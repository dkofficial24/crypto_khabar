import 'package:crypto_khabar/article/model/article.dart';
import 'package:crypto_khabar/article/service/article_service.dart';
import 'package:flutter/material.dart';

class ArticleProvider extends ChangeNotifier {
  List<Article> _articleList = [];

  List<Article> get articleList => _articleList;

  bool isLoading = false;

  ArticleProvider(){
    fetchNewsByPagination();
  }

  Future fetchNewsByPagination() async {
    isLoading = true;
    notifyListeners();
    _articleList = await ArticleService().fetchArticleByPagination();
    isLoading = false;
    notifyListeners();
  }
}
