// To parse this JSON data, do
//
//     final listOfBankModel = listOfBankModelFromJson(jsonString);

import 'dart:convert';

List<ListOfBankModel> listOfBankModelFromJson(String str) =>
    List<ListOfBankModel>.from(
        json.decode(str).map((x) => ListOfBankModel.fromJson(x)));

String listOfBankModelToJson(List<ListOfBankModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListOfBankModel {
  ListOfBankModel({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory ListOfBankModel.fromJson(Map<String, dynamic> json) =>
      ListOfBankModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
