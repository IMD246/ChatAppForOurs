import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/storage/storage.dart';
import 'package:chatappforours/view/chat/messageScreen/components/chat_input_field_message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadImageMessage extends StatelessWidget {
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
          await firebaseChatMessage.createImageMessage(
            userID: id,
            chatID: widget.chat.idChat,
          );
          final lastMessageUserOwner =
              await firebaseChatMessage.getImageMessageNotSentOwnerUser(
            userID: id,
            chatID: widget.chat.idChat,
          );
          await storage.uploadMultipleFile(
            listFile: results.files,
            idChat: widget.chat.idChat,
            firebaseChatMessage: firebaseChatMessage,
            firebaseUserProfile: firebaseUserProfile,
            lastMessageUserOwner: lastMessageUserOwner,
            context: context,
          );
          if (widget.scroll.isAttached) {
            widget.scroll.scrollTo(
              index: intMaxValue,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        }
      },
      icon: const Icon(Icons.photo),
      color: Theme.of(context).primaryColor,
    );
  }
}