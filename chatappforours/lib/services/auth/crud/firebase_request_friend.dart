import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:chatappforours/services/auth/models/request_friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRequestFriend {
  final requestListFriendDoc = "requestFriendList";
  final requestFriendDoc = "requestFriend";
  final requestListFriendCol = FirebaseFirestore.instance.collection(
    'requestFriendList',
  );
  final requestFriendCol =
      FirebaseFirestore.instance.collection('requestFriend');
  Future<void> createNewRequestFriend({
    required String ownerUserID,
    required String userIDFriend,
  }) async {
    Map<String, dynamic> map = <String, dynamic>{
      userIDField: userIDFriend,
      stampTimeField: DateTime.now(),
    };
    await requestFriendCol
        .doc(ownerUserID)
        .collection(requestListFriendDoc)
        .doc(userIDFriend)
        .set(map);
  }

  Future<void> deleteRequestFriend({
    required String ownerUserID,
    required String idUserRequestFriend,
  }) async {
    await requestFriendCol
        .doc(ownerUserID)
        .collection(requestListFriendDoc)
        .doc(idUserRequestFriend)
        .delete();
  }

  Future<String?> getIDRequestFriend({
    required String ownerUserID,
    required String idUserRequestFriend,
  }) async {
    return await requestFriendCol
        .doc(ownerUserID)
        .collection(requestListFriendDoc)
        .doc(idUserRequestFriend)
        .get()
        .then((value) {
      if (value.exists) {
        return value.id;
      } else {
        return null;
      }
    });
  }

  Future<bool> checkIfIDRequestFriendExist({
    required String ownerUserID,
    required String idUserRequestFriend,
  }) {
    return requestFriendCol
        .doc(ownerUserID)
        .collection(requestListFriendDoc)
        .doc(idUserRequestFriend)
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

  Stream<Iterable<RequestFriend>?> getAllRequestFriend(
      {required String ownerUserID}) {
    final friendList = requestFriendCol
        .doc(ownerUserID)
        .collection(requestListFriendDoc)
        .orderBy(stampTimeField, descending: true)
        .snapshots()
        .map(
      (event) {
        if (event.docs.isNotEmpty) {
          return event.docs.map(
            (e) => RequestFriend.fromSnapshot(snapshot: e),
          );
        } else {
          return null;
        }
      },
    );
    return friendList;
  }

  Future<int?> countAllRequestFriendFuture({
    required String ownerUserID,
  }) async {
    return requestFriendCol
        .doc(ownerUserID)
        .collection(requestListFriendDoc)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.length;
      } else {
        return null;
      }
    });
  }

  Stream<int?> countAllRequestFriend({
    required String ownerUserID,
  }) {
    return requestFriendCol
        .doc(ownerUserID)
        .collection(requestListFriendDoc)
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
