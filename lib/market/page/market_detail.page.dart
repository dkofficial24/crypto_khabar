import 'dart:async';

import 'package:crypto_khabar/constants.dart';
import 'package:crypto_khabar/market/model/market_model.dart';
import 'package:crypto_khabar/market/service/market_service.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:crypto_khabar/utils/string_const.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:intl/intl.dart';

class MarketDetailPage extends StatefulWidget {
  @override
  _MarketDetailState createState() => _MarketDetailState();
}

class _MarketDetailState extends State<MarketDetailPage> {
  List<CandleData> _data = [];
  MarketItem marketItem;
  Timer timer;
  MarketService _marketService;

  final formatter = NumberFormat.currency(
    locale: 'HI',
    name: '',
    symbol: '₹ ',
    decimalDigits: 6,
  );

  Future<List<CandleData>> fetchCandles(MarketItem marketItem) async {
    final url =
        'https://api.coingecko.com/api/v3/coins/${marketItem.id}/ohlc?vs_currency=inr&days=1';
    final res = await Dio().get(url);
    return (res.data as List<dynamic>)
        .map((e) => fromJson(e))
        .toList()
        .reversed
        .toList();
  }

   CandleData fromJson(Map<String, dynamic> json) {
    return CandleData(
      timestamp: json['timestamp'],
      open: json['open'],
      high: json['high'],
      low: json['low'],
      close: json['close'],
      volume: json['volume'],
      trends: []
    );
  }

  @override
  void initState() {
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 7;
    _marketService = MarketService();
    initFetchDataTimer();
    super.initState();
  }

