import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/extensions/locallization.dart';
import 'package:chatappforours/services/Theme/theme_changer.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/view/chat/addFriend/components/add_friend_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BodyAddFriend extends StatefulWidget {
  const BodyAddFriend({Key? key, required this.ownerUserProfile})
      : super(key: key);
  final UserProfile ownerUserProfile;
  @override
  State<BodyAddFriend> createState() => _BodyAddFriendState();
}

class _BodyAddFriendState extends State<BodyAddFriend> {
  final TextEditingController searchTextController = TextEditingController();
  late final FirebaseUserProfile firebaseUserProfile;
  late final FocusNode focusNode;
  bool isSelectedSearch = false;

  @override
  void initState() {
    firebaseUserProfile = FirebaseUserProfile();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.unfocus();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeChanger>(context).getTheme();
    return Column(
      children: [
        const SizedBox(
          height: kDefaultPadding,
        ),
        buildSearchText(context, isDarkTheme),
        const SizedBox(
          height: kDefaultPadding,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              context.loc.recommended,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontSize: 18,
                    color: isDarkTheme
                        ? Colors.white
                        : Colors.black.withOpacity(0.4),
                  ),
            ),
          ),
        ),
        StreamBuilder<Iterable<Future<UserProfile>>?>(
          stream: firebaseUserProfile.getAllUserProfileBySearchText(
            widget.ownerUserProfile.idUser!,
            searchTextController.text,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return AddFriendCard(
                          userProfile: snapshot.data!.elementAt(index),
                          ownerUserProfile:widget.ownerUserProfile,
                        );
                      },
                    ),
                  );
                } else {
                  return const Text("");
                }

              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }

  TextField buildSearchText(
    BuildContext context,
    bool isDarkTheme,
  ) {
    return TextField(
      focusNode: focusNode,
      controller: searchTextController,
      onChanged: (val) {
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: context.loc.search,
        hintStyle: TextStyle(
          color: Theme.of(context).textTheme.headline5!.color,
          fontSize: 20,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: !isDarkTheme
                ? Colors.black.withOpacity(0.1)
                : Colors.white.withOpacity(0.5),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: !isDarkTheme
                ? Colors.black.withOpacity(0.1)
                : Colors.white.withOpacity(0.5),
          ),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: kDefaultPadding),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color:
                  !isDarkTheme ? Colors.black.withOpacity(0.5) : Colors.white,
            ),
          ),
        ),
        suffixIcon: Visibility(
          visible: searchTextController.text.isNotEmpty,
          child: IconButton(
            onPressed: () {
              setState(
                () {
                  searchTextController.clear();
                },
              );
            },
            icon: Icon(
              Icons.close_rounded,
              color:
                  !isDarkTheme ? Colors.black.withOpacity(0.5) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
