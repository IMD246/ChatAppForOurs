import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';

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
    setState(() {
      firebaseUserProfile.updateUserPresence(uid: id, bool: true);
    });
    userPresenceDatabaseReference.child(widget.friend.userID).once().then(
      (event) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        bool isOnline = data['presence'];
        final stampTimeUser = DateTime.tryParse(data['stamp_time'])!;
        setState(() {
          widget.friend.presence = isOnline;
          stampTime = stampTimeUser;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return InkWell(
          onTap: () async {
            if (!widget.requestFriend) {
              final chat = await firebaseChat.getChatByListIDUser(
                listUserID: [id, widget.friend.userID],
              );
              if (chat != null) {
                chat.presence = widget.friend.presence;
                chat.stampTimeUser = stampTime;
                final userProfileFriend = await firebaseUserProfile
                    .getUserProfile(userID: widget.friend.userID);
                chat.nameChat = userProfileFriend!.fullName;
                 Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) {
                  return MesssageScreen(chat: chat, currentIndex: 1,);
                },
              ),
            );
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding * 0.5,
              vertical: kDefaultPadding * 0.75,
            ),
            child: FutureBuilder<UserProfile?>(
                future: firebaseUserProfile.getUserProfile(
                    userID: widget.friend.userID),
                builder: (context, snapshot) {
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
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(60),
                                    child: CachedNetworkImage(
                                      imageUrl: userProfile.urlImage!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
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
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                          ],
                        ),
                        Container(
                          width: size.width * 0.45,
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding / 2),
                          child: Text(
                            userProfile.fullName,
                            overflow: widget.requestFriend
                                ? TextOverflow.ellipsis
                                : null,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Visibility(
                          visible: widget.requestFriend,
                          child: Column(
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
                                  );
                                },
                                text: context.loc.accept,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: kDefaultPadding * 0.2),
                                child: FillOutlineButton(
                                  press: () async {
                                    await firebaseFriendList.deleteFriend(
                                      ownerUserID: id,
                                      userID: widget.friend.userID,
                                    );
                                  },
                                  text: context.loc.cancel,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        );
      },
    );
  }
}
