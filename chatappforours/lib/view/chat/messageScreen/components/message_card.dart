import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/chat_message.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/utilities/handle/handle_value.dart';
import 'package:chatappforours/view/chat/messageScreen/components/audio_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/image_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/like_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/message_status_dot.dart';
import 'package:chatappforours/view/chat/messageScreen/components/text_message.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../constants/constants.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    Key? key,
    required this.chatMessage,
    required this.chat,
    required this.scrollController,
    required this.listChatMesage,
    required this.index,
    required this.beforeIndex,
    required this.ownerUserProfile,
  }) : super(key: key);
  final ChatMessage chatMessage;
  final Chat chat;
  final int index;
  final int beforeIndex;
  final Iterable<ChatMessage> listChatMesage;
  final ItemScrollController scrollController;
  final UserProfile ownerUserProfile;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  late final FirebaseUserProfile firebaseUserProfile;
  late final FirebaseChatMessage firebaseChatMessage;

  String? urlStringImage;
  bool isSelected = false;
  bool isCheckLastMessage = false;
  late bool checkCurrentAndIndexTimeGreater10Minute;
  late final String userIDFriend;
  @override
  void initState() {
    firebaseUserProfile = FirebaseUserProfile();
    firebaseChatMessage = FirebaseChatMessage();
    userIDFriend = handleListUserIDChat(widget.chat, widget.ownerUserProfile);
    widget.index <= 0
        ? checkCurrentAndIndexTimeGreater10Minute = true
        : checkCurrentAndIndexTimeGreater10Minute =
            checkDifferenceBeforeAndCurrentTimeGreaterThan10Minutes(
            widget.listChatMesage.elementAt(widget.beforeIndex).stampTime,
            widget.chatMessage.stampTime,
          );
    if (widget.ownerUserProfile.idUser != userIDFriend) {
      if (widget.chatMessage.messageStatus == MessageStatus.sent &&
          widget.chatMessage.isSender == false) {
        firebaseChatMessage.updateMessageFriendToViewed(
          chatID: widget.chat.idChat,
          messageID: widget.chatMessage.idMessage,
        );
      }
    } else {
      if (widget.chatMessage.messageStatus == MessageStatus.sent &&
          widget.chatMessage.isSender == true) {
        firebaseChatMessage.updateMessageFriendToViewed(
          chatID: widget.chat.idChat,
          messageID: widget.chatMessage.idMessage,
        );
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ThemeChanger themeChanger = Provider.of<ThemeChanger>(context);
    Widget messageContaint(ChatMessage chatMessage) {
      switch (chatMessage.messageType) {
        case TypeMessage.text:
          return TextMessage(
            chatMessage: chatMessage,
            isSelected: isSelected,
          );
        case TypeMessage.audio:
          return AudioMessasge(
            chatMessage: chatMessage,
          );
        case TypeMessage.image:
          return ImageMessage(
            chatMessage: chatMessage,
          );
        case TypeMessage.like:
          return const LikeMessage();
        default:
          return const SizedBox();
      }
    }

    return Column(
      children: [
        if (checkCurrentAndIndexTimeGreater10Minute &&
            widget.chatMessage.messageStatus != MessageStatus.notSent)
          Visibility(
            visible: isSelected || checkCurrentAndIndexTimeGreater10Minute,
            child: Center(
              child: Text(
                widget.chatMessage.stampTimeFormated,
                style: TextStyle(
                  fontSize: 12,
                  color: textColorMode(
                      // themeChanger.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
                      ThemeMode.light).withOpacity(0.5),
                ),
              ),
            ),
          ),
        if (!checkCurrentAndIndexTimeGreater10Minute &&
            widget.chatMessage.messageStatus != MessageStatus.notSent)
          Visibility(
            visible: isSelected,
            child: Center(
              child: Text(
                widget.chatMessage.stampTimeFormated,
                style: TextStyle(
                  fontSize: 12,
                  color: textColorMode(
                      // themeChanger.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
                      ThemeMode.light).withOpacity(0.5),
                ),
              ),
            ),
          ),
        GestureDetector(
          onTap: () async {
            if (widget.chatMessage.messageStatus != MessageStatus.notSent) {
              if (isCheckLastMessage == false &&
                  widget.listChatMesage.length > 1) {
                isCheckLastMessage =
                    await firebaseChatMessage.checkLastMessageOfChatRoom(
                  chatID: widget.chat.idChat,
                  idMessage: widget.chatMessage.idMessage,
                );
              }
              setState(
                () {
                  isSelected = !isSelected;
                  if (isCheckLastMessage && isSelected == true) {
                    if (widget.scrollController.isAttached) {
                      widget.scrollController.scrollTo(
                        index: intMaxValue,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  }
                },
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding * 0.25,
              horizontal: kDefaultPadding * 0.2,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: widget.chatMessage.hasSender == true
                      ? widget.chatMessage.isSender!
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    if (widget.chatMessage.hasSender &&
                        widget.chatMessage.isSender != null)
                      if (widget.chatMessage.isSender == false)
                        FutureBuilder<UserProfile?>(
                          future: firebaseUserProfile.getUserProfile(
                             userID: widget.chatMessage.userID,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final userProfile = snapshot.data;
                              urlStringImage = userProfile!.urlImage.isNotEmpty
                                  ? userProfile.urlImage: null;
                              if (widget.chat.urlImage == null) {
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
                                  radius: 20,
                                  child: ClipOval(
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(60),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.chat.urlImage!,
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
                              return const Text('');
                            }
                          },
                        ),
                    const SizedBox(width: kDefaultPadding * 0.5),
                    messageContaint(widget.chatMessage),
                    if (widget.chatMessage.messageStatus ==
                            MessageStatus.viewed ||
                        widget.chatMessage.messageStatus == MessageStatus.sent)
                      MessageStatusDot(
                        messageStatus: widget.chatMessage.messageStatus,
                        urlStringImage: urlStringImage,
                        chatID: widget.chat.idChat,
                        idMessage: widget.chatMessage.idMessage,
                        idUserFriend: userIDFriend,
                        isSender: widget.chatMessage.hasSender
                            ? widget.chatMessage.isSender!
                            : false,
                      ),
                  ],
                ),
                Visibility(
                  visible: isSelected,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 1.25,
                    ),
                    child: Align(
                      alignment: widget.chatMessage.hasSender == true
                          ? widget.chatMessage.isSender!
                              ? Alignment.centerRight
                              : Alignment.centerLeft
                          : Alignment.center,
                      child: Text(
                        getStringMessageStatus(
                          widget.chatMessage.messageStatus,
                          context,
                        ),
                        style: TextStyle(
                          fontSize: 11,
                          color: textColorMode(
                            ThemeMode.light,
                          ).withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
