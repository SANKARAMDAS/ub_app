import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:urbanledger/Models/cashbook_entry_model.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/plan_model.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/chat_module/data/models/message.dart';
import 'package:urbanledger/chat_module/data/models/user.dart';

class CalculatorRouteArgs {
  final bool toTheCustomer;
  final int? paymentType;
  final CustomerModel? customerModel;
  final TransactionModel? transactionModel;
  final Function(double? amount, String? details, int? paymentType)?
      sendMessage;

  CalculatorRouteArgs(
      {required this.toTheCustomer,
      required this.paymentType,
      required this.sendMessage,
      this.transactionModel,
      @required this.customerModel});
}

class AttachBillArgs {
  final TransactionModel transactionModel;
  final String customerName;

  AttachBillArgs(this.transactionModel, this.customerName);
}

class EnterDetailsRouteArgs {
  final CustomerModel? customerModel;
  final TransactionModel transactionModel;
  final Function(double? amount, String? details, int? paymentType)?
      sendMessage;

  EnterDetailsRouteArgs(
      this.customerModel, this.transactionModel, this.sendMessage);
}

class VerificationScreenRouteArgs {
  final String phoneNo;
  final bool isRegister;

  VerificationScreenRouteArgs(this.phoneNo, this.isRegister);
}

class ContactListRouteArgs {
  final String? phoneNo;
  final String? customerName;
  final String? customerId;
  final String? chatId;
  final Function(String? contactName, String? contactNo, int messageType)?
      sendContact;

  ContactListRouteArgs(this.phoneNo, this.customerName, this.customerId,
      this.chatId, this.sendContact);
}

class SetPinRouteArgs {
  final String tempPin;
  final bool showConfirmPinState;
  final bool isResetPinState;
  final bool isRegister;

  SetPinRouteArgs(this.tempPin, this.showConfirmPinState, this.isResetPinState,
      this.isRegister);
}

class IntroRouteArgs {
  final bool isRegister;

  IntroRouteArgs(this.isRegister);
}

class AddEntryScreenRouteArgs {
  final CashbookEntryModel? cashbookEntryModel;
  final EntryType entryType;
  final DateTime selectedDate;

  AddEntryScreenRouteArgs(
      this.cashbookEntryModel, this.entryType, this.selectedDate);
}

class CashbookEntryDetailsArgs {
  final CashbookEntryModel cashbookEntryModel;

  final DateTime selectedDate;

  CashbookEntryDetailsArgs(this.cashbookEntryModel, this.selectedDate);
}

class QRDataArgs {
  final CustomerModel? customerModel;
  final String customerId;
  final String? fName;
  final String? lName;
  final String? amount;
  final String? note;
  final String? mobileNo;
  final String? currency;
  final String type;
  final String through;
  final bool suspense;
  final String? requestId;

  QRDataArgs(
      {required this.customerModel,
      required this.customerId,
      this.fName,
      this.lName,
      this.mobileNo,
      this.amount,
      this.currency,
      this.note,
      required this.type,
      required this.through,
      required this.suspense,
      this.requestId});
}

class ChangePinVArgs {
  final String token;
  final bool isSettings;

  ChangePinVArgs(this.token, this.isSettings);
}

class TransactionDetailsArgs {
  final String? urbanledgerId;
  final String? transactionId;
  final String? to;
  final String? toEmail;
  final String? from;
  final String? fromEmail;
  final String? completed;
  final String? paymentMethod;
  final String? amount;
  final String? customerName;
  final String? mobileNo;
  final String? cardImage;
  final String? endingWith;
  final int? paymentStatus;
  TransactionDetailsArgs(
      {this.urbanledgerId,
      this.transactionId,
      this.to,
      this.toEmail,
      this.from,
      this.fromEmail,
      this.completed,
      this.paymentMethod,
      this.amount,
      this.customerName,
      this.mobileNo,
      this.cardImage,
      this.endingWith,
      this.paymentStatus});
}

class EmiratesPreviewArgs {
  final EmiratesImage;

  EmiratesPreviewArgs({this.EmiratesImage});
}

class TradeLicensePreviewArgs {
  final TradeLicenseImage;
  final TradeLicensePDF;

  TradeLicensePreviewArgs({this.TradeLicenseImage, this.TradeLicensePDF});
}

class UserQRArgs {
  final Uint8List qrCode;

  UserQRArgs({required this.qrCode});
}

class CustomerProfileArgs {
  final String customerId;
  final String name;
  final String mobileNo;

  CustomerProfileArgs(
      {required this.customerId, required this.name, required this.mobileNo});
}

class AddAddressArgs {
  final CustomerModel customerModel;
  final String? name;
  final String? mobile;
  final String? flat;
  final String? landmark;
  final String? pincode;
  final String? city;
  final String? state;
  final int? creditLimit;
  final int? interest;
  final int? emi;
  final bool isSwitched;

  AddAddressArgs(
      {required this.customerModel,
      this.name,
      this.mobile,
      this.flat,
      this.landmark,
      this.pincode,
      this.city,
      this.state,
      this.creditLimit,
      this.emi,
      this.interest,
      required this.isSwitched});
}

class RequestDetailsArgs {
  final bool? status;
  final String customerId;
  final String? firstName;
  final String? lastName;
  final String? mobileNo;
  final String? amount;
  final String? currency;
  final String? note;
  final String? requestId;
  final List<String> bills;
  final Message message;
  final User? user;
  final Function() declinePayment;

  RequestDetailsArgs(
      {this.status,
      this.firstName,
      this.lastName,
      required this.customerId,
      this.amount,
      this.currency,
      required this.bills,
      this.mobileNo,
      this.note,
      this.requestId,
      required this.message,
      required this.user,
      required this.declinePayment});
}

class TransactionListArgs {
  final bool isFromUlChat;
  final CustomerModel model;

  TransactionListArgs(this.isFromUlChat, this.model);
}

class ReceiveTransactionArgs {
  final CustomerModel model;
  final String customerId;

  ReceiveTransactionArgs(this.model, this.customerId);
}

class FreemiumConfirmationArgs {
  final List<PlanModel> planModel;

  FreemiumConfirmationArgs({required this.planModel});
}
