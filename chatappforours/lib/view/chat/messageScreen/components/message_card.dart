import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/chat_message.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/view/chat/messageScreen/components/audio_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/image_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/text_message.dart';
import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    Key? key,
    required this.chatMessage,
  }) : super(key: key);
  final ChatMessage chatMessage;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  late final FirebaseUserProfile firebaseUserProfile;
  @override
  void initState() {
    firebaseUserProfile = FirebaseUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(ChatMessage chatMessage) {
      switch (chatMessage.messageType) {
        case TypeMessage.text:
          return TextMessage(chatMessage: chatMessage);
        case TypeMessage.audio:
          return AudioMessasge(
            chatMessage: chatMessage,
          );
        case TypeMessage.image:
          return const ImageMesage(
            urlImage: "assets/images/Video Place Here.png",
          );
        default:
          return const SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: kDefaultPadding * 0.25,
        horizontal: kDefaultPadding * 0.75,
      ),
      child: Row(
        mainAxisAlignment: widget.chatMessage.isSender
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!widget.chatMessage.isSender)
            FutureBuilder<UserProfile?>(
              future: firebaseUserProfile.getUserProfile(
                  userID: widget.chatMessage.userID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userProfile = snapshot.data;
                  if (userProfile!.urlImage == null) {
                    return FittedBox(
                      fit: BoxFit.fill,
                      child: CircleAvatar(
                        backgroundColor: Colors.cyan[100],
                        backgroundImage: const AssetImage(
                          "assets/images/defaultImage.png",
                        ),
                        radius: 20,
                      ),
                    );
                  } else {
                    return CircleAvatar(
                      backgroundColor: Colors.cyan[100],
                      radius: 20,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: userProfile.urlImage!,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    );
                  }
                } else {
                  return const Text('');
                }
              },
            ),
          const SizedBox(width: kDefaultPadding * 0.5),
          messageContaint(widget.chatMessage),
          if (widget.chatMessage.messageStatus == MessageStatus.viewed ||
              widget.chatMessage.messageStatus == MessageStatus.sent)
            MessageStatusDot(
              messageStatus: widget.chatMessage.messageStatus,
            ),
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  const MessageStatusDot({Key? key, required, required this.messageStatus})
      : super(key: key);
  final MessageStatus messageStatus;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: kDefaultPadding / 2),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: (messageStatus == MessageStatus.viewed)
            ? kPrimaryColor
            : Colors.black.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
