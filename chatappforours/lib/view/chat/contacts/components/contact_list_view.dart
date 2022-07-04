import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/view/chat/contacts/components/list_friend.dart';
import 'package:chatappforours/view/chat/contacts/components/list_request_friend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ContactListView extends StatelessWidget {
  const ContactListView({
    Key? key,
    required this.filledRequestFriend,
    required this.ownerUserProfile,
  }) : super(key: key);
  final bool filledRequestFriend;
  final UserProfile ownerUserProfile;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (filledRequestFriend) {
          return ListFriend(
            ownerUserProfile: ownerUserProfile,
          );
        } else {
          return ListRequestFriend(
            ownerUserProfile: ownerUserProfile,
          );
        }
      },
    );
  }
}
