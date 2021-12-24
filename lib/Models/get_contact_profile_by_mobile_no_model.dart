// To parse this JSON data, do
//
//     final getContactProfilebyMobileNoModel = getContactProfilebyMobileNoModelFromJson(jsonString);

import 'dart:convert';

GetContactProfilebyMobileNoModel getContactProfilebyMobileNoModelFromJson(
        String str) =>
    GetContactProfilebyMobileNoModel.fromJson(json.decode(str));

String getContactProfilebyMobileNoModelToJson(
        GetContactProfilebyMobileNoModel data) =>
    json.encode(data.toJson());

class GetContactProfilebyMobileNoModel {
  GetContactProfilebyMobileNoModel({
    this.id,
    this.name,
    this.mobilenumber,
    this.customerInfo,
  });

  String? id;
  String? name;
  String? mobilenumber;
  CustomerInfo? customerInfo;

  factory GetContactProfilebyMobileNoModel.fromJson(
          Map<String, dynamic> json) =>
      GetContactProfilebyMobileNoModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        mobilenumber:
            json["mobilenumber"] == null ? null : json["mobilenumber"],
        customerInfo: json["customer_info"] == null
            ? null
            : CustomerInfo.fromJson(json["customer_info"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "mobilenumber": mobilenumber == null ? null : mobilenumber,
        "customer_info": customerInfo == null ? null : customerInfo!.toJson(),
      };
}

class CustomerInfo {
  CustomerInfo({
    this.id,
    this.firstName,
    this.lastName,
    this.bankAccountStatus,
    this.kycStatus,
    this.merchantSubscriptionPlan,
  });

  String? id;
  String? firstName;
  String? lastName;
  bool? bankAccountStatus;
  bool? kycStatus;
  bool? merchantSubscriptionPlan;

  factory CustomerInfo.fromJson(Map<String, dynamic> json) => CustomerInfo(
        id: json["id"] == null ? null : json["id"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        bankAccountStatus: json["bankAccountStatus"] == null
            ? null
            : json["bankAccountStatus"],
        kycStatus: json["kycStatus"] == null ? null : json["kycStatus"],
        merchantSubscriptionPlan: json["merchantSubscriptionPlan"] == null
            ? null
            : json["merchantSubscriptionPlan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "bankAccountStatus":
            bankAccountStatus == null ? null : bankAccountStatus,
        "kycStatus": kycStatus == null ? null : kycStatus,
        "merchantSubscriptionPlan":
            merchantSubscriptionPlan == null ? null : merchantSubscriptionPlan,
      };
}
