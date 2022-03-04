import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_khabar/article/model/article.dart';
import 'package:crypto_khabar/shared/firebase_service/article_firebase_service.dart';
import 'package:crypto_khabar/utils/app_utils.dart';

class ArticleService {
  static final ArticleService _instance = ArticleService._();

  ArticleService._();

  factory ArticleService() {
    return _instance;
  }

  QueryDocumentSnapshot last;
  bool isNetConnected = true;

  List<Article> articleList = [];

  Future<List<Article>> fetchArticleByPagination({bool appendInEnd}) async {
    if (isNetConnected) {
      List<Article> itemList =
      await _fetchArticleByPagination(appendInEnd: appendInEnd);
      if (appendInEnd) {
        articleList.addAll(itemList);
      } else {
        articleList.setAll(0, itemList);
      }
      return articleList;
      articleList.addAll(itemList);
      return articleList;
    } else {
      AppUtils.showToast("Internet not available");
    }
    return articleList;
  }

  Future<List<Article>> _fetchArticleByPagination(
      {bool appendInEnd = true}) async {
    List<Article> articleList = [];
    CollectionReference articleRef =
    FirebaseFirestore.instance.collection("article");
    QuerySnapshot data;

    if (last == null || !appendInEnd) {
      data = await articleRef.orderBy("date", descending: true).limit(20).get();
    } else {
      data = await articleRef
          .orderBy("date", descending: true)
          .limit(4)
          .startAfterDocument(last)
          .get();
    }
    if (data != null && data.docs.length > 0) {
      last = data.docs[data.docs.length - 1];
      data.docs.forEach((element) {
        if (element.exists) {
          articleList.add(Article.fromJson(element.data()));
        }
      });
    }

    return articleList;
  }

  Future saveArticle(Article article) async {}
}
