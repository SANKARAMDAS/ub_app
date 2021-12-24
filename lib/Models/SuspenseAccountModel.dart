import 'dart:convert';

SuspenseAccountModel suspenseAccountModelFromJson(String? str) =>
    SuspenseAccountModel.fromJson(json.decode(str!));

String? suspenseAccountModelToJson(SuspenseAccountModel data) =>
    json.encode(data.toJson());

class SuspenseAccountModel {
  SuspenseAccountModel({
    this.status,
    this.data,
    this.statusCode,
  });

  String? status;
  List<SuspenseData>? data;
  int? statusCode;

  factory SuspenseAccountModel.fromJson(Map<String, dynamic> json) =>
      SuspenseAccountModel(
        status: json["status"] == null ? null : json["status"].toString(),
        data: json["data"] == null
            ? null
            : List<SuspenseData>.from(
                json["data"].map((x) => SuspenseData.fromJson(x))),
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
      );
  Map<String?, dynamic> toJson() => {
        "status": status == null ? null : status.toString(),
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "statusCode": statusCode == null ? null : statusCode,
      };
}

class SuspenseData {
  SuspenseData({
    this.suspense,
    this.id,
    this.status,
    this.message,
    this.amount = 0,
    this.currency,
    this.urbanledgerId,
    this.transactionId,
    this.paymentMethod,
    this.completed,
    this.from = '',
    this.fromEmail,
    this.to,
    this.toEmail,
    this.endingWith,
    this.cardType,
    this.through,
    this.type,
    this.cardImage,
    this.toCustId,
    this.fromCustId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.fromMobileNumber,
    this.isMoved,
    this.businessIds,
  });

  bool? suspense;
  String? id;
  String? status;
  String? message;
  int amount;
  String? currency;
  String? urbanledgerId;
  String? transactionId;
  String? paymentMethod;
  String from;
  String? fromEmail;
  String? to;
  String? toEmail;
  String? endingWith;
  String? cardType;
  String? through;
  String? type;
  String? cardImage;
  CustId? toCustId;
  CustId? fromCustId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? completed;

  int? v;
  String? fromMobileNumber;
  int? isMoved = 0;
  List? businessIds;

  //DB
  static const tableName = 'tb_suspenseAccount';

  static const columnid = 'id';
  static const columnchatId = 'chatId';

  static const columnsuspense = 'suspense';

  static const columncurrency = 'currency';
  static const columnamount = 'amount';

  static const columnurbanledgerId = 'urbanledgerId';
  static const columntransactionId = 'transactionId';
  static const columnfrom = 'from1';
  static const columnto = 'to1';
  static const columntoCustId = 'toCustId';
  static const columnfromCustId = 'fromCustId';
  static const columncreatedAt = 'createdAt';
  static const columnupdatedAt = 'updatedAt';
  static const columncompleted = 'completed';

  static const columnfromMobileNumber = 'fromMobileNumber';
  static const columnIsMoved = 'isMoved';
  static const columntype = 'type';
  static const columnbusinessIds = 'businessIds';

  //cardImage
  static const columncardImage = 'cardImage';
  static const columnfromEmail = 'fromEmail';
  static const columntoEmail = 'toEmail';
  static const columnpaymentMethod = 'paymentMethod';

  Map<String, dynamic> toDb() => {
        // columnid: id,
        columncardImage: cardImage,
        columnfromEmail: fromEmail,
        columntoEmail: toEmail,
        columnpaymentMethod: paymentMethod,
        columnurbanledgerId: urbanledgerId,
        columntransactionId: transactionId,
        columnamount: amount,
        columncurrency: currency,
        columnsuspense: suspense! == true ? 1 : 0,
        columncreatedAt: createdAt!.toIso8601String(),
        columnupdatedAt: updatedAt!.toIso8601String(),
        columncompleted: completed!.toIso8601String(),

        columnfromCustId: fromCustId?.id,
        columntoCustId: toCustId!.id,
        columnchatId: toCustId!.chatId,
        columnto: to,
        columnfrom: from,

        columnfromMobileNumber: fromCustId!.mobileNo.isEmpty
            ? fromMobileNumber
            : fromCustId!.mobileNo,
        columnIsMoved: isMoved ?? 0,
        columncardImage: cardImage ?? '',
        columnbusinessIds: jsonEncode(businessIds),

        columntype: type ?? ''
      };
  SuspenseData fromDb(Map<String, dynamic> element) {
    SuspenseData suspenseData = SuspenseData();
    suspenseData.urbanledgerId = element[columnurbanledgerId];
    suspenseData.transactionId = element[columntransactionId];
    suspenseData.amount = element[columnamount];
    // suspenseData.id = element[columnid];
    suspenseData.currency = element[columncurrency];
    suspenseData.suspense = element[columnsuspense] == 1 ? true : false;
    suspenseData.createdAt =
        DateTime.tryParse(element[columncreatedAt]) ?? DateTime.now();
    suspenseData.updatedAt = DateTime.parse(element[columnupdatedAt]);
    suspenseData.completed = DateTime.parse(element[columncompleted]);

    suspenseData.fromCustId =
        CustId(id: element[columnfromCustId], chatId: element[columnchatId]);
    suspenseData.toCustId = CustId(id: element[columntoCustId]);

    suspenseData.to = element[columnto];
    suspenseData.from = element[columnfrom];
    suspenseData.fromMobileNumber = element[columnfromMobileNumber].toString();
    suspenseData.isMoved = element[columnIsMoved];
    suspenseData.type = element[columntype];
    suspenseData.cardImage = element[columncardImage];
    suspenseData.cardType = element[columncardImage];
    suspenseData.fromEmail = element[columnfromEmail];
    suspenseData.toEmail = element[columntoEmail];
    suspenseData.businessIds = jsonDecode(element[columnbusinessIds]) ?? '';
    suspenseData.completed =
        DateTime.tryParse(element[columncompleted]) ?? DateTime.now();

    suspenseData.paymentMethod = element[columnpaymentMethod];

    return suspenseData;
  }

