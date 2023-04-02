import 'dart:io';

import 'package:crypto_khabar/app_configs.dart';
import 'package:flutter/services.dart';

class FlavorSetting {

  factory FlavorSetting() {
    return _instance;
  }
  FlavorSetting._();

  static final FlavorSetting _instance = FlavorSetting._();

  Environment _environment = Environment.DEV;

  Environment get environment => _environment;

  void setBuildFlavor(String flavor) {
    _setEnvironment(flavor);
  }

  void _setEnvironment(String flavorStr) {
    switch (flavorStr) {
      case 'dev':
        _environment = Environment.DEV;
        break;
      case 'prod':
        _environment = Environment.PROD;
        break;
      default:
        _environment = Environment.DEV;
    }
  }

  bool isProdEnvironment() => _environment == Environment.PROD;

  String getAdId() {
    if (Platform.isAndroid) {
      return _environment == Environment.DEV
          ? DevConfigs.androidAdId
          : ProdConfigs.androidAdId;
    } else {
      //iOS
      return _environment == Environment.DEV
          ? DevConfigs.iosAdId
          : ProdConfigs.iosAdId;
    }
  }

  setupFlavorEnvironment() async {
    try {
      const methodChannel = MethodChannel('flavor');
      final flavor = await methodChannel.invokeMethod('getFlavor');
      setBuildFlavor(flavor);
    } catch (e) {
      print('$e');
    }
  }
}

enum Environment { DEV, PROD }
