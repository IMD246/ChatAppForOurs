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
    required String typeChat,
  }) async {
    for (var i = 0; i < listUserID.length; i++) {
      final rule = i == 0
          ? (typeChat.compareTo(TypeChat.normal.toString()) == 0
              ? RuleChat.member.toString()
              : RuleChat.admin.toString())
          : RuleChat.member.toString();
      Map<String, dynamic> map = <String, dynamic>{
        userIDField: listUserID.elementAt(i),
        ruleChatField: rule,
        stampTimeField: DateTime.now(),
      };
      await firebaseUsersJoinChat
          .doc('$chatID/usersJoinedChat/${listUserID.elementAt(i)}')
          .set(map);
    }
  }

  Stream<Iterable<String>> getAllIDChatUserJoined({
    required String ownerUserID,
  }) {
    final allIDChatUserJoined = firebaseUsersJoinChatGroup
        .where(userIDField, isEqualTo: ownerUserID)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (docs) {
              return docs.reference.parent.parent!.id;
            },
          ),
        );
    return allIDChatUserJoined;
  }

  Stream<Iterable<UsersJoinChat>> getUsersJoinChatByID({
    required String chatID,
    required String userID,
  }) {
    final usersJoinChat = firebaseUsersJoinChat
        .doc(chatID)
        .collection('usersJoinedChat')
        .snapshots()
        .map(
          (event) => event.docs.map(
            (docs) {
              return UsersJoinChat.fromSnapshot(docs: docs);
            },
          ),
        );
    return usersJoinChat;
  }
}
