import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class TransactionModel {
  static const tableName = 'TRANSACTION_TABLE';

  static const columnTransactionId = 'TRANSACTIONID';

  static const columnAmount = 'AMOUNT';

  static const columnDate = 'DATE';

  static const columnCreatedDate = 'CREATEDDATE';

  static const columnTransactionDetails = 'DETAILS';

  static const columnAttachment1 = 'ATTACHMENT1';

  static const columnAttachment2 = 'ATTACHMENT2';

  static const columnAttachment3 = 'ATTACHMENT3';

  static const columnAttachment4 = 'ATTACHMENT4';

  static const columnAttachment5 = 'ATTACHMENT5';

  static const columnCustomerId = 'CUSTOMERID';

  static const columnTransactionType = 'TRANSACTIONTYPE';

  static const columnBusiness = 'BUSSINESS';

  static const columnBalanceAmount = 'BALANCEAMOUNT';

  static const columnIsPayment = 'ISPAYMENT';

  static const columnPaymentTransactionId = 'PAYMENTTRANSACTIONID';

  static const columnIsReadOnly = 'ISREADONLY';

  static const columnIsChanged = 'ISCHANGED';

  static const columnIsDeleted = 'ISDELETED';

  String? transactionId;
  double? amount;
  double? balanceAmount;
  DateTime? date;
  List<String?> attachments = [];
  DateTime? createddate;
  String details = '';
  String? customerId;
  TransactionType? transactionType;
  bool? isChanged;
  bool? isDeleted;
  List<String> filePaths = [];
  bool isPayment = false;
  String paymentTransactionId = '';
  String? business;
  bool isReadOnly = false;
  String fromMobileNumber = '';

  Map<String, dynamic> toDb() => {
        columnTransactionId: transactionId,
        columnAmount: removeDecimalif0(amount),
        columnBalanceAmount:
            balanceAmount == null ? 0 : removeDecimalif0(balanceAmount),
        columnDate: date!.toIso8601String(),
        columnTransactionDetails: details,
        columnAttachment1: attachments.length > 0 ? attachments[0] : null,
        columnAttachment2: attachments.length > 1 ? attachments[1] : null,
        columnAttachment3: attachments.length > 2 ? attachments[2] : null,
        columnAttachment4: attachments.length > 3 ? attachments[3] : null,
        columnAttachment5: attachments.length > 4 ? attachments[4] : null,
        columnCustomerId: customerId,
        columnTransactionType:
            transactionType == TransactionType.Pay ? 'PAY' : 'RECEIVE',
        columnIsPayment: isPayment ? 1 : 0,
        columnPaymentTransactionId: paymentTransactionId,
        columnCreatedDate:
            createddate?.toIso8601String() ?? DateTime.now().toIso8601String(),
        columnIsChanged: isChanged == null
            ? 1
            : isChanged!
                ? 1
                : 0,
        columnIsDeleted: isDeleted == null
            ? 0
            : isDeleted!
                ? 1
                : 0,
        columnBusiness: business,
        columnIsReadOnly: isReadOnly ? 1 : 0
      };

  TransactionModel fromDb(Map<String, dynamic> element) {
    TransactionModel transactionModel = TransactionModel();
    transactionModel.transactionId =
        element[TransactionModel.columnTransactionId];
    transactionModel.customerId = element[TransactionModel.columnCustomerId];
    transactionModel.amount =
        double.tryParse(element[TransactionModel.columnAmount]) ?? 0;
    transactionModel.balanceAmount =
        double.tryParse(element[TransactionModel.columnBalanceAmount]) ?? 0;
    transactionModel.date =
        DateTime.tryParse(element[TransactionModel.columnDate]);
    transactionModel.details =
        element[TransactionModel.columnTransactionDetails];
    transactionModel.transactionType =
        element[TransactionModel.columnTransactionType] == 'PAY'
            ? TransactionType.Pay
            : TransactionType.Receive;
    transactionModel.isPayment =
        element[TransactionModel.columnIsPayment] == 1 ? true : false;
    transactionModel.paymentTransactionId =
        element[TransactionModel.columnPaymentTransactionId];
    transactionModel.createddate =
        DateTime.tryParse(element[TransactionModel.columnCreatedDate]);
    transactionModel.attachments.addAll([
      if (element[TransactionModel.columnAttachment1] != null)
        element[TransactionModel.columnAttachment1],
      if (element[TransactionModel.columnAttachment2] != null)
        element[TransactionModel.columnAttachment2],
      if (element[TransactionModel.columnAttachment3] != null)
        element[TransactionModel.columnAttachment3],
      if (element[TransactionModel.columnAttachment4] != null)
        element[TransactionModel.columnAttachment4],
      if (element[TransactionModel.columnAttachment5] != null)
        element[TransactionModel.columnAttachment5],
    ]);
    transactionModel.business = element[TransactionModel.columnBusiness];
    transactionModel.isReadOnly =
        element[TransactionModel.columnIsReadOnly] == 1 ? true : false;
    transactionModel.isChanged =
        element[TransactionModel.columnIsChanged] == 1 ? true : false;
    return transactionModel;
  }

  Map<String, dynamic> toJson() => {
        "contact_id": customerId,
        "business": business,
        "uid": transactionId,
        "amount": amount,
        "currency": currencyAED,
        "type": transactionType == TransactionType.Pay ? 'DR' : 'CR',
        "desc": details,
        "trans_date": date!.toIso8601String(),
        "bills": filePaths,
        "updatedDate":
            createddate?.toIso8601String() ?? DateTime.now().toIso8601String(),
        "balanceAmount":
            balanceAmount == null ? 0 : removeDecimalif0(balanceAmount),
        "paymentTransactionId": paymentTransactionId,
        "isPayment": isPayment,
        "isReadOnly": isReadOnly,
        "fromMobileNumber": fromMobileNumber
      };
}

enum TransactionType { Pay, Receive }
