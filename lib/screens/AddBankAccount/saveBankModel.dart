// To parse this JSON data, do
//
//     final saveBankModel = saveBankModelFromJson(jsonString);

import 'dart:convert';

SaveBankModel saveBankModelFromJson(String str) =>
    SaveBankModel.fromJson(json.decode(str));

String saveBankModelToJson(SaveBankModel data) => json.encode(data.toJson());

class SaveBankModel {
  SaveBankModel({
    required this.status,
    required this.statuscode,
    required this.id,
  });

  bool status;
  int statuscode;
  String id;

  factory SaveBankModel.fromJson(Map<String, dynamic> json) => SaveBankModel(
        status: json["status"] == null ? null : json["status"],
        statuscode: json["statuscode"] == null ? null : json["statuscode"],
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "statuscode": statuscode == null ? null : statuscode,
        "id": id == null ? null : id,
      };
}
