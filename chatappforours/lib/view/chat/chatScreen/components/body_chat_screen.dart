import 'dart:async';

import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/crud/firebase_users_join_chat.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:chatappforours/view/chat/chatScreen/components/chat_list_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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
  late final FirebaseUserProfile firebaseUserProfile;
  late final bool isActive;
  late Stream<Iterable<Chat?>> stream;
  @override
  void initState() {
    streamController = StreamController();
    firebaseUserProfile = FirebaseUserProfile();
    firebaseUsersJoinChat = FirebaseUsersJoinChat();
    firebaseChat = FirebaseChat();
    setState(() {
      stream = firebaseChat.getAllChat(ownerUserID: userID);
      firebaseUserProfile.updateUserPresence(
        uid: userID,
        bool: true,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
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
                    isFilled: !isFilledActive,
                    press: () {
                      if (isFilledActive == true) {
                        setState(
                          () {
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
                        setState(
                          () {
                            isFilledActive = true;
                          },
                        );
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
                    setState(() async {
                      await firebaseUserProfile.updateUserPresence(
                        uid: userID,
                        bool: true,
                      );
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
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

