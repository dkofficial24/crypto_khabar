import 'package:broadcast_events/broadcast_events.dart';
import 'package:crypto_khabar/constants.dart';
import 'package:crypto_khabar/dashboard/model/news_details_args.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/provider/top_news_provider.dart';
import 'package:crypto_khabar/dashboard/widget/column_news_list_widget.dart';
import 'package:crypto_khabar/dashboard/widget/news_carousel.widget.dart';
import 'package:crypto_khabar/dashboard/widget/row_news_list_widget.dart';
import 'package:crypto_khabar/shared/services/notification_service.dart';
import 'package:crypto_khabar/shared/services/remote_config_service.dart';
import 'package:crypto_khabar/shared/widget/banner_ad.dart';
import 'package:crypto_khabar/shared/widget/loader_controller.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:crypto_khabar/utils/string_const.dart';
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

class _TopNewsPageState extends State<TopNewsPage> with WidgetsBindingObserver {
  TopNewsProvider _topNewsProvider;
  RefreshController _refreshController;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      isAppInBackground = false;
    } else {
      isAppInBackground = true;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _topNewsProvider = TopNewsProvider();
    _refreshController = RefreshController();
    init();
    super.initState();
  }

  Future init() async {
    isAppInBackground = false;
    NotificationService();
    BroadcastEvents().subscribe(NewsReceivedEvent, fetchNews);
    BroadcastEvents().subscribe(NewsBookmarkRemove, onBookmarkRemovedEvent);
    BroadcastEvents().subscribe(NewsBookmarked, onBookmarkedEvent);
  }

  void fetchNews(_) {
    _topNewsProvider.fetchNewsByPagination();
  }

  void onBookmarkRemovedEvent(_) {
    if (mounted) {
      setState(() {});
    }
  }

  void onBookmarkedEvent(_) {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConst.appName),
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
                    padding:
                        const EdgeInsets.only(right: 16, left: 16, top: 8),
                    //padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        Expanded(
                            child: LazyLoadScrollView(
                          onEndOfPage: () {
                            provider.fetchNewsByPagination();
                          },
                          isLoading: provider.isLoading,
                          scrollOffset: 80,
                          child: SmartRefresher(
                            controller: _refreshController,
                            reverse: false,
                            onRefresh: () {
                              provider.onRefresh(_refreshController);
                            },
                            child: ListView.separated(
                                itemBuilder: (ctx, index) {
                                  final usedIndex = index - 1;
                                  if (index == 0) {
                                    return _topNewsProvider
                                                .featuredNewsItemList.isNotEmpty
                                        ? CarouselWidget()
                                        : Container();
                                  }
                                  if (index ==
                                      _topNewsProvider.newsItemList.length +
                                          1) {
                                    return provider.isLoading
                                        ? Center(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 4, horizontal: 4,),
                                              height: 30,
                                              width: 30,
                                              child: const CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          )
                                        : Container();
                                  }
                                  if ((index % 5 == 0) ||
                                      (_topNewsProvider.featuredNewsItemList.isEmpty &&
                                          index == 1)) {
                                    return createSlidable(
                                      provider.newsItemList[usedIndex],
                                      context,
                                      child: ColumnNewsListWidget(
                                        newsItem:
                                            provider.newsItemList[usedIndex],
                                        callback: () {
                                          Navigator.pushNamed(context,
                                              AppRoutes.NewsDetailsPage,
                                              arguments: NewsDetailsArgs(
                                                  index: usedIndex,
                                                  newsItem:
                                                      provider.newsItemList[
                                                          usedIndex],),);
                                        },
                                      ),
                                    );
                                  }

                                  return createSlidable(
                                    provider.newsItemList[usedIndex],
                                    context,
                                    child: NewsRowListWidget(
                                      newsItem:
                                          provider.newsItemList[usedIndex],
                                      callback: (_) {
                                        Navigator.pushNamed(
                                            context, AppRoutes.NewsDetailsPage,
                                            arguments: NewsDetailsArgs(
                                                index: usedIndex,
                                                newsItem: provider
                                                    .newsItemList[usedIndex],),);
                                      },
                                    ),
                                  );
                                },
                                separatorBuilder: (ctx, index) {
                                  if (index == 0) return Container();
                                  return const Divider();
                                },
                                itemCount:
                                    _topNewsProvider.newsItemList.length + 2,),
                          ),
                        ),),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        BannerAdWidget()
                      ],
                    ),);
          },
        ),
      ),
    );
  }

  Widget newsRowShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
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
                          const SizedBox(height: 4),
                          Container(
                            height: 10,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 4,
                            width: MediaQuery.of(context).size.width * 0.35,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          height: 60,
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(color: Colors.white),
                          ),),
                    )
                  ],
                );
              },),),
    );
  }

  Slidable createSlidable(NewsItem newsItem, BuildContext context,
      {@required Widget child,}) {
    return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: _topNewsProvider.savingNews
                  ? null
                  : (ctx) {
                      if (_topNewsProvider.isNewsBookmarked(newsItem.id)) {
                        _topNewsProvider.removeBookmarkNews(newsItem);
                      } else {
                        _topNewsProvider.bookmarkNews(newsItem);
                      }
                    },
              icon: _topNewsProvider.isNewsBookmarked(newsItem.id)
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              label: StringConst.doBookmarkNews,
              backgroundColor: Theme.of(context).canvasColor,
            ),
            SlidableAction(
              onPressed: (ctx) {
                shareNews(context, newsItem);
              },
              backgroundColor: Theme.of(context).canvasColor,
              icon: Icons.share,
              label: StringConst.share,
            ),
          ],
        ),
        key: UniqueKey(),
        child: child,);
  }

  Future<void> shareNews(BuildContext context, NewsItem newsItem) async {
    LoaderController().showLoader(context);
    final downloadLink = await RemoteConfigService().getAppDownloadLink();
    LoaderController().dismissLoader(context);
    AppUtils.shareNews(newsItem, appLink: downloadLink);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    BroadcastEvents().unsubscribe(NewsReceivedEvent, handler: fetchNews);
    BroadcastEvents()
        .unsubscribe(NewsBookmarkRemove, handler: onBookmarkRemovedEvent);
    BroadcastEvents().unsubscribe(NewsBookmarked, handler: onBookmarkedEvent);
    super.dispose();
  }
}
