import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_khabar/market/model/market_model.dart';

class MarketFirebaseService {

  factory MarketFirebaseService() {
    return _marketFirebaseService;
  }
  MarketFirebaseService._internal();

  static final MarketFirebaseService _marketFirebaseService =
      MarketFirebaseService._internal();

  Future<List<MarketItem>> fetchAllMarketData(
      {bool appendInEnd = true,}) async {
    final DocumentSnapshot docRef = await FirebaseFirestore.instance
        .collection('exchange')
        .doc('data')
        .get();
    final List mapList = docRef.get('items');
    final marketItemList = <MarketItem>[];

    for (final element in mapList) {
      final item = MarketItem.fromJson(element);
      marketItemList.add(item);
    }
    return marketItemList;
  }
}
