import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/utilities/dialogs/error_dialog.dart';
import 'package:chatappforours/view/chat/chatScreen/components/body_chat_screen.dart';
import 'package:chatappforours/view/chat/contacts/body_contact_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int currentIndex = 0;
  late final FirebaseUserProfile firebaseUserProfile;
  @override
  void initState() {
    firebaseUserProfile = FirebaseUserProfile();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return FutureBuilder<UserProfile?>(
          future: (state is AuthStateLoggedIn)
              ? firebaseUserProfile.getUserProfile(userID: state.authUser.id!)
              : firebaseUserProfile.getUserProfile(userID: null),
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
                  onPressed: () async {
                    final DatabaseReference userPresenceDatabaseReference =
                        FirebaseDatabase.instance.ref('userPresence');
                    final uid = FirebaseAuth.instance.currentUser!.uid;
                    userPresenceDatabaseReference
                        .child("$uid/presence")
                        .onValue
                        .listen((event) {
                      bool isOnline = event.snapshot.value as bool;
                      showErrorDialog(
                        context: context,
                        text: "check: $isOnline",
                        title: "check",
                      );
                    });
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
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.messenger),
                      label: "Chat",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.people),
                      label: "People",
                    ),
                  ],
                ),
              );
            } else {
              return const Scaffold(
                body: Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
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
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: urlImage,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
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
            currentIndex == 0 ? 'Chat' : 'Contacts',
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
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
}
