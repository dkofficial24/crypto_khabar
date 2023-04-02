import 'package:crypto_khabar/market/provider/market_provider.dart';
import 'package:crypto_khabar/market/widget/market_item.widget.dart';
import 'package:crypto_khabar/market/widget/market_shimmer_widget.dart';
import 'package:crypto_khabar/utils/string_const.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FavoriteCoinWidget extends StatefulWidget {
  const FavoriteCoinWidget({Key key}) : super(key: key);

  @override
  State<FavoriteCoinWidget> createState() => _FavoriteCoinWidgetState();
}

class _FavoriteCoinWidgetState extends State<FavoriteCoinWidget> {
  final ScrollController _scrollController = ScrollController();
  final formatter = NumberFormat.currency(
    locale: 'HI',
    name: '',
    symbol: '₹ ',
    decimalDigits: 6,
  );

  @override
  void initState() {
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 7;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MarketProvider>(builder: (context, marketProvider, child) {
        if(marketProvider.favoriteCoinsData.isEmpty && !marketProvider.shimmer){
          return const Center(child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(StringConst.favCoinGuideMsg,textAlign: TextAlign.center,style: TextStyle(
              fontSize: 16,
            ),),
          ),);
        }
        return marketProvider.shimmer
            ? const MarketShimmerWidget()
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: marketProvider.favoriteCoinsData.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item =
                            marketProvider.favoriteCoinsData[index];
                        final bottomPadding =
                            index == marketProvider.favoriteCoinsData.length - 1
                                ? 16
                                : 8;
                        final topPadding = index == 0 ? 16 : 8;
                        return InkWell(
                          onLongPress: () {
                            if (item.isFavorite) {
                              item.isFavorite = false;
                              marketProvider.removeCoinFromFavorite(item);
                            } else {
                              item.isFavorite = true;
                              marketProvider.markCoinFavorite(item);
                            }
                          },
                          child: MarketItemWidget(
                            marketItem: item,
                            formatter: formatter,
                            topPadding: topPadding.toDouble(),
                            bottomPadding: bottomPadding.toDouble(),
                            onMarketItemClick: (){
                              if(mounted) {
                                marketProvider.fetchAllMarketData();
                              }
                            },
                          ),
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return const Divider();
                      },
                    ),
                  ),
                  Container(
                    color: Theme.of(context).secondaryHeaderColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: InkWell(
                      onTap: () async {
                        marketProvider.selectSortingFilter();
                        SchedulerBinding.instance?.addPostFrameCallback((_) {
                          _scrollController.animateTo(0,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.fastOutSlowIn,);
                        });
                        await FirebaseAnalytics.instance
                            .logEvent(name: 'tap_market_filter');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                                '${marketProvider.marketFilterName} ${StringConst.accordingToFilter}',),
                          ),
                          Row(
                            children: [
                              const Text(StringConst.changeFilter),
                              const SizedBox(width: 4),
                              Icon(marketProvider.filterIconData,
                                  size: 15,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
      },),
    );
  }
}
