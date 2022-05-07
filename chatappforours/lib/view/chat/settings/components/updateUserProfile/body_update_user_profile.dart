import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/utilities/button/primary_button.dart';
import 'package:chatappforours/utilities/dialogs/error_dialog.dart';
import 'package:chatappforours/utilities/textField/text_field.dart';
import 'package:chatappforours/utilities/validator/check_format_field.dart';
import 'package:chatappforours/utilities/textField/text_field_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/constants.dart';

class BodyUpdateUserProfile extends StatefulWidget {
  const BodyUpdateUserProfile({Key? key}) : super(key: key);

  @override
  State<BodyUpdateUserProfile> createState() => _BodyUpdateUserProfileState();
}

class _BodyUpdateUserProfileState extends State<BodyUpdateUserProfile> {
  late final TextEditingController firstName;
  late final TextEditingController lastName;
  String errorStringFirstName = '';
  String errorStringLastName = '';
  final FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
  @override
  void initState() {
    firstName = TextEditingController();
    lastName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    final userOwnerID = FirebaseAuth.instance.currentUser!.uid;
    return SingleChildScrollView(
      child: Column(
        children: [
          if (!isKeyboard) SizedBox(height: size.height * 0.05),
          TextFieldContainer(
            child: Column(
              children: [
                TextField(
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: textColorMode(ThemeMode.light)),
                  onTap: () {
                    setState(
                      () {
                        errorStringFirstName =
                            checkFirstName(firstName.text, context);
                      },
                    );
                  },
                  onChanged: (val) {
                    setState(() {
                      errorStringFirstName = checkFirstName(val, context);
                    });
                  },
                  decoration: inputDecoration(
                    context: context,
                    textHint: context.loc.type_your_first_name,
                    icon: Icons.lock,
                    color: textColorMode(ThemeMode.light),
                  ),
                  controller: firstName,
                ),
                Visibility(
                  visible: errorStringFirstName.isNotEmpty,
                  child: Text(
                    errorStringFirstName,
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
                    if (errorStringLastName.isEmpty &&
                        errorStringFirstName.isEmpty) {
                      {
                        await firebaseUserProfile.upLoadUserProfile(
                          userID: userOwnerID,
                          fullName: "${firstName.text} ${lastName.text.trim()}",
                        );
                        await showErrorDialog(
                          context: context,
                          text: context.loc.update_user_profile_successfully,
                          title: context.loc.update_user_profile_notification,
                        );
                        firstName.clear();
                        lastName.clear();
                      }
                    }
                  },
                  textInputAction: TextInputAction.done,
                  style: TextStyle(color: textColorMode(ThemeMode.light)),
                  onTap: () {
                    setState(() {
                      errorStringLastName =
                          checkLastName(lastName.text.trim(), context);
                    });
                  },
                  onChanged: (val) {
                    setState(() {
                      errorStringLastName = checkLastName(val.trim(), context);
                    });
                  },
                  decoration: inputDecoration(
                    context: context,
                    textHint: context.loc.type_your_last_name,
                    icon: Icons.lock,
                    color: textColorMode(ThemeMode.light),
                  ),
                  controller: lastName,
                ),
                Visibility(
                  visible: errorStringLastName.isNotEmpty,
                  child: Text(
                    errorStringLastName,
                    style: const TextStyle(
                      color: kErrorColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kDefaultPadding),
            child: PrimaryButton(
              context: context,
              text: context.loc.update_user_profile,
              press: () async {
                if (errorStringLastName.isEmpty &&
                    errorStringFirstName.isEmpty) {
                  {
                    await firebaseUserProfile.upLoadUserProfile(
                      userID: userOwnerID,
                      fullName: "${firstName.text} ${lastName.text.trim()}",
                    );
                    await showErrorDialog(
                      context: context,
                      text: context.loc.update_user_profile_successfully,
                      title: context.loc.update_user_profile_notification,
                    );
                    firstName.clear();
                    lastName.clear();
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
