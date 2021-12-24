// To parse this JSON data, do
//
//     final startOrderSessionModel = startOrderSessionModelFromJson(jsonString);

import 'dart:convert';

StartOrderSessionModel startOrderSessionModelFromJson(String str) =>
    StartOrderSessionModel.fromJson(json.decode(str));

String startOrderSessionModelToJson(StartOrderSessionModel data) =>
    json.encode(data.toJson());

class StartOrderSessionModel {
  StartOrderSessionModel({
    this.suspense,
    this.id,
    this.status,
    this.statusAt,
    this.orderId,
    this.toCustId,
    this.through,
    this.type,
    this.fromCustId,
    this.fromMobileNumber,
    this.createdAt,
    this.updatedAt,
    this.statuscode,
    this.message,
    this.v,
  });

  bool? suspense;
  String? id;
  String? status;
  DateTime? statusAt;
  String? orderId;
  String? toCustId;
  String? through;
  String? type;
  String? fromCustId;
  String? fromMobileNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? statuscode;
  String? message;
  int? v;

  factory StartOrderSessionModel.fromJson(Map<String, dynamic> json) =>
      StartOrderSessionModel(
        suspense: json["suspense"] == null ? null : json["suspense"],
        id: json["_id"] == null ? null : json["_id"],
        status: json["status"] == null ? null : json["status"] == false ? "false" : json["status"],
        statusAt: json["status_at"] == null
            ? null
            : DateTime.parse(json["status_at"]),
        orderId: json["order_id"] == null ? null : json["order_id"],
        toCustId: json["toCustId"] == null ? null : json["toCustId"],
        through: json["through"] == null ? null : json["through"],
        type: json["type"] == null ? null : json["type"],
        fromCustId: json["fromCustId"] == null ? null : json["fromCustId"],
        fromMobileNumber:
            json["fromMobileNumber"] == null ? null : json["fromMobileNumber"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        statuscode: json["statuscode"] == null ? null : json["statuscode"],
        message: json["message"] == null ? null : json["message"],
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "suspense": suspense == null ? null : suspense,
        "_id": id == null ? null : id,
        "status": status == null ? null : status,
        "status_at": statusAt == null ? null : statusAt?.toIso8601String(),
        "order_id": orderId == null ? null : orderId,
        "toCustId": toCustId == null ? null : toCustId,
        "through": through == null ? null : through,
        "type": type == null ? null : type,
        "fromCustId": fromCustId == null ? null : fromCustId,
        "fromMobileNumber": fromMobileNumber == null ? null : fromMobileNumber,
        "createdAt": createdAt == null ? null : createdAt?.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "statuscode": statuscode == null ? null : statuscode,
        "message": message == null ? null : message,
        "__v": v == null ? null : v,
      };
}
