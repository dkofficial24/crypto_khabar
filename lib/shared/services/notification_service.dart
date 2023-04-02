import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();
  static final NotificationService _notificationService =
      NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future init() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification,);
    // showNotification("Title","Bodyyy");
  }

  Future selectNotification(String payload) async {
  //  print("Payloaddd  $payload");
   // print("Payloaddd  $payload");
  }

  showNotification(String title, String body,
      {int id = 1001,
      String channelId = 'ChannelId',
      String channelName = 'NotificationChannel',
      String payload,}) async {
    const androidNotificationDetails =
        AndroidNotificationDetails(
      'ChannelId',
      'ChannelName',
          'ChannelDesc',
      icon: 'mipmap/ic_launcher',
      //groupKey: "12345678",
    );
    final notificationDetails =
        const NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin
        .show(id, title, body, notificationDetails, payload: payload);
  }
}
