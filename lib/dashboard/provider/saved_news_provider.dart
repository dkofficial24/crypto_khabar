import 'package:broadcast_events/broadcast_events.dart';
import 'package:crypto_khabar/constants.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/service/news_service.dart';
import 'package:flutter/material.dart';

class SavedNewsProvider extends ChangeNotifier {
  List<NewsItem> newsItemList = [];
  bool isLoading = false;

  SavedNewsProvider() {
    init();
  }

  Future init() async {
    isLoading = true;
    notifyListeners();
    newsItemList = await NewsService().getAllSavedNews();
    isLoading = false;
    notifyListeners();
  }

  Future removeSavedNews(String id) async {
    await NewsService().removeSavedNews(id);
    BroadcastEvents().publish(NewsBookmarkRemove, arguments: null);
  }
}
