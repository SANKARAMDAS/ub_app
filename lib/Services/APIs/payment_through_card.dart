import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:urbanledger/Models/startOrderSession_model.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class PaymentThroughCardAPI {
  PaymentThroughCardAPI._();

  static final PaymentThroughCardAPI cardPaymentsProvider =
      PaymentThroughCardAPI._();

  Future paymentThroughCard(Map paymentDetails) async {
    const url = "payment/capture";
    debugPrint('Token Code: ' + apiAuthHeaderWithOnlyToken().toString());

    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeaderWithOnlyToken(),
        body: paymentDetails);
    debugPrint('Status Code: ' + response.statusCode.toString());
    debugPrint('Token Code: ' + apiAuthHeaderWithOnlyToken().toString());

    if (response.statusCode == 200) {
      debugPrint('Payment : ' + response.body.toString());

      return jsonDecode(response.body);
    }
    return Future.error('Unexpected Error occured');
  }

  Future paymentThroughCard2(Map paymentDetails) async {
    const url = "payment/capture/v2";
    debugPrint('Payment Details: ' + jsonEncode(paymentDetails).toString());

    final response = await postRequest(
        endpoint: url,
        timeout: Duration(seconds: 100),
        headers: apiAuthHeaderWithOnlyToken(),
        body: paymentDetails);
    debugPrint('Payment Details: ' + jsonEncode(paymentDetails).toString());
    debugPrint('Payment2 : ' + response.body.toString());
    if (response.statusCode == 200) {
      debugPrint('Payment2 : ' + response.body.toString());

      return jsonDecode(response.body);
    }
    return Future.error('Unexpected Error occured');
  }

  Future cancelOrderSession({orderID}) async {
    const url = "transactions/cancelordersession";

    final response = await postRequest(
      endpoint: url,
      headers: apiAuthHeaderWithOnlyToken(),
      body: jsonEncode(
        {"order_id": "$orderID"},
      ),
    );

    if (response.statusCode == 200) {
      debugPrint('Cancel Order Session : ' + response.body.toString());

      return jsonDecode(response.body);
    }
    return Future.error('Unexpected Error occured');
  }

  Future<StartOrderSessionModel>? startOrderSession(
      {toCustID, through, type, suspense, requestId}) async {
    StartOrderSessionModel model = StartOrderSessionModel();
    const url = "transactions/startordersession";

    debugPrint('Check DATA1' +
        jsonEncode({
          "toCustId": "$toCustID",
          "through": "$through",
          "type": "$type".toString(),
          "payment_request_id": "$requestId",
          'suspense': suspense.toString()
        }));
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeaderWithOnlyToken(),
        body: ({
          "toCustId": "$toCustID",
          "through": "$through",
          "type": "$type",
          "payment_request_id": "$requestId",
          "suspense": '${suspense ?? true}'
        }));
        debugPrint('Order Session STart: ' + response.body.toString());
        debugPrint('Order Session STart: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      debugPrint('Order Session STart: ' + response.body.toString());
      model = startOrderSessionModelFromJson(response.body);
// debugPrint('Order Session STart: ' + StartOrderSessionModel.fromJson(jsonDecode(response.body)).toJson().toString());
      return model;
    }
    Future.error('Unexpected Error occured');
    return model;
  }
}
