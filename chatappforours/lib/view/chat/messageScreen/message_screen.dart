import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/services/Theme/theme_changer.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/view/chat/messageScreen/components/body_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';

class MesssageScreen extends StatelessWidget {
  const MesssageScreen(
      {Key? key, required this.chat,})
      : super(key: key);
  final Chat chat;
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeChanger>(context).getTheme();
    return Scaffold(
      appBar: buildAppbar(
          chat, isDarkTheme ? ThemeMode.dark : ThemeMode.light, context),
      body: BodyMessage(
        chat: chat,
      ),
    );
  }
  AppBar buildAppbar(Chat chat, ThemeMode themeMode, BuildContext context) {
    final FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
    return AppBar(
      automaticallyImplyLeading: true,
      title: FutureBuilder<UserProfile?>(
        future: firebaseUserProfile.getUserProfile(userID: chat.userID),
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
                                imageUrl: userProfile.urlImage!,
                                fit: BoxFit.fill,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        if (userProfile.urlImage == null)
                          const CircleAvatar(
                            backgroundImage: AssetImage(
                              "assets/images/defaultImage.png",
                            ),
                          ),
                        if (chat.presence == true)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 16,
                              width: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kPrimaryColor,
                                border: Border.all(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: kDefaultPadding * 0.75),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.nameChat,
                          style: TextStyle(
                              color: textColorMode(themeMode).withOpacity(0.8),
                              fontSize: 16),
                        ),
                        Text(
                          chat.presence!
                              ? 'Online'
                              : 'Online ${chat.stampTimeUser}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(
                              themeMode == ThemeMode.light ? 0.4 : 0.6,
                            ),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return const Text('Waiting...');
              }
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
