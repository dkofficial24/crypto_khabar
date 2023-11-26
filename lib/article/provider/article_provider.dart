import 'package:crypto_khabar/article/model/article.dart';
import 'package:crypto_khabar/article/service/article_service.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ArticleProvider extends ChangeNotifier {
  List<Article> _articleList = [];

  List<Article> get articleList => _articleList;
  bool isLoading = false;

  ArticleProvider() {
    fetchNewsByPagination();
  }

  Future fetchNewsByPagination({bool appendInEnd = true}) async {
    isLoading = true;
    notifyListeners();
    final articleList = await ArticleService()
        .fetchArticleByPagination(appendInEnd: appendInEnd);
    _articleList = articleList;
    notifyListeners();
    if (!appendInEnd) {
      _articleList.sort((a, b) {
        return (b.date ?? 0) - (a.date ?? 0);
      });
    }
    notifyListeners();
  }

  void onRefresh(RefreshController refreshController) async {
    await fetchNewsByPagination(appendInEnd: false);
    refreshController.refreshCompleted();
  }
}
