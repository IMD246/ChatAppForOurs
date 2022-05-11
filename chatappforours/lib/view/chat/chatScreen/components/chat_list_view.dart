import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/crud/firebase_users_join_chat.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/view/chat/chatScreen/components/chat_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
  List<Chat> listChatData = [];
  late final FirebaseUsersJoinChat firebaseUsersJoinChat;
  late final FirebaseUserProfile firebaseUserProfile;
  late final FirebaseChat firebaseChat;
  late final FirebaseChatMessage firebaseChatMessage;
  String ownerUserID = FirebaseAuth.instance.currentUser!.uid;
  final userPresenceDatabaseReference =
      FirebaseDatabase.instance.ref('userPresence');
  Future<List<Chat>> getAllDataChat() async {
    listChatData.clear();
    for (var i = 0; i < widget.allChat.length; i++) {
      final chat = await firebaseChat.getChatByID(
          idChat: widget.allChat.elementAt(i).idChat, userChatID: ownerUserID);
      final userJoinChat = await firebaseUsersJoinChat.getUserJoinChatByIDChat(
        idChat: chat.idChat,
        ownerUserID: ownerUserID,
      );
      late final String userIDFriend;
      if (chat.listUser[0] == chat.listUser[1]) {
        userIDFriend = chat.listUser.elementAt(0);
        chat.listUser.removeAt(1);
      } else {
        chat.listUser.remove(ownerUserID);
        userIDFriend = chat.listUser.first;
      }
      final userProfile = await firebaseUserProfile.getUserProfile(
        userID: userIDFriend,
      );
      if (chat.typeChat == TypeChat.normal) {
        chat.urlUserFriend = userProfile?.urlImage;
        if (chat.listUser.first != ownerUserID) {
          chat.nameChat = userProfile!.fullName;
        }
      }
      await userPresenceDatabaseReference.child(userIDFriend).once().then(
        (event) async {
          final userProfile = await firebaseUserProfile.getUserProfile(
            userID: userIDFriend,
          );
          if (chat.typeChat == TypeChat.normal) {
            chat.urlUserFriend = userProfile?.urlImage;
            if (chat.listUser.length > 1) {
              chat.nameChat = userProfile!.fullName;
            }
          }
          chat.rule = userJoinChat!.ruleChat;
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          chat.presence = data['presence'];
          chat.stampTimeUser = DateTime.tryParse(data['stamp_time'])!;
          listChatData.add(chat);
        },
      );
    }
    return listChatData;
  }

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
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<Chat>>(
      future: getAllDataChat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final list = snapshot.data!;
          final listFilter = widget.isFilledActive
              ? list.where((element) => element.presence == true).toList()
              : list;
          return ListView.builder(
            itemCount: listFilter.length,
            itemBuilder: (context, index) {
              return ChatCard(
                chat: listFilter.elementAt(index),
              );
            },
          );
        } else {
          return SizedBox(
            height: size.height * 0.45,
            width: size.width * 0.45,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
