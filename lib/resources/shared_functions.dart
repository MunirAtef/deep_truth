
import 'package:fluttertoast/fluttertoast.dart';
import '../general/connectivity_check.dart';

class Shared {
  static bool isConnected(bool showToast) {
    if (ConnectivityCheck.isConnected) return true;
    if (showToast) Fluttertoast.showToast(msg: "No internet connection");
    return false;
  }

  static String getDate(int timestamp) {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestamp);

    String period = 'AM';
    int hour = dt.hour;
    if (hour > 12) {
      hour -= 12;
      period = 'PM';
    } else if (hour == 0) {
      hour = 12;
    }

    String hourStr = '$hour'.padLeft(2, '0');
    String minuteStr = '${dt.minute}'.padLeft(2, '0');
    return "${dt.day}/${dt.month}/${dt.year}   $hourStr:$minuteStr $period";
  }
}
