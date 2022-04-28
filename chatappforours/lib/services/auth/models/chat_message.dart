import 'package:chatappforours/constants/message_chat_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String value;
  final String userID;
  final TypeMessage messageType;
  final MessageStatus messageStatus;
  final bool isSender;

  ChatMessage({
    this.value = '',
    required this.messageType,
    required this.messageStatus,
    required this.isSender,
    required this.userID,
  });
  factory ChatMessage.fromSnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> docs,
      required String ownerUserID}) {
    return ChatMessage(
      value: docs.get(messageField).toString(),
      messageType: getTypeMessage(value: docs.get(typeMessageField).toString()),
      messageStatus:
          getMessageStatus(value: docs.get(messageStatusField).toString()),
      isSender: ownerUserID.compareTo(docs.get(idSenderField).toString()) == 0
          ? true
          : false,
      userID: docs.get(idSenderField).toString(),
    );
  }
}

MessageStatus getMessageStatus({required String value}) {
  if (value.toString().compareTo(MessageStatus.notSent.toString()) == 0) {
    return MessageStatus.notSent;
  } else if (value.toString().compareTo(MessageStatus.sent.toString()) == 0) {
    return MessageStatus.sent;
  } else {
    return MessageStatus.viewed;
  }
}

TypeMessage getTypeMessage({required String value}) {
  if (value.toString().compareTo(TypeMessage.audio.toString()) == 0) {
    return TypeMessage.audio;
  } else if (value.toString().compareTo(TypeMessage.image.toString()) == 0) {
    return TypeMessage.image;
  } else {
    return TypeMessage.text;
  }
}