import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/custom_error.dart';
import '../../data/models/user.dart';
import '../../utils/custom_http_client.dart';
import '../../utils/custom_shared_preferences.dart';
import '../../utils/my_urls.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';

class RegisterRepository {
  CustomHttpClient http = CustomHttpClient();

  Future<dynamic> register(String name, String username,BuildContext context) async {
    try {
      var body = jsonEncode({'name': name, 'username': username});
      var response = await http.post(
        Uri(host: '${MyUrls.serverUrl}/user'),
        body: body,
      );
      final dynamic registerResponse = jsonDecode(response.body);
      await CustomSharedPreferences.setString(
          'chat_token', registerResponse['token']);

      if (registerResponse['error'] != null) {
        return CustomError.fromJson(registerResponse);
      }

      final User user = User.fromJson(registerResponse['user']);

      return user;
    } catch (err) {
      // throw err;
      return null;
    }
  }


}
