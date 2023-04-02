import 'package:crypto_khabar/market/provider/market_provider.dart';
import 'package:crypto_khabar/market/widget/market_item.widget.dart';
import 'package:crypto_khabar/market/widget/market_shimmer_widget.dart';
import 'package:crypto_khabar/utils/string_const.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({Key key}) : super(key: key);

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final formatter = NumberFormat.currency(
    locale: 'HI',
    name: '',
    symbol: '₹ ',
    decimalDigits: 6,
  );

  final ScrollController _scrollController = ScrollController();
  RefreshController _refreshController;

  @override
  void initState() {
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 7;
    _refreshController = RefreshController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MarketProvider>(builder: (context, marketProvider, child) {
        return marketProvider.shimmer
            ? const MarketShimmerWidget()
            : Column(
                children: [
                  Expanded(
                    child: SmartRefresher(
                      controller: _refreshController,
                      reverse: false,
                      onRefresh: () {
                        FirebaseAnalytics.instance
                            .logEvent(name: 'market_refresh');
                        marketProvider.onRefresh(_refreshController);
                      },
                      child: ListView.separated(
                        controller: _scrollController,
                        itemCount: marketProvider.marketItemList.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item =
                              marketProvider.marketItemList[index];
                          final bottomPadding = index ==
                                  marketProvider.marketItemList.length - 1
                              ? 16
                              : 8;
                          final topPadding = index == 0 ? 16 : 8;
                          return InkWell(
                            onLongPress: (){
                              if (item.isFavorite) {
                                item.isFavorite = false;
                                marketProvider.removeCoinFromFavorite(item);
                              } else {
                                item.isFavorite = true;
                                marketProvider.markCoinFavorite(item);
                              }
                            },
                            child: InkWell(
                              onLongPress: (){
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
                            ),
                          );
                        },
                        separatorBuilder: (ctx, index) {
                          return const Divider();
                        },
                      ),
                    ),
                  ),
                  Container(
                    color: Theme.of(context).secondaryHeaderColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: InkWell(
                      onTap: () async {
                        marketProvider.selectSortingFilter();
                        SchedulerBinding.instance
                            ?.addPostFrameCallback((_) {
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
                            child:
                                Text('${marketProvider.marketFilterName} ${StringConst.accordingToFilter}'),
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


