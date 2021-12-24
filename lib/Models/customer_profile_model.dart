// To parse this JSON data, do
//
//     final customerProfileModel = customerProfileModelFromJson(jsonString);

import 'dart:convert';

class CustomerProfileModel {
    CustomerProfileModel({
        this.uid,
        this.name,
        this.mobileNo,
        this.address,
        this.sendFreeSms,
        this.credit,
    });

    String? uid;
    String? name;
    String? mobileNo;
    Address? address;
    bool? sendFreeSms;
    Credit? credit;

    factory CustomerProfileModel.fromRawJson(String str) => CustomerProfileModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CustomerProfileModel.fromJson(Map<String, dynamic> json) => CustomerProfileModel(
        uid: json["uid"] == null ? null : json["uid"],
        name: json["name"] == null ? null : json["name"],
        mobileNo: json["mobileNo"] == null ? null : json["mobileNo"],
        address: json["address"] == null ? null : Address.fromJson(json["address"]),
        sendFreeSms: json["sendFreeSms"] == null ? null : json["sendFreeSms"],
        credit: json["credit"] == null ? null : Credit.fromJson(json["credit"]),
    );

    Map<String, dynamic> toJson() => {
        "uid": uid == null ? null : uid,
        "name": name == null ? null : name,
        "mobileNo": mobileNo == null ? null : mobileNo,
        "address": address == null ? null : address?.toJson(),
        "sendFreeSms": sendFreeSms == null ? null : sendFreeSms,
        "credit": credit == null ? null : credit?.toJson(),
    };
}

class Address {
    Address({
        this.flatBuildingHouse,
        this.landmark,
        this.pincode,
        this.city,
        this.state,
    });

    String? flatBuildingHouse;
    String? landmark;
    String? pincode;
    String? city;
    String? state;

    factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        flatBuildingHouse: json["flatBuildingHouse"] == null ? null : json["flatBuildingHouse"],
        landmark: json["landmark"] == null ? null : json["landmark"],
        pincode: json["pincode"] == null ? null : json["pincode"],
        city: json["city"] == null ? null : json["city"],
        state: json["state"] == null ? null : json["state"],
    );

    Map<String, dynamic> toJson() => {
        "flatBuildingHouse": flatBuildingHouse == null ? null : flatBuildingHouse,
        "landmark": landmark == null ? null : landmark,
        "pincode": pincode == null ? null : pincode,
        "city": city == null ? null : city,
        "state": state == null ? null : state,
    };
}

class Credit {
    Credit({
        this.creditLimit,
        this.interest,
        this.emi,
    });

    int? creditLimit;
    int? interest;
    int? emi;

    factory Credit.fromRawJson(String str) => Credit.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Credit.fromJson(Map<String, dynamic> json) => Credit(
        creditLimit: json["creditLimit"] == null ? null : json["creditLimit"],
        interest: json["interest"] == null ? null : json["interest"],
        emi: json["emi"] == null ? null : json["emi"],
    );

    Map<String, dynamic> toJson() => {
        "creditLimit": creditLimit == null ? null : creditLimit,
        "interest": interest == null ? null : interest,
        "emi": emi == null ? null : emi,
    };
}
