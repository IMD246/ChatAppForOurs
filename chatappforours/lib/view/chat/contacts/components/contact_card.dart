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
import 'package:chatappforours/utilities/handle/handle_value.dart';
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
  DateTime? stampTime;

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
        final date = differenceInCalendarDays(stampTimeUser);
        setState(() {
          widget.friend.presence = isOnline;
          widget.friend.stampTimeUser = date;
          stampTime = stampTimeUser;
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
          final chat = await firebaseChat.getChatByListIDUser(
            listUserID: [id, widget.friend.userID],
          );
          if (chat!.isActive == false) {
            await firebaseChat.updateChatToActive(
              listUserID: [id, widget.friend.userID],
            );
          }
          chat.presence = widget.friend.presence;
          chat.stampTimeUserFormated = widget.friend.stampTimeUser;
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
                                  fit: BoxFit.cover,
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
                                "assets/images/defaultImage.png",
                              ),
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
                                    stampTime != null
                                        ? differenceInCalendarPresence(
                                            stampTime!,
                                          )
                                        : "",
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
                      const Spacer(),
                      Visibility(
                        visible: widget.requestFriend == true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FillOutlineButton(
                              press: () async {
                                await firebaseFriendList.updateRequestFriend(
                                  ownerUserID: id,
                                  userID: widget.friend.userID,
                                );
                                await firebaseChat.createChat(
                                  typeChat: TypeChat.normal,
                                  listUserID: [id, widget.friend.userID],
                                  idFriendList: widget.friend.idFriendList,
                                );
                              },
                              text: 'Accept',
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            FillOutlineButton(
                              press: () async {
                                await firebaseFriendList.deleteFriend(
                                  ownerUserID: id,
                                  userID: widget.friend.userID,
                                );
                              },
                              text: 'Cancel',
                            ),
                          ],
                        ),
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
