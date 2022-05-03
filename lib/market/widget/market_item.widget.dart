import 'package:crypto_khabar/market/model/market_model.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MarketItemWidget extends StatelessWidget {
  final MarketItem marketItem;
  final double fontSize = 12;
  final Color bottomColor = Colors.grey;
  final NumberFormat formatter;
  final double topPadding,bottomPadding;
  static const double rowGap = 8;

  MarketItemWidget({@required this.marketItem,@required this.formatter,
  this.topPadding = 8,this.bottomPadding = 8
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
            context, AppRoutes.MarketDetailPage,
            arguments: marketItem);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            16, topPadding, 16, bottomPadding),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.fromLTRB(
                      0, 4, 2, 4),
                  child: Image.network(
                    marketItem.image,
                    width: 25,
                    height: 25,
                    errorBuilder:
                        (ctx, obj, stack) {
                      return ClipRRect(
                          borderRadius:
                          BorderRadius.circular(
                              16),
                          child: Image.asset(
                            "assets/images/placeholder.png",
                            fit: BoxFit.cover,
                            width: 25,
                            height: 25,
                          ));
                    },
                  ),
                )
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    marketItem.name,
                    style: const TextStyle(
                        fontWeight:
                        FontWeight.w600),
                  ),
                  const SizedBox(height: rowGap),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 18,
                        height: 18,
                        padding:
                        EdgeInsets.symmetric(
                            horizontal: 2),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .secondaryHeaderColor,
                            borderRadius:
                            BorderRadius
                                .circular(2)),
                        child: Center(
                          child: Text(
                            marketItem.marketCapRank
                                .toString(),
                            style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                                fontSize: fontSize),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        marketItem.symbol,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: bottomColor,
                            fontSize: fontSize),
                      ),
                      const SizedBox(width: 4),
                      const SizedBox(width: 4),
                      Text(
                        "${marketItem.priceChangePercentage24h.toStringAsFixed(2)}\u{0025}",
                        style: TextStyle(
                            color:
                            marketItem.priceChangePercentage24h >=
                                0
                                ? Colors.green
                                : Colors.red,
                            fontSize: fontSize),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment:
              CrossAxisAlignment.end,
              children: [
                Text(
                  "${formatter.format(marketItem.currentPrice)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: rowGap),
                Row(
                  children: [
                    Text(
                        "मार्केट कैप ${AppUtils.currencyFormat(marketItem.marketCap)}",
                        style: TextStyle(
                            color: bottomColor,
                            fontSize: fontSize)),
                    const SizedBox(width: 2),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
