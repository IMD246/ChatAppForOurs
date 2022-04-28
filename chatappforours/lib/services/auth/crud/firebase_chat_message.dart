import 'package:chatappforours/constants/message_chat_field.dart';
import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChatMessage {
  final firebaseChatMessageDocument =
      FirebaseFirestore.instance.collection('chatMessage');
  Future<void> createTextMessageNotSent({
    required userID,
    required chatID,
  }) async {
    Map<String, dynamic> map = {
      idSenderField: userID,
      messageField: ". . .",
      typeMessageField: TypeMessage.text.toString(),
      messageStatusField: MessageStatus.notSent.toString(),
      stampTimeField: DateTime.now(),
    };
    await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .doc()
        .set(map);
  }

  Future<void> deleteMessageNotSent({
    required ownerUserID,
    required chatID,
  }) async {
    await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .where(idSenderField, isEqualTo: ownerUserID)
        .where(messageStatusField, isEqualTo: MessageStatus.notSent.toString())
        .orderBy(stampTimeField, descending: true)
        .limit(1)
        .get()
        .then(
          (value) => firebaseChatMessageDocument
              .doc(chatID)
              .collection('message')
              .doc(value.docs.first.id)
              .delete(),
        );
  }

  Future<void> updateTextMessageSent({
    required userID,
    required chatID,
    required text,
  }) async {
    Map<String, dynamic> map = {
      messageField: text,
      messageStatusField: MessageStatus.sent.toString(),
      stampTimeField: DateTime.now(),
    };
    final firebaseChat = FirebaseChat();
    await firebaseChat.updateChat(
      text: text,
      chatID: chatID,
    );
    await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .doc(userID)
        .update(map);
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
            (docs) =>
                ChatMessage.fromSnapshot(docs: docs, ownerUserID: ownerUserID),
          ),
        );
    return allMessage;
  }
}
