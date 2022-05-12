import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/notification/send_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/chat_input_field_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({
    Key? key,
    required this.firebaseChatMessage,
    required this.id,
    required this.textController,
    required this.widget,
  }) : super(key: key);

  final FirebaseChatMessage firebaseChatMessage;
  final String id;
  final TextEditingController textController;
  final ChatInputFieldMessage widget;

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
  final String ownerUserID = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        String message = widget.textController.text;
        setState(
          () {
            widget.firebaseChatMessage.deleteMessageNotSent(
              ownerUserID: widget.id,
              chatID: widget.widget.chat.idChat,
            );
            widget.firebaseChatMessage.updateTextMessageNotSent(
              chat: widget.widget.chat,
              text: widget.textController.text,
              ownerUserID: widget.id,
            );
            if (widget.widget.scroll.isAttached) {
              widget.textController.clear();
              widget.widget.scroll.scrollTo(
                index: intMaxValue,
                duration: const Duration(seconds: 3),
                curve: Curves.easeIn,
              );
            }
          },
        );
        // Push notification to others in chat
        final userIDFriend = widget.widget.chat.listUser.first;
        final ownerUserID = widget.id;
        if (userIDFriend.compareTo(ownerUserID) != 0) {
          final userProfile = await firebaseUserProfile.getUserProfile(
            userID: widget.id,
          );
          final userProfileFriend = await firebaseUserProfile.getUserProfile(
            userID: userIDFriend,
          );
          final Map<String, dynamic> notification = {
            'title': userProfile!.fullName,
            'body': message,
          };
          final Map<String, String> data = {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': widget.widget.chat.idChat,
            'messageType': TypeNotification.chat.toString(),
            "sendById": ownerUserID,
            "sendBy": userProfile.fullName,
            'status': 'done',
          };
          sendMessage(
            notification: notification,
            tokenUserFriend: userProfileFriend!.tokenUser!,
            data: data,
          );
        }
      },
      icon: const Icon(Icons.send),
      color: Theme.of(context).primaryColor,
    );
  }
}
