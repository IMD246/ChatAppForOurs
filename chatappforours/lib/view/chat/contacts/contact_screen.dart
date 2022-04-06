import 'package:chatappforours/constants/constants.dart';
import 'package:chatappforours/models/chat.dart';
import 'package:chatappforours/utilities/button/filled_outline_button.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
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
                      getAllData();
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
              return ContactCard(
                chat: listChatData[index],
              );
            },
          ),
        ),
      ],
    );
  }
}

class ContactCard extends StatelessWidget {
  const ContactCard({
    Key? key,
    required this.chat,
  }) : super(key: key);
  final Chat chat;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding * 0.75,
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(chat.image),
              ),
              if (chat.isActive)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 3,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(width: kDefaultPadding / 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(
              chat.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          const Spacer(),
          Opacity(
            opacity: 0.64,
            child: Text(
              chat.time,
            ),
          ),
        ],
      ),
    );
  }
}
