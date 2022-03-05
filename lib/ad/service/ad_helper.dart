import 'dart:io';

import 'package:crypto_khabar/shared/services/remote_config_service.dart';

//Testing github for team
class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8998311484189842/8306319133';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';//test
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static bool isAdEnabled() {
    return RemoteConfigService().isAdEnabled();
  }
}
