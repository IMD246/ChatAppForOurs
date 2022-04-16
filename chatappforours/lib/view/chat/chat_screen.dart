import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppbar(currentIndex, ThemeMode.light,context),
          body: currentIndex == 0
              ? const BodyChatScreen()
              : const BodyContactScreen(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(
              Icons.person_add_alt_1,
              color: Colors.white,
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.light
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
      },
    );
  }

  AppBar buildAppbar(int currentIndex, ThemeMode themeMode,BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
             context.read<AuthBloc>().add(const AuthEventSetting());
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/user_2.png"),
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
