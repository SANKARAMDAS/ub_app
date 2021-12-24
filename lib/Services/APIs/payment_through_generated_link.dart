import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:urbanledger/Models/generate_link_model.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class PaymentThroughGeneratedLinkAPI {
  PaymentThroughGeneratedLinkAPI._();

  static final PaymentThroughGeneratedLinkAPI generateLinkProvider =
      PaymentThroughGeneratedLinkAPI._();

  Future<GeneratelinkModel> generateLink({required Map paymentDetails}) async {
    GeneratelinkModel generatelinkModel;
    const url = "payment/generate/link";
     debugPrint(paymentDetails.toString());
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeaderWithOnlyToken(),
        body:paymentDetails);
    debugPrint('Status Code: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      debugPrint('Payment : ' + response.body.toString());
      return generatelinkModel = generatelinkModelFromJson(response.body);
    }
    return Future.error('Unexpected Error occured');
  }
}
