import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/utilities/handle/handle_value.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/constants.dart';

class ChatCard extends StatefulWidget {
  const ChatCard({
    Key? key,
    required this.chat,
  }) : super(key: key);
  final Chat chat;

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  late final FirebaseChat firebaseChat;
  late final FirebaseChatMessage firebaseChatMessage;
  String userOwnerID = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    firebaseChat = FirebaseChat();
    firebaseChatMessage = FirebaseChatMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUserProfile = FirebaseUserProfile();
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return InkWell(
          onTap: () async {
            final userProfile = await firebaseUserProfile.getUserProfile(
                userID: widget.chat.listUser.first);
            widget.chat.nameChat = userProfile!.fullName;
            context.read<AuthBloc>().add(
                  AuthEventGetInChatFromBodyChatScreen(
                    chat: widget.chat,
                    currentIndex: 0,
                  ),
                );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding * 0.75,
            ),
            child: Row(
              children: [
                FutureBuilder<UserProfile?>(
                  future: firebaseUserProfile.getUserProfile(
                      userID: widget.chat.listUser.first),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userProfile = snapshot.data;
                      return Stack(
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
                          if (widget.chat.presence == true)
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
                          if (widget.chat.presence == false)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Text(
                                differenceInCalendarPresence(
                                    widget.chat.stampTimeUser!),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
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
                          handleNameChat(userOwnerID,
                              widget.chat.listUser.first, widget.chat, context),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Opacity(
                          opacity: 0.64,
                          child: Text(
                            getStringMessageByTypeMessage(
                              typeMessage: widget.chat.typeMessage,
                              value: widget.chat.lastText,
                              context: context,
                            ),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.64,
                  child: Text(
                    differenceInCalendarDaysLocalization(
                        widget.chat.stampTime, context),
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
