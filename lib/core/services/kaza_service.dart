import 'package:shared_preferences/shared_preferences.dart';

class KazaCounts {
  final int fajr;
  final int dhuhr;
  final int asr;
  final int maghrib;
  final int isha;
  final int witr;
  final int fasts;

  KazaCounts({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.witr,
    required this.fasts,
  });

  KazaCounts copyWith({
    int? fajr,
    int? dhuhr,
    int? asr,
    int? maghrib,
    int? isha,
    int? witr,
    int? fasts,
  }) {
    return KazaCounts(
      fajr: fajr ?? this.fajr,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
      witr: witr ?? this.witr,
      fasts: fasts ?? this.fasts,
    );
  }
}

class KazaService {
  static const String _fajrKey = 'kaza_fajr';
  static const String _dhuhrKey = 'kaza_dhuhr';
  static const String _asrKey = 'kaza_asr';
  static const String _maghribKey = 'kaza_maghrib';
  static const String _ishaKey = 'kaza_isha';
  static const String _witrKey = 'kaza_witr';
  static const String _fastsKey = 'kaza_fasts';

  Future<KazaCounts> loadKazaCounts() async {
    final prefs = await SharedPreferences.getInstance();
    return KazaCounts(
      fajr: prefs.getInt(_fajrKey) ?? 12,
      dhuhr: prefs.getInt(_dhuhrKey) ?? 25,
      asr: prefs.getInt(_asrKey) ?? 18,
      maghrib: prefs.getInt(_maghribKey) ?? 8,
      isha: prefs.getInt(_ishaKey) ?? 30,
      witr: prefs.getInt(_witrKey) ?? 14,
      fasts: prefs.getInt(_fastsKey) ?? 5,
    );
  }

  Future<void> saveKazaCounts(KazaCounts counts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_fajrKey, counts.fajr);
    await prefs.setInt(_dhuhrKey, counts.dhuhr);
    await prefs.setInt(_asrKey, counts.asr);
    await prefs.setInt(_maghribKey, counts.maghrib);
    await prefs.setInt(_ishaKey, counts.isha);
    await prefs.setInt(_witrKey, counts.witr);
    await prefs.setInt(_fastsKey, counts.fasts);
  }
}
