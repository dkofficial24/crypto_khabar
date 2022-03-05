import 'package:crypto_khabar/app_update/model/app_update_config.dart';
import 'package:crypto_khabar/dashboard/page/dashboard_page.dart';
import 'package:crypto_khabar/shared/services/remote_config_service.dart';
import 'package:crypto_khabar/shared/services/shared_pref_helper.dart';
import 'package:crypto_khabar/shared/widget/view_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateHelper {
  static final AppUpdateHelper _instance = AppUpdateHelper._();

  factory AppUpdateHelper() {
    return _instance;
  }

  AppUpdateHelper._();

  static const String DefaultTitle = "अपडेट अलर्ट";
  static const String DefaultContent =
      "ऐप का नया वर्जन प्ले स्टोर पर उपलब्ध है।";

  static const String DefaultUpdateButtonText = "अपडेट";
  static const String DefaultIgnoreButtonTxt = "बाद में";

  Future checkLatestUpdate() async {
    try {
      AppUpdateConfig config = await RemoteConfigService().getAppUpdateConfig();
      if (config == null) {
        //print("AppUpdateHelper checkLatestUpdate AppUpdateConfig is null");
        return;
      }
      if (!config.shouldUpdateShowDialog) {
        return;
      }
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      int appCurrentVersion = extractVersionFromString(packageInfo.version);
      int minimumVersion = extractVersionFromString(config.minimumVersion);
      int latestVersion = extractVersionFromString(config.latestVersion);

      bool isForceUpdate = appCurrentVersion < minimumVersion;
      bool shouldUpdate = appCurrentVersion < latestVersion;

      if (shouldUpdate && globalContext != null) {
        if (await shouldShowUpdateDialog()) {
          showUpdateDialog(globalContext,
              title: config?.title ?? DefaultTitle,
              content: config?.content ?? DefaultContent,
              positiveTextButton:
                  config?.positiveButton ?? DefaultUpdateButtonText,
              negativeTextButton:
                  config?.negativeButton ?? DefaultIgnoreButtonTxt,
              forceUpdate: isForceUpdate, positiveAction: () {
            launch(config.appUrl);
            FirebaseAnalytics.instance
                .logEvent(name: "app_update_accepted", parameters: {
              "appCurrentVersion": appCurrentVersion,
            });
          }, negativeAction: () {
            saveUpdateCheckLaterTime();
            FirebaseAnalytics.instance
                .logEvent(name: "app_update_ignored_by_button", parameters: {
              "appCurrentVersion": appCurrentVersion,
            });
          }, onBackPress: (isDismiss) {
            if (isDismiss) {
              saveUpdateCheckLaterTime();
              FirebaseAnalytics.instance.logEvent(
                  name: "app_update_ignored_by_click_outside",
                  parameters: {
                    "appCurrentVersion": appCurrentVersion,
                  });
            }
          });
        }
      }
    } catch (e) {
      print("AppUpdateHelper checkLatestUpdate err:$e");
    }
  }

  int extractVersionFromString(String versionStr) {
    String currentVersion = versionStr
        .replaceAll(".", "")
        .replaceAll("-", "")
        .replaceAll("-", "")
        .replaceAll("+", "")
        .trim();
    int index = currentVersion.indexOf(RegExp(r'[a-zA-Z]'));
    if (index > 0) {
      currentVersion = currentVersion.substring(0, index);
    }
    try {
      return int.parse(currentVersion);
    } catch (e) {
      return -1;
    }
  }

  Future<bool> shouldShowUpdateDialog() async {
    int lastUpdateCheckTime = await getUpdateCheckLaterTime();
    if (lastUpdateCheckTime == -1) {
      return true;
    }
    DateTime lastUpdateCheckDate =
        DateTime.fromMillisecondsSinceEpoch(lastUpdateCheckTime);
    int timeDiff = DateTime.now().difference(lastUpdateCheckDate).inHours;
    return timeDiff >= 24;
  }

  Future saveUpdateCheckLaterTime() async {
    await SharedPrefHelper().saveValue(
        "updateCheckLaterTime", DateTime.now().millisecondsSinceEpoch);
  }

  Future<int> getUpdateCheckLaterTime() async {
    String value = await SharedPrefHelper().getValue("updateCheckLaterTime");
    if (value == null || value.isEmpty) {
      return -1;
    }
    return int.parse(value);
  }
}
