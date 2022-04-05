import 'package:chatappforours/constants/constants.dart';
import 'package:flutter/material.dart';

InputDecoration inputDecoration({
  required BuildContext context,
  required String textHint,
  required IconData icon,
}) {
  return InputDecoration(
    prefixIcon: Icon(
      icon,
      color: textColorMode(context).withOpacity(0.7),
    ),
    hintText: textHint,
    hintStyle: TextStyle(
      color: textColorMode(context),
    ),
    border: InputBorder.none,
  );
}
