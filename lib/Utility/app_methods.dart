import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:connectivity/connectivity.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/custom_popup.dart';

// import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

// Future<String> getFirebaseToken() async {
//   FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
//   return _firebaseMessaging.getToken();
// }

ValueNotifier<bool> isCustomerAddedNotifier = ValueNotifier(false);
late ValueNotifier<String> calculationStringNotifier;
late ValueNotifier<double> calculatedAmountNotifier;
late ValueNotifier<double> memoryAmountNotifier;

late GlobalKey<ScaffoldState> _globalScaffoldKey;

GlobalKey<ScaffoldState> get globalScaffoldKey => _globalScaffoldKey;

void updateKey() {
  _globalScaffoldKey = GlobalKey<ScaffoldState>();
}

void initializeCalculationNotifiers() {
  calculationStringNotifier = ValueNotifier('');
  calculatedAmountNotifier = ValueNotifier(0);
  memoryAmountNotifier = ValueNotifier(0);
}

void disposeCalculationNotifiers() {
  calculationStringNotifier.dispose();
  calculatedAmountNotifier.dispose();
  memoryAmountNotifier.dispose();
}

void equalPressed() {
  String finaluserinput = calculationStringNotifier.value;
  finaluserinput = finaluserinput.replaceAll('x', '*');
  finaluserinput = finaluserinput.replaceAll('÷', '/');
  finaluserinput = finaluserinput.replaceAll('%', '/ 100' + '*');
  finaluserinput = finaluserinput.replaceAll('x', '*');

  Parser p = Parser();
  if (finaluserinput.isEmpty) {
    calculatedAmountNotifier.value = 0;
  } else if (!finaluserinput.endsWith(' ')) {
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    if (finaluserinput.length > 16) {
      return;
    }
    calculatedAmountNotifier.value = eval.isNaN || eval.isInfinite ? 0 : eval;
  }
}

bool documentLifecycle(String document) {
  if (document == 'Pending') {
    return false;
  } else if (document == 'Rejected') {
    return false;
  } else {
    return true;
  }
}

Widget titleName({required Color color}) {
  return RichText(text: TextSpan(
    children: [
      TextSpan(
        text: 'urban ',
        style: TextStyle(
          fontSize: 30,
          color: color,
          // fontWeight: FontWeight.w500
        ),
      ),
      TextSpan(
        text: 'ledger',
        style: TextStyle(
          fontSize: 30,
          color: color,
          fontWeight: FontWeight.bold
        ),
      ),
    ]
  ),);
}

Widget gradientBackground({required Widget child}) {
  return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  AppTheme.purpleStartColor,
                  AppTheme.purpleEndColor,
                ],
                ),
          ),
          child: child
        );
}

Future<bool> allChecker(BuildContext context) async {
  calculatePremiumDate();
  if (Repository().hiveQueries.userData.bankStatus == false) {
    MerchantBankNotAdded.showBankNotAddedDialog(context, 'userBankNotAdded');
    return false;
  } else if (Repository().hiveQueries.userData.kycStatus2 == 'Rejected' ||
      Repository().hiveQueries.userData.kycStatus2 == 'Expired') {
    MerchantBankNotAdded.showBankNotAddedDialog(context, 'userKYCExpired');
    return false;
  } else if (Repository().hiveQueries.userData.kycStatus == 0 &&
      Repository().hiveQueries.userData.isEmiratesIdDone == false) {
    MerchantBankNotAdded.showBankNotAddedDialog(context, 'EmiratesIdPending');
    return false;
  } else if (Repository().hiveQueries.userData.kycStatus == 0 &&
      Repository().hiveQueries.userData.isTradeLicenseDone == false) {
    MerchantBankNotAdded.showBankNotAddedDialog(context, 'TradeLicensePending');
    return false;
  } else if (Repository().hiveQueries.userData.kycStatus == 0) {
    MerchantBankNotAdded.showBankNotAddedDialog(context, 'userKYCPending');
    return false;
  } else if (Repository().hiveQueries.userData.kycStatus == 2) {
    CustomLoadingDialog.showLoadingDialog(context);
    await KycAPI.kycApiProvider.kycCheker().then((value) {
      Navigator.of(context).pop();
      MerchantBankNotAdded.showBankNotAddedDialog(
          context, 'userKYCVerificationPending');
    });
    return false;
  } else if (Repository().hiveQueries.userData.kycStatus == 1 &&
      Repository().hiveQueries.userData.premiumStatus == 0) {
    MerchantBankNotAdded.showBankNotAddedDialog(context, 'upgradePremium');
    return false;
  } else {
    return true;
  }
}

