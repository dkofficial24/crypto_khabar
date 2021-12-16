import 'package:broadcast_events/broadcast_events.dart';
import 'package:crypto_khabar/constants.dart';
import 'package:crypto_khabar/shared/shared_pref_helper.dart';

class ProfileSettingService {
  ProfileSettingService._internal();

  static ProfileSettingService _authService = ProfileSettingService._internal();

  factory ProfileSettingService() {
    return _authService;
  }

  Future setDarkTheme(bool status) async {
    SharedPrefHelper sharedPrefHelper = SharedPrefHelper();
    await sharedPrefHelper.saveValue("isDarkTheme", status);

    BroadcastEvents().publish<bool>(ThemeChange,arguments: status);
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
