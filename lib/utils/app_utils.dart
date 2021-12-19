import 'package:crypto_khabar/dashboard/model/news_item.dart';
import 'package:crypto_khabar/shared/services/shared_pref_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class AppUtils {
  static String formatDate(int date) {
    final DateFormat formatter = DateFormat('MMM-dd,yyyy hh:mm a');
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  static void shareNews(NewsItem newsItem) {
    String detail =
        "-${newsItem.title}- \n\n ${newsItem.details} \n ${newsItem?.sourceLink ?? ''}";
    Share.share(detail, subject: newsItem.title);
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
}
