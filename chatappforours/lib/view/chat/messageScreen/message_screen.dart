import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/Theme/theme_changer.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/utilities/handle/handle_value.dart';
import 'package:chatappforours/view/chat/messageScreen/components/body_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';

class MesssageScreen extends StatefulWidget {
  const MesssageScreen({
    Key? key,
    required this.chat,
  }) : super(key: key);
  final Chat chat;
  @override
  State<MesssageScreen> createState() => _MesssageScreenState();
}

class _MesssageScreenState extends State<MesssageScreen> {
  final FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
  final FirebaseChatMessage firebaseChatMessage = FirebaseChatMessage();
  String userOwnerID = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firebaseChatMessage.deleteMessageNotSent(
      ownerUserID: userOwnerID,
      chatID: widget.chat.idChat,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeChanger>(context).getTheme();
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppbar(widget.chat,
              isDarkTheme ? ThemeMode.dark : ThemeMode.light, context),
          body: BodyMessage(
            chat: widget.chat,
          ),
        );
      },
    );
  }

  AppBar buildAppbar(Chat chat, ThemeMode themeMode, BuildContext context) {
    final FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
    final String ownerUserID = FirebaseAuth.instance.currentUser!.uid;
    final String? userIDFriend;

    if (chat.listUser.length > 1 && chat.listUser[0] == chat.listUser[1]) {
      chat.listUser.removeAt(1);
      userIDFriend = chat.listUser.first;
    } else if (chat.listUser.length > 1 &&
        chat.listUser[0] != chat.listUser[1]) {
      chat.listUser.remove(ownerUserID);
      userIDFriend = chat.listUser.first;
    } else {
      userIDFriend = chat.listUser.first;
    }

    return AppBar(
      automaticallyImplyLeading: false,
      title: FutureBuilder<UserProfile?>(
        future: firebaseUserProfile.getUserProfile(userID: userIDFriend),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                final userProfile = snapshot.data;
                return Row(
                  children: [
                    BackButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
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
                          chat.nameChat ?? "as",
                          style: TextStyle(
                              color: textColorMode(themeMode).withOpacity(0.8),
                              fontSize: 16),
                        ),
                        Text(
                          chat.presence!
                              ? context.loc.online
                              : '${context.loc.online} ${differenceInCalendarDaysLocalization(widget.chat.stampTimeUser!, context)}',
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
                return Text(context.loc.waiting);
              }
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
