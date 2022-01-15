import 'dart:async';
import 'dart:convert';

import 'package:crypto_khabar/app_update/model/app_update_config.dart';
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

  RemoteConfig _remoteConfig;
  AppUpdateConfig _appUpdateConfig;
  Completer<AppUpdateConfig> appUpdateCompleter = Completer();

  init() async {
    try {
      _remoteConfig = RemoteConfig.instance;
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
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
      String configJson = _remoteConfig.getString("app_update_config");
      _appUpdateConfig = AppUpdateConfig.fromJson(jsonDecode(configJson));
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
}
