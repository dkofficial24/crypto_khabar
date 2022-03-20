import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:crypto_khabar/dashboard/service/news_service.dart';
import 'package:crypto_khabar/market/model/market_model.dart';
import 'package:crypto_khabar/shared/firebase_service/market_firebase_service.dart';
import 'package:crypto_khabar/utils/app_utils.dart';

class MarketService {
  MarketService._internal() {
  }

  static final MarketService _marketService = MarketService._internal();

  factory MarketService() {
    return _marketService;
  }

  List<MarketItem> marketItemList = [];


  Future<List<MarketItem>> fetchMarketByPagination(
      {bool appendInEnd = true}) async {
    if (NewsService().netConnectionStatus) {
      List<MarketItem> marketList =
          await MarketFirebaseService().fetchMarketByPagination();
      marketItemList.clear();
      marketItemList.addAll(marketList);
      return marketItemList;
    } else {
      AppUtils.showToast("इंटरनेट उपलब्ध नहीं है।");
    }
    return marketItemList;
  }
}
