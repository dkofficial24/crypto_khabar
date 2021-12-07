import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AppUtils{

  static String formatDate(int date){
    final DateFormat formatter = DateFormat('MMM-dd,yyyy hh:mm a');
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  static void showToast(String msg){
    Fluttertoast.showToast(msg: msg);
  }

}