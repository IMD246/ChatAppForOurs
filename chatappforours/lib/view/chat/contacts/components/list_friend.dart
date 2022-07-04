import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/crud/firebase_friend_list.dart';
import 'package:chatappforours/services/auth/models/friend.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/view/chat/contacts/components/contact_card.dart';
import 'package:flutter/material.dart';

class ListFriend extends StatelessWidget {
  const ListFriend({
    Key? key,
    required this.ownerUserProfile,
  }) : super(key: key);
  final UserProfile ownerUserProfile;
  @override
  Widget build(BuildContext context) {
    final FirebaseFriendList firebaseFriendList = FirebaseFriendList();
    return Expanded(
      child: StreamBuilder<Iterable<Friend>?>(
        stream: firebaseFriendList.getAllFriend(
          ownerUserID: ownerUserProfile.idUser!,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final listFriend = snapshot.data as Iterable<Friend>;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: listFriend.length,
              itemBuilder: (context, index) {
                return ContactCard(
                  friend: listFriend.elementAt(index),
                  ownerUserProfile: ownerUserProfile,
                );
              },
            );
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
  }
}
