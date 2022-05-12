import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/storage/storage.dart';
import 'package:chatappforours/services/notification/send_notification_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/chat_input_field_message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadImageMessage extends StatefulWidget {
  const UploadImageMessage({
    Key? key,
    required this.firebaseChatMessage,
    required this.id,
    required this.storage,
    required this.widget,
    required this.firebaseUserProfile,
  }) : super(key: key);

  final FirebaseChatMessage firebaseChatMessage;
  final String id;
  final Storage storage;
  final ChatInputFieldMessage widget;
  final FirebaseUserProfile firebaseUserProfile;

  @override
  State<UploadImageMessage> createState() => _UploadImageMessageState();
}

class _UploadImageMessageState extends State<UploadImageMessage> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final results = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png'],
        );
        if (results == null) {
        } else {
          await widget.firebaseChatMessage.createImageMessage(
            userID: widget.id,
            chatID: widget.widget.chat.idChat,
          );
          final lastMessageUserOwner =
              await widget.firebaseChatMessage.getImageMessageNotSentOwnerUser(
            userID: widget.id,
            chatID: widget.widget.chat.idChat,
          );
          setState(
            () {
              widget.storage.uploadMultipleFile(
                listFile: results.files,
                idChat: widget.widget.chat.idChat,
                firebaseChatMessage: widget.firebaseChatMessage,
                firebaseUserProfile: widget.firebaseUserProfile,
                lastMessageUserOwner: lastMessageUserOwner,
                context: context,
              );
              if (widget.widget.scroll.isAttached) {
                widget.widget.scroll.scrollTo(
                  index: intMaxValue,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }
            },
          );
        }
        final userIDFriend = widget.widget.chat.listUser.first;
        final ownerUserID = widget.id;
        if (userIDFriend.compareTo(ownerUserID) != 0) {
          final userProfile = await widget.firebaseUserProfile.getUserProfile(
            userID: ownerUserID,
          );
          final userProfileFriend =
              await widget.firebaseUserProfile.getUserProfile(
            userID: userIDFriend,
          );
          final Map<String, dynamic> notification = {
            'title': userProfile!.fullName,
            'body': userProfile.fullName,
          };
          final Map<String, String> data = {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': widget.widget.chat.idChat,
            'messageType': TypeNotification.chat.toString(),
            "sendById": ownerUserID,
            "sendBy": userProfile.fullName,
             'image': userProfile.urlImage ??
                          "https://i.stack.imgur.com/l60Hf.png",
            'status': 'done',
          };
          sendMessage(
            notification: notification,
            tokenUserFriend: userProfileFriend!.tokenUser!,
            data: data,
          );
        }
      },
      icon: const Icon(Icons.photo),
      color: Theme.of(context).primaryColor,
    );
  }
}
