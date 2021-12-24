// To parse this JSON data, do
//
//     final planModel = planModelFromJson(jsonString);

import 'dart:convert';

PlanModel planModelFromJson(String str) => PlanModel.fromJson(json.decode(str));

String planModelToJson(PlanModel data) => json.encode(data.toJson());

class PlanModel {
  PlanModel({
    required this.activeStatus,
    required this.id,
    required this.name,
    required this.amount,
    required this.discount,
    required this.days,
    this.createdAt,
    this.updatedAt,
  });

  final bool activeStatus;
  final String id;
  final String name;
  final int amount;
  final int discount;
  final int days;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PlanModel copyWith({
    bool? activeStatus,
    String? id,
    String? name,
    int? amount,
    int? discount,
    int? days,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      PlanModel(
        activeStatus: activeStatus ?? this.activeStatus,
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        discount: discount ?? this.discount,
        days: days ?? this.days,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        activeStatus: json["activeStatus"],
        id: json["_id"],
        name: json["name"],
        amount: json["amount"],
        discount: json["discount"],
        days: json["days"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "activeStatus": activeStatus,
        "_id": id,
        "name": name,
        "amount": amount,
        "discount": discount,
        "days": days,
        "createdAt": createdAt?.toIso8601String() ?? DateTime.now(),
        "updatedAt": updatedAt?.toIso8601String() ?? DateTime.now(),
      };
}
