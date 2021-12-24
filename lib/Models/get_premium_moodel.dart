// To parse this JSON data, do
//
//     final getPremiumModel = getPremiumModelFromJson(jsonString);

import 'dart:convert';

GetPremiumModel getPremiumModelFromJson(String str) =>
    GetPremiumModel.fromJson(json.decode(str));

String getPremiumModelToJson(GetPremiumModel data) =>
    json.encode(data.toJson());

class GetPremiumModel {
  GetPremiumModel({
    this.data,
    this.status,
  });

  List<MyPlans>? data;
  bool? status;

  factory GetPremiumModel.fromJson(Map<String, dynamic> json) =>
      GetPremiumModel(
        data: json["data"] == null
            ? null
            : List<MyPlans>.from(json["data"].map((x) => MyPlans.fromJson(x))),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? null
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "status": status == null ? null : status,
  };
}

class MyPlans {
  MyPlans({
    this.id,
    this.plan,
    this.customerId,
    this.planStatus,
    this.status,
    this.amount,
    this.currency,
    this.urbanledgerId,
    this.transactionId,
    this.paymentMethod,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  Plan? plan;
  String? customerId;
  bool? planStatus;
  bool? status;
  int? amount;
  String? currency;
  String? urbanledgerId;
  String? transactionId;
  String? paymentMethod;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory MyPlans.fromJson(Map<String, dynamic> json) => MyPlans(
    id: json["_id"] == null ? null : json["_id"],
    plan: json["plan"] == null ? null : Plan.fromJson(json["plan"]),
    customerId: json["customer_id"] == null ? null : json["customer_id"],
    planStatus: json["planStatus"] == null ? null : json["planStatus"],
    status: json["status"] == null ? null : json["status"],
    amount: json["amount"] == null ? null : json["amount"],
    currency: json["currency"] == null ? null : json["currency"],
    urbanledgerId:
    json["urbanledgerId"] == null ? null : json["urbanledgerId"],
    transactionId:
    json["transactionId"] == null ? null : json["transactionId"],
    paymentMethod:
    json["paymentMethod"] == null ? null : json["paymentMethod"],
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
    "plan": plan == null ? null : plan!.toJson(),
    "customer_id": customerId == null ? null : customerId,
    "planStatus": planStatus == null ? null : planStatus,
    "status": status == null ? null : status,
    "amount": amount == null ? null : amount,
    "currency": currency == null ? null : currency,
    "urbanledgerId": urbanledgerId == null ? null : urbanledgerId,
    "transactionId": transactionId == null ? null : transactionId,
    "paymentMethod": paymentMethod == null ? null : paymentMethod,
    "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
    "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "__v": v == null ? null : v,
  };
}

class Plan {
  Plan({
    this.activeStatus,
    this.id,
    this.name,
    this.amount,
    this.discount,
    this.days,
  });

  bool? activeStatus;
  String? id;
  String? name;
  int? amount;
  int? discount;
  int? days;

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    activeStatus:
    json["activeStatus"] == null ? null : json["activeStatus"],
    id: json["_id"] == null ? null : json["_id"],
    name: json["name"] == null ? null : json["name"],
    amount: json["amount"] == null ? null : json["amount"],
    discount: json["discount"] == null ? null : json["discount"],
    days: json["days"] == null ? null : json["days"],
  );

  Map<String, dynamic> toJson() => {
    "activeStatus": activeStatus == null ? null : activeStatus,
    "_id": id == null ? null : id,
    "name": name == null ? null : name,
    "amount": amount == null ? null : amount,
    "discount": discount == null ? null : discount,
    "days": days == null ? null : days,
  };
}
