import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsDetailsPage extends StatefulWidget {
  @override
  _NewsDetailsPageState createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  NewsItem _newsItem;

  @override
  Widget build(BuildContext context) {
    _newsItem = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  _newsItem.imgUrl,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (ctx, obj, stack) {
                    return Container(
                        child: Image.asset(
                      "assets/images/placeholder.png",
                      fit: BoxFit.fitHeight,
                    ));
                  },
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(_newsItem.title,
                style: Theme.of(context).textTheme.headline6),
          ),
          Text(AppUtils.formatDate(_newsItem.date)),
          SizedBox(height: 8),
          Text(
            _newsItem.details,
            style: GoogleFonts.roboto(fontSize: 16),
            // style: Theme.of(context).textTheme.bodyText2.copyWith(
            //       fontSize: 16,
            //       letterSpacing: 0.5,wordSpacing: 0.5,
            //     ),
          )
        ],
      ),
    ));
  }
}
