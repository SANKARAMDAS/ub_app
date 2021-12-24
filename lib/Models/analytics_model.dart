// To parse this JSON data, do
//
//     final analyticsModel = analyticsModelFromJson(jsonString);

import 'dart:convert';

AnalyticsModel analyticsModelFromJson(String str) =>
    AnalyticsModel.fromJson(json.decode(str));

String analyticsModelToJson(AnalyticsModel data) => json.encode(data.toJson());

class AnalyticsModel {
  AnalyticsModel({
    required this.status,
    required this.data,
    required this.statusCode,
  });

  bool status;
  List<Datum> data;
  int statusCode;

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) => AnalyticsModel(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] =
            List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "statusCode": statusCode == null ? null : statusCode,
      };
}

class Datum {
  Datum({
    this.suspense,
    this.id,
    this.status,
    this.message,
    this.amount,
    this.currency,
    this.urbanledgerId,
    this.transactionId,
    this.paymentMethod,
    this.completed,
    this.from,
    this.fromEmail,
    this.to,
    this.toEmail,
    this.endingWith,
    this.cardType,
    this.through,
    this.type,
    this.toCustId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.fromCustId,
    this.fromMobileNumber,
  });

  bool? suspense;
  String? id;
  dynamic? status;
  String? message;
  int? amount;
  String? currency;
  String? urbanledgerId;
  String? transactionId;
  String? paymentMethod;
  DateTime? completed;
  String? from;
  String? fromEmail;
  String? to;
  String? toEmail;
  String? endingWith;
  String? cardType;
  String? through;
  String? type;
  CustId? toCustId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  CustId? fromCustId;
  String? fromMobileNumber;

  static const tableName = 'tb_analytics';

  static const columnid = 'id';
  static const columnul_id = 'ul_id';
  static const columntransaction_id = 'transaction_id';
  static const columnamount = 'amount';
  // static const columnname = 'name';
  static const columnmobile_no = 'mobile_no';
  static const columncurrency = 'currency';
  static const columnfrom = 'from_cust';
  static const columnto = 'to';
  static const columnthrough = 'through';
  static const columntype = 'type';
  static const columnsuspense = 'suspense';
  static const columncreated_at = 'created_at';
  static const columnupdated_at = 'updated_at';
  static const columnstatus = 'status';

  Map<String, dynamic> toDb() => {
        columnid: id,
        columnul_id: urbanledgerId,
        columntransaction_id: transactionId,
        columnamount: amount,
        columnmobile_no: fromMobileNumber ?? 'XXXXXXXXXX',
        columnfrom: from ?? 'XXX XXX',
        columncurrency: currency,
        columnthrough: through,
        columntype: type,
        columnsuspense: suspense! ? 0 : 1,
        columncreated_at: createdAt!.toIso8601String(),
        columnupdated_at: updatedAt!.toIso8601String(),
        columnstatus: 0,
      };

