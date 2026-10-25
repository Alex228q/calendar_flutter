import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calendar/events_manager.dart';

class Month extends StatelessWidget {
  const Month({
    super.key,
    required this.currentMonth,
    required this.crew,
    required this.events,
    required this.onToggleEvent,
  });

  final DateTime currentMonth;
  final int crew;
  final Set<String> events;
  final void Function(DateTime date) onToggleEvent;

  /// График цикличный (период 10 дней), поэтому цвет считаем арифметикой.
  /// День: 0–1, вечер: 2–3, ночь: 6–7; каждая бригада сдвинута на 2 дня.
  Color _shiftColor(DateTime date) {
    final diff = DateTime.utc(date.year, date.month, date.day)
        .difference(DateTime.utc(2024, 3, 1))
        .inDays;
    final k = (diff - 2 * (crew - 1)) % 10; // в Dart результат всегда >= 0
    if (k == 0 || k == 1) return const Color.fromARGB(255, 24, 226, 31); // день
    if (k == 2 || k == 3)
      return const Color.fromARGB(255, 9, 126, 221); // вечер
    if (k == 6 || k == 7) return const Color.fromARGB(255, 226, 28, 14); // ночь
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    DateTime firstDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month, 1);
    DateTime nextMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
    DateTime lastDayOfMonth = nextMonth.subtract(const Duration(days: 1));
    int daysInMonth = lastDayOfMonth.day;
    int emptyCells = firstDayOfMonth.weekday - 1;
    int totalCells = daysInMonth + emptyCells;

    DateTime now = DateTime.now();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, mainAxisSpacing: 8),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        if (index < emptyCells) {
          return const Center(child: Text(''));
        } else {
          int day = index - emptyCells + 1;
          DateTime date = DateTime(currentMonth.year, currentMonth.month, day);

          bool isCurrentDate = date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
          bool hasEvent = events.contains(EventsManager.keyOf(date));
          Color backgroundColor = _shiftColor(date);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: () {
              HapticFeedback.lightImpact();
              onToggleEvent(date);
            },
            child: Container(
              decoration: isCurrentDate
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color.fromARGB(255, 68, 206, 153),
                          width: 3),
                    )
                  : null,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Звёздочка привязана к самому числу, а не к ячейке,
                    // поэтому расстояние до цифры всегда одинаковое.
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Text(
                          day.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 230, 230, 230),
                          ),
                        ),
                        if (hasEvent)
                          const Positioned(
                            top: -5,
                            right: -9,
                            child: Icon(
                              Icons.star_rounded,
                              size: 13,
                              color: Color.fromARGB(255, 255, 193, 7),
                            ),
                          ),
                      ],
                    ),
                    Container(
                      height: 4,
                      width: 16,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
