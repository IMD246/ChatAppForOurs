import 'package:chatappforours/constants/chat_constant_field.dart';
import 'package:chatappforours/constants/message_chat_field.dart';
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
    Map<String, dynamic> map = <String, dynamic>{
      nameChatField: "a",
      isActiveField: false,
      lastTextField: 'Let make some chat',
      listUserField: listUserID,
      typeChatField: typeChat.toString(),
      timeLastChatField: DateTime.now(),
      stampTimeField: DateTime.now(),
    };
    final check1 = await firebaseChat
        .doc(listUserID[0] + listUserID[1])
        .get()
        .then((value) {
      if (value.exists) {
        return true;
      } else {
        return false;
      }
    });
    final check2 = await firebaseChat
        .doc(listUserID[1] + listUserID[0])
        .get()
        .then((value) {
      if (value.exists) {
        return true;
      } else {
        return false;
      }
    });
    if (check1 == false && check2 == false) {
      await firebaseChat
          .doc(listUserID[0] + listUserID[1])
          .set(map)
          .whenComplete(
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
  }

  Future<void> updateChatLastText({
    required String text,
    required TypeMessage typeMessage,
    required String chatID,
  }) async {
    Map<String, dynamic> map = <String, dynamic>{
      lastTextField: text,
      typeMessageField: typeMessage.toString(),
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
    return await firebaseChat.doc(listUserID[0] + listUserID[1]).get().then(
      (value) async {
        if (value.exists) {
          return await firebaseChat.doc(value.id).get().then(
            (value) {
              return Chat.fromSnapshot(docs: value);
            },
          );
        } else {
          return await firebaseChat
              .doc(listUserID[1] + listUserID[0])
              .get()
              .then(
            (value) async {
              if (value.exists) {
                return await firebaseChat.doc(value.id).get().then(
                  (value) {
                    return Chat.fromSnapshot(docs: value);
                  },
                );
              } else {
                return await null;
              }
            },
          );
        }
      },
    );
  }

  Stream<Iterable<Chat>?> getAllChat({
    required String ownerUserID,
  }) {
    return firebaseChat
        .where(listUserField, arrayContains: ownerUserID)
        .where(isActiveField, isEqualTo: true)
        .orderBy(timeLastChatField, descending: true)
        .snapshots()
        .map(
      (event) {
        if (event.docs.isNotEmpty) {
          return event.docs.map(
            (e) {
              return Chat.fromSnapshot(
                docs: e,
              );
            },
          );
        } else {
          return null;
        }
      },
    );
  }
}
