import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ButtonBloc extends StatelessWidget {
  const ButtonBloc({
    super.key,
    required this.crew,
    required this.onChangeCrew,
    required this.compareCrew,
    required this.onCompareStart,
    required this.onCompareEnd,
  });

  final int crew;
  final Function(int index) onChangeCrew;
  final int? compareCrew; // бригада, которую сейчас удерживаем
  final void Function(int crew) onCompareStart;
  final VoidCallback onCompareEnd;

  static const _accent = Color.fromARGB(255, 66, 211, 146);
  static const int _count = 5;

  static const double _height = 52;
  static const double _padding = 4;

  @override
  Widget build(BuildContext context) {
    const pillRadius = (_height - 2 * _padding) / 2;

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
                    borderRadius: BorderRadius.circular(pillRadius),
                  ),
                ),
              ),
            ),
            Row(
              children: List.generate(_count, (i) {
                final number = i + 1;
                final isChosen = number == crew;
                final isCompared = number == compareCrew;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (!isChosen) HapticFeedback.selectionClick();
                      onChangeCrew(number);
                    },
                    onLongPressStart: (_) {
                      if (isChosen) return;
                      HapticFeedback.mediumImpact();
                      onCompareStart(number);
                    },
                    onLongPressEnd: (_) => onCompareEnd(),
                    onLongPressCancel: onCompareEnd,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(pillRadius),
                        border: Border.all(
                          color: isCompared ? _accent : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isChosen
                              ? Colors.black
                              : isCompared
                                  ? Colors.white
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
