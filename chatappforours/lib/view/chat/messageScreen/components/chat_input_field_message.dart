import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/storage/storage.dart';
import 'package:chatappforours/services/notification/send_notification_message.dart';
import 'package:chatappforours/services/notification/utils_download_file.dart';
import 'package:chatappforours/utilities/handle/handle_value.dart';
import 'package:chatappforours/view/chat/messageScreen/components/send_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/upload_image_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../constants/constants.dart';

class ChatInputFieldMessage extends StatefulWidget {
  const ChatInputFieldMessage({
    Key? key,
    required this.chat,
    required this.scroll,
    required this.userIDFriend,
  }) : super(key: key);
  final Chat chat;
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
  final FirebaseChat firebaseChat = FirebaseChat();
  late final Storage storage;
  final recorder = FlutterSoundRecorder();
  final player = AudioPlayer();
  bool isSelected = false;
  String? recordTxt;
  Future record() async {
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    final path = await recorder.stopRecorder();

    await firebaseChatMessage.createAudioMessage(
      userID: id,
      chatID: widget.chat.idChat,
    );
    await storage.uploadFileAudio(
      filePath: path!,
      firebaseChatMessage: firebaseChatMessage,
      firebaseUserProfile: firebaseUserProfile,
      idChat: widget.chat.idChat,
      userOwnerID: id,
    );
    String userIDFriend = widget.chat.listUser.first;
    final ownerUserID = id;
    if (userIDFriend.compareTo(ownerUserID) != 0) {
      final chat = await firebaseChat.getChatByID(
        idChat: widget.chat.idChat,
        userChatID: ownerUserID,
      );
      final userProfile = await firebaseUserProfile.getUserProfile(
        userID: ownerUserID,
      );
      final userProfileFriend = await firebaseUserProfile.getUserProfile(
        userID: userIDFriend,
      );
      final Map<String, dynamic> notification = {
        'title': userProfile!.fullName,
        'body': getStringMessageByTypeMessage(
          typeMessage: chat.typeMessage,
          value: chat.lastText,
          context: context,
        ),
      };
      final urlImage =
          userProfile.urlImage ?? "https://i.stack.imgur.com/l60Hf.png";
      final largeIconPath = await UtilsDownloadFile.downloadFile(
        urlImage,
        'largeIcon',
      );
      final Map<String, dynamic> data = {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': 1,
        'messageType': TypeNotification.chat.toString(),
        "sendById": ownerUserID,
        "sendBy": userProfile.fullName,
        "chat": <String, dynamic>{
          "idChat": widget.chat.idChat,
          "presence": widget.chat.presence,
          "stampTimeUser": widget.chat.stampTimeUser.toString(),
        },
        'image': largeIconPath,
        'status': 'done',
      };
      sendMessage(
        notification: notification,
        tokenUserFriend: userProfileFriend!.tokenUser!,
        data: data,
      );
    }
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await recorder.openAudioSession();
    await recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
  }

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
    recorder.closeAudioSession();
    firebaseChatMessage.deleteMessageNotSent(
      ownerUserID: id,
      chatID: widget.chat.idChat,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            UploadImageMessage(
              firebaseChatMessage: firebaseChatMessage,
              id: id,
              storage: storage,
              firebaseUserProfile: firebaseUserProfile,
              widget: widget,
            ),
            IconButton(
              onPressed: () async {
                await initRecorder();
                if (recorder.isRecording && isSelected) {
                  setState(() {
                    stop();
                    isSelected = false;
                  });
                } else {
                  setState(() {
                    record();
                    isSelected = true;
                  });
                }
              },
              icon: isSelected ? const Icon(Icons.stop) : const Icon(Icons.mic),
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
                          if (isSelected) {
                            setState(() {
                              isSelected = false;
                              recorder.stopRecorder();
                              recorder.deleteRecord(fileName: 'audio');
                            });
                          } else {
                            await firebaseChatMessage.deleteMessageNotSent(
                                ownerUserID: id, chatID: widget.chat.idChat);
                            if (widget.scroll.isAttached) {
                              widget.scroll.scrollTo(
                                index: intMaxValue,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            }
                          }
                        },
                        onChanged: (value) async {
                          setState(() {});
                          if (textController.text.isNotEmpty) {
                            await firebaseChatMessage.createTextMessageNotSent(
                              userID: id,
                              chatID: widget.chat.idChat,
                            );
                            if (widget.scroll.isAttached) {
                              widget.scroll.scrollTo(
                                index: intMaxValue,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            }
                          }
                          if (textController.text.isEmpty) {
                            await firebaseChatMessage.deleteMessageNotSent(
                                ownerUserID: id, chatID: widget.chat.idChat);
                          }
                        },
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: isSelected
                              ? context.loc.recording
                              : context.loc.type_message,
                          hintStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding / 4),
                    if (isSelected)
                      StreamBuilder<RecordingDisposition>(
                        stream: recorder.onProgress,
                        builder: (context, snapshot) {
                          final duration = snapshot.hasData
                              ? snapshot.data!.duration
                              : Duration.zero;

                          return Text("${formatTime(duration)} s");
                        },
                      )
                    else
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
              SendMessage(
                firebaseChatMessage: firebaseChatMessage,
                id: id,
                widget: widget,
                textController: textController,
              ),
            if (textController.text.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding * 0.6),
                child: Image.asset(
                  "assets/icons/like_white.png",
                  color: kPrimaryColor,
                  height: size.height * 0.030,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
