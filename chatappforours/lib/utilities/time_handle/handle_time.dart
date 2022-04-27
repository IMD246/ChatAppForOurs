String differenceInCalendarDays(DateTime earlier) {
  DateTime later = DateTime.now();
  if (later.difference(earlier).inHours >= 0 &&
      later.difference(earlier).inHours < 24) {
    if (later.difference(earlier).inMinutes >= 0 &&
        later.difference(earlier).inMinutes < 1) {
      return "${later.difference(earlier).inSeconds} s ago";
    } else if (later.difference(earlier).inMinutes >= 1 &&
        later.difference(earlier).inMinutes < 60) {
      return "${later.difference(earlier).inMinutes} min ago";
    } else if (later.difference(earlier).inMinutes >= 60) {
      return "${later.difference(earlier).inHours} h ago";
    }
  } else if (later.difference(earlier).inHours >= 24 &&
      later.difference(earlier).inHours < 720) {
    return "${later.difference(earlier).inDays} d ago";
  } else {
    int month = 1;
    month = (month * later.difference(earlier).inDays / 30).round();
    return "$month m ago";
  }
  return "no time to die";
}
