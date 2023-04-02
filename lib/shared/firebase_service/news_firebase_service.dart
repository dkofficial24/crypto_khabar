import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';

class NewsFirebaseService {

  factory NewsFirebaseService() {
    return _newsService;
  }
  NewsFirebaseService._internal();

  static final NewsFirebaseService _newsService = NewsFirebaseService._internal();

  QueryDocumentSnapshot last;
  QueryDocumentSnapshot featuredLast;

  Future<NewsItem> fetchNewsById(String id) async {
    final CollectionReference newsRef = FirebaseFirestore.instance.collection('news');
    final data = await newsRef
        .where('id', isEqualTo: id)
        .orderBy('date', descending: true)
        .get();
    if (data != null && data.docs.isNotEmpty) {
      return NewsItem.fromJson(data.docs[0].data());
    }
    throw Exception('No such id exists');
  }

  Future<List<NewsItem>> fetchNewsByPagination({bool appendInEnd=true}) async {
    final newsItemList = <NewsItem>[];
    final CollectionReference newsRef = FirebaseFirestore.instance.collection('news');
    QuerySnapshot data;

    if (last == null || !appendInEnd) {
      data = await newsRef.orderBy('date', descending: true).limit(8).get();
    } else {
      data = await newsRef
          .orderBy('date', descending: true)
          .limit(6)
          .startAfterDocument(last)
          .get();
    }
    if (data != null && data.docs.isNotEmpty) {
      last = data.docs[data.docs.length - 1];
      for (final element in data.docs) {
        if (element.exists) {
          newsItemList.add(NewsItem.fromJson(element.data()));
        }
      }
    }
    return newsItemList;
  }

  Future<List<NewsItem>> fetchFeaturedNews() async {
    final newsItemList = <NewsItem>[];
    final CollectionReference newsRef = FirebaseFirestore.instance.collection('feature_news');
    QuerySnapshot data;

    data = await newsRef.orderBy('date', descending: true).limit(5).get();

    if (data != null && data.docs.isNotEmpty) {
      featuredLast = data.docs[data.docs.length - 1];
      for (final element in data.docs) {
        if (element.exists) {
          newsItemList.add(NewsItem.fromJson(element.data()));
        }
      }
    }

    return newsItemList;
  }

  incrementView (String id)async{
    final DocumentReference ref = FirebaseFirestore.instance.collection('news_content').doc(id);
    await Future.delayed(const Duration(seconds: 2)).then((value) async{
      await getLatestViewCount(id).then((int latestCount) async{
        if(latestCount == 0){
          await ref.set({
            'views':1
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
    const fieldName = 'views';
    final DocumentReference ref = FirebaseFirestore.instance.collection('news_content').doc(id);
    final snap = await ref.get();
    int itemCount ;
    try {
       itemCount = snap[fieldName] ?? 0;
    }catch(e){
      itemCount = 0;
    }
    return itemCount;
  }

  incrementShareCount (String id)async{
    final DocumentReference ref = FirebaseFirestore.instance.collection('news_share_counter').doc(id);
    await Future.delayed(const Duration(seconds: 2)).then((value) async{
      await getIncrementShareCount(id).then((int latestCount) async{
        if(latestCount == 0){
          await ref.set({
            'share':1
          });
        }else {
          await ref.update({
            'share': latestCount + 1,
          });
        }
      });
    });
  }

  Future<int> getIncrementShareCount (String id) async {
    // if(widget.article.views != null){
    const fieldName = 'share';
    final DocumentReference ref = FirebaseFirestore.instance.collection('news_share_counter').doc(id);
    final snap = await ref.get();
    int itemCount ;
    try {
      itemCount = snap[fieldName] ?? 0;
    }catch(e){
      itemCount = 0;
    }
    return itemCount;
  }

}
