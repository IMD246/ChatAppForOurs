import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:flutter/widgets.dart';

class UserProfileChanger with ChangeNotifier {
  final UserProfile ownerUserProfile;
  late final BuildContext context;

  UserProfileChanger( {required this.ownerUserProfile});
}
