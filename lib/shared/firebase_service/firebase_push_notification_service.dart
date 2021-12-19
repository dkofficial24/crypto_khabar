import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_khabar/profile/service/profile_setting_service.dart';
import 'package:crypto_khabar/shared/services/notification_service.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      tokenHandler(messaging);

      // subscribe to topic on each app start-up
      FirebaseMessaging.instance.subscribeToTopic('global_notification');
      FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
        final remoteNotification = remoteMessage.notification;
        print("message received");
        AppUtils.showToast("Notification received");
        if (ProfileSettingService().notificationStatus) {
          NotificationService().showNotification(
              remoteNotification.title, remoteNotification.body);
        }
      });
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('Message clicked!');
      });

      FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    } catch (e) {
      print("PushNotificationService init error: $e");
    }
  }

  void tokenHandler(FirebaseMessaging messaging) {
    messaging.getToken().then((value) {
      print("Token received : $value");
      saveTokenToDatabase(value);
      token = value;
    });
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    String userId = FirebaseAuth.instance.currentUser.uid;

    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'tokens': FieldValue.arrayUnion([token]),
    },);
  }
}

Future onBackgroundMessage(RemoteMessage message) async {
  NotificationService().showNotification("Background", "New Message Received");
}
