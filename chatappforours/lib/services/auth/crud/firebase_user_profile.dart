import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:chatappforours/services/auth/crud/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseUserProfile {
  final userProfilePath = FirebaseFirestore.instance.collection('UserProfile');
  final DatabaseReference userPresenceDatabaseReference =
      FirebaseDatabase.instance.ref('userPresence');
  Future<void> createUserProfile({
    required String userID,
    required UserProfile userProfile,
  }) async {
    await userProfilePath.doc(userID).set(
      {
        fullNameField: userProfile.fullName,
        emailField: userProfile.email,
        urlImageField: userProfile.urlImage,
        isDarkModeField: userProfile.isDarkMode
      },
    );
  }

  Future<UserProfile?> getUserProfile({
    required String? userID,
    bool isOnline = false,
  }) async {
    if (userID != null) {
      final userProfileSnapshot = await userProfilePath.doc(userID).get();
      return UserProfile.fromSnapshot(userProfileSnapshot);
    }
    return null;
  }

  Future<void> uploadUserImage({
    required String? userID,
    required String? urlImage,
  }) async {
    if (userID != null) {
      Map<String, dynamic> mapUser = <String, dynamic>{};
      mapUser.addAll({urlImageField: urlImage});
      await userProfilePath.doc(userID).update(mapUser);
    }
  }

  Future<void> uploadDarkTheme({
    required String? userID,
    required bool isDarkTheme,
  }) async {
    if (userID != null) {
      Map<String, dynamic> mapUser = <String, dynamic>{};
      mapUser.addAll({isDarkModeField: isDarkTheme});
      await userProfilePath.doc(userID).update(mapUser);
    }
  }

  Future<void> updateUserPresenceDisconnect({required String uid}) async {
    Map<String, dynamic> presenceStatusTrue = {
      'presence': true,
    };
    await userPresenceDatabaseReference.child(uid).update(
          presenceStatusTrue,
        );
    Map<String, dynamic> presenceStatusFalse = {
      'presence': false,
    };
    await userPresenceDatabaseReference.child(uid).onDisconnect().update(
          presenceStatusFalse,
        );
  }

  Future<void> updateUserPresence(
      {required String uid, required bool bool}) async {
    Map<String, dynamic> presenceStatusFalse = {
      'presence': bool,
    };
    await userPresenceDatabaseReference.child(uid).update(presenceStatusFalse);
  }
}
