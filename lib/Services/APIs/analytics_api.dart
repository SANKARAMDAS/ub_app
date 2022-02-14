import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Models/analytics_model.dart';

class AnalyticsAPI {
  AnalyticsAPI._();

  static final AnalyticsAPI analyticsAPI = AnalyticsAPI._();

  Repository? _repository;

  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  // Future<Datum> getAnalyticsData() async {
  //   try {
  //     _repository = _repository ?? Repository();
  //     const url = "analytics/getAnalytic";
  //     final response = await postRequest(
  //       endpoint: url,
  //       headers: apiAuthHeaderWithOnlyToken(),
  //     );
  //     // debugPrint('qwerty:'+response.body.toString());
  //     Datum analyticsData;
  //     List _list = jsonDecode(response.body)['data'];

  //     for (var i = 0; i < _list.length; i++) {
  //       final data = _list[i];
  //       Map<String, dynamic> json = data;

  //       analyticsData = Datum(
  //           suspense: json["suspense"],
  //           id: json["_id"],
  //           amount: json["amount"],
  //           currency: json["currency"],
  //           urbanledgerId: json["urbanledgerId"],
  //           transactionId: json["transactionId"],
  //           through: json["through"],
  //           type: json["type"],
  //           createdAt: json["createdAt"],
  //           updatedAt: json["updatedAt"],
  //           );
  //       debugPrint('finalData:' + analyticsData.toString());
  //       // final datum = Datum.fromJson(json);

  //       Datum finalData = Datum.fromJson(json);

  //       // if (json['from']['_id'] != json['to']['_id']) {
  //         analyticsData.data.add(finalData);
  //       // }
  //     }
  //     return analyticsData;
  //   } catch (e) {
  //     return Future.error('Something went wrong, Try again.');
  //   }
  // }

  Future<AnalyticsModel?> getAnalyticsData() async {
    // AnalyticsModel? analyticsModel = AnalyticsModel();
    try {
      const url = "analytics/getAnalytic";
      final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeaderWithOnlyToken(),
      );

      if (response.statusCode == 200) {
        // List _list = jsonDecode(response.body)['data'];

        // _list.forEach((element) {
        //   debugPrint(element['_id']);
        //   analyticsModel?.data.add(element);
        // });
        // debugPrint(analyticsModel?.data.toString());
        return analyticsModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (err) {
      // throw CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
      debugPrint(err.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> exportPDF(Map<String, dynamic> data) async {
    try {
      const url = "analytics/exportPdf";
      final response = await postRequest(
          endpoint: url,
          headers: apiAuthHeaderWithOnlyToken(),
          body: data);
      if (response.statusCode == 200) {
        Map<String, dynamic> res = {
          "status": jsonDecode(response.body)['status'],
          "file_name": jsonDecode(response.body)['file_name']
        };
        return res;
      } else {
        Map<String, dynamic> res = {
          "status": false,
          "message": "Something went wrong, Please try again later"
        };
        return res;
      }
    } catch (err) {
      Map<String, dynamic> res = {
          "status": false,
          "message": "Something went wrong, Please try again later"
        };
        return res;
    }
  }
}
