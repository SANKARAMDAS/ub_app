// To parse this JSON data, do
//
//     final kycEmiratesId = kycEmiratesIdFromJson(jsonString);

import 'dart:convert';

KycEmiratesIdModel kycEmiratesIdFromJson(String str) =>
    KycEmiratesIdModel.fromJson(json.decode(str));

String kycEmiratesIdToJson(KycEmiratesIdModel data) =>
    json.encode(data.toJson());

class KycEmiratesIdModel {
  KycEmiratesIdModel({
    this.dob,
    this.expiryDate,
    this.nationality,
    this.nationalityCode,
    this.firstName,
    this.lastName,
    this.name,
    this.gender,
    this.idNumber,
    this.cardNumber,
  });

  String? dob;
  String? expiryDate;
  String? nationality;
  String? nationalityCode;
  String? firstName;
  String? lastName;
  String? name;
  String? gender;
  String? idNumber;
  String? cardNumber;

  factory KycEmiratesIdModel.fromJson(Map<String, dynamic> json) =>
      KycEmiratesIdModel(
        dob: json["dob"] == null ? null : json["dob"],
        expiryDate: json["expiryDate"] == null ? null : json["expiryDate"],
        nationality: json["nationality"] == null ? null : json["nationality"],
        nationalityCode:
            json["nationalityCode"] == null ? null : json["nationalityCode"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        lastName: json["lastName"] == null ? null : json["lastName"],
        name: json["name"] == null ? null : json["name"],
        gender: json["gender"] == null ? null : json["gender"],
        idNumber: json["idNumber"] == null ? null : json["idNumber"],
        cardNumber: json["cardNumber"] == null ? null : json["cardNumber"],
      );

  Map<String, dynamic> toJson() => {
        "dob": dob == null ? null : dob,
        "expiryDate": expiryDate == null ? null : expiryDate,
        "nationality": nationality == null ? null : nationality,
        "nationalityCode": nationalityCode == null ? null : nationalityCode,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "name": name == null ? null : name,
        "gender": gender == null ? null : gender,
        "idNumber": idNumber == null ? null : idNumber,
        "cardNumber": cardNumber == null ? null : cardNumber,
      };
}
