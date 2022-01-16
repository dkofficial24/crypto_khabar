import 'package:broadcast_events/broadcast_events.dart';
import 'package:crypto_khabar/constants.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/service/news_service.dart';
import 'package:crypto_khabar/shared/services/remote_config_service.dart';
import 'package:crypto_khabar/shared/widget/loader_controller.dart';
import 'package:crypto_khabar/shared/widget/markdown_common.dart';
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
  ScrollController _scrollController;
  bool savingNews = false;
  bool removeBookmarkingNews = false;

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
                onPressed: () async {
                  try {
                    LoaderController().showLoader(context);
                    String downloadLink =
                        await RemoteConfigService().getAppDownloadLink();
                    AppUtils.shareNews(_newsItem, appLink: downloadLink);
                    FirebaseAnalytics.instance.logEvent(name: "ndp_share_news");
                  } catch (e) {
                    print("NewsDetailPage shareNews error:$e");
                  } finally {
                    LoaderController().dismissLoader(context);
                  }
                },
                icon: Icon(Icons.share, color: Colors.white)),
            SizedBox(width: 8)
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
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
                        textStyle: Theme.of(context).textTheme.headline6)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(AppUtils.formatDate(_newsItem.date)),
              ),
              SizedBox(height: 8),
              MarkdownView(_newsItem.details, _scrollController)
            ],
          ),
        ));
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
}
