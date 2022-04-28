import 'package:chatappforours/constants/chat_constant_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_users_join_chat.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChat {
  final firebaseChat = FirebaseFirestore.instance.collection('chat');
  Future<void> createChat({
    required String ownerUserID,
    required String userIDFriend,
    required String nameChat,
    required TypeChat typeChat,
    required String idFriendDocument,
  }) async {
    final isExisted =
        await firebaseChat.doc(idFriendDocument).get().then((value) {
      if (value.exists) {
        return true;
      } else {
        return false;
      }
    });
    if (isExisted == false) {
      Map<String, dynamic> map = <String, dynamic>{
        userIDField: userIDFriend,
        nameChatField: nameChat,
        lastTextField: 'Let make some chat',
        typeChatField: typeChat.toString(),
        timeLastChatField: DateTime.now(),
      };
      await firebaseChat.doc(idFriendDocument).set(map);
      List<String> listUser = <String>[];
      listUser.add(ownerUserID);
      listUser.add(userIDFriend);
      final usersJoinChat = FirebaseUsersJoinChat();
      await usersJoinChat.createUsersJoinChat(
        chatID: idFriendDocument.toString(),
        listUserID: listUser,
        typeChat: typeChat.toString(),
      );
    }
  }

  Future<void> updateChat({
    required String text,
    required String chatID,
  }) async {
    Map<String, dynamic> map = <String, dynamic>{
      lastTextField: text,
      timeLastChatField: DateTime.now(),
    };
    await firebaseChat.doc(chatID).update(map);
  }

  Stream<Iterable<Chat>> getAllChat({
    required String userID,
  }) {
    final chat = firebaseChat
        .where(userIDField, isEqualTo: userID)
        .orderBy(timeLastChatField, descending: true)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (e) => Chat.fromSnapshot(
              docs: e,
            ),
          ),
        );
    return chat;
  }

  Future<Chat> getChatByID({
    required String idChat,
  }) async {
    final chat = await firebaseChat.doc(idChat).get();
    return Chat.fromSnapshot(
      docs: chat,
    );
  }
}
