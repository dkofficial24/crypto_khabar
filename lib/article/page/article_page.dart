import 'package:crypto_khabar/article/model/article.dart';
import 'package:crypto_khabar/article/provider/article_provider.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:flutter/material.dart';
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
                        Article article = provider.articleList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.ArticleDetailPage,
                                arguments: article);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Text(article.title),
                          ),
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