Future<bool> kycAndPremium(BuildContext context) async {
  calculatePremiumDate();
  if (Repository().hiveQueries.userData.kycStatus2 == 'Rejected' ||
      Repository().hiveQueries.userData.kycStatus2 == 'Expired') {
    MerchantBankNotAdded.showBankNotAddedDialog(context, 'userKYCExpired');
    return false;
  } else if (Repository().hiveQueries.userData.kycStatus == 0 &&
      Repository().hiveQueries.userData.isEmiratesIdDone == false) {
    MerchantBankNotAdded.showBankNotAddedDialog(context, 'EmiratesIdPending');
    return false;
  } else if (Repository().hiveQueries.userData.kycStatus == 0 &&
      Repository().hiveQueries.userData.isTradeLicenseDone == false) {
    MerchantBankNotAdded.showBankNotAddedDialog(context, 'TradeLicensePending');
    return false;
  } else if (Repository().hiveQueries.userData.kycStatus == 0) {
    MerchantBankNotAdded.showBankNotAddedDialog(context, 'userKYCPending');
    return false;
  } else if (Repository().hiveQueries.userData.kycStatus == 2) {
    CustomLoadingDialog.showLoadingDialog(context);
    await KycAPI.kycApiProvider.kycCheker().then((value) {
      Navigator.of(context).pop();
      MerchantBankNotAdded.showBankNotAddedDialog(
          context, 'userKYCVerificationPending');
    });
    return false;
  } else if (Repository().hiveQueries.userData.kycStatus == 1 &&
      Repository().hiveQueries.userData.premiumStatus == 0) {
    MerchantBankNotAdded.showBankNotAddedDialog(context, 'upgradePremium');
    return false;
  } else {
    return true;
  }
}

Future<bool> kycChecker(BuildContext context) async {
  if (Repository().hiveQueries.userData.kycStatus2 == 'Rejected' ||
      Repository().hiveQueries.userData.kycStatus2 == 'Expired') {
    MerchantBankNotAdded.showBankNotAddedDialog(context, 'userKYCExpired');
    return false;
  } else if (Repository().hiveQueries.userData.kycStatus == 0 &&
      Repository().hiveQueries.userData.isEmiratesIdDone == false) {
    MerchantBankNotAdded.showBankNotAddedDialog(context, 'EmiratesIdPending');
    return false;
  } else if (Repository().hiveQueries.userData.kycStatus == 0 &&
      Repository().hiveQueries.userData.isTradeLicenseDone == false) {
    MerchantBankNotAdded.showBankNotAddedDialog(context, 'TradeLicensePending');
    return false;
  } else if (Repository().hiveQueries.userData.kycStatus == 0) {
    MerchantBankNotAdded.showBankNotAddedDialog(context, 'userKYCPending');
    return false;
  } else if (Repository().hiveQueries.userData.kycStatus == 2) {
    CustomLoadingDialog.showLoadingDialog(context);
    await KycAPI.kycApiProvider.kycCheker().then((value) {
      Navigator.of(context).pop();
      MerchantBankNotAdded.showBankNotAddedDialog(
          context, 'userKYCVerificationPending');
    });
    return false;
  } else {
    return true;
  }
}

bool bankChecker(BuildContext context) {
  if (Repository().hiveQueries.userData.bankStatus == false) {
    MerchantBankNotAdded.showBankNotAddedDialog(context, 'userBankNotAdded');
    return false;
  } else {
    return true;
  }
}

String removeDecimalif0(double? number) {
  return number == null
      ? ''
      : number.toString().split('.').last == '0'
          ? number.toString().split('.').first
          : number.toStringAsFixed(2);
}

String fixTo2(double? number) {
  return number == null ? '' : number.toStringAsFixed(2);
}

bool isPlatformiOS() {
  if (Platform.isIOS)
    return true;
  else
    return false;
}

