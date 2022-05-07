import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:flutter/material.dart';

String differenceInCalendarDays(DateTime earlier, BuildContext? context) {
  if (context != null) {
    DateTime later = DateTime.now();
    if (later.difference(earlier).inHours >= 0 &&
        later.difference(earlier).inHours < 24) {
      if (later.difference(earlier).inMinutes >= 0 &&
          later.difference(earlier).inMinutes < 1) {
        return "${later.difference(earlier).inSeconds} s ${context.loc.ago}";
      } else if (later.difference(earlier).inMinutes >= 1 &&
          later.difference(earlier).inMinutes < 60) {
        return "${later.difference(earlier).inMinutes} min ${context.loc.ago}";
      } else if (later.difference(earlier).inMinutes >= 60) {
        return "${later.difference(earlier).inHours} h ${context.loc.ago}";
      }
    } else if (later.difference(earlier).inHours >= 24 &&
        later.difference(earlier).inHours < 720) {
      return "${later.difference(earlier).inDays} d ${context.loc.ago}";
    } else {
      int month = 1;
      month = (month * later.difference(earlier).inDays / 30).round();
      return "$month m ${context.loc.ago}";
    }
  }

  return "";
}

String differenceInCalendarPresence(DateTime earlier) {
  DateTime later = DateTime.now();
  if (later.difference(earlier).inHours >= 0 &&
      later.difference(earlier).inHours < 24) {
    if (later.difference(earlier).inMinutes >= 0 &&
        later.difference(earlier).inMinutes < 1) {
      return "${later.difference(earlier).inSeconds} s";
    } else if (later.difference(earlier).inMinutes >= 1 &&
        later.difference(earlier).inMinutes < 60) {
      return "${later.difference(earlier).inMinutes} min";
    } else if (later.difference(earlier).inMinutes >= 60) {
      return "${later.difference(earlier).inHours} h";
    }
  } else if (later.difference(earlier).inHours >= 24 &&
      later.difference(earlier).inHours < 720) {
    return "${later.difference(earlier).inDays} d";
  } else {
    int month = 1;
    month = (month * later.difference(earlier).inDays / 30).round();
    return "$month m";
  }
  return "no time to die";
}

String differenceInCalendarStampTime(DateTime earlier) {
  String month = earlier.month.toString();
  String minute = earlier.minute.toString();
  String hour = earlier.hour.toString();
  String day = earlier.day.toString();
  if (earlier.month < 10 || earlier.month <= 1) {
    month = "0" + month.toString();
  }
  if (earlier.hour <= 0 || earlier.hour < 10) {
    hour = "0" + hour.toString();
  }
  if (earlier.minute <= 0 || earlier.minute < 10) {
    minute = "0" + minute.toString();
  }
  if (earlier.day <= 1 || earlier.day < 10) {
    day = "0" + day.toString();
  }
  final String value = "$day/$month $hour:$minute";

  return value;
}

bool checkDifferenceInCalendarInMinutes(DateTime earlier) {
  DateTime later = DateTime.now();
  if (later.difference(earlier).inMinutes <= 0) {
    return false;
  } else {
    return true;
  }
}

bool checkDifferenceBeforeAndCurrentIndexInMinutes(
    DateTime earlier, DateTime later) {
  if (later.difference(earlier).inMinutes >= 30) {
    return true;
  } else {
    return false;
  }
}

bool checkDifferenceBeforeAndCurrentTimeGreaterThan10Minutes(
    DateTime earlier, DateTime later) {
  if (later.difference(earlier).inMinutes >= 30) {
    return true;
  } else {
    return false;
  }
}

String handleStringMessage(String value) {
  final list = value.split('\n');
  if (list.length > 1) {
    return value;
  } else {
    if (value.length >= 18) {
      final count = (value.length / 17).round();
      String v = "";
      for (int i = 0; i < count; i++) {
        if (i != count - 1) {
          final v1 = "${value.substring((17 * i) + i, (17 * (i + 1)))} \n";
          v = v + v1;
        } else {
          final v1 = value.substring((17 * i) + i, value.length);
          v = v + v1;
        }
      }
      return v;
    } else {
      return value;
    }
  }
}

String getStringFromList(String value) {
  final list = value.split('\n');
  if (list.length > 1) {
    final list = value.split('\n').toString();
    return list.substring(1, list.length - 1).replaceAll(',', ' ');
  } else {
    return value;
  }
}

String getStringMessageStatus(
    MessageStatus messageStatus, BuildContext context) {
  if (messageStatus == MessageStatus.notSent) {
    return context.loc.not_sent;
  } else if (messageStatus == MessageStatus.sent) {
    return context.loc.sent;
  } else {
    return context.loc.viewed;
  }
}

String handleNameChat(
    String ownerUserID, String userIDChat, Chat chat, BuildContext context) {
  if (ownerUserID == userIDChat) {
    return context.loc.only_you;
  } else {
    return chat.nameChat ?? "";
  }
}
