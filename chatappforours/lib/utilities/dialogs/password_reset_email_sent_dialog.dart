import 'package:chatappforours/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showPasswordResetSentDialog({required BuildContext context, required String text}) {
  return showGenericDialog<void>(
    context: context,
    title: 'Reset PassWord',
    content: 'Reset PassWord Dialog',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
