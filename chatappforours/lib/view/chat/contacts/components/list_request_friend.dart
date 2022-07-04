import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/auth/crud/firebase_request_friend.dart';
import 'package:chatappforours/services/auth/models/request_friend.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/view/chat/contacts/components/request_card.dart';
import 'package:flutter/material.dart';

class ListRequestFriend extends StatelessWidget {
  const ListRequestFriend({
    Key? key,
    required this.ownerUserProfile,
  }) : super(key: key);
  final UserProfile ownerUserProfile;
  @override
  Widget build(BuildContext context) {
    final FirebaseRequestFriend firebaseRequestFriend = FirebaseRequestFriend();
    return Expanded(
      child: StreamBuilder<Iterable<RequestFriend>?>(
        stream: firebaseRequestFriend.getAllRequestFriend(
          ownerUserID: ownerUserProfile.idUser!,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final listRequest = snapshot.data as Iterable<RequestFriend>;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: listRequest.length,
              itemBuilder: (context, index) {
                return RequestCard(
                  requestFriend: listRequest.elementAt(index),
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
        },
      ),
    );
  }
}
