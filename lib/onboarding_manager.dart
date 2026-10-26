import 'package:shared_preferences/shared_preferences.dart';

/// Запоминает, что приветственные экраны уже показаны.
class OnboardingManager {
  static const String seenKey = 'onboarding_seen';

  Future<bool> isSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(seenKey) ?? false;
  }

  Future<void> setSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(seenKey, true);
  }
}
