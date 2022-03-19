import 'dart:async';

import 'package:crypto_khabar/ad/service/ad_helper.dart';
import 'package:crypto_khabar/market/model/market_model.dart';
import 'package:crypto_khabar/market/service/market_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MarketProvider extends ChangeNotifier {
  List<MarketItem> marketItemList = [];
  bool isLoading = false;
  bool shimmer = false;
  bool isBannerAdReady = false;
  BannerAd bannerAd;

  Timer timer;

  MarketProvider() {
    shimmer = true;
    notifyListeners();
    fetchMarketByPagination().then((value) {
      shimmer = false;
      notifyListeners();
    });

    timer = Timer(Duration(seconds: 30), () {
      print("Fetching market data");
      fetchMarketByPagination().then((value) {
        notifyListeners();
      });
    });

    initAd();
  }

  initAd() {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBannerAdReady = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          isBannerAdReady = false;
          notifyListeners();
          ad.dispose();
        },
      ),
    );
    bannerAd.load();
  }

  Future fetchMarketByPagination({bool appendInEnd = true}) async {
    isLoading = true;
    notifyListeners();
    marketItemList =
        await MarketService().fetchMarketByPagination(appendInEnd: appendInEnd);
    isLoading = false;
    notifyListeners();
  }

  void onRefresh(RefreshController refreshController) async {
    await fetchMarketByPagination(appendInEnd: false);
    refreshController.refreshCompleted();
  }
}
