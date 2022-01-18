import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/login_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/local_db.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/chat_module/data/repositories/chat_repository.dart';
import 'package:urbanledger/chat_module/screens/contact/contact_controller.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/ul_logo_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:uuid/uuid.dart';
import '../Components/extensions.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer;
  final Repository repository = Repository();
  CustomerModel _customerModel = CustomerModel();
  ChatRepository _chatRepository = ChatRepository();
  final GlobalKey<State> key = GlobalKey<State>();
  @override
  void initState() {
    super.initState();
    requestPermission();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint(message.data['type']);
      debugPrint(message.data.toString());
      onMessageTap(message);
    });
    onStart();
}

void onStart() async {
  await LocalDb.db.init(); //push to next screen
}

  Future<void> requestPermission() async {
    await Permission.contacts.request();
    // await Location.instance.requestPermission();
  }

  Future<void> onMessageTap(RemoteMessage message) async {
    switch (message.data['type']) {
      // code commented Waiting for client confimation
      // case 'ledger_gave':
      //   _customerModel
      //     ..customerId = message.data['customerId']
      //     ..mobileNo = message.data['mobile_no']
      //     ..name = message.data['name']
      //     ..chatId = message.data['chatId']
      //     ..businessId = message.data['businessId'];
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => PayTransactionScreen(
      //         model: _customerModel,
      //         customerId: message.data['customerId'],
      //         amount: message.data['amount'],
      //       ),
      //     ),
      //   );
      //   break;
      // case 'update_ledger_gave':
      //   _customerModel
      //     ..customerId = message.data['customerId']
      //     ..mobileNo = message.data['mobile_no']
      //     ..name = message.data['name']
      //     ..chatId = message.data['chatId']
      //     ..businessId = message.data['businessId'];
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => PayTransactionScreen(
      //         model: _customerModel,
      //         customerId: message.data['customerId'],
      //         amount: message.data['amount'],
      //       ),
      //     ),
      //   );
      //   break;
      // case 'delete_ledger_gave':
      //   Navigator.of(context).pushNamed(AppRoutes.mainRoute);
      //   break;
      case 'payment':
        debugPrint('payment .... ... ');
        paymentNotification(message.data['transactionId']);
        Navigator.of(context).pushNamed(AppRoutes.paymentDetailsRoute,
            arguments: TransactionDetailsArgs(
              urbanledgerId: message.data['urbanledgerId'],
              transactionId: message.data['transactionId'],
              to: message.data['to_id'],
              toEmail: message.data['toEmail'],
              from: message.data['from_id'],
              fromEmail: message.data['fromEmail'],
              completed: message.data['completed'],
              paymentMethod: message.data['paymentMethod'],
              amount: message.data['amount'],
              cardImage:
                  message.data['cardImage']?.toString().replaceAll(' ', ''),
              endingWith: message.data['endingWith'],
              customerName: message.data['customerName'],
              mobileNo: message.data['fromMobileNumber'],
              paymentStatus: message.data['paymentStatus'],
            ));
        break;
      case 'bank_account': //in progress from back end
        await CustomSharedPreferences.setBool('isBankAccount', true);
        debugPrint('ffffffffffffK');
        Navigator.of(context)
            .pushReplacementNamed(AppRoutes.profileBankAccountRoute);
        CustomLoadingDialog.showLoadingDialog(context);
        break;
      case 'payment_request':
        CustomLoadingDialog.showLoadingDialog(context);
        debugPrint('payment_request : ');
        double amount = double.parse(message.data['amount'].toString());
        var cid = await repository.customerApi
            .getCustomerID(mobileNumber: message.data['mobileNo'].toString())
            .timeout(Duration(seconds: 30), onTimeout: () async {
          Navigator.of(context).pop();
          return Future.value(null);
        });
        _customerModel
          ..ulId = cid.customerInfo?.id != null ? cid.customerInfo?.id : cid.id
          ..mobileNo = message.data['mobileNo']
          ..name = message.data['name']
          ..chatId = message.data['chatId']
          ..businessId = message.data['businessId'];
        final localCustId =
            await repository.queries.getCustomerId(_customerModel.mobileNo!);
        // final localCustId = '76aeff10-f8f8-11eb-bd60-0d0a52481fd7';
        final uniqueId = Uuid().v1();
        if (localCustId.isEmpty) {
          final customer = CustomerModel()
            ..name =
                getName(_customerModel.name!.trim(), _customerModel.mobileNo!)
            ..mobileNo = (_customerModel.mobileNo!)
            ..avatar = _customerModel.avatar
            ..customerId = uniqueId
            ..businessId = Provider.of<BusinessProvider>(context, listen: false)
                .selectedBusiness
                .businessId
            ..chatId = _customerModel.chatId
            ..isChanged = true;
          await repository.queries.insertCustomer(customer);
        }

        // Navigator.of(context).pushNamed(
        //   AppRoutes.payTransactionRoute,
        //   arguments: QRDataArgs(
        //       customerModel: _customerModel,
        //       customerId: localCustId.isEmpty ? uniqueId : localCustId,
        //       amount: amount.toInt().toString(),
        //       requestId: message.data['request_id'],
        //       type: 'DIRECT',
        //       suspense: false,
        //       through: 'DIRECT'),
        // );

        Map<String, dynamic> isTransaction =
            await repository.paymentThroughQRApi.getTransactionLimit(context);
        if (!(isTransaction)['isError']) {
          // Navigator.of(context).pop(true);
          // showBankAccountDialog();
          debugPrint('Customer iiid: ' + message.data['customerId'].toString());
          Navigator.of(context).popAndPushNamed(
            AppRoutes.payTransactionRoute,
            arguments: QRDataArgs(
                customerModel: _customerModel,
                customerId: localCustId.isEmpty ? uniqueId : localCustId,
                amount: amount.toInt().toString(),
                requestId: message.data['request_id'],
                type: 'DIRECT',
                suspense: false,
                through: 'DIRECT'),
          );
        } else {
          Navigator.of(context).pop(true);
          '${(isTransaction)['message']}'.showSnackBar(context);
        }
        break;
      case 'add_customer':
        Navigator.of(context).pushNamed(AppRoutes.mainRoute);
        break;
      case 'add_kyc':
        await CustomSharedPreferences.setBool('isKYC', true);
        Navigator.of(context).pushNamed(AppRoutes.manageKyc1Route);
        break;
      case 'complete_kyc_reminder':
        await CustomSharedPreferences.setBool('isKYC', true);
        Navigator.of(context).pushNamed(AppRoutes.manageKyc1Route);
        break;
      case 'premium':
        await CustomSharedPreferences.setBool('isKYC', true);
        Navigator.of(context).pushNamed(AppRoutes.manageKyc1Route);
        break;
      case 'ledger_addentry':
        Navigator.of(context).pushNamed(AppRoutes.mainRoute);
        break;
      case 'premium_reminder':
        Navigator.of(context).pushNamed(AppRoutes.urbanLedgerPremiumRoute);
        CustomLoadingDialog.showLoadingDialog(context);
        break;
      case 'chat':
        _customerModel
          ..customerId = message.data['customer_id']
          ..mobileNo = message.data['mobileNo']
          ..name = message.data['name']
          ..chatId = message.data['chatId']
          ..businessId = message.data['business_id'];
        debugPrint('dddaattta' + _customerModel.toJson().toString());
        ContactController.initChat(context, _customerModel.chatId);
        localCustomerId = _customerModel.customerId!;
        BlocProvider.of<LedgerCubit>(context)
            .getLedgerData(_customerModel.customerId!);
        Navigator.of(context).pushNamed(AppRoutes.transactionListRoute,
            arguments: TransactionListArgs(true, _customerModel));
        break;
      default:
        Navigator.of(context).pushNamed(AppRoutes.mainRoute);
    }
  }

  paymentNotification(String transactionId) async {
    Map<String?, dynamic>? response =
        await _chatRepository.getTransactionDetails(transactionId);
    debugPrint(response.toString());
    // Navigator.of(context).popAndPushNamed(
    //                 AppRoutes.paymentDetailsRoute,
    //                 arguments: TransactionDetailsArgs(
    //                     urbanledgerId: (response)?['urbanledgerId'],
    //                     transactionId: (response)?['transactionId'],
    //                     to: (response)?['to'],
    //                     toEmail: (response)?['toEmail'],
    //                     from: (response)?['from'],
    //                     fromEmail: (response)?['fromEmail'],
    //                     completed: (response)?['completed'],
    //                     paymentMethod: (response)?['paymentMethod'],
    //                     amount: (response)?['amount'].toString(),
    //                     cardImage: (response)?['cardImage']
    //                         .toString()
    //                         .replaceAll(' ', ''),
    //                     endingWith: (response)?['endingWith'],
    //                     customerName: widget.customerModel.name,
    //                     mobileNo: widget.customerModel.mobileNo,
    //                     paymentStatus: message.paymentStatus));
  }

  initMethod() async {
    // repository.hiveQueries.insertUnAuthData(
    //     repository.hiveQueries.unAuthData.copyWith(loginTime: DateTime.now()));
    debugPrint(repository.hiveQueries.unAuthData.loginTime.toString());
    debugPrint(repository.hiveQueries.unAuthData.seen.toString());
    timer = Timer(Duration(milliseconds: 2000), () async {
      final loginTime = repository.hiveQueries.unAuthData.loginTime;
      final diff = DateTime.now().difference(loginTime!).inDays;
      if (diff == 30 && repository.hiveQueries.unAuthData.seen == true) {
        repository.hiveQueries.insertUnAuthData(repository
            .hiveQueries.unAuthData
            .copyWith(loginTime: DateTime.now(), seen: false));
      }
      if (repository.hiveQueries.isAuthenticated!) {
        // debugPrint('qqqqqqqqqqqqqqqqqqqqqqqqqq: '+repository.hiveQueries.userData.toString());
        LoginModel loginModel = LoginModel(
                                    mobileNo: repository.hiveQueries.userData.mobileNo);
                                bool isLogin = await Repository()
                                    .queries
                                    .isLoginUser(loginModel);
                                bool isSetPin = await Repository()
                                    .queries
                                    .isSetPin(loginModel);
                                    // if(!isLogin && !isSetPin) {
                                    //   debugPrint('AA'+isSetPin.toString());
                                    // } else {
                                    //   debugPrint('QQ'+isSetPin.toString());
                                    // }
        if (!isLogin && isSetPin) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.setPinRoute,
              arguments: SetPinRouteArgs('', false, false, true));
        } else {
          if (repository.hiveQueries.pinStatus ||
              repository.hiveQueries.fingerPrintStatus) {
            if(!isSetPin) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.setPinRoute,
              arguments: SetPinRouteArgs('', false, false, true));
            } else {
            final loginTime = repository.hiveQueries.unAuthData.loginTime;
            final diff = DateTime.now().difference(loginTime!).inDays;
            debugPrint(diff.toString());
            if (diff < 30 && repository.hiveQueries.unAuthData.seen == true) {
              debugPrint('diff.toString() 1');
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.pinLoginRoute,arguments:PinRouteArgs(
                                                Repository().hiveQueries.userData.mobileNo,
                                                true));
            } else {
              debugPrint('diff.toString() 2');
              Navigator.of(context).pushReplacementNamed(
                  AppRoutes.introscreenRoute,
                  arguments: IntroRouteArgs(false));
              repository.hiveQueries.insertUnAuthData(repository
                  .hiveQueries.unAuthData
                  .copyWith(loginTime: DateTime.now(), seen: true));
            }}
          } else {
            if(!isSetPin) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.setPinRoute,
              arguments: SetPinRouteArgs('', false, false, true));
            } else {
            Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);}
          }
        }
      } else {
        if (diff < 30 && repository.hiveQueries.unAuthData.seen == true) {
          Navigator.of(context)
              .pushReplacementNamed(AppRoutes.welcomescreenRoute);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.introscreenRoute,
              arguments: IntroRouteArgs(true));
          repository.hiveQueries.insertUnAuthData(repository
              .hiveQueries.unAuthData
              .copyWith(loginTime: DateTime.now(), seen: true));
        }
      }
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    initMethod();
    // timer = Timer(Duration(milliseconds: 2000), () {
    //   if (repository.hiveQueries.isAuthenticated!) {
    //     if (repository.hiveQueries.userPin.length == 0) {
    //       Navigator.of(context).pushReplacementNamed(AppRoutes.setPinRoute,
    //           arguments: SetPinRouteArgs('', false, false, false));
    //     } else {
    //       if (repository.hiveQueries.pinStatus ||
    //           repository.hiveQueries.fingerPrintStatus)
    //         Navigator.of(context).pushReplacementNamed(AppRoutes.pinLoginRoute);
    //       else {
    //         bool isStatic =
    //             await (CustomSharedPreferences.contains('StaticQRData'));
    //         bool isDynamic =
    //             await (CustomSharedPreferences.contains('DynamicQRData'));
    //         bool isMerchant =
    //             await (CustomSharedPreferences.contains('MerchantQRData'));
    //         Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);
    //       }
    //     }
    //   } else {
    //     Navigator.of(context)
    //         .pushReplacementNamed(AppRoutes.welcomescreenRoute);
    //   }
    //   timer.cancel();
    // });
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: key,
      body: Stack(alignment: Alignment.topCenter, children: [
        AppAssets.backgroundImage.background,
        /* Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 20,
            color: AppTheme.brownishGrey,
          ),
        ), */
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ULLogoWidget(
              height: 80,
            ),
            CustomText(
              'Track. Remind. Pay.',
              size: 22,
              bold: FontWeight.w500,
              color: AppTheme.brownishGrey,
            ),
          ],
        ),
      ]),
    );
  }
}
