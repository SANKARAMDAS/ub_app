import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:urbanledger/Models/login_model.dart';
import 'package:urbanledger/Models/user_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';

import '../../main.dart';

class LoginAPI {
  LoginAPI._();

  static final LoginAPI loginApi = LoginAPI._();

  Repository? _repository;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<bool> loginOtpRequest(String mobileNo) async {
    try {
      _repository = _repository ?? Repository();
      const url = "auth/customer/verification/request";
      final response =
          await postRequest(endpoint: url, body: {"mobile_no": "$mobileNo"});
      if (response.statusCode == 200) {
        final map = jsonDecode(response.body);
        if (map['status']) {
          if (map['token'] != null)
            _repository!.hiveQueries.insertAuthToken(map['token']);
        }
        return map['status'];
      }
      return Future.error(jsonDecode(response.body)['message'].toString());
    } catch (e) {
      return Future.error('Please check your internet connection or try again later.');
    }
  }

  Future<String> loginOtpVerification(
      String otp, double? lat, double? long) async {
    ///Sample Request Json :
    /* {
  "otp": "1234",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGVfbm8iOiI5OTY3ODY3NTk4IiwiaWF0IjoxNjE3MjU2NzQ1LCJleHAiOjE2MTcyNTczNDV9.SEB0R_DiSbidBFb5t9kxQWghMK75Y8W5zwhM_oBCC-8",
  "latitude":"",
  "longitude":"",
  "os":"",
  "device_name":"",
  "fcm_token":""
} */

//TODO: To update the request json when location and fcm is setup
    try {
      _repository = _repository ?? Repository();
      String filePath = '';
      const url = "auth/customer/verify1";
      final response = await postRequest(
        endpoint: url,
        body: {
          "otp": "$otp",
          "token": "${_repository!.hiveQueries.token}",
          "device_name":
              "${Platform.isAndroid ? (await deviceInfo.androidInfo).model : (await deviceInfo.iosInfo).model}",
          "os": "${Platform.isAndroid ? 'Android' : 'IOS'}",
          "fcm_token": await _firebaseMessaging.getToken(),
          "latitude": (lat ?? 0).toString(),
          "longitude": (long ?? 0).toString()
        },
      );
      if (response.statusCode == 200) {
        debugPrint(response.body);
        final map = jsonDecode(response.body);
        debugPrint('Checking link' +
            map['customerDetails']['referral_code'].toString());
        debugPrint('Check15' + map['customerDetails'].toString());
        debugPrint(
            'Check16' + '${repository.hiveQueries.userData.paymentLink}');

        if (map['status']) {
          if (map['token'] != null)
            _repository!.hiveQueries.insertAuthToken(map['token']);
          if (map['chatToken'] != null)
            await CustomSharedPreferences.setString(
                'chat_token', map['chatToken']);
          if (map['customerDetails']['profilePic'] != null) {
            if (map['customerDetails']['profilePic'].toString().isNotEmpty) {
              filePath = await _repository!.ledgerApi
                  .networkImageToFile(map['customerDetails']['profilePic']);
            }
          }
          LoginModel loginModel = LoginModel(
            userId: map['customerDetails']['_id'],
            userName: map['customerDetails']['first_name'] +
                ' ' +
                map['customerDetails']['last_name'],
            mobileNo: map['customerDetails']['mobile_no'],
            status: true,
          );
          _repository!.hiveQueries.setPinStatus(true);
            _repository!.hiveQueries.setFingerPrintStatus(true);
          repository.queries.checkLoginUser(loginModel);
          _repository!.hiveQueries.insertUserData(SignUpModel.fromJson(
              map['customerDetails'], filePath,
              bankStatus: map['bankStatus'] ?? false,
              kycExpDate: map['kycExpDate'] ?? '',
              kycStatus: map['kycStatus'] ?? 0,
              premiumExpDate: map['premiumExpDate'] ?? '',
              premiumStatus: map['premiumStatus'] ?? 0,
              isEmiratesIdDone: map['tl'] ?? false,
              isTradeLicenseDone: map['emirates'] ?? false,
              paymentLink: map['link'] ??
                  '${repository.hiveQueries.userData.paymentLink}',
              referral_code: map['customerDetails']['referral_code'] ?? '',
              referral_link: map['customerDetails']['referral_link'] ?? '',
              email_status: map['customerDetails']['email_status'] ?? false,
              id: map['customerDetails']['_id']),
            );
        }
        return map['customerDetails']['first_name'] ?? '';
      }
      return Future.error(jsonDecode(response.body)['message']);
    } catch (e) {
      return Future.error('Please check your internet connection or try again later.');
    }
  }

  Future<bool> logout() async {
    const url = "auth/customer/logout";
    final response = await postRequest(
      endpoint: url,
    );
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final map = jsonDecode(response.body);
      return map['status'];
    }
    return Future.error(jsonDecode(response.body)['message']);
  }
}
