// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
  UserProfileModel({
    this.status,
    this.userProfile,
  });

  bool? status;
  UserProfile? userProfile;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
    status: json["status"],
    userProfile: UserProfile.fromJson(json["userProfile"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "userProfile": userProfile?.toJson(),
  };
}

class UserProfile {
  UserProfile({
    this.emailStatus,
    this.id,
    this.mobileNo,
    this.registeredOn,
    this.chatId,
    this.mid,
    this.secretKey,
    this.updatedAt,
    this.referralCode,
    this.referralLink,
    this.emailId,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.lastSettlementDate,
  });

  bool? emailStatus;
  String? id;
  String? mobileNo;
  DateTime? registeredOn;
  String? chatId;
  String? mid;
  String? secretKey;
  DateTime? updatedAt;
  String? referralCode;
  String? referralLink;
  String? emailId;
  String? firstName;
  String? lastName;
  String? profilePic;
  DateTime? lastSettlementDate;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    emailStatus: json.containsKey("email_status")?json["email_status"]:null,
    id: json.containsKey("_id")?json["_id"]:null,
    mobileNo: json.containsKey("mobile_no")?json["mobile_no"]:null,
    registeredOn: json.containsKey("registered_on")?DateTime.tryParse(json["registered_on"]):null,
    chatId: json.containsKey("chat_id")?json["chat_id"]:null,
    mid: json.containsKey("mid")?json["mid"]:null,
    secretKey: json.containsKey("secret_key")?json["secret_key"]:null,
    updatedAt: json.containsKey("updatedAt")?DateTime.tryParse(json["updatedAt"]):null,
    referralCode: json.containsKey("referral_code")?json["referral_code"]:null,
    referralLink: json.containsKey("referral_link")?json["referral_link"]:null,
    emailId: json.containsKey("email_id")?json["email_id"]:null,
    firstName: json.containsKey("first_name")?json["first_name"]:null,
    lastName: json.containsKey("last_name")?json["last_name"]:null,
    profilePic: json.containsKey("profilePic")?json["profilePic"]:null,
    lastSettlementDate:json.containsKey("last_settlement_date")?DateTime.tryParse(json["last_settlement_date"]):null,
  );

  Map<String, dynamic> toJson() => {
    "email_status": emailStatus,
    "_id": id,
    "mobile_no": mobileNo,
    "registered_on": registeredOn?.toIso8601String(),
    "chat_id": chatId,
    "mid": mid,
    "secret_key": secretKey,
    "updatedAt": updatedAt?.toIso8601String(),
    "referral_code": referralCode,
    "referral_link": referralLink,
    "email_id": emailId,
    "first_name": firstName,
    "last_name": lastName,
    "profilePic": profilePic,
    "last_settlement_date": lastSettlementDate?.toIso8601String(),
  };
}
