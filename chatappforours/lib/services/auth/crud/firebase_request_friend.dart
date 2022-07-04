import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:chatappforours/services/auth/models/request_friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRequestFriend {
  final requestListFriendDoc = FirebaseFirestore.instance.collection(
    'requestFriendList',
  );
  final requestFriendDoc =
      FirebaseFirestore.instance.collection('requestFriend');
  Future<void> createNewRequestFriend({
    required String ownerUserID,
    required String userIDFriend,
  }) async {
    Map<String, dynamic> map = <String, dynamic>{
      userIDField: userIDFriend,
      stampTimeField: DateTime.now(),
    };
    await requestFriendDoc
        .doc(ownerUserID)
        .collection('requestFriendList')
        .doc(userIDFriend)
        .set(map);
  }

  Future<void> deleteRequestFriend({
    required String ownerUserID,
    required String idUserRequestFriend,
  }) async {
    await requestFriendDoc
        .doc(ownerUserID)
        .collection('friend')
        .doc(idUserRequestFriend)
        .delete();
  }

  Stream<Iterable<RequestFriend>?> getAllRequestFriend(
      {required String ownerUserID}) {
    final friendList = requestListFriendDoc
        .doc(ownerUserID)
        .collection('friend')
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

  Future<int?> countAllRequestFriend({
    required String ownerUserID,
  }) async {
    final friendRequestCount = await requestFriendDoc
        .doc(ownerUserID)
        .collection('requestFriendList')
        .get()
        .then(
      (value) {
        if (value.docs.isNotEmpty && value.size >= 1) {
          return value.size;
        } else {
          return null;
        }
      },
    );
    return friendRequestCount;
  }
}
