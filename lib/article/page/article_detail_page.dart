import 'package:crypto_khabar/article/model/article.dart';
import 'package:crypto_khabar/article/service/article_service.dart';
import 'package:crypto_khabar/shared/services/remote_config_service.dart';
import 'package:crypto_khabar/shared/widget/markdown_common.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:flutter/material.dart';

class ArticleDetailPage extends StatefulWidget {
  @override
  DetailPageState createState() => DetailPageState();
}

class DetailPageState extends State<ArticleDetailPage> {
  Article _article;
  ScrollController _scrollController;
  bool savingArticle = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _article = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text("आर्टिकल"),
          actions: [
            IconButton(
                onPressed: () {
                  shareArticle();
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
                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                child: Text(_article.title,
                    style: Theme.of(context).textTheme.headline6),
              ),

              MarkdownView(_article.detail, _scrollController)
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
}
