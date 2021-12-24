import 'package:flutter/material.dart';

String appName = "Urban Ledger";

String appVersion = "0.0.1";

bool showMemoryButton = false;

late double deviceHeight;

late String localCustomerId;

const String currencyAED = "AED";

final double appBarHeight = AppBar().preferredSize.height;

// const String baseUrl = "https://vpurban.vernost.in/api/";

const String baseUrl = "https://coms.urbanledger.app/api/";

// const String baseImageUrl = "https://vpurban.vernost.in/api/image/show/";

const String baseImageUrl = "https://coms.urbanledger.app/api/image/show/";

class Constants {
  /*  static String appURL =
      "https://play.google.com/store/apps/details?id={packageName}";

  static String shareReferralLinkMsg = "Download App text";

  static const String paymentGatewayTestKey = "";
  static const String paymentGatewayLiveKey = "";
 */
  ///HiveBoxes

  static const String authBox = 'AuthBox';

  static const String userBox = 'UserBox';

  static const String unAuthBox = 'UnAuthBox';

  static const String tryAgain = "Try Again ! ";

  static const String enterEmail = "Email";

  static const String enterValidEmail = "Enter Valid Email";

  static const String enterValidMessage = "Enter Valid Message";

  static const String enterValidAmount = "Enter Valid Amount";

  static const String enterPassword = "Password";

  static const String enterValidPassword = "Enter Valid Password";

  static const String enterConfirmPassword = "Confirm Password";

  static const String enterValidConfirmPassword =
      "Password and Confirm Password should be identical";

  static const String enterPhone = "Enter Mobile Number";

  static const String mobile = "Mobile Number";

  static const String enterOTP = "Enter OTP";

  static const String otp = 'OTP';

  static const String enterValidOTP = "enterValidOTP";

  static const String enterName = "Name";

  static const String enterValidName = "Enter Valid Name";

  static const String enterValidPhone = "Enter Valid Mobile Number";

  static const String emptyMessage = "Can't be Empty";

  static const String somethingWentWrong = "Something Went Wrong!";
}
