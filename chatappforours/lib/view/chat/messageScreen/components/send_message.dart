import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/services/notification/send_notification_message.dart';
import 'package:chatappforours/utilities/handle/handle_value.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({
    Key? key,
    required this.textController,
    required this.ownerUserProfile,
    required this.chat,
    required this.scroll,
  }) : super(key: key);

  final TextEditingController textController;
  final UserProfile ownerUserProfile;
  final Chat chat;
  final ItemScrollController scroll;
  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  late final FirebaseUserProfile firebaseUserProfile;
  late final FirebaseChatMessage firebaseChatMessage;
  @override
  void initState() {
    firebaseUserProfile = FirebaseUserProfile();
    firebaseChatMessage = FirebaseChatMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (widget.textController.text.isNotEmpty) {
      return IconButton(
        onPressed: () async {
          String message = widget.textController.text;
          setState(
            () {
              firebaseChatMessage.deleteMessageNotSent(
                ownerUserID: widget.ownerUserProfile.idUser!,
                chatID: widget.chat.idChat,
              );
              firebaseChatMessage.updateTextMessageNotSent(
                chat: widget.chat,
                text: widget.textController.text,
                ownerUserID: widget.ownerUserProfile.idUser!,
              );
              if (widget.scroll.isAttached) {
                widget.scroll.scrollTo(
                  index: intMaxValue,
                  duration: const Duration(seconds: 3),
                  curve: Curves.easeIn,
                );
              }
              widget.textController.clear();
            },
          );
          // Push notification to others in chat
          String userIDFriend =
              handleListUserIDChat(widget.chat, widget.ownerUserProfile);
          final ownerUserID = widget.ownerUserProfile.idUser!;
          if (userIDFriend.compareTo(ownerUserID) != 0) {
            final userProfile = widget.ownerUserProfile;
            final userProfileFriend = await firebaseUserProfile.getUserProfile(
              userID: userIDFriend,
            );
            final urlImage = userProfile.urlImage.isNotEmpty
                ? userProfile.urlImage
                : "https://i.stack.imgur.com/l60Hf.png";
            final Map<String, dynamic> notification = {
              'title': userProfile.fullName,
              'body': message,
            };
            final Map<String, dynamic> data = {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': 1,
              'messageType': TypeNotification.chat.toString(),
              "sendById": ownerUserID,
              "sendBy": userProfile.fullName,
              "chat": <String, dynamic>{
                "idChat": widget.chat.idChat,
                "nameChat": widget.chat.nameChat,
                "urlImage": widget.chat.urlImage,
                "presence": widget.chat.presenceUserChat,
              },
              "userProfile": <String, dynamic>{
                "idUser": widget.ownerUserProfile.idUser,
              },
              'image': urlImage,
              'status': 'done',
            };
            await sendMessage(
              notification: notification,
              tokenUserFriend: userProfileFriend!.tokenUser!,
              data: data,
              tokenOwnerUser: widget.ownerUserProfile.tokenUser!,
            );
          }
        },
        icon: const Icon(Icons.send),
        color: Theme.of(context).primaryColor,
      );
    } else {
      return InkWell(
        onTap: () async {
          // Push notification to others in chat
          String userIDFriend =
              handleListUserIDChat(widget.chat, widget.ownerUserProfile);
          final ownerUserID = widget.ownerUserProfile.idUser!;
          if (userIDFriend.compareTo(ownerUserID) != 0) {
            final userProfile = widget.ownerUserProfile;
            final userProfileFriend = await firebaseUserProfile.getUserProfile(
              userID: userIDFriend,
            );
            final urlImage = userProfile.urlImage.isNotEmpty
                ? userProfile.urlImage
                : "https://i.stack.imgur.com/l60Hf.png";
            final Map<String, dynamic> notification = {
              'title': userProfile.fullName,
              'body': "👍",
            };
            final Map<String, dynamic> data = {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': 1,
              'messageType': TypeNotification.chat.toString(),
              "sendById": ownerUserID,
              "sendBy": userProfile.fullName,
              "chat": <String, dynamic>{
                "idChat": widget.chat.idChat,
                "nameChat": widget.chat.nameChat,
                "urlImage": widget.chat.urlImage,
                "presence": widget.chat.presenceUserChat,
              },
              "userProfile": <String, dynamic>{
                "idUser": widget.ownerUserProfile.idUser,
              },
              'image': urlImage,
              'status': 'done',
            };
            await sendMessage(
              notification: notification,
              tokenUserFriend: userProfileFriend!.tokenUser!,
              data: data,
              tokenOwnerUser: widget.ownerUserProfile.tokenUser!,
            );
          }
          setState(
            () {
              firebaseChatMessage.createLikeMessage(
                userProfile: widget.ownerUserProfile,
                chat: widget.chat,
              );
            },
          );
        },
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.6),
          child: Image.asset(
            "assets/icons/like_white.png",
            color: kPrimaryColor,
            height: size.height * 0.030,
          ),
        ),
      );
    }
  }
}
