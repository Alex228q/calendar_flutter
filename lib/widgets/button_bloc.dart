import 'package:flutter/material.dart';

class ButtonBloc extends StatelessWidget {
  const ButtonBloc({super.key, required this.crew, required this.onChangeCrew});

  final int crew;
  final Function(int index) onChangeCrew;

  @override
  Widget build(BuildContext context) {
    List<int> buttonNumbers = [1, 2, 3, 4, 5];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttonNumbers.map((number) {
        final isChosen = number == crew;
        return ElevatedButton(
          onPressed: () {
            onChangeCrew(number);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isChosen
                ? const Color.fromRGBO(66, 211, 146, 1)
                : const Color.fromARGB(255, 26, 26, 26),
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
          ),
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isChosen ? Colors.black : Colors.white,
            ),
          ),
        );
      }).toList(),
    );
  }
}
