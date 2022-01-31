import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/chat_module/data/local_database/db_provider.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/extensions.dart';

Future<http.Response> postRequest(
    {String? endpoint,
    String? url,
    dynamic body,
    Encoding? encoding,
    Map<String, String>? headers,
    Duration? timeout}) async {
  debugPrint(url != null ? "$url" : "$baseUrl$endpoint");
  // debugPrint('dattta '+ body);
  // debugPrint('heasers '+ headers.toString());
  final request = await http
      .post(Uri.parse(url != null ? "$url" : "$baseUrl$endpoint"),
          body: body, encoding: encoding, headers: headers)
      .timeout(timeout ?? Duration(seconds: 30))
      .catchError((e) {
    recordError(e.toString(), StackTrace.current);
    if (e is TimeoutException || e is SocketException)
      return http.Response(
          jsonEncode(
              {"message": 'Please check internet connectivity and try again.'}),
          400);
  });
  List<String> skipList = ['auth/customer/verify1','auth/customer/registeration/verify','changePin/verify'];
  if (request.statusCode == 401 && !skipList.contains(endpoint)) {
    logout();
    
  } 
    return request;
  
}

logout() async {
  await Repository().hiveQueries.clearHiveData();
  await Repository().queries.clearULTables();
  await DBProvider.db.clearDatabase();
  await CustomSharedPreferences.setBool('chatSync', false);
  await CustomSharedPreferences.remove('primaryBusiness');
  Repository().hiveQueries.insertUnAuthData(
      Repository().hiveQueries.unAuthData.copyWith(seen: true));
  // await repository.loginApi.logout();
  // restartAppNotifier.value = !restartAppNotifier.value;
  RestartWidget.restartApp(Constants.navigatorKey.currentContext!);
  'Token Expired'.showSnackBar(Constants.navigatorKey.currentContext!);
}

Future<http.Response> getRequest(
    {String? endpoint,
    String? url,
    dynamic body,
    Encoding? encoding,
    Map<String, String>? headers}) async {
  debugPrint("Url is $baseUrl$endpoint");
  final request = await http
      .get(Uri.parse(url != null ? "$url" : "$baseUrl$endpoint"),
          headers: headers)
      .timeout(
        Duration(seconds: 20),
      )
      .catchError((e) {
    debugPrint(e);
    recordError(e.toString(), StackTrace.current);
    return http.Response('', 400);
  });
  return request;
}
