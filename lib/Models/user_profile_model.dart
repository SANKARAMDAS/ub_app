// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

  UserProfileModel userProfileFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

  String userProfileToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
  String get userTableName => 'USER';
  String get columnId => 'ID';
  String get columnProfilePic => 'PROFILEPIC';
  String get columnCompanyName => 'COMPANYNAME';
  String get columnFirstName => 'FIRSTNAME';
  String get columnLastName => 'LASTNAME';
  String get columnBusinessEmail => 'BUSINESSEMAIL';
  String get columnCountryCode => 'COUNTRYCODE';
  String get columnMobileNo => 'MOBILENO';

    String? id;
    String? profilePic;
    String? companyName;
    String? firstName;
    String? lastName;
    String? businessEmail;
    String? mobileNumber;
    String? countryCode;
    UserProfileModel({
      this.id,
      this.profilePic,
      this.companyName,
      this.firstName,
      this.lastName,
      this.businessEmail,
      this.mobileNumber,
      this.countryCode
    }); 

    factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        id: json["_id"] == null ? null : json["_id"],
        profilePic: json["profilePic"] == null ? null : json["profilePic"],
        companyName: json["companyName"] == null ? null : json["companyName"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        businessEmail: json["businessEmail"] == null ? null : json["businessEmail"],
        mobileNumber: json["mobileNumber"] == null ? null : json["mobileNumber"],
        countryCode: json["countryCode"] == null ? null : json["countryCode"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "profilePic": profilePic == null ? null : profilePic,
        "companyName": companyName == null ? null : companyName,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "businessEmail": businessEmail == null ? null : businessEmail,
        "mobileNumber": mobileNumber == null ? null : mobileNumber,
        "countryCode": countryCode == null ? null : countryCode,
    };
}
