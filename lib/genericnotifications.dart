import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class GenericNotifications {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static List<dynamic> bookingStopsAll = [];
  static initNotifications() {
    _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        ),
        iOS: DarwinInitializationSettings(),
        // iOS: IOSInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (n) async {
        if (kDebugMode) {
          print(
            "RECEIVED FOREGROUND RESPONSE :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::${n.payload}");
        }
      },
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    print("ID:::::::::::::::::::::::::::::::::::::::::::::::::::::::$id:");
    // _notifications.initialize()
    _notifications.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  static void cancelAllNotifications() {
    _notifications.cancelAll();
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
        visibility: NotificationVisibility.public,
        priority: Priority.high,
        fullScreenIntent: true,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            'accept_action',
            'Close',
            titleColor: Colors.red,
            cancelNotification:true,
          ),
          AndroidNotificationAction(
            'reject_action',
            'Open',
            titleColor: Colors.green,
            showsUserInterface:true,
          ),
        ],
      ),
      iOS: DarwinNotificationDetails(),
    );
  }
}