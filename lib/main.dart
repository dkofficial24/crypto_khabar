import 'package:broadcast_events/broadcast_events.dart';
import 'package:crypto_khabar/profile/service/profile_setting_service.dart';
import 'package:crypto_khabar/shared/splash_page.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = false;

  @override
  void initState() {
    BroadcastEvents().subscribe<bool>(ThemeChange, onThemeChange);

    ProfileSettingService().isDarkTheme().then((status) {
      setState(() {
        isDarkTheme = status;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppName,
      routes: routes,
      debugShowCheckedModeBanner: false,
      theme: isDarkTheme
          ? ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.lightBlue[800],
              accentColor: Colors.cyan[600],
              // // fontFamily: 'Georgia',
              //  textTheme: TextTheme(
              //  //  headline1: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              //   // headline6: TextStyle(fontSize: 30.0, fontStyle: FontStyle.italic),
              //   // bodyText2: GoogleFonts.roboto(),
              //  ),
            )
          : ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.black,
              accentColor: Colors.cyan[600],
            ),
      home: SplashPage(),
    );
  }

  onThemeChange(status) {
    setState(() {
      isDarkTheme = status;
    });
  }

  @override
  void dispose() {
    BroadcastEvents().unsubscribe<bool>(ThemeChange, handler: onThemeChange);
    super.dispose();
  }
}
