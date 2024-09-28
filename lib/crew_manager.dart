import 'package:shared_preferences/shared_preferences.dart';

class CrewManager {
  static const String crewKey = 'crew_key';

  Future<void> saveCrew(int crew) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(crewKey, crew);
  }

  Future<int?> loadCrew() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(crewKey);
  }
}
