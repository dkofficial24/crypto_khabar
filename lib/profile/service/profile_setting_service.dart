import 'package:broadcast_events/broadcast_events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_khabar/constants.dart';
import 'package:crypto_khabar/profile/feedback_info.dart';
import 'package:crypto_khabar/shared/services/shared_pref_helper.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ProfileSettingService {
  String defaultDisclaimerMsg = "क्रिप्टो खबर द्वारा दी कोई भी जानकारी निवेश सलाह, वित्तीय सलाह, व्यापारिक सलाह या किसी अन्य प्रकार की सलाह नहीं है और क्रिप्टो खबर कभी क्रिप्टोकरेंसी खरीदने और बेचने की राय नहीं देता।क्रिप्टो मार्केट उच्च जोखिमों के अधीन है इसलिए कोई भी निवेश निर्णय लेने से पहले अच्छे से जानकारी हासिल कर लें।";
  String disclaimerMsg = "";
  ProfileSettingService._internal() {
    init();
  }

 String getDisclaimerMsg(){
    if(disclaimerMsg == null || disclaimerMsg.isEmpty){
      disclaimerMsg = defaultDisclaimerMsg;
    }
    return disclaimerMsg;
  }

  bool _notificationStatus;

  static ProfileSettingService _authService = ProfileSettingService._internal();

  factory ProfileSettingService() {
    return _authService;
  }

  bool get notificationStatus => _notificationStatus;

  init() {
    disclaimerMsg = defaultDisclaimerMsg;
    getNotificationReceiveStatus().then((value) {
      _notificationStatus = value;
    });
    setSystemTheme();
  }

  setSystemTheme() async {
    bool isManuallySet = await AppUtils.isThemeManuallySet();
    if (isManuallySet) {
      bool isDark = await isDarkTheme();
      BroadcastEvents().publish<bool>(ThemeChange, arguments: isDark);
    }else {
      var brightness = SchedulerBinding.instance.window.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      setDarkTheme(isDarkMode);
    }
  }

  Future setDarkTheme(bool status) async {
    SharedPrefHelper sharedPrefHelper = SharedPrefHelper();
    await sharedPrefHelper.saveValue("isDarkTheme", status);
    BroadcastEvents().publish<bool>(ThemeChange, arguments: status);
  }

  Future<bool> isDarkTheme() async {
    SharedPrefHelper sharedPrefHelper = SharedPrefHelper();
    String value = await sharedPrefHelper.getValue("isDarkTheme");
    if (value == null) {
      return false;
    }
    return value == "true";
  }

  Future setNotificationReceiveStatus(bool status) async {
    SharedPrefHelper sharedPrefHelper = SharedPrefHelper();
    await sharedPrefHelper.saveValue("NotificationReceiveStatus", status);
  }

  Future<bool> getNotificationReceiveStatus() async {
    SharedPrefHelper sharedPrefHelper = SharedPrefHelper();
    String value = await sharedPrefHelper.getValue("NotificationReceiveStatus");
    if (value == null) {
      return true;
    }
    return value == "true";
  }

  Future shareFeedback(FeedbackInfo feedback) async {
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance
        .collection("feedback")
        .doc("${feedback.name}_$time")
        .set(feedback.toJson());

   // print('published successfully !  ${feedback.toJson()}');
  }
}
