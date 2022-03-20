import 'package:crypto_khabar/ad/service/ad_helper.dart';
import 'package:crypto_khabar/article/model/article.dart';
import 'package:crypto_khabar/article/service/article_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ArticleProvider extends ChangeNotifier {
  List<Article> _articleList = [];
  List<Article> get articleList => _articleList;
  bool isLoading = false;
  bool isBannerAdReady = false;
  BannerAd bannerAd;

  ArticleProvider() {
    fetchNewsByPagination();
    initAd();
  }

  Future fetchNewsByPagination({bool appendInEnd = true}) async {
    isLoading = true;
    notifyListeners();
    final articleList = await ArticleService().fetchArticleByPagination(appendInEnd: appendInEnd);
  //  if (_articleList.length != articleList.length) {
      _articleList = articleList;
      notifyListeners();
      if(!appendInEnd){
        _articleList.sort((a,b){
          return b.date -a.date;
        });
      }
      notifyListeners();
    //}
    //  isLoading = false;
    // notifyListeners();
  }

  void onRefresh(RefreshController refreshController) async {
    await fetchNewsByPagination(appendInEnd: false);
    refreshController.refreshCompleted();
  }

  initAd() {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBannerAdReady = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          isBannerAdReady = false;
          notifyListeners();
          ad.dispose();
        },
      ),
    );
    bannerAd.load();
  }
}
