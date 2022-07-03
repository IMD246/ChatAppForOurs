import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/crud/firebase_users_join_chat.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/view/chat/chatScreen/components/chat_card.dart';
import 'package:flutter/material.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({
    Key? key,
    required this.allChat,
    required this.isFilledActive,
    required this.ownerUserProfile,
  }) : super(key: key);
  final Iterable<Future<Chat>> allChat;
  final bool isFilledActive;
  final UserProfile ownerUserProfile;
  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  List<Chat> listChatData = [];
  late final FirebaseUsersJoinChat firebaseUsersJoinChat;
  late final FirebaseUserProfile firebaseUserProfile;
  late final FirebaseChat firebaseChat;
  late final FirebaseChatMessage firebaseChatMessage;

  @override
  void initState() {
    firebaseUsersJoinChat = FirebaseUsersJoinChat();
    firebaseUserProfile = FirebaseUserProfile();
    firebaseChat = FirebaseChat();
    listChatData.clear();
    firebaseChatMessage = FirebaseChatMessage();
    super.initState();
  }

  @override
  void dispose() {
    listChatData.clear();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    listChatData.clear();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.allChat.length,
      itemBuilder: (context, index) {
        return ChatCard(
          chat: widget.allChat.elementAt(index),
          ownerUserProfile: widget.ownerUserProfile, isFillActive: widget.isFilledActive,
        );
      },
    );
  }
}
