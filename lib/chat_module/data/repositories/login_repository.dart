import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
import '../../utils/custom_http_client.dart';
import '../../data/models/custom_error.dart';
import '../../data/models/user.dart';
import '../../utils/custom_shared_preferences.dart';
import '../../utils/my_urls.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

export '../../data/models/custom_error.dart' show CustomError;
export '../../data/models/user.dart' show User;


class LoginRepository {
  Future<dynamic> login(String username,BuildContext context) async {
    CustomHttpClient http = CustomHttpClient();
    try {
      RegExp regExp = new RegExp(r"[^0-9]");
      username = username.replaceAll(regExp, '');
      if (username.length == 10) {
        username = '91' + username;
      }
      debugPrint('${MyUrls.serverUrl}/auth');
      final response = await http.post(
        Uri.parse('${MyUrls.serverUrl}/auth'),
        body: jsonEncode({'username': username}),
      );
      final loginResponse = jsonDecode(response.body);
      debugPrint(loginResponse.toString());
      if (loginResponse['error'] != null) {
        return CustomError.fromJson(loginResponse);
      }
      await CustomSharedPreferences.setString(
          'chat_token', loginResponse['token']);

      final User user = User.fromJson(loginResponse['user']);
      await CustomSharedPreferences.setString('user', user.toString());
      debugPrint(await CustomSharedPreferences.get('user'));
      _sendUserLoginEvent(context,user);
      return user;
    } catch (err) {
      debugPrint(err.toString());
      return CustomError(
        error: true,
        errorMessage: "An error has occurred! Try again",
      );
    }
  }
  Future<void> _sendUserLoginEvent(BuildContext context,User user) async {
    FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context,listen:false);
    await analytics.logLogin();
    if(user != null){
      await analytics.setUserId(user.id);
    }

  }
}
