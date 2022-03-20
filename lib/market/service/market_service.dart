import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:crypto_khabar/market/model/market_model.dart';
import 'package:crypto_khabar/shared/firebase_service/market_firebase_service.dart';
import 'package:crypto_khabar/utils/app_utils.dart';

class MarketService {
  MarketService._internal() {
    init();
  }

  static final MarketService _marketService = MarketService._internal();

  factory MarketService() {
    return _marketService;
  }

  List<MarketItem> marketItemList = [];
  StreamSubscription subscription;
  bool isNetConnected = true;

  void init() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        isNetConnected = true;
      } else {
        isNetConnected = false;
      }
    });
  }

  Future<List<MarketItem>> fetchMarketByPagination(
      {bool appendInEnd = true}) async {
    if (isNetConnected) {
      List<MarketItem> marketList =
          await MarketFirebaseService().fetchMarketByPagination();
      marketItemList.clear();
      marketItemList.addAll(marketList);
      return marketItemList;
    } else {
      AppUtils.showToast("Internet not available");
    }
    return marketItemList;
  }
}
