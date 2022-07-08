import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class GetRealSize {
  static Future<ui.Image> getSize(String path) {
    Image image = Image.network(path);
    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((ImageInfo info, bool synchronousCall) =>
            completer.complete(info.image)));
    completer.future.then((value) {
      return value;
    });
    return completer.future;
  }
}
