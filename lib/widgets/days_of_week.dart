import 'package:flutter/material.dart';

class DaysOfWeek extends StatelessWidget {
  const DaysOfWeek({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6, left: 6, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'].map(
          (day) {
            Color color = const Color.fromARGB(255, 230, 230, 230);
            if (day == 'СБ' || day == 'ВС') {
              color = const Color.fromARGB(255, 215, 47, 35);
            }
            return Text(
              day,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: color),
            );
          },
        ).toList(),
      ),
    );
  }
}
