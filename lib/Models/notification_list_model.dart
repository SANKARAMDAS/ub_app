// To parse this JSON data, do
//
//     final notificationListModel = notificationListModelFromJson(jsonString);

import 'dart:convert';

NotificationListModel notificationListModelFromJson(String str) => NotificationListModel.fromJson(json.decode(str));

String notificationListModelToJson(NotificationListModel data) => json.encode(data.toJson());

class NotificationListModel {
  NotificationListModel({
    this.status,
    this.statuscode,
    this.message,
    this.data,
  });

  bool? status;
  int? statuscode;
  String? message;
  List<NotificationData>? data;

  factory NotificationListModel.fromJson(Map<String, dynamic> json) => NotificationListModel(
    status: json["status"],
    statuscode: json["statuscode"],
    message: json["message"],
    data: List<NotificationData>.from(json["data"].map((x) => NotificationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statuscode": statuscode,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class NotificationData {
  NotificationData({
    this.read,
    this.id,
    this.isdeleted,
    this.title,
    this.body,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isSelected = false
  });

  bool? read;
  String? id;
  bool? isdeleted;
  String? title;
  String? body;
  Data? data;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  bool isSelected;

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    read: json["read"],
    id: json["_id"],
    isdeleted: json["isdeleted"],
    title: json["title"],
    body: json["body"],
    data: Data.fromJson(json["data"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "read": read,
    "_id": id,
    "isdeleted": isdeleted,
    "title": title,
    "body": body,
    "data": data?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class Data {
  Data({
    this.type,
    this.urbanledgerId,
    this.fromMobileNumber,
  });

  String? type;
  String? urbanledgerId;
  String? fromMobileNumber;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    type: json["type"],
    urbanledgerId: json["urbanledgerId"] == null ? null : json["urbanledgerId"],
    fromMobileNumber: json["fromMobileNumber"] == null ? null : json["fromMobileNumber"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "urbanledgerId": urbanledgerId == null ? null : urbanledgerId,
    "fromMobileNumber": fromMobileNumber == null ? null : fromMobileNumber,
  };
}
