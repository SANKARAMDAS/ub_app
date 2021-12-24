import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class LedgerAPI {
  LedgerAPI._();

  static final LedgerAPI ledgerApi = LedgerAPI._();

  Future<bool> saveTransaction(TransactionModel transactionModel) async {
    const url = "ledger/save";
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeader(),
        body: jsonEncode(transactionModel.toJson()));
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
      final map = jsonDecode(response.body);
      return map['status'];
    }
    return Future.error('Unexpected Error occured');
  }

  Future<bool> updateLedger(TransactionModel transactionModel) async {
    const url = "ledger/update";
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeader(),
        body: jsonEncode(transactionModel.toJson()));
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final map = jsonDecode(response.body);
      return map['status'];
    }
    return Future.error('Unexpected Error occured');
  }

  Future<bool> deleteLedger(String transactionId, String balanceAmount) async {
    const url = "ledger/delete";
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeader(),
        body:
            jsonEncode({'id': transactionId, 'balanceAmount': balanceAmount}));
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final map = jsonDecode(response.body);
      return map['status'];
    }
    return Future.error('Unexpected Error occured');
  }

  Future<List<TransactionModel>> getLedger(String? contactId) async {
    const url = "ledger/get?sortBy=trans_date&sortOrder=desc";
    final response = await postRequest(
        endpoint: url,
        headers: apiAuthHeader(),
        body: jsonEncode({'contact_id': contactId}));
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final list = jsonDecode(response.body) as List;
      return await Future.wait(list.map((e) async {
        return await addAttachmentsToModel(
            TransactionModel()
              ..transactionId = e['uid']
              ..customerId = e['contact_id']
              ..amount = double.tryParse(e['amount'].toString()) ?? 0
              ..details = e['desc'] ?? ''
              ..date = DateTime.parse(
                  (e['trans_date']).toString().replaceAll('Z', ''))
              ..transactionType = e['type'] == 'CR'
                  ? TransactionType.Receive
                  : e['type'] == 'DR'
                      ? TransactionType.Pay
                      : null
              ..balanceAmount = (e['balanceAmount']).toDouble()
              ..paymentTransactionId = (e['paymentTransactionId']) ?? ''
              ..isPayment = (e['isPayment']) ?? false
              ..isChanged = false
              ..isDeleted = false
              ..business = e['business'], //todoadd column
            e['bills'] as List);
      }).toList());
    }
    return [];
  }

  Future<String> uploadAttachment(String path) async {
    const url = "image/upload";
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + url));
    request.files.add(await http.MultipartFile.fromPath('image', path));
    final _streamResponse = await request.send();
    final response = await http.Response.fromStream(_streamResponse);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final map = jsonDecode(response.body);
      return map['status'] ? map['file_name'] : null;
    }
    return Future.error('Unexpected Error occured');
  }

  Future<TransactionModel> addAttachmentsToModel(
      TransactionModel transactionModel, List bills) async {
    transactionModel.attachments.addAll([...(await getFilePathsList(bills))]);
    return transactionModel;
  }

  Future<String> networkImageToFile(String fileName) async {
    var response = await http
        .get(Uri.parse(baseImageUrl + fileName.trim().replaceAll(' ', '')));
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    File file = File(join(documentDirectory.path, fileName));
    file.writeAsBytesSync(response.bodyBytes);
    return file.path;
  }

  Future<String> networkImageToFile2(String fileName) async {
    var response = await http.get(Uri.parse(baseImageUrl + fileName));
    var documentDirectory = await (getExternalStorageDirectory());
    String path = documentDirectory!.path + "/filereader/files/";
    // Directory documentDirectory = await getApplicationDocumentsDirectory();
    // File file = File(join(path, fileName));
    File file = File(join(path, fileName));
    await file.create(recursive: true);
    // debugPrint('asdfg'+file.path);
    file.writeAsBytesSync(response.bodyBytes);
    return file.path;
  }

  Future<String> networkImageToFile3(String fileName) async {
    var response = await http.get(Uri.parse(fileName));
    var documentDirectory = await (getExternalStorageDirectory());
    String path = documentDirectory!.path + "/filereader/files/";
    // Directory documentDirectory = await getApplicationDocumentsDirectory();
    // File file = File(join(path, fileName));
    File file = File(join(path, fileName));
    await file.create(recursive: true);
    debugPrint('asdfg' + file.path);
    file.writeAsBytesSync(response.bodyBytes);
    return file.path;
  }

  Future<dynamic> networkAudio(String fileName) async {
    var response = await http.get(Uri.parse(baseImageUrl + fileName));
    var documentDirectory;
    if (Platform.isAndroid) {
      documentDirectory = await (getExternalStorageDirectory());
    } else {
      documentDirectory = await (getApplicationDocumentsDirectory());
    }
    String path = documentDirectory!.path;
    // Directory documentDirectory = await getApplicationDocumentsDirectory();
    // File file = File(join(path, fileName));
    File file = File(join(path, fileName));
    await file.create(recursive: true);
    // debugPrint('asdfg'+file.path);
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
