import 'dart:io';

import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String? idUser;
  final String email;
  final String fullName;
  final String urlImage;
  final String language;
  final String? tokenUser;
  bool? isEmailVerified = false;
  bool isDarkMode = false;
  bool presence = false;
  DateTime stampTime = DateTime.now();
  UserProfile({
    required this.tokenUser,
    required this.language,
    this.idUser,
    required this.email,
    required this.fullName,
    required this.urlImage,
    required this.isDarkMode,
    this.isEmailVerified,
  });
  factory UserProfile.fromSnapshot(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      UserProfile(
        email: snapshot.get(emailField),
        fullName: snapshot.get(fullNameField),
        isEmailVerified: snapshot.get(isEmailVerifiedField),
        urlImage: snapshot.get(urlImageField).toString().isEmpty
            ? null
            : snapshot.get(urlImageField),
        isDarkMode: snapshot.get(isDarkModeField),
        idUser: snapshot.id,
        language: snapshot.data()?[languageField] != null
            ? snapshot.get(languageField)
            : Platform.localeName.substring(0, 2).toString(),
        tokenUser: snapshot.data()?[tokenUserField] != null
            ? snapshot.get(tokenUserField)
            : null,
      );
}
