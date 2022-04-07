import 'package:flutter/material.dart';

InputDecoration inputDecoration({
  required BuildContext context,
  required String textHint,
  required IconData? icon,
  required Color color,
}) {
  return InputDecoration(
    prefixIcon: Icon(
      icon,
      color: color.withOpacity(0.7),
    ),
    hintText: textHint,
    hintStyle: TextStyle(
      color: color,
    ),
    border: InputBorder.none,
  );
}