import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/view/chat/addFriend/components/body_add_friend.dart';
import 'package:flutter/material.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({Key? key,required this.ownerUserProfile}) : super(key: key);
  final UserProfile ownerUserProfile;
  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyAddFriend(ownerUserProfile:widget.ownerUserProfile),
    );
  }
}
