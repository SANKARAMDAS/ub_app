// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    LoginModel({
        this.userId,
        this.userName,
        this.mobileNo,
        this.pin,
        // this.loginDate,
        // this.updatedDate,
        this.status,
    });

    String? userId;
    String? userName;
    String? mobileNo;
    String? pin;
    // DateTime? loginDate;
    // DateTime? updatedDate;
    bool? status;

  static const tableName = 'tb_login';
  static const column_id = '_id';
  static const column_user_id = 'user_id';
  static const column_user_name = 'user_name';
  static const column_mobile_no = 'mobile_no';
  static const column_pin = 'pin';
  // static const column_login_date = 'login_date';
  // static const column_updated_date = 'updated_date';
  static const column_status = 'status';

  Map<String, dynamic> toDb() => {
        column_user_id: userId,
        column_user_name: userName,
        column_mobile_no: mobileNo,
        column_pin: pin,
        // column_login_date: loginDate?.toIso8601String(),
        // column_updated_date: updatedDate?.toIso8601String(),
        column_status: status == true ? 1 : 0
      };

    LoginModel copyWith({
        String? userId,
        String? userName,
        String? mobileNO,
        String? pin,
        // DateTime? loginDate,
        // DateTime? updatedDate,
        bool? status,
    }) => 
        LoginModel(
            userId: userId ?? this.userId,
            userName: userName ?? this.userName,
            mobileNo: mobileNo,
            pin: pin ?? this.pin,
            // loginDate: loginDate ?? this.loginDate,
            // updatedDate: updatedDate ?? this.updatedDate,
            status: status ?? this.status,
        );

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        userId: json["user_id"],
        userName: json["user_name"],
        mobileNo: json["mobile_no"],
        pin: json["pin"],
        // loginDate: json["login_date"],
        // updatedDate: json["updated_date"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "mobile_no": mobileNo,
        "pin": pin,
        // "login_date": loginDate,
        // "updated_date": updatedDate,
        "status": status,
    };
}
