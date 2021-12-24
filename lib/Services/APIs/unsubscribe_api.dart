import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:urbanledger/Models/unsubscribe_api.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class UnsubsAPI {
  UnsubsAPI._();

  static final UnsubsAPI unsubsApi = UnsubsAPI._();

  Future<UnsubscribeModel?> putunSubscribePlan() async {
    UnsubscribeModel? model;
    try {
      const url = "subscriptions/unSubscribePlan";
      debugPrint('$baseUrl$url');
      final response = await http.put(
        Uri.parse('$baseUrl$url'),
        headers: apiAuthHeader(),
      );
      if (response.statusCode == 200) {
        debugPrint(
            'UnSubscribe Response : ' + jsonDecode(response.body).toString());
        model = unsubscribeModelFromJson(response.body);
        return model;
      } else {
        return Future.error('Unexpected Error Occured');
      }
    } catch (e) {
      return Future.error('$e');
    }
  }
}
