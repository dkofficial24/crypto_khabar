import 'dart:io';

import 'package:crypto_khabar/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateWidget extends StatelessWidget {
  const AppUpdateWidget({@required this.title,@required this.desc});
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.65,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              //tileMode: TileMode.clamp,
              colors: [
                Color.fromRGBO(9, 198, 249, 1),
                Color.fromRGBO(4, 93, 233, 1),
              ],
            ),),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                  child: Text(
                    title,
                    style:
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      desc,
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                    onPressed: () {
                      if (Platform.isAndroid) {
                        launchUrl(
                            Uri.parse('https://play.google.com/store/apps/details?id=com.edgetechapps.crypto_khabar'),);
                      }
                    },
                    child: const Text(StringConst.doUpdate),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
