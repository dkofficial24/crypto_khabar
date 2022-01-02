import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/provider/top_news_provider.dart';
import 'package:crypto_khabar/dashboard/service/news_service.dart';
import 'package:crypto_khabar/dashboard/widget/column_news_list_widget.dart';
import 'package:crypto_khabar/dashboard/widget/drawer_menu.dart';
import 'package:crypto_khabar/dashboard/widget/row_news_list_widget.dart';
import 'package:crypto_khabar/shared/services/notification_service.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class TopNewsPage extends StatefulWidget {
  @override
  _TopNewsPageState createState() => _TopNewsPageState();
}

class _TopNewsPageState extends State<TopNewsPage> {
  TopNewsProvider _topNewsProvider;
  RefreshController _refreshController;

  @override
  void initState() {
    _topNewsProvider = TopNewsProvider();
    _refreshController = RefreshController(initialRefresh: false);
    init();
    super.initState();
  }

  Future init() async {
    NotificationService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crypto News"),
      ),
      // drawer: Drawer(
      //   child: DrawerMenuWidget(),
      // ),
      body: ChangeNotifierProvider<TopNewsProvider>(
        create: (ctx) => _topNewsProvider,
        child: Consumer<TopNewsProvider>(
          builder: (context, provider, child) {
            return _topNewsProvider.shimmer
                ? newsRowShimmer()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: LazyLoadScrollView(
                      onEndOfPage: () {
                        provider.fetchNewsByPagination();
                      },
                      isLoading: provider.isLoading,
                      scrollOffset: 50,
                      child: ListView.separated(
                          itemBuilder: (ctx, index) {
                            if (index == _topNewsProvider.newsItemList.length) {
                              return provider.isLoading
                                  ? Center(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 4),
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                  : Container();
                            }
                            if (index == 0 || index % 4 == 0) {
                              return createSlidable(
                                provider.newsItemList[index],
                                context,
                                child: ColumnNewsListWidget(
                                  newsItem: provider.newsItemList[index],
                                  callback: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.NewsDetailsPage,
                                        arguments:
                                            provider.newsItemList[index]);
                                  },
                                ),
                              );
                            }
                            return createSlidable(
                              provider.newsItemList[index],
                              context,
                              child: NewsRowListWidget(
                                newsItem: provider.newsItemList[index],
                                callback: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.NewsDetailsPage,
                                      arguments: provider.newsItemList[index]);
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
                          itemCount: _topNewsProvider.newsItemList.length + 1),
                    ));
          },
        ),
      ),
    );
  }

  Widget newsRowShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Shimmer.fromColors(
          child: ListView.builder(
              itemCount: 16,
              itemBuilder: (ctx, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 10,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          SizedBox(height: 4),
                          Container(
                            height: 10,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 4,
                            width: MediaQuery.of(context).size.width * 0.35,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      flex: 1,
                      child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          height: 60,
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(color: Colors.white),
                          )),
                    )
                  ],
                );
              }),
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100]),
    );
  }

  Slidable createSlidable(NewsItem newsItem, BuildContext context,
      {@required Widget child}) {
    return Slidable(
        closeOnScroll: true,
        enabled: true,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: _topNewsProvider.savingNews
                  ? null
                  : (ctx) {
                      _topNewsProvider.saveNews(newsItem);
                    },
              icon: Icons.bookmark_border,
              label: 'Save',
              backgroundColor: Theme.of(context).canvasColor,
            ),
            SlidableAction(
              onPressed: (ctx) {
                AppUtils.shareNews(newsItem);
              },
              backgroundColor: Theme.of(context).canvasColor,
              icon: Icons.share,
              label: 'Share',
            ),
          ],
        ),
        key: UniqueKey(),
        child: child);
  }

  @override
  void dispose() {
    print("Disposing top news page");
    super.dispose();
  }
}
