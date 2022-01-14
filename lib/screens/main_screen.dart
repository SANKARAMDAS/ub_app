import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
import 'package:urbanledger/Models/analytics_model.dart';
import 'package:urbanledger/Models/business_model.dart';
import 'package:urbanledger/Models/cashbook_entry_model.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/login_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/chat_module/data/models/message.dart';
import 'package:urbanledger/chat_module/data/providers/chats_provider.dart';
import 'package:urbanledger/chat_module/data/repositories/chat_repository.dart';
import 'package:urbanledger/chat_module/screens/contact/contact_controller.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/chat_module/utils/my_urls.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_bottom_nav_bar.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/DynamicLinks/dynamicLinkService.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:urbanledger/screens/UserProfile/user_profile_new.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import 'package:uuid/uuid.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import '../screens/home.dart';
import 'Components/custom_bottom_nav_bar_new.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

Timer? _timer;

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = HomeScreen();
  late Socket socket;
  CustomerModel _customerModel = CustomerModel();
  ChatRepository _chatRepository = ChatRepository();
  final GlobalKey<State> key = GlobalKey<State>();
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = DynamicLinkService().handleDynamicLinks(context);
    // onMessageNotification();
    // _customerModel
    //   ..customerId = message.data['customerId']
    //   ..mobileNo = message.data['mobile_no']
    //   ..name = message.data['name']
    //   ..chatId = message.data['chatId']
    //   ..businessId = message.data['businessId'];
    repository.queries.getPrimaryBusiness();

    Provider.of<BusinessProvider>(context, listen: false)
        .getBusinesses()
        .then((value) {
      if (value > 0) {
        Provider.of<BusinessProvider>(context, listen: false)
            .updateSelectedBusiness();
        BlocProvider.of<ContactsCubit>(context).getContacts(
            Provider.of<BusinessProvider>(context, listen: false)
                .selectedBusiness
                .businessId);
      }
    });

    // BlocProvider.of<ImportContactsCubit>(context).getContactsFromDevice();

    ///continuous Stream to check Connection
    socket = io(
        MyUrls.serverUrl,
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect()
            .disableForceNewConnection() // disable auto-connection
            .build());
    socket.connect();
    socket.onConnect((_) {
      if (mounted) syncData(context);
      socket.disconnect();
    });
    socket.onDisconnect((_) {
      debugPrint('Not Connected To Internet');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint(message.data['type']);
      debugPrint(message.data.toString());
      onMessageTap(message);
    });
    getKyc();
  }

  getKyc() async {
    await KycAPI.kycApiProvider.kycCheker();
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

  @override
  void dispose() {
    if (socket.connected) socket.disconnect();
    _timer?.cancel();
    debugPrint('disposecall ::::::::::::::::::::::::::::::::::::::::::');
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedScreen,
      // bottomSheet: CustomBottomNavBarNew(),
    );
  }

  /* void onMessageNotification() {
    FirebaseMessaging.onMessage.listen((message) async {
      /* await showNotification(
          Random().nextInt(100),
          message.notification?.title ?? '',
          message.notification?.body ?? '',
          message.data); */
      debugPrint(message.data.toString());
      if (message.data['type'] == 'payment') {
        if (message.data['fromMobileNumber'] != null) {
          final localCustId = await repository.queries
              .getCustomerId(message.data['fromMobileNumber']);
          final previousBalance =
              (await repository.queries.getPaidMinusReceived(localCustId));
          await BlocProvider.of<LedgerCubit>(context).addLedger(
              TransactionModel()
                ..transactionId = message.data['transactionId']
                ..amount = message.data['amount']
                ..transactionType = TransactionType.Receive
                ..customerId = localCustId
                ..date = DateTime.now()
                ..attachments = []
                ..balanceAmount =
                    previousBalance + (message.data['amount'] ?? 0)
                ..isChanged = true
                ..isDeleted = false
                ..isPayment = true
                ..business =
                    Provider.of<BusinessProvider>(context, listen: false)
                        .selectedBusiness
                        .businessId
                ..createddate = DateTime.now(),
              () {},
              context);
        }
      }
    });
  } */

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
              to: message.data['to'],
              toEmail: message.data['toEmail'],
              from: message.data['from'],
              fromEmail: message.data['fromEmail'],
              completed: message.data['completed'],
              paymentMethod: message.data['paymentMethod'],
              amount: message.data['amount'],
              cardImage:
                  message.data['cardImage'].toString().replaceAll(' ', ''),
              endingWith: message.data['endingWith'],
              customerName: message.data['customerName'],
              mobileNo: message.data['fromMobileNumber'],
              paymentStatus: message.data['paymentStatus'],
            ));
        break;
      case 'bank_account': //in progress from back end
        await CustomSharedPreferences.setBool('isBankAccount', true);
        debugPrint('fffffffffffL');
        Navigator.of(context).pushNamed(AppRoutes.profileBankAccountRoute);
        CustomLoadingDialog.showLoadingDialog(context, key);
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
        CustomLoadingDialog.showLoadingDialog(context, key);
        break;
      case 'complete_email_verification_reminder':
        Navigator.of(context).pushNamed(AppRoutes.edituserProfileRoute);
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
        
      case 'move_unknown_transactions':
        Navigator.of(context).pushNamed(AppRoutes.suspenseAccountRoute);
        break;

      default:
        Navigator.of(context).pushNamed(AppRoutes.mainRoute);
    }
  }
}

