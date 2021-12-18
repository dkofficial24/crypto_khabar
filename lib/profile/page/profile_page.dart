import 'package:crypto_khabar/profile/provider/profile_setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
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
              title: Text("Profile"),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ListView(
                  children: [
                    Text(
                      "Settings",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 16),
                    ProfileItem(
                      title: "Saved",
                      iconData: Icons.bookmark_outline,
                      callback: () {},
                      lastChild: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    ),
                    SizedBox(height: 16),
                    ProfileItem(
                      title: "Dark Mode",
                      iconData: Icons.brightness_6_outlined,
                      callback: () {},
                      lastChild: Switch(
                        onChanged: (value) {
                          provider.setThemeMode(value);
                        },
                        value: provider.isDarkMode,
                      ),
                    ),
                    SizedBox(height: 10),
                    ProfileItem(
                      title: "Notifications",
                      iconData: Icons.notifications_outlined,
                      callback: () {},
                      lastChild: Switch(
                        onChanged: (value) {
                          provider.setNotificationReceiveStatus(value);
                        },
                        value: provider.getNotification,
                      ),
                    )
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
    @required this.callback,
    @required this.lastChild,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2),
            child: Icon(iconData,color: Theme.of(context).iconTheme.color,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            //  color: Colors.cyan,
            ),
          ),
          SizedBox(width: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Expanded(child: Container()),
          lastChild
        ],
      ),
    );
  }
}
