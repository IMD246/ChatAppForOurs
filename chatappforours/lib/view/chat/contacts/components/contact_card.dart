import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_presence.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/crud/firebase_friend_list.dart';
import 'package:chatappforours/services/auth/models/friend.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/utilities/handle/handle_value.dart';
import 'package:chatappforours/view/chat/messageScreen/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactCard extends StatefulWidget {
  const ContactCard({
    Key? key,
    required this.friend,
    required this.ownerUserProfile,
  }) : super(key: key);
  final Friend friend;
  final UserProfile ownerUserProfile;
  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  late final FirebaseUserProfile firebaseUserProfile;
  late final FirebaseChat firebaseChat;
  late final FirebaseUserPresence firebaseUserPresence;
  late final FirebaseFriendList firebaseFriendList;
  @override
  void initState() {
    firebaseUserProfile = FirebaseUserProfile();
    firebaseChat = FirebaseChat();
    firebaseUserPresence = FirebaseUserPresence();
    firebaseFriendList = FirebaseFriendList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return FutureBuilder<UserProfile?>(
          future: firebaseUserProfile.getUserProfile(
            userID: widget.friend.userID,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userProfileFriend = snapshot.data!;
              return InkWell(
                onTap: () async {
                  final chat = await firebaseChat.getChatByListIDUser(
                    listUserID: [
                      widget.ownerUserProfile.idUser!,
                      widget.friend.userID
                    ],
                  );
                  if (chat != null) {
                    chat.presenceUserChat = userProfileFriend.presence;
                    chat.stampTimeUser = userProfileFriend.stampTime;
                    chat.urlImage = userProfileFriend.urlImage;
                    chat.nameChat = userProfileFriend.fullName;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) {
                          return MesssageScreen(
                            chat: chat,
                            ownerUserProfile: widget.ownerUserProfile,
                          );
                        },
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding * 0.5,
                    vertical: kDefaultPadding * 0.75,
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          if (userProfileFriend.urlImage.isNotEmpty)
                            CircleAvatar(
                              backgroundColor: Colors.cyan[100],
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(60),
                                  child: CachedNetworkImage(
                                    imageUrl: userProfileFriend.urlImage,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            )
                          else
                            CircleAvatar(
                              backgroundColor: Colors.cyan[100],
                              backgroundImage: const AssetImage(
                                "assets/images/defaultImage.png",
                              ),
                            ),
                          if (userProfileFriend.presence)
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
                          else
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Text(
                                differenceInCalendarPresence(
                                  userProfileFriend.stampTime,
                                ),
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
                          userProfileFriend.fullName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              );
            } else {
              return const Text("");
            }
          },
        );
      },
    );
  }
}
