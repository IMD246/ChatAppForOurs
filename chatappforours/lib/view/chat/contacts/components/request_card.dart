import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/crud/firebase_request_friend.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_presence.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/crud/firebase_friend_list.dart';
import 'package:chatappforours/services/auth/models/request_friend.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/services/notification/send_notification_message.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:chatappforours/utilities/handle/handle_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestCard extends StatefulWidget {
  const RequestCard({
    Key? key,
    required this.requestFriend,
    required this.ownerUserProfile,
  }) : super(key: key);
  final RequestFriend requestFriend;
  final UserProfile ownerUserProfile;
  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  late final FirebaseUserProfile firebaseUserProfile;
  late final FirebaseChat firebaseChat;
  late final FirebaseUserPresence firebaseUserPresence;
  late final FirebaseRequestFriend firebaseRequestFriend;
  late final FirebaseFriendList firebaseFriendList;
  @override
  void initState() {
    firebaseUserProfile = FirebaseUserProfile();
    firebaseChat = FirebaseChat();
    firebaseUserPresence = FirebaseUserPresence();
    firebaseRequestFriend = FirebaseRequestFriend();
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
            userID: widget.requestFriend.userID,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userProfileFriend = snapshot.data!;
              return Padding(
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
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FillOutlineButton(
                          press: () async {
                            final userProfile = widget.ownerUserProfile;
                            final Map<String, dynamic> notification = {
                              'title':
                                  context.loc.accept_friend_notification_title,
                              'body': context.loc
                                  .accept_friend_notification_body(
                                      userProfile.fullName),
                            };
                            final urlImage = userProfile.urlImage.isEmpty
                                ? userProfile.urlImage
                                : "https://i.stack.imgur.com/l60Hf.png";
                            if (widget.requestFriend.userID
                                    .compareTo(userProfile.idUser!) !=
                                0) {
                              final Map<String, String> data = {
                                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                'id': '1',
                                'messageType':
                                    TypeNotification.acceptFriend.toString(),
                                'image': urlImage,
                                'status': 'done',
                              };
                              await sendMessage(
                                notification: notification,
                                tokenUserFriend: userProfileFriend.tokenUser!,
                                data: data,
                                tokenOwnerUser:
                                    widget.ownerUserProfile.tokenUser!,
                              );
                              await firebaseFriendList.createNewFriend(
                                ownerUserID: userProfile.idUser!,
                                userIDFriend: widget.requestFriend.userID,
                                isAccepted: true,
                              );
                              await firebaseFriendList.updateAcceptedFriend(
                                ownerUserID: widget.requestFriend.userID,
                                userIDFriend: userProfile.idUser!,
                                isAccepted: true
                              );
                              await firebaseRequestFriend.deleteRequestFriend(
                                ownerUserID: widget.ownerUserProfile.idUser!,
                                idUserRequestFriend:
                                    widget.requestFriend.userID,
                              );
                            }
                          },
                          text: context.loc.accept,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: kDefaultPadding * 0.2),
                          child: FillOutlineButton(
                            press: () async {
                              await firebaseRequestFriend.deleteRequestFriend(
                                ownerUserID: widget.ownerUserProfile.idUser!,
                                idUserRequestFriend:
                                    widget.requestFriend.userID,
                              );
                            },
                            text: context.loc.refuse,
                          ),
                        ),
                      ],
                    ),
                  ],
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
