import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/provider/top_news_provider.dart';
import 'package:crypto_khabar/dashboard/widget/column_news_list_widget.dart';
import 'package:crypto_khabar/dashboard/widget/drawer_menu.dart';
import 'package:crypto_khabar/dashboard/widget/row_news_list_widget.dart';
import 'package:crypto_khabar/shared/notification_service.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
        title: Text("Top News"),
      ),
      drawer: Drawer(
        child: DrawerMenuWidget(),
      ),
      body: ChangeNotifierProvider<TopNewsProvider>(
        create: (ctx) => _topNewsProvider,
        child: Consumer<TopNewsProvider>(
          builder: (context, provider, child) {
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () {
                    provider.onRefresh(_refreshController);
                  },
                  child: LazyLoadScrollView(
                    onEndOfPage: provider.fetchNewsByPagination,isLoading: provider.isLoading,
                    scrollOffset: 50,
                    child: ListView.separated(
                        itemBuilder: (ctx, index) {
                          if (index == 0 || index % 4 == 0) {
                            return ColumnNewsListWidget(
                              newsItem: provider.newsItemList[index],
                              callback: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.NewsDetailsPage,
                                    arguments: provider.newsItemList[index]);
                              },
                            );
                          }

                          return NewsRowListWidget(
                            newsItem: provider.newsItemList[index],
                            callback: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.NewsDetailsPage,
                                  arguments: provider.newsItemList[index]);
                            },
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
                        itemCount: _topNewsProvider.newsItemList.length),
                  ),
                ));
          },
        ),
      ),
    );
  }
}
