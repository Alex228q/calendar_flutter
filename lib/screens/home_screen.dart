import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendar/widgets/button_bloc.dart';
import 'package:calendar/widgets/days_of_week.dart';
import 'package:calendar/widgets/month.dart';
import 'package:calendar/widgets/month_year.dart';
import 'package:intl/intl.dart';

import '../crew_manager.dart';
import '../widgets/custom_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _crew = 2;
  DateTime currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadCrew();
  }

  Future<void> _selectDate(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CustomMonthYearPicker(
          initialDate: currentMonth,
          onDateChanged: (DateTime newDate) {
            setState(() {
              currentMonth = newDate;
            });
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

  void _updateCrew(int newCrew) {
    _crew = newCrew;
    CrewManager().saveCrew(newCrew);
  }

  void _plusMonth() {
    setState(() {
      currentMonth =
          DateTime(currentMonth.year, currentMonth.month + 1, currentMonth.day);
    });
  }

  void _minusMonth() {
    setState(() {
      currentMonth =
          DateTime(currentMonth.year, currentMonth.month - 1, currentMonth.day);
    });
  }

  void _changeCrew(int numberOfCrew) {
    setState(() {
      _crew = numberOfCrew;
    });
    _updateCrew(numberOfCrew);
  }

  void _handleSwipe(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dx > 0) {
      _minusMonth();
    } else if (details.velocity.pixelsPerSecond.dx < 0) {
      _plusMonth();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 26, 26),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
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
            const SizedBox(
              height: 12,
            ),
            const DaysOfWeek(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: SizedBox(
                height: 380,
                child: GestureDetector(
                  onHorizontalDragEnd: _handleSwipe,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Month(
                      currentMonth: currentMonth,
                      crew: _crew,
                      key: ValueKey(currentMonth),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedOpacity(
                    opacity: currentMonth.year == DateTime.now().year &&
                            currentMonth.month == DateTime.now().month
                        ? 0
                        : 1,
                    duration: const Duration(milliseconds: 700),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentMonth = DateTime.now();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color.fromARGB(255, 68, 206, 153),
                            width: 3,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 10),
                          child: Text(
                            DateFormat('dd.MM.yyyy').format(DateTime.now()),
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
                ],
              ),
            ),
            const Spacer(),
            ButtonBloc(
              crew: _crew,
              onChangeCrew: _changeCrew,
            ),
            const SizedBox(
              height: 46,
            )
          ],
        ),
      ),
    );
  }
}
