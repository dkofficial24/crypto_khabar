import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:flutter/material.dart';

class NewsRowListWidget extends StatelessWidget {

  const NewsRowListWidget({@required this.newsItem, @required this.callback, this.index = -1});
  final NewsItem newsItem;
  final Function callback;
  final int index;

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
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 3,
                    overflow: TextOverflow.fade,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${newsItem.source} . ${AppUtils.formatDate(newsItem.date)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 60,
                  width: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AppUtils.isValidUrl(newsItem.imgUrl)
                        ? Image.network(
                            newsItem.imgUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, obj, stack) {
                              return SizedBox(
                                  height: 60,
                                  width: 70,
                                  child: Image.asset(
                                'assets/images/placeholder.png',
                                fit: BoxFit.fitHeight,
                              ),);
                            },
                          )
                        : SizedBox(
                        height: 60,
                        width: 70,
                            child: Image.asset(
                            'assets/images/placeholder.png',
                            fit: BoxFit.fitHeight,
                          ),),
                  ),),
            )
          ],
        ),
      ),
    );
  }
}
