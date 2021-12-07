import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/shared/news_firebase_service.dart';
import 'package:crypto_khabar/utils/app_utils.dart';

class NewsService {

  NewsService._internal(){
    init();
  }

  static final NewsService _newsService = NewsService._internal();

  factory NewsService() {
    return _newsService;
  }

  List<NewsItem> newsItemList = [];
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

  Future<List<NewsItem>> fetchNewsByPagination() async {
    if (isNetConnected) {
      List<NewsItem> itemList =
      await NewsFirebaseService().fetchNewsByPagination();
      newsItemList.addAll(itemList);
      return newsItemList;
    } else {
      AppUtils.showToast("Internet not available");
    }
    return newsItemList;
  }
}
