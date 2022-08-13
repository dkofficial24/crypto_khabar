import 'package:crypto_khabar/market/page/market_page.dart';
import 'package:crypto_khabar/market/provider/market_provider.dart';
import 'package:crypto_khabar/market/service/market_db_service.dart';
import 'package:crypto_khabar/market/service/market_service.dart';
import 'package:crypto_khabar/market/widget/crypto_search.dart';
import 'package:crypto_khabar/market/widget/favorite_coin_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarketTabScreen extends StatefulWidget {
  const MarketTabScreen({Key key}) : super(key: key);

  @override
  State<MarketTabScreen> createState() => _MarketTabScreenState();
}

class _MarketTabScreenState extends State<MarketTabScreen> {
  MarketProvider _marketProvider;

  @override
  initState() {
    _marketProvider = MarketProvider(MarketDbService(), MarketService());
    super.initState();
  }

  dispose() {
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
            title: Text("क्रिप्टो खबर"),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  await showSearch(
                    context: context,
                    delegate: CryptoSearchDelegate(),
                  );
                  _marketProvider.fetchAllMarketData();
                },
              ),
            ],
            bottom: TabBar(
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
            children: [MarketPage(), FavoriteCoinWidget()],
          ),
        ),
      ),
    );
  }
}
