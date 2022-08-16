import 'package:crypto_khabar/market/model/market_model.dart';
import 'package:crypto_khabar/market/service/market_service.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:crypto_khabar/utils/string_const.dart';
import 'package:intl/intl.dart';

class CryptoSearchProvider {
  MarketService marketService;
  List<MarketItem> data;
  List<MarketItem> filteredData = [];
  final formatter = NumberFormat.currency(
    locale: 'HI',
    name: "",
    symbol: '₹ ',
    decimalDigits: 6,
  );

  CryptoSearchProvider(this.marketService) {
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 7;
    data = marketService.getMarketData();
  }

  Future markCoinFavorite(MarketItem favoriteCoin) async {
    marketService.markCoinAsFavorite(favoriteCoin);
    AppUtils.showToast("${favoriteCoin.name} ${StringConst.favCoinAddMsg}");
  }

  Future removeCoinFromFavorite(MarketItem marketItem) async {
    marketService.removeCoinFromFavorite(marketItem);
    AppUtils.showToast("${marketItem.name} ${StringConst.favCoinRemoveMsg}");
  }

  List<MarketItem> searchCrypto(String input) {
    input = input.trim();
    if(input.isEmpty)return [];
    input = input.toLowerCase();
    filteredData.clear();
    filteredData.addAll(data);
    filteredData.retainWhere(
        (element) => element.name.toLowerCase().contains(input) || element.symbol.toLowerCase().contains(input));
    return filteredData;
  }
}
