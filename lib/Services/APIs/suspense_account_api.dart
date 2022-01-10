import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:urbanledger/Models/SuspenseAccountModel.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class SuspenseAccountApi {
  SuspenseAccountApi._();

  static final SuspenseAccountApi suspenseAccountApi = SuspenseAccountApi._();

  Future<SuspenseAccountModel?> getSuspenseAccount() async {
    SuspenseAccountModel? model;
    const url = "/suspense/suspenseAccount";
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$url'),
        headers: apiAuthHeaderWithOnlyToken(),
      );

      debugPrint('Check SUS' + jsonDecode(response.body).toString());

      model = suspenseAccountModelFromJson(response.body);
      debugPrint('Check API LENGTH' + model.data!.length.toString());
      await Repository().queries.clearSuspenseTable();
      model.data!.forEach((element) async {
        debugPrint('Check11' + element.fromCustId!.id.toString());
        await Repository().queries.insertSuspenseAccount(element);
      }); //insert to DB

      return model;
    } catch (e) {
      //return Future.error('$e');
      return model;
    }
  }

  Future<bool> moveLedger() async {
    bool? status = false;
    const url = "/suspense/movetoledger";

    final response = await http.post(
      Uri.parse('$baseUrl$url'),
      headers: apiAuthHeaderWithOnlyToken(),
    );

    debugPrint('Message' + response.body.toString());

    status = jsonDecode(response.body)['status'] ?? false;
    return status ?? false;
  }

  Future removeFromSuspenseEntry({required List<String>? TransctionIDS}) async {
    const url = "suspense/remove";
    debugPrint('$baseUrl$url');
    print('Ht3' + {"transactionIds": TransctionIDS}.toString());

    try {
      final response = await http.post(
        Uri.parse('$baseUrl$url'),
        headers: apiAuthHeader(),
        body: jsonEncode({"transactionIds": TransctionIDS}),
      );
      debugPrint(response.body.toString());
      debugPrint('Ht4' + jsonEncode(response.body).toString());

      // model = suspenceAccountRemoveModelFromJson();

      if (jsonDecode(response.body)['status'] == true) {
        TransctionIDS!.forEach((element) async {
          await Repository().queries.deleteIsMovedOffline(element);
        });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return Future.error('$e');
    }
  }
}
