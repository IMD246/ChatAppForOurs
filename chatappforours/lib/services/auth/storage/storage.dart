import 'dart:io';

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
      await storage.ref('image/$fileName').putFile(file).then(
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
