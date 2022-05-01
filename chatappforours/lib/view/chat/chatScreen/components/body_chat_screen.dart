import 'dart:async';

import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/crud/firebase_users_join_chat.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:chatappforours/view/chat/chatScreen/components/chat_card.dart';
import 'package:chatappforours/view/chat/messageScreen/message_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../utilities/handle/handle_value.dart';

class BodyChatScreen extends StatefulWidget {
  const BodyChatScreen({Key? key}) : super(key: key);

  @override
  State<BodyChatScreen> createState() => _BodyChatScreenState();
}

class _BodyChatScreenState extends State<BodyChatScreen> {
  List<Chat> listChatData = [];
  late final FirebaseChat firebaseChat;
  late final FirebaseUsersJoinChat firebaseUsersJoinChat;
  final String userID = FirebaseAuth.instance.currentUser!.uid;
  bool isFilledRecent = true;
  bool isFilledActive = false;
  late final bool isActive;
  @override
  void initState() {
    firebaseChat = FirebaseChat();
    firebaseUsersJoinChat = FirebaseUsersJoinChat();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: kPrimaryColor,
          padding: const EdgeInsets.fromLTRB(
            kDefaultPadding,
            0,
            kDefaultPadding,
            kDefaultPadding,
          ),
          child: Row(
            children: [
              FillOutlineButton(
                isFilled: isFilledRecent,
                press: () {
                  if (isFilledActive == true) {
                    setState(
                      () {
                        isFilledRecent = true;
                        isFilledActive = false;
                      },
                    );
                  }
                },
                text: "Recent Message",
              ),
              const SizedBox(width: kDefaultPadding),
              FillOutlineButton(
                press: () {
                  if (isFilledActive == false) {
                    setState(() {
                      isFilledRecent = false;
                      isFilledActive = true;
                    });
                  }
                },
                text: "Active",
                isFilled: isFilledActive,
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream: firebaseChat.getAllChat(ownerUserID: userID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final allChat = snapshot.data as Iterable<Chat>;
                  if (allChat.isNotEmpty) {
                    return ChatListView(
                      allChat: allChat,
                      isFilledActive: isFilledActive,
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "Don't have any chat",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
                } else {
                  return const Center(
                    child: Text(
                      "Don't have any chat",
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
              }),
        ),
      ],
    );
  }
}

class ChatListView extends StatefulWidget {
  const ChatListView({
    Key? key,
    required this.allChat,
    required this.isFilledActive,
  }) : super(key: key);
  final Iterable<Chat> allChat;
  final bool isFilledActive;
  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  final List<Chat> listChatData = [];
  final StreamController _streamController = StreamController();
  late final FirebaseUsersJoinChat firebaseUsersJoinChat;
  late final FirebaseUserProfile firebaseUserProfile;
  String ownerUserID = FirebaseAuth.instance.currentUser!.uid;
  final userPresenceDatabaseReference =
      FirebaseDatabase.instance.ref('userPresence');

  getAllDataChat({required Iterable<Chat> list}) async {
    listChatData.clear();
    for (var i = 0; i < list.length; i++) {
      // final userJoinChat = await firebaseUsersJoinChat.getUserJoinChatByIDChat(
      //   idChat: chat.idChat,
      //   ownerUserID: ownerUserID,
      // );
      // if (list.elementAt(i).typeChat == TypeChat.normal) {
      //   if (list.elementAt(i).listUser.length <= 1) {
      //     chat.nameChat = 'Only You';
      //     final userProfile = await firebaseUserProfile.getUserProfile(
      //       userID: list.first.userID,
      //     );
      //     chat.urlUserFriend = userProfile!.urlImage;
      //   } else {
      //     final userFriend = list
      //         .elementAt(i)
      //         .listUser
      //         .where((element) => element != ownerUserID)
      //         .first;
      //     final userProfile = await firebaseUserProfile.getUserProfile(
      //       userID: userFriend,
      //     );
      //     chat.urlUserFriend = userProfile!.urlImage;
      //     chat.nameChat = userProfile.fullName;
      //   }
      // }
      userPresenceDatabaseReference
          .child(list.elementAt(i).listUser.elementAt(1))
          .once()
          .then(
        (event) {
          // chat.rule = userJoinChat!.ruleChat;
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          final isOnline = data['presence'];
          final stampTimeUser = DateTime.tryParse(data['stamp_time'])!;
          final date = differenceInCalendarDays(stampTimeUser);
          list.elementAt(i).stampTimeUser = stampTimeUser;
          list.elementAt(i).stampTimeUserFormated = date;
          list.elementAt(i).presence = isOnline;
          listChatData.add(list.elementAt(i));
          _streamController.sink.add(listChatData);
        },
      );
    }
  }

  getAllDataChatOnline({required Iterable<Chat> list}) async {
    listChatData.clear();
    for (var i = 0; i < list.length; i++) {
      final chat = list.elementAt(i);
      // final userJoinChat = await firebaseUsersJoinChat.getUserJoinChatByIDChat(
      //   idChat: chat.idChat,
      //   ownerUserID: ownerUserID,
      // );
      // if (list.elementAt(i).typeChat == TypeChat.normal) {
      //   if (list.elementAt(i).listUser.length <= 1) {
      //     chat.nameChat = 'Only You';
      //     final userProfile = await firebaseUserProfile.getUserProfile(
      //       userID: list.first.userID,
      //     );
      //     chat.urlUserFriend = userProfile!.urlImage;
      //   } else {
      //     final userFriend = list
      //         .elementAt(i)
      //         .listUser
      //         .where((element) => element != ownerUserID)
      //         .first;
      //     final userProfile = await firebaseUserProfile.getUserProfile(
      //       userID: userFriend,
      //     );
      //     chat.urlUserFriend = userProfile!.urlImage;
      //     chat.nameChat = userProfile.fullName;
      //   }
      // }
      userPresenceDatabaseReference
          .child(list.elementAt(i).listUser[1])
          .once()
          .then(
        (event) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          // chat.rule = userJoinChat!.ruleChat;
          final isOnline = data['presence'];
          final stampTimeUser = DateTime.tryParse(data['stamp_time'])!;
          final date = differenceInCalendarDays(stampTimeUser);
          list.elementAt(i).stampTimeUser = stampTimeUser;
          list.elementAt(i).stampTimeUserFormated = date;
          list.elementAt(i).presence = isOnline;
          listChatData.add(chat);
          _streamController.sink.add(listChatData);
        },
      );
    }
  }

  @override
  void initState() {
    firebaseUsersJoinChat = FirebaseUsersJoinChat();
    firebaseUserProfile = FirebaseUserProfile();
    if (widget.isFilledActive == false) {
      getAllDataChat(list: widget.allChat);
    } else {
      getAllDataChatOnline(list: widget.allChat);
    }
    super.initState();
  }

  @override
  void dispose() {
    listChatData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allChatCard = snapshot.data as Iterable<Chat>;
              return ListView.builder(
                itemCount: allChatCard.length,
                itemBuilder: (context, index) {
                  return ChatCard(
                    chat: allChatCard.elementAt(index),
                    press: () {
                      final chatData = listChatData[index];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MesssageScreen(
                              chat: chatData,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
              );
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
