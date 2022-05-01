import 'package:chatappforours/constants/chat_constant_field.dart';
import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/crud/firebase_users_join_chat.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChat {
  final firebaseChat = FirebaseFirestore.instance.collection('chat');
  Future<void> createChat({
    required TypeChat typeChat,
    required List<String> listUserID,
  }) async {
    final firebaseUserJoinChat = FirebaseUsersJoinChat();
    final FirebaseChatMessage firebaseChatMessage = FirebaseChatMessage();
    final chatIDCheck = await getChatNormalByIDUserFriend(
      listUserID: listUserID,
    );
    if (chatIDCheck == null) {
      Map<String, dynamic> map = <String, dynamic>{
        nameChatField: " ",
        listUserField: listUserID,
        lastTextField: 'Let make some chat',
        typeChatField: typeChat.toString(),
        timeLastChatField: DateTime.now(),
        stampTimeField: DateTime.now(),
      };
      await firebaseChat.doc().set(map);
      final chatNormal = await getChatNormalByIDUserFriend(
        listUserID: listUserID,
      );
      await firebaseChatMessage.createFirstTextMessage(
        userID: "",
        chatID: chatNormal!.idChat,
      );
      await firebaseUserJoinChat.createUsersJoinChat(
        listUserID: listUserID,
        idChat: chatNormal.idChat,
        typeChat: typeChat,
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

  Future<Chat?> getChatNormalByIDUserFriend({
    required List<String> listUserID,
  }) async {
    final chatNormalID = await firebaseChat
        .where(listUserField, arrayContainsAny: listUserID)
        .where(typeChatField, isEqualTo: TypeChat.normal.toString())
        .orderBy(stampTimeField, descending: true)
        .limit(1)
        .get()
        .then(
      (value) {
        if (value.size > 0) {
          return value.docs.first;
        } else {
          return null;
        }
      },
    );
    if (chatNormalID != null) {
      return Chat.fromSnapshot(docs: chatNormalID);
    }
    return null;
  }

  Future<Chat> getChatByID({
    required String idChat,
  }) async {
    final chat = await firebaseChat.doc(idChat).get();
    return Chat.fromSnapshot(
      docs: chat,
    );
  }

  Stream<Iterable<Chat>> getAllChat({
    required String ownerUserID,
  }) {
    return firebaseChat
        .where(listUserField, arrayContains: ownerUserID)
        .orderBy(timeLastChatField, descending: true)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (e) => Chat.fromSnapshot(
              docs: e,
            ),
          ),
        );
  }
}
