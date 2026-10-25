import 'package:shared_preferences/shared_preferences.dart';

/// Хранит даты с отметкой-событием в формате 'yyyy-MM-dd'.
class EventsManager {
  static const String eventsKey = 'events_key';

  /// Ключ даты. Строки с нулями слева сравниваются как даты.
  static String keyOf(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  /// Загружает события и удаляет те, что старше [oldest]
  /// (то есть вышли за пределы диапазона календаря).
  Future<Set<String>> loadEvents({required DateTime oldest}) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(eventsKey) ?? <String>[];
    final oldestKey = keyOf(oldest);
    final actual = stored.where((k) => k.compareTo(oldestKey) >= 0).toSet();
    if (actual.length != stored.length) {
      await prefs.setStringList(eventsKey, actual.toList());
    }
    return actual;
  }

  Future<void> saveEvents(Set<String> events) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(eventsKey, events.toList());
  }
}
