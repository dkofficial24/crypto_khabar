import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/service/news_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TopNewsProvider extends ChangeNotifier {
  List<NewsItem> newsItemList = [];
  bool isLoading = false;

  TopNewsProvider() {
    loadNews();
  }

  Future loadNews() async {
    isLoading = true;
    notifyListeners();
    newsItemList = await NewsService().fetchNews();
    isLoading = false;
    notifyListeners();
  }

  void onRefresh(RefreshController refreshController) {
    refreshController.refreshCompleted();
  }

  void loadMore() async{}
}
