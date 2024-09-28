import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calendar/work_shift.dart';

class Month extends StatelessWidget {
  const Month({super.key, required this.currentMonth, required this.crew});
  final DateTime currentMonth;
  final int crew;
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

    final days = WorkShifts(numberOfTeam: crew).getDays();
    final evening = WorkShifts(numberOfTeam: crew).getEvening();
    final night = WorkShifts(numberOfTeam: crew).getNight();

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
          Color backgroundColor = Colors.transparent;
          if (days.contains(DateFormat('dd.MM.yyyy').format(date))) {
            backgroundColor = const Color.fromARGB(255, 24, 226, 31);
          } else if (evening.contains(DateFormat('dd.MM.yyyy').format(date))) {
            backgroundColor = const Color.fromARGB(255, 9, 126, 221);
          } else if (night.contains(DateFormat('dd.MM.yyyy').format(date))) {
            backgroundColor = const Color.fromARGB(255, 226, 28, 14);
          }

          return Container(
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
                  Text(
                    day.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 230, 230, 230),
                    ),
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
          );
        }
      },
    );
  }
}
