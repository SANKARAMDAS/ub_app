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
    this.customerId,
    this.createdAt,
    this.updatedAt,
    this.v,
   // this.isSelected = false
  });

  bool? read;
  String? id;
  bool? isdeleted;
  String? title;
  String? body;
  Data? data;
  String? customerId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
 // bool isSelected;

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    read: json["read"],
    id: json["_id"],
    isdeleted: json["isdeleted"],
    title: json["title"],
    body: json["body"],
    data: Data.fromJson(json["data"]),
    customerId: json["customer_id"],
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
    "customer_id": customerId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class Data {
  Data({
    this.urbanledgerId,
    this.transactionId,
    this.paymentMethod,
    this.completed,
    this.amount,
    this.cardType,
    this.cardImage,
    this.endingWith,
    this.paymentStatus,
    this.toEmail,
    this.toId,
    this.toMobileNumber,
    this.customerName,
    this.fromMobileNumber,
    this.fromEmail,
    this.type,
    this.fromId,
    this.to,
    this.from,
    this.chatId,
    this.requestId,
    this.businessId

  });

  String? urbanledgerId;
  String? transactionId;
  String? paymentMethod;
  DateTime? completed;
  String? amount;
  String? cardType;
  String? cardImage;
  String? endingWith;
  bool? paymentStatus;
  String? toEmail;
  String? toId;
  String? toMobileNumber;
  String? customerName;
  String? fromMobileNumber;
  String? fromEmail;
  String? type;
  String? fromId;
  String? to;
  String? from;
  String? chatId;
  String? requestId;
  String? businessId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    urbanledgerId: json["urbanledgerId"] == null ? null : json["urbanledgerId"],
    transactionId: json["transactionId"] == null ? null : json["transactionId"],
    paymentMethod: json["paymentMethod"] == null ? null : json["paymentMethod"],
    completed: json["completed"] == null ? null : DateTime.parse(json["completed"]),
    amount: json["amount"] == null ? null : json["amount"],
    cardType: json["cardType"] == null ? null : json["cardType"],
    cardImage: json["cardImage"] == null ? null : json["cardImage"],
    endingWith: json["endingWith"] == null ? null : json["endingWith"],
    paymentStatus: json["paymentStatus"] == null ? null : json["paymentStatus"],
    toEmail: json["toEmail"] == null ? null : json["toEmail"],
    toId: json["to_id"] == null ? null : json["to_id"],
    toMobileNumber: json["toMobileNumber"] == null ? null : json["toMobileNumber"],
    customerName: json["customerName"] == null ? null : json["customerName"],
    fromMobileNumber: json["fromMobileNumber"] == null ? null : json["fromMobileNumber"],
    fromEmail: json["fromEmail"] == null ? null : json["fromEmail"],
    type: json["type"],
    fromId: json["from_id"] == null ? null : json["from_id"],
    to: json["to"] == null ? null : json["to"],
    from: json["from"] == null ? null : json["from"],
    chatId: json["chatId"] == null ? null : json["chatId"],
    requestId: json["request_id"] == null ? null : json["request_id"],
    businessId: json["business_id"] == null ? null : json["business_id"]
  );

  Map<String, dynamic> toJson() => {
    "urbanledgerId": urbanledgerId == null ? null : urbanledgerId,
    "transactionId": transactionId == null ? null : transactionId,
    "paymentMethod": paymentMethod == null ? null : paymentMethod,
    "completed": completed == null ? null : completed!.toIso8601String(),
    "amount": amount == null ? null : amount,
    "cardType": cardType == null ? null : cardType,
    "cardImage": cardImage == null ? null : cardImage,
    "endingWith": endingWith == null ? null : endingWith,
    "paymentStatus": paymentStatus == null ? null : paymentStatus,
    "toEmail": toEmail == null ? null : toEmail,
    "to_id": toId == null ? null : toId,
    "toMobileNumber": toMobileNumber == null ? null : toMobileNumber,
    "customerName": customerName == null ? null : customerName,
    "fromMobileNumber": fromMobileNumber == null ? null : fromMobileNumber,
    "fromEmail": fromEmail == null ? null : fromEmail,
    "type": type,
    "from_id": fromId == null ? null : fromId,
    "to": to == null ? null : to,
    "from": from == null ? null : from,
    "chatId" : chatId == null? null: chatId,
    "request_id" : requestId == null? null: requestId,
    "business_id" : businessId == null? null : businessId
  };
}
