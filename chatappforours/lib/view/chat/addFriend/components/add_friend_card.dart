import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/firebase_friend_list.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/services/notification/send_notification_message.dart';
import 'package:chatappforours/services/notification/utils_download_file.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:flutter/material.dart';

class AddFriendCard extends StatefulWidget {
  const AddFriendCard({
    Key? key,
    required this.userProfile,
    required this.ownerUserProfile,
  }) : super(key: key);
  final Future<UserProfile> userProfile;
  final UserProfile ownerUserProfile;
  @override
  State<AddFriendCard> createState() => _AddFriendCardState();
}

class _AddFriendCardState extends State<AddFriendCard> {
  late final FirebaseUserProfile firebaseUserProfile;

  late final FirebaseFriendList firebaseFriendList;

  @override
  void initState() {
    firebaseFriendList = FirebaseFriendList();
    firebaseUserProfile = FirebaseUserProfile();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<UserProfile?>(
      future: widget.userProfile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userProfile = snapshot.data!;
          return FutureBuilder<String?>(
              future: firebaseFriendList.getIDFriendListDocument(
                ownerUserID: widget.ownerUserProfile.idUser!,
                userID: userProfile.idUser!,
              ),
              builder: (context, snapshot) {
                bool isAdded = snapshot.hasData ? true : false;
                return ListTile(
                  leading: Stack(
                    children: [
                      if (userProfile.urlImage.isNotEmpty)
                        CircleAvatar(
                          backgroundColor: Colors.cyan[100],
                          radius: 20,
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(60),
                              child: CachedNetworkImage(
                                imageUrl: userProfile.urlImage,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      if (userProfile.urlImage.isEmpty)
                        CircleAvatar(
                          backgroundColor: Colors.cyan[100],
                          backgroundImage: const AssetImage(
                            "assets/images/defaultImage.png",
                          ),
                        ),
                      if (userProfile.presence)
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
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    userProfile.fullName,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: FillOutlineButton(
                    minWidth: size.width * 0.2,
                    press: () async {
                      if (isAdded == false) {
                        final ownerUserProfile = widget.ownerUserProfile;
                        final notifcation = <String, dynamic>{
                          'title':
                              context.loc.request_friend_notification_title,
                          'body': context.loc.request_friend_notification_body(
                            userProfile.fullName,
                          ),
                        };
                        final urlImage = ownerUserProfile.urlImage.isNotEmpty
                            ? ownerUserProfile.urlImage
                            : "https://i.stack.imgur.com/l60Hf.png";
                        final largeIconPath =
                            await UtilsDownloadFile.downloadFile(
                          urlImage,
                          'largeIcon',
                        );
                        if (userProfile.idUser!
                                .compareTo(ownerUserProfile.idUser!) !=
                            0) {
                          final Map<String, String> data = {
                            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                            'id': '1',
                            'messageType':
                                TypeNotification.addFriend.toString(),
                            'status': 'done',
                            'image': largeIconPath,
                          };
                          await sendMessage(
                            notification: notifcation,
                            tokenUserFriend: userProfile.tokenUser!,
                            data: data,
                          );
                        }
                        setState(
                          () {
                            firebaseFriendList.createNewFriend(
                              ownerUserID: ownerUserProfile.idUser!,
                              userIDFriend: userProfile.idUser!,
                              isRequest: false,
                            );
                            firebaseFriendList.createNewFriend(
                              ownerUserID: userProfile.idUser!,
                              userIDFriend: ownerUserProfile.idUser!,
                              isRequest: false,
                            );
                          },
                        );
                      }
                    },
                    text: isAdded ? context.loc.added : context.loc.add,
                    isFilled: !isAdded,
                    isCheckAdded: isAdded,
                  ),
                );
              });
        } else {
          return const Text("");
        }
      },
    );
  }
}
