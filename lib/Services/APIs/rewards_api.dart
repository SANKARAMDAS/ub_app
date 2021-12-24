import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:urbanledger/Models/rewards.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class RewardsApi {
  RewardsApi._();

  static final RewardsApi rewardsApi = RewardsApi._();

  Future<GetRewards?>? getRewardsOfUsers() async {
    GetRewards? model;
    try {
      debugPrint('RewardsApi');

      const url = "referral/customer";
      debugPrint('$baseUrl$url');
      final response = await http.get(
        Uri.parse('$baseUrl$url'),
        headers: apiAuthHeader(),
      );
      if (response.statusCode == 200) {
        debugPrint('Successful fetching rewards : ' +
            jsonDecode(response.body).toString());
        model = getRewardsFromJson(response.body.toString());
        debugPrint('Total Rewards fetched: ' + model.data!.length.toString());
        return model;
      } else {
        return model;
      }
    } catch (e) {
      return Future.error('$e');
    }
  }

  Future<String> triggerNotification(String customerId) async {
    try {
      const url = "referral/notification";
      debugPrint('$baseUrl$url');
      final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeader(),
        body: jsonEncode({
          "notify_to": "$customerId",
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else {
        return Future.error('Unexpected Error Occured');
      }
    } catch (e) {
      return Future.error('$e');
    }
  }

  Future<String> getReferalMessage() async {
    try {
      const url = "referral/message";
      debugPrint('$baseUrl$url');
      final response = await http.get(
        Uri.parse('$baseUrl$url'),
        headers: apiAuthHeader(),
      );
      if (response.statusCode == 200) {
        debugPrint(jsonDecode(response.body).toString());
        return jsonDecode(response.body)['message'];
      } else {
        return Future.error('Unexpected Error Occured');
      }
    } catch (e) {
      return Future.error('$e');
    }
  }

  // Future<String> triggerNotification(String customerId) async {
  //   try {
  //     const url = "referral/notification";
  //     debugPrint('$baseUrl$url');
  //     final response = await postRequest(
  //       endpoint: url,
  //       headers: apiAuthHeader(),
  //       body: jsonEncode({
  //         "notify_to": "$customerId",
  //       }),
  //     );
  //     if (response.statusCode == 200) {
  //       return jsonDecode(response.body)['message'];
  //     } else {
  //       return Future.error('Unexpected Error Occured');
  //     }
  //   } catch (e) {
  //     return Future.error('$e');
  //   }
  // }
}
