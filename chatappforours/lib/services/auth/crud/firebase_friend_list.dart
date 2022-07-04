import 'package:chatappforours/constants/list_friend_constant_field.dart';
import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:chatappforours/services/auth/models/friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFriendList {
  final friendListDocumentDefault =
      FirebaseFirestore.instance.collection('friendList');
  final friendListDocument = FirebaseFirestore.instance;
  Future<void> createNewFriend(
      {required String ownerUserID,
      required String userIDFriend,
      }) async {
    Map<String, dynamic> map = <String, dynamic>{
      userIDField: userIDFriend,
      stampTimeField: DateTime.now(),
    };
    await friendListDocumentDefault
        .doc(ownerUserID)
        .collection('friend')
        .doc(userIDFriend)
        .set(map);
  }

  Future<String?> getIDFriendListDocument(
      {required String ownerUserID,
      required String userID,
      bool? isRequest}) async {
    final id = await friendListDocumentDefault
        .doc(ownerUserID)
        .collection('friend')
        .where(userIDField, isEqualTo: userID)
        .limit(1)
        .get()
        .then(
      (value) {
        if (value.docs.isNotEmpty) {
          return value.docs.first.id;
        } else {
          return null;
        }
      },
    );
    return id;
  }
  Future<void> deleteFriend(
      {required String ownerUserID, required String userID}) async {
    String? id = await getIDFriendListDocument(
      ownerUserID: ownerUserID,
      userID: userID,
    );
    await friendListDocumentDefault
        .doc(ownerUserID)
        .collection('friend')
        .doc(id)
        .delete();
  }

  Stream<Iterable<Friend>?> getAllFriendIsAccepted(
      {required String ownerUserID}) {
    final friendList = friendListDocument
        .collection('friendList')
        .doc(ownerUserID)
        .collection('friend')
        .where(isRequestField, isEqualTo: true)
        .orderBy(stampTimeField, descending: true)
        .snapshots()
        .map((event) {
      if (event.docs.isNotEmpty) {
        return event.docs.map(
          (e) => Friend.fromSnapshot(snapshot: e),
        );
      } else {
        return null;
      }
    });
    return friendList;
  }

  Stream<Iterable<Friend>?> getAllFriendIsRequested(
      {required String ownerUserID}) {
    final friendList = friendListDocument
        .collection('friendList')
        .doc(ownerUserID)
        .collection('friend')
        .where(isRequestField, isEqualTo: false)
        .orderBy(stampTimeField, descending: true)
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

  Stream<Iterable<Friend>?> getAllFriend({required String ownerUserID}) {
    final friendList = friendListDocument
        .collection('friendList')
        .doc(ownerUserID)
        .collection('friend')
        .orderBy(stampTimeField, descending: true)
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

  Future<int?> countAllFriend({required String ownerUserID}) async {
    final friendRequestCount = await friendListDocument
        .collection('friendList')
        .doc(ownerUserID)
        .collection('friend')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty && value.size > 0) {
        return value.size;
      } else {
        return null;
      }
    },);
    return friendRequestCount;
  }
}
