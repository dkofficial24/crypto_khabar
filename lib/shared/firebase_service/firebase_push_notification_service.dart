import 'package:crypto_khabar/shared/notification_service.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static final _instance = PushNotificationService._internal();

  PushNotificationService._internal() {
    init();
  }

  factory PushNotificationService() {
    return _instance;
  }

  String token;

  void init() {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      messaging.getToken().then((value) {
        print("Token received : $value");
        token = value;
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
        final remoteNotification = remoteMessage.notification;
        print("message received");
        AppUtils.showToast("Notification received");
        NotificationService().showNotification(
            remoteNotification.title, remoteNotification.body);
      });
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('Message clicked!');
      });

      FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    } catch (e) {
      print("PushNotificationService init error: $e");
    }
  }
}

Future onBackgroundMessage(RemoteMessage message) async {
  NotificationService().showNotification("Background", "New Message Received");
}
