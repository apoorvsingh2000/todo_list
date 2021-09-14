import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static Future init({bool isScheduled = false}) async {
    final settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: IOSInitializationSettings());
    await _notifications.initialize(settings,
        onSelectNotification: (payload) async {});
  }

  static Future showNotification({
    int id = 0,
    String title,
    String body,
    String payload,
  }) async =>
      _notifications.show(id, title, body, await _notificationDetails());

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel description',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }
}
