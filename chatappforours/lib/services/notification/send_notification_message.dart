import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> sendMessage({
  required Map<String, dynamic> notification,
  required String tokenUserFriend,
  required String tokenOwnerUser,
  required Map<String, dynamic> data,
}) async {
  if (tokenUserFriend != tokenOwnerUser) {
    String url = 'https://fcm.googleapis.com/fcm/send';
    String keyApp =
        'key=AAAAB461BsM:APA91bFXTTlSC4zu_o_iwauFGUO8xBUEw1ycrIb5YkgUk-aSzUMvC5zIOFRcgLIsrK8kTaLYdyJweZMT7GEwngwLOzYyDZSSeqOgURilsENtR8mCkV_2Le3JHx8NWeBnPr_l_6SyJS4A';
    final headers = <String, String>{
      'Content-type': 'application/json',
      'Authorization': keyApp,
    };
    try {
      await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(
          <String, dynamic>{
            'notification': notification,
            'priority': 'high',
            'data': data,
            "to": tokenUserFriend,
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
