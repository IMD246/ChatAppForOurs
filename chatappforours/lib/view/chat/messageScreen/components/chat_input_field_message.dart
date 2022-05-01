import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/storage/storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../constants/constants.dart';

class ChatInputFieldMessage extends StatefulWidget {
  const ChatInputFieldMessage({
    Key? key,
    required this.idChat,
    required this.scroll,
    required this.userIDFriend,
  }) : super(key: key);
  final String idChat;
  final String userIDFriend;
  final ItemScrollController scroll;
  @override
  State<ChatInputFieldMessage> createState() => _ChatInputFieldMessageState();
}

class _ChatInputFieldMessageState extends State<ChatInputFieldMessage> {
  late final TextEditingController textController;
  late final FirebaseChatMessage firebaseChatMessage;
  late final FirebaseUserProfile firebaseUserProfile;
  String id = FirebaseAuth.instance.currentUser!.uid;
  late final Storage storage;
  @override
  void initState() {
    textController = TextEditingController();
    firebaseChatMessage = FirebaseChatMessage();
    firebaseUserProfile = FirebaseUserProfile();
    storage = Storage();
    super.initState();
  }

  @override
  void dispose() {
    textController.clear();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 32,
            color: const Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
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
                    chatID: widget.idChat,
                  );
                  final lastMessageUserOwner =
                      await firebaseChatMessage.getImageMessageNotSentOwnerUser(
                    userID: id,
                    chatID: widget.idChat,
                  );
                  await storage.uploadMultipleFile(
                    listFile: results.files,
                    idChat: widget.idChat,
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
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.mic),
              color: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75,
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: kDefaultPadding * 0.4,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        onTap: () async {
                          await firebaseChatMessage.createTextMessageNotSent(
                            userID: id,
                            chatID: widget.idChat,
                          );
                          if (widget.scroll.isAttached) {
                            widget.scroll.scrollTo(
                              index: intMaxValue,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        onChanged: (value) async {
                          if (textController.text.isNotEmpty) {
                            await firebaseChatMessage.createTextMessageNotSent(
                              userID: id,
                              chatID: widget.idChat,
                            );
                            if (widget.scroll.isAttached) {
                              widget.scroll.scrollTo(
                                index: intMaxValue,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            }
                          }
                          setState(() {
                            if (textController.text.isEmpty) {
                              firebaseChatMessage.deleteMessageNotSent(
                                  ownerUserID: id, chatID: widget.idChat);
                            }
                          });
                        },
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Type Message',
                          hintStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding / 4),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.sentiment_satisfied_alt,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
              ),
            ),
            if (textController.text.isNotEmpty)
              IconButton(
                onPressed: () async {
                  setState(
                    () {
                      firebaseChatMessage.deleteMessageNotSent(
                        ownerUserID: id,
                        chatID: widget.idChat,
                      );
                      firebaseChatMessage.updateTextMessageSent(
                        chatID: widget.idChat,
                        text: textController.text,
                        ownerUserID: id,
                        userIDFriend: widget.userIDFriend,
                      );
                      textController.clear();
                      if (widget.scroll.isAttached) {
                        widget.scroll.jumpTo(
                          index: intMaxValue,
                        );
                      }
                    },
                  );
                },
                icon: const Icon(Icons.send),
                color: Theme.of(context).primaryColor,
              ),
            if (textController.text.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding * 0.6),
                child: Image.asset(
                  "assets/icons/like_white.png",
                  color: kPrimaryColor,
                  height: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
