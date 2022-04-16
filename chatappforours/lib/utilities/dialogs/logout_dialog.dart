import 'package:chatappforours/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';
Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Logout',
    content: 'Dialog Logout',
    optionsBuilder: () => {
      'Canccel': false,
      'Yes': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
