import 'package:crypto_khabar/market/page/market_page.dart';
import 'package:crypto_khabar/profile/provider/profile_setting_provider.dart';
import 'package:crypto_khabar/profile/service/profile_setting_service.dart';
import 'package:crypto_khabar/shared/services/remote_config_service.dart';
import 'package:crypto_khabar/shared/widget/loader_controller.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileSettingProvider provider;

  @override
  void initState() {
    provider = ProfileSettingProvider();
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
              title: Text("क्रिप्टो खबर"),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ListView(
                  children: [
                    SizedBox(height: 12),
                    ProfileItem(
                      title: "डार्क थीम",
                      iconData: Icons.brightness_6_outlined,
                      callback: () {},
                      lastChild: Switch(
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          provider.setThemeMode(value).then((value) {
                            AppUtils.markThemeManuallySet();
                          });
                          FirebaseAnalytics.instance.logEvent(
                              name: 'theme_change',
                              parameters: {"isDark": value});
                        },
                        value: provider.isDarkMode,
                      ),
                    ),
                    SizedBox(height: 12),
                    ProfileItem(
                      title: "बुकमार्क ख़बर",
                      iconData: Icons.bookmark_outline,
                      callback: () {
                        Navigator.pushNamed(context, AppRoutes.SavedNewsPage);
                      },
                      lastChild: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    ),
                    SizedBox(height: 8),
                    ProfileItem(
                      title: "नोटिफिकेशन्स",
                      iconData: Icons.notifications_outlined,
                      callback: () {},
                      lastChild: Switch(
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          provider.setNotificationReceiveStatus(value);
                          FirebaseAnalytics.instance.logEvent(
                              name: 'notification_status',
                              parameters: {"notification_status:": value});
                        },
                        value: provider.getNotification,
                      ),
                    ),
                    SizedBox(height: 8),
                    ProfileItem(
                      title: "फीडबैक",
                      iconData: Icons.feedback_outlined,
                      callback: () async{
                        Navigator.pushNamed(context, AppRoutes.FeedbackPage);
                        FirebaseAnalytics.instance.logEvent(name: "feedback_page_open");
                      },
                      lastChild: Container(),
                    ),SizedBox(height: 8),
                    ProfileItem(
                      title: "डिस्क्लेमर",
                      iconData: Icons.info_outline_rounded,
                      callback: () async{
                        String disclaimer = ProfileSettingService().getDisclaimerMsg();
                        Navigator.pushNamed(context, AppRoutes.DisclaimerPage,arguments: disclaimer);
                        FirebaseAnalytics.instance.logEvent(name: "disclaimer_page_open");
                      },
                      lastChild: Container(),
                    ),SizedBox(height: 8),
                    ProfileItem(
                      title: "शेयर ऐप",
                      iconData: Icons.share,
                      callback: () async{
                        LoaderController().showLoader(context);
                        String downloadLink = await RemoteConfigService().getAppDownloadLink();
                        LoaderController().dismissLoader(context);
                        Share.share(downloadLink,subject: "क्रिप्टो से संबधित ख़बर पढ़ने के लिए क्रिप्टो खबर ऐप डाउनलोड करेंं");
                        FirebaseAnalytics.instance.logEvent(name: "share_app");
                      },
                      lastChild: Container(),
                    ),
                    SizedBox(height: 8),
                    ProfileItem(
                      title: "Market",
                      iconData: Icons.share,
                      callback: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MarketPage()));
                      },
                      lastChild: Icon(Icons.arrow_forward_ios, size: 15),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function callback;
  final Widget lastChild;

  const ProfileItem({
    @required this.title,
    @required this.iconData,
    @required this.lastChild,
    this.callback,
  });

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
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(2),
                child: Icon(
                  iconData,
                  color: Theme.of(context).iconTheme.color,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  //  color: Colors.cyan,
                ),
              ),
            ),
            SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.subtitle1,
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