Future<void> uploadBusinessData(BuildContext context) async {
  debugPrint('Uploading Business Data');
  final List<BusinessModel> businessList =
      await repository.queries.getBusinessToSync();
  if (businessList.length != 0) {
    businessList.forEach((e) async {
      final apiResponse = await (repository.businessApi
          .saveBusiness(e, context, false)
          .catchError((e) {
        debugPrint(e);
        recordError(e, StackTrace.current);
        return false;
      }));
      if (apiResponse) {
        await repository.queries.updateBusinessIsChanged(e, 0);
      }
    });
    debugPrint('Uploading Business Data Complete');
  } else {
    debugPrint('No Business Data to upload');
  }
}

Future<void> syncData(BuildContext context) async {
  debugPrint('Connected to internet');
  downloadData(context);
  await uploadData(context);
  _timer = Timer.periodic(Duration(minutes: 1), (_) async {
    await uploadData(context);
  });
}

Future<void> uploadData(BuildContext context) async {
  debugPrint('uploading data');
  await uploadBusinessData(context);
  await uploadCustomerData(context);
  await uploadTransactionData();
  await uploadCashbookData();
  await updateDeletedBusinessData(context);
  await updateDeletedTransactionData();
  await updateDeletedCashbookData();

  repository.hiveQueries.insertLastBackupTimeStamp(DateTime.now());
}

Future<void> uploadCustomerData(context) async {
  debugPrint('Uploading Customer Data');
  ChatRepository _chatRepository = ChatRepository();
  final List<CustomerModel> customerList =
      await repository.queries.getCustomerstoSync();
  if (customerList.length != 0) {
    customerList.forEach((e) async {
      final apiResponse = await (repository.customerApi
          .saveCustomer(e, context, AddCustomers.ADD_NEW_CUSTOMER)
          .catchError((e) {
        debugPrint(e.toString());
        recordError(e, StackTrace.current);
        return false;
      }));
      // if (apiResponse.isNotEmpty) {
      //   await repository.queries
      //       .updateCustomerIsChanged(0, e.customerId, apiResponse);
      // }
      if (apiResponse) {
        ///update chat id here

        final Messages msg = Messages(messages: '', messageType: 100);
        var jsondata = jsonEncode(msg);
        final response = await _chatRepository.sendMessage(
            e.mobileNo.toString(),
            e.name,
            jsondata,
            e.customerId ?? '',
            Provider.of<BusinessProvider>(context, listen: false)
                .selectedBusiness
                .businessId);
        final messageResponse =
            Map<String, dynamic>.from(jsonDecode(response.body));
        Message _message = Message.fromJson(messageResponse['message']);
        if (_message.chatId.toString().isNotEmpty) {
          await repository.queries
              .updateCustomerIsChanged(0, e.customerId!, _message.chatId);
        }
      }
    });
    debugPrint('Uploading Customer Data Complete');
  } else {
    debugPrint('No Customer Data to upload');
  }
}

Future<void> uploadTransactionData() async {
  debugPrint('Uploading Transaction Data');
  final List<TransactionModel> transactionList =
      await repository.queries.getLedgerTransactionsToSync();
  if (transactionList.length != 0) {
    transactionList.forEach((e) async {
      final apiResponse =
          await (repository.ledgerApi.saveTransaction(e).catchError((e) {
        debugPrint(e);
        recordError(e, StackTrace.current);
        return false;
      }));
      if (apiResponse) {
        await repository.queries.updateLedgerIsChanged(e, 0);
      }
    });
    debugPrint('Uploading Transaction Data Complete');
  } else {
    debugPrint('No Transaction Data to upload');
  }
}

Future<void> uploadCashbookData() async {
  debugPrint('Uploading Cashbook Data');
  final List<CashbookEntryModel> cashbookList =
      await repository.queries.getCashbookEntrysToSync();
  if (cashbookList.length != 0) {
    cashbookList.forEach((e) async {
      final apiResponse =
          await (repository.cashbookApi.saveCashbookEntry(e).catchError((e) {
        debugPrint(e);
        recordError(e, StackTrace.current);
        return false;
      }));
      if (apiResponse) {
        await repository.queries.updateCashbookEntryIsChanged(e, 0);
      }
    });
    debugPrint('Uploading Cashbook Data Complete');
  } else {
    debugPrint('No Cashbook Data to upload');
  }
}

Future<void> updateDeletedBusinessData(BuildContext context) async {
  debugPrint('updating deleted Business Data');
  final List<BusinessModel> businessList =
      await repository.queries.getDeletedBusinessToSync();
  if (businessList.length != 0) {
    businessList.forEach((e) async {
      final apiResponse = await (repository.businessApi
          .deleteBusiness(e.businessId, context)
          .catchError((e) {
        debugPrint(e);
        recordError(e, StackTrace.current);
        return false;
      }));
      if (apiResponse) {
        await repository.queries.deleteBusiness(e);
      }
    });
    debugPrint('updating Deleted Business Data Complete');
  } else {
    debugPrint('No Business Data to upload');
  }
}

