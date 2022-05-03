import 'package:crypto_khabar/market/model/market_model.dart';
import 'package:crypto_khabar/market/service/market_service.dart';
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
