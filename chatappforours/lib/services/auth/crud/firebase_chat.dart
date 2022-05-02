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
  final firebaseChatGroup =
      FirebaseFirestore.instance.collectionGroup('friendChatID');
  Future<void> createChat(
      {required TypeChat typeChat,
      required List<String> listUserID,
      required String idFriendList}) async {
    final firebaseUserJoinChat = FirebaseUsersJoinChat();
    final FirebaseChatMessage firebaseChatMessage = FirebaseChatMessage();
    Map<String, dynamic> map = <String, dynamic>{
      nameChatField: "a",
      userIDField: listUserID.elementAt(0),
      isActiveField: false,
      lastTextField: 'Let make some chat',
      listUserField: listUserID,
      typeChatField: typeChat.toString(),
      timeLastChatField: DateTime.now(),
      stampTimeField: DateTime.now(),
    };
    await firebaseChat
        .doc(listUserID[0] + listUserID[1])
        .collection('friendChatID')
        .doc(idFriendList)
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
        if (listUserID.elementAt(0) != listUserID.elementAt(1)) {
          await firebaseChat
              .doc(listUserID[0] + listUserID[1])
              .collection('friendChatID')
              .doc(listUserID.elementAt(1))
              .set(map);
        }
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
    await firebaseChat.doc(chatID).collection('friendChatID').get().then(
      (value) {
        for (var i = 0; i < value.docs.length; i++) {
          firebaseChat
              .doc(chatID)
              .collection('friendChatID')
              .doc(value.docs.elementAt(i).id)
              .update(map);
        }
      },
    );
  }

  Future<void> updateChatToActive({
    required List<String> listUserID,
  }) async {
    Map<String, dynamic> map = <String, dynamic>{
      isActiveField: true,
    };
    await firebaseChat.doc(listUserID[0] + listUserID[1]).get().then(
      (value) async {
        if (value.exists) {
          await firebaseChat
              .doc(value.id)
              .collection('friendChatID')
              .doc(listUserID.elementAt(0))
              .update(map);
        } else {
          await firebaseChat.doc(listUserID[1] + listUserID[0]).get().then(
            (value) async {
              await firebaseChat
                  .doc(value.id)
                  .collection('friendChatID')
                  .doc(listUserID.elementAt(0))
                  .update(map);
            },
          );
        }
      },
    );
  }

  Future<Chat> getIDParentDocumentChat({required String ownerUserID}) async {
    return await firebaseChat
        .where(listUserField, arrayContains: ownerUserID)
        .where(typeChatField, isEqualTo: TypeChat.normal.toString())
        .where(isActiveField, isEqualTo: true)
        .orderBy(stampTimeField, descending: true)
        .limit(1)
        .get()
        .then(
      (value) {
        return Chat.fromSnapshot(docs: value.docs.first);
      },
    );
  }

  Future<Chat> getChatByID({
    required String idChat,
    required String userChatID,
  }) async {
    final chat = await firebaseChat
        .doc(idChat)
        .collection('friendChatID')
        .doc(userChatID)
        .get();
    return Chat.fromSnapshot(
      docs: chat,
    );
  }

  Future<Chat?> getChatByListIDUser({
    required List<String> listUserID,
  }) async {
    final chat =
        await firebaseChat.doc(listUserID[0] + listUserID[1]).get().then(
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
    return await firebaseChat
        .doc(chat)
        .collection('friendChatID')
        .doc(listUserID[0])
        .get()
        .then(
          (value) => Chat.fromSnapshot(docs: value),
        );
  }

  Stream<Iterable<Chat>> getAllChat({
    required String ownerUserID,
  }) {
    return firebaseChatGroup
        .where(userIDField, isEqualTo: ownerUserID)
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
