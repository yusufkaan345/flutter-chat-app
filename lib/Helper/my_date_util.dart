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

  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;
    if (i == -1) {
      return "Last Seen Available";
    }
    final DateTime time = DateTime.fromMicrosecondsSinceEpoch(i);
    final DateTime now = DateTime.now();
    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (now.day == time.day &&
        now.month == time.month &&
        now.year == time.year) {
      return "Last seen todat at ${formattedTime}";
    }
    if ((now.difference(time).inHours / 24).round() == 1)
      return 'Last seen yesterday at $formattedTime';
    String month = _getMonth(time);
    return 'Last seen $month $formattedTime';
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
