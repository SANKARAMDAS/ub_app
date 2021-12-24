import 'dart:async';
import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/chat_module/data/models/message.dart';
import 'package:urbanledger/chat_module/data/repositories/chat_repository.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';

class DynamicLinkService {
  Future handleInitialDynamicLinks() async {
    // Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    // handle link that has been retrieved
    _handleDeepLink(null, data);
  }

  StreamSubscription<PendingDynamicLinkData> handleDynamicLinks(BuildContext context) {
    // Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    return FirebaseDynamicLinks.instance.onLink.listen(
         (PendingDynamicLinkData? dynamicLink) async {
      // handle link that has been retrieved
      _handleDeepLink(context, dynamicLink!);
    })..onError((e){
      debugPrint(e.toString());
    });
  }


  Future<void> _handleDeepLink(
      BuildContext? context, PendingDynamicLinkData? data) async {
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');
      Uri paths = Uri.parse(deepLink.toString());
      if (paths.queryParameters['paymentrequest_link'] != null) {
        if(context != null)
        CustomLoadingDialog.showLoadingDialog(context);
        Map<String, dynamic> data = await repository.paymentThroughQRApi
            .getQRData(paths.queryParameters['paymentrequest_link']!);
        debugPrint('qq :' + data.toString());
        await CustomSharedPreferences.setString(
            'DynamicQRData', jsonEncode(data));
            
        if (context != null) {
          
          Provider.of<BusinessProvider>(context, listen: false)
              .updateSelectedBusiness();
          
          String data2 = await (CustomSharedPreferences.get('DynamicQRData'));
          Map<String, dynamic> dynamicQRData = jsonDecode(data2);
          final id = await getlocalCustId(
                  context,
                  (dynamicQRData)['mobileNo'],
                  (dynamicQRData)['firstName'] +
                      ' ' +
                      (dynamicQRData)['lastName'])
              .timeout(Duration(seconds: 30), onTimeout: () async {
            // Navigator.of(context).pop();
            return Future.value(null);
          });
          // Navigator.pop(context);

          // Map<String, dynamic> isTransaction =
          //     await repository.paymentThroughQRApi.getTransactionLimit();
          // if (!(isTransaction)['isError']) {
          Navigator.of(context).pop();
          Navigator.pushNamed(
            context,
            AppRoutes.payTransactionRoute,
            arguments: QRDataArgs(
                customerModel: CustomerModel()
                  ..ulId = (dynamicQRData)['customer_id']
                  ..name = (dynamicQRData)['firstName'] +
                      ' ' +
                      (dynamicQRData)['lastName']
                  ..mobileNo = (dynamicQRData)['mobileNo'],
                customerId: id,
                amount: (dynamicQRData)['amount'].toString(),
                currency: (dynamicQRData)['currency'],
                note: (dynamicQRData)['note'],
                type: 'QRCODE',
                requestId: paths.queryParameters['paymentrequest_link'],
                suspense: false,
                through: 'DYNAMICQRCODE'),
          );
        }
      }
      if (paths.queryParameters['paymentrequest_mid'] != null) {
        Map<String, dynamic> data = await repository.paymentThroughQRApi
            .getQRGalleryData(paths.queryParameters['paymentrequest_mid']!);
        debugPrint('qq :' + data.toString());
        await CustomSharedPreferences.setString(
            'MerchantQRData', jsonEncode(data));
        if (context != null) {
          
          Provider.of<BusinessProvider>(context, listen: false)
              .updateSelectedBusiness();
          CustomLoadingDialog.showLoadingDialog(context);
          String data2 = await (CustomSharedPreferences.get('DynamicQRData'));
          Map<String, dynamic> dynamicQRData = jsonDecode(data2);
          final id = await getlocalCustId(
                  context,
                  (dynamicQRData)['mobileNo'],
                  (dynamicQRData)['firstName'] +
                      ' ' +
                      (dynamicQRData)['lastName'])
              .timeout(Duration(seconds: 30), onTimeout: () async {
            // Navigator.of(context).pop();
            return Future.value(null);
          });
          // Navigator.pop(context);

          // Map<String, dynamic> isTransaction =
          //     await repository.paymentThroughQRApi.getTransactionLimit();
          // if (!(isTransaction)['isError']) {
          Navigator.of(context).pop();
          Navigator.pushNamed(
            context,
            AppRoutes.payTransactionRoute,
            arguments: QRDataArgs(
                customerModel: CustomerModel()
                  ..ulId = (dynamicQRData)['customer_id']
                  ..name = (dynamicQRData)['firstName'] +
                      ' ' +
                      (dynamicQRData)['lastName']
                  ..mobileNo = (dynamicQRData)['mobileNo'],
                customerId: id,
                amount: (dynamicQRData)['amount'].toString(),
                currency: (dynamicQRData)['currency'],
                note: (dynamicQRData)['note'],
                type: 'QRCODE',
                requestId: paths.queryParameters['paymentrequest_mid'],
                suspense: false,
                through: 'DYNAMICQRCODE'),
          );
        }
      }
      if (paths.queryParameters['id'] != null) {

        Map<String, dynamic> data = await repository.paymentThroughQRApi
            .getStaticQRData(paths.queryParameters['id']!);
        debugPrint('qq :' + data.toString());
        await CustomSharedPreferences.setString(
            'StaticQRData', jsonEncode(data));
        if (context != null) {
          
          Provider.of<BusinessProvider>(context, listen: false)
              .updateSelectedBusiness();
          CustomLoadingDialog.showLoadingDialog(context);
          String data2 = await (CustomSharedPreferences.get('DynamicQRData'));
          Map<String, dynamic> dynamicQRData = jsonDecode(data2);
          final id = await getlocalCustId(
                  context,
                  (dynamicQRData)['mobileNo'],
                  (dynamicQRData)['firstName'] +
                      ' ' +
                      (dynamicQRData)['lastName'])
              .timeout(Duration(seconds: 30), onTimeout: () async {
            // Navigator.of(context).pop();
            return Future.value(null);
          });
          // Navigator.pop(context);

          // Map<String, dynamic> isTransaction =
          //     await repository.paymentThroughQRApi.getTransactionLimit();
          // if (!(isTransaction)['isError']) {
          Navigator.of(context).pop();
          Navigator.pushNamed(
            context,
            AppRoutes.payTransactionRoute,
            arguments: QRDataArgs(
                customerModel: CustomerModel()
                  ..ulId = (dynamicQRData)['customer_id']
                  ..name = (dynamicQRData)['firstName'] +
                      ' ' +
                      (dynamicQRData)['lastName']
                  ..mobileNo = (dynamicQRData)['mobileNo'],
                customerId: id,
                amount: (dynamicQRData)['amount'].toString(),
                currency: (dynamicQRData)['currency'],
                note: (dynamicQRData)['note'],
                type: 'QRCODE',
                suspense: false,
                through: 'DYNAMICQRCODE'),
          );
        }
      }
      var isPost = deepLink.pathSegments.contains('referral_code');
      debugPrint('Referral code1: ' + isPost.toString());
      debugPrint('Referral code: ' +
          deepLink.queryParameters['referral_code'].toString());
      if (deepLink.queryParameters['referral_code'] != null &&
          deepLink.queryParameters['referral_code']!.isNotEmpty) {
        Repository().hiveQueries.insertDynamicRefferalCode(
            deepLink.queryParameters['referral_code']);
      }
    }
  }

  Future<String> getlocalCustId(
      BuildContext context, String mobileNo, String name) async {
    final localCustId = await repository.queries
        .getCustomerId(mobileNo)
        .timeout(Duration(seconds: 30), onTimeout: () async {
      Navigator.of(context).pop();
      return Future.value(null);
    });
    Provider.of<BusinessProvider>(context, listen: false)
        .updateSelectedBusiness();
    var businessId = Provider.of<BusinessProvider>(context, listen: false)
        .selectedBusiness
        .businessId;
    final uniqueId = Uuid().v1();
    // String primaryBusiness =
    //     await (CustomSharedPreferences.get('primaryBusiness'));
    if (localCustId.isEmpty) {
      final customer = CustomerModel()
        ..name = getName(name.trim(), mobileNo)
        ..mobileNo = mobileNo
        ..customerId = uniqueId
        ..businessId = businessId
        ..isChanged = true;
      await repository.queries.insertCustomer(customer);
      if (await checkConnectivity) {
        final apiResponse = await (repository.customerApi
            .saveCustomer(customer, context, AddCustomers.ADD_NEW_CUSTOMER)
            .timeout(Duration(seconds: 30), onTimeout: () async {
          Navigator.of(context).pop();
          return Future.value(null);
        }).catchError((e) {
          recordError(e, StackTrace.current);
          return false;
        }));

        if (apiResponse) {
          ///update chat id here
          final Messages msg = Messages(messages: '', messageType: 100);
          var jsondata = jsonEncode(msg);
          final response = await ChatRepository()
              .sendMessage(customer.mobileNo.toString(), customer.name,
                  jsondata, customer.customerId ?? '', businessId)
              .timeout(Duration(seconds: 30), onTimeout: () async {
            Navigator.of(context).pop();
            return Future.value(null);
          });
          final messageResponse =
              Map<String, dynamic>.from(jsonDecode(response.body));
          Message _message = Message.fromJson(messageResponse['message']);
          if (_message.chatId.toString().isNotEmpty) {
            await repository.queries.updateCustomerIsChanged(
                0, customer.customerId!, _message.chatId);
          }
        }
      } else {
                          'Please check your internet connection or try again later.'
                              .showSnackBar(context);
                        }
      // BlocProvider.of<ContactsCubit>(context)
      //     .getContacts(businessId)
      //     .timeout(Duration(seconds: 30), onTimeout: () async {
      //   Navigator.of(context).pop();
      //   return Future.value(null);
      // });
    }
    return localCustId.isEmpty ? uniqueId : localCustId;
  }

  // Future<String> createFirstPostLink(String title) async {
  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //     uriPrefix: 'https://filledstacks.page.link',
  //     link: Uri.parse('https://www.compound.com/post?title=$title'),
  //     androidParameters: AndroidParameters(
  //       packageName: 'com.filledstacks.compound',
  //     ),
  //
  //
  //
  //
  //     // Other things to add as an example. We don't need it now
  //     iosParameters: IosParameters(
  //       bundleId: 'com.example.ios',
  //       minimumVersion: '1.0.1',
  //       appStoreId: '123456789',
  //     ),
  //     googleAnalyticsParameters: GoogleAnalyticsParameters(
  //       campaign: 'example-promo',
  //       medium: 'social',
  //       source: 'orkut',
  //     ),
  //     itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
  //       providerToken: '123456',
  //       campaignToken: 'example-promo',
  //     ),
  //     socialMetaTagParameters: SocialMetaTagParameters(
  //       title: 'Example of a Dynamic Link',
  //       description: 'This link works whether app is installed or not!',
  //     ),
  //   );
  //
  //   final Uri dynamicUrl = await parameters.buildUrl();
  //
  //   return dynamicUrl.toString();
  // }
}
