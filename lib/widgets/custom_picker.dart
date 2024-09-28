import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMonthYearPicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateChanged;

  const CustomMonthYearPicker({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
  });

  @override
  CustomMonthYearPickerState createState() => CustomMonthYearPickerState();
}

class CustomMonthYearPickerState extends State<CustomMonthYearPicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Color.fromARGB(255, 66, 211, 146),
      ),
      height: 250,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedDate.month - 1,
                    ),
                    itemExtent: 40,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        selectedDate = DateTime(selectedDate.year, index + 1);
                      });
                    },
                    children: List<Widget>.generate(12, (index) {
                      return Center(
                        child: Text(
                          getMonthInRussian(index + 1),
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedDate.year - 2024,
                    ),
                    itemExtent: 40,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        selectedDate =
                            DateTime(2024 + index, selectedDate.month);
                      });
                    },
                    children: List<Widget>.generate(33, (index) {
                      return Center(
                        child: Text(
                          (2024 + index).toString(),
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          CupertinoButton(
            child: const Text(
              'ВЫБРАТЬ',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              widget.onDateChanged(selectedDate);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  String getMonthInRussian(int month) {
    const months = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь'
    ];
    return months[month - 1];
  }
}
