import 'dart:async';
import 'package:crypto_khabar/market/model/market_model.dart';
import 'package:crypto_khabar/market/service/market_service.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

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
    name: "",
    symbol: '₹ ',
    decimalDigits: 6,
  );

  Future<List<CandleData>> fetchCandles(MarketItem marketItem) async {
    final url =
        "https://api.coingecko.com/api/v3/coins/${marketItem.id}/ohlc?vs_currency=inr&days=1";
    Response res = await Dio().get(url);
    return (res.data as List<dynamic>)
        .map((e) => CandleData.fromJson(e))
        .toList()
        .reversed
        .toList();
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
    timer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (isAppInBackground) return;
      print("Loading market item");
      try {
        List<MarketItem> list = _marketService.getMarketData();
        MarketItem item =
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
                        "assets/images/placeholder.png",
                        fit: BoxFit.cover,
                        width: 20,
                        height: 20,
                      ));
                },
              ),
              SizedBox(width: 8),
              Text(marketItem.name),
              Spacer(),
              IconButton(
                  onPressed: () {
                    if (marketItem.isFavorite) {
                      marketItem.isFavorite = false;
                      _marketService.removeCoinFromFavorite(marketItem);
                      AppUtils.showToast("कॉइन फेवरेट लिस्ट से हटा दिया गया");
                    } else {
                      _marketService.markCoinAsFavorite(marketItem);
                      AppUtils.showToast("कॉइन फेवरेट लिस्ट में जोड़ दिया गया");
                      marketItem.isFavorite = true;
                    }
                    setState(() {});
                  },
                  icon: Icon(
                      marketItem.isFavorite ? Icons.star : Icons.star_border))
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Container(
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
                                      TextStyle(color: Colors.white),
                                  timeLabelHeight: 32,
                                  volumeHeightFactor:
                                      0, // volume area is 20% of total height
                                ),
                                timeLabel: (timestamp, visibleDataCount) =>
                                    "\n",
                                overlayInfo: (candle) => {
                                  "Date": AppUtils.formatDate(candle.timestamp),
                                  "Open":
                                      candle.open?.toStringAsFixed(2) ?? "-",
                                  "Close":
                                      candle.close?.toStringAsFixed(2) ?? "-",
                                  "High": "${candle.high?.toStringAsFixed(2)}",
                                  "Low": "${candle.low?.toStringAsFixed(2)}",
                                },
                                onTap: (candle) {
                                  FirebaseAnalytics.instance
                                      .logEvent(name: "chart_tap");
                                },
                                onCandleResize: (width) {
                                  FirebaseAnalytics.instance
                                      .logEvent(name: "chart_zoom");
                                },
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  // height: MediaQuery.of(context).size.height * 0.6,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Column(
                        children: [
                          MarketInfoWidget(
                              name: "रैंक",
                              value: marketItem.marketCapRank.toString()),
                          MarketInfoWidget(name: "नाम", value: marketItem.name),
                          MarketInfoWidget(
                              name: "मौजूदा कीमत",
                              value: marketItem.currentPrice != null
                                  ? "${formatter.format(marketItem.currentPrice)}"
                                  : "-"),
                          MarketInfoWidget(
                              name: "मार्केट कैप",
                              value: marketItem.marketCap != null
                                  ? formatter.format(marketItem.marketCap)
                                  : "-"),
                          MarketInfoWidget(
                              name: "चिह्न",
                              value: marketItem.symbol.toUpperCase()),
                          MarketInfoWidget(
                              name: "24 घंटे में बदलाव",
                              value: marketItem.priceChangePercentage24h != null
                                  ? "${marketItem.priceChangePercentage24h}%"
                                  : "-",valueColor: marketItem.priceChangePercentage24h>0?Colors.green:Colors.red),
                          MarketInfoWidget(
                              name: "24 घंटे में उच्च स्तर",
                              value: marketItem.high24h != null
                                  ? "${formatter.format(marketItem.high24h)}"
                                  : "-"),
                          MarketInfoWidget(
                              name: "24 घंटे में कम स्तर",
                              value: marketItem.low24h != null
                                  ? "${formatter.format(marketItem.low24h)}"
                                  : "-"),
                          MarketInfoWidget(
                              name: "सबसे उच्च स्तर पर",
                              value: marketItem.ath != null
                                  ? "${formatter.format(marketItem.ath)}"
                                  : "-"),
                          MarketInfoWidget(
                              name: "सबसे उच्च स्तर की तारीख",
                              value: marketItem.athDate != null
                                  ? "${AppUtils.formatDateTime(DateTime.parse(marketItem.athDate))}"
                                  : "-"),
                          MarketInfoWidget(
                              name: "सबसे कम स्तर पर",
                              value: marketItem.atl != null
                                  ? "${formatter.format(marketItem.atl)}"
                                  : "-"),
                          MarketInfoWidget(
                              name: "सबसे कम स्तर की तारीख",
                              value: marketItem.atlDate != null
                                  ? "${AppUtils.formatDateTime(DateTime.parse(marketItem.atlDate))}"
                                  : "-"),
                          MarketInfoWidget(
                              name: "सर्क्युलेटिंग आपूर्ति",
                              value: marketItem.circulatingSupply != null
                                  ? "${marketItem.circulatingSupply}"
                                  : "-"),
                          MarketInfoWidget(
                              name: "कुल आपूर्ति",
                              value: marketItem.totalSupply != null
                                  ? "${marketItem.totalSupply}"
                                  : "-"),
                          MarketInfoWidget(
                              name: "कुल मात्रा",
                              value: marketItem.totalVolume != null
                                  ? "${marketItem.totalVolume}"
                                  : "-",
                              isLastItem: true),
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
  final String name;
  final String value;
  final bool isLastItem;
  final Color valueColor;

  MarketInfoWidget(
      {@required this.name,
      @required this.value,
      this.isLastItem = false,
      this.valueColor});

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
                    color: valueColor == null
                        ? AppUtils.isDarkTheme(context)
                            ? Colors.white
                            : Colors.black
                        : valueColor))
          ],
        ),
        SizedBox(height: 8),
        !isLastItem ? Divider() : Container(),
        !isLastItem ? SizedBox(height: 8) : Container(),
      ],
    );
  }
}
