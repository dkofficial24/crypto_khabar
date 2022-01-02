import 'dart:io';

import 'package:crypto_khabar/article/model/article.dart';
import 'package:crypto_khabar/article/provider/article_provider.dart';
import 'package:crypto_khabar/shared/widget/markdown_common.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  ArticleProvider _provider;


  @override
  void initState() {
    _provider = ArticleProvider();
    // if (Pl;p0atform.isAndroid) WebView.platform = AndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Learn")),
      body: ChangeNotifierProvider<ArticleProvider>(
        create: (context) => _provider,
        builder: (ctx, child) {
          return Consumer<ArticleProvider>(
            builder: (ctx, provider, child) {

              return Padding(
                padding: EdgeInsets.all(16),
                child: LazyLoadScrollView(
                  isLoading: _provider.isLoading,
                  scrollOffset: 50,
                  onEndOfPage: () {
                    provider.fetchNewsByPagination();
                  },
                  child: ListView.builder(
                      itemCount: provider.articleList.length,
                      itemBuilder: (context, index) {
                        ExpandableController _expandedController = ExpandableController();
                        Article article = provider.articleList[index];
                        return ExpandablePanel(controller: _expandedController,
                          header: Text(article.title,
                              style: GoogleFonts.hind(fontWeight: FontWeight.bold)),
                          expanded: GestureDetector(
                            child: Column(
                              children: [
                                MarkdownView(article.detail,ScrollController()),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, AppRoutes.WebViewPage,
                                            arguments: article.source);
                                      },
                                      icon: Icon(Icons.open_in_browser),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          // collapsed: Text(
                          //   article.detail,
                          //   softWrap: true,
                          //   maxLines: 2,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                        );
                      }),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

