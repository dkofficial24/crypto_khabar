import 'package:crypto_khabar/shared/firebase_service/firebase_push_notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid, macOS: null);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    // showNotification("Title","Bodyyy");
  }

  Future selectNotification(String payload) async {

  }

  showNotification(String title, String body,
      {int id = 1001,
        String channelId = 'ChannelId',
        String channelName = 'NotificationChannel',
        String payload}) async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails("ChannelId", "ChannleName", "ChannelDesc");
    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin
        .show(id, title, body, notificationDetails, payload: payload);
  }
}
