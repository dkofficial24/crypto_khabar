import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_khabar/market/model/market_model.dart';

class MarketFirebaseService {
  MarketFirebaseService._internal();

  static MarketFirebaseService _marketFirebaseService =
      MarketFirebaseService._internal();

  factory MarketFirebaseService() {
    return _marketFirebaseService;
  }

  Future<List<MarketItem>> fetchAllMarketData(
      {bool appendInEnd = true}) async {
    DocumentSnapshot docRef = await FirebaseFirestore.instance
        .collection("exchange")
        .doc("data")
        .get();
    List mapList = docRef.get("items");
    List<MarketItem> marketItemList = [];

    mapList.forEach((element) {
      MarketItem item = MarketItem.fromJson(element);
      marketItemList.add(item);
    });
    print("");
    return marketItemList;
  }
}
