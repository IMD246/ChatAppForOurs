import 'package:chatappforours/view/chat/settings/components/changeUserProfile/body_change_user_profile.dart';
import 'package:flutter/material.dart';

class ChangeUserProfileScreen extends StatefulWidget {
  const ChangeUserProfileScreen({Key? key}) : super(key: key);

  @override
  State<ChangeUserProfileScreen> createState() => _ChangeUserProfileScreenState();
}

class _ChangeUserProfileScreenState extends State<ChangeUserProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change User Profile",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: const BodyChangeUserProfile(),
    );
  }
}
