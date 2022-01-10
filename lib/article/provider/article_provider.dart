import 'package:crypto_khabar/article/model/article.dart';
import 'package:crypto_khabar/article/service/article_service.dart';
import 'package:flutter/material.dart';

class ArticleProvider extends ChangeNotifier {
  List<Article> _articleList = [];

  List<Article> get articleList => _articleList;

  bool isLoading = false;

  ArticleProvider() {
    fetchNewsByPagination();
  }

  Future fetchNewsByPagination() async {
    // isLoading = true;
    //notifyListeners();
    final articleList = await ArticleService().fetchArticleByPagination();
  //  if (_articleList.length != articleList.length) {
      _articleList = articleList;
      notifyListeners();
    //}
    //  isLoading = false;
    // notifyListeners();
  }
}
