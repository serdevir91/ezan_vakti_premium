import 'package:package_info_plus/package_info_plus.dart';

class AppVersionInfo {
  final String version;
  final String buildNumber;
  final bool isLatest;
  final String releaseNotes;

  AppVersionInfo({
    required this.version,
    required this.buildNumber,
    required this.isLatest,
    required this.releaseNotes,
  });
}

class UpdateService {
  /// Fetches local app package info and simulates a non-blocking background check
  Future<AppVersionInfo> checkAppUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return AppVersionInfo(
        version: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
        isLatest: true,
        releaseNotes: "• Yenilenmiş Workout-Tracker İlerleme Dashboard'u\n• Tam Offline Kur'an-ı Kerim ve Mealleri\n• Akıllı Kıble Pusulası ve Haptik Geri Bildirim\n• Otomatik RTL ve Çok Dilli Destek (TR, EN, AR, FA)",
      );
    } catch (_) {
      return AppVersionInfo(
        version: "1.0.0",
        buildNumber: "1",
        isLatest: true,
        releaseNotes: "Ezan Vakti Premium Kararlı Sürüm",
      );
    }
  }
}
