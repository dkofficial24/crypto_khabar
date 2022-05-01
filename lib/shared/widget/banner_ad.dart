import 'package:crypto_khabar/ad/service/ad_helper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  bool isBannerAdReady = false;
  BannerAd bannerAd;

  @override
  void initState() {
    initAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return AdHelper.isAdEnabled() && isBannerAdReady
          ? Container(
        width: bannerAd.size.width.toDouble(),
        height: bannerAd.size.height.toDouble(),
        child: AdWidget(ad: bannerAd),
      )
          : Container();
  }

  initAd() {
    if (AdHelper.isAdEnabled()) {
      bannerAd = BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              isBannerAdReady = true;
              FirebaseAnalytics.instance.logEvent(name: 'ad_ready_event');
            });
          },
          onAdFailedToLoad: (ad, err) {
            print('Failed to load a banner ad: ${err.message}');
            setState(() {
              isBannerAdReady = false;
            });
            ad.dispose();
          },
        ),
      );
      bannerAd.load();
    }
  }

  @override
  void dispose() {
    bannerAd.dispose();
    super.dispose();
  }
}
