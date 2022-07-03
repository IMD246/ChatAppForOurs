import 'dart:async';

import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:chatappforours/view/chat/chatScreen/components/chat_list_view.dart';
import 'package:flutter/material.dart';

class BodyChatScreen extends StatefulWidget {
  const BodyChatScreen({Key? key, required this.ownerUserProfile})
      : super(key: key);
  final UserProfile ownerUserProfile;

  @override
  State<BodyChatScreen> createState() => _BodyChatScreenState();
}

class _BodyChatScreenState extends State<BodyChatScreen>
    with AutomaticKeepAliveClientMixin<BodyChatScreen> {
  bool isFilledRecent = true;
  bool isFilledActive = false;
  late final FirebaseChat firebaseChat;
  @override
  void initState() {
    super.initState();
    firebaseChat = FirebaseChat();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  // stream = firebaseChatDocs.getAllChat(ownerUserID: userID);
                });
              },
              child: StreamBuilder<Iterable<Future<Chat>>?>(
                stream: firebaseChat.getAllChat(
                  ownerUserProfile: widget.ownerUserProfile,
                  context: context,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final allChat = snapshot.data as Iterable<Future<Chat>>;
                    return ChatListView(
                      allChat: allChat,
                      isFilledActive: isFilledActive,
                      ownerUserProfile: widget.ownerUserProfile,
                    );
                  } else {
                    return Center(
                      child: Text(
                        context.loc.dont_have_any_chat,
                        style: const TextStyle(fontSize: 20),
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
