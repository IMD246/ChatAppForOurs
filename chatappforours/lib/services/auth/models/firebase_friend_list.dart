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
    await friendListDocumentDefault.doc('$ownerUserID/userID').update(map);
  }

  Stream<Iterable<FriendList?>?> getAllFriendIsOnlined({required ownerUserID}) {
    return friendListDocument
        .collection('friendList/$ownerUserID/friend')
        .where(isRequestField, isEqualTo: true)
        .orderBy(stampTimeField, descending: true)
        .snapshots()
        .map(
      (event) {
        if (event.docs.isNotEmpty) {
          return event.docs.map(
            (docs) {
              if (docs.exists) {
                return FriendList.fromSnapshot(snapshot: docs);
              } else {
                return null;
              }
            },
          );
        } else {
          return null;
        }
      },
    );
  }
}
