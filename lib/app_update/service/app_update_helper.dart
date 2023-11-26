import 'dart:io';

import 'package:crypto_khabar/app_update/model/app_update_config.dart';
import 'package:crypto_khabar/dashboard/page/dashboard_page.dart';
import 'package:crypto_khabar/flavor_setting.dart';
import 'package:crypto_khabar/shared/services/remote_config_service.dart';
import 'package:crypto_khabar/shared/services/shared_pref_helper.dart';
import 'package:crypto_khabar/shared/widget/view_utils.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:crypto_khabar/utils/string_const.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateHelper {
  static final AppUpdateHelper _instance = AppUpdateHelper._();

  factory AppUpdateHelper() {
    return _instance;
  }

  AppUpdateHelper._();

  static const String DefaultTitle = StringConst.updateAppTitle;
  static const String DefaultContent = StringConst.appNewVersionMsg;

  static const String DefaultUpdateButtonText = StringConst.updateAppBtn;
  static const String DefaultIgnoreButtonTxt = StringConst.updateAppLaterBtn;

  Future checkLatestUpdate(BuildContext context) async {
    if (FlavorSetting().isProdEnvironment()) {
      try {
        AppUpdateConfig? config =
            await RemoteConfigService().getAppUpdateConfig();
        if (config == null) {
          return;
        }
        if (!config.shouldUpdateShowDialog) {
          return;
        }

        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        int appCurrentVersion = _extractVersionFromString(packageInfo.version);
        int minimumVersion = _extractVersionFromString(config.minimumVersion);
        int latestVersion = _extractVersionFromString(config.latestVersion);

        bool isForceUpdate = appCurrentVersion < minimumVersion;
        bool shouldUpdate = appCurrentVersion < latestVersion;

        if (Platform.isAndroid && !isForceUpdate) {
          _checkForInAppUpdate(context, config);
        } else {
          if (shouldUpdate) {
            await _doTraditionalUpdate(
                config, isForceUpdate, appCurrentVersion);
          }
        }
      } catch (e) {
        print("AppUpdateHelper checkLatestUpdate err:$e");
      }
    }
  }

  Future<void> _doTraditionalUpdate(AppUpdateConfig? config, bool isForceUpdate,
      int appCurrentVersion) async {
    await Future.delayed(Duration(seconds: 5));
    if (await _shouldShowUpdateDialog()) {
      showUpdateDialog(globalContext,
          title: config?.title ?? DefaultTitle,
          content: config?.content ?? DefaultContent,
          positiveTextButton: config?.positiveButton ?? DefaultUpdateButtonText,
          negativeTextButton: config?.negativeButton ?? DefaultIgnoreButtonTxt,
          forceUpdate: isForceUpdate, positiveAction: () {
        launchUrl(Uri.parse(config?.appUrl ?? ''));
        FirebaseAnalytics.instance
            .logEvent(name: "app_update_accepted", parameters: {
          "appCurrentVersion": appCurrentVersion,
        });
      }, negativeAction: () {
        _saveUpdateCheckLaterTime();
        FirebaseAnalytics.instance
            .logEvent(name: "app_update_ignored_by_button", parameters: {
          "appCurrentVersion": appCurrentVersion,
        });
      }, onBackPress: (isDismiss) {
        if (isDismiss) {
          _saveUpdateCheckLaterTime();
          FirebaseAnalytics.instance.logEvent(
              name: "app_update_ignored_by_click_outside",
              parameters: {
                "appCurrentVersion": appCurrentVersion,
              });
        }
      });
    }
  }

  int _extractVersionFromString(String versionStr) {
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

  Future<bool> _shouldShowUpdateDialog() async {
    int lastUpdateCheckTime = await _getUpdateCheckLaterTime();
    if (lastUpdateCheckTime == -1) {
      return true;
    }
    DateTime lastUpdateCheckDate =
        DateTime.fromMillisecondsSinceEpoch(lastUpdateCheckTime);
    int timeDiff = DateTime.now().difference(lastUpdateCheckDate).inHours;
    return timeDiff >= 12;
  }

  Future _saveUpdateCheckLaterTime() async {
    await SharedPrefHelper().saveValue(
        "updateCheckLaterTime", DateTime.now().millisecondsSinceEpoch);
  }

  Future<int> _getUpdateCheckLaterTime() async {
    String? value = await SharedPrefHelper().getValue("updateCheckLaterTime");
    if (value == null || value.isEmpty) {
      return -1;
    }
    return int.parse(value);
  }

  Future<void> _checkForInAppUpdate(
      BuildContext context, AppUpdateConfig appUpdateConfig) async {
    InAppUpdate.checkForUpdate().then((AppUpdateInfo appUpdateInfo) async {
      if (appUpdateInfo.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        if (await _shouldShowUpdateDialog()) {
          if (appUpdateConfig.appUpdateType == AppUpdateType.IMMEDIATE ||
              appUpdateInfo.updateAvailability ==
                  UpdateAvailability.developerTriggeredUpdateInProgress) {
            _doImmediateUpdate(context);
          } else if (appUpdateConfig.appUpdateType == AppUpdateType.FLEXIBLE) {
            if (appUpdateInfo.installStatus == InstallStatus.downloaded) {
              _downloadFlexibleUpdate(context);
            } else {
              _startFlexibleUpdate(context);
            }
          } else {
            AppUtils.showToast(
              "Something went wrong with the app update.Manually update from play store",
              toastLength: Toast.LENGTH_SHORT,
            );
          }
        }
      } else {
        if (appUpdateInfo.installStatus == InstallStatus.downloaded) {
          _downloadFlexibleUpdate(context);
        }
      }
    }).catchError((e) {
      AppUtils.showSnackBar(context, e.toString());
    });
  }

  void _startFlexibleUpdate(BuildContext context) {
    InAppUpdate.startFlexibleUpdate().then((AppUpdateResult appUpdateResult) {
      if (appUpdateResult.index == AppUpdateResult.success.index) {
        AppUtils.showSnackBar(context, StringConst.appInstalledMsg, action: () {
          _downloadFlexibleUpdate(context);
        },
            actionText: StringConst.appRestartMsg,
            duration: Duration(minutes: 10));
      }
    }).catchError((e) {
      AppUtils.showSnackBar(context, StringConst.updateFailMsg);
    });
    _saveUpdateCheckLaterTime();
  }

  void _doImmediateUpdate(BuildContext context) {
    InAppUpdate.performImmediateUpdate()
        .then((AppUpdateResult appUpdateResult) {
      if (appUpdateResult.index == AppUpdateResult.inAppUpdateFailed.index) {
        AppUtils.showSnackBar(context, StringConst.updateFailMsg);
      }
      _saveUpdateCheckLaterTime();
    }).catchError((e) {
      AppUtils.showSnackBar(context, e.toString());
    });
  }

  void _downloadFlexibleUpdate(BuildContext context) {
    InAppUpdate.completeFlexibleUpdate().then((_) {
      AppUtils.showSnackBar(context, StringConst.appUpdateSuccessMsg);
    }).catchError((e) {
      AppUtils.showSnackBar(context, StringConst.updateFailMsg);
    });
  }
}
