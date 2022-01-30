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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("क्रिप्टो खबर")),
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
                  child: GridView.builder(
                      itemCount: _provider.articleList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,childAspectRatio: 1/1.5,
                        crossAxisSpacing: 4,mainAxisSpacing: 4
                      ),
                      itemBuilder: (ctx, index) {
                        return getGridItem(_provider.articleList[index]);
                      }),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget getGridItem(Article article) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, AppRoutes.ArticleDetailPage,arguments: article);
      },
      child: Container(
        color: Theme.of(context).secondaryHeaderColor,
        height:120,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                article?.imgUrl ?? "",
                fit: BoxFit.cover,
                errorBuilder: (ctx, obj, stack) {
                  return Container(
                      child: Image.asset(
                        "assets/images/placeholder.png",
                        fit: BoxFit.cover,
                      ));
                },
              ),
            ),
            SizedBox(height: 8),
            Flexible(
              child: Text(
                article.title,
                softWrap: true,
                maxLines: 4,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height:8),
            Text(
              article.detail,
              maxLines: 3,overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

  ListView getListView(ArticleProvider provider, BuildContext context) {
    return ListView.separated(
        itemCount: provider.articleList.length,
        separatorBuilder: (ctx, index) {
          return Container(
            key: Key(index.toString()),
            margin: EdgeInsets.symmetric(vertical: 8),
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey,
          );
        },
        itemBuilder: (context, index) {
          ExpandableController _expandedController = ExpandableController();
          Article article = provider.articleList[index];
          return Container(
            child: Column(
              children: [
                Text(article.title,
                    style: GoogleFonts.hind(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(article.detail,
                    style: GoogleFonts.hind(),maxLines: 1,)
              ],
            ),
          );

        });
  }
}
