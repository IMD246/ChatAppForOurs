import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/Theme/theme_changer.dart';
import 'package:chatappforours/services/auth/bloc/auth_bloc.dart';
import 'package:chatappforours/services/auth/bloc/auth_event.dart';
import 'package:chatappforours/services/auth/bloc/auth_state.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/utilities/button/primary_button.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class BodySetting extends StatefulWidget {
  const BodySetting({Key? key}) : super(key: key);

  @override
  State<BodySetting> createState() => _BodySettingState();
}

class _BodySettingState extends State<BodySetting> {
  bool isSelectedDarkMode = false;
  late final FirebaseUserProfile userProfile;
  late final FirebaseUserProfile firebaseUserProfile;
  @override
  void initState() {
    userProfile = FirebaseUserProfile();
    firebaseUserProfile = FirebaseUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger themeChanger = Provider.of<ThemeChanger>(context);
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
                                  final path = results.files.single.path;
                                  final fileName = userProfile!.email;
                                  context.read<AuthBloc>().add(
                                        AuthEventUploadImage(
                                          context: context,
                                          path: path!,
                                          fileName: fileName,
                                        ),
                                      );
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
                                  if (userProfile!.urlImage != null)
                                    CircleAvatar(
                                      backgroundColor: Colors.cyan[100],
                                      radius: 60,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: userProfile.urlImage!,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          colorBlendMode: BlendMode.softLight,
                                        ),
                                      ),
                                    ),
                                  Positioned(
                                    bottom: -7,
                                    right: -5,
                                    child: Container(
                                      child: IconButton(
                                        onPressed: () async {
                                          final results = await FilePicker
                                              .platform
                                              .pickFiles(
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
                                            final path =
                                                results.files.single.path;
                                            final fileName = userProfile.email;
                                            context.read<AuthBloc>().add(
                                                  AuthEventUploadImage(
                                                    context: context,
                                                    path: path!,
                                                    fileName: fileName,
                                                  ),
                                                );
                                          }
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Color.fromARGB(162, 189, 187, 187),
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
                            value: themeChanger.getTheme(),
                            activeColor: kPrimaryColor,
                            onChanged: (val) {
                              setState(
                                () {
                                  context.read<AuthBloc>().add(
                                      AuthEventUploadStateTheme(
                                          isDarkTheme: val));
                                  themeChanger.setTheme(val);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: kDefaultPadding,
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
