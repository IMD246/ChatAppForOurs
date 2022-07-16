import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/view/chat/settings/components/updateUserProfile/body_update_user_profile.dart';
import 'package:flutter/material.dart';

class UpdateUserProfileScreen extends StatefulWidget {
  const UpdateUserProfileScreen({Key? key, required this.fullNameNotifier}) : super(key: key);
  final ValueNotifier<String> fullNameNotifier;
  @override
  State<UpdateUserProfileScreen> createState() =>
      _UpdateUserProfileScreenState();
}

class _UpdateUserProfileScreenState extends State<UpdateUserProfileScreen> {
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
        title: Text(
          context.loc.update_user_profile,
          style: const TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: BodyUpdateUserProfile(fullnameNotifier: widget.fullNameNotifier,),
    );
  }
}
