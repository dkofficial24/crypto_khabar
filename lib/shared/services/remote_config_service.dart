import 'dart:async';
import 'dart:convert';

import 'package:crypto_khabar/app_update/model/app_update_config.dart';
import 'package:crypto_khabar/profile/service/profile_setting_service.dart';
import 'package:crypto_khabar/utils/string_const.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final RemoteConfigService _remoteConfigService =
      RemoteConfigService._internal();

  factory RemoteConfigService() {
    return _remoteConfigService;
  }

  RemoteConfigService._internal() {
    init();
  }

  FirebaseRemoteConfig _remoteConfig;
  AppUpdateConfig _appUpdateConfig;
  bool _isAdEnabled = true;
  Completer<AppUpdateConfig> appUpdateCompleter = Completer();

  init() async {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        minimumFetchInterval: const Duration(minutes: 10),
      ));
      await _remoteConfig.fetchAndActivate();
      downloadUpdateConfig();
    } catch (e) {
      print("RemoteConfigService init err: $e");
    }
  }

  Future downloadUpdateConfig() async {
    try {
      if (appUpdateCompleter.isCompleted) {
        appUpdateCompleter = Completer();
      }
      String configJson = _remoteConfig.getString("app_update_config");
      _appUpdateConfig = AppUpdateConfig.fromJson(jsonDecode(configJson));
      _isAdEnabled = _remoteConfig.getBool("is_ad_enabled");
      String disclaimerMsg = _remoteConfig.getString("disclaimer_msg");
      ProfileSettingService().disclaimerMsg = disclaimerMsg;
      appUpdateCompleter.complete(_appUpdateConfig);
    } catch (e) {
      appUpdateCompleter.completeError("Error while downloadUpdateConfig");
    }
  }

  Future<AppUpdateConfig> getAppUpdateConfig() async {
    if (appUpdateCompleter.isCompleted) {
      return _appUpdateConfig;
    }
    return appUpdateCompleter.future;
  }

  bool isAdEnabled() {
    return _isAdEnabled;
  }

  Future<String> getAppDownloadLink() async {
    if (_appUpdateConfig == null) {
      await downloadUpdateConfig();
    }
    String linkUrl = _appUpdateConfig.appUrl;
    linkUrl = linkUrl + " " + StringConst.shareAppMsg;
    return linkUrl;
  }
}
