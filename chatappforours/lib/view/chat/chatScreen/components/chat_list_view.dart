import 'dart:async';

import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/crud/firebase_users_join_chat.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/utilities/handle/handle_value.dart';
import 'package:chatappforours/view/chat/chatScreen/components/chat_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    _streamController.onPause;
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
        chat.listUser.remove(ownerUserID);
        userIDFriend = chat.listUser.first;
      }
      userPresenceDatabaseReference.child(userIDFriend).once().then(
        (event) async {
          final userProfile = await firebaseUserProfile.getUserProfile(
            userID: userIDFriend,
          );
          if (chat.typeChat == TypeChat.normal) {
            chat.urlUserFriend = userProfile?.urlImage;
            if (chat.listUser.length <= 1 && chat.listUser[0] == ownerUserID) {
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
          _streamController.onResume;
        },
      );
    }
  }

  getAllDataChatOnline({required Iterable<Chat> list}) async {
    listChatData.clear();
    _streamController.onPause;
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
        chat.listUser.remove(ownerUserID);
        userIDFriend = chat.listUser.first;
      }
      userPresenceDatabaseReference.child(userIDFriend).once().then(
        (event) async {
          final userProfile = await firebaseUserProfile.getUserProfile(
            userID: userIDFriend,
          );
          if (chat.typeChat == TypeChat.normal) {
            chat.urlUserFriend = userProfile?.urlImage;
            if (chat.listUser.length <= 1 && chat.listUser[0] == ownerUserID) {
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
          if (isOnline == true) {
            listChatData.add(chat);
            _streamController.sink.add(listChatData);
            _streamController.onResume;
          }
        },
      );
    }
  }

  @override
  void initState() {
    firebaseUsersJoinChat = FirebaseUsersJoinChat();
    firebaseUserProfile = FirebaseUserProfile();
    firebaseChat = FirebaseChat();
    firebaseChatMessage = FirebaseChatMessage();

    super.initState();
  }

  @override
  void dispose() {
    listChatData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return FutureBuilder(
          future: !widget.isFilledActive
              ? getAllDataChat(list: widget.allChat)
              : getAllDataChatOnline(list: widget.allChat),
          builder: (context, snapshot) {
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
                          context.read<AuthBloc>().add(
                                AuthEventGetInChatFromBodyChatScreen(
                                  chat: chatData,
                                  currentIndex: 0,
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
          },
        );
      },
    );
  }
}
