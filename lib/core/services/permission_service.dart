import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PermissionService {
  static Future<void> requestInitialPermissions() async {
    // 1. Location Permission
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          await Geolocator.requestPermission();
        }
      }
    } catch (_) {}

    // 2. Notification Permission
    try {
      final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();
      final androidImplementation = notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
    } catch (_) {}
  }
}
