import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDateUtils {
  static getFormattedDate(BuildContext context, String time) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int timestamp = int.tryParse(lastActive) ?? -1;
    if (timestamp == -1) return 'Last seen not available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();

    // Format time for "today" and "yesterday"
    String formattedTime = DateFormat.jm().format(time);

    // Check if it's today
    if (time.year == now.year &&
        time.month == now.month &&
        time.day == now.day) {
      return 'Last seen today at $formattedTime';
    }

    // Check if it's yesterday
    if (time.year == now.year &&
        time.month == now.month &&
        now.day - time.day == 1) {
      return 'Last seen yesterday at $formattedTime';
    }

    // Format for other dates
    String formattedDate = DateFormat('d MMM ').format(time);
    return 'Last seen on $formattedDate at $formattedTime';
  }

  static String getLastMessageTime({
    required BuildContext context,
    required String time,
    bool showYear = false,
  }) {
    // Check if the timestamp is in seconds (10 digits) or milliseconds (13 digits)
    final int timestamp =
        time.length == 10 ? int.parse(time) * 1000 : int.parse(time);

    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final DateTime now = DateTime.now();

    // Check if the message was sent today
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    // Format based on whether the year should be displayed
    final String dateFormat = showYear ? 'd MMM yyyy' : 'd MMM';
    return DateFormat(dateFormat).format(sent);
  }
}
