import 'package:chatappforours/constants/list_friend_constant_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Friend {
  final String idFriendList;
  final String userID;
  final bool isAccepted;
  String? stampTimeUser;
  bool presence;
  Friend({
    required this.idFriendList,
    required this.userID,
    required this.isAccepted,
    this.stampTimeUser,
    this.presence = false,
  });
  factory Friend.fromSnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> snapshot}) {
    return Friend(
      userID: snapshot.get(userIDField),
      idFriendList: snapshot.id,
      isAccepted: snapshot.data()[isAcceptedField] != null
          ? snapshot.get(isAcceptedField)
          : false,
    );
  }
}
