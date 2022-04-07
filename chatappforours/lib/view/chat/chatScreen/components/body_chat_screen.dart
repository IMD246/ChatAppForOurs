import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/models/chat.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:chatappforours/view/chat/chatScreen/components/chat_card.dart';
import 'package:chatappforours/view/chat/messageScreen/message_screen.dart';
import 'package:flutter/material.dart';

class BodyChatScreen extends StatefulWidget {
  const BodyChatScreen({Key? key}) : super(key: key);

  @override
  State<BodyChatScreen> createState() => _BodyChatScreenState();
}

class _BodyChatScreenState extends State<BodyChatScreen> {
  List<dynamic> listChatData = [];
  bool isFilledRecent = true;
  bool isFilledActive = false;
  void getAllData() {
    listChatData.clear();
    listChatData.addAll(chatsData);
  }

  Future<void> getData() async {
    listChatData.clear();
    for (var i = 0; i < chatsData.length; i++) {
      await chatsData[i].isActive ? listChatData.add(chatsData[i]) : null;
    }
  }

  @override
  void initState() {
    super.initState();

    getAllData();
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
          color: kPrimaryColor,
          padding: const EdgeInsets.fromLTRB(
            kDefaultPadding,
            0,
            kDefaultPadding,
            kDefaultPadding,
          ),
          child: Row(
            children: [
              FillOutlineButton(
                isFilled: isFilledRecent,
                press: () {
                  setState(
                    () {
                      isFilledRecent = true;
                      isFilledActive = false;
                      getAllData();
                    },
                  );
                },
                text: "Recent Message",
              ),
              const SizedBox(width: kDefaultPadding),
              FillOutlineButton(
                press: () {
                  setState(() {
                    isFilledRecent = false;
                    isFilledActive = true;
                    getData();
                  });
                },
                text: "Active",
                isFilled: isFilledActive,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: listChatData.length,
            itemBuilder: (context, index) {
              return ChatCard(
                chat: listChatData[index],
                press: () async {
                  final chatData = await listChatData[index];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MesssageScreen(chat: chatData);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
