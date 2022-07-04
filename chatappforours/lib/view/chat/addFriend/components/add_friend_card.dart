import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/crud/firebase_request_friend.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/crud/firebase_friend_list.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/services/notification/send_notification_message.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:flutter/material.dart';

class AddFriendCard extends StatefulWidget {
  const AddFriendCard({
    Key? key,
    required this.userProfile,
    required this.ownerUserProfile,
  }) : super(key: key);
  final UserProfile userProfile;
  final UserProfile ownerUserProfile;
  @override
  State<AddFriendCard> createState() => _AddFriendCardState();
}

class _AddFriendCardState extends State<AddFriendCard> {
  late final FirebaseUserProfile firebaseUserProfile;

  late final FirebaseFriendList firebaseFriendList;
  late final FirebaseRequestFriend firebaseRequestFriend;
  @override
  void initState() {
    firebaseFriendList = FirebaseFriendList();
    firebaseUserProfile = FirebaseUserProfile();
    firebaseRequestFriend = FirebaseRequestFriend();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<bool?>(
      future: firebaseFriendList.checkAddedUserYet(
          ownerUserID: widget.ownerUserProfile.idUser!,
          userID: widget.userProfile.idUser!),
      builder: (context, snapshot) {
        bool isAdded = snapshot.hasData ? snapshot.data! : true;
        return ListTile(
          leading: Stack(
            children: [
              if (widget.userProfile.urlImage.isNotEmpty)
                CircleAvatar(
                  backgroundColor: Colors.cyan[100],
                  radius: 20,
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(60),
                      child: CachedNetworkImage(
                        imageUrl: widget.userProfile.urlImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              if (widget.userProfile.urlImage.isEmpty)
                CircleAvatar(
                  backgroundColor: Colors.cyan[100],
                  backgroundImage: const AssetImage(
                    "assets/images/defaultImage.png",
                  ),
                ),
              if (widget.userProfile.presence)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 3,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            widget.userProfile.fullName,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: FillOutlineButton(
            minWidth: size.width * 0.2,
            press: () async {
              if (isAdded == false) {
                final notifcation = <String, dynamic>{
                  'title': context.loc.request_friend_notification_title,
                  'body': context.loc.request_friend_notification_body(
                    widget.userProfile.fullName,
                  ),
                };
                final urlImage = widget.ownerUserProfile.urlImage.isNotEmpty
                    ? widget.ownerUserProfile.urlImage
                    : "https://i.stack.imgur.com/l60Hf.png";
                if (widget.userProfile.idUser!
                        .compareTo(widget.ownerUserProfile.idUser!) !=
                    0) {
                  final Map<String, String> data = {
                    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                    'id': '1',
                    'messageType': TypeNotification.addFriend.toString(),
                    'status': 'done',
                    'image': urlImage,
                  };
                  await sendMessage(
                    notification: notifcation,
                    tokenUserFriend: widget.userProfile.tokenUser!,
                    data: data,
                    tokenOwnerUser: widget.ownerUserProfile.tokenUser!,
                  );
                }
                if (widget.ownerUserProfile.idUser! ==
                    widget.userProfile.idUser) {
                  await firebaseFriendList.createNewFriend(
                    ownerUserID: widget.ownerUserProfile.idUser!,
                    userIDFriend: widget.userProfile.idUser!,
                    isAccepted: true,
                  );
                } else {
                  await firebaseFriendList.createNewFriend(
                    ownerUserID: widget.ownerUserProfile.idUser!,
                    userIDFriend: widget.userProfile.idUser!,
                    isAccepted: false,
                  );
                  await firebaseRequestFriend.createNewRequestFriend(
                    ownerUserID: widget.userProfile.idUser!,
                    userIDFriend: widget.ownerUserProfile.idUser!,
                  );
                }
                setState(() {
                  isAdded = true;
                });
              }
            },
            text: isAdded ? context.loc.added : context.loc.add,
            isFilled: !isAdded,
            isCheckAdded: isAdded,
          ),
        );
      },
    );
  }
}
