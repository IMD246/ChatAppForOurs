import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/utilities/button/primary_button.dart';
import 'package:chatappforours/utilities/dialogs/error_dialog.dart';
import 'package:chatappforours/utilities/textField/text_field.dart';
import 'package:chatappforours/utilities/validator/check_format_field.dart';
import 'package:chatappforours/utilities/textField/text_field_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/constants.dart';

class BodyChangeUserProfile extends StatefulWidget {
  const BodyChangeUserProfile({Key? key}) : super(key: key);

  @override
  State<BodyChangeUserProfile> createState() => _BodyChangeUserProfileState();
}

class _BodyChangeUserProfileState extends State<BodyChangeUserProfile> {
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
    final userOwnerID = FirebaseAuth.instance.currentUser!.uid;
    return Column(
      children: [
        const SizedBox(height: 100),
        TextFieldContainer(
          child: Column(
            children: [
              TextField(
                textInputAction: TextInputAction.next,
                style: TextStyle(color: textColorMode(ThemeMode.light)),
                onTap: () {
                  setState(() {
                    errorStringFirstName = checkFirstName(firstName.text);
                  });
                },
                onChanged: (val) {
                  setState(() {
                    errorStringFirstName = checkFirstName(val);
                  });
                },
                decoration: inputDecoration(
                  context: context,
                  textHint: 'Type Your First Name',
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
                        fullName: "${firstName.text} ${lastName.text}",
                      );
                      await showErrorDialog(
                        context: context,
                        text: "Update User Profile successfully!",
                        title: "Update User Profile Notification",
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
                    errorStringLastName = checkLastName(lastName.text);
                  });
                },
                onChanged: (val) {
                  setState(() {
                    errorStringLastName = checkLastName(val);
                  });
                },
                decoration: inputDecoration(
                  context: context,
                  textHint: 'Type Your Last Name',
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
        SizedBox(height: size.height * 0.03),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: PrimaryButton(
            context: context,
            text: 'Update Profile',
            press: () async {
              if (errorStringLastName.isEmpty && errorStringFirstName.isEmpty) {
                {
                  await firebaseUserProfile.upLoadUserProfile(
                    userID: userOwnerID,
                    fullName: "${firstName.text} ${lastName.text}",
                  );
                  await showErrorDialog(
                    context: context,
                    text: "Update User Profile successfully!",
                    title: "Update User Profile Notification",
                  );
                  firstName.clear();
                  lastName.clear();
                }
              }
            },
          ),
        )
      ],
    );
  }
}
