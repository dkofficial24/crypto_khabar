import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';

class NewsService {

  NewsService._internal(){
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
    });
  }

  static final NewsService _newsService = NewsService._internal();

  factory NewsService() {
    return _newsService;
  }

  Future<List<NewsItem>> fetchNews() async {
    List<NewsItem> newsItemList = [];


    return newsItemList;
  }
}
