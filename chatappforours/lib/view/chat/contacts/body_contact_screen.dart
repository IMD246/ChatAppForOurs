import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/firebase_friend_list.dart';
import 'package:chatappforours/services/auth/models/friend_list.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:chatappforours/view/chat/contacts/components/contact_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BodyContactScreen extends StatefulWidget {
  const BodyContactScreen({Key? key}) : super(key: key);

  @override
  State<BodyContactScreen> createState() => _BodyContactScreenState();
}

class _BodyContactScreenState extends State<BodyContactScreen> {
  List<Chat> listChatData = [];
  bool isFilledRecent = true;
  bool isFilledActive = false;
  // void getAllData() {
  //   listChatData.clear();
  //   listChatData.addAll(chatsData);
  // }

  // Future<void> getData() async {
  //   listChatData.clear();
  //   for (var i = 0; i < chatsData.length; i++) {
  //     await chatsData[i].isActive ? listChatData.add(chatsData[i]) : null;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // getAllData();
  }

  @override
  void dispose() {
    super.dispose();
    listChatData.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
            kDefaultPadding,
            0,
            kDefaultPadding,
            kDefaultPadding,
          ),
          color: kPrimaryColor,
          child: Row(
            children: [
              FillOutlineButton(
                isFilled: isFilledRecent,
                press: () {
                  if (isFilledActive == true) {
                    setState(
                      () {
                        isFilledRecent = true;
                        isFilledActive = false;
                      },
                    );
                  }
                },
                text: "Recent Contact",
              ),
              const SizedBox(width: kDefaultPadding * 0.7),
              FillOutlineButton(
                press: () {
                  if (isFilledActive == false) {
                    setState(() {
                      isFilledRecent = false;
                      isFilledActive = true;
                    });
                  }
                },
                text: "Active",
                isFilled: isFilledActive,
              ),
            ],
          ),
        ),
        const ContactListView(),
      ],
    );
  }
}

class ContactListView extends StatefulWidget {
  const ContactListView({
    Key? key,
  }) : super(key: key);

  @override
  State<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView> {
  late final FirebaseFriendList firebaseFriendList = FirebaseFriendList();
  String id = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: firebaseFriendList.getAllFriendIsOnlined(ownerUserID: id),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              if (snapshot.hasData) {
                final listFriend = snapshot.data as Iterable<FriendList>;
                return ListView.builder(
                  itemCount: listFriend.length,
                  itemBuilder: (context, index) {
                    return ContactCard(
                      friend: listFriend.elementAt(index),
                    );
                  },
                );
              } else {
                return const Text("Let add some friend");
              }
            case ConnectionState.waiting:
              return const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              );
            default:
              return const SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
