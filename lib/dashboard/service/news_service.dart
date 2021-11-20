import 'package:crypto_khabar/dashboard/model/news_item.dart';

class NewsService {
  NewsService._internal();

  static final NewsService _newsService = NewsService._internal();

  factory NewsService() {
    return _newsService;
  }

  Future<List<NewsItem>> fetchNews() async {
    List<NewsItem> newsItemList = [];

    newsItemList.add(NewsItem(
        title: "Why cryptocurrency Bitcoin is headed for its worst week in months",
        author: "Dinesh",
        date: 1637390631000,
        details: "Bitcoin fell to a one-month low on Friday and was headed for its worst week in six months as traders have booked profits from a long rally and been spooked by an expectation that creditors of collapsed crypto exchange Mt Gox might liquidate their payments.",
        source: "Mint",
        imgUrls: [
          "https://image.shutterstock.com/image-photo/crypto-currency-background-various-shiny-260nw-1434643079.jpg",
          "https://www.trustetc.com/wp-content/uploads/2018/09/8crypto.png"
        ]));

    newsItemList.add(NewsItem(
        title: "India's Prime Minister Narendra Modi Urges Countries to Collaborate on Bitcoin, Cryptocurrency",
        author: "Dinesh",
        date: 1637390631000,
        details: "Indian Prime Minister Narendra Modi talked about cryptocurrency, specifically bitcoin, during his virtual keynote address at the Sydney Dialogue Wednesday.He called on countries to work together to ensure that cryptocurrency does not fall into the wrong hands. 'Take cryptocurrency or bitcoin for example. It is important that all democratic nations work together on this and ensure it does not end up in wrong hands, which can spoil our youth,” Modi said.",
        source: "Bitcoin.com",
        imgUrls: [
          "https://www.trustetc.com/wp-content/uploads/2018/09/8crypto.png"
        ]));

    newsItemList.add(NewsItem(
        title: "Famed Economist Doubts Bitcoin Will Become Global Currency",
        author: "Dinesh",
        date: 1637390631000,
        details: "Famed economist Mohamed El-Erian talked about the future outlook for cryptocurrencies, particularly bitcoin, in an interview with CNBC Monday.El-Erian is the chief economic advisor at Allianz, the corporate parent of PIMCO, one of the largest investment managers, where he was CEO and co-chief investment officer. The Egyptian-American businessman is also president of Queens College, Cambridge University.",
        source: "Bitcoin.com",
        imgUrls: [
          "https://www.trustetc.com/wp-content/uploads/2018/09/8crypto.png"
        ]));

    newsItemList.add(NewsItem(
        title: "Crypto Markets Shed Billions Overnight — Analyst Says ‘Drawdown Normal’ and ‘Bull Market Structure Still Intact’",
        author: "Dinesh",
        date: 1637390631000,
        details: "Cryptocurrency markets have dropped significantly in value during the last 24 hours as the entire market capitalization of all 10,000 crypto assets in existence has dropped below the 3 trillion mark to 2.77 trillion on Tuesday morning (EST). After tapping 66K on Monday, bitcoin’s price slid below the 60K handle to a low of 58,563 per unit. After the steep fall, bitcoin’s price has recovered some losses, rising back above the 60K dollar range and has started to show some consolidation.",
        source: "Bitcoin.com",
        imgUrls: [
          "https://www.trustetc.com/wp-content/uploads/2018/09/8crypto.png"
        ]));

    newsItemList.add(NewsItem(
        title: "India's Prime Minister Narendra Modi Urges Countries to Collaborate on Bitcoin, Cryptocurrency",
        author: "Dinesh",
        date: 1637390631000,
        details: "Indian Prime Minister Narendra Modi talked about cryptocurrency, specifically bitcoin, during his virtual keynote address at the Sydney Dialogue Wednesday.He called on countries to work together to ensure that cryptocurrency does not fall into the wrong hands. 'Take cryptocurrency or bitcoin for example. It is important that all democratic nations work together on this and ensure it does not end up in wrong hands, which can spoil our youth,” Modi said.",
        source: "Bitcoin.com",
        imgUrls: [
          "https://www.trustetc.com/wp-content/uploads/2018/09/8crypto.png"
        ]));

    newsItemList.add(NewsItem(
        title: "Why cryptocurrency Bitcoin is headed for its worst week in months",
        author: "Dinesh",
        date: 1637390631000,
        details: "Bitcoin fell to a one-month low on Friday and was headed for its worst week in six months as traders have booked profits from a long rally and been spooked by an expectation that creditors of collapsed crypto exchange Mt Gox might liquidate their payments.",
        source: "Mint",
        imgUrls: [
          "https://image.shutterstock.com/image-photo/crypto-currency-background-various-shiny-260nw-1434643079.jpg",
          "https://www.trustetc.com/wp-content/uploads/2018/09/8crypto.png"
        ]));

    return newsItemList;
  }
}
