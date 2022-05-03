import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/models/firebase_friend_list.dart';
import 'package:chatappforours/services/auth/models/friend_list.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:chatappforours/view/chat/contacts/components/contact_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BodyContactScreen extends StatefulWidget {
  const BodyContactScreen({Key? key}) : super(key: key);

  @override
  State<BodyContactScreen> createState() => _BodyContactScreenState();
}

class _BodyContactScreenState extends State<BodyContactScreen> {
  bool isFilledRecent = true;
  bool isFilledRequestFriend = false;
  late final FirebaseFriendList firebaseFriendList;
  String id = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    firebaseFriendList = FirebaseFriendList();
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
                  StreamBuilder(
                    stream: firebaseFriendList.getAllFriendIsAccepted(
                        ownerUserID: id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final friendList =
                            snapshot.data as Iterable<FriendList>;
                        String? lengthText =
                            friendList.isEmpty ? '' : "(${friendList.length})";
                        return FillOutlineButton(
                          press: () {
                            if (isFilledRequestFriend == true) {
                              setState(() {
                                isFilledRequestFriend = false;
                                isFilledRecent = true;
                              });
                            }
                          },
                          text: "Recent Friend $lengthText",
                          isFilled: isFilledRecent,
                        );
                      } else {
                        return FillOutlineButton(
                          press: () {
                            if (isFilledRequestFriend == true) {
                              setState(() {
                                isFilledRequestFriend = false;
                                isFilledRecent = true;
                              });
                            }
                          },
                          text: "Recent Friend",
                          isFilled: isFilledRecent,
                        );
                      }
                    },
                  ),
                  const SizedBox(width: kDefaultPadding * 0.7),
                  StreamBuilder(
                    stream: firebaseFriendList.getAllFriendIsRequested(
                        ownerUserID: id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final friendList =
                            snapshot.data as Iterable<FriendList>;
                        String? lengthText =
                            friendList.isEmpty ? '' : "(${friendList.length})";
                        return FillOutlineButton(
                          press: () {
                            if (isFilledRequestFriend == false) {
                              setState(() {
                                isFilledRequestFriend = true;
                                isFilledRecent = false;
                              });
                            }
                          },
                          text: "Request Friend $lengthText",
                          isFilled: isFilledRequestFriend,
                        );
                      } else {
                        return FillOutlineButton(
                          press: () {
                            if (isFilledRequestFriend == false) {
                              setState(() {
                                isFilledRequestFriend = true;
                                isFilledRecent = false;
                              });
                            }
                          },
                          text: "Request Friend",
                          isFilled: isFilledRequestFriend,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            ContactListView(filledRequestFriend: isFilledRequestFriend),
          ],
        );
      },
    );
  }
}

class ContactListView extends StatefulWidget {
  const ContactListView({
    Key? key,
    required this.filledRequestFriend,
  }) : super(key: key);
  final bool filledRequestFriend;
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
        stream: widget.filledRequestFriend
            ? firebaseFriendList.getAllFriendIsRequested(ownerUserID: id)
            : firebaseFriendList.getAllFriendIsAccepted(ownerUserID: id),
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
                      requestFriend: widget.filledRequestFriend,
                    );
                  },
                );
              } else {
                return const Text("Let add some friend");
              }
            case ConnectionState.waiting:
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: const Center(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            default:
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: const Center(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
