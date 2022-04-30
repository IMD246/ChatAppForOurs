import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/crud/firebase_users_join_chat.dart';
import 'package:chatappforours/services/auth/models/firebase_friend_list.dart';
import 'package:chatappforours/services/auth/models/friend_list.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:chatappforours/utilities/time_handle/handle_value.dart';
import 'package:chatappforours/view/chat/messageScreen/message_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatefulWidget {
  const ContactCard({
    Key? key,
    required this.friend,
    required this.requestFriend,
  }) : super(key: key);
  final FriendList friend;
  final bool requestFriend;
  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  final userPresenceDatabaseReference =
      FirebaseDatabase.instance.ref('userPresence');
  late final FirebaseUserProfile firebaseUserProfile;
  late final FirebaseChat firebaseChat;
  late final FirebaseFriendList firebaseFriendList;
  late final FirebaseUsersJoinChat firebaseUsersJoinChat;
  String id = FirebaseAuth.instance.currentUser!.uid;
  late final DateTime stampTime;

  @override
  void initState() {
    firebaseFriendList = FirebaseFriendList();
    firebaseUserProfile = FirebaseUserProfile();
    firebaseChat = FirebaseChat();
    firebaseUsersJoinChat = FirebaseUsersJoinChat();
    userPresenceDatabaseReference.child(widget.friend.userID).once().then(
      (event) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        bool isOnline = data['presence'];
        final stampTimeUser = DateTime.tryParse(data['stamp_time'])!;
        stampTime = stampTimeUser;
        final date = differenceInCalendarDays(stampTimeUser);
        setState(() {
          widget.friend.presence = isOnline;
          widget.friend.stampTimeUser = date;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!widget.requestFriend) {
          final userProfile = await firebaseUserProfile.getUserProfile(
              userID: widget.friend.userID);
          await firebaseChat.createChat(
            ownerUserID: id,
            userIDFriend: widget.friend.userID,
            nameChat: userProfile!.fullName,
            typeChat: TypeChat.normal,
          );
          final userJoinChat =
              await firebaseUsersJoinChat.getChatNormalByIDUser(
            userIDFriend: widget.friend.userID,
          );
          final chat = await firebaseChat.getChatByID(
            idChat: userJoinChat!.chatID,
          );
          chat.presence = widget.friend.presence;
          chat.stampTimeUserFormated = widget.friend.stampTimeUser;
          chat.userID = widget.friend.userID;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MesssageScreen(chat: chat),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 0.5,
          vertical: kDefaultPadding * 0.75,
        ),
        child: FutureBuilder<UserProfile?>(
          future:
              firebaseUserProfile.getUserProfile(userID: widget.friend.userID),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasData) {
                  final userProfile = snapshot.data;
                  return Row(
                    children: [
                      Stack(
                        children: [
                          if (userProfile!.urlImage != null)
                            CircleAvatar(
                              backgroundColor: Colors.cyan[100],
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: userProfile.urlImage!,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          if (userProfile.urlImage == null)
                            CircleAvatar(
                              backgroundColor: Colors.cyan[100],
                              backgroundImage: const AssetImage(
                                  "assets/images/defaultImage.png"),
                            ),
                          widget.friend.presence
                              ? Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 3,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ),
                                )
                              : Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Text(
                                    differenceInCalendarPresence(stampTime),
                                  ),
                                ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Text(
                          userProfile.fullName,
                          overflow: widget.requestFriend
                              ? TextOverflow.ellipsis
                              : null,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Visibility(
                        child: FillOutlineButton(
                          press: () async {
                            await firebaseFriendList.updateRequestFriend(
                              ownerUserID: id,
                              userID: widget.friend.userID,
                            );
                          },
                          text: 'Accept',
                        ),
                        visible: widget.requestFriend == true,
                      ),
                      const Spacer(),
                      Visibility(
                        child: FillOutlineButton(
                          press: () async {
                            await firebaseFriendList.deleteFriend(
                              ownerUserID: id,
                              userID: widget.friend.userID,
                            );
                          },
                          text: 'Cancel',
                        ),
                        visible: widget.requestFriend == true,
                      ),
                    ],
                  );
                } else {
                  return const Text('No Data Available');
                }
              case ConnectionState.waiting:
                return const Center(
                  child: SizedBox(
                    height: 25,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                );
              default:
                return const Center(
                  child: SizedBox(
                    height: 25,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
