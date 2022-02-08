import 'dart:convert';

class Message {
  Message({
    this.localId,
    this.id,
    this.chatId,
    this.from,
    this.to,
    this.sendAt,
    this.unreadByMe,
    this.message,
    this.paymentCancel,
    // this.avatar,
  });

  int? localId;
  String? id;
  String? chatId;
  String? from;
  String? to;
  int? sendAt;
  bool? unreadByMe;
  bool? paymentCancel;
  Messages? message;

  // Uint8List avatar;

  Message.fromJson(Map<String, dynamic> json) {
    //put null checker
    id = json['_id'] == null ? null : json['_id'];
    chatId = json['chatId'] == null ? null : json['chatId'];
    from = json['from']['_id'] == null ? null : json['from']['_id'];
    to = json['to']['_id'] == null ? null : json['to']['_id'];
    unreadByMe = json['unreadByMe'] == null ? null : json['unreadByMe'] ?? true;
    sendAt = json['sendAt'] == null ? null : json['sendAt'];
    message = Messages.fromJson(jsonDecode(json["message"]));
  }

  String? get dateTime => message!.dateTime;
  int? get messageType => message!.messageType;
  String? get msg => message!.messages;
  String? get details => message!.details;
  String? get fileName => message!.fileName;
  String? get fileSize => message!.fileSize;
  String? get duration => message!.duration;
  double? get amount => message!.amount;
  String? get contactName => message!.contactName;
  String? get contactNo => message!.contactNo;
  String? get transactionId => message!.transactionId;
  String? get requestId => message!.requestId;
  int? get attachmentCount => message!.attachmentCount;
  int? get paymentStatus => message!.paymentStatus;
  String? get urbanledgerId => message!.urbanledgerId;
  String? get type => message!.type;
  String? get through => message!.through;
  int? get suspense => message!.suspense;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['_id'] = id;
    json['chatId'] = chatId;
    json['from'] = from;
    json['to'] = to;
    json['sendAt'] = sendAt;
    json["message"] = jsonEncode(message!.toJson());
    return json;
  }

  Message.fromLocalDatabaseMap(Map<String, dynamic> json) {
    localId = json["id_message"];
    id = json["_id"];
    chatId = json["chat_id"];
    from = json["from_user"];
    to = json["to_user"];
    sendAt = json["send_at"];
    unreadByMe = json["unread_by_me"] == 0;
    paymentCancel = json["payment_cancel"] == 0;
    message = Messages.fromDB(json);
  }

  Map<String, dynamic> toLocalDatabaseMap() {
    Map<String, dynamic> map = {};
    map["_id"] = id;
    map["chat_id"] = chatId;
    map["from_user"] = from;
    map["to_user"] = to;
    map["send_at"] = sendAt;
    map["unread_by_me"] = (unreadByMe ?? false) ? 1 : 0;
    map["payment_cancel"] = (paymentCancel ?? false) ? 1 : 0;
    map.addAll(message!.toDB());
    return map;
  }

  Message copyWith({
    int? localId,
    String? id,
    bool? unreadByMe,
  }) {
    return Message(
      localId: localId ?? this.localId,
      id: id ?? this.id,
      chatId: this.chatId,
      message: this.message,
      from: this.from,
      to: this.to,
      sendAt: this.sendAt,
      unreadByMe: unreadByMe ?? this.unreadByMe,
    );
  }
}

class Messages {
  Messages(
      {this.amount,
      this.details,
      this.messages,
      this.dateTime,
      this.messageType,
      this.contactName,
      this.contactNo,
      this.transactionId,
      this.urbanledgerId,
      this.requestId,
      this.attachmentCount,
      this.paymentStatus,
      this.suspense,
      this.through,
      this.type,
      this.fileName,
      this.fileSize,
      this.duration
      // this.avatar,
      });

