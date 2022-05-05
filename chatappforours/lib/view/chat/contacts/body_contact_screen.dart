import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/models/firebase_friend_list.dart';
import 'package:chatappforours/services/auth/models/friend_list.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:chatappforours/view/chat/contacts/components/contact_list_view.dart';
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


