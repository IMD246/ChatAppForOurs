import 'package:chatappforours/constants/message_chat_field.dart';
import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChatMessage {
  final firebaseChatMessageDocument =
      FirebaseFirestore.instance.collection('chatMessage');

  Future<void> createFirstTextMessage({
    required userID,
    required chatID,
    String? text,
  }) async {
    Map<String, dynamic> map = {
      idSenderField: '',
      hasSenderField: false,
      messageField: "Let make some chat",
      typeMessageField: TypeMessage.text.toString(),
      messageStatusField: MessageStatus.notSent.toString(),
      stampTimeField: DateTime.now(),
    };
    await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .get()
        .then(
      (value) {
        if (value.docs.isNotEmpty) {
          firebaseChatMessageDocument
              .doc(chatID)
              .collection('message')
              .where(idSenderField, isEqualTo: userID)
              .where(
                messageStatusField,
                isEqualTo: MessageStatus.notSent.toString(),
              )
              .get()
              .then(
            (value) {
              if (value.docs.isNotEmpty) {
                firebaseChatMessageDocument
                    .doc(chatID)
                    .collection('message')
                    .doc(value.docs.first.id)
                    .set(map);
              }
            },
          );
        } else {
          firebaseChatMessageDocument
              .doc(chatID)
              .collection('message')
              .doc()
              .set(map);
        }
      },
    );
  }

  Future<void> createTextMessageNotSent(
      {required userID, required chatID}) async {
    Map<String, dynamic> map = {
      idSenderField: userID,
      hasSenderField: true,
      messageField: ". . .",
      typeMessageField: TypeMessage.text.toString(),
      messageStatusField: MessageStatus.notSent.toString(),
      stampTimeField: DateTime.now(),
    };
    await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .doc(userID)
        .set(map);
  }

  Future<void> deleteMessageNotSent({
    required ownerUserID,
    required chatID,
  }) async {
    String? id;
    final bool isCheck = await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .where(idSenderField, isEqualTo: ownerUserID)
        .where(messageStatusField, isEqualTo: MessageStatus.notSent.toString())
        .orderBy(stampTimeField, descending: true)
        .limit(1)
        .get()
        .then(
      (value) {
        if (value.size > 0 && value.docs.first.exists) {
          id = value.docs.first.id;
          return true;
        } else {
          return false;
        }
      },
    );
    if (isCheck == true) {
      await firebaseChatMessageDocument
          .doc(chatID)
          .collection('message')
          .doc(id)
          .delete();
    }
  }

  Future<void> updateTextMessageSent({
    required userID,
    required chatID,
    required text,
  }) async {
    final firebaseChat = FirebaseChat();

    Map<String, dynamic> mapCreate = {
      idSenderField: userID,
      hasSenderField: true,
      messageField: text,
      typeMessageField: TypeMessage.text.toString(),
      messageStatusField: MessageStatus.sent.toString(),
      stampTimeField: DateTime.now(),
    };
    await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .doc()
        .set(mapCreate);
    await firebaseChat.updateChat(
      text: text,
      chatID: chatID,
    );
  }

  Stream<Iterable<ChatMessage>> getAllMessage(
      {required String chatID, required String ownerUserID}) {
    final allMessage = firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .orderBy(
          stampTimeField,
          descending: false,
        )
        .snapshots()
        .map(
          (event) => event.docs.map(
            (docs) => ChatMessage.fromSnapshot(
              docs: docs,
              ownerUserID: ownerUserID,
            ),
          ),
        );
    return allMessage;
  }
}
