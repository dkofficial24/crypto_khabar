import 'package:crypto_khabar/profile/service/profile_setting_service.dart';
import 'package:flutter/cupertino.dart';

class ProfileSettingProvider extends ChangeNotifier {
  bool isDarkMode = false;
  bool getNotification = false;

  ProfileSettingProvider() {
    init();
  }

  void init() async {
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
}
