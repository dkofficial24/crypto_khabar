import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:uuid/uuid.dart';

class NewsFirebaseService {
  NewsFirebaseService._internal();

  static NewsFirebaseService _newsService = NewsFirebaseService._internal();

  factory NewsFirebaseService() {
    return _newsService;
  }

  QueryDocumentSnapshot last;

  Future<NewsItem> fetchNewsById(String id) async {
    CollectionReference newsRef = FirebaseFirestore.instance.collection("news");
    QuerySnapshot data = await newsRef
        .where('id', isEqualTo: id)
        .orderBy('date', descending: true)
        .get();
    if (data != null && data.docs.length > 0) {
      return NewsItem.fromJson(data.docs[0].data());
    }
    throw Exception("No such id exists");
  }

  Future<List<NewsItem>> fetchNewsByPagination() async {
    List<NewsItem> newsItemList = [];
    CollectionReference newsRef = FirebaseFirestore.instance.collection("news");
    QuerySnapshot data;

    if (last == null) {
      data = await newsRef.orderBy('date', descending: true).limit(5).get();
    } else {
      data = await newsRef
          .orderBy("date", descending: true)
          .limit(3)
          .startAfterDocument(last)
          .get();
    }
    if (data != null && data.docs.length > 0) {
      last = data.docs[data.docs.length - 1];
      data.docs.forEach((element) {
        if (element.exists) {
          newsItemList.add(NewsItem.fromJson(element.data()));
        }
      });
    }

    return newsItemList;
  }
}
