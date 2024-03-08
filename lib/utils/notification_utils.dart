import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtils {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationUtils() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String packageId, {bool isNew = true}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    // Generate a unique notification ID based on the current time and type
    int notificationId = DateTime.now().millisecondsSinceEpoch % 2147483647;
    if (!isNew) {
      notificationId += 1; // Use an odd number for replacing notifications
    }

    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      isNew ? 'New Ride Notification' : 'Replacing Notification',
      'Do you want to accept ? #: $packageId',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

}




// class NotificationUtils {
//   late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
//
//   NotificationUtils() {
//     _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     _initializeNotifications();
//   }
//
//   void _initializeNotifications() {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings initializationSettings =
//     InitializationSettings(android: initializationSettingsAndroid);
//     _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   Future<void> showNotification(int count, {bool isNew = true}) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//
//     // Generate a unique notification ID based on the current time and type
//     int notificationId = DateTime.now().millisecondsSinceEpoch;
//     if (!isNew) {
//       notificationId += 1; // Use an odd number for replacing notifications
//     }
//
//     await _flutterLocalNotificationsPlugin.show(
//       notificationId,
//       isNew ? 'New Count Received' : 'Replacing Notification',
//       'Count: $count',
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//   }
// }


// class NotificationUtils {
//   late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
//
//   NotificationUtils() {
//     _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     _initializeNotifications();
//   }
//
//   void _initializeNotifications() {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//     final InitializationSettings initializationSettings =
//     InitializationSettings(android: initializationSettingsAndroid);
//     _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   Future<void> showNotification(int count) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       // 'your_channel_description',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       'New Count Received',
//       'Count: $count',
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//   }
// }
