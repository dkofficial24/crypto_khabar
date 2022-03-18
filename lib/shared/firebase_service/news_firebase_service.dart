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
  QueryDocumentSnapshot featuredLast;

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

  Future<List<NewsItem>> fetchNewsByPagination({bool appendInEnd=true}) async {
    List<NewsItem> newsItemList = [];
    CollectionReference newsRef = FirebaseFirestore.instance.collection("news");
    QuerySnapshot data;

    if (last == null || !appendInEnd) {
      data = await newsRef.orderBy('date', descending: true).limit(8).get();
    } else {
      data = await newsRef
          .orderBy("date", descending: true)
          .limit(6)
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

  Future<List<NewsItem>> fetchFeaturedNews() async {
    List<NewsItem> newsItemList = [];
    CollectionReference newsRef = FirebaseFirestore.instance.collection("feature_news");
    QuerySnapshot data;

    data = await newsRef.orderBy('date', descending: true).limit(5).get();

    if (data != null && data.docs.length > 0) {
      featuredLast = data.docs[data.docs.length - 1];
      data.docs.forEach((element) {
        if (element.exists) {
          newsItemList.add(NewsItem.fromJson(element.data()));
        }
      });
    }

    return newsItemList;
  }

  incrementView (String id)async{
    final DocumentReference ref = FirebaseFirestore.instance.collection('news_content').doc(id);
    Future.delayed(Duration(seconds: 2)).then((value) async{
      await getLatestViewCount(id).then((int latestCount) async{
        if(latestCount == 0){
          await ref.set({
            "views":1
          });
        }else {
          await ref.update({
            'views': latestCount + 1,
          });
        }
      });
    });
  }

  Future<int> getLatestViewCount (String id) async {
    // if(widget.article.views != null){
    final String fieldName = 'views';
    final DocumentReference ref = FirebaseFirestore.instance.collection('news_content').doc(id);
    DocumentSnapshot snap = await ref.get();
    int itemCount ;
    try {
       itemCount = snap[fieldName] ?? 0;
    }catch(e){
      itemCount = 0;
    }
    return itemCount;
  }
}
