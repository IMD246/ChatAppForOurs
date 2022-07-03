import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/crud/user_presence_field.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/services/notification/notification.dart';
import 'package:chatappforours/view/chat/addFriend/add_friend_screen.dart';
import 'package:chatappforours/view/chat/chatScreen/components/body_chat_screen.dart';
import 'package:chatappforours/view/chat/contacts/body_contact_screen.dart';
import 'package:chatappforours/view/chat/messageScreen/message_screen.dart';
import 'package:chatappforours/view/chat/settings/setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest.dart' as tz;

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.countFriend,
    required this.userProfile,
  }) : super(key: key);
  final int countFriend;
  final UserProfile userProfile;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int currentIndex = 0;
  final FirebaseUserProfile firebaseUserProfile = FirebaseUserProfile();
  final FirebaseChat firebaseChat = FirebaseChat();
  final userPresenceDatabaseReference =
      FirebaseDatabase.instance.ref('userPresence');
  String ownerUserID = FirebaseAuth.instance.currentUser!.uid;
  late final PageController pageController;
  @override
  void initState() {
    FirebaseMessaging.instance.requestPermission();
    pageController = PageController(initialPage: currentIndex);
    firebaseUserProfile.updateUserPresenceDisconnect(uid: ownerUserID);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    tz.initializeTimeZones();
    final noti = NotificationService();
    noti.initNotification();
    FirebaseMessaging.onMessage.listen(
      (event) async {
        if (event.notification != null && event.data.isNotEmpty) {
          if (event.data['messageType'] ==
              TypeNotification.addFriend.toString()) {
            noti.showNotification(
              id: 1,
              title: event.notification!.title!,
              body: event.notification!.body!,
              urlImage: event.data['image'],
            );
          } else if (event.data['messageType'] ==
              TypeNotification.acceptFriend.toString()) {
            noti.showNotification(
              id: 1,
              title: event.notification!.title!,
              body: event.notification!.body!,
              urlImage: event.data['image'],
            );
          } else {
            noti.showNotification(
              id: 1,
              title: event.notification!.title!,
              body: event.notification!.body!,
              urlImage: event.data['image'],
            );
          }
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) async {
        if (event.data['messageType'] ==
            TypeNotification.addFriend.toString()) {
          await noti.showNotification(
            id: 1,
            title: context.loc.request_friend_notification_title,
            body: context.loc.request_friend_notification_body(
              event.notification!.body!,
            ),
            urlImage: event.data['image'],
          );
        } else if (event.data['messageType'] ==
            TypeNotification.acceptFriend.toString()) {
          noti.showNotification(
            id: 1,
            title: event.notification!.title!,
            body: event.notification!.body!,
            urlImage: event.data['image'],
          );
        } else {
          Map<String, dynamic> temp = jsonDecode(event.data['chat']);
          final chat = await firebaseChat.getChatByID(
            idChat: temp['idChat'],
            userChatID: event.data['sendById'],
          );
          chat.nameChat = event.data['sendBy'];
          chat.presenceUserChat = temp[presenceField];
          chat.stampTimeUser = DateTime.parse(temp['stampTimeUser']);
          chat.listUser.remove(event.data['sendById']);
          await noti.showNotification(
            id: 1,
            title: event.notification!.title!,
            body: event.notification!.body!,
            urlImage: event.data['image'],
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) {
                return MesssageScreen(
                  chat: chat,
                  ownerUserProfile: widget.userProfile,
                );
              },
            ),
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
            if (snapshot.hasData) {
              final userProfile = snapshot.data;
              return Scaffold(
                appBar: buildAppbar(
                  currentIndex,
                  ThemeMode.light,
                  context,
                  userProfile?.urlImage,
                ),
                body: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: [
                    BodyChatScreen(
                      ownerUserProfile: widget.userProfile,
                    ),
                    BodyContactScreen(
                      ownerUserProfile: widget.userProfile,
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return AddFriendScreen(ownerUserProfile: widget.userProfile,);
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
                    if (currentIndex != index) {
                      setState(
                        () {
                          currentIndex = index;
                          pageController.jumpToPage(index);
                        },
                      );
                    }
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
              return const Scaffold();
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return const SettingScreen();
                    },
                  ),
                );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return const SettingScreen();
                  }),
                );
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
