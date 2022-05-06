import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/models/firebase_friend_list.dart';
import 'package:chatappforours/services/auth/models/friend_list.dart';
import 'package:chatappforours/view/chat/contacts/components/contact_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ContactListView extends StatelessWidget {
  ContactListView({
    Key? key,
    required this.filledRequestFriend,
  }) : super(key: key);
  final bool filledRequestFriend;

  final FirebaseFriendList firebaseFriendList = FirebaseFriendList();
  String id = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Expanded(
          child: StreamBuilder(
            stream: filledRequestFriend
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
                          requestFriend: filledRequestFriend,
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
      },
    );
  }
}
