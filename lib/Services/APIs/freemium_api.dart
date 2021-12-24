import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:urbanledger/Models/PremiumPurchaseTrackingModel.dart';
import 'package:urbanledger/Models/plan_model.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class FreemiumAPI {
  FreemiumAPI._();

  static final FreemiumAPI freemiumApi = FreemiumAPI._();

  Future<List<PlanModel>> getPremiumPlans() async {
    const url = "subscriptions/getPlans";
    final response = await getRequest(
      endpoint: url,
      headers: apiAuthHeader(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return parsePlanJson(jsonDecode(response.body)['plans']);
    }
    return Future.error('Unexpected Error occured');
  }

  List<PlanModel> parsePlanJson(List<dynamic> list) {
    final List<PlanModel> _parsedList = list.map((e) {
      return PlanModel(
        activeStatus: e['activeStatus'],
        id: e['_id'],
        name: e['name'],
        amount: e['amount'],
        discount: e['discount'],
        days: e['days'],
      );
    }).toList();
    return _parsedList;
  }

  Future purchaseSubscriptionPlan(Map<String, dynamic> data) async {
    try {
      const url = "subscriptions/purchaseSubscriptionPlan";
      final response = await postRequest(
          endpoint: url, headers: apiAuthHeader(), body: jsonEncode(data));
      debugPrint('Response from Purchase' + response.body.toString());
      if (response.statusCode == 200) {
        debugPrint('plan1 :' + jsonDecode(response.body)['status'].toString());
        return jsonDecode(response.body);
      } else {
        debugPrint('plan2 :' + jsonDecode(response.body)['status'].toString());
        return jsonDecode(response.body);
      }
    } catch (e) {
      return Future.error('$e');
    }
  }

  Future cancelOrderSessionPremiumPLan({orderID}) async {
    const url = "transactions/cancelordersession";
    debugPrint('Order ID FOR PP' + '$orderID');
    final response = await postRequest(
      endpoint: url,
      headers: apiAuthHeaderWithOnlyToken(),
      body: {"order_id": "$orderID", "order_type": "subscription"},
    );

    if (response.statusCode == 200) {
      debugPrint('Cancel Order Session : ' + response.body.toString());

      return jsonDecode(response.body);
    }
    return Future.error('Unexpected Error occured');
  }

  Future<PremiumStartOrderSession>? startOrderSessionPremiumPLan() async {
    PremiumStartOrderSession model = PremiumStartOrderSession();
    const url = "transactions/startordersession";

    // debugPrint('Check DATA1' +
    //     jsonEncode({
    //       "toCustId": "6135f1811765c961853165e3",
    //       "through": "DIRECT",
    //       "type": "DIRECT",
    //       "order_type": "subscription"
    //     }));
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeaderWithOnlyToken(),
        body: ({
          "toCustId": "6135f1811765c961853165e3",
          "through": "DIRECT",
          "type": "DIRECT",
          "order_type": "subscription"
        }));

    if (response.statusCode == 200) {
      debugPrint(
          'Order Session STart Premium PLan: ' + response.body.toString());
      model = premiumStartOrderSessionFromJson(response.body);

      return model;
    }
    Future.error('Unexpected Error occured');
    return model;
  }
}
