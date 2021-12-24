import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Models/business_model.dart';
import 'package:urbanledger/Models/cashbook_entry_model.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/chat_module/data/models/user.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/screens/AddBankAccount/saveBankModel.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_constants.dart';

class AnalyticsEvents{
  BuildContext context;
  FirebaseAnalytics? analytics;
   Map<String,dynamic>? userDetails;


  AnalyticsEvents(this.context) {
    analytics = Provider.of<FirebaseAnalytics>(context,listen:false);

  }

  Future<void> sendAddBankEvent(SaveBankModel saveBankModel) async {
    await analytics!.logEvent(
      name: AnalyticsConstants.ADD_BANK_EVENT,
      parameters: <String, dynamic>{
        AnalyticsConstants.BANK_DETAILS: saveBankModel.toJson(),
        AnalyticsConstants.USER_DETAILS: userDetails
      },
    );
  }
  Future<void> sendAddCustomerEvent(CustomerModel customerModel,AddCustomers eventType) async {
    await analytics!.logEvent(
      name: eventType == AddCustomers.ADD_CUSTOMER_FROM_LIST?AnalyticsConstants.ADD_CUSTOMER_FROM_LIST_EVENT:AnalyticsConstants.ADD_CUSTOMER_EVENT,
      parameters: <String, dynamic>{
        AnalyticsConstants.CUSTOMER_ID: customerModel.customerId,
        AnalyticsConstants.USER_DETAILS: userDetails
      },
    );

  }
  Future<void> sendAddLedgerEvent(BusinessModel businessModel) async {
    await analytics!.logEvent(
      name: AnalyticsConstants.ADD_LEDGER_EVENT,
      parameters: <String, dynamic>{
        AnalyticsConstants.BUSINESS_ID: businessModel.businessId,
        AnalyticsConstants.BUSINESS_NAME: businessModel.businessName,
        AnalyticsConstants.USER_DETAILS: userDetails
      },
    );

  }
  Future<void> sendEditLedgerEvent(BusinessModel businessModel) async {
    await analytics!.logEvent(
      name: AnalyticsConstants.EDIT_LEDGER_EVENT,
      parameters: <String, dynamic>{
        AnalyticsConstants.BUSINESS_ID: businessModel.businessId,
        AnalyticsConstants.BUSINESS_NAME: businessModel.businessName,
        AnalyticsConstants.USER_DETAILS: userDetails
      },
    );

  }

  Future<void> sendDeleteLedgerEvent(String businessId) async {
    await analytics!.logEvent(
      name: AnalyticsConstants.DELETE_LEDGER_EVENT,
      parameters: <String, dynamic>{
        AnalyticsConstants.BUSINESS_ID:businessId,
        AnalyticsConstants.USER_DETAILS: userDetails
      },
    );

  }

  Future<void> sendPremiumPurchaseEvent() async {
    try{
      await analytics!.logEvent(
          name: AnalyticsConstants.PREMIUM_PURCHASE_EVENT,
          parameters: <String, dynamic>{
            'bool': true,
            AnalyticsConstants.USER_DETAILS: userDetails
          }
      );

    }
    catch(e){
      print(e);

    }


  }

  Future<void> sendAddCashbookEvent(CashbookEntryModel cashbookEModel) async {
    try{
      await analytics!.logEvent(
        name: AnalyticsConstants.ADD_CASHBOOK_EVENT,
        parameters: <String, dynamic>{
          AnalyticsConstants.CASHBOOK_ENTRY_DETAILS: cashbookEModel.toJson(),
          AnalyticsConstants.USER_DETAILS: userDetails
        },
      );
    }catch(e){
      print(e);

    }

  }

  Future<void> sendEditCashbookEvent(CashbookEntryModel cashbookEModel) async {
    await analytics!.logEvent(
      name: AnalyticsConstants.EDIT_CASHBOOK_EVENT,
      parameters: <String, dynamic>{
        AnalyticsConstants.CASHBOOK_ENTRY_DETAILS: cashbookEModel.toJson(),
        AnalyticsConstants.USER_DETAILS: userDetails
      },
    );

  }

  Future<void> sendSaveCardEvent() async {
    await analytics!.logEvent(
        name: AnalyticsConstants.SAVE_CARD_EVENT,
        parameters:  <String, dynamic>{
        'bool': true,
        AnalyticsConstants.USER_DETAILS: userDetails
        }
    );

  }

  Future<void> requestPaymentEvent(String linkInput) async {
    await analytics!.logEvent(
        name: AnalyticsConstants.REQUEST_PAYMENT_EVENT,
        parameters:  <String, dynamic>{
          AnalyticsConstants.REQUEST_PAYMENT_DETAILS: linkInput,
          AnalyticsConstants.USER_DETAILS: userDetails
        }
    );

  }
  Future<void> generatedDynamicQrCodeEvent(Map<String, dynamic> data) async {
    await analytics!.logEvent(
        name: AnalyticsConstants.GENERATE_DYNAMIC_QRCODE_EVENT,
        parameters:  <String, dynamic>{
          AnalyticsConstants.REQUEST_PAYMENT_DETAILS: data,
          AnalyticsConstants.USER_DETAILS: userDetails
        }
    );

  }

