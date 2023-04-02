class MarketItem {

  MarketItem(
      {this.id,
      this.symbol,
      this.name,
      this.image,
      this.currentPrice,
      this.marketCap,
      this.marketCapRank,
      this.fullyDilutedValuation,
      this.totalVolume,
      this.high24h,
      this.low24h,
      this.priceChange24h,
      this.priceChangePercentage24h,
      this.marketCapChange24h,
      this.marketCapChangePercentage24h,
      this.circulatingSupply,
      this.totalSupply,
      this.maxSupply,
      this.ath,
      this.athChangePercentage,
      this.athDate,
      this.atl,
      this.atlChangePercentage,
      this.atlDate,
      this.roi,
      this.lastUpdated,});

  MarketItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    symbol = json['symbol'];
    name = json['name'];
    image = json['image'];
    currentPrice = json['current_price'];
    marketCap = json['market_cap'];
    marketCapRank = json['market_cap_rank'];
    fullyDilutedValuation = json['fully_diluted_valuation'];
    totalVolume = json['total_volume'];
    high24h = json['high_24h'];
    low24h = json['low_24h'];
    priceChange24h = json['price_change_24h'];
    priceChangePercentage24h = json['price_change_percentage_24h'];
    marketCapChange24h = json['market_cap_change_24h'];
    marketCapChangePercentage24h = json['market_cap_change_percentage_24h'];
    circulatingSupply = json['circulating_supply'];
    totalSupply = json['total_supply'];
    maxSupply = json['max_supply'];
    ath = json['ath'];
    athChangePercentage = json['ath_change_percentage'];
    athDate = json['ath_date'];
    atl = json['atl'];
    atlChangePercentage = json['atl_change_percentage'];
    atlDate = json['atl_date'];
    roi = json['roi'];
    lastUpdated = json['last_updated'];
  }
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

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['symbol'] = symbol;
    data['name'] = name;
    data['image'] = image;
    data['current_price'] = currentPrice;
    data['market_cap'] = marketCap;
    data['market_cap_rank'] = marketCapRank;
    data['fully_diluted_valuation'] = fullyDilutedValuation;
    data['total_volume'] = totalVolume;
    data['high_24h'] = high24h;
    data['low_24h'] = low24h;
    data['price_change_24h'] = priceChange24h;
    data['price_change_percentage_24h'] = priceChangePercentage24h;
    data['market_cap_change_24h'] = marketCapChange24h;
    data['market_cap_change_percentage_24h'] =
        marketCapChangePercentage24h;
    data['circulating_supply'] = circulatingSupply;
    data['total_supply'] = totalSupply;
    data['max_supply'] = maxSupply;
    data['ath'] = ath;
    data['ath_change_percentage'] = athChangePercentage;
    data['ath_date'] = athDate;
    data['atl'] = atl;
    data['atl_change_percentage'] = atlChangePercentage;
    data['atl_date'] = atlDate;
    data['roi'] = roi;
    data['last_updated'] = lastUpdated;
    return data;
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class ExchangeModel {
//   String name;
//   String shortName;
//   int rank;
//   double currentValue;
//   double marketCap;
//   double grossRate;
//   IconData icon;
//   IconData star;
//   IconData grossIcon;
//
//   ExchangeModel({
//     @required this.name,
//     @required this.shortName,
//     @required this.rank,
//     @required this.currentValue,
//     @required this.marketCap,
//     @required this.grossRate,
//     @required this.icon,
//     @required this.star,
//     @required this.grossIcon,
//   });
// }
//
// List<ExchangeModel> exchangeModelList = <ExchangeModel>[
//   ExchangeModel(
//     name: "Bitcoin",
//     shortName: "BTC",
//     rank: 1,
//     currentValue: 41287.54,
//     marketCap: 783.87,
//     grossRate: 5.46,
//     icon: CupertinoIcons.bitcoin,
//     star: Icons.star_border_outlined,
//     grossIcon: CupertinoIcons.arrowtriangle_up_fill,
//   ),
//   ExchangeModel(
//       name: "Ethereum",
//       shortName: "ETH",
//       rank: 2,
//       currentValue: 2762.76,
//       marketCap: 331.51,
//       grossRate: 5.42,
//       icon: CupertinoIcons.add,
//       grossIcon: CupertinoIcons.arrowtriangle_up_fill,
//       star: Icons.star_border_outlined),
//   ExchangeModel(
//       name: "Tether",
//       shortName: "USDT",
//       rank: 3,
//       currentValue: 1.000,
//       marketCap: 80.148,
//       grossRate: 0.004,
//       icon: CupertinoIcons.drop_triangle,
//       star: Icons.star_border_outlined,
//       grossIcon: CupertinoIcons.arrowtriangle_up_fill),
//   ExchangeModel(
//       name: "BNB",
//       shortName: "BNB",
//       rank: 4,
//       currentValue: 387.14,
//       marketCap: 63.99,
//       grossRate: 5.02,
//       icon: CupertinoIcons.map,
//       grossIcon: CupertinoIcons.arrowtriangle_up_fill,
//       star: Icons.star_border_outlined),
//   ExchangeModel(
//       name: "USD Coin",
//       shortName: "USDT",
//       rank: 5,
//       currentValue: 0.9997,
//       marketCap: 52.46,
//       grossRate: 0.02,
//       icon: CupertinoIcons.money_dollar,
//       star: Icons.star_border_outlined,
//       grossIcon: CupertinoIcons.arrowtriangle_down_fill),
//   ExchangeModel(
//       name: "XRP",
//       shortName: "XRP",
//       rank: 6,
//       currentValue: 0.7916,
//       marketCap: 38.03,
//       grossRate: 0.31,
//       icon: CupertinoIcons.drop,
//       star: Icons.star_border_outlined,
//       grossIcon: CupertinoIcons.arrowtriangle_down_fill),
//   ExchangeModel(
//       name: "Cardano",
//       shortName: "ADA",
//       rank: 7,
//       currentValue: 0.8504,
//       marketCap: 28.66,
//       grossRate: 0.95,
//       icon: CupertinoIcons.shuffle,
//       star: Icons.star_border_outlined,
//       grossIcon: CupertinoIcons.arrowtriangle_down_fill),
//   ExchangeModel(
//       name: "Solana",
//       shortName: "SOL",
//       rank: 8,
//       currentValue: 87.09,
//       marketCap: 27.86,
//       grossRate: 0.01,
//       icon: CupertinoIcons.camera,
//       star: Icons.star_border_outlined,
//       grossIcon: CupertinoIcons.arrowtriangle_down_fill),
//   ExchangeModel(
//       name: "Dogecoin",
//       shortName: "DOGE",
//       rank: 9,
//       currentValue: 0.1174,
//       marketCap: 15.578,
//       grossRate: 0.52,
//       icon: CupertinoIcons.rectangle_expand_vertical,
//       star: Icons.star_border_outlined,
//       grossIcon: CupertinoIcons.arrowtriangle_down_fill),
//   ExchangeModel(
//       name: "Shiba Inu",
//       shortName: "SHIB",
//       rank: 10,
//       currentValue: 0.00002247,
//       marketCap: 12.33,
//       grossRate: 0.519,
//       icon: CupertinoIcons.staroflife,
//       star: Icons.star_border_outlined,
//       grossIcon: CupertinoIcons.arrowtriangle_down_fill)
// ];
