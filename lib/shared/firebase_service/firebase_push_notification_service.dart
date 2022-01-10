import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/page/dashboard_page.dart';
import 'package:crypto_khabar/profile/service/profile_setting_service.dart';
import 'package:crypto_khabar/shared/firebase_service/news_firebase_service.dart';
import 'package:crypto_khabar/shared/services/notification_service.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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

      FirebaseMessaging.instance.getInitialMessage().then((remoteMessage) {

        if(remoteMessage.data['type'] == 'news'){

        }

      });

      FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
        final remoteNotification = remoteMessage.notification;
        print("message received");
        AppUtils.showToast("Notification received");
        if (ProfileSettingService().notificationStatus) {
          NotificationService().showNotification(
              remoteNotification.title, remoteNotification.body);
        }
      });
      FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
        final remoteNotification = remoteMessage.notification;
        NotificationService().showNotification(
            remoteNotification.title, remoteNotification.body);
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

    await FirebaseFirestore.instance.collection('users').doc(userId).set(
      {
        'tokens': FieldValue.arrayUnion([token]),
      },
    );
  }

  fetchNewsById(String id) async {
    try {
      NewsItem newsItem = await NewsFirebaseService().fetchNewsById(id);
      Navigator.pushNamed(globalContext, AppRoutes.NewsDetailsPage,
          arguments: newsItem);
    } catch (e) {
      print("FirebasePushNotificationService fetchNewsById err:$e");
    }
  }
}

Future onBackgroundMessage(RemoteMessage remoteMessage) async {
  final remoteNotification = remoteMessage.notification;
  NotificationService()
      .showNotification(remoteNotification.title, remoteNotification.body);
}
