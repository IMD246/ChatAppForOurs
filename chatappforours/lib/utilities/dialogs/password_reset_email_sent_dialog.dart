import 'package:chatappforours/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Reset PassWord',
    content: 'Reset PassWord Dialog',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
