import 'package:crypto_khabar/utils/string_const.dart';
import 'package:flutter/material.dart';

class DisclaimerPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final String disclaimerMsg = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: const Text(StringConst.disclaimer),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          child: Text(disclaimerMsg,style:const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
