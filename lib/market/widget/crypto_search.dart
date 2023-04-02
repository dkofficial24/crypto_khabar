
import 'package:crypto_khabar/market/model/market_model.dart';
import 'package:crypto_khabar/market/provider/crypto_search.provider.dart';
import 'package:crypto_khabar/market/service/market_service.dart';
import 'package:crypto_khabar/market/widget/market_item.widget.dart';
import 'package:crypto_khabar/utils/string_const.dart';
import 'package:flutter/material.dart';

class CryptoSearchDelegate extends SearchDelegate {

  CryptoSearchProvider provider = CryptoSearchProvider(MarketService());

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _searchedItem(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
  return _searchedItem(query);
  }

  Widget _searchedItem(String query){
    if(query.isNotEmpty) {
      List<MarketItem> items = provider.searchCrypto(query);
      if(items.length>0) {
        return ListView.separated(
            itemBuilder: (context, index) {
              return InkWell(
                onLongPress: (){
                  if (items[index].isFavorite) {
                    items[index].isFavorite = false;
                    provider.removeCoinFromFavorite(items[index]);
                  } else {
                    items[index].isFavorite = true;
                    provider.markCoinFavorite(items[index]);
                  }
                },
                child: MarketItemWidget(
                    marketItem: items[index], formatter: provider.formatter),
              );
            }, separatorBuilder: (context, index) {
          return Divider();
        },
            itemCount: items.length);
      }else{
        return Center(child:Text(StringConst.coinNotAvailable));
      }
    }
    return Center();
  }
}