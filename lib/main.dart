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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppName,
      routes: routes,
      debugShowCheckedModeBanner: false,
      theme: false
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
              primaryColor: Color(0xFF282727),
              accentColor: Colors.cyan[600],
            ),
      home: SplashPage(),
    );
  }
}
