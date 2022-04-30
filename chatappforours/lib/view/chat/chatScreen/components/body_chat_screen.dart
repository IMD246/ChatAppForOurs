import 'dart:async';

import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/crud/firebase_users_join_chat.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/users_join_chat.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:chatappforours/utilities/time_handle/handle_value.dart';
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
            stream: firebaseUsersJoinChat.getAllIDChatUserJoined(
                ownerUserID: userID),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allUersJoinChat =
                        snapshot.data as Iterable<UsersJoinChat>;
                    final List<UsersJoinChat> allUsers = [];
                    allUsers.addAll(allUersJoinChat);
                    if (allUersJoinChat.isNotEmpty) {
                      return ChatListView(
                        allChat: allUersJoinChat.elementAt(0).userID == userID
                            ? allUsers
                            : allUersJoinChat
                                .where((element) => element.userID != userID)
                                .toList(),
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

                case ConnectionState.waiting:
                  return const Center(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: CircularProgressIndicator(),
                    ),
                  );
                default:
                  return const Center(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: CircularProgressIndicator(),
                    ),
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
    required this.allChat,
    required this.isFilledActive,
  }) : super(key: key);
  final List<UsersJoinChat> allChat;
  final bool isFilledActive;
  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  final List<Chat> listChatData = [];
  final StreamController _streamController = StreamController();
  late final FirebaseChat firebaseChat;
  String ownerUserID = FirebaseAuth.instance.currentUser!.uid;
  final userPresenceDatabaseReference =
      FirebaseDatabase.instance.ref('userPresence');

  getAllDataChat({required List<UsersJoinChat> list}) async {
    listChatData.clear();
    for (var i = 0; i < list.length; i++) {
      final chat =
          await firebaseChat.getChatByID(idChat: list.elementAt(i).chatID);
      chat.userID = list.elementAt(i).userID;
      chat.rule = list.elementAt(i).ruleChat;
      userPresenceDatabaseReference.child(chat.userID!).once().then(
        (event) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          final isOnline = data['presence'];
          final stampTimeUser = DateTime.tryParse(data['stamp_time'])!;
          final date = differenceInCalendarDays(stampTimeUser);
          chat.stampTimeUser = stampTimeUser;
          chat.stampTimeUserFormated = date;
          chat.presence = isOnline;
          listChatData.add(chat);
          if (listChatData.length == list.length) {
            listChatData.sort(
              (a, b) {
                return b.stampTime.compareTo(a.stampTime);
              },
            );
          }
          _streamController.sink.add(listChatData);
        },
      );
    }
  }

  getAllDataChatOnline({required List<UsersJoinChat> list}) async {
    listChatData.clear();
    for (var i = 0; i < list.length; i++) {
      final chat =
          await firebaseChat.getChatByID(idChat: list.elementAt(i).chatID);
      chat.userID = list.elementAt(i).userID;
      chat.rule = list.elementAt(i).ruleChat;
      userPresenceDatabaseReference.child(chat.userID!).once().then(
        (event) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          final isOnline = data['presence'];
          final stampTimeUser = DateTime.tryParse(data['stamp_time'])!;
          final date = differenceInCalendarDays(stampTimeUser);
          chat.stampTimeUser = stampTimeUser;
          chat.stampTimeUserFormated = date;
          chat.presence = isOnline;
          if (chat.presence!) {
            listChatData.add(chat);
            if (listChatData.length == list.length) {
              listChatData.sort(
                (a, b) {
                  return b.stampTime.compareTo(a.stampTime);
                },
              );
            }
          }
          _streamController.sink.add(listChatData);
        },
      );
    }
  }

  @override
  void initState() {
    firebaseChat = FirebaseChat();
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
        if (snapshot.hasData) {
          final allChatCard = snapshot.data as Iterable<Chat>;
          return ListView.builder(
            itemCount: allChatCard.length,
            itemBuilder: (context, index) {
              return ChatCard(
                chat: allChatCard.elementAt(index),
                press: () async {
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
      },
    );
  }
}
