import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/service/news_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NewsDbService{

  factory NewsDbService() {
    _instance ??= NewsDbService._internal();
    return _instance;
  }

  NewsDbService._internal() {
    init();
  }

  static NewsDbService _instance;

  final String tableName = 'SavedNewsTable';
  Database database;

  Future init() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'saved_news_db4.db');

    database =
    await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          'create table $tableName (id String primary key,title text,details text,date integer,author text,source text,imgUrl text,category text,sourceLink text)',);
     // print("Table created !");
    },);
    await NewsService().loadAllSavedNewsId();
  }

  Future<bool> saveNews(NewsItem newsItem) async {
    try {
      if (database != null) {
        //database.insert(tableName, newsItem.toJson());
        await database.rawInsert('insert or replace into $tableName values(?,?,?,?,?,?,?,?,?)',[newsItem.id,newsItem.title,newsItem.details,newsItem.date,newsItem.author,
          newsItem.source,newsItem.imgUrl,newsItem.category,newsItem.sourceLink,]);
       // print("SavedDbService saveNews successfully");
        await FirebaseAnalytics.instance.logEvent(name: 'save_news',parameters: {
          'save_news':newsItem.title
        },);
        return true;
      }
    } catch (e) {
    //  print("SavedDbService saveNews $e");
    }
    return false;
  }

  Future<List<NewsItem>> getAllSavedNews() async {
    if (database == null) return [];
    final List<Map<String, dynamic>> mapList =
    await database.rawQuery('Select * from $tableName');

    if (mapList == null) {
      return [];
    }

    final newsList = <NewsItem>[];
    for (final map in mapList) {
      newsList.add(NewsItem.fromJson(map));
    }
    return newsList;
  }

  Future removeSavedNews(String id)async{
    await database.rawDelete('delete from $tableName where id=?',[id]);
  //  print("removed Saved News !");
  }


}