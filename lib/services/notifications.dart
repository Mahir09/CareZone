import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications with ChangeNotifier {
  var flutterLocalNotificationsPlugin;

  Notifications() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    initNotifications();
  }

  getNotificationInstance() {
    return flutterLocalNotificationsPlugin;
  }

  void initNotifications() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void showNotificationDaily(
      int id, String title, String body, int hour, int minute) async {
    var time = new Time(hour, minute, 0);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id, title, body, time, getPlatformChannelSpecfics());
    print('Notification Successfully Scheduled at ${time.toString()}');
    notifyListeners();
  }

  getPlatformChannelSpecfics() {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'Medicine Reminder');
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }

  Future onSelectNotification(String payload) async {
    print('Notification clicked');
    return Future.value(0);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return Future.value(1);
  }

  void removeReminder(int notificationId) {
    flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
