import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showPasswordResetDialog(
    {required BuildContext context, required String text}) {
  return showGenericDialog<void>(
    context: context,
    title: context.loc.reset_password_dialog,
    content: text,
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
