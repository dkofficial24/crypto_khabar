import 'package:crypto_khabar/profile/provider/profile_setting_provider.dart';
import 'package:crypto_khabar/profile/service/profile_setting_service.dart';
import 'package:crypto_khabar/shared/services/remote_config_service.dart';
import 'package:crypto_khabar/shared/widget/loader_controller.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:crypto_khabar/utils/string_const.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileSettingProvider provider;
  String version = '';

  @override
  void initState() {
    provider = ProfileSettingProvider();
    PackageInfo.fromPlatform().then((value) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          version = value.version;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileSettingProvider>(
      create: (ctx) => provider,
      child: Consumer<ProfileSettingProvider>(
        builder: (ctx, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(StringConst.appName),
            ),
            body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    ProfileItem(
                      title: StringConst.darkTheme,
                      iconData: Icons.brightness_6_outlined,
                      callback: () {},
                      lastChild: Switch(
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          LoaderController().showLoader(context);
                          provider.setThemeMode(value).then((value) {
                            AppUtils.markThemeManuallySet();
                            LoaderController().dismissLoader(context);
                          });
                          FirebaseAnalytics.instance.logEvent(
                              name: 'theme_change',
                              parameters: {'isDark': value},);
                        },
                        value: provider.isDarkMode,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ProfileItem(
                      title: StringConst.bookmarkNews,
                      iconData: Icons.bookmark_outline,
                      callback: () {
                        Navigator.pushNamed(context, AppRoutes.SavedNewsPage);
                      },
                      lastChild: const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ProfileItem(
                      title: StringConst.notifications,
                      iconData: Icons.notifications_outlined,
                      callback: () {},
                      lastChild: Switch(
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          provider.setNotificationReceiveStatus(value);
                          FirebaseAnalytics.instance.logEvent(
                              name: 'notification_status',
                              parameters: {'notification_status:': value},);
                        },
                        value: provider.getNotification,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ProfileItem(
                      title: StringConst.feedback,
                      iconData: Icons.feedback_outlined,
                      callback: () async {
                        await Navigator.pushNamed(context, AppRoutes.FeedbackPage);
                        await FirebaseAnalytics.instance
                            .logEvent(name: 'feedback_page_open');
                      },
                      lastChild: Container(),
                    ),
                    const SizedBox(height: 8),
                    ProfileItem(
                      title: StringConst.disclaimer,
                      iconData: Icons.info_outline_rounded,
                      callback: () async {
                        final disclaimer =
                            ProfileSettingService().getDisclaimerMsg();
                        await Navigator.pushNamed(context, AppRoutes.DisclaimerPage,
                            arguments: disclaimer,);
                        await FirebaseAnalytics.instance
                            .logEvent(name: 'disclaimer_page_open');
                      },
                      lastChild: Container(),
                    ),
                    const SizedBox(height: 8),
                    ProfileItem(
                      title: StringConst.shareApp,
                      iconData: Icons.share,
                      callback: () async {
                        LoaderController().showLoader(context);
                        final downloadLink =
                            await RemoteConfigService().getAppDownloadLink();
                        LoaderController().dismissLoader(context);
                        await Share.share(downloadLink,
                            subject:
                                StringConst.shareAppMsg,);
                        await FirebaseAnalytics.instance.logEvent(name: 'share_app');
                      },
                      lastChild: Container(),
                    ),
                    const SizedBox(height: 32),
                    Center(child: Text("${StringConst.appVersion} ${version ?? ""}",style: const TextStyle(color: Colors.grey),))
                  ],
                ),),
          );
        },
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {

  const ProfileItem({
    @required this.title,
    @required this.iconData,
    @required this.lastChild,
    this.callback,
  });
  final String title;
  final IconData iconData;
  final Function callback;
  final Widget lastChild;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (callback != null) {
          callback();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  //  color: Colors.cyan,
                ),
                child: Icon(
                  iconData,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Expanded(
              child: Container(),
            ),
            lastChild
          ],
        ),
      ),
    );
  }
}
