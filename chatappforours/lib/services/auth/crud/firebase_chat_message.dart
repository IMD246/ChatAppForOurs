import 'package:chatappforours/constants/message_chat_field.dart';
import 'package:chatappforours/constants/user_join_chat_field.dart';
import 'package:chatappforours/enum/enum.dart';
import 'package:chatappforours/services/auth/crud/firebase_chat.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/chat.dart';
import 'package:chatappforours/services/auth/models/chat_message.dart';
import 'package:chatappforours/services/auth/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChatMessage {
  final firebaseChatMessageDocument = FirebaseFirestore.instance.collection(
    'chatMessage',
  );
  Future<void> createFirstTextMessage({
    required userID,
    required chatID,
    String? text,
  }) async {
    Map<String, dynamic> map = {
      idSenderField: '',
      hasSenderField: false,
      messageField: "Let make some chat",
      typeMessageField: TypeMessage.text.toString(),
      messageStatusField: MessageStatus.sent.toString(),
      stampTimeField: DateTime.now(),
    };
    await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .get()
        .then(
      (value) {
        if (value.docs.isNotEmpty) {
          firebaseChatMessageDocument
              .doc(chatID)
              .collection('message')
              .where(idSenderField, isEqualTo: userID)
              .where(
                messageStatusField,
                isEqualTo: MessageStatus.notSent.toString(),
              )
              .get()
              .then(
            (value) {
              if (value.docs.isNotEmpty) {
                firebaseChatMessageDocument
                    .doc(chatID)
                    .collection('message')
                    .doc(value.docs.first.id)
                    .set(map);
              }
            },
          );
        } else {
          firebaseChatMessageDocument
              .doc(chatID)
              .collection('message')
              .doc()
              .set(map);
        }
      },
    );
  }

  Future<void> createTextMessageNotSent(
      {required userID, required chatID}) async {
    Map<String, dynamic> map = {
      idSenderField: userID,
      hasSenderField: true,
      messageField: ". . .",
      typeMessageField: TypeMessage.text.toString(),
      messageStatusField: MessageStatus.notSent.toString(),
      stampTimeField: DateTime.now(),
    };
    await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .doc(userID)
        .set(map);
  }

  Future<void> createImageMessage({
    required userID,
    required chatID,
  }) async {
    List<String> list = ["."];
    Map<String, dynamic> map = {
      idSenderField: userID,
      hasSenderField: true,
      messageField: ". . .",
      listURLImageField: list,
      typeMessageField: TypeMessage.image.toString(),
      messageStatusField: MessageStatus.notSent.toString(),
      stampTimeField: DateTime.now(),
    };
    await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .doc()
        .set(map);
  }

  Future<void> createAudioMessage({
    required userID,
    required chatID,
  }) async {
    Map<String, dynamic> map = {
      idSenderField: userID,
      hasSenderField: true,
      messageField: ". . .",
      urlAudioField: ".",
      typeMessageField: TypeMessage.audio.toString(),
      messageStatusField: MessageStatus.notSent.toString(),
      stampTimeField: DateTime.now(),
    };
    await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .doc()
        .set(map);
  }

  Future<ChatMessage> getAudioMessageNotSentOwnerUser({
    required userID,
    required chatID,
  }) async {
    return await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .where(idSenderField, isEqualTo: userID)
        .where(typeMessageField, isEqualTo: TypeMessage.audio.toString())
        .where(messageStatusField, isEqualTo: MessageStatus.notSent.toString())
        .orderBy(stampTimeField, descending: true)
        .limit(1)
        .get()
        .then(
          (value) => ChatMessage.fromSnapshot(
            docs: value.docs.first,
            ownerUserID: userID,
          ),
        );
  }

  Future<ChatMessage> getImageMessageNotSentOwnerUser({
    required userID,
    required chatID,
  }) async {
    return await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .where(idSenderField, isEqualTo: userID)
        .where(typeMessageField, isEqualTo: TypeMessage.image.toString())
        .where(messageStatusField, isEqualTo: MessageStatus.notSent.toString())
        .orderBy(stampTimeField, descending: true)
        .limit(1)
        .get()
        .then(
          (value) => ChatMessage.fromSnapshot(
              docs: value.docs.first, ownerUserID: userID),
        );
  }

  Future<void> uploadImageMessageNotSent({
    required String chatID,
    required List<String> listUrlImage,
    required String nameSender,
    required ChatMessage lastMessageUserOwner,
  }) async {
    final firebaseChat = FirebaseChat();
    Map<String, dynamic> map = {
      listURLImageField: listUrlImage,
      messageField: "n",
      typeMessageField: TypeMessage.image.toString(),
      messageStatusField: MessageStatus.sent.toString(),
    };
    await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .doc(lastMessageUserOwner.idMessage)
        .update(map);
    await firebaseChat.updateChatLastText(
      text: "$nameSender sent ${listUrlImage.length} photo",
      chatID: chatID,
      typeMessage: TypeMessage.image,
    );
  }

  Future<void> uploadAudioMessageNotSent({
    required String chatID,
    required String urlAudio,
    required String nameSender,
    required ChatMessage lastMessageUserOwner,
  }) async {
    final firebaseChat = FirebaseChat();
    Map<String, dynamic> map = {
      urlAudioField: urlAudio,
      typeMessageField: TypeMessage.audio.toString(),
      messageStatusField: MessageStatus.sent.toString(),
    };
    await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .doc(lastMessageUserOwner.idMessage)
        .update(map);
    await firebaseChat.updateChatLastText(
      text: nameSender,
      chatID: chatID,
      typeMessage: TypeMessage.audio,
    );
  }

  Future<void> deleteMessageNotSent({
    required String ownerUserID,
    required String chatID,
  }) async {
    String? id;
    if (id != null) {
      final bool isCheck = await firebaseChatMessageDocument
          .doc(chatID)
          .collection('message')
          .where(idSenderField, isEqualTo: ownerUserID)
          .where(typeMessageField, isEqualTo: TypeMessage.text)
          .where(messageStatusField,
              isEqualTo: MessageStatus.notSent.toString())
          .orderBy(stampTimeField, descending: true)
          .limit(1)
          .get()
          .then(
        (value) {
          if (value.size > 0 && value.docs.first.exists) {
            id = value.docs.first.id;
            return true;
          } else {
            return false;
          }
        },
      );
      if (isCheck == true) {
        await firebaseChatMessageDocument
            .doc(chatID)
            .collection('message')
            .doc(id)
            .delete();
      }
    }
  }

  Future<void> updateMessageFriendToViewed({
    required chatID,
    required messageID,
  }) async {
    Map<String, dynamic> mapUpdate = {
      messageStatusField: MessageStatus.viewed.toString(),
    };
    await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .doc(messageID)
        .update(mapUpdate);
  }

  Future<void> updateTextMessageNotSent({
    required String ownerUserID,
    required Chat chat,
    required String text,
  }) async {
    final firebaseChat = FirebaseChat();
    Map<String, dynamic> mapCreate = {
      idSenderField: ownerUserID,
      hasSenderField: true,
      messageField: text,
      typeMessageField: TypeMessage.text.toString(),
      messageStatusField: MessageStatus.sent.toString(),
      stampTimeField: DateTime.now(),
    };
    await firebaseChatMessageDocument
        .doc(chat.idChat)
        .collection('message')
        .doc()
        .set(mapCreate);
    if (chat.isActive == false) {
      await firebaseChat.updateChatToActive(
        idChat: chat.idChat,
        ownerUserID: ownerUserID,
      );
    }
    await firebaseChat.updateChatLastText(
      text: text,
      chatID: chat.idChat,
      typeMessage: TypeMessage.text,
    );
  }

  Future<UserProfile?> checkLastMessageOfChatRoomForUploadStatusMessageViewed(
      {required String chatID,
      required String idMessage,
      required String userIDFriend}) async {
    final FirebaseUserProfile userProfile = FirebaseUserProfile();
    final bool lastMessage = await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .where(
          messageStatusField,
          isEqualTo: MessageStatus.viewed.toString(),
        )
        .orderBy(stampTimeField, descending: true)
        .limit(1)
        .get()
        .then(
      (value) {
        if (value.docs.first.id.isNotEmpty) {
          return value.docs.first.id == idMessage ? true : false;
        } else {
          return false;
        }
      },
    );
    if (lastMessage) {
      return userProfile.getUserProfile(userID: userIDFriend);
    } else {
      return null;
    }
  }

  Future<bool> checkLastMessageOfChatRoom({
    required String chatID,
    required String idMessage,
  }) async {
    final bool lastMessage = await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .where(messageStatusField, isEqualTo: MessageStatus.viewed.toString())
        .orderBy(
          stampTimeField,
          descending: true,
        )
        .limit(1)
        .get()
        .then(
      (value) {
        if (value.docs.first.id.isNotEmpty) {
          return value.docs.first.id == idMessage ? true : false;
        } else {
          return false;
        }
      },
    );
    return lastMessage;
  }

  Future<ChatMessage?> getIDNotSentOwnerUser({
    required String chatID,
    required String ownerUserID,
  }) async {
    final id = await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .doc(ownerUserID)
        .get()
        .then(
      (value) async {
        if (value.exists) {
          return value.id;
        } else {
          return null;
        }
      },
    );
    final chatMess = id;
    if (chatMess != null) {
      final a = await firebaseChatMessageDocument
          .doc(chatID)
          .collection('message')
          .doc(chatMess)
          .get();
      ChatMessage.fromSnapshot(docs: a, ownerUserID: ownerUserID);
    } else {
      return null;
    }
    return null;
  }

  Future<ChatMessage?> getAMessage({
    required String chatID,
    required String idMessage,
    required String ownerUserID,
  }) async {
    return await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .doc(idMessage)
        .get()
        .then(
      (value) async {
        if (value.exists) {
          return ChatMessage.fromSnapshot(
              docs: value, ownerUserID: ownerUserID);
        } else {
          return null;
        }
      },
    );
  }

  Future<ChatMessage?> getLastMessageOfAChat({
    required String chatID,
    required String ownerUserID,
  }) async {
    return await firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .orderBy(stampTimeField, descending: true)
        .limit(1)
        .get()
        .then(
      (value) {
        if (value.docs.isNotEmpty) {
          return ChatMessage.fromSnapshot(
            docs: value.docs.first,
            ownerUserID: ownerUserID,
          );
        } else {
          return null;
        }
      },
    );
  }

  Stream<Iterable<ChatMessage>> getAllMessage(
      {required String chatID, required String ownerUserID}) {
    final allMessage = firebaseChatMessageDocument
        .doc(chatID)
        .collection('message')
        .orderBy(
          stampTimeField,
          descending: false,
        )
        .snapshots()
        .map(
          (event) => event.docs.map(
            (docs) => ChatMessage.fromSnapshot(
              docs: docs,
              ownerUserID: ownerUserID,
            ),
          ),
        );
    return allMessage;
  }
}
