import 'package:crypto_khabar/flavor_setting.dart';
import 'package:crypto_khabar/shared/services/remote_config_service.dart';

//Testing github for team
class AdHelper {
  static String get bannerAdUnitId {
    return FlavorSetting().getAdId();
  }

  static bool isAdEnabled() {
    return RemoteConfigService().isAdEnabled();
  }
}
