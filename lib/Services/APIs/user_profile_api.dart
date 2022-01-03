import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:urbanledger/Models/login_model.dart';
import 'package:urbanledger/Models/user_model.dart';
import 'package:urbanledger/Models/user_profile_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/main.dart';

class UserProfileAPI {
  UserProfileAPI._();

  static final UserProfileAPI userProfileAPI = UserProfileAPI._();

  Future<bool> userProfileApi(
      SignUpModel signUpModel, BuildContext context) async {
    const url = "userProfile/addOrEdit";
    var bodyMap = {
      "first_name": "${signUpModel.firstName}",
      "last_name": "${signUpModel.lastName}",
      "email_id": "${signUpModel.email}"
    };
    final response = await postRequest(
            endpoint: url,
            headers: apiAuthHeaderWithOnlyToken(),
            body: bodyMap);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final map = jsonDecode(response.body);
      LoginModel loginModel = LoginModel(
        userId: map['customerData']['_id'],
        userName: map['customerData']['first_name'] +
            ' ' +
            map['customerData']['last_name'],
        mobileNo: map['customerData']['mobile_no'],
        status: true,
      );
      debugPrint('dddd:' + loginModel.toJson().toString());
      Repository().queries.checkLoginUser(loginModel);
      return map['status'];
    }
    return Future.error('Unexpected Error occured');
  }

  Future<Map<String, dynamic>> userEmailAuthentication(
      String userId, BuildContext context) async {
    const url = "auth/customer/emailverification";
    Map<String, dynamic> bodyData = {"_id": userId};
    Map<String, dynamic> map = {};
    final response = await postRequest(
        endpoint: url,
        // headers: apiAuthHeaderWithOnlyToken(),
        body: bodyData);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      map = jsonDecode(response.body);
    }
    return map;
  }

  Future<bool>? sendDynamicReferralCode(code) async {
    bool? check = false;
    const url = "referral/code";
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeader(),
        body: jsonEncode({"referral_code": "$code"}));
    debugPrint(jsonEncode({"referral_code": "$code"}));

    if (response.statusCode == 200) {
      Repository().hiveQueries.insertDynamicRefferalCode('');
      check = jsonDecode(response.body)['status'] ?? false;
      return check ?? false;
    }
    if (response.statusCode == 500) {
      debugPrint(Future.error('CHECK 500').toString());
      return check;
    } else {
      debugPrint(Future.error('Unexpected Error occured').toString());
      return check;
    }
  }

  Future<UserProfileModel?> getUserProfileApi() async {
    const url = "userProfile/get";
    UserProfileModel? userProfileModel ;
    final responseAPI =
        await postRequest(endpoint: url, headers: apiAuthHeaderWithOnlyToken());

    if (responseAPI.statusCode == 200) {
      debugPrint('Check' + responseAPI.body.toString());
      userProfileModel=  userProfileModelFromJson(responseAPI.body.toString());
    }
    else{
      userProfileModel=null;
    }
    debugPrint(responseAPI.statusCode.toString());
    return userProfileModel;
  }

// Future<dynamic> postUserdata(Map userData) async {
//   debugPrint('user data');
//   debugPrint(userData.toString());
//   // try {
//   //   const url = "userProfile/addOrEdit";

//   //   // final jsonData = jsonEncode(userData);

//   //   final response = await postRequest(
//   //       endpoint: url,
//   //       headers: apiAuthHeader(),
//   //       body: jsonEncode(userData)
//   //     );

//   //     if (response.statusCode == 200) {
//   //       debugPrint(response.body);
//   //        final map = jsonDecode(response.body);
//   //   return map['status'];
//   //     }
//   //   // return [];
//   // } catch (e) {
//   //   debugPrint(e.toString());
//   // }
//   // return [];
// }

}
