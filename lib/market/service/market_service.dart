import 'dart:async';

import 'package:crypto_khabar/dashboard/service/news_service.dart';
import 'package:crypto_khabar/market/model/favorite_coin_info.dart';
import 'package:crypto_khabar/market/model/market_model.dart';
import 'package:crypto_khabar/market/service/market_db_service.dart';
import 'package:crypto_khabar/shared/firebase_service/market_firebase_service.dart';
import 'package:crypto_khabar/utils/app_utils.dart';

class MarketService {
  late MarketDbService marketDbService;

  MarketService._internal() {
    init();
  }

  static final MarketService _marketService = MarketService._internal();

  factory MarketService() {
    return _marketService;
  }

  List<MarketItem> _marketItemList = [];
  List<FavoriteCoinInfo> favoriteCoinInfoList = [];

  List<MarketItem> getMarketData() => _marketItemList;

  List<MarketItem> getFavoriteCoinData() =>
      _marketItemList.where((element) => element.isFavorite).toList();

  void init() {
    try {
      marketDbService = MarketDbService();
      //loadFavoriteCoinsData();
    } catch (e) {
      print("$e");
    }
  }

  Future<List<MarketItem>> fetchAllMarketData({bool appendInEnd = true}) async {
    if (NewsService().netConnectionStatus) {
      List<MarketItem> marketList =
          await MarketFirebaseService().fetchAllMarketData();
      _marketItemList.clear();
      _marketItemList.addAll(marketList);
      return _marketItemList;
    } else {
      AppUtils.showToast("इंटरनेट उपलब्ध नहीं है।");
    }
    return _marketItemList;
  }

  refreshFavoriteData() {
    try {
      favoriteCoinInfoList.forEach((item) {
        MarketItem marketItem = _marketItemList
            .firstWhere((element) => item.symbol == element.symbol);
        marketItem.isFavorite = true;
      });
    }catch(e){}
  }

  Future loadFavoriteCoinsData() async {
    favoriteCoinInfoList = await marketDbService.getAllFavoriteCoins();
    refreshFavoriteData();
  }

  Future markCoinAsFavorite(MarketItem marketItem) async {
    marketItem.isFavorite = true;
    favoriteCoinInfoList
        .add(FavoriteCoinInfo(id: marketItem.id, symbol: marketItem.symbol));
    await marketDbService.markCoinAsFavorite(
        FavoriteCoinInfo(id: marketItem.id, symbol: marketItem.symbol));
  }

  Future removeCoinFromFavorite(MarketItem marketItem) async {
    marketItem.isFavorite = false;
    favoriteCoinInfoList
        .removeWhere((element) => element.symbol == marketItem.symbol);
    await marketDbService.removeCoinFromFavorite(marketItem.symbol);
  }
}
