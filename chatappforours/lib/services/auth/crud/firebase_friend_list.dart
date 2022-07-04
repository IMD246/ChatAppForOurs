import 'dart:async';

import 'package:chatappforours/constants/list_friend_constant_field.dart';
import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:chatappforours/services/auth/crud/firebase_request_friend.dart';
import 'package:chatappforours/services/auth/models/friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFriendList {
  final String listFriendCollection = "listFriend";
  final String friendCollection = "friend";
  final friendListDoc = FirebaseFirestore.instance.collection('listFriend');
  final friendDoc = FirebaseFirestore.instance.collection('friend');
  Future<void> createNewFriend({
    required String ownerUserID,
    required String userIDFriend,
    required bool isAccepted,
  }) async {
    Map<String, dynamic> map = <String, dynamic>{
      userIDField: userIDFriend,
      isAcceptedField: isAccepted,
      stampTimeField: DateTime.now(),
    };
    await friendDoc
        .doc(ownerUserID)
        .collection(listFriendCollection)
        .doc(userIDFriend)
        .set(map);
  }

  Future<void> updateAcceptedFriend({
    required String ownerUserID,
    required String userIDFriend,
    required bool isAccepted,
  }) async {
    Map<String, dynamic> map = <String, dynamic>{
      isAcceptedField: isAccepted,
    };
    await friendDoc
        .doc(ownerUserID)
        .collection(listFriendCollection)
        .doc(userIDFriend)
        .update(map);
  }

  Future<String?> getIDFriendListDocument({
    required String ownerUserID,
    required String userID,
  }) async {
    return await friendDoc
        .doc(ownerUserID)
        .collection(listFriendCollection)
        .doc(userID)
        .get()
        .then(
      (value) {
        if (value.reference.path.isNotEmpty && value.exists) {
          return value.id;
        } else {
          return null;
        }
      },
    );
  }

  Future<bool?> checkAddedUserYet({
    required String ownerUserID,
    required String userID,
  }) async {
    final firebaseRequestFriend = FirebaseRequestFriend();
    final check1 = await firebaseRequestFriend.checkIfIDRequestFriendExist(
      ownerUserID: ownerUserID,
      idUserRequestFriend: userID,
    );
    if (check1 == false) {
      return await checkIfIDFriendListExist(
        ownerUserID: ownerUserID,
        userID: userID,
      );
    } else {
      return null;
    }
  }

  Future<bool> checkIfIDFriendListExist({
    required String ownerUserID,
    required String userID,
  }) {
    return friendDoc
        .doc(ownerUserID)
        .collection(listFriendCollection)
        .doc(userID)
        .get()
        .then(
      (value) {
        if (value.exists) {
          return true;
        } else {
          return false;
        }
      },
    );
  }

  Stream<Iterable<Friend>?> getAllFriend({required String ownerUserID}) {
    final friendList = friendDoc
        .doc(ownerUserID)
        .collection(listFriendCollection)
        .where(isAcceptedField, isEqualTo: true)
        .snapshots()
        .map(
      (event) {
        if (event.docs.isNotEmpty) {
          return event.docs.map(
            (e) => Friend.fromSnapshot(snapshot: e),
          );
        } else {
          return null;
        }
      },
    );
    return friendList;
  }

  Stream<int?> countAllFriend({
    required String ownerUserID,
  }) {
    return friendDoc
        .doc(ownerUserID)
        .collection(listFriendCollection)
        .where(isAcceptedField, isEqualTo: true)
        .snapshots()
        .map(
      (event) {
        if (event.docs.isNotEmpty) {
          return event.docs.length;
        } else {
          return null;
        }
      },
    );
  }
}
