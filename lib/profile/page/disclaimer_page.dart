import 'package:crypto_khabar/utils/string_const.dart';
import 'package:flutter/material.dart';

class DisclaimerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String disclaimerMsg =
        (ModalRoute.of(context)?.settings.arguments as String?) ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConst.disclaimer),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Text(disclaimerMsg, style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
