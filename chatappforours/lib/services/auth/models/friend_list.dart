import 'package:chatappforours/constants/list_friend_constant_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendList {
  final String userID;
  final bool? isRequest;
  FriendList({
    required this.userID,
    required this.isRequest,
  });
  factory FriendList.fromSnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> snapshot}) {
    return FriendList(
      userID: snapshot.data()[userIDField],
      isRequest: snapshot.data()[isRequestField],
    );
  }
}
