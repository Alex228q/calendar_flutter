import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMonthYearPicker extends StatefulWidget {
  final DateTime initialDate;
  final int firstYear;
  final int yearCount;
  final Function(DateTime) onDateChanged;

  const CustomMonthYearPicker({
    super.key,
    required this.initialDate,
    required this.firstYear,
    required this.yearCount,
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
    // Отступ под системную панель навигации (кнопки домой/назад/меню),
    // чтобы она не перекрывала кнопку «ВЫБРАТЬ».
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: 8 + bottomInset),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Color.fromARGB(255, 66, 211, 146),
      ),
      height: 250 + bottomInset,
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
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedDate.year - widget.firstYear,
                    ),
                    itemExtent: 40,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        selectedDate = DateTime(
                            widget.firstYear + index, selectedDate.month);
                      });
                    },
                    children: List<Widget>.generate(widget.yearCount, (index) {
                      return Center(
                        child: Text(
                          (widget.firstYear + index).toString(),
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
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
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
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
