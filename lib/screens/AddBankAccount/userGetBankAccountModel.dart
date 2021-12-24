// To parse this JSON data, do
//
//     final getBankModel = getBankModelFromJson(jsonString);

import 'dart:convert';

GetBankModel getBankModelFromJson(String str) =>
    GetBankModel.fromJson(json.decode(str));

String getBankModelToJson(GetBankModel data) => json.encode(data.toJson());

class GetBankModel {
  GetBankModel({
    this.status,
    this.data,
  });

  bool? status;
  List<UserBankModel>? data;

  factory GetBankModel.fromJson(Map<String, dynamic> json) => GetBankModel(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null
            ? null
            : List<UserBankModel>.from(
                json["data"].map((x) => UserBankModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class UserBankModel {
  UserBankModel({
    this.id,
    this.accountHoldersName,
    this.selectedBankId,
    this.ibannNumber,
  });

  String? id;
  String? accountHoldersName;
  String? selectedBankId;
  String? ibannNumber;

  factory UserBankModel.fromJson(Map<String, dynamic> json) => UserBankModel(
        id: json["_id"] == null ? null : json["_id"],
        accountHoldersName: json["account_holders_name"] == null
            ? null
            : json["account_holders_name"],
        selectedBankId:
            json["selected_bank_id"] == null ? null : json["selected_bank_id"],
        ibannNumber: json["ibann_number"] == null ? null : json["ibann_number"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "account_holders_name":
            accountHoldersName == null ? null : accountHoldersName,
        "selected_bank_id": selectedBankId == null ? null : selectedBankId,
        "ibann_number": ibannNumber == null ? null : ibannNumber,
      };
}
