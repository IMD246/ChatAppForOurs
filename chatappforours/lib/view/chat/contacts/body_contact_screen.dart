import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:chatappforours/view/chat/contacts/components/contact_card.dart';
import 'package:flutter/material.dart';

class BodyContactScreen extends StatefulWidget {
  const BodyContactScreen({Key? key}) : super(key: key);

  @override
  State<BodyContactScreen> createState() => _BodyContactScreenState();
}

class _BodyContactScreenState extends State<BodyContactScreen> {
  List<Chat> listChatData = [];
  bool isFilledRecent = true;
  bool isFilledActive = false;
  // void getAllData() {
  //   listChatData.clear();
  //   listChatData.addAll(chatsData);
  // }

  // Future<void> getData() async {
  //   listChatData.clear();
  //   for (var i = 0; i < chatsData.length; i++) {
  //     await chatsData[i].isActive ? listChatData.add(chatsData[i]) : null;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // getAllData();
  }

  @override
  void dispose() {
    super.dispose();
    listChatData.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
            kDefaultPadding,
            0,
            kDefaultPadding,
            kDefaultPadding,
          ),
          color: kPrimaryColor,
          child: Row(
            children: [
              FillOutlineButton(
                isFilled: isFilledRecent,
                press: () {
                  setState(
                    () {
                      isFilledRecent = true;
                      isFilledActive = false;
                    },
                  );
                },
                text: "Recent Contact",
              ),
              const SizedBox(width: kDefaultPadding * 0.7),
              FillOutlineButton(
                press: () {
                  setState(() {
                    isFilledRecent = false;
                    isFilledActive = true;
                  });
                },
                text: "Active",
                isFilled: isFilledActive,
              ),
            ],
          ),
        ),
        // Expanded(
        //   child: ListView.builder(
        //     itemBuilder: (context, index) {
        //       return ContactCard(
        //         chat: listChatData[index],
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
