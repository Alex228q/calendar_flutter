import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calendar/events_manager.dart';

class Month extends StatelessWidget {
  const Month({
    super.key,
    required this.currentMonth,
    required this.crew,
    required this.compareCrew,
    required this.lastCompareCrew,
    required this.events,
    required this.onToggleEvent,
  });

  final DateTime currentMonth;
  final int crew;
  final int? compareCrew;
  final int? lastCompareCrew;
  final Set<String> events;
  final void Function(DateTime date) onToggleEvent;

  static const double _outsideOpacity = 0.35;

  /// График цикличный (период 10 дней), поэтому цвет считаем арифметикой.
  /// День: 0–1, вечер: 2–3, ночь: 6–7; каждая бригада сдвинута на 2 дня.
  Color _shiftColor(DateTime date, int crewNumber) {
    final diff = DateTime.utc(date.year, date.month, date.day)
        .difference(DateTime.utc(2024, 3, 1))
        .inDays;
    final k = (diff - 2 * (crewNumber - 1)) % 10;
    if (k == 0 || k == 1) return const Color.fromARGB(255, 24, 226, 31); // день
    if (k == 2 || k == 3) {
      return const Color.fromARGB(255, 9, 126, 221); // вечер
    }
    if (k == 6 || k == 7) return const Color.fromARGB(255, 226, 28, 14); // ночь
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final emptyCells = firstDayOfMonth.weekday - 1;
    final totalCells = ((daysInMonth + emptyCells + 6) ~/ 7) * 7;

    final now = DateTime.now();
    // Пока уголок гаснет, красим его цветом последней сравниваемой бригады
    final compare = compareCrew ?? lastCompareCrew ?? crew;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, mainAxisSpacing: 8),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final date = DateTime(
            currentMonth.year, currentMonth.month, index - emptyCells + 1);
        final isOutside = date.month != currentMonth.month;

        final isCurrentDate = date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
        final hasEvent = events.contains(EventsManager.keyOf(date));

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
              child: Opacity(
                opacity: isOutside ? _outsideOpacity : 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Text(
                          date.day.toString(),
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
                    // Основная полоска. Уголок второй бригады привязан
                    // к ней, поэтому нижняя часть всегда на одной высоте.
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 4,
                          width: 16,
                          decoration: BoxDecoration(
                            color: _shiftColor(date, crew),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        Positioned(
                          left: 16 + CornerPainter.gap,
                          // центр нижней линии уголка = центр полоски
                          bottom: (4 - CornerPainter.stroke) / 2,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: compareCrew == null ? 0 : 1,
                            child: CustomPaint(
                              size: CornerPainter.size,
                              painter:
                                  CornerPainter(_shiftColor(date, compare)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Уголок с закруглением справа от основной полоски:
/// вертикаль вверх, поворот и короткая горизонталь внизу.
/// Публичный, чтобы его можно было использовать в онбординге.
class CornerPainter extends CustomPainter {
  CornerPainter(this.color);

  final Color color;

  static const double stroke = 3.5; // толщина линии
  static const double gap = 4; // зазор до основной полоски
  static const double _radius = 6;
  static const Size size = Size(_radius + stroke / 2, 16); // ширина, высота

  @override
  void paint(Canvas canvas, Size s) {
    if (color == Colors.transparent) return;

    final x = s.width - stroke / 2;
    final y = s.height - stroke / 2;

    final path = Path()
      ..moveTo(x, 0)
      ..lineTo(x, y - _radius)
      ..arcToPoint(
        Offset(x - _radius, y),
        radius: const Radius.circular(_radius),
        clockwise: true,
      );

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(CornerPainter old) => old.color != color;
}
