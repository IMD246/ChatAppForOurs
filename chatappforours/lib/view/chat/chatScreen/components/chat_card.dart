import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/utilities/handle/handle_value.dart';
import 'package:chatappforours/view/chat/messageScreen/message_screen.dart';
import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';

class ChatCard extends StatefulWidget {
  const ChatCard({
    Key? key,
    required this.chat,
    required this.ownerUserProfile,
    required this.isFillActive,
  }) : super(key: key);
  final Future<Chat> chat;
  final UserProfile ownerUserProfile;
  final bool isFillActive;
  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  late final FirebaseChat firebaseChat;
  @override
  void initState() {
    firebaseChat = FirebaseChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Chat>(
      future: widget.chat,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final chat = snapshot.data!;
          final bool isFillActive = widget.isFillActive
              ? chat.presenceUserChat
                  ? true
                  : false
              : true;
          return Visibility(
            visible: isFillActive,
            child: InkWell(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MesssageScreen(
                        chat: chat,
                        ownerUserProfile: widget.ownerUserProfile,
                      );
                    },
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding,
                  vertical: kDefaultPadding * 0.75,
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        if (chat.urlImage != null)
                          CircleAvatar(
                            backgroundColor: Colors.cyan[100],
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(60),
                                child: CachedNetworkImage(
                                  imageUrl: chat.urlImage!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        if (chat.urlImage == null)
                          CircleAvatar(
                            backgroundColor: Colors.cyan[100],
                            backgroundImage: const AssetImage(
                              "assets/images/defaultImage.png",
                            ),
                          ),
                        if (chat.presenceUserChat)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kPrimaryColor,
                                border: Border.all(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                        if (!chat.presenceUserChat)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Text(
                              differenceInCalendarPresence(
                                chat.stampTimeUser,
                              ),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: kDefaultPadding / 2),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chat.nameChat,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Opacity(
                              opacity: 0.64,
                              child: Text(
                                chat.lastText
                                // getStringMessageByTypeMessage(
                                //   typeMessage: chat.typeMessage,
                                //   value: chat.lastText,
                                //   context: context,
                                // ),
                                ,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        differenceInCalendarDaysLocalization(
                          chat.stampTime,
                          context,
                        ),
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Text("");
        }
      },
    );
  }
}
