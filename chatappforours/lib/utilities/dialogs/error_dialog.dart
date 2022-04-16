import 'package:chatappforours/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';
Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'Generic Error',
    content: text,
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
