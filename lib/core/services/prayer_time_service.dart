import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerTimeModel {
  final String nameKey;
  final DateTime time;
  final bool isNext;

  PrayerTimeModel({
    required this.nameKey,
    required this.time,
    this.isNext = false,
  });
}

class PrayerSchedule {
  final String locationName;
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final PrayerTimeModel nextPrayer;

  PrayerSchedule({
    required this.locationName,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.nextPrayer,
  });

  List<PrayerTimeModel> get allPrayers => [
        PrayerTimeModel(nameKey: 'fajr', time: fajr, isNext: nextPrayer.nameKey == 'fajr'),
        PrayerTimeModel(nameKey: 'sunrise', time: sunrise, isNext: nextPrayer.nameKey == 'sunrise'),
        PrayerTimeModel(nameKey: 'dhuhr', time: dhuhr, isNext: nextPrayer.nameKey == 'dhuhr'),
        PrayerTimeModel(nameKey: 'asr', time: asr, isNext: nextPrayer.nameKey == 'asr'),
        PrayerTimeModel(nameKey: 'maghrib', time: maghrib, isNext: nextPrayer.nameKey == 'maghrib'),
        PrayerTimeModel(nameKey: 'isha', time: isha, isNext: nextPrayer.nameKey == 'isha'),
      ];
}

class PrayerTimeService {
  static const String _latKey = 'user_lat';
  static const String _lngKey = 'user_lng';


  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
    } catch (_) {
      return null;
    }
  }

  Future<PrayerSchedule> getPrayerTimes({double? latitude, double? longitude}) async {
    final prefs = await SharedPreferences.getInstance();

    double lat = latitude ?? prefs.getDouble(_latKey) ?? 41.0082; // Default Istanbul
    double lng = longitude ?? prefs.getDouble(_lngKey) ?? 28.9784;

    if (latitude != null && longitude != null) {
      await prefs.setDouble(_latKey, latitude);
      await prefs.setDouble(_lngKey, longitude);
    }

    final coordinates = Coordinates(lat, lng);
    final dateComponents = DateComponents.from(DateTime.now());

    final calculationParameters = CalculationMethod.turkey.getParameters();
    calculationParameters.madhab = Madhab.hanafi;

    final prayerTimes = PrayerTimes(coordinates, dateComponents, calculationParameters);

    final now = DateTime.now();
    final nextPrayerEnum = prayerTimes.nextPrayer();

    String nextNameKey = 'fajr';
    DateTime nextTime = prayerTimes.fajr;

    switch (nextPrayerEnum) {
      case Prayer.fajr:
        nextNameKey = 'fajr';
        nextTime = prayerTimes.fajr;
        break;
      case Prayer.sunrise:
        nextNameKey = 'sunrise';
        nextTime = prayerTimes.sunrise;
        break;
      case Prayer.dhuhr:
        nextNameKey = 'dhuhr';
        nextTime = prayerTimes.dhuhr;
        break;
      case Prayer.asr:
        nextNameKey = 'asr';
        nextTime = prayerTimes.asr;
        break;
      case Prayer.maghrib:
        nextNameKey = 'maghrib';
        nextTime = prayerTimes.maghrib;
        break;
      case Prayer.isha:
        nextNameKey = 'isha';
        nextTime = prayerTimes.isha;
        break;
      case Prayer.none:
        // Tomorrow's Fajr
        final tomorrowComponents = DateComponents.from(now.add(const Duration(days: 1)));
        final tomorrowPrayerTimes = PrayerTimes(coordinates, tomorrowComponents, calculationParameters);
        nextNameKey = 'fajr';
        nextTime = tomorrowPrayerTimes.fajr;
        break;
    }

    final nextModel = PrayerTimeModel(nameKey: nextNameKey, time: nextTime, isNext: true);

    return PrayerSchedule(
      locationName: (lat == 41.0082 && lng == 28.9784) ? "İstanbul, Türkiye" : "Mevcut Konum",
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
      nextPrayer: nextModel,
    );
  }
}
