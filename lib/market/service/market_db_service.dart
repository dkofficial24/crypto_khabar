import 'dart:async';

import 'package:crypto_khabar/market/model/favorite_coin_info.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MarketDbService {

  factory MarketDbService() {
    _instance ??= MarketDbService._internal();
    return _instance;
  }

  MarketDbService._internal() {
    init();
  }
  static MarketDbService _instance;
  Completer<bool> completer = Completer<bool>();

  final String tableName = 'FavoriteCoinTable';
  Database database;

  Future init() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'market_db.db');

    database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('create table $tableName (id String, symbol String primary key)');
      // print("Table created !");
    },);
    completer.complete(true);
  }

  Future<bool> markCoinAsFavorite(FavoriteCoinInfo favoriteCoin) async {
    try {
      if (database != null) {
        //database.insert(tableName, newsItem.toJson());
        await database.rawInsert('insert or replace into $tableName values(?,?)',
            [favoriteCoin.id, favoriteCoin.symbol],);
        await FirebaseAnalytics.instance.logEvent(
            name: 'fav_coin_${favoriteCoin.symbol}',);
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
    final List<Map<String, dynamic>> mapList =
        await database.rawQuery('Select * from $tableName');

    if (mapList == null) {
      return [];
    }

    final favoriteCoins = <FavoriteCoinInfo>[];
    for (final map in mapList) {
      favoriteCoins.add(FavoriteCoinInfo.fromMap(map));
    }
    return favoriteCoins;
  }

  Future removeCoinFromFavorite(String symbol) async {
    await database.rawDelete('delete from $tableName where symbol=?', [symbol]);
  }
}
