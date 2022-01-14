import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:urbanledger/Models/business_model.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Screens/Auth/login.dart';
import 'package:urbanledger/Screens/Auth/pin_login.dart';
import 'package:urbanledger/Screens/Auth/signup.dart';
import 'package:urbanledger/Screens/Auth/verification.dart';
import 'package:urbanledger/Screens/customer_profile.dart';
import 'package:urbanledger/Screens/main_screen.dart';
import 'package:urbanledger/Screens/request_money.dart';
import 'package:urbanledger/Screens/request_money_options.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/screens/Add Card/saved_cards.dart';
import 'package:urbanledger/screens/Add%20Card/add_card_screen.dart';
import 'package:urbanledger/screens/Add%20Card/card_list.dart';
import 'package:urbanledger/screens/Add%20Card/saved_cards.dart';
import 'package:urbanledger/screens/AddBankAccount/bank_accounts.dart';
import 'package:urbanledger/screens/AddCustomer/add_customer.dart';
import 'package:urbanledger/screens/AddCustomer/add_customer_form.dart';
import 'package:urbanledger/screens/Auth/change_pin_verification.dart';
import 'package:urbanledger/screens/Auth/set_pin.dart';
import 'package:urbanledger/screens/CashbookScreens/add_entry.dart';
import 'package:urbanledger/screens/CashbookScreens/cashbook_expense.dart';
import 'package:urbanledger/screens/CashbookScreens/cashbook_list.dart';
import 'package:urbanledger/screens/CashbookScreens/entry_details_cashbook.dart';
import 'package:urbanledger/screens/CustomerReport/customer_report.dart';
import 'package:urbanledger/screens/Freemium/UnSubscribe/getpaidplans.dart';
import 'package:urbanledger/screens/Freemium/UnSubscribe/premiumtranactionlist.dart';
import 'package:urbanledger/screens/Freemium/UnSubscribe/unsubscribe_plan.dart';
import 'package:urbanledger/screens/Freemium/UnSubscribe/upgrade_subscription.dart';
import 'package:urbanledger/screens/Freemium/confirmation_screen_1.dart';
import 'package:urbanledger/screens/Freemium/premium_member.dart';
import 'package:urbanledger/screens/Kyc%20Screen/manage_kyc1_screen.dart';
import 'package:urbanledger/screens/Kyc%20Screen/preview_screen.dart';
import 'package:urbanledger/screens/Kyc%20Screen/scan_id_screen.dart';
import 'package:urbanledger/screens/Kyc%20Screen/trade_license_preview_screen.dart';
import 'package:urbanledger/screens/Kyc%20Screen/trade_license_screen.dart';
import 'package:urbanledger/screens/SettlementHistory/settlement_details_screen.dart';
import 'package:urbanledger/screens/SettlementHistory/settlement_history_screen.dart';
import 'package:urbanledger/screens/SuspenseAccount/suspense_account_screen.dart';
import 'package:urbanledger/screens/SuspenseAccount/suspense_customer_move.dart';
// import 'package:urbanledger/screens/OCR/ocr_page.dart';
import 'package:urbanledger/screens/TransactionScreens/ReceiveTransaction/qr_screen.dart';
import 'package:urbanledger/screens/TransactionScreens/ReceiveTransaction/receive_transaction_screen.dart';
import 'package:urbanledger/screens/TransactionScreens/ScanQRScreen.dart';
import 'package:urbanledger/screens/TransactionScreens/TransacationReport/report.dart';
import 'package:urbanledger/screens/TransactionScreens/calculator_screen.dart';
import 'package:urbanledger/screens/TransactionScreens/contact_list.dart';
import 'package:urbanledger/screens/TransactionScreens/enter_details.dart';
import 'package:urbanledger/screens/TransactionScreens/pay_recieve.dart';
import 'package:urbanledger/screens/TransactionScreens/pay_transaction.dart';
import 'package:urbanledger/screens/TransactionScreens/payment_transaction_details.dart';
import 'package:urbanledger/screens/TransactionScreens/photo_view.dart';
import 'package:urbanledger/screens/TransactionScreens/request_payment_details.dart';
import 'package:urbanledger/screens/TransactionScreens/transaction_details.dart';
import 'package:urbanledger/screens/TransactionScreens/transaction_list.dart';
import 'package:urbanledger/screens/TransactionScreens/transaction_saved.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/add_ledger.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/backup_information.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/global_report.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/individual_report.dart';
// import 'package:urbanledger/screens/UserProfile/MyLedger/delete_ledger.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/my_business.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/rename_ledger.dart';
import 'package:urbanledger/screens/UserProfile/ReferAFriend/refer_friend.dart';
import 'package:urbanledger/screens/UserProfile/ReferAFriend/rewards.dart';
import 'package:urbanledger/screens/UserProfile/Settings/Pin/pin_check.dart';
import 'package:urbanledger/screens/UserProfile/Settings/Pin/pin_setup.dart';
import 'package:urbanledger/screens/UserProfile/Settings/Pin/set_new_pin.dart';
import 'package:urbanledger/screens/UserProfile/Settings/app_update.dart';
import 'package:urbanledger/screens/UserProfile/add_address.dart';
import 'package:urbanledger/screens/UserProfile/my_profile_screen.dart';
import 'package:urbanledger/screens/UserProfile/profile_qr.dart';
import 'package:urbanledger/screens/UserProfile/user_profile.dart';
import 'package:urbanledger/screens/UserProfile/user_profile_new.dart';
import 'package:urbanledger/screens/WelcomeScreens/intropg.dart';
import 'package:urbanledger/screens/WelcomeScreens/welcome_screen.dart';
import 'package:urbanledger/screens/WelcomeScreens/welcome_user.dart';
import 'package:urbanledger/screens/home.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics.dart';
import 'package:urbanledger/screens/nfc_card.dart';
import 'package:urbanledger/screens/pdf_preview.dart';
import 'package:urbanledger/screens/transaction_failed.dart';

