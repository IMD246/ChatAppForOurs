import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/services/notification.dart/notification.dart';
import 'package:chatappforours/view/chat/addFriend/add_friend_screen.dart';
import 'package:chatappforours/view/chat/chatScreen/components/body_chat_screen.dart';
import 'package:chatappforours/view/chat/contacts/body_contact_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest.dart' as tz;

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.currentIndex,
    this.countFriend = 0,
  }) : super(key: key);
  final int currentIndex;
  final int countFriend;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late int currentIndex;
  final FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
  final FirebaseChatMessage firebaseChatMessage = FirebaseChatMessage();
  String ownerUserID = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    tz.initializeTimeZones();
    currentIndex = widget.currentIndex;
    setState(() {
      firebaseUserProfile.updateUserPresenceDisconnect(
        uid: ownerUserID,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    setState(
      () {
        if (widget.countFriend > 0) {
          NotificationService.fromSnapshot().initNotification();
          NotificationService().showNotification(
            1,
            context.loc.request_friend_notification_title,
            context.loc.request_friend_notification_body(widget.countFriend),
            3,
          );
        }
      },
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return FutureBuilder<UserProfile?>(
          future: firebaseUserProfile.getUserProfile(userID: ownerUserID),
          builder: (context, snapshot) {
            final userProfile = snapshot.data;
            if (snapshot.hasData) {
              return Scaffold(
                appBar: buildAppbar(
                  currentIndex,
                  ThemeMode.light,
                  context,
                  userProfile?.urlImage,
                ),
                body: currentIndex == 0
                    ? const BodyChatScreen()
                    : const BodyContactScreen(),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const AddFriendScreen();
                        },
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.person_add_alt_1,
                    color: Colors.white,
                  ),
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.light
                          ? kPrimaryColor
                          : Theme.of(context).scaffoldBackgroundColor,
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: currentIndex,
                  onTap: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.messenger),
                      label: context.loc.chat,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.people),
                      label: context.loc.contacts,
                    ),
                  ],
                ),
              );
            } else {
              return const Scaffold(
                body: Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  AppBar buildAppbar(int currentIndex, ThemeMode themeMode,
      BuildContext context, String? urlImage) {
    return AppBar(
      title: Row(
        children: [
          if (urlImage != null)
            GestureDetector(
              onTap: () {
                context.read<AuthBloc>().add(const AuthEventSetting());
              },
              child: CircleAvatar(
                backgroundColor: Colors.cyan[100],
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(60),
                    child: CachedNetworkImage(
                      imageUrl: urlImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
          if (urlImage == null)
            GestureDetector(
              onTap: () {
                context.read<AuthBloc>().add(const AuthEventSetting());
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/defaultImage.png"),
              ),
            ),
          const SizedBox(width: kDefaultPadding * 0.7),
          Text(
            currentIndex == 0 ? context.loc.chat : context.loc.contacts,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColorMode(themeMode).withOpacity(
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? 0.6
                    : 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
