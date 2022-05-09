import 'dart:async';

import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:chatappforours/view/chat/chatScreen/components/chat_list_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BodyChatScreen extends StatefulWidget {
  const BodyChatScreen({Key? key}) : super(key: key);

  @override
  State<BodyChatScreen> createState() => _BodyChatScreenState();
}

class _BodyChatScreenState extends State<BodyChatScreen> {
  List<Chat> listChatData = [];
  final FirebaseChat firebaseChatDocs = FirebaseChat();
  final String userID = FirebaseAuth.instance.currentUser!.uid;
  bool isFilledRecent = true;
  bool isFilledActive = false;
  late Stream<Iterable<Chat>?> stream;

  @override
  void initState() {
    setState(() {
      stream = firebaseChatDocs.getAllChat(ownerUserID: userID);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                text: context.loc.recent_message,
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
                text: context.loc.active,
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
                  stream = firebaseChatDocs.getAllChat(ownerUserID: userID);
                });
              },
              child: StreamBuilder(
                stream: stream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allChat = snapshot.data as Iterable<Chat>;
                        return ChatListView(
                          allChat: allChat,
                          isFilledActive: isFilledActive,
                        );
                      } else {
                        return Center(
                          child: Text(
                            context.loc.dont_have_any_chat,
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      }
                    default:
                      return SizedBox(
                        height: size.height * 0.2,
                        width: size.width * 0.2,
                        child: const Center(
                          child: CircularProgressIndicator(),
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
  }
}
