import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/services/auth/storage/storage.dart';
import 'package:chatappforours/services/notification/send_notification_message.dart';
import 'package:chatappforours/utilities/handle/handle_value.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class UploadImageMessage extends StatelessWidget {
  const UploadImageMessage({
    Key? key,
    required this.chat,
    required this.ownerUserProfile,
    required this.scroll,
  }) : super(key: key);

  final Chat chat;
  final UserProfile ownerUserProfile;
  final ItemScrollController scroll;

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    final FirebaseChatMessage firebaseChatMessage = FirebaseChatMessage();
    final FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
    return IconButton(
      onPressed: () async {
        final results = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png'],
        );
        if (results != null) {
          await firebaseChatMessage.createImageMessage(
            ownerUserProfile: ownerUserProfile,
            context: context,
            chat: chat,
          );
          final lastMessageUserOwner =
              await firebaseChatMessage.getImageMessageNotSentOwnerUser(
            userID: ownerUserProfile.idUser!,
            chatID: chat.idChat,
          );
          await storage.uploadMultipleFile(
              listFile: results.files,
              idChat: chat.idChat,
              firebaseChatMessage: firebaseChatMessage,
              lastMessageUserOwner: lastMessageUserOwner,
              context: context,
              ownerUserProfile: ownerUserProfile);
          if (scroll.isAttached) {
            scroll.scrollTo(
              index: intMaxValue,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
          String userIDFriend = handleListUserIDChat(chat, ownerUserProfile);
          final ownerUserID = ownerUserProfile.idUser!;
          if (userIDFriend.compareTo(ownerUserID) != 0) {
            final userProfile = ownerUserProfile;
            final userProfileFriend = await firebaseUserProfile.getUserProfile(
              userID: userIDFriend,
            );
            final Map<String, dynamic> notification = {
              'title': userProfile.fullName,
              'body': handleStringMessageLocalization(
                chat.lastText,
                context,
              ),
            };
            final urlImage = userProfile.urlImage.isNotEmpty
                ? userProfile.urlImage
                : "https://i.stack.imgur.com/l60Hf.png";
            final Map<String, dynamic> data = {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': 1,
              'messageType': TypeNotification.chat.toString(),
              "sendById": ownerUserID,
              "sendBy": userProfile.fullName,
              "chat": <String, dynamic>{
                "idChat": chat.idChat,
                "nameChat": chat.nameChat,
                "urlImage": chat.urlImage,
                "presence": chat.presenceUserChat,
              },
              "userProfile": <String, dynamic>{
                "idUser": ownerUserProfile.idUser,
              },
              'image': urlImage,
              'status': 'done',
            };
            sendMessage(
              notification: notification,
              tokenUserFriend: userProfileFriend!.tokenUser!,
              data: data,
              tokenOwnerUser: ownerUserProfile.tokenUser!,
            );
          }
        }
      },
      icon: const Icon(Icons.photo),
      color: Theme.of(context).primaryColor,
    );
  }
}
