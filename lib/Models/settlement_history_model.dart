// To parse this JSON data, do
//
//     final settlementHistoryModel = settlementHistoryModelFromJson(jsonString);

import 'dart:convert';

SettlementHistoryModel settlementHistoryModelFromJson(String str) => SettlementHistoryModel.fromJson(json.decode(str));

String settlementHistoryModelToJson(SettlementHistoryModel data) => json.encode(data.toJson());

class SettlementHistoryModel {
  SettlementHistoryModel({
    this.count,
    this.data,
  });

  int? count;
  List<SettlementHistoryData>? data;

  factory SettlementHistoryModel.fromJson(Map<String, dynamic> json) => SettlementHistoryModel(
    count: json["count"],
    data: List<SettlementHistoryData>.from(json["data"].map((x) => SettlementHistoryData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SettlementHistoryData {
  SettlementHistoryData({
    this.id,
    this.transactionIds,
    this.status,
    this.isdeleted,
    this.settlementId,
    this.customerId,
    this.bankName,
    this.ibannNumber,
    this.fromDate,
    this.toDate,
    this.currency,
    this.totalSettlementAmount,
    this.totalFixedFeesAmount,
    this.totalMarginAmount,
    this.totalActualAmount,
    this.totalSettlementCommissionAmount,
    this.fileUrl,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  List<dynamic>? transactionIds;
  String? status;
  bool? isdeleted;
  String? settlementId;
  String? customerId;
  String? bankName;
  String? ibannNumber;
  DateTime? fromDate;
  DateTime? toDate;
  String? currency;
  double? totalSettlementAmount;
  double? totalFixedFeesAmount;
  double? totalMarginAmount;
  double? totalActualAmount;
  double? totalSettlementCommissionAmount;
  String? fileUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  static const tableName = 'tb_settlement_history';
  static const column_id = 'id';
  static const column_shId = 'shId';
  static const column_transactionIds = 'transactionIds';
  static const column_status = 'status';
  static const column_isdeleted = 'isdeleted';
  static const column_settlementId = 'settlementId';
  static const column_customerId = 'customerId';
  static const column_bankName = 'bankName';
  static const column_ibannNumber = 'ibannNumber';
  static const column_fromDate = 'fromDate';
  static const column_toDate = 'toDate';
  static const column_currency = 'currency';
  static const column_totalSettlementAmount = 'totalSettlementAmount';
  static const column_totalFixedFeesAmount = 'totalFixedFeesAmount';
  static const column_totalMarginAmount = 'totalMarginAmount';
  static const column_totalActualAmount = 'totalActualAmount';
  static const column_totalSettlementCommissionAmount = 'totalSettlementCommissionAmount';
  static const column_fileUrl = 'fileUrl';
  static const column_createdAt = 'createdAt';
  static const column_updatedAt = 'updatedAt';


  Map<String, dynamic> toDb() => {
    column_shId: id,
    column_transactionIds: jsonEncode(transactionIds),
    column_status: status,
    column_isdeleted : isdeleted! == true ? 1 : 0,
    column_settlementId : settlementId,
    column_customerId : customerId,
    column_bankName: bankName,
    column_ibannNumber: ibannNumber,
    column_fromDate: fromDate!.toIso8601String(),
    column_toDate : toDate!.toIso8601String(),
    column_currency : currency,
    column_totalSettlementAmount : totalSettlementAmount.toString(),
    column_totalFixedFeesAmount : totalFixedFeesAmount.toString(),
    column_totalMarginAmount : totalMarginAmount.toString(),
    column_totalActualAmount : totalActualAmount.toString(),
    column_totalSettlementCommissionAmount : totalSettlementCommissionAmount.toString(),
    column_fileUrl : fileUrl,
    column_createdAt: createdAt!.toIso8601String(),
    column_updatedAt : updatedAt!.toIso8601String(),
  };



  SettlementHistoryData fromDb(Map<String, dynamic> element) => SettlementHistoryData(
    id: element[column_shId],
    transactionIds: jsonDecode(element[column_transactionIds]),
    status: element[column_status],
    isdeleted: element[column_isdeleted] == 1?true:false,
    settlementId: element[column_settlementId],
    customerId: element[column_customerId],
    bankName:element[column_bankName],
    ibannNumber: element[column_ibannNumber],
    fromDate: DateTime.parse(element[column_fromDate]),
    toDate: DateTime.parse(element[column_toDate]),
    currency: element[column_currency],
    totalSettlementAmount: double.tryParse(element[column_totalSettlementAmount]),
    totalFixedFeesAmount: double.tryParse(element[column_totalFixedFeesAmount]),
    totalMarginAmount: double.tryParse(element[column_totalMarginAmount]),
    totalActualAmount: double.tryParse(element[column_totalActualAmount]),
    totalSettlementCommissionAmount: double.tryParse(element[column_totalSettlementCommissionAmount]),
    fileUrl: element[column_fileUrl],
    createdAt: DateTime.parse(element[column_createdAt]),
    updatedAt: DateTime.parse(element[column_updatedAt]),
  );





factory SettlementHistoryData.fromJson(Map<String, dynamic> json) => SettlementHistoryData(
    id: json["_id"],
    transactionIds: List<String>.from(json["transactionIds"].map((x) => x)),
    status: json["status"],
    isdeleted: json["isdeleted"],
    settlementId: json["settlement_id"],
    customerId: json["customer_id"],
    bankName: json["bank_name"],
    ibannNumber: json["ibann_number"],
    fromDate: DateTime.parse(json["from_date"]),
    toDate: DateTime.parse(json["to_date"]),
    currency: json["currency"],
    totalSettlementAmount: json["total_settlement_amount"].toDouble(),
    totalFixedFeesAmount: json["total_fixed_fees_amount"].toDouble(),
    totalMarginAmount: json["total_margin_amount"].toDouble(),
    totalActualAmount: json["total_actual_amount"].toDouble(),
    totalSettlementCommissionAmount: json["total_settlement_commission_Amount"].toDouble(),
    fileUrl: json["file_url"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "transactionIds": List<dynamic>.from(transactionIds!.map((x) => x)),
    "status": status,
    "isdeleted": isdeleted,
    "settlement_id": settlementId,
    "customer_id": customerId,
    "bank_name": bankName,
    "ibann_number": ibannNumber,
    "from_date": fromDate!.toIso8601String(),
    "to_date": toDate!.toIso8601String(),
    "currency": currency,
    "total_settlement_amount": totalSettlementAmount,
    "total_fixed_fees_amount": totalFixedFeesAmount,
    "total_margin_amount": totalMarginAmount,
    "total_actual_amount": totalActualAmount,
    "total_settlement_commission_Amount": totalSettlementCommissionAmount,
    "file_url": fileUrl,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}
