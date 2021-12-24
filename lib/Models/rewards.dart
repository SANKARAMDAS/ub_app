// To parse this JSON data, do
//
//     final getRewards = getRewardsFromJson(jsonString);

import 'dart:convert';

GetRewards getRewardsFromJson(String str) =>
    GetRewards.fromJson(json.decode(str));

String getRewardsToJson(GetRewards data) => json.encode(data.toJson());

class GetRewards {
  GetRewards({
    this.data,
    this.totalPendingAmt,
    this.totalRewardAmt,
  });

  List<RewardsDetails>? data;
  int? totalPendingAmt;
  int? totalRewardAmt;

  factory GetRewards.fromJson(Map<String, dynamic> json) => GetRewards(
        data: json["data"] == null
            ? null
            : List<RewardsDetails>.from(
                json["data"]!.map((x) => RewardsDetails.fromJson(x))),
        totalPendingAmt: json["total_pending_amt"] == null
            ? null
            : json["total_pending_amt"],
        totalRewardAmt:
            json["total_reward_amt"] == null ? null : json["total_reward_amt"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_pending_amt": totalPendingAmt == null ? null : totalPendingAmt,
        "total_reward_amt": totalRewardAmt == null ? null : totalRewardAmt,
      };
}

class RewardsDetails {
  RewardsDetails({
    this.id,
    this.referralType,
    this.firstPayment,
    this.currency,
    this.isdeleted,
    this.customerId,
    this.referId,
    this.createdAt,
    this.updatedAt,
    this.firstPaymentAt,
    this.referPaymentTo,
    this.referTransactionId,
    this.referralAmount,
    this.customerAmount,
    this.referCustomerData,
  });

  String? id;
  String? referralType;
  bool? firstPayment;
  String? currency;
  bool? isdeleted;
  String? customerId;
  String? referId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? firstPaymentAt;
  String? referPaymentTo;
  String? referTransactionId;
  int? referralAmount;
  int? customerAmount;
  ReferCustomerData? referCustomerData;

  factory RewardsDetails.fromJson(Map<String, dynamic> json) => RewardsDetails(
        id: json["_id"] == null ? null : json["_id"],
        referralType:
            json["referral_type"] == null ? null : json["referral_type"],
        firstPayment:
            json["first_payment"] == null ? null : json["first_payment"],
        currency: json["currency"] == null ? null : json["currency"],
        isdeleted: json["isdeleted"] == null ? null : json["isdeleted"],
        customerId: json["customer_id"] == null ? null : json["customer_id"],
        referId: json["refer_Id"] == null ? null : json["refer_Id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        firstPaymentAt: json["first_payment_at"] == null
            ? null
            : DateTime.parse(json["first_payment_at"]),
        referPaymentTo:
            json["refer_payment_to"] == null ? null : json["refer_payment_to"],
        referTransactionId: json["refer_transaction_Id"] == null
            ? null
            : json["refer_transaction_Id"],
        referralAmount:
            json["referral_amount"] == null ? null : json["referral_amount"],
        customerAmount:
            json["customer_amount"] == null ? null : json["customer_amount"],
        referCustomerData: json["refer_customer_data"] == null
            ? null
            : ReferCustomerData.fromJson(json["refer_customer_data"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "referral_type": referralType == null ? null : referralType,
        "first_payment": firstPayment == null ? null : firstPayment,
        "currency": currency == null ? null : currency,
        "isdeleted": isdeleted == null ? null : isdeleted,
        "customer_id": customerId == null ? null : customerId,
        "refer_Id": referId == null ? null : referId,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "first_payment_at":
            firstPaymentAt == null ? null : firstPaymentAt!.toIso8601String(),
        "refer_payment_to": referPaymentTo == null ? null : referPaymentTo,
        "refer_transaction_Id":
            referTransactionId == null ? null : referTransactionId,
        "referral_amount": referralAmount == null ? null : referralAmount,
        "customer_amount": customerAmount == null ? null : customerAmount,
        "refer_customer_data":
            referCustomerData == null ? null : referCustomerData!.toJson(),
      };
}

class ReferCustomerData {
  ReferCustomerData({
    this.id,
    this.mobileNo,
    this.registeredOn,
    this.chatId,
    this.emailId,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.updatedAt,
    this.referralCode,
    this.referralLink,
  });

  String? id;
  String? mobileNo;
  DateTime? registeredOn;
  String? chatId;
  String? emailId;
  String? firstName;
  String? lastName;
  String? profilePic;
  DateTime? updatedAt;
  String? referralCode;
  String? referralLink;

  factory ReferCustomerData.fromJson(Map<String, dynamic> json) =>
      ReferCustomerData(
        id: json["_id"] == null ? null : json["_id"],
        mobileNo: json["mobile_no"] == null ? null : json["mobile_no"],
        registeredOn: json["registered_on"] == null
            ? null
            : DateTime.parse(json["registered_on"]),
        chatId: json["chat_id"] == null ? null : json["chat_id"],
        emailId: json["email_id"] == null ? null : json["email_id"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        profilePic: json["profilePic"] == null ? null : json["profilePic"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        referralCode:
            json["referral_code"] == null ? null : json["referral_code"],
        referralLink:
            json["referral_link"] == null ? null : json["referral_link"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "mobile_no": mobileNo == null ? null : mobileNo,
        "registered_on":
            registeredOn == null ? null : registeredOn!.toIso8601String(),
        "chat_id": chatId == null ? null : chatId,
        "email_id": emailId == null ? null : emailId,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "profilePic": profilePic == null ? null : profilePic,
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "referral_code": referralCode == null ? null : referralCode,
        "referral_link": referralLink == null ? null : referralLink,
      };
}
