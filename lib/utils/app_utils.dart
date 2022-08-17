import 'package:crypto_khabar/article/model/article.dart';
import 'package:crypto_khabar/constants.dart';
import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/dashboard/service/news_service.dart';
import 'package:crypto_khabar/shared/services/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class AppUtils {
  static String formatDate(int date) {
    final DateFormat formatter = DateFormat('MMM-dd,yyyy hh:mm a');
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  static String chartHorizontalTime(int date) {
    final DateFormat formatter = DateFormat('MMM-dd hh');
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  static String formatOnlyDate(int date) {
    final DateFormat formatter = DateFormat('MMM-dd,yyyy');
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  static String formatDateTime(DateTime date) {
    final DateFormat formatter = DateFormat('MMM-dd,yyyy');
    return formatter.format(date);
  }

  static void showToast(String msg) {
    if (isAppInBackground) return;
    Fluttertoast.showToast(msg: msg);
  }

  static void shareNews(NewsItem newsItem, {String appLink = ''}) {
    String detail = "${newsItem.title} \n\n $appLink";
    Share.share(detail, subject: newsItem.title);
    NewsService().incrementShareCount(newsItem.id);
  }

  static void shareArticle(Article article, {String appLink = ''}) {
    String detail = "${article.title} \n '$appLink";
    Share.share(detail, subject: article.title);
  }

  static Future<bool> isThemeManuallySet() async {
    String status = await SharedPrefHelper().getValue("isThemeManuallySetKey");
    if (status == null) {
      return false;
    }
    return status == "true";
  }

  static Future markThemeManuallySet() async {
    await SharedPrefHelper().saveValue("isThemeManuallySetKey", true);
  }

  static bool isValidUrl(String url) {
    if (url == null || url.isEmpty) {
      return false;
    }
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  static String currencyFormat(int num) {
    var _formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: 2,
      locale: 'en_IN',
      name: "",
    ).format(num);
    return _formattedNumber;
  }

  static bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static void showSnack(BuildContext context, String text,
      {Function action, String actionText}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        action: action != null
            ? SnackBarAction(
                onPressed: action,
                label: actionText ?? "",
              )
            : null,
      ),
    );
  }
}
