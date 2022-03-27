import 'dart:async';

import 'package:crypto_khabar/ad/service/ad_helper.dart';
import 'package:crypto_khabar/constants.dart';
import 'package:crypto_khabar/market/model/market_model.dart';
import 'package:crypto_khabar/market/service/market_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum SortMarket { Rank, Gainer, Loser }

class MarketProvider extends ChangeNotifier {
  List<MarketItem> marketItemList = [];
  bool isLoading = false;
  bool shimmer = false;
  bool isBannerAdReady = false;
  BannerAd bannerAd;
  Timer timer;

  SortMarket currentSortFilter = SortMarket.Rank;
  String marketFilterName = "रैंक";

  MarketProvider() {
    shimmer = true;
    notifyListeners();
    fetchMarketByPagination().then((value) {
      shimmer = false;
      notifyListeners();
    });
    initFetchDataTimer();
  //  initAd();
  }

  void initFetchDataTimer() {
    timer = Timer.periodic(Duration(seconds: 30), (timer) {
      if(isAppInBackground)return;
      print("Fetching market data");
      try {
        fetchMarketByPagination().then((value) {
          notifyListeners();
        });
      }catch(e){}
    });
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

  sortMarketData() {
    if (currentSortFilter == SortMarket.Gainer) {
      marketItemList.sort((a, b) {
        return (b.priceChangePercentage24h
            .compareTo(a.priceChangePercentage24h));
      });
    } else if (currentSortFilter == SortMarket.Loser) {
      marketItemList.sort((a, b) {
        return (a.priceChangePercentage24h
            .compareTo(b.priceChangePercentage24h));
      });
    } else if (currentSortFilter == SortMarket.Rank) {
      marketItemList.sort((a, b) {
        return (a.marketCapRank.compareTo(b.marketCapRank));
      });
    }
  }

  selectSortingFilter() {
    if (currentSortFilter == SortMarket.Rank) {
      currentSortFilter = SortMarket.Gainer;
      marketFilterName = "लाभ";
    } else if (currentSortFilter == SortMarket.Gainer) {
      currentSortFilter = SortMarket.Loser;
      marketFilterName = "हानि";
    } else {
      currentSortFilter = SortMarket.Rank;
      marketFilterName = "रैंक";
    }
    sortMarketData();
    notifyListeners();
  }

  Future fetchMarketByPagination({bool appendInEnd = true}) async {
    isLoading = true;
    notifyListeners();
    marketItemList =
        await MarketService().fetchMarketByPagination(appendInEnd: appendInEnd);
    sortMarketData();
    isLoading = false;
    notifyListeners();
  }

  void onRefresh(RefreshController refreshController) async {
    await fetchMarketByPagination(appendInEnd: false);
    refreshController.refreshCompleted();
  }

  void dispose() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
  }
}
