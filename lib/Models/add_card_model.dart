// To parse this JSON data, do
//
//     final cardDetailsModel = cardDetailsModelFromJson(jsonString);

import 'dart:convert';

List<CardDetailsModel> cardDetailsModelFromJson(String str) => List<CardDetailsModel>.from(json.decode(str).map((x) => CardDetailsModel.fromJson(x)));

String cardDetailsModelToJson(List<CardDetailsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CardDetailsModel {
  CardDetailsModel({
    this.id,
    this.title,
    this.expdate,
    this.isdefault,
    this.endNumber,
    this.hashedName,
    this.cardImage,
    this.cardType,
    this.bankName,
  });

  String? id;
  String? title;
  String? expdate;
  dynamic isdefault;
  String? endNumber;
  String? hashedName;
  String? cardImage;
  String? cardType;
  String? bankName;

  factory CardDetailsModel.fromJson(Map<String, dynamic> json) => CardDetailsModel(
    id: json["_id"] == null ? null : json["_id"],
    title: json["title"] == null ? null : json["title"],
    expdate: json["expdate"] == null ? null : json["expdate"],
    isdefault: json["isdefault"] == null ? null : json["isdefault"],
    endNumber: json["endNumber"] == null ? null : json["endNumber"],
    hashedName: json["hashedName"] == null ? null : json["hashedName"],
    cardImage: json["cardImage"] == null ? null : json["cardImage"],
    cardType: json["cardType"] == null ? null : json["cardType"],
    bankName: json["bankName"] == null ? null : json["bankName"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "title": title == null ? null : title,
    "expdate": expdate == null ? null : expdate,
    "isdefault": isdefault == null ? null : isdefault,
    "endNumber": endNumber == null ? null : endNumber,
    "hashedName": hashedName == null ? null : hashedName,
    "cardImage": cardImage == null ? null : cardImage,
    "cardType": cardImage == null ? null : cardType,
    "bankName": bankName == null ? null : bankName,
  };
}
