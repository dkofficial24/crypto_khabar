import 'dart:async';

import 'package:crypto_khabar/market/model/favorite_coin_info.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MarketDbService {
  static MarketDbService? _instance;
  Completer<bool> completer = Completer<bool>();

  MarketDbService._internal() {
    init();
  }

  factory MarketDbService() {
    if (_instance == null) {
      _instance = MarketDbService._internal();
    }
    return _instance!;
  }

  final String tableName = "FavoriteCoinTable";
  Database? database;

  Future init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'market_db.db');

    database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute("create table $tableName (id String, symbol String primary key)");
      // print("Table created !");
    });
    completer.complete(true);
  }

  Future<bool> markCoinAsFavorite(FavoriteCoinInfo favoriteCoin) async {
    try {
      if (database != null) {
        //database.insert(tableName, newsItem.toJson());
        database!.rawInsert("insert or replace into $tableName values(?,?)",
            [favoriteCoin.id, favoriteCoin.symbol]);
        FirebaseAnalytics.instance.logEvent(
            name: 'fav_coin_${favoriteCoin.symbol}');
        return true;
      }
    } catch (e) {
      //  print("SavedDbService saveNews $e");
    }
    return false;
  }

  Future<List<FavoriteCoinInfo>> getAllFavoriteCoins() async {
    if (!completer.isCompleted) {
      await completer.future;
    }
    if (database == null) return [];
    List<Map<String, dynamic>> mapList =
        await database!.rawQuery("Select * from $tableName");

    if (mapList.isEmpty) {
      return [];
    }

    List<FavoriteCoinInfo> favoriteCoins = [];
    mapList.forEach((map) {
      favoriteCoins.add(FavoriteCoinInfo.fromMap(map));
    });
    return favoriteCoins;
  }

  Future removeCoinFromFavorite(String symbol) async {
    await database!.rawDelete("delete from $tableName where symbol=?", [symbol]);
  }
}
