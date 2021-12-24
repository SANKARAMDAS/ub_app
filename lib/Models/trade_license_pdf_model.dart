// To parse this JSON data, do
//
//     final tradeLicensePdfModel = tradeLicensePdfModelFromJson(jsonString);

import 'dart:convert';

TradeLicensePdfModel tradeLicensePdfModelFromJson(String str) =>
    TradeLicensePdfModel.fromJson(json.decode(str));

String tradeLicensePdfModelToJson(TradeLicensePdfModel data) =>
    json.encode(data.toJson());

class TradeLicensePdfModel {
  TradeLicensePdfModel({
    this.essentials,
    this.id,
    this.patronId,
    this.task,
    this.result,
  });

  Essentials? essentials;
  String? id;
  String? patronId;
  String? task;
  Result? result;

  factory TradeLicensePdfModel.fromJson(Map<String, dynamic> json) =>
      TradeLicensePdfModel(
        essentials: json["essentials"] == null
            ? null
            : Essentials.fromJson(json["essentials"]),
        id: json["id"] == null ? null : json["id"],
        patronId: json["patronId"] == null ? null : json["patronId"],
        task: json["task"] == null ? null : json["task"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "essentials": essentials == null ? null : essentials!.toJson(),
        "id": id == null ? null : id,
        "patronId": patronId == null ? null : patronId,
        "task": task == null ? null : task,
        "result": result == null ? null : result!.toJson(),
      };
}

class Essentials {
  Essentials({
    this.urls,
    this.ttl,
  });

  List<String>? urls;
  String? ttl;

  factory Essentials.fromJson(Map<String, dynamic> json) => Essentials(
        urls: json["urls"] == null
            ? null
            : List<String>.from(json["urls"].map((x) => x)),
        ttl: json["ttl"] == null ? null : json["ttl"],
      );

  Map<String, dynamic> toJson() => {
        "urls": urls == null ? null : List<dynamic>.from(urls!.map((x) => x)),
        "ttl": ttl == null ? null : ttl,
      };
}

class Result {
  Result({
    this.pdftoJpgs,
  });

  List<String>? pdftoJpgs;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        pdftoJpgs: json["pdftoJpgs"] == null
            ? null
            : List<String>.from(json["pdftoJpgs"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "pdftoJpgs": pdftoJpgs == null
            ? null
            : List<dynamic>.from(pdftoJpgs!.map((x) => x)),
      };
}