import 'Models/customer_model.dart';
import 'screens/Kyc Screen/manage_kyc3_screen.dart';

class Router {
  static Route<dynamic> generateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case (AppRoutes.loginRoute):
        return MaterialPageRoute(
            builder: (_) => LoginScreen(
                  isRegister: routeSettings.arguments as bool,
                ),
            settings: routeSettings);
      case (AppRoutes.transactionListRoute):
        return MaterialPageRoute(
            builder: (_) => TransactionListScreen(
                  customerModel:
                      (routeSettings.arguments as TransactionListArgs).model,
                  isFromUlChat: (routeSettings.arguments as TransactionListArgs)
                      .isFromUlChat,
                ),
            settings: routeSettings);
      case (AppRoutes.mainRoute):
        return MaterialPageRoute(
            builder: (_) => MainScreen(), settings: routeSettings);
      case (AppRoutes.homeRoute):
        return MaterialPageRoute(
            builder: (_) => HomeScreen(), settings: routeSettings);

      case (AppRoutes.referFriendstRoute):
        return MaterialPageRoute(
            builder: (_) => ReferFriends(), settings: routeSettings);
      case (AppRoutes.rewardsRoute):
        return MaterialPageRoute(
            builder: (_) => Rewards(), settings: routeSettings);

      case (AppRoutes.premiumtranactionlistRoute):
        return MaterialPageRoute(
            builder: (_) => premiumtranactionlist(), settings: routeSettings);

      case (AppRoutes.suspenseAccountRoute):
        return MaterialPageRoute(
            builder: (_) => SuspenseAccountScreen(), settings: routeSettings);

      case (AppRoutes.suspenseCustomerAccountRoute):
        return MaterialPageRoute(
            builder: (_) =>
                SuspenseAccountCustomerScreen(data: routeSettings.arguments!),
            settings: routeSettings);

