import 'package:broadcast_events/broadcast_events.dart';
import 'package:crypto_khabar/constants.dart';
import 'package:crypto_khabar/shared/services/shared_pref_helper.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ProfileSettingService {
  ProfileSettingService._internal() {
    init();
  }

  bool _notificationStatus;

  static ProfileSettingService _authService = ProfileSettingService._internal();

  factory ProfileSettingService() {
    return _authService;
  }

  bool get notificationStatus => _notificationStatus;

  init() {
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
      return false;
    }
    return value == "true";
  }
}
