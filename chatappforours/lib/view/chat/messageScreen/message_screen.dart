import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/services/Theme/theme_changer.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
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
    required this.currentIndex,
  }) : super(key: key);
  final Chat chat;
  final int currentIndex;
  @override
  State<MesssageScreen> createState() => _MesssageScreenState();
}

class _MesssageScreenState extends State<MesssageScreen> {
  final FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
  String userOwnerID = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    firebaseUserProfile.updateUserPresence(
      uid: userOwnerID,
      bool: true,
    );
    super.initState();
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
    final String userIDFriend;
    if (chat.listUser[0] == ownerUserID) {
      userIDFriend = ownerUserID;
    } else {
      userIDFriend =
          (chat.listUser.where((element) => element != ownerUserID)).first;
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
                        widget.currentIndex == 0
                            ? context.read<AuthBloc>().add(
                                  const AuthEventGetOutChatFromBodyChatScreen(),
                                )
                            : context.read<AuthBloc>().add(
                                  const AuthEventGetOutChatFromBodyContactScreen(),
                                );
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
                              ? 'Online'
                              : 'Online ${chat.stampTimeUserFormated}',
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
