import 'package:shared_preferences/shared_preferences.dart';

class ZikrModel {
  final String id;
  final String titleTr;
  final String titleAr;
  final int count;
  final int target;

  ZikrModel({
    required this.id,
    required this.titleTr,
    required this.titleAr,
    required this.count,
    required this.target,
  });

  ZikrModel copyWith({int? count, int? target}) {
    return ZikrModel(
      id: id,
      titleTr: titleTr,
      titleAr: titleAr,
      count: count ?? this.count,
      target: target ?? this.target,
    );
  }
}

class TasbihService {
  static const String _currentZikrCountKey = 'current_zikr_count';


  final List<ZikrModel> _presets = [
    ZikrModel(id: 'subhanallah', titleTr: 'Subhanallah', titleAr: 'سُبْحَانَ اللَّهِ', count: 0, target: 33),
    ZikrModel(id: 'alhamdulillah', titleTr: 'Elhamdulillah', titleAr: 'الْحَمْدُ لِلَّهِ', count: 0, target: 33),
    ZikrModel(id: 'allahuakbar', titleTr: 'Allahu Akbar', titleAr: 'اللَّهُ أَكْبَرُ', count: 0, target: 33),
    ZikrModel(id: 'lailahaillallah', titleTr: 'La ilaha illallah', titleAr: 'لَا إِلَٰهَ إِلَّا اللَّهُ', count: 0, target: 100),
    ZikrModel(id: 'astaghfirullah', titleTr: 'Estağfirullah', titleAr: 'أَسْتَغْفِرُ اللَّهَ', count: 0, target: 100),
    ZikrModel(id: 'salawat', titleTr: 'Allahümme Salli Ala Seyyidina Muhammed', titleAr: 'اللَّهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ', count: 0, target: 100),
  ];

  List<ZikrModel> getPresets() => _presets;

  Future<int> loadTodayTotalZikrs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentZikrCountKey) ?? 432;
  }

  Future<void> saveTodayTotalZikrs(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentZikrCountKey, count);
  }
}
