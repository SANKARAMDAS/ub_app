// To parse this JSON data, do
//
//     final verifyCardModel = verifyCardModelFromJson(jsonString);

import 'dart:convert';

VerifyCardModel verifyCardModelFromJson(String str) =>
    VerifyCardModel.fromJson(json.decode(str));

String verifyCardModelToJson(VerifyCardModel data) =>
    json.encode(data.toJson());

class VerifyCardModel {
  VerifyCardModel({
    this.country,
    this.countryCode,
    this.cardBrand,
    this.isCommercial,
    this.issuer,
    this.issuerWebsite,
    this.valid,
    this.cardImage,
    this.isPrepaid,
    this.cardCategory,
    this.issuerPhone,
    this.currencyCode,
    this.countryCode3,
    this.img,
  });

  String? country;
  String? countryCode;
  String? cardBrand;
  bool? isCommercial;
  String? issuer;
  String? issuerWebsite;
  bool? valid;
  String? cardImage;
  bool? isPrepaid;
  String? cardCategory;
  String? issuerPhone;
  String? currencyCode;
  String? countryCode3;
  String? img;

  factory VerifyCardModel.fromJson(Map<String, dynamic> json) =>
      VerifyCardModel(
        country: json["country"] == null ? null : json["country"],
        countryCode: json["country-code"] == null ? null : json["country-code"],
        cardBrand: json["card-brand"] == null ? null : json["card-brand"],
        isCommercial:
            json["is-commercial"] == null ? null : json["is-commercial"],
        issuer: json["issuer"] == null ? null : json["issuer"],
        issuerWebsite:
            json["issuer-website"] == null ? null : json["issuer-website"],
        valid: json["valid"] == null ? null : json["valid"],
        cardImage: json["card-type"] == null ? null : json["card-type"],
        isPrepaid: json["is-prepaid"] == null ? null : json["is-prepaid"],
        cardCategory:
            json["card-category"] == null ? null : json["card-category"],
        issuerPhone: json["issuer-phone"] == null ? null : json["issuer-phone"],
        currencyCode:
            json["currency-code"] == null ? null : json["currency-code"],
        countryCode3:
            json["country-code3"] == null ? null : json["country-code3"],
        img: json["img"] == null ? null : json["img"],
      );

  Map<String, dynamic> toJson() => {
        "country": country == null ? null : country,
        "country-code": countryCode == null ? null : countryCode,
        "card-brand": cardBrand == null ? null : cardBrand,
        "is-commercial": isCommercial == null ? null : isCommercial,
        "issuer": issuer == null ? null : issuer,
        "issuer-website": issuerWebsite == null ? null : issuerWebsite,
        "valid": valid == null ? null : valid,
        "card-type": cardImage == null ? null : cardImage,
        "is-prepaid": isPrepaid == null ? null : isPrepaid,
        "card-category": cardCategory == null ? null : cardCategory,
        "issuer-phone": issuerPhone == null ? null : issuerPhone,
        "currency-code": currencyCode == null ? null : currencyCode,
        "country-code3": countryCode3 == null ? null : countryCode3,
        "img": img == null ? null : img,
      };
}
