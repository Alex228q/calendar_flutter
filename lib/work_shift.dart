import 'package:intl/intl.dart';

class WorkShifts {
  final int numberOfTeam;

  WorkShifts({required this.numberOfTeam}) {
    if (numberOfTeam < 1 || numberOfTeam > 5) {
      throw Exception("bad team");
    }
  }

  DateTime get teamDay1 {
    switch (numberOfTeam) {
      case 1:
        return DateTime(2024, 3, 1);
      case 2:
        return DateTime(2024, 3, 3);
      case 3:
        return DateTime(2024, 3, 5);
      case 4:
        return DateTime(2024, 3, 7);
      case 5:
        return DateTime(2024, 3, 9);
      default:
        throw Exception("bad team");
    }
  }

  DateTime get teamDay2 {
    switch (numberOfTeam) {
      case 1:
        return DateTime(2024, 3, 2);
      case 2:
        return DateTime(2024, 3, 4);
      case 3:
        return DateTime(2024, 3, 6);
      case 4:
        return DateTime(2024, 3, 8);
      case 5:
        return DateTime(2024, 3, 10);
      default:
        throw Exception("bad team");
    }
  }

  DateTime get teamEvening1 {
    switch (numberOfTeam) {
      case 1:
        return DateTime(2024, 3, 3);
      case 2:
        return DateTime(2024, 3, 5);
      case 3:
        return DateTime(2024, 3, 7);
      case 4:
        return DateTime(2024, 3, 9);
      case 5:
        return DateTime(2024, 3, 11);
      default:
        throw Exception("bad team");
    }
  }

  DateTime get teamEvening2 {
    switch (numberOfTeam) {
      case 1:
        return DateTime(2024, 3, 4);
      case 2:
        return DateTime(2024, 3, 6);
      case 3:
        return DateTime(2024, 3, 8);
      case 4:
        return DateTime(2024, 3, 10);
      case 5:
        return DateTime(2024, 3, 12);
      default:
        throw Exception("bad team");
    }
  }

  DateTime get teamNight1 {
    switch (numberOfTeam) {
      case 1:
        return DateTime(2024, 3, 7);
      case 2:
        return DateTime(2024, 3, 9);
      case 3:
        return DateTime(2024, 3, 11);
      case 4:
        return DateTime(2024, 3, 13);
      case 5:
        return DateTime(2024, 3, 15);
      default:
        throw Exception("bad team");
    }
  }

  DateTime get teamNight2 {
    switch (numberOfTeam) {
      case 1:
        return DateTime(2024, 3, 8);
      case 2:
        return DateTime(2024, 3, 10);
      case 3:
        return DateTime(2024, 3, 12);
      case 4:
        return DateTime(2024, 3, 14);
      case 5:
        return DateTime(2024, 3, 16);
      default:
        throw Exception("bad team");
    }
  }

  List<String> getDays() {
    DateTime firstDay = teamDay1;
    DateTime secondDay = teamDay2;
    List<String> days = [];
    for (int i = 0; i < 1200; i++) {
      days.add(DateFormat('dd.MM.yyyy').format(firstDay));
      days.add(DateFormat('dd.MM.yyyy').format(secondDay));
      firstDay = firstDay.add(const Duration(days: 10));
      secondDay = secondDay.add(const Duration(days: 10));
    }
    return days;
  }

  List<String> getEvening() {
    DateTime firstEvening = teamEvening1;
    DateTime secondEvening = teamEvening2;
    List<String> evening = [];
    for (int i = 0; i < 1200; i++) {
      evening.add(DateFormat('dd.MM.yyyy').format(firstEvening));
      evening.add(DateFormat('dd.MM.yyyy').format(secondEvening));
      firstEvening = firstEvening.add(const Duration(days: 10));
      secondEvening = secondEvening.add(const Duration(days: 10));
    }
    return evening;
  }

  List<String> getNight() {
    DateTime firstNight = teamNight1;
    DateTime secondNight = teamNight2;
    List<String> night = [];
    for (int i = 0; i < 1200; i++) {
      night.add(DateFormat('dd.MM.yyyy').format(firstNight));
      night.add(DateFormat('dd.MM.yyyy').format(secondNight));
      firstNight = firstNight.add(const Duration(days: 10));
      secondNight = secondNight.add(const Duration(days: 10));
    }
    return night;
  }
}
