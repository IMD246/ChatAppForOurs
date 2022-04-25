import 'dart:async';

import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';

import 'package:chatappforours/services/auth/crud/firebase_users_join_chat.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/users_join_chat.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:chatappforours/view/chat/chatScreen/components/chat_card.dart';
import 'package:chatappforours/view/chat/messageScreen/message_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BodyChatScreen extends StatefulWidget {
  const BodyChatScreen({Key? key}) : super(key: key);

  @override
  State<BodyChatScreen> createState() => _BodyChatScreenState();
}

class _BodyChatScreenState extends State<BodyChatScreen> {
  List<Chat> listChatData = [];
  late final FirebaseUsersJoinChat firebaseUsersJoinChat;
  final String userID = FirebaseAuth.instance.currentUser!.uid;
  late final DatabaseReference userPresenceDatabaseReference;
  bool isFilledRecent = true;
  bool isFilledActive = false;
  late final bool isActive;
  @override
  void initState() {
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
                  setState(
                    () {
                      isFilledRecent = true;
                      isFilledActive = false;
                      // getAllData();
                    },
                  );
                },
                text: "Recent Message",
              ),
              const SizedBox(width: kDefaultPadding),
              FillOutlineButton(
                press: () {
                  setState(() {
                    isFilledRecent = false;
                    isFilledActive = true;
                    // getData();
                  });
                },
                text: "Active",
                isFilled: isFilledActive,
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: firebaseUsersJoinChat.getUsersJoinChatByID(userID: userID),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final listUserJoinChat =
                        snapshot.data as Iterable<UsersJoinChat>;
                    return ChatListView(
                      listUserJoinChat: listUserJoinChat,
                      isFilledActive: isFilledActive,
                    );
                  } else {
                    return const SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    );
                  }
                default:
                  return const SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  );
              }
            },
          ),
        ),
      ],
    );
  }
}

class ChatListView extends StatefulWidget {
  const ChatListView({
    Key? key,
    required this.listUserJoinChat,
    required this.isFilledActive,
  }) : super(key: key);
  final Iterable<UsersJoinChat> listUserJoinChat;
  final bool isFilledActive;
  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  late final List<Chat> listChatData;
  final StreamController _streamController = StreamController();
  late final FirebaseChat firebaseChat;
  final userPresenceDatabaseReference =
      FirebaseDatabase.instance.ref('userPresence');
  getData({required Iterable<UsersJoinChat> list}) async {
    listChatData.clear();
    for (var i = 0; i < list.length; i++) {
      final chat = await firebaseChat.getChatByID(
        idChat: list.elementAt(i).chatID,
        ruleChat: list.elementAt(i).ruleChat,
        userIDChatScreen: list.elementAt(i).userID,
      );
      userPresenceDatabaseReference
          .child("${chat.userID}/presence")
          .onValue
          .listen((event) {
        bool isOnline = event.snapshot.value as bool;
        chat.presence = isOnline;
        listChatData.add(chat);
        _streamController.sink.add(listChatData);
      });
    }
  }

  @override
  void initState() {
    firebaseChat = FirebaseChat();
    listChatData = <Chat>[];
    getData(list: widget.listUserJoinChat);
    super.initState();
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
                            return MesssageScreen(chat: chatData);
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
            return Container(
              color: Theme.of(context).scaffoldBackgroundColor,
            );
        }
      },
    );
  }
}
