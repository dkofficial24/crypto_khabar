class MarketItem {
  String id;
  String symbol;
  String name;
  String image;
  num currentPrice;
  num marketCap;
  num marketCapRank;
  num fullyDilutedValuation;
  num totalVolume;
  num high24h;
  num low24h;
  num priceChange24h;
  num priceChangePercentage24h;
  num marketCapChange24h;
  num marketCapChangePercentage24h;
  num circulatingSupply;
  num totalSupply;
  num maxSupply;
  num ath;
  num athChangePercentage;
  String athDate;
  num atl;
  num atlChangePercentage;
  String atlDate;
  Map<String, dynamic> roi;
  String lastUpdated;
  bool isFavorite = false;

  MarketItem({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.fullyDilutedValuation,
    required this.totalVolume,
    required this.high24h,
    required this.low24h,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.marketCapChange24h,
    required this.marketCapChangePercentage24h,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    required this.ath,
    required this.athChangePercentage,
    required this.athDate,
    required this.atl,
    required this.atlChangePercentage,
    required this.atlDate,
    required this.roi,
    required this.lastUpdated,
  });

  factory MarketItem.fromJson(Map<String, dynamic> json) {
    return MarketItem(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      currentPrice: json['current_price'] ?? 0,
      marketCap: json['market_cap'] ?? 0,
      marketCapRank: json['market_cap_rank'] ?? 0,
      fullyDilutedValuation: json['fully_diluted_valuation'] ?? 0,
      totalVolume: json['total_volume'] ?? 0,
      high24h: json['high_24h'] ?? 0,
      low24h: json['low_24h'] ?? 0,
      priceChange24h: json['price_change_24h'] ?? 0,
      priceChangePercentage24h: json['price_change_percentage_24h'] ?? 0,
      marketCapChange24h: json['market_cap_change_24h'] ?? 0,
      marketCapChangePercentage24h: json['market_cap_change_percentage_24h'] ?? 0,
      circulatingSupply: json['circulating_supply'] ?? 0,
      totalSupply: json['total_supply'] ?? 0,
      maxSupply: json['max_supply'] ?? 0,
      ath: json['ath'] ?? 0,
      athChangePercentage: json['ath_change_percentage'] ?? 0,
      athDate: json['ath_date'] ?? '',
      atl: json['atl'] ?? 0,
      atlChangePercentage: json['atl_change_percentage'] ?? 0,
      atlDate: json['atl_date'] ?? '',
      roi: json['roi'] ?? <String, dynamic>{},
      lastUpdated: json['last_updated'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'fully_diluted_valuation': fullyDilutedValuation,
      'total_volume': totalVolume,
      'high_24h': high24h,
      'low_24h': low24h,
      'price_change_24h': priceChange24h,
      'price_change_percentage_24h': priceChangePercentage24h,
      'market_cap_change_24h': marketCapChange24h,
      'market_cap_change_percentage_24h': marketCapChangePercentage24h,
      'circulating_supply': circulatingSupply,
      'total_supply': totalSupply,
      'max_supply': maxSupply,
      'ath': ath,
      'ath_change_percentage': athChangePercentage,
      'ath_date': athDate,
      'atl': atl,
      'atl_change_percentage': atlChangePercentage,
      'atl_date': atlDate,
      'roi': roi,
      'last_updated': lastUpdated,
    };
  }
}