  Future<void> generatedDynamicPaymentLinkEvent() async {
    await analytics!.logEvent(
        name: AnalyticsConstants.GENERATE_DYNAMIC_PAYMENT_LINK_EVENT,
        parameters:  <String, dynamic>{
          'bool': true,
          AnalyticsConstants.USER_DETAILS: userDetails
        }
    );

  }

  Future<void> sendRecieveButtonEvent() async {
    await analytics!.logEvent(
        name: AnalyticsConstants.SEND_RECIEVE_BUTTON_EVENT,
        parameters: <String, dynamic>{
          AnalyticsConstants.USER_DETAILS: userDetails
        }
    );
  }

  Future<void> customerDetailsPayEvent() async {
    await analytics!.logEvent(
    name: AnalyticsConstants.CUSTOMER_DETAILS_PAY_EVENT,
    parameters: <String, dynamic>{
    AnalyticsConstants.USER_DETAILS: userDetails
    }
    );
  }

  Future<void> customerDetailsPayRequestEvent() async {
    await analytics!.logEvent(
        name: AnalyticsConstants.CUSTOMER_DETAILS_PAY_REQUEST_EVENT,
        parameters: <String, dynamic>{
          AnalyticsConstants.USER_DETAILS: userDetails
        }
    );
  }


  Future<void> chatPayEvent() async {
    await analytics!.logEvent(
    name: AnalyticsConstants.CHAT_PAY_EVENT,
    parameters: <String, dynamic>{
    AnalyticsConstants.USER_DETAILS: userDetails
    }
    );

  }

  Future<void> chatPayRequestEvent() async {
    await analytics!.logEvent(
        name: AnalyticsConstants.CHAT_PAY_REQUEST_EVENT,
        parameters: <String, dynamic>{
          AnalyticsConstants.USER_DETAILS: userDetails
        }
    );

  }

  Future<void> sendPaymentEvent(TransactionModel transactionModel) async {
    await analytics!.logEvent(
        name: AnalyticsConstants.SEND_PAYMENT_EVENT,
        parameters: <String, dynamic>{
          AnalyticsConstants.PAYMENT_TRANSACTION:transactionModel.toJson(),
          AnalyticsConstants.USER_DETAILS: userDetails
        }
    );

  }

  sendEmiratesIdAddedEvent() async {
    await analytics!.logEvent(
        name: AnalyticsConstants.EMIRATES_ID_ADDED_EVENT,
        parameters:  <String, dynamic>{
          'bool': true,
          AnalyticsConstants.USER_DETAILS: userDetails
        }
    );


  }

  sendTradeLicenseAddedEvent() async {
    await analytics!.logEvent(
        name: AnalyticsConstants.TRADE_LICENSE_ADDED_EVENT,
        parameters:  <String, dynamic>{
          'bool': true,
          AnalyticsConstants.USER_DETAILS: userDetails
        }
    );


  }

  changePinEvent() async {
    await analytics!.logEvent(
        name: AnalyticsConstants.CHANGE_PIN_EVENT,
        parameters:  <String, dynamic>{
          'bool': true,
          AnalyticsConstants.USER_DETAILS: userDetails
        }
    );


  }

  fingerprintChangeEvent(bool status) async {
    await analytics!.logEvent(
        name: AnalyticsConstants.CHANGE_FINGERPRINT_EVENT,
        parameters:  <String, dynamic>{
          'bool': status,
          AnalyticsConstants.USER_DETAILS: userDetails
        }
    );


  }

  signUpEvent(bool withReferral) async {
    await analytics!.logEvent(
        name: withReferral?AnalyticsConstants.SIGN_UP_WITH_REFERRAL_EVENT:AnalyticsConstants.SIGN_UP_WITHOUT_REFERRAL_EVENT,
        parameters:  <String, dynamic>{
          'bool': true,
        }
    );
  }

  shareGlobalPaymentLinkEvent() async {
    await analytics!.logEvent(
        name: AnalyticsConstants.SHARE_GLOBAL_PAYMENT_lINK_EVENT,
        parameters:  <String, dynamic>{
          'bool': true,
          AnalyticsConstants.USER_DETAILS: userDetails
        }
    );


  }

  generateGlobalQrcodeEvent() async {
    await analytics!.logEvent(
        name: AnalyticsConstants.GENERATE_GLOBAL_QRCODE_EVENT,
        parameters:  <String, dynamic>{
          'bool': true,
          AnalyticsConstants.USER_DETAILS: userDetails
        }
    );


  }

  updateUserProfileDetailsEvent() async {
    await analytics!.logEvent(
        name: AnalyticsConstants.UPDATE_USER_PROFILE_DETAILS_EVENT,
        parameters:  <String, dynamic>{
          'bool': true,
          AnalyticsConstants.USER_DETAILS: userDetails
        }
    );


  }



  initCurrentUser() async {
    final userString = await CustomSharedPreferences.get("user");
    final userJson = jsonDecode(userString);
    userDetails = userJson;
  }












}

enum AddCustomers{ADD_NEW_CUSTOMER,ADD_CUSTOMER_FROM_LIST}
enum RequestPaymentType{REQUEST_TYPE_QR,REQUEST_TYPE_LINK}