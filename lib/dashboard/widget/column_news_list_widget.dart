import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:flutter/material.dart';

class ColumnNewsListWidget extends StatelessWidget {

  const ColumnNewsListWidget(
      {@required this.newsItem, @required this.callback,});
  final NewsItem newsItem;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AppUtils.isValidUrl(newsItem.imgUrl)?Image.network(
                  newsItem.imgUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, obj, stack) {
                    return Container(
                        child: Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover,
                        ),);
                  },
                ):Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              newsItem.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 3,
              overflow: TextOverflow.fade,
            ),
            const SizedBox(height: 8),
            Text(
              '${newsItem.source} . ${AppUtils.formatDate(newsItem.date)}',
              style: const TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
