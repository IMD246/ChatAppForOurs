import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/Theme/theme_changer.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/services/auth/storage/storage.dart';
import 'package:chatappforours/utilities/button/primary_button.dart';
import 'package:chatappforours/view/chat/settings/components/change_language.dart';
import 'package:chatappforours/view/chat/settings/components/updatePassword/update_password_screen.dart';
import 'package:chatappforours/view/chat/settings/components/updateUserProfile/update_user_profile_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BodySetting extends StatefulWidget {
  const BodySetting({Key? key}) : super(key: key);

  @override
  State<BodySetting> createState() => _BodySettingState();
}

class _BodySettingState extends State<BodySetting> {
  bool isSelectedDarkMode = false;
  late final FirebaseUserProfile userProfile;
  late final FirebaseUserProfile firebaseUserProfile;
  final Storage storage = Storage();
  final user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    userProfile = FirebaseUserProfile();
    firebaseUserProfile = FirebaseUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger themeChanger = Provider.of<ThemeChanger>(context);
    themeChanger.context = context;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return FutureBuilder<UserProfile?>(
          future: userProfile.getUserProfile(userID: user.uid),
          builder: (context, snapshot) {
            final userProfile = snapshot.data;
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: kDefaultPadding),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final results =
                                  await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                allowedExtensions: [
                                  'jpg',
                                  'png',
                                  'PNG',
                                ],
                              );
                              if (results == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'No file selected',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              } else {
                                setState(() {
                                  storage.uploadFile(
                                    filePath: results.files.single.path!,
                                    fileName: user.email!,
                                    userID: user.uid,
                                    firebaseUserProfile: firebaseUserProfile,
                                    context: context,
                                  );
                                });
                              }
                            },
                            child: Stack(
                              children: [
                                if (userProfile?.urlImage == null)
                                  CircleAvatar(
                                    backgroundColor: Colors.cyan[100],
                                    radius: 60,
                                    backgroundImage: const AssetImage(
                                      "assets/images/defaultImage.png",
                                    ),
                                  ),
                                if (userProfile!.urlImage.isNotEmpty)
                                  CircleAvatar(
                                    backgroundColor: Colors.cyan[100],
                                    radius: 60,
                                    child: ClipOval(
                                      child: SizedBox.fromSize(
                                        size: const Size.fromRadius(60),
                                        child: CachedNetworkImage(
                                          imageUrl: userProfile.urlImage,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  bottom: -7,
                                  right: -5,
                                  child: Container(
                                    child: IconButton(
                                      onPressed: () async {
                                        final results =
                                            await FilePicker.platform.pickFiles(
                                          allowMultiple: false,
                                          type: FileType.custom,
                                          allowedExtensions: [
                                            'jpg',
                                            'png',
                                            'PNG',
                                          ],
                                        );
                                        if (results == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'No file selected',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        } else {
                                          setState(() {
                                            storage.uploadFile(
                                              filePath:
                                                  results.files.single.path!,
                                              fileName: user.email!,
                                              userID: user.uid,
                                              firebaseUserProfile:
                                                  firebaseUserProfile,
                                              context: context,
                                            );
                                          });
                                        }
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(162, 189, 187, 187),
                                    ),
                                  ),
                                ),
                              ],
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
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              const AssetImage('assets/icons/dakrmode.png'),
                          backgroundColor: textColorMode(ThemeMode.light),
                        ),
                        const SizedBox(width: kDefaultPadding * 0.5),
                        Text(
                          context.loc.dark_mode,
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
                          value: themeChanger.getTheme(),
                          activeColor: kPrimaryColor,
                          onChanged: (val) {
                            setState(
                              () {
                                firebaseUserProfile.uploadDarkTheme(
                                  userID: user.uid,
                                  isDarkTheme: val,
                                );
                                themeChanger.setTheme(val);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return const ChangeLanguage();
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/icons/languages.png',
                            ),
                          ),
                          const SizedBox(width: kDefaultPadding * 0.5),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding * 0.05,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  context.loc.language,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColorMode(
                                      ThemeMode.light,
                                    ),
                                  ),
                                ),
                                Text(
                                  themeChanger.getLanguage(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: textColorMode(
                                      ThemeMode.light,
                                    ).withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultPadding / 2.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding,
                    ),
                    child: PrimaryButton(
                        text: context.loc.update_user_profile,
                        color: Colors.white,
                        press: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const UpdateUserProfileScreen();
                              },
                            ),
                          );
                        },
                        context: context),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding,
                        vertical: kDefaultPadding / 2),
                    child: PrimaryButton(
                        text: context.loc.update_password,
                        color: Colors.white,
                        press: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return const UpdatePasswordScreen();
                            }),
                          );
                        },
                        context: context),
                  ),
                  const SizedBox(
                    height: kDefaultPadding / 2.5,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: PrimaryButton(
                        text: context.loc.sign_out,
                        color: Colors.white,
                        press: () async {
                          final GoogleSignIn googleSignIn = GoogleSignIn();
                          await googleSignIn.isSignedIn() == true
                              ? await googleSignIn.signOut()
                              : "";
                          context.read<AuthBloc>().add(
                                const AuthEventLogOut(),
                              );
                          Navigator.pop(context);
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
      },
    );
  }
}
