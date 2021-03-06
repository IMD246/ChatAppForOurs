import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_presence.dart';
import 'package:chatappforours/services/auth/models/auth_exception.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
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
        emailField: userProfile.email,
        fullNameField: userProfile.fullName,
        urlImageField: userProfile.urlImage,
        isDarkModeField: userProfile.isDarkMode,
        languageField: userProfile.language,
        isEmailVerifiedField: userProfile.isEmailVerified,
      },
    );
  }

  Stream<Iterable<Future<UserProfile>>?> getAllUserProfileBySearchText(
      String ownerUserID, String? searchText) {
                final firebaseUserProfile = FirebaseUserProfile();
    if (searchText?.isEmpty == true) {
      final listUserProfile = userProfilePath.limit(20).snapshots().map(
        (event) {
          if (event.docs.isNotEmpty) {
            return event.docs.map(
              (e) async {
                final userProfile = UserProfile.fromSnapshot(e);
                final getUserProfile = await firebaseUserProfile.getUserProfile(
                  userID: userProfile.idUser,
                );
                return getUserProfile!;
              },
            );
          } else {
            return null;
          }
        },
      );
      return listUserProfile;
    } else {
      final String text = searchText! + "\uf8ff";
      final listUserProfile = userProfilePath
          .where(fullNameField, isGreaterThanOrEqualTo: searchText)
          .where(fullNameField, isLessThanOrEqualTo: text)
          .orderBy(fullNameField, descending: true)
          .limit(20)
          .snapshots()
          .map(
        (event) {
          if (event.docs.isNotEmpty) {
            return event.docs.map(
              (e) async{
                  final userProfile = UserProfile.fromSnapshot(e);
                final getUserProfile = await firebaseUserProfile.getUserProfile(
                  userID: userProfile.idUser,
                );
                return getUserProfile!;
              },
            );
          } else {
            return null;
          }
        },
      );
      return listUserProfile;
    }
  }

  Future<UserProfile?> getUserProfile({
    required String? userID,
  }) async {
    try {
      final doc = await userProfilePath.doc(userID).get();
      final userProfile = UserProfile.fromSnapshot(doc);
      final firebaseUserPresence = FirebaseUserPresence();
      final userPresence =
          await firebaseUserPresence.getUserPresence(userID: userID!);
      userProfile.presence = userPresence.presence;
      userProfile.stampTime = userPresence.stampTime;
      return userProfile;
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  Future<UserProfile?> getUserProfileByEmail({
    required String? email,
  }) async {
    try {
      return await userProfilePath
          .where(emailField, isEqualTo: email)
          .get()
          .then(
        (value) {
          if (value.docs.isNotEmpty) {
            return UserProfile.fromSnapshot(value.docs.first);
          } else {
            return null;
          }
        },
      );
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  Stream<Iterable<UserProfile?>> getAllUserProfile() {
    final userProfile = userProfilePath
        .where(isEmailVerifiedField, isEqualTo: true)
        .limit(30)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (e) => UserProfile.fromSnapshot(e),
          ),
        );
    return userProfile;
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

  Future<void> updateTokenUserProfile({
    required String? token,
    required String? userID,
  }) async {
    if (userID != null) {
      Map<String, dynamic> mapUser = <String, dynamic>{tokenUserField: token};
      await userProfilePath.doc(userID).update(mapUser);
    }
  }

  Future<void> updateUserIsEmailVerified({
    required String? userID,
  }) async {
    if (userID != null) {
      Map<String, dynamic> mapUser = <String, dynamic>{};
      mapUser.addAll({isEmailVerifiedField: true});
      await userProfilePath.doc(userID).update(mapUser);
    }
  }

  Future<void> updateUserLanguage({
    required String userID,
    required String language,
  }) async {
    Map<String, dynamic> mapUser = <String, dynamic>{};
    mapUser.addAll({languageField: language});
    await userProfilePath.doc(userID).update(mapUser);
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

  Future<void> upLoadUserProfile({
    required String userID,
    required String fullName,
  }) async {
    Map<String, dynamic> mapUser = <String, dynamic>{
      fullNameField: fullName,
    };

    await userProfilePath.doc(userID).update(mapUser);
  }

  Future<void> updateUserPresenceDisconnect({required String uid}) async {
    Map<String, dynamic> presenceStatusTrue = {
      'presence': true,
      stampTimeField: DateTime.now().toString(),
    };
    await userPresenceDatabaseReference.child(uid).update(
          presenceStatusTrue,
        );
    Map<String, dynamic> presenceStatusFalse = {
      'presence': false,
      stampTimeField: DateTime.now().toString(),
    };
    await userPresenceDatabaseReference
        .child(uid)
        .onDisconnect()
        .update(presenceStatusFalse);
  }

  Future<void> updateUserPresence(
      {required String? uid, required bool bool}) async {
    Map<String, dynamic> presenceStatusFalse = {
      'presence': bool,
      stampTimeField: DateTime.now().toString(),
    };
    try {
      await userPresenceDatabaseReference
          .child(uid!)
          .update(presenceStatusFalse);
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