  factory SuspenseData.fromJson(Map<String, dynamic> json) => SuspenseData(
        suspense: json["suspense"] == null ? null : json["suspense"],
        id: json["_id"] == null ? null : json["_id"],
        status: json["status"] == null ? null : json["status"].toString(),
        message: json["message"] == null ? null : json["message"],
        amount: json["amount"] == null ? 0 : json["amount"],
        currency: json["currency"] == null ? null : json["currency"],
        urbanledgerId:
            json["urbanledgerId"] == null ? null : json["urbanledgerId"],
        transactionId:
            json["transactionId"] == null ? null : json["transactionId"],
        paymentMethod:
            json["paymentMethod"] == null ? null : json["paymentMethod"],
        // completed: json["completed"] == null ? null : json["completed"],
        from: json["from"] == null ? null : json["from"],
        fromEmail: json["fromEmail"] == null ? null : json["fromEmail"],
        to: json["to"] == null ? null : json["to"],
        toEmail: json["toEmail"] == null ? null : json["toEmail"],
        endingWith: json["endingWith"] == null ? null : json["endingWith"],
        cardType: json["cardType"] == null ? null : json["cardType"],
        through: json["through"] == null ? null : json["through"],
        type: json["type"] == null ? null : json["type"],
        cardImage: json["cardImage"] == null ? null : json["cardImage"],
        //cardImage
        toCustId:
            json["toCustId"] == null ? null : CustId.fromJson(json["toCustId"]),
        fromCustId: json["fromCustId"] == null
            ? CustId()
            : CustId.fromJson(json["fromCustId"]),
        fromMobileNumber:
            json["fromMobileNumber"] == null ? null : json["fromMobileNumber"],
        createdAt: json["createdAt"] == null
            ? DateTime.now()
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        completed: json["completed"] == null
            ? null
            : DateTime.parse(json["completed"]),

        businessIds: json["businessIds"] == null
            ? null
            : List<dynamic>.from(json["businessIds"].map((x) => x)),

        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String?, dynamic> toJson() => {
        "suspense": suspense == null ? null : suspense,
        "_id": id == null ? null : id,
        "status": status == null ? null : status.toString(),
        "message": message == null ? null : message,
        "amount": amount,
        "currency": currency == null ? null : currency,
        "urbanledgerId": urbanledgerId == null ? null : urbanledgerId,
        "transactionId": transactionId == null ? null : transactionId,
        "paymentMethod": paymentMethod == null ? null : paymentMethod,
        "completed": completed == null ? null : completed!.toIso8601String(),
        "from": from == null ? null : from,
        "fromEmail": fromEmail == null ? null : fromEmail,
        "to": to == null ? null : to,
        "toEmail": toEmail == null ? null : toEmail,
        "endingWith": endingWith == null ? null : endingWith,
        "cardType": cardType == null ? null : cardType,
        "through": through == null ? null : through,
        "type": type == null ? null : type,
        "cardImage": cardImage == null ? null : cardImage,
        "toCustId": toCustId == null ? null : toCustId!.toJson(),
        "fromCustId": fromCustId == null ? null : fromCustId!.toJson(),
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "__v": v == null ? null : v,
        "businessIds": businessIds == null
            ? null
            : List<dynamic>.from(businessIds!.map((x) => x)),
        "fromMobileNumber": fromMobileNumber == null ? null : fromMobileNumber,
      };
}

class CustId {
  CustId({
    this.id = '',
    this.mobileNo = '',
    this.registeredOn,
    this.chatId,
    this.emailId,
    this.firstName = '',
    this.lastName = '',
    this.profilePic,
    this.updatedAt,
  });

  String id;
  String mobileNo;
  DateTime? registeredOn;
  String? chatId;
  String? emailId;
  String firstName;
  String lastName;
  String? profilePic;
  DateTime? updatedAt;

  factory CustId.fromJson(Map<String?, dynamic> json) => CustId(
        id: json["_id"] == null ? '' : json["_id"],
        mobileNo: json["mobile_no"] == null ? '' : json["mobile_no"],
        registeredOn: json["registered_on"] == null
            ? null
            : DateTime?.parse(json["registered_on"]),
        chatId: json["chat_id"] == null ? null : json["chat_id"],
        emailId: json["email_id"] == null ? null : json["email_id"],
        firstName: json["first_name"] == null ? '' : json["first_name"],
        lastName: json["last_name"] == null ? '' : json["last_name"],
        profilePic: json["profilePic"] == null ? null : json["profilePic"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String?, dynamic> toJson() => {
        "_id": id,
        "mobile_no": mobileNo,
        "registered_on":
            registeredOn == null ? null : registeredOn!.toIso8601String(),
        "chat_id": chatId == null ? null : chatId,
        "email_id": emailId == null ? null : emailId,
        "first_name": firstName,
        "last_name": lastName,
        "profilePic": profilePic == null ? null : profilePic,
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}
