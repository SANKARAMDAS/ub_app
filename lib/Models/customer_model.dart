import 'dart:typed_data';

import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class CustomerModel {
  static const customerTableName = 'CUSTOMER';

  static const columnId = 'ID';

  static const columnChatId = 'CHATID';

  static const columnName = 'NAME';

  static const columnMobileNo = 'MOBILENO';

  static const columnAvatar = 'AVATAR';

  static const columnTransactionAmount = 'TRANSACTIONAMOUNT';

  static const columnUpdatedDate = 'UPDATEDDATE';

  static const columnUpdatedAt = 'UPDATEDAT';

  static const columnCreatedDate = 'CREATEDDATE';

  static const columnTransactionType = 'TRANSACTIONTYPE';

  static const columnCollectionDate = 'COLLECTIONDATE';

  static const columnIsChanged = 'ISCHANGED';

  static const columnIsDeleted = 'ISDELETED';

  static const columnBusinessId = 'BUSINESSID';

  String? customerId;
  String? name;
  String? chatId;
  String? mobileNo;
  Uint8List? avatar;
  Future<bool>? isAdded;
  DateTime? updatedDate;
  DateTime? updatedAt;
  double? transactionAmount;
  TransactionType? transactionType;
  bool? isChanged;
  bool? isDeleted;
  DateTime? collectionDate;
  String? businessId;
  String? ulId;
  DateTime? createdDate;

  Map<String, dynamic> toDb() => {
        columnId: customerId,
        columnName: name,
        columnMobileNo: mobileNo!.replaceAll('+', '').replaceAll(' ', ''),
        columnChatId: chatId,
        columnAvatar: avatar,
        columnTransactionAmount: removeDecimalif0(transactionAmount ?? 0),
        columnUpdatedAt:
            updatedAt?.toIso8601String(),
        columnCreatedDate:
            createdDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
        columnTransactionType: transactionType == null
            ? null
            : transactionType == TransactionType.Pay
                ? 'PAY'
                : 'RECEIVE',
        columnBusinessId: businessId,
        columnCollectionDate: collectionDate?.toIso8601String(),
        columnIsChanged: isChanged == null
            ? 1
            : isChanged!
                ? 1
                : 0,
        columnIsDeleted: isDeleted == null
            ? 0
            : isDeleted!
                ? 1
                : 0
      };

  CustomerModel fromDb(Map<String, dynamic> element) {
    CustomerModel customerModel = CustomerModel();
    customerModel.customerId = element[CustomerModel.columnId];
    customerModel.businessId = element[CustomerModel.columnBusinessId];
    customerModel.name = element[CustomerModel.columnName];
    customerModel.mobileNo = element[CustomerModel.columnMobileNo];
    customerModel.avatar = element[CustomerModel.columnAvatar];
    customerModel.transactionAmount =
        double.tryParse(element[CustomerModel.columnTransactionAmount]) ?? 0;
    customerModel.updatedAt =
        DateTime.tryParse(element[CustomerModel.columnUpdatedAt]) ??
            DateTime.now();
    customerModel.createdDate =
        DateTime.tryParse(element[CustomerModel.columnCreatedDate]) ??
            DateTime.now();
    customerModel.transactionType =
        element[CustomerModel.columnTransactionType] == null
            ? null
            : element[CustomerModel.columnTransactionType] == 'PAY'
                ? TransactionType.Pay
                : TransactionType.Receive;
    customerModel.chatId = element[CustomerModel.columnChatId];
    customerModel.collectionDate =
        element[CustomerModel.columnCollectionDate] == null
            ? null
            : DateTime.tryParse(element[CustomerModel.columnCollectionDate]) ??
                null;
    return customerModel;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'mobilenumber': mobileNo,
        'uid': customerId,
        "business": businessId,
        "chat_id": chatId,
        'transactionAmount': transactionAmount ?? 0,
        'updatedAt':
            updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'transactionType': transactionType == null
            ? null
            : transactionType == TransactionType.Pay
                ? 'Debit'
                : 'Credit',
        'collectionDate': collectionDate?.toIso8601String(),
        'createdDate':
            createdDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      };
}
