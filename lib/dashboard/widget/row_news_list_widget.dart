import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/utils/app_routes.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:flutter/material.dart';

class NewsRowListWidget extends StatelessWidget {
  final NewsItem newsItem;
  final Function callback;
  const NewsRowListWidget({@required this.newsItem,@required this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        child: Row(
          children: [
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsItem.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 3,
                    overflow: TextOverflow.fade,
                  ),
                  SizedBox(height: 8),
                  Text("${newsItem.source} . ${AppUtils.formatDate(newsItem.date)}",
                    style: TextStyle(
                        fontSize: 12
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 8),
            Flexible(
              flex: 1,
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      newsItem.imgUrls[0],
                      fit: BoxFit.fitHeight,
                      errorBuilder: (ctx, obj, stack) {
                        return Container(
                            child: Image.asset(
                              "assets/images/placeholder.png",
                              fit: BoxFit.fitHeight,
                            ));
                      },
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
