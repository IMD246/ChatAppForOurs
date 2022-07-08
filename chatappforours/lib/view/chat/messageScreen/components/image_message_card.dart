import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/chat_message.dart';
import 'package:chatappforours/view/chat/messageScreen/components/full_screen_image.dart';
import 'package:flutter/material.dart';

class ImageMessageCard extends StatelessWidget {
  const ImageMessageCard({
    Key? key,
    required this.urlImage,
    required this.chatMessage,
  }) : super(key: key);

  final String urlImage;
  final ChatMessage chatMessage;
  @override
  Widget build(BuildContext context) {
    final FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
    return GestureDetector(
      onTap: () async {
        final userProfile = await firebaseUserProfile.getUserProfile(
            userID: chatMessage.userID);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return FullScreenImage(
                urlImage: urlImage,
                fullName: userProfile!.fullName,
              );
            },
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: urlImage,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          colorBlendMode: BlendMode.softLight,
        ),
      ),
    );
  }
}
