import 'dart:async';

import 'package:crypto_khabar/ad/service/ad_helper.dart';
import 'package:crypto_khabar/constants.dart';
import 'package:crypto_khabar/market/model/market_model.dart';
import 'package:crypto_khabar/market/service/market_db_service.dart';
import 'package:crypto_khabar/market/service/market_service.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum SortMarket { Rank, Gainer, Loser }

class MarketProvider extends ChangeNotifier {
  List<MarketItem> marketItemList = [];
  List<MarketItem> favoriteCoinsData = [];
  bool isLoading = false;
  bool shimmer = false;
  bool isBannerAdReady = false;
  BannerAd bannerAd;
  Timer timer;
  MarketService marketService;

  SortMarket currentSortFilter = SortMarket.Rank;
  String marketFilterName = "रैंक";
  IconData filterIconData = Icons.arrow_circle_up;
  MarketDbService marketDbService;

  MarketProvider(MarketDbService marketDbService, MarketService marketService) {
    this.marketDbService = marketDbService;
    this.marketService = marketService;
    shimmer = true;
    notifyListeners();
    fetchAllMarketData().then((value) {
      shimmer = false;
      notifyListeners();
    });
    marketService.loadFavoriteCoinsData().then((value) {
      notifyListeners();
    });
    initFetchDataTimer();
    //  initAd();
  }

  void initFetchDataTimer() {
    timer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (isAppInBackground) return;
      print("Fetching market data");
      try {
        fetchAllMarketData().then((value) {
          notifyListeners();
        });
      } catch (e) {}
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

      favoriteCoinsData.sort((a, b) {
        return (b.priceChangePercentage24h
            .compareTo(a.priceChangePercentage24h));
      });


    } else if (currentSortFilter == SortMarket.Loser) {
      marketItemList.sort((a, b) {
        return (a.priceChangePercentage24h
            .compareTo(b.priceChangePercentage24h));
      });

      favoriteCoinsData.sort((a, b) {
        return (a.priceChangePercentage24h
            .compareTo(b.priceChangePercentage24h));
      });
    } else if (currentSortFilter == SortMarket.Rank) {
      marketItemList.sort((a, b) {
        return (a.marketCapRank.compareTo(b.marketCapRank));
      });

      favoriteCoinsData.sort((a, b) {
        return (a.marketCapRank.compareTo(b.marketCapRank));
      });
    }
  }

  selectSortingFilter() {
    if (currentSortFilter == SortMarket.Rank) {
      currentSortFilter = SortMarket.Gainer;
      marketFilterName = "लाभ";
      filterIconData = Icons.add;
    } else if (currentSortFilter == SortMarket.Gainer) {
      currentSortFilter = SortMarket.Loser;
      marketFilterName = "हानि";
      filterIconData = Icons.remove;
    } else {
      currentSortFilter = SortMarket.Rank;
      marketFilterName = "रैंक";
      filterIconData = Icons.arrow_circle_up;
    }
    sortMarketData();
    notifyListeners();
  }

  Future fetchAllMarketData({bool appendInEnd = true}) async {
    isLoading = true;
    notifyListeners();
    marketItemList =
        await marketService.fetchAllMarketData(appendInEnd: appendInEnd);
    marketService.refreshFavoriteData();
    await marketService.loadFavoriteCoinsData();
    favoriteCoinsData = marketService.getFavoriteCoinData();
    sortMarketData();
    isLoading = false;
    notifyListeners();
  }

  void onRefresh(RefreshController refreshController) async {
    await fetchAllMarketData(appendInEnd: false);
    refreshController.refreshCompleted();
  }

  Future markCoinFavorite(MarketItem favoriteCoin) async {
    marketService.markCoinAsFavorite(favoriteCoin);
    favoriteCoinsData = marketService.getFavoriteCoinData();
    AppUtils.showToast("कॉइन फेवरेट लिस्ट में जोड़ दिया गया");
    notifyListeners();
  }

  Future removeCoinFromFavorite(MarketItem marketItem) async {
    marketService.removeCoinFromFavorite(marketItem);
    favoriteCoinsData = marketService.getFavoriteCoinData();
    AppUtils.showToast("कॉइन फेवरेट लिस्ट से हटा दिया गया");
    notifyListeners();
  }

  void dispose() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
  }
}
