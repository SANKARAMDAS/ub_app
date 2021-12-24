import 'dart:convert';

import 'package:flutter/material.dart';

import '../../data/models/custom_error.dart';
import '../../data/models/user.dart';
import '../../utils/custom_http_client.dart';
import '../../utils/my_urls.dart';

class UserRepository {
  CustomHttpClient http = CustomHttpClient();

  Future<dynamic> getUsers() async {
    try {
      var response = await http.get(Uri(host: '${MyUrls.serverUrl}/users'));
      final List<dynamic> usersResponse = jsonDecode(response.body)['users'];

      final List<User> users =
          usersResponse.map((user) => User.fromJson(user)).toList();
      return users;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<void> saveUserFcmToken(String? fcmToken) async {
    try {
      var body = jsonEncode({'fcmToken': fcmToken});
      await http.post(Uri.parse('${MyUrls.serverUrl}/fcm-token'), body: body);
    } catch (err) {
      debugPrint("error $err");
    }
  }
}
