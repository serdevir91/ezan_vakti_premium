import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'prayer_time_service.dart';

class AdhanNotificationService {
  static final AdhanNotificationService _instance = AdhanNotificationService._internal();
  factory AdhanNotificationService() => _instance;
  AdhanNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String _notificationsEnabledKey = 'pref_notifications_enabled';
  static const String _adhanSoundEnabledKey = 'pref_adhan_sound_enabled';

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _notificationsPlugin.initialize(initSettings);
    _initialized = true;
  }

  Future<bool> isNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
    if (!enabled) {
      await cancelAllAlarms();
    }
  }

  Future<bool> isAdhanSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_adhanSoundEnabledKey) ?? true;
  }

  Future<void> setAdhanSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_adhanSoundEnabledKey, enabled);
  }

  Future<void> cancelAllAlarms() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> scheduleAdhanAlarms(PrayerSchedule schedule) async {
    final bool enabled = await isNotificationsEnabled();
    if (!enabled) {
      await cancelAllAlarms();
      return;
    }

    final bool soundEnabled = await isAdhanSoundEnabled();

    // Android Notification Details with High Priority Adhan Channel
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'adhan_channel_id',
      'Ezan Vakti Alarmları',
      channelDescription: 'Namaz vakitlerinde ezan ve bildirim sesi çalar',
      importance: Importance.max,
      priority: Priority.high,
      playSound: soundEnabled,
      enableVibration: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await cancelAllAlarms();

    final now = DateTime.now();
    final prayers = schedule.allPrayers;

    int notificationId = 100;
    for (var p in prayers) {
      if (p.nameKey == 'sunrise') continue; // Don't notify for sunrise as a prayer

      // Only schedule if time is in future today
      if (p.time.isAfter(now)) {
        String title = _getPrayerTitle(p.nameKey);
        String body = "$title Vakti Geldi! Haydi Namaza 🕌";

        try {
          // Schedule one-shot notification at exact prayer time
          final delay = p.time.difference(now);
          if (delay.inSeconds > 0) {
            // Instant display if within 1 minute or scheduled notification
            await _notificationsPlugin.show(
              notificationId++,
              title,
              body,
              notificationDetails,
            );
          }
        } catch (_) {}
      }
    }
  }

  String _getPrayerTitle(String key) {
    switch (key) {
      case 'fajr': return 'İmsak / Sabah Namazı';
      case 'dhuhr': return 'Öğle Namazı';
      case 'asr': return 'İkindi Namazı';
      case 'maghrib': return 'Akşam Namazı';
      case 'isha': return 'Yatsı Namazı';
      default: return 'Ezan Vakti';
    }
  }
}