      case (AppRoutes.settlementHistoryRoute):
        return MaterialPageRoute(
            builder: (_) => SettlementHistoryScreen(), settings: routeSettings);
      case (AppRoutes.settlementDetailsRoute):
        return MaterialPageRoute(
            builder: (_) => SettlementDetails(), settings: routeSettings);
      case (AppRoutes.requestDetailsRoute):
        return MaterialPageRoute(
            builder: (_) => RequestPaymentDetails(
                  customerId: (routeSettings.arguments as RequestDetailsArgs)
                      .customerId,
                  firstName:
                      (routeSettings.arguments as RequestDetailsArgs).firstName,
                  lastName:
                      (routeSettings.arguments as RequestDetailsArgs).lastName,
                  mobileNo:
                      (routeSettings.arguments as RequestDetailsArgs).mobileNo,
                  amount:
                      (routeSettings.arguments as RequestDetailsArgs).amount,
                  currency:
                      (routeSettings.arguments as RequestDetailsArgs).currency,
                  note: (routeSettings.arguments as RequestDetailsArgs).note,
                  bills: (routeSettings.arguments as RequestDetailsArgs).bills,
                  message:
                      (routeSettings.arguments as RequestDetailsArgs).message,
                  user: (routeSettings.arguments as RequestDetailsArgs).user,
                  declinePayment:
                      (routeSettings.arguments as RequestDetailsArgs)
                          .declinePayment,
                ),
            settings: routeSettings);
      case (AppRoutes.addAddressRoute):
        return MaterialPageRoute(
            builder: (_) => AddAddress(
                  customerModel:
                      (routeSettings.arguments as AddAddressArgs).customerModel,
                  name: (routeSettings.arguments as AddAddressArgs).name,
                  mobile: (routeSettings.arguments as AddAddressArgs).mobile,
                  flat: (routeSettings.arguments as AddAddressArgs).flat,
                  landmark:
                      (routeSettings.arguments as AddAddressArgs).landmark,
                  pincode: (routeSettings.arguments as AddAddressArgs).pincode,
                  city: (routeSettings.arguments as AddAddressArgs).city,
                  state: (routeSettings.arguments as AddAddressArgs).state,
                  creditLimit:
                      (routeSettings.arguments as AddAddressArgs).creditLimit,
                  interest:
                      (routeSettings.arguments as AddAddressArgs).interest,
                  emi: (routeSettings.arguments as AddAddressArgs).emi,
                  isSwitched:
                      (routeSettings.arguments as AddAddressArgs).isSwitched,
                ),
            settings: routeSettings);
      case (AppRoutes.profileBankAccountRoute):
        return MaterialPageRoute(
            builder: (_) => ProfileBankAccount(), settings: routeSettings);
      case (AppRoutes.cardListRoute):
        return MaterialPageRoute(
            builder: (_) => CardList(), settings: routeSettings);
      case (AppRoutes.addCardRoute):
        return MaterialPageRoute(
            builder: (_) => AddCardScreen(), settings: routeSettings);
      case (AppRoutes.globalReportRoute):
        return MaterialPageRoute(
            builder: (_) => GlobalReport(), settings: routeSettings);
      case (AppRoutes.individualReportRoute):
        return MaterialPageRoute(
            builder: (_) => IndividualReport(), settings: routeSettings);
      case (AppRoutes.urbanLedgerPremiumRoute):
        return MaterialPageRoute(
            builder: (_) => UrbanLedgerPremium(), settings: routeSettings);
      case (AppRoutes.upgrdUnsubsRoute):
        return MaterialPageRoute(
            builder: (_) => UpgrdUnsubs(), settings: routeSettings);
      case (AppRoutes.unsubscribeplanRoute):
        return MaterialPageRoute(
            builder: (_) => UnSubscribePlan(
                  planModel:
                      (routeSettings.arguments as FreemiumConfirmationArgs)
                          .planModel,
                ),
            settings: routeSettings);
      case (AppRoutes.confirmationscreen1Route):
        return MaterialPageRoute(
            builder: (_) => ConfirmationScreen1(
                  planModel:
                      (routeSettings.arguments as FreemiumConfirmationArgs)
                          .planModel,
                ),
            settings: routeSettings);

      case (AppRoutes.upgradeSubscriptionRoute):
        return MaterialPageRoute(
            builder: (_) => UpgradeSubscription(
                  planModel:
                      (routeSettings.arguments as FreemiumConfirmationArgs)
                          .planModel,
                ),
            settings: routeSettings);

