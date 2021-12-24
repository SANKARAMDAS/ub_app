// To parse this JSON data, do
//
//     final suspenceAccountRemoveModel = suspenceAccountRemoveModelFromJson(jsonString);

import 'dart:convert';

SuspenceAccountRemoveModel suspenceAccountRemoveModelFromJson(String str) => SuspenceAccountRemoveModel.fromJson(json.decode(str));

String suspenceAccountRemoveModelToJson(SuspenceAccountRemoveModel data) => json.encode(data.toJson());

class SuspenceAccountRemoveModel {
    SuspenceAccountRemoveModel({
        this.status,
    });

    bool? status;

    factory SuspenceAccountRemoveModel.fromJson(Map<String, dynamic> json) => SuspenceAccountRemoveModel(
        status: json["status"] == null ? null : json["status"],
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
    };
}
