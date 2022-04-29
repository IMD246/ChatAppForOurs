import 'package:chatappforours/constants/chat_constant_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
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
  }) async {
    final firebaseUserJoinChat = FirebaseUsersJoinChat();
    final userJoinChatCheck = await firebaseUserJoinChat.getChatNormalByIDUser(
        userIDFriend: userIDFriend);
    if (userJoinChatCheck == null) {
      Map<String, dynamic> map = <String, dynamic>{
        nameChatField: nameChat,
        lastTextField: 'Let make some chat',
        typeChatField: typeChat.toString(),
        timeLastChatField: DateTime.now(),
      };
      List<String> listUser = <String>[];
      if (ownerUserID.compareTo(userIDFriend) == 0) {
        listUser.add(ownerUserID);
        map.update(nameChatField, (value) => 'Only You');
      } else {
        listUser.add(ownerUserID);
        listUser.add(userIDFriend);
      }
      await firebaseUserJoinChat.createUsersJoinChat(
        listUserID: listUser,
        typeChat: typeChat,
      );
      final userJoinChat = await firebaseUserJoinChat.getChatNormalByIDUser(
          userIDFriend: userIDFriend);
      // final FirebaseChatMessage firebaseChatMessage = FirebaseChatMessage();
      // firebaseChatMessage.createFirstTextMessage(
      //   userID: ownerUserID,
      //   chatID: userJoinChat!.chatID,
      // );
      await firebaseChat.doc(userJoinChat!.chatID).set(map);
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

  // Stream<Iterable<Chat>> getAllChat({
  //   required String ownerUserID,
  // }) {
  //   final chat = firebaseChat
  //       .where(userIDField, isEqualTo: userID)
  //       .orderBy(timeLastChatField, descending: true)
  //       .snapshots()
  //       .map(
  //         (event) => event.docs.map(
  //           (e) => Chat.fromSnapshot(
  //             docs: e,
  //           ),
  //         ),
  //       );
  //   return chat;
  // }

  Future<Chat> getChatByID({
    required String idChat,
  }) async {
    final chat = await firebaseChat.doc(idChat).get();
    return Chat.fromSnapshot(
      docs: chat,
    );
  }
}
