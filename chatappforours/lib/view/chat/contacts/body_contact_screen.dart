import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_friend_list.dart';
import 'package:chatappforours/services/auth/crud/firebase_request_friend.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:chatappforours/view/chat/contacts/components/contact_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BodyContactScreen extends StatefulWidget {
  const BodyContactScreen({
    Key? key,
    required this.ownerUserProfile,
  }) : super(key: key);
  final UserProfile ownerUserProfile;
  @override
  State<BodyContactScreen> createState() => _BodyContactScreenState();
}

class _BodyContactScreenState extends State<BodyContactScreen>
    with AutomaticKeepAliveClientMixin<BodyContactScreen> {
  bool isFilledRecent = true;
  late final FirebaseFriendList firebaseFriendList;
  late final FirebaseRequestFriend firebaseRequestFriend;
  @override
  void initState() {
    firebaseFriendList = FirebaseFriendList();
    firebaseRequestFriend = FirebaseRequestFriend();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  FutureBuilder<int?>(
                    future: firebaseFriendList.countAllFriend(
                        ownerUserID: widget.ownerUserProfile.idUser!),
                    builder: (context, snapshot) {
                      int lengthText = snapshot.hasData ? snapshot.data! : 0;
                      return FillOutlineButton(
                        press: () {
                          if (isFilledRecent == false) {
                            setState(() {
                              isFilledRecent = true;
                            });
                          }
                        },
                        text:
                            "${context.loc.recent_friend}(${lengthText.toString()})",
                        isFilled: isFilledRecent,
                      );
                    },
                  ),
                  const SizedBox(width: kDefaultPadding * 0.7),
                  FutureBuilder<int?>(
                    future: firebaseRequestFriend.countAllRequestFriend(
                      ownerUserID: widget.ownerUserProfile.idUser!,
                    ),
                    builder: (context, snapshot) {
                      int lengthText = snapshot.hasData ? snapshot.data! : 0;
                      return FillOutlineButton(
                        press: () {
                          if (isFilledRecent == true) {
                            setState(() {
                              isFilledRecent = false;
                            });
                          }
                        },
                        text:
                            "${context.loc.request_friend}(${lengthText.toString()})",
                        isFilled: !isFilledRecent,
                      );
                    },
                  ),
                ],
              ),
            ),
            ContactListView(
              filledRequestFriend: isFilledRecent,
              ownerUserProfile: widget.ownerUserProfile,
            ),
          ],
        );
      },
    );
  }
}
