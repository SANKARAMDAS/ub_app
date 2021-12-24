// To parse this JSON data, do
//
//     final CustomerRankingModel = CustomerRankingModelFromJson(jsonString);

import 'dart:convert';

CustomerRankingModel CustomerRankingModelFromJson(String str) => CustomerRankingModel.fromJson(json.decode(str));

String CustomerRankingModelToJson(CustomerRankingModel data) => json.encode(data.toJson());

class CustomerRankingModel {
  CustomerRankingModel({
    this.data,
    this.totalPages,
  });

  List<CustomerRankingData>? data;
  int? totalPages;

  factory CustomerRankingModel.fromJson(Map<String, dynamic> json) => CustomerRankingModel(
    data: List<CustomerRankingData>.from(json["data"].map((x) => CustomerRankingData.fromJson(x))),
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "totalPages": totalPages,
  };
}

class CustomerRankingData {
  CustomerRankingData({
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
    this.type,
    this.contactData
  });

  String? id;
  String? mobileNo;
  String? registeredOn;
  String? chatId;
  String? emailId;
  String? firstName;
  String? lastName;
  String? profilePic;
  String? updatedAt;
  String? referralCode;
  String? referralLink;
  String? type;
  ContactData? contactData;


  static const tableName = 'tb_customer_ranking';

  static const  columnId = "column_id";
  static const  columnCustomerId="column_customer_id";
  static const  columnMobileNo="column_mobile_no";
  static const  columnRegisteredOn="column_registered_on";
  static const  columnChatId="column_chat_id";
  static const  columnEmailId="column_email_id";
  static const  columnFirstName="column_first_name";
  static const  columnLastName="column_last_name";
  static const  columnProfilePic="column_profilePic";
  static const  columnUpdatedAt="column_updatedAt";
  static const  columnReferralCode="column_referral_code";
  static const  columnReferralLink="column_referral_link";
  static const columnType = "column_type";
  static const columnContactData = "column_contact_data";

  Map<String, dynamic> toDb() => {
    columnCustomerId: id,
    columnMobileNo: mobileNo,
    columnRegisteredOn: registeredOn,
    columnChatId: chatId,
    columnEmailId: emailId,
    columnFirstName: firstName,
    columnLastName: lastName,
    columnProfilePic: profilePic,
    columnUpdatedAt: updatedAt,
    columnReferralCode: referralCode,
    columnReferralLink: referralLink,
    columnType: type,
    columnContactData:jsonEncode(contactData!.toJson())
  };


   CustomerRankingData fromDb(Map<String, dynamic> json) => CustomerRankingData(
     id: json[columnCustomerId],
     mobileNo: json[columnMobileNo],
     registeredOn: json[columnRegisteredOn],
     chatId: json[columnChatId],
     emailId: json[columnEmailId],
     firstName: json[columnFirstName],
     lastName: json[columnLastName],
     profilePic: json[columnProfilePic],
     updatedAt: json[columnUpdatedAt],
     referralCode: json[columnReferralCode],
     referralLink: json[columnReferralLink],
     type: json[columnType],
     contactData: ContactData.fromJson(jsonDecode(json[columnContactData]))
  );

  factory CustomerRankingData.fromJson(Map<String, dynamic> json) => CustomerRankingData(
    id: json["_id"],
    mobileNo: json["mobile_no"],
    registeredOn: json["registered_on"],
    chatId: json["chat_id"],
    emailId: json["email_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    profilePic: json["profilePic"],
    updatedAt: json["updatedAt"],
    referralCode: json["referral_code"] == null ? null : json["referral_code"],
    referralLink: json["referral_link"] == null ? null : json["referral_link"],
      contactData:ContactData.fromJson(json["contactData"])
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "mobile_no": mobileNo,
    "registered_on": registeredOn,
    "chat_id": chatId,
    "email_id": emailId,
    "first_name": firstName,
    "last_name": lastName,
    "profilePic": profilePic,
    "updatedAt": updatedAt,
    "referral_code": referralCode == null ? null : referralCode,
    "referral_link": referralLink == null ? null : referralLink,
    "contactData":contactData!.toJson()
  };
}

class ContactData {
  ContactData({
    this.id,
    this.name,
    this.mobilenumber,
    this.uid,
    this.business,
    this.chatId,
    this.transactionAmount,
    this.updatedDate,
    this.transactionType,
    this.collectionDate,
    this.createdDate,
    this.customerId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? name;
  String? mobilenumber;
  String? uid;
  String? business;
  String? chatId;
  int? transactionAmount;
  DateTime? updatedDate;
  String? transactionType;
  dynamic? collectionDate;
  DateTime? createdDate;
  String? customerId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory ContactData.fromJson(Map<String, dynamic> json) => ContactData(
    id: json["_id"],
    name: json["name"],
    mobilenumber: json["mobilenumber"],
    uid: json["uid"],
    business: json["business"],
    chatId: json["chat_id"],
    transactionAmount: json["transactionAmount"],
    updatedDate: DateTime.parse(json["updatedDate"]),
    transactionType: json["transactionType"],
    collectionDate: json["collectionDate"],
    createdDate: DateTime.parse(json["createdDate"]),
    customerId: json["customer_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "mobilenumber": mobilenumber,
    "uid": uid,
    "business": business,
    "chat_id": chatId,
    "transactionAmount": transactionAmount,
    "updatedDate": updatedDate!.toIso8601String(),
    "transactionType": transactionType,
    "collectionDate": collectionDate,
    "createdDate": createdDate!.toIso8601String(),
    "customer_id": customerId,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
  };
}
