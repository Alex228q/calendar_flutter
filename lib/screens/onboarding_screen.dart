import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart'; // для appOverlayStyle
import '../onboarding_manager.dart';
import 'home_screen.dart';

const Color _bgColor = Color.fromARGB(255, 26, 26, 26);
const Color _accent = Color.fromARGB(255, 66, 211, 146);
const Color _textMain = Color.fromARGB(255, 230, 230, 230);
const Color _textSecondary = Color.fromARGB(255, 170, 170, 170);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  late final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      visual: const _ShiftLegend(),
      title: 'Ваш график смен',
      text: 'Цветная полоска под датой показывает смену. '
          'Свою бригаду выберите кнопками 1–5 внизу экрана.',
    ),
    const _OnboardingPage(
      visual: _BigIcon(Icons.swipe),
      title: 'Листайте месяцы',
      text: 'Свайп влево и вправо переключает месяцы. '
          'Значок календаря сверху открывает выбор месяца и года, '
          'а кнопка с датой возвращает к сегодняшнему дню.',
    ),
    const _OnboardingPage(
      visual: _BigIcon(
        Icons.star_rounded,
        color: Color.fromARGB(255, 255, 193, 7),
      ),
      title: 'Отметки событий',
      text: 'Дважды нажмите на дату, чтобы поставить звёздочку, '
          'и ещё раз, чтобы убрать. Отметки сохраняются на телефоне, '
          'а старше двух лет удаляются сами.',
    ),
  ];

  bool get _isLast => _page == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await OnboardingManager().setSeen();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  void _next() {
    if (_isLast) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appOverlayStyle,
      child: Scaffold(
        backgroundColor: _bgColor,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 48,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isLast ? 0 : 1,
                    child: TextButton(
                      onPressed: _isLast ? null : _finish,
                      child: const Text(
                        'Пропустить',
                        style: TextStyle(color: _textSecondary, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _page = i),
                  children: _pages,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  final active = i == _page;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: active ? 24 : 8,
                    decoration: BoxDecoration(
                      color: active ? _accent : const Color(0xFF444444),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      _isLast ? 'Начать' : 'Далее',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.visual,
    required this.title,
    required this.text,
  });

  final Widget visual;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          visual,
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: _textMain,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              height: 1.4,
              color: _textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BigIcon extends StatelessWidget {
  const _BigIcon(this.icon, {this.color = _accent});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.12),
      ),
      child: Icon(icon, size: 60, color: color),
    );
  }
}

/// Легенда цветов смен (те же цвета, что и в календаре).
class _ShiftLegend extends StatelessWidget {
  const _ShiftLegend();

  Widget _row(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _textMain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF242424),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row(const Color.fromARGB(255, 24, 226, 31), 'День'),
          _row(const Color.fromARGB(255, 9, 126, 221), 'Вечер'),
          _row(const Color.fromARGB(255, 226, 28, 14), 'Ночь'),
        ],
      ),
    );
  }
}
