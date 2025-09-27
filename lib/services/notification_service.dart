import 'dart:math' as Importance;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final androidDetails = AndroidNotificationDetails('notes_channel', 'Notes',
        channelDescription: 'Notes reminders',
        importance: Importance.max,
        priority: Priority.high);
    final notificationDetails = NotificationDetails(android: androidDetails);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

class FlutterLocalNotificationsPlugin {
  Future<void> zonedSchedule(int id, String title, String body, DateTime scheduledTime, NotificationDetails notificationDetails, {required bool androidAllowWhileIdle, required uiLocalNotificationDateInterpretation}) async {}
  
  Future<void> initialize(InitializationSettings settings) async {}
}

class AndroidInitializationSettings {
  const AndroidInitializationSettings(String s);
}

class InitializationSettings {
  const InitializationSettings({required AndroidInitializationSettings android});
}

class Priority {
  static get high => null;
}

class AndroidNotificationDetails {
  const AndroidNotificationDetails(String s, String , {required String channelDescription, required importance, required priority});
}

class NotificationDetails {
  const NotificationDetails({required android});
}

class UILocalNotificationDateInterpretation {
  static get absoluteTime => null;
}
