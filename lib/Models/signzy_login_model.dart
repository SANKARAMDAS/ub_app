// To parse this JSON data, do
//
//     final signzyModel = signzyModelFromJson(jsonString);

import 'dart:convert';

SignzyModel signzyModelFromJson(String str) =>
    SignzyModel.fromJson(json.decode(str));

String signzyModelToJson(SignzyModel data) => json.encode(data.toJson());

class SignzyModel {
  SignzyModel({
    this.id,
    this.ttl,
    this.created,
    this.userId,
  });

  String? id;
  int? ttl;
  DateTime? created;
  String? userId;

  factory SignzyModel.fromJson(Map<String, dynamic> json) => SignzyModel(
        id: json["id"] == null ? null : json["id"],
        ttl: json["ttl"] == null ? null : json["ttl"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        userId: json["userId"] == null ? null : json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "ttl": ttl == null ? null : ttl,
        "created": created == null ? null : created?.toIso8601String(),
        "userId": userId == null ? null : userId,
      };
}
