import 'package:crypto_khabar/utils/string_const.dart';
import 'package:flutter/material.dart';

class LoaderController {
  static final LoaderController _instance = LoaderController._();

  LoaderController._();

  factory LoaderController() {
    return _instance;
  }

  bool isShowingLoader = false;

  void showLoader(BuildContext context,
      {String title = StringConst.pleaseWait,
      String desc = '',
      bool isDismissible = false}) {
    if (isShowingLoader) return;
    isShowingLoader = true;
    showDialog(
        context: context,
        builder: (ctx) {
          return _LoaderDialog(
            title: title,
            desc: desc,
            isDismissible: isDismissible,
          );
        });
  }

  void dismissLoader(BuildContext context) {
    if (isShowingLoader) {
      isShowingLoader = false;
      Navigator.pop(context);
    }
  }
}

class _LoaderDialog extends StatelessWidget {
  final String title;
  final String desc;
  final bool isDismissible;

  _LoaderDialog({
    required this.title,
    required this.desc,
    required this.isDismissible,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: isDismissible,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          // backgroundColor: Colors.black87,
          content: _LoadingIndicator(title: title, desc: desc),
        ));
  }
}

class _LoadingIndicator extends StatelessWidget {
  _LoadingIndicator({
    required this.title,
    required this.desc,
  });

  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    var displayedText = desc;

    return Container(
        padding: EdgeInsets.all(16),
        // color: Colors.black87,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getLoadingIndicator(),
              _getHeading(context),
              _getText(displayedText)
            ]));
  }

  Padding _getLoadingIndicator() {
    return Padding(
        child: Container(
            child: CircularProgressIndicator(strokeWidth: 3),
            width: 32,
            height: 32),
        padding: EdgeInsets.only(bottom: 16));
  }

  Widget _getHeading(context) {
    return Padding(
        child: Text(
          title,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.only(bottom: 4));
  }

  Text _getText(String displayedText) {
    return Text(
      displayedText,
      style: TextStyle(fontSize: 14),
      textAlign: TextAlign.center,
    );
  }
}
