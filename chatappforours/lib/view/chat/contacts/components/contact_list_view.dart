import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/models/firebase_friend_list.dart';
import 'package:chatappforours/services/auth/models/friend_list.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/view/chat/contacts/components/contact_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ContactListView extends StatelessWidget {
  ContactListView({
    Key? key,
    required this.filledRequestFriend,
    required this.ownerUserProfile,
  }) : super(key: key);
  final bool filledRequestFriend;
  final UserProfile ownerUserProfile;
  final FirebaseFriendList firebaseFriendList = FirebaseFriendList();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Expanded(
          child: StreamBuilder(
            stream: firebaseFriendList.getAllFriendIsAccepted(ownerUserID: ownerUserProfile.idUser!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final listFriend = snapshot.data as Iterable<FriendList>;
                final List<FriendList> listFilter = filledRequestFriend
                    ? listFriend
                        .where((element) => element.isRequest! == false)
                        .toList()
                    : listFriend.toList();
                if (listFilter.isNotEmpty){
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: listFilter.length,
                    itemBuilder: (context, index) {
                      return ContactCard(
                        friend: listFilter.elementAt(index),
                        requestFriend: filledRequestFriend,
                        ownerUserProfile: ownerUserProfile,
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      context.loc.no_request_friend_available,
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                }
              } else {
                return Center(
                  child: Text(
                    context.loc.no_friend_available,
                    style: const TextStyle(fontSize: 20),
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
