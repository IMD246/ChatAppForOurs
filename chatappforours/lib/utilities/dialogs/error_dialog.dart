import 'package:chatappforours/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';
Future<void> showErrorDialog(
  {required BuildContext context,
  required String text,required String title}
  
) {
  return showGenericDialog<void>(
    context: context,
    title: title,
    content: text,
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