double removeNegativeIfNegative(double? amount) {
  return amount == null
      ? 0
      : amount.isNegative
          ? removeNegativeSign(amount)
          : amount != 0
              ? makeNegative(amount)
              : amount;
}

double makeNegative(double? amount) {
  return double.tryParse('-' + amount.toString()) ?? 0;
}

double removeNegativeSign(double? amount) {
  return double.tryParse(amount.toString().replaceAll('-', '')) ?? 0;
}

counter() {
  return (BuildContext context,
          {int? currentLength, bool? isFocused, int? maxLength}) =>
      Container();
}

Future<bool> get checkConnectivity async {
  try {
    final result = await InternetAddress.lookup('google.com')
        .timeout(Duration(seconds: 5));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  } on TimeoutException catch (_) {
    return false;
  }
  return false;
  // return (await (Connectivity().checkConnectivity())) == ConnectivityResult.none
  //     ? false
  //     : true;
}

double screenWidth(context) {
  return MediaQuery.of(context).size.width;
}

double screenHeight(context) {
  return MediaQuery.of(context).size.height;
}

double getWHRatio(context) {
  return MediaQuery.of(context).size.aspectRatio;
}

Map<String, String> apiAuthHeader() {
  print('token' + Repository().hiveQueries.token);
  return {
    "Content-Type": "application/json",
    "Authorization": Repository().hiveQueries.token
  };
}

Map<String, String> apiAuthHeaderWithOnlyToken() {
  var token = Repository().hiveQueries.token;
  print(token);
  return {
    // "Content-Type": "application/json",
    "Authorization": token
  };
}

Map<String, String> apiHeader() {
  return {"Content-Type": "application/json"};
}

String getName(String? name, String? phoneNo) {
  if (name == null) {
    return phoneNo ?? '';
  }

  return name.length == 0 ? phoneNo ?? '' : name;
}

String getInitials(String? name, String? phoneNo) {
  if (name == null || name.length == 0) {
    return phoneNo!.split(' ').length > 1
        ? phoneNo.split(' ').first.substring(0, 1) +
            phoneNo.split(' ').last.substring(0, 1)
        : phoneNo.split(' ').first.substring(0, 1);
  }

  return name.split(' ').first.substring(0, 1) +
      ((name.split(' ').length > 1)
          ? name.split(' ').last.substring(0, 1)
          : '');
}

Future<void> recordError(e, s) async =>
    await FirebaseCrashlytics.instance.recordError(e, s);

const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('1', 'Pdf Notifications',
        channelDescription: 'Notifications shown on download of a pdf',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);

const IOSNotificationDetails iosCS = IOSNotificationDetails(
  presentAlert: true,
  presentBadge: true,
  presentSound: true,
);

const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosCS);

Future<void> showNotification(
    int id, String title, String body, Map<String, dynamic> payload) async {
  final data = jsonEncode(payload);
  await flutterLocalNotificationsPlugin
      .show(id, title, body, platformChannelSpecifics, payload: data);
}

calculatePremiumDate() async {
  if (Repository().hiveQueries.userData.premiumStatus != 0 &&
      Repository().hiveQueries.userData.premiumExpDate != null) {
    DateTime dob = Repository().hiveQueries.userData.premiumExpDate!;
    // await Provider.of<FreemiumProvider>(context,listen: false).getPremiumPlans();
    //  Provider.of<FreemiumProvider>(context,listen: false).endDate;
    Duration dur = dob.difference(DateTime.now());
    String differenceInYears = (dur.inDays / 365).floor().toString();
    debugPrint(differenceInYears + ' years');

    if (int.tryParse(differenceInYears.toString())!.isNegative) {
      debugPrint('Negative' + differenceInYears);
      Repository().hiveQueries.insertUserData(
          Repository().hiveQueries.userData.copyWith(premiumStatus: 0));
    } else {
      debugPrint('Still Premium');
    }
  }
}

/* launchURL(String url) async {
  if (await canLaunch('file://' + url)) {
    await launch('file://' + url);
  } else {
    throw 'Could not launch $url';
  }
} */

/* shareDefault(String msg) {
  Clipboard.setData(new ClipboardData(text: msg));
  showToastMsg("Text copied, Paste before posting!");
  Share.text("Share via", msg, "text/plain");
}
 */
List<T?> map<T>(List list, Function handler) {
  List<T?> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}
