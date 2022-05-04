import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/Theme/theme_changer.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/firebase_friend_list.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BodyAddFriend extends StatefulWidget {
  const BodyAddFriend({Key? key}) : super(key: key);
  @override
  State<BodyAddFriend> createState() => _BodyAddFriendState();
}

class _BodyAddFriendState extends State<BodyAddFriend> {
  late final TextEditingController textController;
  late final FirebaseUserProfile firebaseUserProfile;
  late final FirebaseFriendList firebaseFriendList;
  bool isSelectedSearch = false;
  bool isAdded = false;
  @override
  void initState() {
    textController = TextEditingController();
    firebaseUserProfile = FirebaseUserProfile();
    setState(() {
      isAdded = textController.text.isNotEmpty ? true : false;
    });
    super.initState();
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
            itemCount: 50,
            itemBuilder: (context, index) {
              return AddFriendCard(index: index);
            },
          ),
        )
      ],
    );
  }

  TextField buildSearchText(BuildContext context, bool isDarkTheme) {
    return TextField(
      controller: textController,
      onChanged: (value) {
        setState(() {
          isAdded = value.isNotEmpty ? true : false;
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
          visible: textController.text.isNotEmpty,
          child: IconButton(
            onPressed: () {
              setState(
                () {
                  textController.clear();
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

class AddFriendCard extends StatefulWidget {
  const AddFriendCard({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;

  @override
  State<AddFriendCard> createState() => _AddFriendCardState();
}

class _AddFriendCardState extends State<AddFriendCard> {
  bool isCheck = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 20,
        backgroundImage: AssetImage(
          "assets/images/defaultImage.png",
        ),
      ),
      title: Text(
        "Me ${widget.index}",
        overflow: TextOverflow.ellipsis,
      ),
      trailing: FillOutlineButton(
        press: () {
          setState(() {
            if (isCheck == false) {
              isCheck = true;
            }
          });
        },
        text: isCheck ? "Added" : "Add",
        isFilled: !isCheck,
        isCheckAdded: isCheck,
      ),
    );
  }
}
