import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Models/business_model.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';

class BusinessAPI {
  BusinessAPI._();

  static final BusinessAPI businessApi = BusinessAPI._();

  Future<bool> saveBusiness(BusinessModel businessModel,BuildContext context,bool isInEditMode) async {
    const url = "business/save";
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeader(),
        body: jsonEncode(businessModel.toJson()));
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
      var anaylticsEvents =  AnalyticsEvents(context);
     await anaylticsEvents.initCurrentUser();

      if(isInEditMode){
       await anaylticsEvents.sendEditLedgerEvent(businessModel);
      }else{
       await anaylticsEvents.sendAddLedgerEvent(businessModel);
      }

      final map = jsonDecode(response.body);
      return map['status'];
    }
    return Future.error('Unexpected Error occured');
  }



  Future<List<BusinessModel>> getBusiness() async {
    const url = "business/get";
    final response = await postRequest(
      endpoint: url,
      headers: apiAuthHeader(),
    );
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final list = jsonDecode(response.body) as List;
      return list
          .map((e) => BusinessModel(
              businessId: e['uid'],
              businessName: e['name'],
              deleteAction: e['deleteAction'],
              isChanged: false,
              isDeleted: false))
          .toList();
    }
    return Future.error('Unexpected Error occured');
  }

  Future<bool> deleteBusiness(String businessId,BuildContext context) async {
    const url = "business/delete";
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeader(),
        body: jsonEncode({'id': businessId}));
    if (response.statusCode == 200) {
      debugPrint(response.body);
      var anaylticsEvents =  AnalyticsEvents(context);
      await anaylticsEvents.initCurrentUser();

        await anaylticsEvents.sendDeleteLedgerEvent(businessId);
      final map = jsonDecode(response.body);
      return map['status'];
    }
    return Future.error('Unexpected Error occured');
  }
}
