import 'package:crypto_khabar/market/model/market_model.dart';
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
  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final formatter = NumberFormat.currency(
    locale: 'HI',
    name: "",
    symbol: '₹ ',
    decimalDigits: 6,
  );

  final ScrollController _scrollController = ScrollController();
  late RefreshController _refreshController;

  void initState() {
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 7;
    _refreshController = RefreshController(initialRefresh: false);
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
            ? MarketShimmerWidget()
            : Column(
                children: [
                  Expanded(
                    child: SmartRefresher(
                      controller: _refreshController,
                      enablePullUp: false,
                      reverse: false,
                      enableTwoLevel: false,
                      enablePullDown: true,
                      onRefresh: () {
                        FirebaseAnalytics.instance
                            .logEvent(name: "market_refresh");
                        marketProvider.onRefresh(_refreshController);
                      },
                      child: ListView.separated(
                        controller: _scrollController,
                        itemCount: marketProvider.marketItemList.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          MarketItem item =
                              marketProvider.marketItemList[index];
                          double bottomPadding =
                              index == marketProvider.marketItemList.length - 1
                                  ? 16
                                  : 8;
                          double topPadding = index == 0 ? 16 : 8;
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
                            child: InkWell(
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
                                topPadding: topPadding,
                                bottomPadding: bottomPadding,
                                onMarketItemClick: () {
                                  if (mounted) {
                                    marketProvider.fetchAllMarketData();
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (ctx, index) {
                          return Divider();
                        },
                      ),
                    ),
                  ),
                  Container(
                    color: Theme.of(context).secondaryHeaderColor,
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: InkWell(
                      onTap: () async {
                        marketProvider.selectSortingFilter();
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          _scrollController.animateTo(0,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.fastOutSlowIn);
                        });
                        FirebaseAnalytics.instance
                            .logEvent(name: "tap_market_filter");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                                "${marketProvider.marketFilterName} ${StringConst.accordingToFilter}"),
                          ),
                          Row(
                            children: [
                              Text(StringConst.changeFilter),
                              SizedBox(width: 4),
                              Icon(marketProvider.filterIconData,
                                  size: 15,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
      }),
    );
  }
}
