import 'package:crypto_khabar/market/model/market_model.dart';
import 'package:crypto_khabar/market/provider/market_provider.dart';
import 'package:crypto_khabar/market/widget/crypto_search.dart';
import 'package:crypto_khabar/market/widget/market_item.widget.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({Key key}) : super(key: key);

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
  static const double rowGap = 8;

  final ScrollController _scrollController = ScrollController();
  MarketProvider marketProvider;
  RefreshController _refreshController;

  void initState() {
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 7;
    _refreshController = RefreshController(initialRefresh: false);
    marketProvider = MarketProvider();
    super.initState();
  }

  @override
  void dispose() {
    marketProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("क्रिप्टो खबर"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CryptoSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: ChangeNotifierProvider<MarketProvider>(
          create: (ctx) => marketProvider,
          child: Consumer<MarketProvider>(builder: (context, provider, child) {
            return provider.shimmer
                ? _MarketShimmerWidget(rowGap)
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
                            provider.onRefresh(_refreshController);
                          },
                          child: ListView.separated(
                            controller: _scrollController,
                            itemCount: marketProvider.marketItemList.length,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              MarketItem item =
                                  marketProvider.marketItemList[index];
                              double bottomPadding = index ==
                                      marketProvider.marketItemList.length - 1
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
                      ),
                      Container(
                        color: Theme.of(context).secondaryHeaderColor,
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: InkWell(
                          onTap: () async {
                            provider.selectSortingFilter();
                            SchedulerBinding.instance
                                ?.addPostFrameCallback((_) {
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
                                child:
                                    Text("${provider.marketFilterName} अनुसार"),
                              ),
                              Row(
                                children: [
                                  Text("बदलें"),
                                  SizedBox(width: 4),
                                  Icon(provider.filterIconData,
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
          })),
    );
  }
}

class _MarketShimmerWidget extends StatelessWidget {
  final double rowGap;

  _MarketShimmerWidget(this.rowGap);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: ListView.separated(
        itemCount: 16,
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 30,
                    height: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 10,
                      color: Colors.white,
                    ),
                    SizedBox(height: rowGap),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.03,
                          height: 10,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: 10,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 10,
                      color: Colors.white,
                    ),
                    SizedBox(height: rowGap),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 10,
                      color: Colors.white,
                    )
                  ],
                ),
              ],
            ),
          );
        },
        separatorBuilder: (ctx, index) {
          return Divider();
        },
      ),
    );
  }
}
