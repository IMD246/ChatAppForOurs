import 'dart:io';

import 'package:chatappforours/services/auth/crud/firebase_chat_message.dart';
import 'package:chatappforours/services/auth/crud/firebase_user_profile.dart';
import 'package:chatappforours/services/auth/models/chat_message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;
  Future<void> uploadFile(
      {required String filePath,
      required String fileName,
      BuildContext? context}) async {
    File file = File(filePath);
    try {
      await storage
          .ref('image/$fileName')
          .putFile(
            file,
            SettableMetadata(
              contentType: 'image/jpeg,',
            ),
          )
          .then(
            (p0) => ScaffoldMessenger.of(context!).showSnackBar(
              const SnackBar(
                content: Text(
                  'Upload Image Successful',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
    } on FirebaseException catch (_) {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(
          content: Text(
            'Upload Image Failed',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  Future<void> uploadMultipleFile({
    required List<PlatformFile> listFile,
    BuildContext? context,
    required FirebaseChatMessage firebaseChatMessage,
    required ChatMessage lastMessageUserOwner,
    required FirebaseUserProfile firebaseUserProfile,
    required String idChat,
  }) async {
    try {
      List<String> listUrlImage = [];
      for (var i = 0; i < listFile.length; i++) {
        File file = File(listFile.elementAt(i).path!);
        final String fileName =
            '${lastMessageUserOwner.idMessage}/${listFile.elementAt(i).name}';
        await storage
            .ref('image/$fileName')
            .putFile(file, SettableMetadata(contentType: 'image/jpeg'))
            .then(
          (p0) async {
            final urlImage = await getDownloadURL(fileName: fileName);
            listUrlImage.add(urlImage!);
            if (listUrlImage.length == listFile.length) {
              final userProfile = await firebaseUserProfile.getUserProfile(
                  userID: lastMessageUserOwner.userID);
              await firebaseChatMessage.uploadImageMessageNotSent(
                chatID: idChat,
                lastMessageUserOwner: lastMessageUserOwner,
                listUrlImage: listUrlImage,
                nameSender: userProfile!.fullName,
              );
            }
          },
        );
      }
    } on FirebaseException catch (_) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'context.loc.upload_image_failed',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }

  Future<String?> getDownloadURL({required String fileName}) async {
    try {
      String downloadURL =
          await storage.ref('image/$fileName').getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (_) {
      return null;
    }
  }
}
