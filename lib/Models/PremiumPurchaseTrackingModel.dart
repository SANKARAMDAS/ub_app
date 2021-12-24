// To parse this JSON data, do
//
//     final premiumStartOrderSession = premiumStartOrderSessionFromJson(jsonString);

import 'dart:convert';

PremiumStartOrderSession premiumStartOrderSessionFromJson(String str) =>
    PremiumStartOrderSession.fromJson(json.decode(str));

String premiumStartOrderSessionToJson(PremiumStartOrderSession data) =>
    json.encode(data.toJson());

class PremiumStartOrderSession {
  PremiumStartOrderSession({
    this.id,
    this.status,
    this.planStatus,
    this.transactionStatus,
    this.statusAt,
    this.orderId,
    this.customerId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  bool? status;
  bool? planStatus;
  String? transactionStatus;
  DateTime? statusAt;
  String? orderId;
  String? customerId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory PremiumStartOrderSession.fromJson(Map<String, dynamic> json) =>
      PremiumStartOrderSession(
        id: json["_id"] == null ? null : json["_id"],
        status: json["status"] == null ? null : json["status"],
        planStatus: json["planStatus"] == null ? null : json["planStatus"],
        transactionStatus: json["transactionStatus"] == null
            ? null
            : json["transactionStatus"],
        statusAt: json["status_at"] == null
            ? null
            : DateTime.parse(json["status_at"]),
        orderId: json["order_id"] == null ? null : json["order_id"],
        customerId: json["customer_id"] == null ? null : json["customer_id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "status": status == null ? null : status,
        "planStatus": planStatus == null ? null : planStatus,
        "transactionStatus":
            transactionStatus == null ? null : transactionStatus,
        "status_at": statusAt == null ? null : statusAt!.toIso8601String(),
        "order_id": orderId == null ? null : orderId,
        "customer_id": customerId == null ? null : customerId,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "__v": v == null ? null : v,
      };
}