  double? amount;
  String? details;
  String? messages;
  String? dateTime;
  int? messageType;
  String? contactName;
  String? contactNo;
  String? transactionId;
  String? urbanledgerId;
  String? requestId;
  int? attachmentCount;
  int? paymentStatus;
  String? type;
  String? fileName;
  String? fileSize;
  String? duration;
  String? through;
  int? suspense;
  // Uint8List avatar;

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        amount: json["amount"] == null ? null : json["amount"] is int ? double.parse(json["amount"].toString()) : json["amount"] is String ? double.parse(json["amount"].toString()): json["amount"],
        details: json["details"] == null ? null : json["details"],
        requestId: json["request_id"] == null ? null : json["request_id"],
        attachmentCount:
            json["attachment_count"] == null ? null : json["attachment_count"],
        messages: json["messages"] == null ? null : json["messages"],
        dateTime: json["date_time"] == null ? null : json["date_time"],
        contactName: json["contact_name"] == null ? null : json["contact_name"],
        contactNo: json["contact_no"] == null ? null : json["contact_no"],
        transactionId:
            json["transaction_id"] == null ? null : json["transaction_id"],
        urbanledgerId:
            json["urbanledger_id"] == null ? null : json["urbanledger_id"],
        paymentStatus:
            json["payment_status"] == null ? null : json["payment_status"],
        // avatar: json["avatar"]==null?null:json["avatar"],
        messageType: json["messageType"] == null ? null : json["messageType"],
        type: json["type"] == null ? null : json["type"],
        fileName: json["file_name"] == null ? null : json["file_name"],
        fileSize: json["file_size"] == null ? null : json["file_size"],
        duration: json["duration"] == null ? null : json["duration"],
        through: json["through"] == null ? null : json["through"],
        suspense: json["suspense"] == null ? null : json["suspense"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount == null ? null : amount,
        "details": details == null ? null : details,
        "request_id": requestId == null ? null : requestId,
        "attachment_count": attachmentCount == null ? null : attachmentCount,
        "messages": messages == null ? null : messages,
        "date_time": dateTime == null ? null : dateTime,
        "contact_name": contactName == null ? null : contactName,
        "contact_no": contactNo == null ? null : contactNo,
        "transaction_id": transactionId == null ? null : transactionId,
        "urbanledger_id": urbanledgerId == null ? null : urbanledgerId,
        "payment_status": paymentStatus == null ? null : paymentStatus,
        "type": type == null ? null : type,
        "file_name": fileName == null ? null : fileName,
        "file_size": fileSize == null ? null : fileSize,
        "duration": duration == null ? null : duration,
        "through": through == null ? null : through,
        "suspense": suspense == null ? null : suspense,
        // "avatar": avatar==null?null:avatar,
        "messageType": messageType == null ? null : messageType,
      };

  factory Messages.fromDB(Map<String, dynamic> json) => Messages(
        amount: json["amount"] == null ? null : json["amount"] is int ? double.parse(json["amount"].toString()) : json["amount"] is String ? double.parse(json["amount"].toString()): json["amount"],
        details: json["details"] == null ? null : json["details"],
        requestId: json["request_id"] == null ? null : json["request_id"],
        attachmentCount:
            json["attachment_count"] == null ? null : json["attachment_count"],
        messages: json["message"] == null ? null : json["message"],
        dateTime: json["date_time"] == null ? null : json["date_time"],
        contactName: json["contact_name"] == null ? null : json["contact_name"],
        contactNo: json["contact_no"] == null ? null : json["contact_no"],
        transactionId:
            json["transaction_id"] == null ? null : json["transaction_id"],
        urbanledgerId:
            json["urbanledger_id"] == null ? null : json["urbanledger_id"],
        paymentStatus:
            json["payment_status"] == null ? null : json["payment_status"],
        // avatar: json["avatar"]==null?null:json["avatar"],
        messageType: json["messageType"] == null ? null : json["messageType"],
        type: json["type"] == null ? null : json["type"],
        fileName: json["file_name"] == null ? null : json["file_name"],
        fileSize: json["file_size"] == null ? null : json["file_size"],
        duration: json["duration"] == null ? null : json["duration"],
        through: json["through"] == null ? null : json["through"],
        suspense: json["suspense"] == null ? null : json["suspense"],
      );

  Map<String, dynamic> toDB() => {
        "amount": amount == null ? null : amount,
        "details": details == null ? null : details,
        "attachment_count": attachmentCount == null ? null : attachmentCount,
        "request_id": requestId == null ? null : requestId,
        "message": messages == null ? null : messages,
        "date_time": dateTime == null ? null : dateTime,
        "contact_name": contactName == null ? null : contactName,
        "contact_no": contactNo == null ? null : contactNo,
        "transaction_id": transactionId == null ? null : transactionId,
        "urbanledger_id": urbanledgerId == null ? null : urbanledgerId,
        "payment_status": paymentStatus == null ? null : paymentStatus,
        // "avatar": avatar==null?null:avatar,
        "messageType": messageType == null ? null : messageType,
        "type": type == null ? null : type,
        "file_name": fileName == null ? null : fileName,
        "file_size": fileSize == null ? null : fileSize,
        "duration": duration == null ? null : duration,
        "through": through == null ? null : through,
        "suspense": suspense == null ? null : suspense,
      };
}
