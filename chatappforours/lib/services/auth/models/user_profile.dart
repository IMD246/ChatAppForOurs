import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  final String? idUser;
  final String email;
  final String fullName;
  final String? urlImage;
  final bool isDarkMode;
  const UserProfile({
    this.idUser,
    required this.email,
    required this.fullName,
    required this.urlImage,
    required this.isDarkMode,
  });
  factory UserProfile.fromSnapshot(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      UserProfile(
        email: snapshot.get(emailField),
        fullName: snapshot.get(fullNameField),
        urlImage: snapshot.get(urlImageField).toString().isEmpty
            ? null
            : snapshot.get(urlImageField),
        isDarkMode: snapshot.get(isDarkModeField),
        idUser: snapshot.id,
      );
}
