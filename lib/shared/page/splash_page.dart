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
    Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.pushReplacementNamed(context, AppRoutes.Dashboard);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/app_icon.png"),
      ),
    );
  }
}
