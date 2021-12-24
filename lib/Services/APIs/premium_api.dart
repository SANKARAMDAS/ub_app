import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:urbanledger/Models/get_premium_moodel.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class PremiumAPI {
  PremiumAPI._();

  static final PremiumAPI getpremiumplanApi = PremiumAPI._();

  Future<GetPremiumModel?> getPremiumPlan() async {
    GetPremiumModel? model;
    try {
      const url = "subscriptions/getMyPlan";
      debugPrint('$baseUrl$url');
      final response = await http.get(
        Uri.parse('$baseUrl$url'),
        headers: apiAuthHeader(),
      );
      if (response.statusCode == 200) {
        debugPrint('getPremium Plans Response : ' +
            jsonDecode(response.body).toString());
        model = getPremiumModelFromJson(response.body);
        return model;
      } else {
        return Future.error('Unexpected Error Occured');
      }
    } catch (e) {
      return Future.error('$e');
    }
  }
}
