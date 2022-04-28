import 'package:chatappforours/constants/chat_constant_field.dart';
import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/models/users_join_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUsersJoinChat {
  final firebaseUsersJoinChat =
      FirebaseFirestore.instance.collection('userJoinChat');
  final firebaseUsersJoinChatGroup =
      FirebaseFirestore.instance.collectionGroup('usersJoinedChat');
  Future<void> createUsersJoinChat({
    required String chatID,
    required List<String> listUserID,
    required TypeChat typeChat,
  }) async {
    for (var i = 0; i < listUserID.length; i++) {
      final rule = i == 0
          ? (typeChat == TypeChat.normal)
              ? RuleChat.member.toString()
              : RuleChat.admin.toString()
          : RuleChat.member.toString();
      Map<String, dynamic> map = <String, dynamic>{
        userIDField: listUserID.elementAt(i),
        ruleChatField: rule,
        typeChatField: typeChat.toString(),
        stampTimeField: DateTime.now(),
      };
      await firebaseUsersJoinChat
          .doc('$chatID/usersJoinedChat/${listUserID.elementAt(i)}')
          .set(map);
    }
  }

  Stream<Iterable<UsersJoinChat>> getAllIDChatUserJoined({
    required String ownerUserID,
  }) {
    final allIDChatUserJoined = firebaseUsersJoinChatGroup
        .where(userIDField, isEqualTo: ownerUserID)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (docs) {
              return UsersJoinChat.fromSnapshot(docs: docs);
            },
          ),
        );
    return allIDChatUserJoined;
  }

  Future<UsersJoinChat?> getChatNormalByIDUser({
    required String userIDFriend,
  }) async {
    if (firebaseUsersJoinChat.path.isNotEmpty) {
      final userJoin = await firebaseUsersJoinChatGroup
          .where(userIDField, isEqualTo: userIDFriend)
          .where(typeChatField, isEqualTo: TypeChat.normal.toString())
          .limit(1)
          .get()
          .then(
        (value) {
          if (value.docs.isNotEmpty) {
            return value.docs.first;
          } else {
            return null;
          }
        },
      );
      return userJoin != null
          ? UsersJoinChat.fromSnapshot(docs: userJoin)
          : null;
    }
    return null;
  }
}
