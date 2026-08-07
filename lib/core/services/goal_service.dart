import 'package:shared_preferences/shared_preferences.dart';

class MonthlyGoals {
  final int monthlyZikrTarget;
  final int monthlyQuranPagesTarget;
  final int monthlyFastingDaysTarget;
  final List<String> enabledTasks; // Default 5 prayers

  MonthlyGoals({
    required this.monthlyZikrTarget,
    required this.monthlyQuranPagesTarget,
    required this.monthlyFastingDaysTarget,
    required this.enabledTasks,
  });

  MonthlyGoals copyWith({
    int? monthlyZikrTarget,
    int? monthlyQuranPagesTarget,
    int? monthlyFastingDaysTarget,
    List<String>? enabledTasks,
  }) {
    return MonthlyGoals(
      monthlyZikrTarget: monthlyZikrTarget ?? this.monthlyZikrTarget,
      monthlyQuranPagesTarget: monthlyQuranPagesTarget ?? this.monthlyQuranPagesTarget,
      monthlyFastingDaysTarget: monthlyFastingDaysTarget ?? this.monthlyFastingDaysTarget,
      enabledTasks: enabledTasks ?? this.enabledTasks,
    );
  }
}

class GoalService {
  static const String _monthlyZikrKey = 'target_monthly_zikr';
  static const String _monthlyQuranPagesKey = 'target_monthly_quran_pages';
  static const String _monthlyFastingKey = 'target_monthly_fasting';

  static const List<String> defaultPrayers = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];

  Future<MonthlyGoals> loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    return MonthlyGoals(
      monthlyZikrTarget: prefs.getInt(_monthlyZikrKey) ?? 10000,
      monthlyQuranPagesTarget: prefs.getInt(_monthlyQuranPagesKey) ?? 100,
      monthlyFastingDaysTarget: prefs.getInt(_monthlyFastingKey) ?? 4,
      enabledTasks: defaultPrayers,
    );
  }

  Future<void> saveGoals(MonthlyGoals goals) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_monthlyZikrKey, goals.monthlyZikrTarget);
    await prefs.setInt(_monthlyQuranPagesKey, goals.monthlyQuranPagesTarget);
    await prefs.setInt(_monthlyFastingKey, goals.monthlyFastingDaysTarget);
  }
}
