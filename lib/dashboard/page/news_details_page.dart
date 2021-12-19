import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/service/news_service.dart';
import 'package:crypto_khabar/shared/widget/markdown_common.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:flutter/material.dart';

class NewsDetailsPage extends StatefulWidget {
  @override
  _NewsDetailsPageState createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  NewsItem _newsItem;
  ScrollController _scrollController;
  bool savingNews = false;
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _newsItem = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text("News"),
          actions: [
            IconButton(
                onPressed: (){
                  saveNews(_newsItem);
                },
                icon: Icon(Icons.bookmark_border, color: Colors.white)),
            IconButton(
                onPressed: () {
                  AppUtils.shareNews(_newsItem);
                },
                icon: Icon(Icons.share, color: Colors.white)),
            SizedBox(width: 8)
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      _newsItem?.imgUrl ?? "",
                      fit: BoxFit.fitWidth,
                      errorBuilder: (ctx, obj, stack) {
                        return Container(
                            child: Image.asset(
                          "assets/images/placeholder.png",
                          fit: BoxFit.fitHeight,
                        ));
                      },
                    ),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(_newsItem.title,
                    style: Theme.of(context).textTheme.headline6),
              ),
              Text(AppUtils.formatDate(_newsItem.date)),
              SizedBox(height: 8),
              MarkdownView(_newsItem.details, _scrollController)
            ],
          ),
        ));
  }

  Future saveNews(NewsItem newsItem) async {
    if(!savingNews) {
      setState(() {
        savingNews = true;
      });
      try {
       bool status = await NewsService().saveNews(newsItem);
       if(status) {
         AppUtils.showToast("News saved");
       }
      }catch(e){
        print("ERROR:$e");
      }
      setState(() {
        savingNews = false;
      });
    }
  }
}
