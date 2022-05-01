import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateWidget extends StatelessWidget {
  final String title;
  final String desc;
  const AppUpdateWidget({@required this.title,@required this.desc});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.65,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              //tileMode: TileMode.clamp,
              colors: [
                Color.fromRGBO(9, 198, 249, 1),
                Color.fromRGBO(4, 93, 233, 1),
              ],
            )),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                  child: Text(
                    title,
                    style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )),
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      desc,
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                    onPressed: () {
                      if (Platform.isAndroid) {
                        launch(
                            "https://play.google.com/store/apps/details?id=com.edgetechapps.crypto_khabar");
                      }
                    },
                    child: Text("अपडेट करें")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
