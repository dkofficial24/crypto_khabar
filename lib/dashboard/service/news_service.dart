import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/service/saved_db_service.dart';
import 'package:crypto_khabar/shared/firebase_service/firebase_push_notification_service.dart';
import 'package:crypto_khabar/shared/firebase_service/news_firebase_service.dart';
import 'package:crypto_khabar/utils/app_utils.dart';

class NewsService {
  NewsService._internal() {
    init();
  }

  static final NewsService _newsService = NewsService._internal();

  factory NewsService() {
    return _newsService;
  }

  Set<String> bookmarkedNewsIdSet = Set();

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
    SavedDbService();
  }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<List<NewsItem>> fetchNewsByPagination(
      {bool appendInEnd = true}) async {
    if(!_isNetConnected){
      _isNetConnected = await checkConnectivity();
    }
    if (_isNetConnected) {
      List<NewsItem> itemList = await NewsFirebaseService()
          .fetchNewsByPagination(appendInEnd: appendInEnd);
      if (appendInEnd) {
        newsItemList.addAll(itemList);
      } else {
        newsItemList.setAll(0, itemList);
      }
      removeDuplicateNews();
      return newsItemList;
    } else {
      AppUtils.showToast("इंटरनेट उपलब्ध नहीं है।");
    }

    return newsItemList;
  }

  removeDuplicateNews() {
    List<String> idCache = [];
    List<NewsItem> _newsItemList = [];

    newsItemList.forEach((element) {
      if (!idCache.contains(element.id)) {
        idCache.add(element.id);
        _newsItemList.add(element);
      }
    });
    newsItemList.clear();
    newsItemList = _newsItemList;
  }

  List<NewsItem> getFetchedNews() {
    return newsItemList;
  }

  Future<List<NewsItem>> fetchFeaturedNews() async {
    return await NewsFirebaseService().fetchFeaturedNews();
  }

  Future<bool> saveNews(NewsItem newsItem) async {
    markNewsItemSaved(newsItem.id);
    return await SavedDbService().saveNews(newsItem);
  }

  Future<List<NewsItem>> getAllSavedNews() async {
    return await SavedDbService().getAllSavedNews();
  }

  Future removeSavedNews(String id) async {
    removeNewsItemFromBookmark(id);
    await SavedDbService().removeSavedNews(id);
  }

  Future loadAllSavedNewsId() async {
    List<NewsItem> listNews = await getAllSavedNews();
    bookmarkedNewsIdSet.clear();
    listNews.forEach((newsItem) {
      bookmarkedNewsIdSet.add(newsItem.id);
    });
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
