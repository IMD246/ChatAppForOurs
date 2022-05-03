import 'package:chatappforours/constants/chat_constant_field.dart';
import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
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
    Map<String, dynamic> map = <String, dynamic>{
      nameChatField: "a",
      isActiveField: false,
      lastTextField: 'Let make some chat',
      listUserField: listUserID,
      typeChatField: typeChat.toString(),
      timeLastChatField: DateTime.now(),
      stampTimeField: DateTime.now(),
    };
    await firebaseChat.doc(listUserID[0] + listUserID[1]).set(map).whenComplete(
      () async {
        await firebaseUserJoinChat.createUsersJoinChat(
          listUserID: listUserID,
          idChat: listUserID[0] + listUserID[1],
          typeChat: typeChat,
        );
        await firebaseChatMessage.createFirstTextMessage(
          userID: "",
          chatID: listUserID[0] + listUserID[1],
        );
      },
    );
  }

  Future<void> updateChatLastText({
    required String text,
    required String chatID,
  }) async {
    Map<String, dynamic> map = <String, dynamic>{
      lastTextField: text,
      timeLastChatField: DateTime.now(),
    };
    await firebaseChat.doc(chatID).update(map);
  }

  Future<void> updateChatToActive({
    required String idChat,
    required String ownerUserID,
  }) async {
    Map<String, dynamic> map = <String, dynamic>{
      isActiveField: true,
    };
    await firebaseChat.doc(idChat).update(map);
  }

  Future<Chat> getChatByID({
    required String idChat,
    required String userChatID,
  }) async {
    final chat = await firebaseChat.doc(idChat).get();
    return Chat.fromSnapshot(
      docs: chat,
    );
  }

  Future<Chat?> getChatByListIDUser({
    required List<String> listUserID,
  }) async {
    final id = await firebaseChat.doc(listUserID[0] + listUserID[1]).get().then(
      (value) async {
        if (value.id.isNotEmpty) {
          return value.id;
        } else {
          await firebaseChat.doc(listUserID[1] + listUserID[0]).get().then(
            (value) {
              return value.id;
            },
          );
        }
      },
    );
    return await firebaseChat.doc(id).get().then(
          (value) => Chat.fromSnapshot(docs: value),
        );
  }

  Stream<Iterable<Chat>> getAllChat({
    required String ownerUserID,
  }) {
    return firebaseChat
        .where(listUserField, arrayContains: ownerUserID)
        .where(isActiveField, isEqualTo: true)
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
