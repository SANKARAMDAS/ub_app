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
    emailStatus: json["email_status"],
    id: json["_id"],
    mobileNo: json["mobile_no"],
    registeredOn: DateTime.parse(json["registered_on"]),
    chatId: json["chat_id"],
    mid: json["mid"],
    secretKey: json["secret_key"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    referralCode: json["referral_code"],
    referralLink: json["referral_link"],
    emailId: json["email_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    profilePic: json["profilePic"],
    lastSettlementDate: DateTime.parse(json["last_settlement_date"]),
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
