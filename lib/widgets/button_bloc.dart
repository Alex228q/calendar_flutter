import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ButtonBloc extends StatelessWidget {
  const ButtonBloc({super.key, required this.crew, required this.onChangeCrew});

  final int crew;
  final Function(int index) onChangeCrew;

  static const _accent = Color.fromARGB(255, 66, 211, 146);
  static const int _count = 5;

  // Высота всей полосы и внутренний отступ. Высота «таблетки» = _height - 2 * _padding.
  static const double _height = 52;
  static const double _padding = 4;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        height: _height,
        padding: const EdgeInsets.all(_padding),
        decoration: BoxDecoration(
          color: const Color(0xFF242424),
          borderRadius: BorderRadius.circular(_height / 2),
        ),
        child: Stack(
          children: [
            // Скользящая «таблетка» выбранной бригады
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              alignment: Alignment(-1 + (crew - 1) * 2 / (_count - 1), 0),
              child: FractionallySizedBox(
                widthFactor: 1 / _count,
                heightFactor: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius:
                        BorderRadius.circular((_height - 2 * _padding) / 2),
                  ),
                ),
              ),
            ),
            Row(
              children: List.generate(_count, (i) {
                final number = i + 1;
                final isChosen = number == crew;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (!isChosen) HapticFeedback.selectionClick();
                      onChangeCrew(number);
                    },
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isChosen
                              ? Colors.black
                              : const Color.fromARGB(255, 170, 170, 170),
                        ),
                        child: Text(number.toString()),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
