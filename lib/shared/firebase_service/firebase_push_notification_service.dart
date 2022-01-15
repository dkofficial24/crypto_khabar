import 'package:broadcast_events/broadcast_events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_khabar/constants.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/page/dashboard_page.dart';
import 'package:crypto_khabar/profile/service/profile_setting_service.dart';
import 'package:crypto_khabar/shared/firebase_service/news_firebase_service.dart';
import 'package:crypto_khabar/shared/services/notification_service.dart';
import 'package:crypto_khabar/shared/services/shared_pref_helper.dart';
import 'package:crypto_khabar/shared/widget/loader_controller.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
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

      FirebaseMessaging.instance
          .getInitialMessage()
          .then((remoteMessage) async {
        if (remoteMessage == null) return;
        if ((await isMessageIdExists(remoteMessage.messageId))) return;
        LoaderController().showLoader(globalContext);
        await onNotificationClick(remoteMessage);
        LoaderController().dismissLoader(globalContext);
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
        final remoteNotification = remoteMessage.notification;
        print("message received...");
        // if (ProfileSettingService().notificationStatus) {
        //   NotificationService().showNotification(
        //       remoteNotification.title, remoteNotification.body);
        // }
        //BroadcastEvents().publish(NewsReceivedEvent);
      });
      FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) async {
        if (remoteMessage == null) return;
        if ((await isMessageIdExists(remoteMessage.messageId))) return;
        await onNotificationClick(remoteMessage);
      });

      FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    } catch (e) {
      print("PushNotificationService init error: $e");
    }
  }

  Future onNotificationClick(RemoteMessage remoteMessage) async {
    setLastSharedMsg(remoteMessage.messageId);
    if (remoteMessage.data['type'] == 'news') {
      await fetchNewsById(remoteMessage.data['id']);
    }
  }

  void tokenHandler(FirebaseMessaging messaging) {
    messaging.getToken().then((value) {
      print("Token received : $value");
      //saveTokenToDatabase(value);
      token = value;
    });
    // FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  // Future<void> saveTokenToDatabase(String token) async {
  //   // Assume user is logged in for this example
  //   String userId = FirebaseAuth.instance.currentUser.uid;
  //
  //   await FirebaseFirestore.instance.collection('users').doc(userId).set(
  //     {
  //       'tokens': FieldValue.arrayUnion([token]),
  //     },
  //   );
  // }

  Future fetchNewsById(String id) async {
    try {
      LoaderController().showLoader(globalContext);
      NewsItem newsItem = await NewsFirebaseService().fetchNewsById(id);
      LoaderController().dismissLoader(globalContext);
      Navigator.pushNamed(globalContext, AppRoutes.NewsDetailsPage,
          arguments: newsItem);
    } catch (e) {
      LoaderController().dismissLoader(globalContext);
      print("FirebasePushNotificationService fetchNewsById err:$e");
    }
  }

  Future setLastSharedMsg(String msgId) async {
    SharedPrefHelper().saveValue("LastSavedMsgId", msgId);
  }

  Future<bool> isMessageIdExists(String msgId) async {
    String value = await SharedPrefHelper().getValue("LastSavedMsgId");
    if (value == null) {
      return false;
    }

    return msgId == value;
  }
}

Future onBackgroundMessage(RemoteMessage remoteMessage) async {
  return;
  final remoteNotification = remoteMessage.notification;
  NotificationService()
      .showNotification(remoteNotification.title, remoteNotification.body);
}
