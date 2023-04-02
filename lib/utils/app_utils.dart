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
    final formatter = DateFormat('MMM-dd,yyyy hh:mm a');
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  static String chartHorizontalTime(int date) {
    final formatter = DateFormat('MMM-dd hh');
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  static String formatOnlyDate(int date) {
    final formatter = DateFormat('MMM-dd,yyyy');
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  static String formatDateTime(DateTime date) {
    final formatter = DateFormat('MMM-dd,yyyy');
    return formatter.format(date);
  }

  static void showToast(String msg, {Toast toastLength = Toast.LENGTH_SHORT}) {
    if (isAppInBackground) return;
    Fluttertoast.showToast(msg: msg, toastLength: toastLength);
  }

  static void shareNews(NewsItem newsItem, {String appLink = ''}) {
    final detail = '${newsItem.title} \n\n $appLink';
    Share.share(detail, subject: newsItem.title);
    NewsService().incrementShareCount(newsItem.id);
  }

  static void shareArticle(Article article, {String appLink = ''}) {
    final detail = "${article.title} \n '$appLink";
    Share.share(detail, subject: article.title);
  }

  static Future<bool> isThemeManuallySet() async {
    final status = await SharedPrefHelper().getValue('isThemeManuallySetKey');
    if (status == null) {
      return false;
    }
    return status == 'true';
  }

  static Future markThemeManuallySet() async {
    await SharedPrefHelper().saveValue('isThemeManuallySetKey', true);
  }

  static bool isValidUrl(String url) {
    if (url == null || url.isEmpty) {
      return false;
    }
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  static String currencyFormat(int num) {
    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: 2,
      locale: 'en_IN',
      name: '',
    ).format(num);
    return formattedNumber;
  }

  static bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static const Duration _snackBarDisplayDuration = Duration(milliseconds: 4000);

  static void showSnackBar(BuildContext context, String text,
      {Function action,
      String actionText = 'Dismiss',
      Duration duration = _snackBarDisplayDuration,
      Color backgroundColor = Colors.black,
      Color textColor,
      SnackBarBehavior behavior = SnackBarBehavior.fixed,}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: backgroundColor,
        behavior: behavior,
        action: SnackBarAction(
          onPressed: action ?? () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
          label: actionText,
          textColor: Colors.white,
        ),
        duration: duration,
      ),
    );
  }
}
