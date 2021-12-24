import 'package:equatable/equatable.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class CashbookEntryModel extends Equatable {
  static const tableName = 'CASHBOOK_ENTRY_TABLE';

  static const columnEntryId = 'ENTRYID';

  static const columnAmount = 'AMOUNT';

  static const columnEntryDetails = 'DETAILS';

  static const columnAttachment1 = 'ATTACHMENT1';

  static const columnAttachment2 = 'ATTACHMENT2';

  static const columnAttachment3 = 'ATTACHMENT3';

  static const columnAttachment4 = 'ATTACHMENT4';

  static const columnAttachment5 = 'ATTACHMENT5';

  static const columnEntryType = 'ENTRYTYPE';

  static const columnPaymentMode = 'PAYMENTMODE';

  static const columnCreatedDate = 'CREATEDDATE';

  static const columnCreatedDateOnly = 'CREATEDDATEONLY';

  static const columnIsChanged = 'ISCHANGED';

  static const columnIsDeleted = 'ISDELETED';

  static const columnBusinessId = 'BUSINESSID';

  final String entryId;
  final String businessId;
  final double amount;
  final String? details;
  final EntryType entryType;
  final PaymentMode paymentMode;
  final List<String?> attachments;
  final List<String> filePaths;
  final DateTime createdDate;
  final bool isChanged;
  final bool isDeleted;

  CashbookEntryModel(
      {required this.entryId,
      required this.businessId,
      required this.amount,
      this.details,
      this.attachments: const [],
      this.filePaths: const [],
      required this.entryType,
      required this.paymentMode,
      required this.createdDate,
      this.isChanged: false,
      this.isDeleted: false});

  CashbookEntryModel copyWith({
    String? entryId,
    String? businessId,
    double? amount,
    String? details,
    EntryType? entryType,
    PaymentMode? paymentMode,
    List<String?>? attachments,
    List<String>? filePaths,
    DateTime? createdDate,
    bool? isChanged,
    bool? isDeleted,
  }) =>
      CashbookEntryModel(
          entryId: entryId ?? this.entryId,
          businessId: businessId ?? this.businessId,
          amount: amount ?? this.amount,
          attachments: attachments ?? this.attachments,
          entryType: entryType ?? this.entryType,
          paymentMode: paymentMode ?? this.paymentMode,
          createdDate: createdDate ?? this.createdDate,
          details: details ?? this.details,
          filePaths: filePaths ?? this.filePaths,
          isChanged: isChanged ?? this.isChanged,
          isDeleted: isDeleted ?? this.isDeleted);

  Map<String, dynamic> toDb() => {
        columnEntryId: entryId,
        columnBusinessId: businessId,
        columnAmount: removeDecimalif0(amount),
        columnEntryDetails: details,
        columnAttachment1: attachments.length > 0 ? attachments[0] : null,
        columnAttachment2: attachments.length > 1 ? attachments[1] : null,
        columnAttachment3: attachments.length > 2 ? attachments[2] : null,
        columnAttachment4: attachments.length > 3 ? attachments[3] : null,
        columnAttachment5: attachments.length > 4 ? attachments[4] : null,
        columnEntryType: entryType == EntryType.IN ? 'IN' : 'OUT',
        columnPaymentMode: paymentMode == PaymentMode.Cash ? 'Cash' : 'Online',
        columnCreatedDate: createdDate.toIso8601String(),
        columnCreatedDateOnly: createdDate.toIso8601String().substring(0, 10),
        columnIsChanged: isChanged ? 1 : 0,
        columnIsDeleted: isDeleted ? 1 : 0
      };

  factory CashbookEntryModel.fromDb(Map<String, dynamic> element) {
    CashbookEntryModel cashbookEntryModel = CashbookEntryModel(
      entryId: element[CashbookEntryModel.columnEntryId] ?? '',
      amount: double.tryParse(element[CashbookEntryModel.columnAmount]) ?? 0,
      businessId: element[CashbookEntryModel.columnBusinessId]??'',
      attachments: [
        if (element[CashbookEntryModel.columnAttachment1] != null)
          element[CashbookEntryModel.columnAttachment1],
        if (element[CashbookEntryModel.columnAttachment2] != null)
          element[CashbookEntryModel.columnAttachment2],
        if (element[CashbookEntryModel.columnAttachment3] != null)
          element[CashbookEntryModel.columnAttachment3],
        if (element[CashbookEntryModel.columnAttachment4] != null)
          element[CashbookEntryModel.columnAttachment4],
        if (element[CashbookEntryModel.columnAttachment5] != null)
          element[CashbookEntryModel.columnAttachment5],
      ],
      paymentMode: element[CashbookEntryModel.columnPaymentMode] == 'Cash'
          ? PaymentMode.Cash
          : PaymentMode.Online,
      entryType: element[CashbookEntryModel.columnEntryType] == 'IN'
          ? EntryType.IN
          : EntryType.OUT,
      details: element[CashbookEntryModel.columnEntryDetails]??'',
      createdDate:
          DateTime.tryParse(element[CashbookEntryModel.columnCreatedDate]) ??
              DateTime.now(),
    );

    return cashbookEntryModel;
  }

  Map<String, dynamic> toJson() => {
        "entryId": entryId,
        "amount": amount,
        "currency": currencyAED,
        "paymentMode": paymentMode == PaymentMode.Cash ? 'cash' : 'online',
        "entryType": entryType == EntryType.IN ? 'IN' : 'OUT',
        "details": details,
        "createdDate": createdDate.toIso8601String().substring(0, 10),
        "bills": filePaths,
        'businessId': businessId
      };

  @override
  List<Object?> get props => [entryId];
}

enum EntryType { IN, OUT }

enum PaymentMode { Cash, Online }

class CashbookPdfModel {
  final DateTime date;
  final double onlineAmount;
  final double inAmount;
  final double outAmount;
  final double dailyBalance;
  final double cashInHand;

  CashbookPdfModel(
      {required this.date,
      required this.onlineAmount,
      required this.inAmount,
      required this.outAmount,
      required this.dailyBalance,
      required this.cashInHand});
}
