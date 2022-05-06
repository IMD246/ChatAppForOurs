import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String? idUser;
  final String email;
  final String fullName;
  final String? urlImage;
  bool? isEmailVerified = false;
  bool isDarkMode = false;
  UserProfile(
    {
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
      );
}
