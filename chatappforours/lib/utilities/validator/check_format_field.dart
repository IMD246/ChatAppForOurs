import 'package:chatappforours/extensions/locallization.dart';
import 'package:flutter/material.dart';

String checkFormatEmail(String val, BuildContext context) {
  String pattern = r'(^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})$)';
  RegExp regExp = RegExp(pattern);
  return val.isEmpty
      ? context.loc.enter_your_email
      : (val.split('@')[0].length > 30 || val.split('@')[0].length < 6)
          ? context.loc.check_your_email_address_length
          : (!regExp.hasMatch(val.toString())
              ? context.loc.check_format_your_email
              : '');
}

String checkPassword(String val, BuildContext context) {
  return val.isEmpty
      ? context.loc.enter_your_password
      : (val.length < 6 ? context.loc.weak_password : "");
}

String checkDuplicatePassword(String val, String val2, BuildContext context) {
  return val != val2 ? context.loc.your_password_is_not_duplicate : "";
}

String checkFirstName(String val, BuildContext context) {
  return val.isEmpty
      ? context.loc.enter_your_first_name
      : (val.length < 3 ? context.loc.check_your_first_name_length : '');
}

String checkLastName(String val, BuildContext context) {
  return val.isEmpty
      ? context.loc.enter_your_last_name
      : (val.length < 3 ? context.loc.check_your_last_name_length : '');
}
