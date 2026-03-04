import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Top-level callback invoked by AndroidAlarmManager in an isolate.
/// Must be a top-level or static function.
@pragma('vm:entry-point')
Future<void> dailyReminderCallback() async {
  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);
  await plugin.initialize(initSettings);

  const androidDetails = AndroidNotificationDetails(
    'daily_reminder',
    'Daily Reminder',
    channelDescription: 'Daily lunch reminder notification',
    importance: Importance.high,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
  );

  const notificationDetails = NotificationDetails(android: androidDetails);

  await plugin.show(
    Random().nextInt(100000),
    'Waktunya Makan Siang! 🍽️',
    'Yuk, lihat rekomendasi restoran favoritmu hari ini!',
    notificationDetails,
  );
}

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _alarmId = 1;

  /// Initialize flutter_local_notifications plugin.
  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(initSettings);
  }

  /// Request notification & exact alarm permissions on Android.
  static Future<void> requestPermissions() async {
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl != null) {
      await androidImpl.requestNotificationsPermission();
      await androidImpl.requestExactAlarmsPermission();
    }
  }

  /// Schedule a daily notification at 11:00 AM using AndroidAlarmManager.
  static Future<void> scheduleDailyElevenAMNotification() async {
    // Calculate how long until the next 11:00 AM
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, 11, 0);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await AndroidAlarmManager.periodic(
      const Duration(hours: 24),
      _alarmId,
      dailyReminderCallback,
      startAt: scheduledDate,
      exact: true,
      wakeup: true,
    );
  }

  /// Cancel the daily reminder alarm.
  static Future<void> cancelDailyReminder() async {
    await AndroidAlarmManager.cancel(_alarmId);
  }

  /// Show a test notification immediately.
  static Future<void> showTestNotification() async {
    await requestPermissions();

    const androidDetails = AndroidNotificationDetails(
      'daily_reminder',
      'Daily Reminder',
      channelDescription: 'Daily lunch reminder notification',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      'Waktunya Makan Siang! \u{1F37D}\u{FE0F}',
      'Yuk, lihat rekomendasi restoran favoritmu hari ini!',
      notificationDetails,
    );
  }
}
