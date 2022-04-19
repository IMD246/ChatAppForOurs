import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:chatappforours/services/auth/crud/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserProfile {
  final userProfilePath = FirebaseFirestore.instance.collection('UserProfile');
  Future<void> createNewNote({
    required String userID,
    required UserProfile userProfile,
  }) async {
    await userProfilePath.doc(userID).set(
      {
        fullNameField: userProfile.fullName,
        emailField: userProfile.email,
        urlImageField : userProfile.urlImage,
        isDarkModeField: userProfile.isDarkMode
      },
    );
  }

  Future<UserProfile?> getUserProfile({
    required String? userID,
  }) async {
    if (userID != null) {
      final userProfileSnapshot = await userProfilePath.doc(userID).get();
      return UserProfile.fromSnapshot(userProfileSnapshot);
    }
    return null;
  }
}
