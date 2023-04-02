import 'dart:convert';

import 'package:crypto_khabar/profile/feedback_info.dart';
import 'package:crypto_khabar/profile/service/profile_setting_service.dart';
import 'package:crypto_khabar/shared/services/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';

class ProfileSettingProvider extends ChangeNotifier {


  ProfileSettingProvider() {
    init();
  }
  bool isDarkMode = false;
  bool getNotification = false;
  double rating = 5;
  FeedbackInfo previousFeedback;

  Future<void> init() async {
    isDarkMode = await isDarkTheme();
    getNotification = await getNotificationReceiveStatus();
    notifyListeners();
  }

  Future setThemeMode(bool isDarkMode) async {
    await ProfileSettingService().setDarkTheme(isDarkMode);
    this.isDarkMode = isDarkMode;
    notifyListeners();
  }

  Future<bool> isDarkTheme() async {
    return await ProfileSettingService().isDarkTheme();
  }

  Future setNotificationReceiveStatus(bool status) async {
    await ProfileSettingService().setNotificationReceiveStatus(status);
    getNotification = status;
    notifyListeners();
  }

  Future<bool> getNotificationReceiveStatus() async {
    return await ProfileSettingService().getNotificationReceiveStatus();
  }

  Future shareFeedback(FeedbackInfo feedback) async {
    await ProfileSettingService().shareFeedback(feedback);
    await saveUserDetails(feedback);
  }

  Future saveUserDetails(FeedbackInfo feedback)async{
    feedback.review = '';
    await SharedPrefHelper().saveValue('userDetails', jsonEncode(feedback.toJson()));
  //  print("User detail saved");
  }

  Future<FeedbackInfo> getUserDetails()async{
    try {
      final value = await SharedPrefHelper().getValue('userDetails');
      if (value == null || value.isEmpty) return null;
      final info = FeedbackInfo.fromJson(jsonDecode(value));
      return info;
    }catch(e){
      return null;
    }
  }

}
