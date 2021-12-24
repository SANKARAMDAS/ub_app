import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class ChangePinAPI {
  ChangePinAPI._();

  static final ChangePinAPI changePinApi = ChangePinAPI._();

  Future<String> changePinRequest() async {
    const url = "changePin/request";
    final response = await postRequest(
      endpoint: url,
      headers: apiAuthHeader(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
      final map = jsonDecode(response.body);
      return map['status'] ? map['changePinToken'] : '';
    }
    return Future.error('Unexpected Error occured');
  }

  Future<bool> verifyChangePin(String token, String otp) async {
    const url = "changePin/verify";
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeader(),
        body: jsonEncode({'changePinToken': token, 'otp': otp}));
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
      final map = jsonDecode(response.body);
      return map['status'];
    } else if (response.statusCode == 401) {
    return Future.error(jsonDecode(response.body)['message']);

    }
    return Future.error('Unexpected Error occured');
  }
}
