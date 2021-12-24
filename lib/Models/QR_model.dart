// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

  QRModel userProfileFromJson(String str) => QRModel.fromJson(json.decode(str));

  String userProfileToJson(QRModel data) => json.encode(data.toJson());

class QRModel {
    // ignore: non_constant_identifier_names
    String? customer_id;
    String? firstName;
    String? lastName;
    String? currency;
    String? note;
    String? mobileNo;
    String? amount;
    String? bills;
    QRModel({
      // ignore: non_constant_identifier_names
      this.customer_id,
      this.firstName,
      this.lastName,
      this.amount,
      this.currency,
      this.mobileNo,
      this.note,
      this.bills
    }); 

    factory QRModel.fromJson(Map<String, dynamic> json) => QRModel(
        customer_id: json["customer_id"] == null ? null : json["customer_id"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        amount: json["amount"] == null ? null : json["amount"],
        currency: json["currency"] == null ? null : json["currency"],
        mobileNo: json["mobileNo"] == null ? null : json["mobileNo"],
        note: json["note"] == null ? null : json["note"],
        bills: json["bills"] == null ? null : json["bills"],
    );

    Map<String, dynamic> toJson() => {
        "customer_id": customer_id == null ? null : customer_id,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "amount": amount == null ? null : amount,
        "currency": currency == null ? null : currency,
        "mobileNo": mobileNo == null ? null : mobileNo,
        "note": note == null ? null : note,
        "bills": bills == null ? null : bills,
    };
}
