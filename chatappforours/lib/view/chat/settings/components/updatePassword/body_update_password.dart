import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/utilities/button/primary_button.dart';
import 'package:chatappforours/utilities/dialogs/error_dialog.dart';
import 'package:chatappforours/utilities/textField/text_field.dart';
import 'package:chatappforours/utilities/validator/check_format_field.dart';
import 'package:chatappforours/utilities/textField/text_field_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/constants.dart';

class BodyUpdatePassword extends StatefulWidget {
  const BodyUpdatePassword({Key? key}) : super(key: key);

  @override
  State<BodyUpdatePassword> createState() => _BodyUpdatePasswordState();
}

class _BodyUpdatePasswordState extends State<BodyUpdatePassword> {
  late final TextEditingController password;
  late final TextEditingController verifyPassword;
  String errorStringPassWord = '';
  String errorStringVerifyPassWord = '';
  bool isVisiblePassWord = false;
  bool isVisibleVerifyPassWord = false;
  final FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
  final authUser = FirebaseAuth.instance.currentUser;
  late final UserProfile? userProfile;
  @override
  void initState() {
    password = TextEditingController();
    verifyPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    password.dispose();
    verifyPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Column(
      children: [
        if (!isKeyboard) const SizedBox(height: 100),
        TextFieldContainer(
          child: Column(
            children: [
              TextField(
                textInputAction: TextInputAction.next,
                style: TextStyle(color: textColorMode(ThemeMode.light)),
                onTap: () {
                  setState(() {
                    errorStringPassWord = checkPassword(password.text, context);
                  });
                },
                onChanged: (val) {
                  setState(() {
                    errorStringPassWord = checkPassword(val, context);
                  });
                },
                decoration: inputDecoration(
                  context: context,
                  textHint: context.loc.type_your_password,
                  icon: Icons.lock,
                  color: textColorMode(ThemeMode.light),
                ).copyWith(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(
                        () {
                          isVisiblePassWord = !isVisiblePassWord;
                        },
                      );
                    },
                    icon: Icon(
                      isVisiblePassWord
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: textColorMode(ThemeMode.light),
                    ),
                  ),
                ),
                controller: password,
                obscureText: !isVisiblePassWord ? true : false,
              ),
              Visibility(
                visible: errorStringPassWord.isNotEmpty,
                child: Text(
                  errorStringPassWord,
                  style: const TextStyle(
                    color: kErrorColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        TextFieldContainer(
          child: Column(
            children: [
              TextField(
                onSubmitted: (_) async {
                  if (errorStringVerifyPassWord.isEmpty &&
                      errorStringPassWord.isEmpty) {
                    {
                      await FirebaseAuth.instance.currentUser!
                          .updatePassword(password.text);
                      await showErrorDialog(
                        context: context,
                        text: "Update password successfully!",
                        title: "Update Password Notification",
                      );
                      password.clear();
                      verifyPassword.clear();
                    }
                  }
                },
                textInputAction: TextInputAction.done,
                style: TextStyle(color: textColorMode(ThemeMode.light)),
                onTap: () {
                  setState(() {
                    errorStringVerifyPassWord = checkDuplicatePassword(
                        password.text, verifyPassword.text, context);
                  });
                },
                onChanged: (val) {
                  setState(() {
                    errorStringVerifyPassWord = checkDuplicatePassword(
                      password.text,
                      val.toString(),
                      context,
                    );
                  });
                },
                decoration: inputDecoration(
                  context: context,
                  textHint: context.loc.type_verify_password,
                  icon: Icons.lock,
                  color: textColorMode(ThemeMode.light),
                ).copyWith(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(
                        () {
                          isVisibleVerifyPassWord = !isVisibleVerifyPassWord;
                        },
                      );
                    },
                    icon: Icon(
                      isVisibleVerifyPassWord
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: textColorMode(ThemeMode.light),
                    ),
                  ),
                ),
                controller: verifyPassword,
                obscureText: !isVisibleVerifyPassWord ? true : false,
              ),
              Visibility(
                visible: errorStringVerifyPassWord.isNotEmpty,
                child: Text(
                  errorStringVerifyPassWord,
                  style: const TextStyle(
                    color: kErrorColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: PrimaryButton(
            context: context,
            text: context.loc.update_password,
            press: () async {
              if (errorStringVerifyPassWord.isEmpty &&
                  errorStringPassWord.isEmpty) {
                {
                  try {
                    await authUser!.updatePassword(password.text);
                    await showErrorDialog(
                      context: context,
                      text: context.loc.update_password_successfully,
                      title: context.loc.update_password_notification,
                    );
                  } catch (_) {
                    setState(() {
                      final credential = EmailAuthProvider.credentialWithLink(
                          email: authUser!.email!, emailLink: authUser!.email!);
                      authUser!.linkWithCredential(credential);
                      authUser!.updatePassword(password.text);
                      showErrorDialog(
                        context: context,
                        text: context.loc.update_password_successfully,
                        title: context.loc.update_password_notification,
                      );
                    });
                  }
                  password.clear();
                  verifyPassword.clear();
                }
              }
            },
          ),
        )
      ],
    );
  }
}