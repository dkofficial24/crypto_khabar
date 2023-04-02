import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_khabar/article/model/article.dart';
import 'package:crypto_khabar/dashboard/service/news_service.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:crypto_khabar/utils/string_const.dart';

class ArticleService {

  factory ArticleService() {
    return _instance;
  }

  ArticleService._();
  static final ArticleService _instance = ArticleService._();
  QueryDocumentSnapshot last;

  List<Article> articleList = [];

  Future<List<Article>> fetchArticleByPagination({bool appendInEnd}) async {
    if (NewsService().netConnectionStatus) {
      final itemList =
      await _fetchArticleByPagination(appendInEnd: appendInEnd);
      if (appendInEnd) {
        articleList.addAll(itemList);
      } else {
        articleList.setAll(0, itemList);
      }
      return articleList;
    } else {
      AppUtils.showToast(StringConst.noInternet);
    }
    return articleList;
  }

  Future<List<Article>> _fetchArticleByPagination(
      {bool appendInEnd = true,}) async {
    final articleList = <Article>[];
    final CollectionReference articleRef =
    FirebaseFirestore.instance.collection('article');
    QuerySnapshot data;

    if (last == null || !appendInEnd) {
      data = await articleRef.orderBy('date', descending: true).limit(20).get();
    } else {
      data = await articleRef
          .orderBy('date', descending: true)
          .limit(4)
          .startAfterDocument(last)
          .get();
    }
    if (data != null && data.docs.isNotEmpty) {
      last = data.docs[data.docs.length - 1];
      for (final element in data.docs) {
        if (element.exists) {
          articleList.add(Article.fromJson(element.data()));
        }
      }
    }

    return articleList;
  }

  Future saveArticle(Article article) async {}
}
