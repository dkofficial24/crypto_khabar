import 'package:broadcast_events/broadcast_events.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/service/news_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../constants.dart';

class TopNewsProvider extends ChangeNotifier {
  List<NewsItem> newsItemList = [];
  List<NewsItem> featuredNewsItemList = [];
  bool isLoading = false;
  bool shimmer = false;
  int carouselCurrentIndex = 0;

  TopNewsProvider() {
    shimmer = true;
    notifyListeners();
    fetchNewsByPagination().then((value) {
      shimmer = false;
      notifyListeners();
    });
    fetchFeaturedNews();
    BroadcastEvents().subscribe(NewsFetched, loadFetchedNews);
  }

  Future fetchNewsByPagination({bool appendInEnd = true}) async {
    isLoading = true;
    notifyListeners();
    newsItemList =
        await NewsService().fetchNewsByPagination(appendInEnd: appendInEnd);
    isLoading = false;
    if (!appendInEnd) {
      newsItemList.sort((a, b) {
        return b.date - a.date;
      });
    }

    notifyListeners();
  }

  loadFetchedNews(_) {
    List<NewsItem> list = NewsService().getFetchedNews();
    newsItemList.clear();
    newsItemList.addAll(list);
    newsItemList.sort((a, b) {
      return b.date - a.date;
    });
    notifyListeners();
  }

  void onRefresh(RefreshController refreshController) async {
    await fetchNewsByPagination(appendInEnd: false);
    fetchFeaturedNews();
    refreshController.refreshCompleted();
  }

  Future fetchFeaturedNews() async {
    try {
      featuredNewsItemList = await NewsService().fetchFeaturedNews();
      notifyListeners();
    } catch (e) {
      print("$e");
    }
  }

  bool savingNews = false;
  bool removingBookmarkNews = false;

  Future bookmarkNews(NewsItem newsItem) async {
    if (!savingNews) {
      savingNews = true;
      notifyListeners();
      try {
        bool status = await NewsService().saveNews(newsItem);
        if (status) {
          //AppUtils.showToast("बुकमार्क हो गयी");
        }
      } catch (e) {
        print("ERROR:$e");
      }
      savingNews = false;
      notifyListeners();
    }
  }

  Future removeBookmarkNews(NewsItem newsItem) async {
    if (!removingBookmarkNews) {
      removingBookmarkNews = true;
      notifyListeners();
      try {
        await NewsService().removeSavedNews(newsItem.id);
      } catch (e) {
        print("ERROR:$e");
      }
      removingBookmarkNews = false;
      notifyListeners();
    }
  }

  bool isNewsBookmarked(String id) {
    return NewsService().isNewsBookmarked(id);
  }

  void updateCarouselCurrentIndex(int index) {
    carouselCurrentIndex = index;
    notifyListeners();
  }
}
