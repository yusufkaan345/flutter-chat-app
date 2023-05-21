import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDate {
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final timeInt = int.parse(time);
    final dateTime = DateTime.fromMicrosecondsSinceEpoch(timeInt);
    final formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  }

  static String getlastMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sendTime =
        DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sendTime.day &&
        now.month == sendTime.month &&
        now.year == sendTime.year) {
      return DateFormat.jm().format(sendTime);
    }
    return '${sendTime.day} ${_getMonth(sendTime)}';
  }

  static _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Aug';
      case 8:
        return 'Sep';
      case 9:
        return 'Oct';
      case 10:
        return 'Now';
      case 11:
        return 'Dec';
      case 12:
        return 'Jan';
    }
    return 'NA';
  }
}
