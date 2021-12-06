import 'package:crypto_khabar/auth/service/auth_service.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    AuthService().loginAnonymously().then((value) {
      Navigator.pushReplacementNamed(context, AppRoutes.TopNewsPage);
    }).timeout(Duration(seconds: 2));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Loading..."),
      ),
    );
  }
}
