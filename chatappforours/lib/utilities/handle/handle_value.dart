import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
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

String differenceInCalendarDaysLocalization(
    DateTime earlier, BuildContext? context) {
  if (context != null) {
    DateTime later = DateTime.now();
    if (later.difference(earlier).inHours >= 0 &&
        later.difference(earlier).inHours < 24) {
      if (later.difference(earlier).inMinutes >= 0 &&
          later.difference(earlier).inMinutes < 1) {
        return "${later.difference(earlier).inSeconds} ${context.loc.seconds} ${context.loc.ago}";
      } else if (later.difference(earlier).inMinutes >= 1 &&
          later.difference(earlier).inMinutes < 60) {
        return "${later.difference(earlier).inMinutes} ${context.loc.minutes} ${context.loc.ago}";
      } else if (later.difference(earlier).inMinutes >= 60) {
        return "${later.difference(earlier).inHours} ${context.loc.hours} ${context.loc.ago}";
      }
    } else if (later.difference(earlier).inHours >= 24 &&
        later.difference(earlier).inHours < 720) {
      return "${later.difference(earlier).inDays} ${context.loc.days} ${context.loc.ago}";
    } else {
      int month = 1;
      month = (month * later.difference(earlier).inDays / 30).round();
      return "$month ${context.loc.months} ${context.loc.ago}";
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

String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(
    duration.inMinutes.remainder(60),
  );
  final seconds = twoDigits(
    duration.inSeconds.remainder(60),
  );
  return [
    if (duration.inHours > 0) hours,
    minutes,
    seconds,
  ].join(':');
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

String getStringMessageByTypeMessage(
    {required TypeMessage typeMessage,
    required String value,
    required BuildContext context}) {
  if (typeMessage == TypeMessage.text) {
    getStringFromList(value);
  } else if (typeMessage == TypeMessage.image) {
    return handleStringMessageLocalization(
      getStringFromList(value),
      context,
    );
  } else if (typeMessage == TypeMessage.audio) {
    return context.loc.message_recording;
  }
  return value;
}

String handleStringMessageLocalization(String value, BuildContext context) {
  final List<String> list =
      value.substring(value.length - 9, value.length).split(" ");
  final v1 = value.substring(0, value.length - 12);
  final string1 = context.loc.sent_text_image + " ";
  final string2 = list.elementAt(1) + " ";
  final string3 = context.loc.photo;
  final string = v1 + string1 + string2 + string3;
  return string;
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

String handleListUserIDChat(Chat chat, UserProfile ownerUserProfile) {
  int count = 0;
  for (var element in chat.listUser) {
    if (element == ownerUserProfile.idUser) {
      if (count >= 2) {
        continue;
      }
      count++;
    }
  }
  if (count >= 2) {
    return ownerUserProfile.idUser!;
  } else {
    return chat.listUser
        .where(
          (element) => element != ownerUserProfile.idUser!,
        )
        .first;
  }
}