Future<void> updateDeletedTransactionData() async {
  debugPrint('updating deleted Transaction Data');
  final List<TransactionModel> transactionList =
      await repository.queries.getDeletedLedgerTransactionsToSync();
  if (transactionList.length != 0) {
    transactionList.forEach((e) async {
      final previousBalance =
          (await repository.queries.getPaidMinusReceived(e.customerId!));
      final apiResponse = await (repository.ledgerApi
          .deleteLedger(
              e.transactionId!, removeDecimalif0(previousBalance - e.amount!))
          .catchError((e) {
        debugPrint(e);
        recordError(e, StackTrace.current);
        return false;
      }));
      if (apiResponse) {
        await repository.queries.deleteLedgerTransaction(e);
      }
    });
    debugPrint('updating Deleted Transaction Data Complete');
  } else {
    debugPrint('No Transaction Data to upload');
  }
}

Future<void> updateDeletedCashbookData() async {
  debugPrint('updating deleted Cashbook Data');
  final List<CashbookEntryModel> cashbookList =
      await repository.queries.getDeletedCashbookEntrysToSync();
  if (cashbookList.length != 0) {
    cashbookList.forEach((e) async {
      final apiResponse = await (repository.cashbookApi
          .deleteCashbookEntry(e.entryId)
          .catchError((e) {
        debugPrint(e);
        recordError(e, StackTrace.current);
        return false;
      }));
      if (apiResponse) {
        await repository.queries.deleteCashbookEntry(e);
      }
    });
    debugPrint('updating Deleted Cashbook Data Complete');
  } else {
    debugPrint('No Cashbook Data to upload');
  }
}

Future<void> updateAnalyticsData() async {
  AnalyticsModel? _response = await repository.analyticsAPI.getAnalyticsData();
  if (_response!.data.length > 0) {
    _response.data.forEach((element) {
      Datum data = Datum(
          suspense: element.suspense,
          // id: element.id,
          from: element.from,
          fromMobileNumber: element.fromMobileNumber,
          amount: element.amount,
          currency: element.currency,
          urbanledgerId: element.urbanledgerId,
          transactionId: element.transactionId,
          through: element.through,
          type: element.type,
          createdAt: element.createdAt,
          status: element.status.toString(),
          updatedAt: element.updatedAt);
      repository.queries.insertAnalytics(data);
    });
  }
}

Future<void> _insertData(BusinessModel element, BuildContext context) async {
  ChatRepository _chatRepository = ChatRepository();
  Provider.of<BusinessProvider>(context, listen: false)
      .addBusiness(element)
      .then((value) => Provider.of<BusinessProvider>(context, listen: false)
          .updateSelectedBusiness());
  /* updateSelectedBusinessName.value = BusinessModel(
      businessId: element.businessId,
      businessName: element.businessName,
      isChanged: false,
      isDeleted: false); */
  final _customerList =
      await repository.customerApi.getAllCustomers(element.businessId);

  await Future.forEach<CustomerModel>(_customerList,
      (element) async => await repository.queries.insertCustomer(element));
 await BlocProvider.of<ContactsCubit>(context).getContacts(
      Provider.of<BusinessProvider>(context, listen: false)
          .selectedBusiness
          .businessId);
  _customerList.forEach((e) async {
    final _ledgerTransactionList =
        await repository.ledgerApi.getLedger(e.customerId);
    _ledgerTransactionList.forEach(
      (e) async =>
          await repository.queries.insertLedgerTransaction(e).catchError((e) {
        debugPrint(e);
        recordError(e, StackTrace.current);
      }),
    );
  });
  //todo chat
  // _customerList.forEach((e) async {
  //   Provider.of<ChatsProvider>(context, listen: false).syncChats(e.chatId);
  // });
  chatSync(_customerList, context);

  final _cashbookList =
      await repository.cashbookApi.getCashbookEntries(element.businessId);
  _cashbookList.forEach((e) async {
    await repository.queries.insertCashbookEntry(e);
  });
  updateAnalyticsData();
}

Future<void> chatSync(
    List<CustomerModel> _customerList, BuildContext context) async {
  bool isChatSync = (await CustomSharedPreferences.get("chatSync")) ?? false;
  if (!isChatSync) {
    Future.forEach<CustomerModel>(
        _customerList,
        (element) => Provider.of<ChatsProvider>(context, listen: false)
            .syncChats(element.chatId)).then((value) async {
      await CustomSharedPreferences.setBool('chatSync', true);
    });
  }
}

Future<void> downloadData(BuildContext context) async {
  final business = await repository.businessApi.getBusiness();
//  business.forEach((element) async {
//     //  BlocProvider.of<ContactsCubit>(context)
//     //     .getContacts(e ?? '');

//   });
  Future.forEach<BusinessModel>(
      business, (element) => _insertData(element, context));
}
