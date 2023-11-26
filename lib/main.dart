import 'dart:async';

// import 'package:device_preview/device_preview.dart';
import 'package:broadcast_events/broadcast_events.dart';
import 'package:crypto_khabar/flavor_setting.dart';
import 'package:crypto_khabar/profile/service/profile_setting_service.dart';
import 'package:crypto_khabar/shared/page/splash_page.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'constants.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlavorSetting().setupFlavorEnvironment();
    MobileAds.instance.initialize();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    await Firebase.initializeApp();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(
      // DevicePreview(
      //   enabled: true,
      //
      //   child: MyApp(),
      // ),

      MyApp(),
    );
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
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

    ProfileSettingService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // builder: DevicePreview.appBuilder,
      title: AppName,
      routes: routes,
      debugShowCheckedModeBanner: false,
      theme: isDarkTheme
          ? ThemeData(
              brightness: Brightness.dark,
              iconTheme: IconThemeData(color: Colors.blue),
              primaryColor: Colors.black,
              hintColor: Colors.cyan[600],
            )
          : ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.lightBlue[800],
              hintColor: Colors.cyan[600],
              iconTheme: IconThemeData(color: Colors.lightBlue[800]),
              // // fontFamily: 'Georgia',
              //  textTheme: TextTheme(
              //  //  headline1: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              //   // headline6: TextStyle(fontSize: 30.0, fontStyle: FontStyle.italic),
              //   // bodyText2: GoogleFonts.roboto(),
              //  ),
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
