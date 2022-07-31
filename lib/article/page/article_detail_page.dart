import 'package:crypto_khabar/article/model/article.dart';
import 'package:crypto_khabar/article/service/article_service.dart';
import 'package:crypto_khabar/shared/services/remote_config_service.dart';
import 'package:crypto_khabar/shared/widget/banner_ad.dart';
import 'package:crypto_khabar/shared/widget/markdown_common.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ArticleDetailPage extends StatefulWidget {
  @override
  DetailPageState createState() => DetailPageState();
}

class DetailPageState extends State<ArticleDetailPage> {
  Article _article;
  ScrollController _scrollController;
  bool savingArticle = false;
  YoutubePlayerController _controller;
  bool isVideoContain = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    FirebaseAnalytics.instance.logEvent(name: "adp_detail_article");
    super.initState();
  }

  void initVideoPlayerController() {
    isVideoContain = _article.vdoUrl != null && _article.vdoUrl.isNotEmpty;
    if (isVideoContain) {
      _controller = YoutubePlayerController(
        initialVideoId: _article.vdoUrl,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_article == null) {
      _article = ModalRoute
          .of(context)
          .settings
          .arguments;
      initVideoPlayerController();
    }
  //  print("Link: ${_article.imgUrl}");
    return Scaffold(
        appBar: AppBar(
          title: Text("आर्टिकल"),
          actions: [
            IconButton(
                onPressed: () {
                  shareArticle();
                  FirebaseAnalytics.instance.logEvent(name: "adp_top_share_article");
                },
                icon: Icon(Icons.share, color: Colors.white)),
            SizedBox(width: 8)
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Column(
            children: [
              videoWidget(),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    isVideoContain
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                _article?.imgUrl ?? "",
                                fit: BoxFit.fitWidth,
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
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: Text(_article.title,
                          style: Theme.of(context).textTheme.headline6),
                    ),
                    MarkdownView(_article.detail, _scrollController),
                    SizedBox(height:4),
                    GestureDetector(
                      onTap: (){
                        shareArticle();
                        FirebaseAnalytics.instance.logEvent(name: "adp_bttm_share_article");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("शेयर करें"),
                            SizedBox(width:8),
                            Icon(Icons.share),
                            SizedBox(width:48),
                          ],),
                      ),
                    )
                  ],
                ),
              ),
              Divider(height: 1,thickness: 1,color: Colors.grey.withOpacity(0.1),),
           //   BannerAdWidget()
            ],
          ),
        ));
  }

  Future<void> shareArticle() async {
    String downloadLink = await RemoteConfigService().getAppDownloadLink();
    AppUtils.shareArticle(_article, appLink: downloadLink);
  }

  Future saveArticle(Article article) async {
    if (!savingArticle) {
      setState(() {
        savingArticle = true;
      });
      try {
        bool status = await ArticleService().saveArticle(article);
        if (status) {
          AppUtils.showToast("आर्टिकल बुकमार्क हो गयी");
        }
      } catch (e) {
        print("ERROR:$e");
      }
      setState(() {
        savingArticle = false;
      });
    }
  }

  Widget videoWidget() {
    return _controller != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                bottomActions: [
                  const SizedBox(width: 14.0),
                  CurrentPosition(),
                  const SizedBox(width: 8.0),
                  ProgressBar(
                    isExpanded: true,
                  ),
                  RemainingDuration(),
                  const PlaybackSpeedButton(),
                ],
                progressColors: ProgressBarColors(
                    handleColor: Theme.of(context).primaryColor,
                    backgroundColor: Theme.of(context).primaryColor),
                progressIndicatorColor: Colors.amber,
                onReady: () {},
                aspectRatio: 4 / 3,
              ),
            ),
          )
        : Container();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }
}
