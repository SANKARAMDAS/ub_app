// To parse this JSON data, do
//
//     final capturePaymentModel = capturePaymentModelFromJson(jsonString);

import 'dart:convert';

CapturePaymentModel capturePaymentModelFromJson(String str) =>
    CapturePaymentModel.fromJson(json.decode(str));

String capturePaymentModelToJson(CapturePaymentModel data) =>
    json.encode(data.toJson());

class CapturePaymentModel {
  CapturePaymentModel({
    this.status,
    this.message,
    this.amount,
    this.urbanledgerId,
    this.transactionId,
    this.paymentMethod,
    this.date,
  });

  bool? status;
  String? message;
  int? amount;
  String? urbanledgerId;
  String? transactionId;
  String? paymentMethod;
  DateTime? date;

  factory CapturePaymentModel.fromJson(Map<String, dynamic> json) =>
      CapturePaymentModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        amount: json["amount"] == null ? null : json["amount"],
        urbanledgerId:
            json["urbanledgerId"] == null ? null : json["urbanledgerId"],
        transactionId:
            json["transactionId"] == null ? null : json["transactionId"],
        paymentMethod:
            json["paymentMethod"] == null ? null : json["paymentMethod"],
        date: json["Date"] == null ? null : DateTime.parse(json["Date"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "amount": amount == null ? null : amount,
        "urbanledgerId": urbanledgerId == null ? null : urbanledgerId,
        "transactionId": transactionId == null ? null : transactionId,
        "paymentMethod": paymentMethod == null ? null : paymentMethod,
        "Date": date == null ? null : date?.toIso8601String(),
      };
}
