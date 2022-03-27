import 'package:broadcast_events/broadcast_events.dart';
import 'package:crypto_khabar/ad/service/ad_helper.dart';
import 'package:crypto_khabar/constants.dart';
import 'package:crypto_khabar/dashboard/model/news_details_args.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/provider/top_news_provider.dart';
import 'package:crypto_khabar/dashboard/widget/column_news_list_widget.dart';
import 'package:crypto_khabar/dashboard/widget/news_carousel.widget.dart';
import 'package:crypto_khabar/dashboard/widget/row_news_list_widget.dart';
import 'package:crypto_khabar/shared/services/notification_service.dart';
import 'package:crypto_khabar/shared/services/remote_config_service.dart';
import 'package:crypto_khabar/shared/widget/loader_controller.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';


class TopNewsPage extends StatefulWidget {
  @override
  _TopNewsPageState createState() => _TopNewsPageState();
}

class _TopNewsPageState extends State<TopNewsPage> with WidgetsBindingObserver{
  TopNewsProvider _topNewsProvider;
  RefreshController _refreshController;


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
       isAppInBackground = false;
    }else{
      isAppInBackground = true;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _topNewsProvider = TopNewsProvider();
    _refreshController = RefreshController(initialRefresh: false);
    init();
    super.initState();
  }

  Future init() async {
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
        title: Text("क्रिप्टो खबर"),
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
                            enablePullUp: false,
                            reverse: false,
                            enableTwoLevel: false,
                            enablePullDown: true,
                            onRefresh: () {
                              provider.onRefresh(_refreshController);
                            },
                            child: ListView.separated(
                                itemBuilder: (ctx, index) {
                                  int usedIndex = index - 1;
                                  if (index == 0) {
                                    return _topNewsProvider
                                                .featuredNewsItemList.length >
                                            0
                                        ? CarouselWidget()
                                        : Container();
                                  }
                                  if (index ==
                                      _topNewsProvider.newsItemList.length +
                                          1) {
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
                                  if ((index% 5 == 0) ||
                                      (_topNewsProvider.featuredNewsItemList.length ==
                                              0 &&
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
                                                          usedIndex]));
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
                                                    .newsItemList[usedIndex]));
                                      },
                                    ),
                                  );
                                },
                                separatorBuilder: (ctx, index) {
                                  if (index == 0) return Container();
                                  return Divider();
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    height: 1,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.grey,
                                  );
                                },
                                itemCount:
                                    _topNewsProvider.newsItemList.length + 2),
                          ),
                        )),
                        provider.isBannerAdReady
                            ? adBannerWidget(provider)
                            : Container()
                      ],
                    ));
          },
        ),
      ),
    );
  }

  Container adBannerWidget(TopNewsProvider provider) {
    return AdHelper.isAdEnabled()
        ? Container(
            width: provider.bannerAd.size.width.toDouble(),
            height: provider.bannerAd.size.height.toDouble(),
            child: AdWidget(ad: provider.bannerAd),
          )
        : Container();
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
                      if (_topNewsProvider.isNewsBookmarked(newsItem.id)) {
                        _topNewsProvider.removeBookmarkNews(newsItem);
                      } else {
                        _topNewsProvider.bookmarkNews(newsItem);
                      }
                    },
              icon: _topNewsProvider.isNewsBookmarked(newsItem.id)
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              label: 'बुकमार्क करें',
              backgroundColor: Theme.of(context).canvasColor,
            ),
            SlidableAction(
              onPressed: (ctx) {
                shareNews(context, newsItem);
              },
              backgroundColor: Theme.of(context).canvasColor,
              icon: Icons.share,
              label: 'शेयर',
            ),
          ],
        ),
        key: UniqueKey(),
        child: child);
  }

  Future<void> shareNews(BuildContext context, NewsItem newsItem) async {
    LoaderController().showLoader(context);
    String downloadLink = await RemoteConfigService().getAppDownloadLink();
    LoaderController().dismissLoader(context);
    AppUtils.shareNews(newsItem, appLink: downloadLink);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _topNewsProvider.bannerAd.dispose();
    BroadcastEvents().unsubscribe(NewsReceivedEvent, handler: fetchNews);
    BroadcastEvents()
        .unsubscribe(NewsBookmarkRemove, handler: onBookmarkRemovedEvent);
    BroadcastEvents().unsubscribe(NewsBookmarked, handler: onBookmarkedEvent);
    super.dispose();
  }
}