  void initFetchDataTimer() {
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (isAppInBackground) return;
      print('Loading market item');
      try {
        final list = _marketService.getMarketData();
        final item =
            list.where((element) => element.symbol == marketItem.symbol).first;
        if (item != null) {
          setState(() {
            marketItem = item;
          });
        }
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    if (marketItem == null) {
      marketItem = ModalRoute.of(context).settings.arguments;
      fetchCandles(marketItem).then((value) {
        setState(() {
          _data = value;
        });
      });
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.network(
                marketItem.image,
                width: 20,
                height: 20,
                errorBuilder: (ctx, obj, stack) {
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/placeholder.png',
                        fit: BoxFit.cover,
                        width: 20,
                        height: 20,
                      ),);
                },
              ),
              const SizedBox(width: 8),
              Text(marketItem.name),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    if (marketItem.isFavorite) {
                      FirebaseAnalytics.instance
                          .logEvent(name: 'mdp_coin_added_fav');
                      marketItem.isFavorite = false;
                      _marketService.removeCoinFromFavorite(marketItem);
                      AppUtils.showToast('${marketItem.name} ${StringConst.favCoinRemoveMsg}');
                    } else {
                      _marketService.markCoinAsFavorite(marketItem);
                      AppUtils.showToast('${marketItem.name} ${StringConst.favCoinAddMsg}');
                      marketItem.isFavorite = true;
                      FirebaseAnalytics.instance
                          .logEvent(name: 'mdp_coin_removed_fav');
                    }
                    setState(() {});
                  },
                  icon: Icon(
                      marketItem.isFavorite ? Icons.star : Icons.star_border,),)
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: SizedBox(
                    // padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    height: 400,
                    child: Center(
                      child: _data.length > 3
                          ? Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: InteractiveChart(
                                candles: _data,
                                style: ChartStyle(
                                  volumeColor: Colors.teal.withOpacity(0),
                                  trendLineStyles: [
                                    Paint()
                                      ..strokeWidth = 2.0
                                      ..strokeCap = StrokeCap.round
                                      ..color = Colors.deepOrange,
                                    Paint()
                                      ..strokeWidth = 4.0
                                      ..strokeCap = StrokeCap.round
                                      ..color = Colors.orange,
                                  ],
                                  // priceGridLineColor: AppUtils.isDarkTheme(context)?Colors.white:Colors.black,
                                  priceLabelStyle: TextStyle(
                                    fontSize: 8,
                                    color: AppUtils.isDarkTheme(context)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  timeLabelStyle:
                                      TextStyle(color: Colors.blue[200]),
                                  selectionHighlightColor:
                                      Colors.red.withOpacity(0.2),
                                  overlayBackgroundColor:
                                      Colors.blue.withOpacity(0.9),
                                  overlayTextStyle:
                                      const TextStyle(color: Colors.white),
                                  timeLabelHeight: 32,
                                  volumeHeightFactor:
                                      0, // volume area is 20% of total height
                                ),
                                timeLabel: (timestamp, visibleDataCount) =>
                                    '\n',
                                overlayInfo: (candle) => {
                                  'Date': AppUtils.formatDate(candle.timestamp),
                                  'Open':
                                      candle.open?.toStringAsFixed(2) ?? '-',
                                  'Close':
                                      candle.close?.toStringAsFixed(2) ?? '-',
                                  'High': candle.high?.toStringAsFixed(2),
                                  'Low': candle.low?.toStringAsFixed(2),
                                },
                                onTap: (candle) {
                                  FirebaseAnalytics.instance
                                      .logEvent(name: 'chart_tap');
                                },
                                onCandleResize: (width) {
                                  FirebaseAnalytics.instance
                                      .logEvent(name: 'chart_zoom');
                                },
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  // height: MediaQuery.of(context).size.height * 0.6,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16,),
                      child: Column(
                        children: [
                          MarketInfoWidget(
                              name: StringConst.rank,
                              value: marketItem.marketCapRank.toString(),),
                          MarketInfoWidget(name: StringConst.coinName, value: marketItem.name),
                          MarketInfoWidget(
                              name: StringConst.coinCurrentValue,
                              value: marketItem.currentPrice != null
                                  ? formatter.format(marketItem.currentPrice)
                                  : '-',),
                          MarketInfoWidget(
                              name: StringConst.coinMarketCap,
                              value: marketItem.marketCap != null
                                  ? formatter.format(marketItem.marketCap)
                                  : '-',),
                          MarketInfoWidget(
                              name: StringConst.coinSign,
                              value: marketItem.symbol.toUpperCase(),),
                          MarketInfoWidget(
                              name: StringConst.coinChangeIn24Hrs,
                              value: marketItem.priceChangePercentage24h != null
                                  ? '${marketItem.priceChangePercentage24h}%'
                                  : '-',valueColor: marketItem.priceChangePercentage24h>0?Colors.green:Colors.red,),
                          MarketInfoWidget(
                              name: StringConst.coinHighLevelIn24Hrs,
                              value: marketItem.high24h != null
                                  ? formatter.format(marketItem.high24h)
                                  : '-',),
                          MarketInfoWidget(
                              name: StringConst.coinLowLevelIn24Hrs,
                              value: marketItem.low24h != null
                                  ? formatter.format(marketItem.low24h)
                                  : '-',),
                          MarketInfoWidget(
                              name: StringConst.coinHighestLevel,
                              value: marketItem.ath != null
                                  ? formatter.format(marketItem.ath)
                                  : '-',),
                          MarketInfoWidget(
                              name: StringConst.coinHighestLevelDate,
                              value: marketItem.athDate != null
                                  ? AppUtils.formatDateTime(DateTime.parse(marketItem.athDate))
                                  : '-',),
                          MarketInfoWidget(
                              name: StringConst.coinLowestLevel,
                              value: marketItem.atl != null
                                  ? formatter.format(marketItem.atl)
                                  : '-',),
                          MarketInfoWidget(
                              name: StringConst.coinLowestLevelDate,
                              value: marketItem.atlDate != null
                                  ? AppUtils.formatDateTime(DateTime.parse(marketItem.atlDate))
                                  : '-',),
                          MarketInfoWidget(
                              name:  StringConst.circulatingSupply,
                              value: marketItem.circulatingSupply != null
                                  ? '${marketItem.circulatingSupply}'
                                  : '-',),
                          MarketInfoWidget(
                              name: StringConst.totalSupply,
                              value: marketItem.totalSupply != null
                                  ? '${marketItem.totalSupply}'
                                  : '-',),
                          MarketInfoWidget(
                              name: StringConst.totalQuantity,
                              value: marketItem.totalVolume != null
                                  ? '${marketItem.totalVolume}'
                                  : '-',
                              isLastItem: true,),
                          //  MarketInfoWidget(name: "अधिकतम आपूर्ति",value: "${marketItem.maxSupply}"),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }
}

class MarketInfoWidget extends StatelessWidget {

  const MarketInfoWidget(
      {@required this.name,
      @required this.value,
      this.isLastItem = false,
      this.valueColor,});
  final String name;
  final String value;
  final bool isLastItem;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name),
            Text(value,
                style: TextStyle(
                    color: valueColor ?? (AppUtils.isDarkTheme(context)
                            ? Colors.white
                            : Colors.black),),)
          ],
        ),
        const SizedBox(height: 8),
        if (!isLastItem) const Divider() else Container(),
        if (!isLastItem) const SizedBox(height: 8) else Container(),
      ],
    );
  }
}
