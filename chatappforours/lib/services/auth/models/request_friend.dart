import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestFriend {
  final String idRequestFriend;
  final String userID;
  String? stampTimeUser;
  bool presence;
  RequestFriend({
    required this.idRequestFriend,
    required this.userID,
    this.stampTimeUser,
    this.presence = false,
  });
  factory RequestFriend.fromSnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> snapshot}) {
    return RequestFriend(
      userID: snapshot.get(userIDField),
      idRequestFriend: snapshot.id,
    );
  }
}
