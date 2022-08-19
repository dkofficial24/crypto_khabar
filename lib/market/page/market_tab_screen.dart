import 'package:crypto_khabar/market/page/market_page.dart';
import 'package:crypto_khabar/market/provider/market_provider.dart';
import 'package:crypto_khabar/market/service/market_db_service.dart';
import 'package:crypto_khabar/market/service/market_service.dart';
import 'package:crypto_khabar/market/widget/crypto_search.dart';
import 'package:crypto_khabar/market/widget/favorite_coin_widget.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:crypto_khabar/utils/string_const.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarketTabScreen extends StatefulWidget {
  const MarketTabScreen({Key key}) : super(key: key);

  @override
  State<MarketTabScreen> createState() => _MarketTabScreenState();
}

class _MarketTabScreenState extends State<MarketTabScreen>
    with TickerProviderStateMixin {
  MarketProvider _marketProvider;
  TabController tabController;

  @override
  initState() {
    _marketProvider = MarketProvider(MarketDbService(), MarketService());
    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
        if(tabController.index == 1){
          FirebaseAnalytics.instance
              .logEvent(name: "mts_fav_coin_tab");
        }

    });
    super.initState();
  }

  dispose() {
    tabController.dispose();
    _marketProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: ChangeNotifierProvider(
        create: (ctx) => _marketProvider,
        child: Scaffold(
          appBar: AppBar(
            title: Text(StringConst.appName),
            actions: [
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () async {
                  AppUtils.showSnack(context, StringConst.favCoinGuideMsg);
                  FirebaseAnalytics.instance
                      .logEvent(name: "mts_info_abt_fav");
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    FirebaseAnalytics.instance
                        .logEvent(name: "mts_search_coin");
                    await showSearch(
                      context: context,
                      delegate: CryptoSearchDelegate(),
                    );
                    _marketProvider.fetchAllMarketData();
                  },
                ),
              ),
              SizedBox(width: 4,)
            ],
            bottom: TabBar(
              controller: tabController,
              tabs: [
                Tab(
                  icon: Icon(Icons.auto_graph),
                ),
                Tab(
                  icon: Icon(Icons.star),
                )
              ],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [MarketPage(), FavoriteCoinWidget()],
          ),
        ),
      ),
    );
  }
}
