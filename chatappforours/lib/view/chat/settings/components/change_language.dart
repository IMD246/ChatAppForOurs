import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/Theme/theme_changer.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({Key? key}) : super(key: key);

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  final FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
  final String userID = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          context.loc.language,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 0.5,
          vertical: kDefaultPadding,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  value: "vi",
                  groupValue: themeChanger.langugage,
                  onChanged: (val) {
                    setState(
                      () {
                        themeChanger.setLanguge(val.toString());
                        firebaseUserProfile.updateUserLanguage(
                          userID: userID,
                          language: themeChanger.langugage,
                        );
                      },
                    );
                  },
                ),
                Text(context.loc.vietnamese),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: "en",
                  groupValue: themeChanger.langugage,
                  onChanged: (val) {
                    setState(() {
                      themeChanger.setLanguge(val.toString());
                      firebaseUserProfile.updateUserLanguage(
                        userID: userID,
                        language: themeChanger.langugage,
                      );
                    });
                  },
                ),
                Text(context.loc.english),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