      case (AppRoutes.payTransactionRoute):
        return MaterialPageRoute(
            builder: (_) => PayTransactionScreen(
                  model: (routeSettings.arguments as QRDataArgs).customerModel,
                  customerId:
                      (routeSettings.arguments as QRDataArgs).customerId,
                  fName: (routeSettings.arguments as QRDataArgs).fName,
                  lName: (routeSettings.arguments as QRDataArgs).lName,
                  amount: (routeSettings.arguments as QRDataArgs).amount,
                  mobileNo: (routeSettings.arguments as QRDataArgs).mobileNo,
                  currency: (routeSettings.arguments as QRDataArgs).currency,
                  note: (routeSettings.arguments as QRDataArgs).note,
                  type: (routeSettings.arguments as QRDataArgs).type,
                  through: (routeSettings.arguments as QRDataArgs).through,
                  suspense: (routeSettings.arguments as QRDataArgs).suspense,
                  requestId: (routeSettings.arguments as QRDataArgs).requestId,
                ),
            settings: routeSettings);
      case (AppRoutes.myProfileScreenRoute):
        return MaterialPageRoute(
            builder: (_) => MyProfileScreen(), settings: routeSettings);
      case (AppRoutes.myBusinessRoute):
        return MaterialPageRoute(
            builder: (_) => MyBusinessScreen(), settings: routeSettings);
      case (AppRoutes.scanEmiratesID):
        return MaterialPageRoute(
          builder: (_) => ScanIdScreen(),
        );
      case (AppRoutes.EmiratesIdPreviewScreen):
        return MaterialPageRoute(
            builder: (_) => EmiratesIdPreviewScreen(
                  imgPath: (routeSettings.arguments as EmiratesPreviewArgs)
                      .EmiratesImage,
                ),
            settings: routeSettings);
      case (AppRoutes.scanTradeLicense):
        return MaterialPageRoute(
          builder: (_) => TradeLicenseScreen(),
        );
      case (AppRoutes.TradeLiscensePreviewScreen):
        return MaterialPageRoute(
          builder: (_) => TradeLiscensePreviewScreen(
            imgPath: (routeSettings.arguments as TradeLicensePreviewArgs)
                .TradeLicenseImage,
            path: (routeSettings.arguments as TradeLicensePreviewArgs)
                .TradeLicensePDF,
          ),
        );
      case (AppRoutes.urbanLedgerPremium):
        return MaterialPageRoute(
          builder: (_) => UrbanLedgerPremium(),
        );
      case (AppRoutes.paymentDetailsRoute):
        return MaterialPageRoute(
            builder: (_) => PaymentDetails(
                  urbanledgerId:
                      (routeSettings.arguments as TransactionDetailsArgs)
                          .urbanledgerId,
                  transactionId:
                      (routeSettings.arguments as TransactionDetailsArgs)
                          .transactionId,
                  to: (routeSettings.arguments as TransactionDetailsArgs).to,
                  toEmail: (routeSettings.arguments as TransactionDetailsArgs)
                      .toEmail,
                  from:
                      (routeSettings.arguments as TransactionDetailsArgs).from,
                  fromEmail: (routeSettings.arguments as TransactionDetailsArgs)
                      .fromEmail,
                  completed: (routeSettings.arguments as TransactionDetailsArgs)
                      .completed,
                  paymentMethod:
                      (routeSettings.arguments as TransactionDetailsArgs)
                          .paymentMethod,
                  amount: (routeSettings.arguments as TransactionDetailsArgs)
                      .amount,
                  customerName:
                      (routeSettings.arguments as TransactionDetailsArgs)
                          .customerName,
                  mobileNo: (routeSettings.arguments as TransactionDetailsArgs)
                      .mobileNo,
                  cardImage: (routeSettings.arguments as TransactionDetailsArgs)
                      .cardImage,
                  endingWith:
                      (routeSettings.arguments as TransactionDetailsArgs)
                          .endingWith,
                  paymentStatus:
                      (routeSettings.arguments as TransactionDetailsArgs)
                          .paymentStatus,
                ),
            settings: routeSettings);
      case (AppRoutes.transactionDetailsRoute):
        return MaterialPageRoute(
            builder: (_) => TransactionDetailsScreen(),
            settings: routeSettings);

