import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:flutter/material.dart';

class NewsRowListWidget extends StatelessWidget {
  final NewsItem newsItem;
  final Function callback;
  final int index;

  const NewsRowListWidget({required this.newsItem, required this.callback, this.index = -1});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        callback(index);
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Row(
                    children: [
                      Text(
                        "${newsItem.source} . ${AppUtils.formatDate(newsItem.date)}",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
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
                  width: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AppUtils.isValidUrl(newsItem.imgUrl)
                        ? Image.network(
                            newsItem.imgUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, obj, stack) {
                              return Container(
                                  height: 60,
                                  width: 70,
                                  child: Image.asset(
                                "assets/images/placeholder.png",
                                fit: BoxFit.fitHeight,
                              ));
                            },
                          )
                        : Container(
                        height: 60,
                        width: 70,
                            child: Image.asset(
                            "assets/images/placeholder.png",
                            fit: BoxFit.fitHeight,
                          )),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
