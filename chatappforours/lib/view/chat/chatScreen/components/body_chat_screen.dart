import 'dart:async';

import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
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
  late final StreamController streamController;
  late final bool isActive;
  late Stream<Iterable<Chat?>> stream;
  @override
  void initState() {
    streamController = StreamController();
    firebaseUsersJoinChat = FirebaseUsersJoinChat();
    setState(() {
      firebaseChat = FirebaseChat();
      stream = firebaseChat.getAllChat(ownerUserID: userID);
    });
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
          child: Center(
            child: RefreshIndicator(
              strokeWidth: 1,
              onRefresh: () async {
                setState(() {
                  stream = firebaseChat.getAllChat(ownerUserID: userID);
                });
              },
              child: StreamBuilder(
                  stream: stream,
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
  late final FirebaseChat firebaseChat;
  late final FirebaseChatMessage firebaseChatMessage;
  String ownerUserID = FirebaseAuth.instance.currentUser!.uid;
  final userPresenceDatabaseReference =
      FirebaseDatabase.instance.ref('userPresence');

  getAllDataChat({required Iterable<Chat> list}) async {
    listChatData.clear();
    for (var i = 0; i < list.length; i++) {
      final chat = await firebaseChat.getChatByID(
          idChat: list.elementAt(i).idChat, userChatID: ownerUserID);
      final userJoinChat = await firebaseUsersJoinChat.getUserJoinChatByIDChat(
        idChat: chat.idChat,
        ownerUserID: ownerUserID,
      );
      final String userIDFriend;
      if (chat.listUser[0] == chat.listUser[1]) {
        userIDFriend = chat.listUser.elementAt(0);
      } else {
        userIDFriend =
            chat.listUser.where((element) => element != ownerUserID).first;
      }
      userPresenceDatabaseReference.child(userIDFriend).once().then(
        (event) async {
          final userProfile = await firebaseUserProfile.getUserProfile(
            userID: userIDFriend,
          );
          if (chat.typeChat == TypeChat.normal) {
            chat.urlUserFriend = userProfile?.urlImage;
            if (chat.listUser.length <= 1) {
              chat.nameChat = 'Only You';
            } else {
              chat.nameChat = userProfile!.fullName;
            }
          }
          chat.rule = userJoinChat!.ruleChat;
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          final isOnline = data['presence'];
          final stampTimeUser = DateTime.tryParse(data['stamp_time'])!;
          final date = differenceInCalendarDays(stampTimeUser);
          chat.stampTimeUser = stampTimeUser;
          chat.stampTimeUserFormated = date;
          chat.presence = isOnline;
          listChatData.add(chat);
          _streamController.sink.add(listChatData);
        },
      );
    }
  }

  getAllDataChatOnline({required Iterable<Chat> list}) async {
    listChatData.clear();
    for (var i = 0; i < list.length; i++) {
      final chat = await firebaseChat.getChatByID(
          idChat: list.elementAt(i).idChat, userChatID: ownerUserID);
      final userJoinChat = await firebaseUsersJoinChat.getUserJoinChatByIDChat(
        idChat: list.elementAt(i).idChat,
        ownerUserID: ownerUserID,
      );
      final String userIDFriend;
      if (chat.listUser[0] == chat.listUser[1]) {
        userIDFriend = chat.listUser.elementAt(0);
      } else {
        userIDFriend =
            chat.listUser.where((element) => element != ownerUserID).first;
      }
      userPresenceDatabaseReference.child(userIDFriend).once().then(
        (event) async {
          final userProfile = await firebaseUserProfile.getUserProfile(
            userID: userIDFriend,
          );
          if (chat.typeChat == TypeChat.normal) {
            chat.urlUserFriend = userProfile?.urlImage;
            if (chat.listUser.length <= 1) {
              chat.nameChat = 'Only You';
            } else {
              chat.nameChat = userProfile!.fullName;
            }
          }
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          chat.rule = userJoinChat!.ruleChat;
          final isOnline = data['presence'];
          final stampTimeUser = DateTime.tryParse(data['stamp_time'])!;
          final date = differenceInCalendarDays(stampTimeUser);
          chat.stampTimeUser = stampTimeUser;
          chat.stampTimeUserFormated = date;
          chat.presence = isOnline;
          listChatData.add(list.elementAt(i));
        },
      );
      _streamController.sink.add(listChatData);
    }
  }

  @override
  void initState() {
    firebaseUsersJoinChat = FirebaseUsersJoinChat();
    firebaseUserProfile = FirebaseUserProfile();
    firebaseChat = FirebaseChat();
    firebaseChatMessage = FirebaseChatMessage();
    setState(() {
      if (widget.isFilledActive == false) {
        getAllDataChat(list: widget.allChat);
      } else {
        getAllDataChatOnline(list: widget.allChat);
      }
    });
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
                press: () {
                  final chatData = allChatCard.elementAt(index);
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
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
