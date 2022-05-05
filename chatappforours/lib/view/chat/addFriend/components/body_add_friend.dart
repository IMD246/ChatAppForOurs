
import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/constants/user_profile_constant_field.dart';
import 'package:chatappforours/services/Theme/theme_changer.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/firebase_friend_list.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:chatappforours/view/chat/addFriend/components/add_friend_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BodyAddFriend extends StatefulWidget {
  const BodyAddFriend({Key? key}) : super(key: key);
  @override
  State<BodyAddFriend> createState() => _BodyAddFriendState();
}

class _BodyAddFriendState extends State<BodyAddFriend> {
  final TextEditingController searchTextController = TextEditingController();
  late final FirebaseUserProfile firebaseUserProfile;
  late final FirebaseFriendList firebaseFriendList;
  Iterable<UserProfile> listUserProfile = [];
  List<UserProfile> resultListUserProfile = [];
  bool isSelectedSearch = false;
  getUserProfileStreamSnapshot() async {
    var data = await FirebaseFirestore.instance
        .collection('UserProfile')
        .where(isEmailVerifiedField, isEqualTo: true)
        .get()
        .then(
          (value) => value.docs.map(
            (e) => UserProfile.fromSnapshot(e),
          ),
        );
    setState(() {
      listUserProfile = data;
      resultListUserProfile = List.from(listUserProfile);
    });
  }

  _onsearchChange(String val) {
    resultListUserProfile = [];
    if (val != "") {
      for (var userProfile in listUserProfile) {
        String fullName = userProfile.fullName.toLowerCase();
        if (fullName.contains(val.toLowerCase())) {
          resultListUserProfile.add(userProfile);
        }
      }
    } else {
      resultListUserProfile = List.from(listUserProfile);
    }
  }

  @override
  void initState() {
    firebaseUserProfile = FirebaseUserProfile();
    _onsearchChange("");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserProfileStreamSnapshot();
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
              "Recommened",
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontSize: 18,
                    color: isDarkTheme
                        ? Colors.white
                        : Colors.black.withOpacity(0.4),
                  ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: resultListUserProfile.length,
            itemBuilder: (context, index) {
              return AddFriendCard(
                userProfile: resultListUserProfile.elementAt(index),
              );
            },
          ),
        ),
      ],
    );
  }

  TextField buildSearchText(
    BuildContext context,
    bool isDarkTheme,
  ) {
    return TextField(
      controller: searchTextController,
      onChanged: (val) {
        setState(() {
          _onsearchChange(val);
        });
      },
      decoration: InputDecoration(
        hintText: "Search",
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


