import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/constants/list_friend_constant_field.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/firebase_friend_list.dart';
import 'package:chatappforours/services/auth/models/friend_list.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:chatappforours/utilities/button/primary_button.dart';
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
  final FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
  late final FirebaseFriendList firebaseFriendList;
  String id = FirebaseAuth.instance.currentUser!.uid;
  late bool isActive;
  @override
  void initState() {
    firebaseFriendList = FirebaseFriendList();
    userPresenceDatabaseReference
        .child("${widget.friend.userID}/presence")
        .onValue
        .listen((event) {
      bool isOnline = event.snapshot.value as bool;
      isActive = isOnline;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MesssageScreen(chat: chat),
        //   ),
        // );
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
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: userProfile.urlImage!,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          if (userProfile.urlImage == null)
                            const CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/defaultImage.png"),
                            ),
                          if (isActive)
                            Positioned(
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
                        ],
                      ),
                      const SizedBox(width: kDefaultPadding * 0.25),
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
                return const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(),
                );
              default:
                return const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }
}
