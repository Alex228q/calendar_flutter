import 'package:flutter/material.dart';

class MonthYear extends StatelessWidget {
  const MonthYear(
      {super.key, required this.currentMonth, required this.onClickPicker});

  final DateTime currentMonth;
  final Function(BuildContext context) onClickPicker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text(
            getMonthName(currentMonth.month).toUpperCase(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 230, 230, 230),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            currentMonth.year.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 66, 211, 146),
            ),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                onClickPicker(context);
              },
              icon: const Icon(
                Icons.calendar_month,
                color: Color.fromARGB(255, 66, 211, 146),
                size: 28,
              ))
        ],
      ),
    );
  }
}

String getMonthName(int month) {
  switch (month) {
    case 1:
      return 'Январь';
    case 2:
      return 'Февраль';
    case 3:
      return 'Март';
    case 4:
      return 'Апрель';
    case 5:
      return 'Май';
    case 6:
      return 'Июнь';
    case 7:
      return 'Июль';
    case 8:
      return 'Август';
    case 9:
      return 'Сентябрь';
    case 10:
      return 'Октябрь';
    case 11:
      return 'Ноябрь';
    case 12:
      return 'Декабрь';
    default:
      return '';
  }
}