  Datum fromDb(Map<String, dynamic> element) {
    Datum transactionData = Datum();
    try{

      transactionData.urbanledgerId = element[columnul_id];
      transactionData.transactionId = element[columntransaction_id];
      transactionData.amount = element[columnamount];
      // suspenseData.id = element[columnid];
      transactionData.currency = element[columncurrency];
      transactionData.suspense = element[columnsuspense] == 1 ? true : false;
      transactionData.createdAt =
          DateTime.tryParse(element[columncreated_at]) ?? DateTime.now();
      transactionData.updatedAt =   element.containsKey(columnupdated_at)? DateTime.tryParse(element[columnupdated_at]):null;

      transactionData.to = element[columnto];
      transactionData.from = element[columnfrom];
      transactionData.fromMobileNumber = element[columnmobile_no].toString();
      transactionData.type = element[columntype];
    }
    catch(e){
      print(e.toString());
    }



    return transactionData;
  }

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        suspense: json["suspense"] == null ? 0 : json["suspense"],
        id: json["_id"] == null ? null : json["_id"],
        status: json["status"] == null ? null : json["status"].toString(),
        message: json["message"] == null ? null : json["message"],
        amount: json["amount"] == null ? null : json["amount"],
        currency: json["currency"] == null ? null : json["currency"],
        urbanledgerId:
            json["urbanledgerId"] == null ? null : json["urbanledgerId"],
        transactionId:
            json["transactionId"] == null ? null : json["transactionId"],
        paymentMethod:
            json["paymentMethod"] == null ? null : json["paymentMethod"],
        completed: DateTime.parse(json["completed"]),
        from: json["from"] == null ? null : json["from"],
        fromEmail: json["fromEmail"] == null ? null : json["fromEmail"],
        to: json["to"] == null ? null : json["to"],
        toEmail: json["toEmail"] == null ? null : json["toEmail"],
        endingWith: json["endingWith"] == null ? null : json["endingWith"],
        cardType: json["cardType"] == null ? null : json["cardType"],
        through: json["through"] == null ? 'DIRECT' : json["through"],
        type: json["type"] == null ? 'DIRECT' : json["type"],
        // toCustId: CustId.fromJson(json["toCustId"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"] == null ? null : json["__v"],
        // fromCustId: CustId.fromJson(json["fromCustId"]),
        fromMobileNumber:
            json["fromMobileNumber"] == null ? null : json["fromMobileNumber"],
      );

  Map<String, dynamic> toJson() => {
        "suspense": suspense == null ? null : suspense,
        "_id": id == null ? null : id,
        "status": status == null ? null : status.toString(),
        "message": message == null ? null : message,
        "amount": amount == null ? null : amount,
        "currency": currency == null ? null : currency,
        "urbanledgerId": urbanledgerId == null ? null : urbanledgerId,
        "transactionId": transactionId == null ? null : transactionId,
        "paymentMethod": paymentMethod == null ? null : paymentMethod,
        "completed": completed == null ? null : completed?.toIso8601String(),
        "from": from == null ? null : from,
        "fromEmail": fromEmail == null ? null : fromEmail,
        "to": to == null ? null : to,
        "toEmail": toEmail == null ? null : toEmail,
        "endingWith": endingWith == null ? null : endingWith,
        "cardType": cardType == null ? null : cardType,
        "through": through == null ? null : through,
        "type": type == null ? null : type,
        "toCustId": toCustId == null ? null : toCustId?.toJson(),
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "__v": v == null ? null : v,
        "fromCustId": fromCustId == null ? null : fromCustId?.toJson(),
        "fromMobileNumber": fromMobileNumber == null ? null : fromMobileNumber,
      };
}

class CustId {
  CustId({
    this.id,
    this.mobileNo,
    this.registeredOn,
    this.chatId,
    this.emailId,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.updatedAt,
  });

  String? id;
  String? mobileNo;
  DateTime? registeredOn;
  String? chatId;
  String? emailId;
  String? firstName;
  String? lastName;
  String? profilePic;
  DateTime? updatedAt;

  factory CustId.fromJson(Map<String, dynamic> json) => CustId(
        id: json["_id"] == null ? null : json["_id"],
        mobileNo: json["mobile_no"] == null ? null : json["mobile_no"],
        registeredOn: DateTime.parse(json["registered_on"]),
        chatId: json["chat_id"] == null ? null : json["chat_id"],
        emailId: json["email_id"] == null ? null : json["email_id"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        profilePic: json["profilePic"] == null ? null : json["profilePic"],
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "mobile_no": mobileNo == null ? null : mobileNo,
        "registered_on":
            registeredOn == null ? null : registeredOn?.toIso8601String(),
        "chat_id": chatId == null ? null : chatId,
        "email_id": emailId == null ? null : emailId,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "profilePic": profilePic == null ? null : profilePic,
        "updatedAt": updatedAt == null ? null : updatedAt?.toIso8601String(),
      };
}
