import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:urbanledger/Models/cashbook_entry_model.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_services.dart';

class CashbookAPI {
  CashbookAPI._();

  static final CashbookAPI cashbookApi = CashbookAPI._();

  Future<bool> saveCashbookEntry(CashbookEntryModel cashbookEntryModel) async {
    const url = "cashbook/saveOrUpdate";
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeader(),
        body: jsonEncode(cashbookEntryModel.toJson()));
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
      final map = jsonDecode(response.body);
      return map['status'];
    }
    return Future.error('Unexpected Error occured');
  }

  Future<bool> deleteCashbookEntry(String entryId) async {
    const url = "cashbook/delete";
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeader(),
        body: jsonEncode({'entryId': entryId}));
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final map = jsonDecode(response.body);
      return map['status'];
    }
    return Future.error('Unexpected Error occured');
  }

  Future<List<CashbookEntryModel>> getCashbookEntries(String businessId) async {
    const url = "cashbook/get";
    final response = await postRequest(
      endpoint: url,
      headers: apiAuthHeader(),
    );
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final list = jsonDecode(response.body) as List;
      return await Future.wait(list.map((e) async {
        return await addAttachmentsToModel(
            CashbookEntryModel(
                entryId: e['entryId'],
                businessId: e['businessId'],
                amount: double.tryParse(e['amount'].toString()) ?? 0,
                details: e['details'],
                createdDate: DateTime.parse(e['updatedAt']),
                entryType:
                    e['entryType'] == 'IN' ? EntryType.IN : EntryType.OUT,
                paymentMode: e['paymentMode'] == 'cash'
                    ? PaymentMode.Cash
                    : PaymentMode.Online,
                isChanged: false,
                isDeleted: false),
            e['bills'] as List);
      }).toList());
    }
    return Future.error('Unexpected Error occured');
  }

  Future<CashbookEntryModel> addAttachmentsToModel(
      CashbookEntryModel cashbookEntryModel, List bills) async {
    cashbookEntryModel
        .copyWith(attachments: [...(await getFilePathsList(bills))]);
    return cashbookEntryModel;
  }

  Future<String> networkImageToFile(String fileName) async {
    var response = await http.get(Uri.parse(baseImageUrl + fileName));
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    File file = File(join(documentDirectory.path, fileName));
    file.writeAsBytesSync(response.bodyBytes);
    return file.path;
  }

  Future<List<String>> getFilePathsList(List fileNames) async {
    List<String> names = [];
    for (var name in fileNames) {
      names.add((await networkImageToFile(name)));
    }
    return names;
  }
}
