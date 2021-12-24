import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/screens/AddBankAccount/bankModel.dart';
import 'package:urbanledger/screens/AddBankAccount/saveBankModel.dart';
import 'package:urbanledger/screens/AddBankAccount/userGetBankAccountModel.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';

import '../repository.dart';

class BankAPI {
  BankAPI._();

  static final BankAPI bankProvider = BankAPI._();

  Future getBank() async {
    GetBankModel getBankModel;
    const url = "bankAccount/get";
    final response = await postRequest(
      endpoint: url,
      headers: apiAuthHeader(),
    );
    if (response.statusCode == 200) {
      debugPrint('GetBank : ' + response.body.toString());

      getBankModel = getBankModelFromJson(response.body);

      return getBankModel.data;
    }

    return Future.error('Unexpected Error occured');
  }

  Future getListOfBankFromAPI() async {
    List<ListOfBankModel> model;
    const url = "bankAccount/get-banks-list";
    final response = await postRequest(
      endpoint: url,
      headers: apiAuthHeader(),
    );
    if (response.statusCode == 200) {
      debugPrint('GetBank : ' + response.body.toString());
      model = listOfBankModelFromJson(response.body);
      return model;
    }
    return Future.error('Unexpected Error occured');
  }

  Future<bool> deleteBank(String? bankID) async {
    bool isDeleted = false;
    const url = "bankAccount/delete";
    final response = await postRequest(
      endpoint: url,
      headers: apiAuthHeaderWithOnlyToken(),
      body: {"id": "$bankID"},
    );
    if (response.statusCode == 200) {
      debugPrint('Delete Card : ' + response.body.toString());
      Repository().hiveQueries.insertUserData(Repository()
          .hiveQueries
          .userData
          .copyWith(bankStatus: !(jsonDecode(response.body)['status'])));

      return isDeleted = jsonDecode(response.body)['status'];
    } else
      Future.error('Unexpected Error occured');

    return isDeleted;
  }

  Future<bool> saveBank(
      {required Map Bank, required BuildContext context}) async {
    SaveBankModel saveBankModel;
    const url = "bankAccount/save";
    final response = await postRequest(
        endpoint: url, headers: apiAuthHeaderWithOnlyToken(), body: Bank);
    debugPrint('Status Code: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      debugPrint('Bank Save: ' + response.body.toString());
      saveBankModel = saveBankModelFromJson(response.body);
      var anaylticsEvents = AnalyticsEvents(context);
      await anaylticsEvents.initCurrentUser();
      await anaylticsEvents.sendAddBankEvent(saveBankModel);

      return saveBankModel.status;
    }
    return Future.error('Unexpected Error occured');
  }
}
