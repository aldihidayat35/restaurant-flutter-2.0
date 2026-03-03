import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant_flutter/common/notification_helper.dart';

class ReminderProvider extends ChangeNotifier {
  static const String _reminderKey = 'daily_reminder';

  bool _isDailyReminderOn = false;
  bool get isDailyReminderOn => _isDailyReminderOn;

  ReminderProvider() {
    _loadReminder();
  }

  Future<void> _loadReminder() async {
    final prefs = await SharedPreferences.getInstance();
    _isDailyReminderOn = prefs.getBool(_reminderKey) ?? false;

    if (_isDailyReminderOn) {
      await NotificationHelper.scheduleDailyElevenAMNotification();
    }

    notifyListeners();
  }

  Future<void> toggleDailyReminder(bool value) async {
    _isDailyReminderOn = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reminderKey, value);

    if (value) {
      await NotificationHelper.requestPermissions();
      await NotificationHelper.scheduleDailyElevenAMNotification();
    } else {
      await NotificationHelper.cancelDailyReminder();
    }
  }
}
