import 'package:chatappforours/constants/message_chat_field.dart';
import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/utilities/time_handle/handle_value.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String idMessage;
  final dynamic value;
  final TypeMessage messageType;
  final MessageStatus messageStatus;
  final String? userID;
  final bool? isSender;
  final bool hasSender;
  final String stampTimeFormated;
  final DateTime stampTime;
  final bool checkTimeGreaterOneMinute;
  ChatMessage({
    required this.idMessage,
    required this.stampTime,
    required this.stampTimeFormated,
    this.value = '',
    required this.checkTimeGreaterOneMinute,
    required this.messageType,
    required this.messageStatus,
    required this.isSender,
    required this.userID,
    required this.hasSender,
  });
  factory ChatMessage.fromSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> docs,
      required String ownerUserID}) {
    return ChatMessage(
        idMessage: docs.id,
        value: handleMessageValue(
          value: docs.get(messageField).toString(),
          typeMessage: getTypeMessage(
            value: docs.get(typeMessageField).toString(),
          ),
        ),
        messageType:
            getTypeMessage(value: docs.get(typeMessageField).toString()),
        messageStatus:
            getMessageStatus(value: docs.get(messageStatusField).toString()),
        isSender: docs.get(hasSenderField) == true
            ? ownerUserID.compareTo(docs.get(idSenderField).toString()) == 0
                ? true
                : false
            : null,
        userID: docs.get(idSenderField).toString(),
        hasSender: docs.get(hasSenderField),
        stampTime: docs.get(stampTimeField).toDate(),
        checkTimeGreaterOneMinute: checkDifferenceInCalendarInMinutes(
          docs.get(stampTimeField).toDate(),
        ),
        stampTimeFormated: differenceInCalendarStampTime(
          docs.get(stampTimeField).toDate(),
        ));
  }
}

dynamic handleMessageValue(
    {required dynamic value, required TypeMessage typeMessage}) {
  if (typeMessage == TypeMessage.text) {
    return value.toString();
  } else if (typeMessage == TypeMessage.image) {
    return value;
  } else {
    return null;
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
