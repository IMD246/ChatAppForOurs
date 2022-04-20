import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/crud/user_profile.dart';
import 'package:chatappforours/services/auth/storage/storage.dart';
import 'package:chatappforours/utilities/button/primary_button.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BodySetting extends StatefulWidget {
  const BodySetting({Key? key}) : super(key: key);

  @override
  State<BodySetting> createState() => _BodySettingState();
}

class _BodySettingState extends State<BodySetting> {
  bool isSelectedDarkMode = false;
  late final FirebaseUserProfile userProfile;
  @override
  void initState() {
    userProfile = FirebaseUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateSetting) {
          return FutureBuilder<UserProfile?>(
            future: userProfile.getUserProfile(userID: state.authUser.id),
            builder: (context, snapshot) {
              final userProfile = snapshot.data;
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding),
                        child: Column(
                          children: [
                            if (userProfile!.urlImage != null)
                              GestureDetector(
                                onTap: () {
                                  // context.read<AuthBloc>().add(
                                  //       const AuthEventSetting(),
                                  //     );
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  child: ClipOval(
                                    child: Image.network(
                                      userProfile.urlImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            if (userProfile.urlImage == null)
                              GestureDetector(
                                // onTap: () {
                                //   context
                                //       .read<AuthBloc>()
                                //       .add(const AuthEventSetting());
                                // },
                                child: const CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage(
                                      "assets/images/defaultImage.png"),
                                ),
                              ),
                            const SizedBox(height: kDefaultPadding * 0.5),
                            Text(
                              userProfile.fullName,
                              style: TextStyle(
                                color: textColorMode(ThemeMode.light),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: kDefaultPadding * 0.5),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding,
                              ),
                              child: PrimaryButton(
                                width: 100,
                                text: 'Upload Image',
                                press: () async {
                                  final results =
                                      await FilePicker.platform.pickFiles(
                                    allowMultiple: false,
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      'jpg',
                                      'png',
                                    ],
                                  );
                                  if (results == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('No file selected'),
                                      ),
                                    );
                                  } else {
                                    final path = results.files.single.path;
                                    final fileName = userProfile.email;
                                    Storage storage = Storage();
                                    await storage.uploadFile(
                                      filePath: path!,
                                      fileName: fileName,
                                      context: context,
                                    );
                                    final urlProfile =
                                        await storage.getDownloadURL(
                                      fileName: fileName,
                                    );
                                    FirebaseUserProfile firebaseUserProfile =
                                        FirebaseUserProfile();
                                    await firebaseUserProfile.uploadUserImage(
                                      userID: state.authUser.id,
                                      urlImage: urlProfile,
                                    );
                                  }
                                },
                                context: context,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                const AssetImage('assets/icons/dakrmode.png'),
                            backgroundColor: textColorMode(ThemeMode.light),
                          ),
                          const SizedBox(width: kDefaultPadding * 0.5),
                          Text(
                            "Chế độ tối",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColorMode(
                                ThemeMode.light,
                              ),
                            ),
                          ),
                          Switch(
                            inactiveTrackColor: kPrimaryColor.withOpacity(0.5),
                            value: isSelectedDarkMode,
                            activeColor: kPrimaryColor,
                            onChanged: (val) {
                              setState(
                                () {
                                  isSelectedDarkMode = val;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: PrimaryButton(
                          text: 'Sign Out',
                          press: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventLogOut());
                          },
                          context: context),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
