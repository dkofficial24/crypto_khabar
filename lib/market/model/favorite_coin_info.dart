import 'package:flutter/foundation.dart';

class FavoriteCoinInfo {

  FavoriteCoinInfo({@required this.id,@required this.symbol});

  FavoriteCoinInfo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    symbol = map['symbol'];
  }
  String id;
  String symbol;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'symbol': symbol,
    };
  }
}
