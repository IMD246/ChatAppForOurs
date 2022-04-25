import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:chatappforours/utilities/time_handle/handle_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  final String email;
  final String fullName;
  final String? urlImage;
  final bool isDarkMode;
  final String? stampTime;
  const UserProfile({
    required this.email,
    required this.fullName,
    required this.urlImage,
    required this.isDarkMode,
    this.stampTime,
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
        stampTime: differenceInCalendarDays(
          snapshot.get(stampTimeField).toDate(),
        ),
      );
}
