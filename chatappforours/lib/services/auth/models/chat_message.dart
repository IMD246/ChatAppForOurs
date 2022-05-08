import 'package:chatappforours/constants/message_chat_field.dart';
import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/utilities/handle/handle_value.dart';
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
  final String urlAudio;
  List<String>? listURLImage = [];
  final bool checkTimeGreaterOneMinute;
  ChatMessage({
    required this.urlAudio,
    required this.idMessage,
    required this.stampTime,
    required this.stampTimeFormated,
    this.listURLImage,
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
      value: docs.get(messageField),
      messageType: getTypeMessage(value: docs.get(typeMessageField).toString()),
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
      ),
        urlAudio:
            getTypeMessage(value: docs.get(typeMessageField).toString()) == TypeMessage.audio ? docs.get('url_audio').toString() : "",
      listURLImage: checkTypeMessageImage(
              typeMessage:
                  getTypeMessage(value: docs.get(typeMessageField).toString()))
          ? getListStringURLImage(
              typeMessage:
                  getTypeMessage(value: docs.get(typeMessageField).toString()),
              value: docs.get(listURLImageField),
            )
          : [],
    );
  }
}

bool checkTypeMessageImage({required TypeMessage typeMessage}) {
  if (typeMessage == TypeMessage.image) {
    return true;
  } else {
    return false;
  }
}

List<String> getListStringURLImage(
    {required TypeMessage typeMessage, required dynamic value}) {
  if (value != null) {
    if (typeMessage == TypeMessage.image) {
      return List<String>.from(value as List);
    } else {
      return [];
    }
  } else {
    return [];
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
