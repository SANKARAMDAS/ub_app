import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/customer_profile_model.dart';
import 'package:urbanledger/Models/get_contact_profile_by_mobile_no_model.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';

class CustomerAPI {
  CustomerAPI._();

  static final CustomerAPI customerApi = CustomerAPI._();

  Future<bool> saveCustomer(CustomerModel customerModel, BuildContext context,
      AddCustomers eventType) async {
    debugPrint('customer data : ' + customerModel.toJson().toString());
    try {
      const url = "contact/save";
      final response = await postRequest(
              endpoint: url,
              headers: apiAuthHeader(),
              body: jsonEncode(customerModel.toJson()))
          .timeout(Duration(seconds: 30), onTimeout: () async {
        Navigator.of(context).pop();
        return Future.value(null);
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Saving response: ' + response.body.toString());
        // var anaylticsEvents = AnalyticsEvents(context);
        // await anaylticsEvents.initCurrentUser();
        // await anaylticsEvents.sendAddCustomerEvent(customerModel, eventType);
        final map = jsonDecode(response.body);
        return map['status'];
      } else {
        return Future.error('Something went wrong.');
      }
    } catch (e) {
      debugPrint('ssd: ' + e.toString());
      return Future.error('${e.toString()}');
    }
  }

  Future<List<CustomerModel>> getAllCustomers(String businessId) async {
    const url = "contact/get";
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeader(),
        body: jsonEncode({'business': businessId}));
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return parseCustomersJson(jsonDecode(response.body));
    }
    return Future.error('Unexpected Error occured');
  }

  List<CustomerModel> parseCustomersJson(List<dynamic> list) {
    final List<CustomerModel> _parsedList = list.map((e) {
      return CustomerModel()
        ..customerId = e['id'] as String?
        ..name = e['name'] as String?
        ..mobileNo = e['mobilenumber'] as String?
        ..chatId = e['chat_id'] as String?
        ..avatar = null
        ..transactionAmount =
            double.tryParse((e['ledger']['amount']).toString()) ?? 0
        ..transactionType = e['ledger']['type'] == 'Credit'
            ? TransactionType.Receive
            : e['ledger']['type'] == 'Debit'
                ? TransactionType.Pay
                : null
        ..updatedAt =
            DateTime.tryParse(e['updatedAt']) ?? DateTime.now()
        ..createdDate = e['createdDate'] != null
            ? DateTime.tryParse(e['createdDate']) ?? DateTime.now()
            : DateTime.now()
        ..businessId = e['business']
        ..isDeleted = false
        ..isChanged = false;
    }).toList();
    return _parsedList;
  }

  Future<bool> deletedCustomer(String customerId, String businessId) async {
    const url = "contact/delete";
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeader(),
        body: jsonEncode({"id": "$customerId", "business": "$businessId"}));
    if (response.statusCode == 200 || response.statusCode == 201) {
      final map = jsonDecode(response.body);
      return map['status'];
    }
    return Future.error('Unexpected Error occured');
  }

  Future<GetContactProfilebyMobileNoModel> getCustomerID(
      {mobileNumber, context}) async {
    GetContactProfilebyMobileNoModel contactProfilebyMobileNoModel;
    const url = "contact/profile";
    final response = await postRequest(
            endpoint: url,
            headers: apiAuthHeaderWithOnlyToken(),
            body: {"mobilenumber": "$mobileNumber"});
    //     .timeout(Duration(seconds: 30), onTimeout: () async {
    //   Navigator.of(context).pop();
    //   return Future.value(null);
    // });
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return contactProfilebyMobileNoModel =
          getContactProfilebyMobileNoModelFromJson((response.body));
    }
    return Future.error('Unexpected Error occured');
  }

  Future<String> getContactProfileByMobileNo(String mobileNo) async {
    const url = "contact/profile";
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeader(),
        body: jsonEncode({"mobilenumber": mobileNo}));
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return (jsonDecode(response.body))['customer_info']['id'];
    }
    return Future.error('Unexpected Error occured');
  }

  Future<dynamic> saveUpdateCustomer(CustomerProfileModel data) async {
    debugPrint(data.toJson().toString());
    try {
      const url = "customerProfile/addOrEdit";
      final response = await postRequest(
          headers: apiAuthHeader(),
          endpoint: url,
          body: data.toRawJson().toString());
      debugPrint(apiAuthHeader().toString());
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      return Future.error('Something went wrong, Try again.');
    }
  }

  Future<String> getCustomerDetails(String? uid) async {
    try {
      const url = "customerProfile/get";
      final response = await postRequest(
          endpoint: url,
          headers: apiAuthHeader(),
          body: jsonEncode({'uid': uid}));
      if (response.statusCode == 200) {
        debugPrint(response.body.toString());
        return response.body;
      }
      return response.body;
    } catch (e) {
      return Future.error('Something went wrong, Try again.');
    }
  }

  /* Future<String> deleteCustomer(String uid) async {
    try {
      const url = "customerProfile/delete";
      final response = await postRequest(
          endpoint: url,
          headers: apiAuthHeader(),
          body: jsonEncode({'uid': uid}));
      if (response.statusCode == 200) {
        debugPrint(response.body.toString());
        return response.body;
      }
      return response.body;
    } catch (e) {
      return Future.error('Something went wrong, Try again.');
    }
  } */

  Future<List<dynamic>> contactSync(List<String> mobileNos) async {
    const url = "contact/sync";
    final List<Map> mobileList =
        mobileNos.map((e) => {'mobile_no': e}).toList();
    debugPrint(mobileList.toString());
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeader(),
        body: jsonEncode({"contacts": mobileList}),
        timeout: Duration(minutes: 10));
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body.toString());
      final List<dynamic> map = jsonDecode(response.body);
      return map;
    }
    return Future.error('Unexpected Error occured');
  }
}
