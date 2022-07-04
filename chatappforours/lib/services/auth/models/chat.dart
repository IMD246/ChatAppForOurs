import 'package:chatappforours/constants/chat_constant_field.dart';
import 'package:chatappforours/constants/message_chat_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/models/user_presence.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String idChat;
  final DateTime stampTime;
  String lastText;
  String nameChat = "";
  String? urlImage;
  bool presenceUserChat = false;
  DateTime stampTimeUser;
  final bool isActive;
  final TypeMessage typeMessage;
  List<String> listUser = [];
  Chat({
    required this.typeMessage,
    required this.isActive,
    required this.idChat,
    required this.stampTime,
    required this.lastText,
    required this.nameChat,
    required this.urlImage,
    required this.presenceUserChat,
    required this.stampTimeUser,
    required this.listUser,
  });
  factory Chat.fromSnapshot({
    required DocumentSnapshot<Map<String, dynamic>> docs,
    required UserProfile? userProfile,
    required UserPresence? userPresence,
  }) =>
      Chat(
        idChat: docs.id,
        stampTime: docs.data()?[timeLastChatField] != null
            ? docs.get(timeLastChatField).toDate()
            : DateTime.now(),
        nameChat: userProfile?.fullName ?? "",
        lastText: docs.get(lastTextField),
        listUser: List<String>.from(
          docs.get(listUserField) as List,
        ),
        isActive: docs.get(isActiveField),
        typeMessage: docs.data()?[typeMessageField] != null
            ? getTypeMessage(value: docs.get(typeMessageField).toString())
            : TypeMessage.text,
        urlImage: userProfile?.urlImage ?? "",
        presenceUserChat: userPresence?.presence ?? false,
        stampTimeUser: userPresence?.stampTime ?? DateTime.now(),
      );
}

TypeMessage getTypeMessage({required String value}) {
  if (value.toString().compareTo(TypeMessage.audio.toString()) == 0) {
    return TypeMessage.audio;
  } else if (value.toString().compareTo(TypeMessage.image.toString()) == 0) {
    return TypeMessage.image;
  } else if (value.toString().compareTo(TypeMessage.text.toString()) == 0) {
    return TypeMessage.text;
  } else {
    return TypeMessage.like;
  }
}
