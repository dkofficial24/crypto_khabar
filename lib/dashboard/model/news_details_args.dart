import 'package:crypto_khabar/dashboard/model/news_item.dart';

class NewsDetailsArgs {
  NewsDetailsArgs({
    required this.newsItem,
    required this.index,
  });

  NewsItem newsItem;
  int index;
}
