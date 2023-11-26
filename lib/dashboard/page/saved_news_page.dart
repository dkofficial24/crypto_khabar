import 'package:crypto_khabar/dashboard/model/news_details_args.dart';
import 'package:crypto_khabar/dashboard/provider/saved_news_provider.dart';
import 'package:crypto_khabar/dashboard/widget/row_news_list_widget.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:crypto_khabar/utils/string_const.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedNewsPage extends StatefulWidget {
  @override
  _SavedNewsPageState createState() => _SavedNewsPageState();
}

class _SavedNewsPageState extends State<SavedNewsPage> {
  late SavedNewsProvider _provider;

  @override
  void initState() {
    _provider = SavedNewsProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SavedNewsProvider>(
      create: (ctx) => _provider,
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringConst.bookmarkNews),
        ),
        body: Consumer<SavedNewsProvider>(
          builder: (context, provider, child) {
            if(_provider.newsItemList.length == 0){
              return Center(child: Text(StringConst.noBookmarkedNews),);
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView.separated(
                  itemBuilder: (ctx, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        color: Colors.red,
                        child: Icon(Icons.delete,color: Colors.red,),
                      ),
                      onDismissed: (_) async {
                        await _provider
                            .removeSavedNews(_provider.newsItemList[index].id);
                        _provider.newsItemList.removeAt(index);
                        setState(() {});
                        FirebaseAnalytics.instance.logEvent(name: "removeSavedNews");
                      },
                      child: NewsRowListWidget(
                        newsItem: _provider.newsItemList[index],
                        callback: (_) {
                          Navigator.pushNamed(
                              context, AppRoutes.NewsDetailsPage,
                              arguments: NewsDetailsArgs(
                                  index:-1,
                                  newsItem: provider
                                      .newsItemList[index]));
                        },
                      ),
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                    );
                  },
                  itemCount: _provider.newsItemList.length),
            );
          },
        ),
      ),
    );
  }
}
