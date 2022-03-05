import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:crypto_khabar/dashboard/model/news_details_args.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/provider/top_news_provider.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
                              arguments: NewsDetailsArgs(
                                  index:-1,
                                  newsItem: newsItem));
                        } else if (newsItem.category
                            .toLowerCase()
                            .contains("app_update")) {
                          if (Platform.isAndroid) {
                            launch(
                                "https://play.google.com/store/apps/details?id=com.edgetechapps.crypto_khabar");
                          }
                        } else if (newsItem.category
                            .toLowerCase()
                            .contains("short")) {
                          if (!isShortVideo(newsItem)) {
                            AppUtils.showToast("Only headline available");
                          }
                        } else {
                          AppUtils.showToast("डिटेल में उपलब्ध नहीं है।");
                        }
                        FirebaseAnalytics.instance.logEvent(
                            name: "carousle_click",
                            parameters: {"category": newsItem.category});
                      },
                      child: isShortVideo(newsItem)
                          ? PlayerWidget(newsItem.vdoUrl)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        newsItem.imgUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (ctx, obj, stack) {
                                          return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.65,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color:
                                                newsItem.title.trim().isNotEmpty
                                                    ? Colors.black38
                                                    : Colors.transparent),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            newsItem.title,
                                            style:
                                                TextStyle(color: Colors.white),
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

  bool isShortVideo(NewsItem newsItem) {
    if (newsItem.category == "short" &&
        newsItem.vdoUrl != null &&
        newsItem.vdoUrl.isNotEmpty) {
      return true;
    }
    return false;
  }
}

class PlayerWidget extends StatefulWidget {
  final String videoUrl;

  PlayerWidget(this.videoUrl);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoUrl,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          bottomActions: [
            const SizedBox(width: 14.0),
            CurrentPosition(),
            const SizedBox(width: 8.0),
            ProgressBar(
              isExpanded: true,
            ),
            RemainingDuration(),
            const PlaybackSpeedButton(),
          ],
          progressColors: ProgressBarColors(
              handleColor: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).primaryColor),
          progressIndicatorColor: Colors.amber,
          onReady: () {},onEnded: (meta){
          // _controller.reset();
        },
          aspectRatio: 4 / 3,
        ),
      ),
    );
  }
}
