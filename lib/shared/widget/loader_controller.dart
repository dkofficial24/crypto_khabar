import 'package:crypto_khabar/utils/string_const.dart';
import 'package:flutter/material.dart';

class LoaderController {

  factory LoaderController() {
    return _instance;
  }

  LoaderController._();
  static final LoaderController _instance = LoaderController._();

  bool isShowingLoader = false;

  void showLoader(BuildContext context,
      {String title = StringConst.pleaseWait,
      String desc = '',
      bool isDismissible = false,}) {
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
        },);
  }

  void dismissLoader(BuildContext context) {
    if (isShowingLoader) {
      isShowingLoader = false;
      Navigator.pop(context);
    }
  }
}

class _LoaderDialog extends StatelessWidget {

  const _LoaderDialog({this.title, this.desc, this.isDismissible});
  final String title;
  final String desc;
  final bool isDismissible;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => isDismissible,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),),
          // backgroundColor: Colors.black87,
          content: _LoadingIndicator(title: title, desc: desc),
        ),);
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({this.title, this.desc});

  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    final displayedText = desc;

    return Container(
        padding: const EdgeInsets.all(16),
        // color: Colors.black87,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getLoadingIndicator(),
              _getHeading(context),
              _getText(displayedText)
            ],),);
  }

  Padding _getLoadingIndicator() {
    return const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(strokeWidth: 3),),);
  }

  Widget _getHeading(context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),);
  }

  Text _getText(String displayedText) {
    return Text(
      displayedText,
      style: const TextStyle(fontSize: 14),
      textAlign: TextAlign.center,
    );
  }
}
