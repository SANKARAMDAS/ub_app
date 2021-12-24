import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class PaymentThroughQRAPI {
  PaymentThroughQRAPI._();

  static final PaymentThroughQRAPI paymentThroughQRApi =
      PaymentThroughQRAPI._();

  Repository? _repository;

  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<List> sendQRData(Map data) async {
    try {
      _repository = _repository ?? Repository();
      const url = "payment/request/qr";
      final jsonData = (data);
      final response = await postRequest(
          endpoint: url, headers: apiAuthHeaderWithOnlyToken(), body: jsonData);
      var map = (response.body.split('/').last);
      final responseAPI = await getRequest(endpoint: url + '/' + map);
      return [map, responseAPI.bodyBytes];
    } catch (e) {
      return Future.error('Something went wrong, Try again.');
    }
  }

  Future<dynamic> getQRCode() async {
    try {
      _repository = _repository ?? Repository();
      const url = "auth/customer/generate-user-qr-code";
      final response = await getRequest(
          endpoint: url, headers: apiAuthHeaderWithOnlyToken());
      return response.bodyBytes;
    } catch (e) {
      return Future.error('Something went wrong, Try again.');
    }
  }

  Future<dynamic> getQRData(String data) async {
    try {
      _repository = _repository ?? Repository();
      const url = "payment/request/qr/process/data";
      // var map = jsonDecode(data);
      Map<String, String> jsonData = {"requestid": "$data"};
      debugPrint('json Data' + jsonData.toString());
      final response = await postRequest(endpoint: url, body: (jsonData));
      debugPrint('Data' + response.toString());

      var map2 = jsonDecode(response.body);
      debugPrint('Data2' + map2.toString());

      return map2;
    } catch (e) {
      return Future.error('Something went wrong, Try again.');
    }
  }

  Future<dynamic> getStaticQRData(String data) async {
    try {
      _repository = _repository ?? Repository();
      debugPrint('ss : ' + data.toString());
      const url = "customerProfile/getcustomerinfobyid";
      final jsonData = jsonEncode({"customer_id": data.toString()});
      final response = await postRequest(
          endpoint: url, headers: apiAuthHeader(), body: jsonData);
      // final response = await http.post(
      //   Uri.parse(url),
      //   headers: apiAuthHeader(),
      //   body: jsonData,
      // );
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        var map2 = jsonDecode(response.body);
        return map2;
      } else {
        return Future.error('Something went wrong, Try again.');
      }
    } catch (e) {
      return Future.error('Something went wrong, Try again.');
    }
  }

  Future<dynamic> getQRGalleryData(String data) async {
    try {
      debugPrint('qqw f : ' + data.toString());
      _repository = _repository ?? Repository();
      const url = "merchant/qrcode-read/";
      // var map = jsonDecode(data);
      // Map<String, String> jsonData = {"requestid": "$data"};
      // debugPrint('json Data' + jsonData.toString());
      final response =
          await getRequest(endpoint: url + data, headers: apiAuthHeader());
      debugPrint('Data' + response.toString());

      var map2 = jsonDecode(response.body);
      debugPrint('Data2' + map2.toString());

      return map2;
    } catch (e) {
      return Future.error('Something went wrong, Try again.');
    }
  }

  Future<dynamic> getRequestId(Map<String, dynamic> data) async {
    try {
      const url = "payment/request/qr";
      final jsonData = jsonEncode(data);
      final response = await postRequest(
          endpoint: url, headers: apiAuthHeader(), body: jsonData);
      // debugPrint(response.body.toString());
      final map = (response.body.split('/').last);
      debugPrint('mapiiinnnf');
      debugPrint(map);
      // final responseAPI = await getRequest(endpoint: url + '/' + map);
      return map;
    } catch (e) {
      return Future.error('Something went wrong, Try again.');
    }
  }

  Future<Map<String, dynamic>> getTransactionLimit(BuildContext context) async {
    try {
      const url = "transactions/limit";
      final response =
          await getRequest(endpoint: url, headers: apiAuthHeader()).timeout(Duration(seconds: 30), onTimeout: () async {
            Navigator.of(context).pop();
            return Future.value(null);
          });
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return Future.error('Something went wrong, Try again.');
      }
    } catch (e) {
      return Future.error('Something went wrong, Try again.');
    }
  }

  Future<dynamic> uploadQRFile(String data) async {
    try {
      const url = "payment/request/readqrcode";
      Map<String, String> jsonData = {"qrcode": "$data"};
      final response = await postRequest(
          endpoint: url, headers: apiAuthHeader(), body: jsonData);
      var map2 = jsonDecode(response.body);
      return map2;
    } catch (e) {
      return Future.error('Something went wrong, Try again.');
    }
  }
}
