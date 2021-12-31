import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';

class RegisterAPI {
  RegisterAPI._();

  static final RegisterAPI registerApi = RegisterAPI._();

  Repository? _repository;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

/*
  Future<bool> registerUser(SignUpModel signUpModel) async {
    final url = "create/data/v1/register/new/customer";
    final response =
        await postRequest(endpoint: url, body: signUpModel.toJson());
    if (response?.statusCode == 200) {
      debugPrint(response.body);
      return jsonDecode(response.body)['status'];
    }
    return Future.error('Unexpected Error occured');
  } */

  /* Future<bool> checkUserAvailability(String mobile) async {
    Map<String, dynamic> map;
    final url = "create/data/v1/check/registered/customer";
    final response = await postRequest(
      endpoint: url,
      body: {'mobile_no': mobile},
    );
    if (response?.statusCode == 200) {
      debugPrint(response.body);
      map = jsonDecode(response.body);
      if (map['status']) {
        Repository()
            .hiveQueries
            .insertUserData(SignUpModel.fromJson((map['key'] as List).first));
      }
      return map['status'];
    } else if (response?.statusCode == 503)
      return Future.error('Services temporarily unavailable');
    return Future.error('Unexpected Error occured');
  } */

  Future<bool> signUpOtpRequest(String mobileNo) async {
    try {
      _repository = _repository ?? Repository();
    const url = "auth/customer/registeration/request";
    final response =
        await postRequest(endpoint: url, body: {"mobile_no": "$mobileNo"});
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final map = jsonDecode(response.body);
      if (map['status']) {
        if (map['token'] != null)
          _repository!.hiveQueries.insertAuthToken(map['token']);

        print(map['token']);

        // _sendUserRegisterEvent(context,user);
      }
      return map['status'];
    }
    return Future.error(jsonDecode(response.body)['message']);
    } catch (e) {
      return Future.error('Something went wrong. Please try again later.');
    }
    
  }

  Future<String> registerOtpVerification(
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
    const url = "auth/customer/registeration/verify";
    Map bodyMap = {
      "otp": "$otp",
      "token": "${_repository!.hiveQueries.token}",
      "device_name":
      "${Platform.isAndroid ? (await deviceInfo.androidInfo).model : (await deviceInfo.iosInfo).model}",
      "os": "${Platform.isAndroid ? 'Android' : 'IOS'}",
      "fcm_token": await _firebaseMessaging.getToken(),
      "latitude": (lat ?? 0).toString(),
      "longitude": (long ?? 0).toString()
    };
    print(jsonEncode(bodyMap));
    final response = await postRequest(
      endpoint: url,
      body: bodyMap,
    );
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final map = jsonDecode(response.body);
      if (map['referral_code'] != null) {
        debugPrint('Check14' + map['payment_link'].toString());
        debugPrint(
            'Saving while onRegister:' + map['referral_code'].toString());
        _repository!.hiveQueries
            .insertSignUpUserReferralCode(map['referral_code'] ?? '');
        _repository!.hiveQueries
            .insertSignUpUserReferralLink(map['referral_link'] ?? '');
        _repository!.hiveQueries
            .insertSignUpPaymentLink(map['payment_link'] ?? '');
        _repository!.hiveQueries.userData
            .copyWith(paymentLink: map['payment_link'].toString());
      }
      if (map['status']) {
        if (map['token'] != null)
          _repository!.hiveQueries.insertAuthToken(map['token']);
        if (map['chatToken'] != null)
          await CustomSharedPreferences.setString(
              'chat_token', map['chatToken']);
      }
      return map['status'] ? "true" : '';
    }
    print(jsonDecode(response.body)['message'].toString());
    return Future.error(jsonDecode(response.body)['message'].toString());
    } catch (e) {
      return Future.error('Something went wrong. Please try again later.');
    }
  }

/*  Future<bool> updateCustomerDetails(
      String mobileNo, SignUpModel signUpModel) async {
    debugPrint(jsonEncode({
      "filter": {"mobile_no": "$mobileNo"},
      "data": {
        "mobile_no": signUpModel.mobileNo.replaceAll('+', ''),
        "first_name": signUpModel.firstName,
        "last_name": signUpModel.lastName,
        "email": signUpModel.email
      }
    }));
    _repository = _repository ?? Repository();
    const url = "create/data/v1/edit/registered/customer";
    final response = await postRequest(
      endpoint: url,
      headers: apiHeader(),
      body: jsonEncode({
        "filter": {"mobile_no": "$mobileNo"},
        "data": {
          "mobile_no": signUpModel.mobileNo.replaceAll('+', ''),
          "first_name": signUpModel.firstName,
          "last_name": signUpModel.lastName,
          "email": signUpModel.email
        }
      }),
    );
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final map = jsonDecode(response.body);
      return map['status'];
    }
    return Future.error('Unexpected Error occured');
  } */
}
