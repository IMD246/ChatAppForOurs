import 'package:chatappforours/constants/list_friend_constant_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendList {
  final String idFriendList;
  final String userID;
  final bool? isRequest;
  String? stampTimeUser;
  bool presence;
  FriendList( {required this.idFriendList,
    required this.userID,
    required this.isRequest,
    this.stampTimeUser,
    this.presence = false,
  });
  factory FriendList.fromSnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> snapshot}) {
    return FriendList(
      userID: snapshot.get(userIDField),
      isRequest: snapshot.get(isRequestField), idFriendList: snapshot.id,
    );
  }
}
