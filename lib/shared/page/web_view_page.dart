import 'package:crypto_khabar/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  bool isLoading = false;
  String link;
  int index = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (link == null) {
      link = ModalRoute.of(context).settings.arguments;
    }

    return Scaffold(
      appBar: AppBar(title: Text(StringConst.appName),),
      body: Center(
        child: IndexedStack(
          index:index,
          children: [
            WebView(
              initialUrl: link,
              onPageFinished: (_) {
                setState(() {
                  index = 0;
                });
              },
              onPageStarted: (_){
                setState(() {
                  index = 1;
                });
              },
            ),
            Center(child: CircularProgressIndicator(),)
          ],
        ),
      ),
    );
  }
}
