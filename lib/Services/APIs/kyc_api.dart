import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:urbanledger/Models/kyc_emirates_id.dart';
import 'package:urbanledger/Models/trade_license_pdf_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_services.dart';

class KycAPI {
  KycAPI._();

  static final KycAPI kycApiProvider = KycAPI._();

  bool isPremium = false;

  Future KycEmiratedID({String? path}) async {
    debugPrint('kyc emirated id path ' + path.toString());

    KycEmiratesIdModel model;
    // const url = "customer/kyc/emirtes_id/eng+ara/";
    const url = "customer-kyc-new/add-emirates-id";
    debugPrint(baseUrl + url);

    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + url));
    request.files
        .add(await http.MultipartFile.fromPath('file', path.toString()));
    request.headers.addAll(apiAuthHeaderWithOnlyToken());

    final _streamResponse = await request.send();
    final response = await http.Response.fromStream(_streamResponse);
    debugPrint(response.statusCode.toString());
    debugPrint(response.body.toString());

    if (response.statusCode == 200) {
      debugPrint(response.body);
      isPremium = jsonDecode(response.body)['premium'] ?? false;

      debugPrint('isPremium: ' + isPremium.toString());
      Repository().hiveQueries.insertUserData(
            Repository().hiveQueries.userData.copyWith(
                  kycID: jsonDecode(response.body)['kycId'].toString(),
                ),
          );
      return jsonDecode(response.body);
    } else {
      Future.error('Unexpected Error occured');

      return jsonDecode(response.body);
    }
  }

  Future KycTradeLicsense({required String path}) async {
    debugPrint('kyc Trade License path ' + path.toString());

    // const url = "customer-kyc/trade-liscence";
    const url_new = "customer-kyc-new/add-trade-liscence";
    Map<String, String> requestBody = <String,String>{
      'kycId':"${Repository().hiveQueries.userData.kycID}"
    };
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + url_new))
    ..files
        .add(await http.MultipartFile.fromPath('file', path.toString()))
    ..fields.addAll(requestBody)
    ..headers.addAll(apiAuthHeaderWithOnlyToken());

    final _streamResponse = await request.send();
    final response = await http.Response.fromStream(_streamResponse);
    debugPrint(response.statusCode.toString());
    debugPrint(response.body.toString());

    if (response.statusCode == 200) {
      debugPrint('wwwww'+response.body);

      return jsonDecode(response.body);
    } else {
      Future.error('Unexpected Error occured');

      return jsonDecode(response.body);
    }
  }

  //customer-kyc/check-kyc-status

  Future kycCheker() async {
    const url = "customer-kyc/check-kyc-status";
    debugPrint('Token Code: ' + apiAuthHeaderWithOnlyToken().toString());

    final response = await postRequest(
      endpoint: url,
      headers: apiAuthHeaderWithOnlyToken(),
    );
    debugPrint('Status Code: ' + response.statusCode.toString());
    debugPrint('Token Code: ' + apiAuthHeaderWithOnlyToken().toString());

    if (response.statusCode == 200) {
      debugPrint('kyc Checker : ' + response.body.toString());

      return jsonDecode(response.body);
    }
    return Future.error('Unexpected Error occured');
  }

  Future sLogin() async {
    final response = await postRequest(
      url: 'https://preproduction.signzy.tech/api/v2/patrons/login',
      body: {"username": "vervali_test", "password": "XZ4BQdbbFldD7Fyeg8E2"},
    );
    debugPrint('Status Code: ' + response.statusCode.toString());

    if (response.statusCode == 200) {
      debugPrint('Signzy Login : ' + response.body.toString());

      return (response.body).toString();
    }
    return Future.error('Unexpected Error occured');
  }

  Future PdfToImage(userID, pdfLink, id, ttl) async {
    var headers = {'Authorization': '$id', 'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://preproduction.signzy.tech/api/v2/patrons/$userID/converters'));
    request.body = json.encode({
      "task": "pdftojpg",
      "essentials": {
        "urls": ["$pdfLink"],
        "ttl": "$ttl"
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      TradeLicensePdfModel tpf =
          tradeLicensePdfModelFromJson(await response.stream.bytesToString());
      return tpf;
    } else {
      print(response.reasonPhrase);
      return response.statusCode;
    }
  }
}
