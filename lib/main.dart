import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'onboarding_manager.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

const SystemUiOverlayStyle appOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Color.fromARGB(255, 26, 26, 26),
  statusBarIconBrightness: Brightness.light, // Android: светлые иконки
  statusBarBrightness: Brightness.dark, // iOS: светлые иконки
  systemNavigationBarColor: Color.fromARGB(255, 26, 26, 26),
  systemNavigationBarIconBrightness: Brightness.light,
  systemNavigationBarContrastEnforced: false,
  systemStatusBarContrastEnforced: false,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(appOverlayStyle);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // Решаем до запуска, какой экран показывать, чтобы не было мерцания.
  final seen = await OnboardingManager().isSeen();
  runApp(MainApp(showOnboarding: !seen));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.showOnboarding});

  final bool showOnboarding;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: showOnboarding ? const OnboardingScreen() : const HomeScreen(),
    );
  }
}
