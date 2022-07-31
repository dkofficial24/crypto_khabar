import 'package:broadcast_events/broadcast_events.dart';
import 'package:crypto_khabar/constants.dart';
import 'package:crypto_khabar/dashboard/model/news_details_args.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/service/news_service.dart';
import 'package:crypto_khabar/dashboard/widget/row_news_list_widget.dart';
import 'package:crypto_khabar/shared/services/remote_config_service.dart';
import 'package:crypto_khabar/shared/widget/banner_ad.dart';
import 'package:crypto_khabar/shared/widget/loader_controller.dart';
import 'package:crypto_khabar/shared/widget/markdown_common.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsDetailsPage extends StatefulWidget {
  @override
  _NewsDetailsPageState createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  NewsItem _newsItem;
  NewsDetailsArgs newsDetailsArgs;
  ScrollController _scrollController;
  bool savingNews = false;
  bool removeBookmarkingNews = false;
  List<Widget> list = [];

  @override
  void initState() {
    _scrollController = ScrollController();
    FirebaseAnalytics.instance.logEvent(name: "ndp_detail_news");
    super.initState();
  }

  void initRelatedNews(int index) {
    if(index == -1) return;
    List<NewsItem> newsList = NewsService().newsItemList;
    int currentIndex = index;
    List nextNewsList = [];
    int i = newsList.length - currentIndex - 1;
    if (i > 0) {
      i = i > 4 ? 4 : i;
      nextNewsList =
          newsList.getRange(currentIndex + 1, currentIndex + i).toList();
    }
    int count = 0;
    List<Widget> rowList = nextNewsList.map((e) {
      count++;
      return Column(
        children: [
          NewsRowListWidget(newsItem: e, callback: (clickedIndex) {
            if(index == -1)return;
            Navigator.pushReplacementNamed(context,
                AppRoutes.NewsDetailsPage,
                arguments: NewsDetailsArgs(
                    index:clickedIndex,
                    newsItem: e));
          },index: index+count,
          ),
          Divider()
        ],
      );
    }).toList();

    list.addAll(rowList);
  }

  @override
  Widget build(BuildContext context) {
    if (_newsItem == null) {
      newsDetailsArgs = ModalRoute.of(context).settings.arguments;
      _newsItem = newsDetailsArgs.newsItem;
      initRelatedNews(newsDetailsArgs.index);
      incrementView(_newsItem.id);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("क्रिप्टो खबर"),
          actions: [
            IconButton(
                onPressed: () {
                  if (isNewsBookmarked(_newsItem.id)) {
                    removeNewsFromBookmark(_newsItem.id);
                  } else {
                    bookmarkNews(_newsItem);
                  }
                },
                icon: Icon(
                    isNewsBookmarked(_newsItem.id)
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: Colors.white)),
            IconButton(
                onPressed: ()  {
                  shareNews(context);
                  FirebaseAnalytics.instance.logEvent(
                      name: "ndp_share_news",
                      parameters: {"title": "${_newsItem.title}"});
                },
                icon: Icon(Icons.share, color: Colors.white)),
            SizedBox(width: 8)
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(left: 4,right: 4,top: 12,bottom: 4),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            _newsItem?.imgUrl ?? "",
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, obj, stack) {
                              return Container(
                                  child: Image.asset(
                                "assets/images/placeholder.png",
                                fit: BoxFit.cover,
                              ));
                            },
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Text(_newsItem.title,
                          style: GoogleFonts.hind(
                              textStyle:
                                  Theme.of(context).textTheme.headline6)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(AppUtils.formatDate(_newsItem.date)),
                    ),
                    SizedBox(height: 8),
                    MarkdownView(_newsItem.details, _scrollController),
                    SizedBox(height: 4),
                    GestureDetector(
                      onTap: (){
                        shareNews(context);
                        FirebaseAnalytics.instance.logEvent(
                            name: "ndp_bttm_share_news",
                            parameters: {"title": "${_newsItem.title}"});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("शेयर करें"),
                          SizedBox(width:8),
                          Icon(Icons.share),
                          SizedBox(width:48),
                        ],),
                    ),
                    list.length !=0?Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        SizedBox(height: 8),
                        Text(
                          "और खबरें",
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
                        ),
                        Divider(),
                        SizedBox(height: 8),
                        ...list,
                      ]),
                    ):Container()
                  ],
                ),
              ),
              Divider(height: 1,thickness: 1,color: Colors.grey.withOpacity(0.1),),
              BannerAdWidget()
            ],
          ),
        ));
  }

  Future<void> shareNews(BuildContext context) async {
     try {
      LoaderController().showLoader(context);
      String downloadLink =
          await RemoteConfigService().getAppDownloadLink();
      AppUtils.shareNews(_newsItem, appLink: downloadLink);
    } catch (e) {
      print("NewsDetailPage shareNews error:$e");
    } finally {
      LoaderController().dismissLoader(context);
    }
  }

  Future bookmarkNews(NewsItem newsItem) async {
    if (!savingNews) {
      setState(() {
        savingNews = true;
      });
      try {
        bool status = await NewsService().saveNews(newsItem);
        if (status) {
          BroadcastEvents().publish(NewsBookmarked);
        }
      } catch (e) {
        print("ERROR:$e");
      }
      setState(() {
        savingNews = false;
      });
    }
  }

  Future removeNewsFromBookmark(String id) async {
    if (!removeBookmarkingNews) {
      setState(() {
        removeBookmarkingNews = true;
      });
      try {
        await NewsService().removeSavedNews(id);
        BroadcastEvents().publish(NewsBookmarkRemove);
      } catch (e) {
        print("ERROR:$e");
      }
      setState(() {
        removeBookmarkingNews = false;
      });
    }
  }

  bool isNewsBookmarked(String id) {
    return NewsService().isNewsBookmarked(id);
  }

  Future incrementView(String id) async {
    try {
      await NewsService().incrementView(id);
    } catch (e) {
 //     print("incrementView err $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
