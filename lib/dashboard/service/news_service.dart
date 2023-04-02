import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/service/saved_db_service.dart';
import 'package:crypto_khabar/shared/firebase_service/firebase_push_notification_service.dart';
import 'package:crypto_khabar/shared/firebase_service/news_firebase_service.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:crypto_khabar/utils/string_const.dart';

class NewsService {

  factory NewsService() {
    return _newsService;
  }
  NewsService._internal() {
    init();
  }

  static final NewsService _newsService = NewsService._internal();

  Set<String> bookmarkedNewsIdSet = {};

  List<NewsItem> newsItemList = [];
  StreamSubscription subscription;
  bool _isNetConnected = true;

  bool get netConnectionStatus => _isNetConnected;

  void init() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        _isNetConnected = true;
      } else {
        _isNetConnected = false;
      }
    });
    PushNotificationService();
    NewsDbService();
  }

  Future<bool> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<List<NewsItem>> fetchNewsByPagination(
      {bool appendInEnd = true,}) async {
    if(!_isNetConnected){
      _isNetConnected = await checkConnectivity();
    }
    if (_isNetConnected) {
      final itemList = await NewsFirebaseService()
          .fetchNewsByPagination(appendInEnd: appendInEnd);
      if (appendInEnd) {
        newsItemList.addAll(itemList);
      } else {
        newsItemList.setAll(0, itemList);
      }
      removeDuplicateNews();
      return newsItemList;
    } else {
      AppUtils.showToast(StringConst.noInternet);
    }

    return newsItemList;
  }

  removeDuplicateNews() {
    final idCache = <String>[];
    var newsItemList = <NewsItem>[];

    for (final element in newsItemList) {
      if (!idCache.contains(element.id)) {
        idCache.add(element.id);
        newsItemList.add(element);
      }
    }
    newsItemList.clear();
    newsItemList = newsItemList;
  }

  List<NewsItem> getFetchedNews() {
    return newsItemList;
  }

  Future<List<NewsItem>> fetchFeaturedNews() async {
    return await NewsFirebaseService().fetchFeaturedNews();
  }

  Future<bool> saveNews(NewsItem newsItem) async {
    markNewsItemSaved(newsItem.id);
    return await NewsDbService().saveNews(newsItem);
  }

  Future<List<NewsItem>> getAllSavedNews() async {
    return await NewsDbService().getAllSavedNews();
  }

  Future removeSavedNews(String id) async {
    removeNewsItemFromBookmark(id);
    await NewsDbService().removeSavedNews(id);
  }

  Future loadAllSavedNewsId() async {
    final listNews = await getAllSavedNews();
    bookmarkedNewsIdSet.clear();
    for (final newsItem in listNews) {
      bookmarkedNewsIdSet.add(newsItem.id);
    }
  }

  void markNewsItemSaved(String id) {
    bookmarkedNewsIdSet.add(id);
  }

  void removeNewsItemFromBookmark(String id) {
    bookmarkedNewsIdSet.remove(id);
  }

  bool isNewsBookmarked(String id) {
    return bookmarkedNewsIdSet.contains(id);
  }

  incrementView(String id) async {
    await NewsFirebaseService().incrementView(id);
  }

  incrementShareCount(String id) async {
    await NewsFirebaseService().incrementShareCount(id);
  }

  Future<NewsItem> fetchNewsById(String id) async {
    final newsItem = await NewsFirebaseService().fetchNewsById(id);
    newsItemList.insert(0, newsItem);
    return newsItem;
  }
}