      case (AppRoutes.requestTransactionRoute):
        return MaterialPageRoute(
            builder: (_) => ReceiveTransactionScreen(
                  model:
                      (routeSettings.arguments as ReceiveTransactionArgs).model,
                  customerId:
                      (routeSettings.arguments as ReceiveTransactionArgs)
                          .customerId,
                ),
            settings: routeSettings);
      case (AppRoutes.requestMoneyRoute):
        return MaterialPageRoute(
            builder: (_) => RequestMoney(), settings: routeSettings);
      case (AppRoutes.profileQRRoute):
        return MaterialPageRoute(
            builder: (_) => ProfileQR(
                  qrCode: (routeSettings.arguments as UserQRArgs).qrCode,
                ),
            settings: routeSettings);
      case (AppRoutes.payReceiveRoute):
        return MaterialPageRoute(
            builder: (_) => PayRequestScreen(), settings: routeSettings);
      case (AppRoutes.reportRoute):
        return MaterialPageRoute(
            builder: (_) => Report(
                  customerModel: routeSettings.arguments as CustomerModel,
                ),
            settings: routeSettings);
      case (AppRoutes.scanQRRoute):
        return MaterialPageRoute(
            builder: (_) => ScanQR(), settings: routeSettings);
      case (AppRoutes.addLedgerRoute):
        return MaterialPageRoute(
            builder: (_) => AddLedger(), settings: routeSettings);
      case (AppRoutes.manageKyc1Route):
        return MaterialPageRoute(
            builder: (_) => ManageKycScreen(), settings: routeSettings);
      case (AppRoutes.manageKyc3Route):
        return MaterialPageRoute(
            builder: (_) => ManageKycScreen3(), settings: routeSettings);
      case (AppRoutes.myBankAccRoute):
        return MaterialPageRoute(
            builder: (_) => ProfileBankAccount(), settings: routeSettings);
      case (AppRoutes.savedCardsRoute):
        return MaterialPageRoute(
            builder: (_) => SavedCards(), settings: routeSettings);
      case (AppRoutes.backUpInformationRoute):
        return MaterialPageRoute(
            builder: (_) => BackupInformationScreen(), settings: routeSettings);
      case (AppRoutes.photoViewRoute):
        return MaterialPageRoute(
            builder: (_) =>
                PhotoViewer2(filePath: routeSettings.arguments as String),
            settings: routeSettings);
      case (AppRoutes.renameLedgerRoute):
        return MaterialPageRoute(
            builder: (_) => RenameLedger(
                  businessModel: routeSettings.arguments as BusinessModel,
                ),
            settings: routeSettings);
      /* case (AppRoutes.deleteLedgerRoute):
        return MaterialPageRoute(
            builder: (_) => DeleteLedger(
                  businessModel: routeSettings.arguments as BusinessModel,
                ),
            settings: routeSettings); */
      case (AppRoutes.pdfPreviewScreen):
        return MaterialPageRoute(
            builder: (_) => PdfPreviewScreen(
                  path: routeSettings.arguments as String,
                ),
            settings: routeSettings);
      case (AppRoutes.customerReportRoute):
        return MaterialPageRoute(
            builder: (_) => CustomerReport(), settings: routeSettings);
      case (AppRoutes.appUpdateRoute):
        return MaterialPageRoute(
            builder: (_) => AppUpdate(), settings: routeSettings);
      case (AppRoutes.savedCardsRoute):
        return MaterialPageRoute(
            builder: (_) => SavedCards(), settings: routeSettings);
      /* case (AppRoutes.attachBillRoute):
        return MaterialPageRoute(
            builder: (_) => AttachBillScreen(
                  customerName:
                      (routeSettings.arguments as AttachBillArgs).customerName,
                  transactionModel: (routeSettings.arguments as AttachBillArgs)
                      .transactionModel,
                ),
            settings: routeSettings); */
      case (AppRoutes.verificationRoute):
        return MaterialPageRoute(
            builder: (_) => VerificationScreen(
                  phoneNo:
                      (routeSettings.arguments as VerificationScreenRouteArgs)
                          .phoneNo,
                  isRegister:
                      (routeSettings.arguments as VerificationScreenRouteArgs)
                          .isRegister,
                ),
            settings: routeSettings);
      case (AppRoutes.signupRoute):
        return MaterialPageRoute(
            builder: (_) => SignUpScreen(
                  mobile: routeSettings.arguments as String,
                ),
            settings: routeSettings);
      case (AppRoutes.changePinVerification):
        return MaterialPageRoute(
            builder: (_) => ChangePinVerification(
                  token: (routeSettings.arguments as ChangePinVArgs).token,
                  fromSettings:
                      (routeSettings.arguments as ChangePinVArgs).isSettings,
                ),
            settings: routeSettings);
      case (AppRoutes.requestMoneyOptionsRoute):
        return MaterialPageRoute(
            builder: (_) => RequestMoneyOptions(), settings: routeSettings);
      case (AppRoutes.customerProfileRoute):
        return MaterialPageRoute(
            builder: (_) => CustomerProfile(
                  customerModel: routeSettings.arguments as CustomerModel,
                ),
            settings: routeSettings);
      case (AppRoutes.userProfileRoute):
        return MaterialPageRoute(
            builder: (_) => UserProfile(), settings: routeSettings);
      case (AppRoutes.edituserProfileRoute):
        return MaterialPageRoute(
            builder: (_) => UserProfileNew(), settings: routeSettings);            
      case (AppRoutes.addCustomerRoute):
        return MaterialPageRoute(
            builder: (_) => AddCustomerScreen(), settings: routeSettings);
      case (AppRoutes.contactListRoute):
        return MaterialPageRoute(
            builder: (_) => ContactListScreen(
                  phoneNo:
                      (routeSettings.arguments as ContactListRouteArgs).phoneNo,
                  customerName:
                      (routeSettings.arguments as ContactListRouteArgs)
                          .customerName,
                  customerId: (routeSettings.arguments as ContactListRouteArgs)
                      .customerId,
                  chatId:
                      (routeSettings.arguments as ContactListRouteArgs).chatId,
                  sendContact: (routeSettings.arguments as ContactListRouteArgs)
                      .sendContact,
                ),
            settings: routeSettings);
      case (AppRoutes.addCustomerFormRoute):
        return MaterialPageRoute(
            builder: (_) => AddCustomerForm(
                  name: routeSettings.arguments as String,
                ),
            settings: routeSettings);
      case (AppRoutes.calculatorRoute):
        return MaterialPageRoute(
            builder: (_) => CalculatorScreen(
                  customerModel:
                      (routeSettings.arguments as CalculatorRouteArgs)
                          .customerModel,
                  toTheCustomer:
                      (routeSettings.arguments as CalculatorRouteArgs)
                          .toTheCustomer,
                  paymentType: (routeSettings.arguments as CalculatorRouteArgs)
                      .paymentType,
                  transactionModel:
                      (routeSettings.arguments as CalculatorRouteArgs)
                          .transactionModel,
                  sendMessage: (routeSettings.arguments as CalculatorRouteArgs)
                      .sendMessage,
                ),
            settings: routeSettings);
      case (AppRoutes.welcomescreenRoute):
        return MaterialPageRoute(
            builder: (_) => WelcomeScreen(), settings: routeSettings);
      
