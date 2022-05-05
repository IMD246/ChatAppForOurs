import 'package:chatappforours/constants/list_friend_constant_field.dart';
import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:chatappforours/services/auth/models/friend_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFriendList {
  final friendListDocumentDefault =
      FirebaseFirestore.instance.collection('friendList');
  final friendListDocument = FirebaseFirestore.instance;
  Future<void> createNewFriend(
      {required String ownerUserID,
      required String userIDFriend,
      required bool isRequest}) async {
    Map<String, dynamic> map = <String, dynamic>{
      userIDField: userIDFriend,
      isRequestField: isRequest,
      stampTimeField: DateTime.now(),
    };
    await friendListDocumentDefault
        .doc(ownerUserID)
        .collection('friend')
        .doc(userIDFriend)
        .set(map);
  }

  Future<void> createNewFriendDefault({
    required String ownerUserID,
    required String userIDFriend,
  }) async {
    Map<String, dynamic> map = <String, dynamic>{
      userIDField: userIDFriend,
      isRequestField: false,
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
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.first.id;
      } else {
        return null;
      }
    });
    return id;
  }

  Future<void> updateRequestFriend(
      {required String ownerUserID, required String userID}) async {
    await createNewFriend(
      ownerUserID: ownerUserID,
      userIDFriend: userID,
      isRequest: true,
    );
    if (ownerUserID != userID) {
      await createNewFriend(
        ownerUserID: userID,
        userIDFriend: ownerUserID,
        isRequest: true,
      );
    }
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

  Stream<Iterable<FriendList>> getAllFriendIsAccepted({required ownerUserID}) {
    final friendList = friendListDocument
        .collection('friendList')
        .doc(ownerUserID)
        .collection('friend')
        .where(isRequestField, isEqualTo: true)
        .orderBy(stampTimeField, descending: true)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (e) => FriendList.fromSnapshot(snapshot: e),
          ),
        );
    return friendList;
  }

  Stream<Iterable<FriendList>> getAllFriendIsRequested(
      {required String ownerUserID}) {
    final friendList = friendListDocument
        .collection('friendList')
        .doc(ownerUserID)
        .collection('friend')
        .where(isRequestField, isEqualTo: false)
        .orderBy(stampTimeField, descending: true)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (e) => FriendList.fromSnapshot(snapshot: e),
          ),
        );
    return friendList;
  }
}
