import 'package:crypto_khabar/market/model/market_model.dart';
import 'package:crypto_khabar/market/provider/market_provider.dart';
import 'package:crypto_khabar/market/widget/market_item.widget.dart';
import 'package:crypto_khabar/market/widget/market_shimmer_widget.dart';
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
    name: "",
    symbol: '₹ ',
    decimalDigits: 6,
  );

  void initState() {
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 7;
    super.initState();
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
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: marketProvider.favoriteCoinsData.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        MarketItem item =
                            marketProvider.favoriteCoinsData[index];
                        double bottomPadding =
                            index == marketProvider.favoriteCoinsData.length - 1
                                ? 16
                                : 8;
                        double topPadding = index == 0 ? 16 : 8;
                        return MarketItemWidget(
                          marketItem: item,
                          formatter: formatter,
                          topPadding: topPadding,
                          bottomPadding: bottomPadding,
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return Divider();
                      },
                    ),
                  ),
                  Container(
                    color: Theme.of(context).secondaryHeaderColor,
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: InkWell(
                      onTap: () async {
                        marketProvider.selectSortingFilter();
                        SchedulerBinding.instance?.addPostFrameCallback((_) {
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
                            child: Text("${marketProvider.marketFilterName} अनुसार"),
                          ),
                          Row(
                            children: [
                              Text("बदलें"),
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
