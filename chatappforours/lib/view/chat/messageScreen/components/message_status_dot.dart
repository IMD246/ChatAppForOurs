import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:flutter/material.dart';


class MessageStatusDot extends StatefulWidget {
  const MessageStatusDot(
      {Key? key,
      required,
      required this.messageStatus,
      required this.urlStringImage,
      required this.chatID,
      required this.idMessage,
      required this.idUserFriend,
      required this.isSender})
      : super(key: key);
  final MessageStatus messageStatus;
  final String? urlStringImage;
  final String chatID;
  final String idMessage;
  final String idUserFriend;
  final bool isSender;
  @override
  State<MessageStatusDot> createState() => _MessageStatusDotState();
}

class _MessageStatusDotState extends State<MessageStatusDot> {
  late final FirebaseChatMessage firebaseChatMessage;
  @override
  void initState() {
    firebaseChatMessage = FirebaseChatMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 16,
        height: 16,
        decoration: widget.messageStatus == MessageStatus.viewed
            ? null
            : BoxDecoration(
                color: (widget.messageStatus == MessageStatus.sent &&
                        widget.isSender == true)
                    ? kPrimaryColor
                    : null,
                shape: BoxShape.circle,
              ),
        child: widget.messageStatus != MessageStatus.notSent &&
                widget.isSender == true
            ? FutureBuilder<UserProfile?>(
                future: firebaseChatMessage
                    .checkLastMessageOfChatRoomForUploadStatusMessageViewed(
                  chatID: widget.chatID,
                  idMessage: widget.idMessage,
                  userIDFriend: widget.idUserFriend,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userProfile = snapshot.data;
                    if (userProfile!.urlImage.isEmpty) {
                      return CircleAvatar(
                        backgroundColor: Colors.cyan[100],
                        backgroundImage: const AssetImage(
                          "assets/images/defaultImage.png",
                        ),
                      );
                    } else {
                      return CircleAvatar(
                        backgroundColor: Colors.cyan[100],
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(60),
                            child: CachedNetworkImage(
                              imageUrl: userProfile.urlImage,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      );
                    }
                  } else {
                    return Icon(
                      Icons.done,
                      size: 8,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    );
                  }
                },
              )
            : const Text(''));
  }
}