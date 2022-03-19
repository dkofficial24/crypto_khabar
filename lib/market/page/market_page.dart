import 'package:crypto_khabar/constants.dart';
import 'package:crypto_khabar/market/model/market_model.dart';
import 'package:crypto_khabar/market/provider/market_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({Key key}) : super(key: key);

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  MarketProvider marketProvider;

  void initState() {
    marketProvider = MarketProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Market"),
      ),
      body: ChangeNotifierProvider<MarketProvider>(
          create: (ctx) => marketProvider,
          child: Consumer<MarketProvider>(builder: (context, provider, child) {
            return ListView.separated(
              itemCount: marketProvider.marketItemList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                MarketItem item = marketProvider.marketItemList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 2, 4),
                            child: Image.network(
                              item.image,
                              height: 25,
                              width: 25,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2)),
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(6, 2, 6, 2),
                                    child: Text(
                                      item.marketCapRank.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: bottomSize),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item.symbol,
                                  style: TextStyle(
                                      color: bottomColor,
                                      fontSize: bottomSize),
                                ),
                                const SizedBox(width: 4),
                                const SizedBox(width: 4),
                                Text(
                                  "${item.priceChangePercentage24h
                                      .toStringAsFixed(2)}\u{0025}",
                                  style: TextStyle(
                                      color:
                                      item.priceChangePercentage24h >= 0
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: bottomSize),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${marketProvider.marketItemList[index].currentPrice
                                .toString()}",
                            style:
                            const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text("MCap ${getSuffix(item.marketCap)}",
                                  style: TextStyle(
                                      color: bottomColor,
                                      fontSize: bottomSize)),
                              const SizedBox(width: 2),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 1,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  color: Colors.grey[200],
                );
              },
            );
          })),
    );
  }

  String getSuffix(int num) {
    var _formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: 2,
      locale: 'en_IN', name: "",
    ).format(num);
    return _formattedNumber;
  }
}

