import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_khabar/article/model/article.dart';
import 'package:crypto_khabar/article/provider/article_provider.dart';
import 'package:crypto_khabar/shared/widget/banner_ad.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:crypto_khabar/utils/string_const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late ArticleProvider _provider;
  late RefreshController _refreshController;

  @override
  void initState() {
    _provider = ArticleProvider();
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringConst.appName)),
      body: ChangeNotifierProvider<ArticleProvider>(
        create: (context) => _provider,
        builder: (ctx, child) {
          return Consumer<ArticleProvider>(
            builder: (ctx, provider, child) {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: LazyLoadScrollView(
                        isLoading: _provider.isLoading,
                        scrollOffset: 50,
                        onEndOfPage: () {
                          provider.fetchNewsByPagination();
                        },
                        child: SmartRefresher(
                          controller: _refreshController,
                          enablePullUp: false,
                          reverse: false,
                          enableTwoLevel: false,
                          enablePullDown: true,
                          onRefresh: () {
                            provider.onRefresh(_refreshController);
                          },
                          child: GridView.builder(
                              itemCount: _provider.articleList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1 / 1.5,
                                      crossAxisSpacing: 4,
                                      mainAxisSpacing: 4),
                              itemBuilder: (ctx, index) {
                                return getGridItem(
                                    _provider.articleList[index]);
                              }),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  BannerAdWidget()
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget getGridItem(Article article) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.ArticleDetailPage,
            arguments: article);
      },
      child: Container(
        color: Theme.of(context).secondaryHeaderColor,
        height: 125,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: article.imgUrl ?? "",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Container(
                      child: Image.asset(
                    "assets/images/placeholder.png",
                    fit: BoxFit.cover,
                  )),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              article.title ?? '',
              softWrap: true,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Text(
                article.detail ?? '',
                softWrap: false,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
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
        Article article = provider.articleList[index];
        return Container(
          child: Column(
            children: [
              Text(article.title ?? '',
                  style: GoogleFonts.hind(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                article.detail ?? '',
                style: GoogleFonts.hind(),
                maxLines: 1,
              )
            ],
          ),
        );
      },
    );
  }
}
