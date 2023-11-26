class FavoriteCoinInfo {
  String id;
  String symbol;

  FavoriteCoinInfo({
    required this.id,
    required this.symbol,
  });

  FavoriteCoinInfo.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        symbol = map['symbol'] as String;

  Map<String, String> toMap() {
    return {
      "id": id,
      "symbol": symbol,
    };
  }
}
