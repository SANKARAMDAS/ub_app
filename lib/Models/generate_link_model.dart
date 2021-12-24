// To parse this JSON data, do
//
//     final generatelinkModel = generatelinkModelFromJson(jsonString);

import 'dart:convert';

GeneratelinkModel generatelinkModelFromJson(String str) =>
    GeneratelinkModel.fromJson(json.decode(str));

String generatelinkModelToJson(GeneratelinkModel data) =>
    json.encode(data.toJson());

class GeneratelinkModel {
  GeneratelinkModel({
    this.status,
    this.template,
    this.payLink,
  });

  bool? status;
  String? template;
  String? payLink;

  factory GeneratelinkModel.fromJson(Map<String, dynamic> json) =>
      GeneratelinkModel(
        status: json["status"] == null ? null : json["status"],
        template: json["template"] == null ? null : json["template"],
        payLink: json["pay_link"] == null ? null : json["pay_link"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "template": template == null ? null : template,
        "pay_link": payLink == null ? null : payLink,
      };
}
