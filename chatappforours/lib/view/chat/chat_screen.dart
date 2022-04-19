import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/crud/user_profile.dart';
import 'package:chatappforours/view/chat/chatScreen/components/body_chat_screen.dart';
import 'package:chatappforours/view/chat/contacts/body_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int currentIndex = 0;
  late final FirebaseUserProfile userProfile;
  @override
  void initState() {
    userProfile = FirebaseUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return FutureBuilder<UserProfile?>(
          future: (state is AuthStateLoggedIn)
              ? userProfile.getUserProfile(userID: state.authUser.id!)
              : userProfile.getUserProfile(userID: null),
          builder: (context, snapshot) {
            final userProfile = snapshot.data;
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
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
                  onPressed: () {},
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
                child:
                    ClipOval(child: Image.network(urlImage, fit: BoxFit.cover)),
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
