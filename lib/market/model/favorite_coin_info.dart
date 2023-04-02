import 'package:flutter/foundation.dart';

class FavoriteCoinInfo {
  String id;
  String symbol;

  FavoriteCoinInfo({@required this.id,@required this.symbol});

  FavoriteCoinInfo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    symbol = map['symbol'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "symbol": symbol,
    };
  }
}
