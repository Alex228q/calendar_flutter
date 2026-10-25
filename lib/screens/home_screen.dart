import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calendar/widgets/button_bloc.dart';
import 'package:calendar/widgets/days_of_week.dart';
import 'package:calendar/widgets/month.dart';
import 'package:calendar/widgets/month_year.dart';
import 'package:intl/intl.dart';

import '../crew_manager.dart';
import '../events_manager.dart';
import '../main.dart'; // для appOverlayStyle
import '../widgets/custom_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int _yearsBack = 2;
  static const int _yearsForward = 10;
  static const int _monthsBack = _yearsBack * 12;
  static const int _pageCount = _monthsBack + _yearsForward * 12 + 1;

  int _crew = 2;
  Set<String> _events = {};

  late final DateTime _baseMonth; // первое число текущего месяца
  late final PageController _pageController;
  late DateTime currentMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _baseMonth = DateTime(now.year, now.month);
    currentMonth = _baseMonth;
    _pageController = PageController(initialPage: _monthsBack);
    _loadCrew();
    _loadEvents();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _monthForPage(int page) =>
      DateTime(_baseMonth.year, _baseMonth.month + page - _monthsBack);

  int _pageForMonth(DateTime month) {
    final page = (month.year - _baseMonth.year) * 12 +
        (month.month - _baseMonth.month) +
        _monthsBack;
    return page.clamp(0, _pageCount - 1);
  }

  Future<void> _selectDate(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CustomMonthYearPicker(
          initialDate: currentMonth,
          firstYear: _baseMonth.year - _yearsBack,
          yearCount: _yearsBack + _yearsForward + 1,
          onDateChanged: (DateTime newDate) {
            // currentMonth обновится сам через onPageChanged
            _pageController.jumpToPage(_pageForMonth(newDate));
          },
        );
      },
    );
  }

  Future<void> _loadCrew() async {
    int? crew = await CrewManager().loadCrew();
    if (crew != null) {
      setState(() {
        _crew = crew;
      });
    }
  }

  Future<void> _loadEvents() async {
    // Самый ранний месяц диапазона. Всё, что старше, удаляется из памяти.
    final oldest = DateTime(_baseMonth.year - _yearsBack, _baseMonth.month, 1);
    final events = await EventsManager().loadEvents(oldest: oldest);
    if (!mounted) return;
    setState(() {
      _events = events;
    });
  }

  void _toggleEvent(DateTime date) {
    final key = EventsManager.keyOf(date);
    final updated = Set<String>.from(_events);
    if (!updated.remove(key)) {
      updated.add(key);
    }
    setState(() {
      _events = updated;
    });
    EventsManager().saveEvents(updated);
  }

  void _changeCrew(int numberOfCrew) {
    setState(() {
      _crew = numberOfCrew;
    });
    CrewManager().saveCrew(numberOfCrew);
  }

  void _goToToday() {
    _pageController.jumpToPage(_monthsBack);
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentMonth = currentMonth.year == _baseMonth.year &&
        currentMonth.month == _baseMonth.month;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appOverlayStyle,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 26, 26, 26),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              MonthYear(
                currentMonth: currentMonth,
                onClickPicker: _selectDate,
              ),
              const Divider(
                indent: 12,
                endIndent: 12,
                thickness: 2,
                color: Color.fromARGB(255, 66, 211, 146),
              ),
              const SizedBox(height: 12),
              const DaysOfWeek(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: SizedBox(
                  height: 380,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pageCount,
                    onPageChanged: (page) {
                      setState(() {
                        currentMonth = _monthForPage(page);
                      });
                    },
                    itemBuilder: (context, page) {
                      return Month(
                        currentMonth: _monthForPage(page),
                        crew: _crew,
                        events: _events,
                        onToggleEvent: _toggleEvent,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 700),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: isCurrentMonth
                        ? const SizedBox.shrink()
                        : GestureDetector(
                            key: const ValueKey('date_button'),
                            onTap: _goToToday,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 68, 206, 153),
                                  width: 3,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                child: Text(
                                  DateFormat('dd.MM.yyyy')
                                      .format(DateTime.now()),
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 230, 230, 230),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const Spacer(),
              ButtonBloc(crew: _crew, onChangeCrew: _changeCrew),
              const SizedBox(height: 46),
            ],
          ),
        ),
      ),
    );
  }
}
