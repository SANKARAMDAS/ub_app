import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:urbanledger/Models/SuspenseAccountModel.dart';
import 'package:urbanledger/Models/settlement_history_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class SettlementHistoryApi {
  SettlementHistoryApi._();

  static final SettlementHistoryApi settlementHistoryApi = SettlementHistoryApi._();

  Future<SettlementHistoryModel?> getSettlementHistory() async {
    SettlementHistoryModel? model;
    const url = "merchant-settlement/merchant";
    print('$baseUrl$url');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$url'),
        headers: apiAuthHeaderWithOnlyToken(),
      );

      debugPrint('Check SUS' + jsonDecode(response.body).toString());

      model = settlementHistoryModelFromJson(response.body);
      debugPrint('Check API LENGTH' + model.data!.length.toString());
      await Repository().queries.clearSettlementHistoryTable();
      model.data!.forEach((element) async {
       // debugPrint('Check11' + element.fromCustId!.id.toString());
        await Repository().queries.insertSettlementHistory(element);
      }); //insert to DB

      return model;
    } catch (e) {
      //return Future.error('$e');
      print(e);
      return model;
    }
  }


}
