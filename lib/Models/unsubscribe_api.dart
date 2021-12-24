// To parse this JSON data, do
//
//     final unsubscribeModel = unsubscribeModelFromJson(jsonString);

import 'dart:convert';

UnsubscribeModel unsubscribeModelFromJson(String str) =>
    UnsubscribeModel.fromJson(json.decode(str));

String unsubscribeModelToJson(UnsubscribeModel data) =>
    json.encode(data.toJson());

class UnsubscribeModel {
  UnsubscribeModel({
    this.status,
    this.data,
  });

  bool? status;
  UnSubscribe? data;

  factory UnsubscribeModel.fromJson(Map<String, dynamic> json) =>
      UnsubscribeModel(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : UnSubscribe.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data!.toJson(),
      };
}

class UnSubscribe {
  UnSubscribe({
    this.n,
    this.nModified,
    this.opTime,
    this.electionId,
    this.ok,
    this.clusterTime,
    this.operationTime,
  });

  int? n;
  int? nModified;
  OpTime? opTime;
  String? electionId;
  int? ok;
  ClusterTime? clusterTime;
  String? operationTime;

  factory UnSubscribe.fromJson(Map<String, dynamic> json) => UnSubscribe(
        n: json["n"] == null ? null : json["n"],
        nModified: json["nModified"] == null ? null : json["nModified"],
        opTime: json["opTime"] == null ? null : OpTime.fromJson(json["opTime"]),
        electionId: json["electionId"] == null ? null : json["electionId"],
        ok: json["ok"] == null ? null : json["ok"],
        clusterTime: json["\u0024clusterTime"] == null
            ? null
            : ClusterTime.fromJson(json["\u0024clusterTime"]),
        operationTime:
            json["operationTime"] == null ? null : json["operationTime"],
      );

  Map<String, dynamic> toJson() => {
        "n": n == null ? null : n,
        "nModified": nModified == null ? null : nModified,
        "opTime": opTime == null ? null : opTime!.toJson(),
        "electionId": electionId == null ? null : electionId,
        "ok": ok == null ? null : ok,
        "\u0024clusterTime": clusterTime == null ? null : clusterTime!.toJson(),
        "operationTime": operationTime == null ? null : operationTime,
      };
}

class ClusterTime {
  ClusterTime({
    this.clusterTime,
    this.signature,
  });

  String? clusterTime;
  Signature? signature;

  factory ClusterTime.fromJson(Map<String, dynamic> json) => ClusterTime(
        clusterTime: json["clusterTime"] == null ? null : json["clusterTime"],
        signature: json["signature"] == null
            ? null
            : Signature.fromJson(json["signature"]),
      );

  Map<String, dynamic> toJson() => {
        "clusterTime": clusterTime == null ? null : clusterTime,
        "signature": signature == null ? null : signature!.toJson(),
      };
}

class Signature {
  Signature({
    this.hash,
    this.keyId,
  });

  String? hash;
  String? keyId;

  factory Signature.fromJson(Map<String, dynamic> json) => Signature(
        hash: json["hash"] == null ? null : json["hash"],
        keyId: json["keyId"] == null ? null : json["keyId"],
      );

  Map<String, dynamic> toJson() => {
        "hash": hash == null ? null : hash,
        "keyId": keyId == null ? null : keyId,
      };
}

class OpTime {
  OpTime({
    this.ts,
    this.t,
  });

  String? ts;
  int? t;

  factory OpTime.fromJson(Map<String, dynamic> json) => OpTime(
        ts: json["ts"] == null ? null : json["ts"],
        t: json["t"] == null ? null : json["t"],
      );

  Map<String, dynamic> toJson() => {
        "ts": ts == null ? null : ts,
        "t": t == null ? null : t,
      };
}
