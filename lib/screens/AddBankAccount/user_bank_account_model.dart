// To parse this JSON data, do
//
//     final userBankAccountModel = userBankAccountModelFromJson(jsonString);

import 'dart:convert';

UserBankAccountModel userBankAccountModelFromJson(String str) =>
    UserBankAccountModel.fromJson(json.decode(str));

String userBankAccountModelToJson(UserBankAccountModel data) =>
    json.encode(data.toJson());

class UserBankAccountModel {
  UserBankAccountModel({
    this.accountHolderName,
    this.bankId,
    this.iBanNumber,
    this.selectBankName,
  });

  String? accountHolderName;
  int? bankId;
  String? iBanNumber;
  String? selectBankName;

  factory UserBankAccountModel.fromJson(Map<String, dynamic> json) =>
      UserBankAccountModel(
        accountHolderName: json["AccountHolderName"],
        bankId: json["bank_id"],
        iBanNumber: json["IBanNumber"],
        selectBankName: json["selectBankName"],
      );

  Map<String, dynamic> toJson() => {
        "AccountHolderName": accountHolderName,
        "bank_id": bankId,
        "IBanNumber": iBanNumber,
        "selectBankName": selectBankName,
      };
}
