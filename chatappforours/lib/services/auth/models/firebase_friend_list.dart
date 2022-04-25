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
      required String userID,
      bool? isRequest}) async {
    Map<String, dynamic> map = <String, dynamic>{
      userIDField: userID,
      isRequestField: isRequest ?? false,
      stampTimeField: DateTime.now(),
    };
    await friendListDocumentDefault.doc("$ownerUserID/friend/$userID").set(map);
  }

  Future<void> updateRequestFriend(
      {required String ownerUserID, required String userID}) async {
    Map<String, dynamic> map = <String, dynamic>{
      isRequestField: true,
    };
    await friendListDocumentDefault
        .doc('$ownerUserID/friend/$userID')
        .update(map);
  }

  Future<void> deleteFriend(
      {required String ownerUserID, required String userID}) async {
    await friendListDocumentDefault.doc('$ownerUserID/friend/$userID').delete();
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
  Stream<Iterable<FriendList>> getAllFriendIsRequested({required ownerUserID}) {
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
