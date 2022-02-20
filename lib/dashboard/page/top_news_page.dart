import 'dart:io';

import 'package:broadcast_events/broadcast_events.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crypto_khabar/ad/service/ad_helper.dart';
import 'package:crypto_khabar/constants.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/provider/top_news_provider.dart';
import 'package:crypto_khabar/dashboard/widget/column_news_list_widget.dart';
import 'package:crypto_khabar/dashboard/widget/row_news_list_widget.dart';
import 'package:crypto_khabar/shared/services/notification_service.dart';
import 'package:crypto_khabar/shared/services/remote_config_service.dart';
import 'package:crypto_khabar/shared/widget/loader_controller.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

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
                          scrollOffset: 50,
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
                                  if (index % 5 == 0) {
                                    return createSlidable(
                                      provider.newsItemList[usedIndex],
                                      context,
                                      child: ColumnNewsListWidget(
                                        newsItem:
                                            provider.newsItemList[usedIndex],
                                        callback: () {
                                          Navigator.pushNamed(context,
                                              AppRoutes.NewsDetailsPage,
                                              arguments: provider
                                                  .newsItemList[usedIndex]);
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
                                      callback: () {
                                        Navigator.pushNamed(
                                            context, AppRoutes.NewsDetailsPage,
                                            arguments: provider
                                                .newsItemList[usedIndex]);
                                      },
                                    ),
                                  );
                                },
                                separatorBuilder: (ctx, index) {
                                  if (index == 0) return Container();
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
    print("Disposing top news page");
    _topNewsProvider.bannerAd.dispose();
    BroadcastEvents().unsubscribe(NewsReceivedEvent, handler: fetchNews);
    BroadcastEvents()
        .unsubscribe(NewsBookmarkRemove, handler: onBookmarkRemovedEvent);
    BroadcastEvents().unsubscribe(NewsBookmarked, handler: onBookmarkedEvent);
    super.dispose();
  }
}

class CarouselWidget extends StatelessWidget {
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Consumer<TopNewsProvider>(builder: (ctx, provider, child) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.2,
                viewportFraction: 0.75,
                onPageChanged: (index, reason) {
                  provider.updateCarouselCurrentIndex(index);
                },
                enlargeCenterPage: false,
                autoPlayInterval: Duration(seconds: 8),
                initialPage: 0,
                enableInfiniteScroll: true,
                aspectRatio: 16 / 9,
                reverse: false,
                autoPlay: false,
              ),
              items: provider.featuredNewsItemList.map((newsItem) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        if (newsItem.category.toLowerCase().contains("news") &&
                            (newsItem.details?.isNotEmpty ?? false)) {
                          Navigator.pushNamed(
                              context, AppRoutes.NewsDetailsPage,
                              arguments: newsItem);
                        } if(newsItem.category.toLowerCase().contains("app_update")){
                          if(Platform.isAndroid) {
                            launch(
                                "https://play.google.com/store/apps/details?id=com.edgetechapps.crypto_khabar");
                          }
                        }else {
                          AppUtils.showToast("डिटेल में उपलब्ध नहीं है।");
                        }
                        FirebaseAnalytics.instance.logEvent(
                            name: "carousle_click",
                            parameters: {"category": newsItem.category});
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  newsItem.imgUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, obj, stack) {
                                    return ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          "assets/images/placeholder.png",
                                          fit: BoxFit.cover,
                                        ));
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: newsItem.title.trim().isNotEmpty
                                          ? Colors.black38
                                          : Colors.transparent),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      newsItem.title,
                                      style: TextStyle(color: Colors.white),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  )),
                              bottom: 0,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
              carouselController: _carouselController,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                provider.featuredNewsItemList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(entry.key),
                child: Container(
                  width: 6.0,
                  height: 6.0,
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(
                              provider.carouselCurrentIndex == entry.key
                                  ? 0.9
                                  : 0.4)),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}
