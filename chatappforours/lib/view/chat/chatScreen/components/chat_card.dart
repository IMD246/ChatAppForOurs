import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key? key,
    required this.chat,
    required this.press,
  }) : super(key: key);
  final Chat chat;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    final firebaseUserProfile = FirebaseUserProfile();
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding * 0.75,
        ),
        child: Row(
          children: [
            FutureBuilder<UserProfile?>(
              future: firebaseUserProfile.getUserProfile(userID: chat.userID),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      final userProfile = snapshot.data;
                      return Stack(
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
                          if (chat.presence == true)
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
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    } else {
                      return const Text(
                        "Let make some friend and chat",
                      );
                    }
                  case ConnectionState.waiting:
                    return const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    );
                }
              },
            ),
            const SizedBox(width: kDefaultPadding / 2),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.nameChat,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        chat.lastText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(chat.stampTime),
            ),
          ],
        ),
      ),
    );
  }
}