      case (AppRoutes.nfcCardRoute):
        return MaterialPageRoute(
            builder: (_) => NFCCard(), settings: routeSettings);
      case (AppRoutes.pinLoginRoute):
        return MaterialPageRoute(
            builder: (_) => PinLoginScreen(
              isLogin: (routeSettings.arguments as PinRouteArgs)
                          .isLogin,
                          mobileNo: (routeSettings.arguments as PinRouteArgs)
                          .mobileNo,
            ), settings: routeSettings);
      case (AppRoutes.setPinRoute):
        return MaterialPageRoute(
            builder: (_) => SetPinScreen(
                  showConfirmPinState:
                      (routeSettings.arguments as SetPinRouteArgs)
                          .showConfirmPinState,
                  tempPin: (routeSettings.arguments as SetPinRouteArgs).tempPin,
                  isResetPinState: (routeSettings.arguments as SetPinRouteArgs)
                      .isResetPinState,
                  isRegister:
                      (routeSettings.arguments as SetPinRouteArgs).isRegister,
                ),
            settings: routeSettings);
      case (AppRoutes.introscreenRoute):
        return MaterialPageRoute(
            builder: (_) => IntroductionScreen(
              isRegister: (routeSettings.arguments as IntroRouteArgs).isRegister,
            ),
            settings: routeSettings);
      // case (AppRoutes.paymentDoneRoute):
      //   return MaterialPageRoute(
      //       builder: (_) => PaymentDoneScreen(), settings: routeSettings);
      case (AppRoutes.transactionFailedRoute):
        return MaterialPageRoute(
            builder: (_) => TransactionFailedScreen(), settings: routeSettings);
      case (AppRoutes.welcomeuserRoute):
        return MaterialPageRoute(
            builder: (_) => WelcomeUser(), settings: routeSettings);
      case (AppRoutes.cashbookListRoute):
        return MaterialPageRoute(
            builder: (_) => CashbookList(), settings: routeSettings);
      case (AppRoutes.enterDetailsRoute):
        return MaterialPageRoute(
            builder: (_) => EnterDetails(
                  customerModel:
                      (routeSettings.arguments as EnterDetailsRouteArgs)
                          .customerModel,
                  transactionModel:
                      (routeSettings.arguments as EnterDetailsRouteArgs)
                          .transactionModel,
                  sendMessage:
                      (routeSettings.arguments as EnterDetailsRouteArgs)
                          .sendMessage,
                ),
            settings: routeSettings);
      case (AppRoutes.addEntryRoute):
        return MaterialPageRoute(
            builder: (_) => AddEntryScreen(
                  entryType:
                      (routeSettings.arguments as AddEntryScreenRouteArgs)
                          .entryType,
                  cashbookEntryModel:
                      (routeSettings.arguments as AddEntryScreenRouteArgs)
                          .cashbookEntryModel,
                  selectedDate:
                      (routeSettings.arguments as AddEntryScreenRouteArgs)
                          .selectedDate,
                ),
            settings: routeSettings);
      case (AppRoutes.entryDetailsCashbook):
        return MaterialPageRoute(
            builder: (_) => CashbookEntryDetails(
                  cashbookEntryModel:
                      (routeSettings.arguments as CashbookEntryDetailsArgs)
                          .cashbookEntryModel,
                  selectedDate:
                      (routeSettings.arguments as CashbookEntryDetailsArgs)
                          .selectedDate,
                ),
            settings: routeSettings);
      case (AppRoutes.cashbookExpenseRoute):
        return MaterialPageRoute(
            builder: (_) => CashbookExpense(), settings: routeSettings);
      case (AppRoutes.transactionSavedRoute):
        return MaterialPageRoute(
            builder: (_) => TransactionSaved(), settings: routeSettings);
      case (AppRoutes.pinSetupRoute):
        return MaterialPageRoute(
            builder: (_) => PinSetupScreen(), settings: routeSettings);
      case (AppRoutes.checkPinRoute):
        return MaterialPageRoute(
            builder: (_) => PinCheckScreen(
                  fromPinSetupScreen: routeSettings.arguments as bool?,
                ),
            settings: routeSettings);
      case (AppRoutes.setNewPinRoute):
        return MaterialPageRoute(
            builder: (_) => SetNewPinScreen(
                  showConfirmPinState:
                      (routeSettings.arguments as SetPinRouteArgs)
                          .showConfirmPinState,
                  tempPin: (routeSettings.arguments as SetPinRouteArgs).tempPin,
                  isResetPinState: (routeSettings.arguments as SetPinRouteArgs)
                      .isResetPinState,
                ),
            settings: routeSettings);
      case (AppRoutes.qrScreen):
        return MaterialPageRoute(
            builder: (_) => QRScreen(
                  qr: routeSettings.arguments as Uint8List,
                ),
            settings: routeSettings);
      case (AppRoutes.mobileAnalyticsRoute):
        return MaterialPageRoute(
            builder: (_) => MobileAnalytics(), settings: routeSettings);
      default:
        return MaterialPageRoute(
            builder: (_) => LoginScreen(
                  isRegister: false,
                ),
            settings: routeSettings);
    }
  }
}
