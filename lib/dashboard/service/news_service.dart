import 'dart:async';

import 'package:connectivity/connectivity.dart';
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
    PushNotificationService();
    SavedDbService();
  }

  Future<List<NewsItem>> fetchNewsByPagination(
      {bool appendInEnd = true}) async {
    if (isNetConnected) {
      List<NewsItem> itemList = await NewsFirebaseService()
          .fetchNewsByPagination(appendInEnd: appendInEnd);
      if (appendInEnd) {
        newsItemList.addAll(itemList);
      } else {
        newsItemList.setAll(0, itemList);
      }
      return newsItemList;
    } else {
      AppUtils.showToast("Internet not available");
    }
    return newsItemList;
  }

  List<NewsItem> getFetchedNews(){
    return newsItemList;
  }

  Future<List<NewsItem>> fetchFeaturedNews()async{
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
}
