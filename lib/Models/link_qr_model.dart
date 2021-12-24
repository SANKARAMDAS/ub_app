// To parse this JSON data, do
//
//     final linkAndQrModel = linkAndQrModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LinkAndQrModel linkAndQrModelFromJson(String str) => LinkAndQrModel.fromJson(json.decode(str));

String linkAndQrModelToJson(LinkAndQrModel data) => json.encode(data.toJson());

class LinkAndQrModel {
    LinkAndQrModel({
        required this.listData,
        required this.totalLinks,
        required this.total,
    });

    List<ListDatum> listData;
    int totalLinks;
    double total;

    factory LinkAndQrModel.fromJson(Map<String, dynamic> json) => LinkAndQrModel(
      listData: List<ListDatum>.from(json["listData"].map((x) => ListDatum.fromJson(x))),
      totalLinks: json["totalLinks"] == null ? null : json["totalLinks"],
      total: json["total"] == null ? null : json["total"],
    );

    Map<String, dynamic> toJson() => {
        "listData": List<dynamic>.from(listData.map((x) => x.toJson())),
        "totalLinks": totalLinks,
        "total": total,
    };
}

class ListDatum {
    ListDatum({
        this.count,
        required this.day,
        this.totalamount,
    });

    int? count;
    String day;
    int? totalamount;

    factory ListDatum.fromJson(Map<String, dynamic> json) => ListDatum(
        count: json["COUNT"] == null ? null : json["COUNT"],
        day: json["DAY"] == null ? null : json["DAY"],
        totalamount: json["TOTALAMOUNT"] == null ? null : json["TOTALAMOUNT"],
    );

    Map<String, dynamic> toJson() => {
        "COUNT": count,
        "DAY": day,
        "TOTALAMOUNT": totalamount,
    };
}
