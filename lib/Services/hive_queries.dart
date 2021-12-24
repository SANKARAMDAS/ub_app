import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:urbanledger/Models/business_model.dart';
import 'package:urbanledger/Models/unauth_model.dart';
import 'package:urbanledger/Models/user_model.dart';
// import 'package:urbanledger/Models/user_details_model.dart';
import 'package:urbanledger/Utility/app_constants.dart';

class HiveQueries {
  HiveQueries._();

  static final hiveQueries = HiveQueries._();

  Future<Box> get openAuthBox async {
    return await Hive.openBox(Constants.authBox);
  }

  Future<Box> get openUserBox async {
    return await Hive.openBox(Constants.userBox);
  }

  Future<Box> get openUnAuthBox async {
    return await Hive.openBox(Constants.unAuthBox);
  }

  Box get authBox {
    return Hive.box(Constants.authBox);
  }

  Box get userBox {
    return Hive.box(Constants.userBox);
  }

  Box get unAuthBox {
    return Hive.box(Constants.unAuthBox);
  }

  void insertIsAuthenticated(bool status) {
    try {
      authBox.put('isAuthenticated', status);
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  void insertUserPin(String pin) {
    try {
      authBox.put('pin', pin);
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  void setPinStatus(bool status) {
    try {
      authBox.put('pinStatus', status);
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  void setFingerPrintStatus(bool status) {
    try {
      authBox.put('fingerprintStatus', status);
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  void insertIncorrectPinTime(List timeList) {
    try {
      authBox.put('incorrectPinTimes', timeList);
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
    }
  }

  void insertAuthToken(String? token) {
    try {
      authBox.put('token', token);
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  void insertUserData(SignUpModel signUpModel) {
    try {
      userBox.put('UserData', signUpModel);
      var v =userBox.get('UserData');
      print('s');
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  void insertUnAuthData(UnAuthModel unAuthModel) {
    try {
      userBox.put('UnAuthData', unAuthModel);
      var v =userBox.get('UnAuthData');
      print('s');
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  void insertLastBackupTimeStamp(DateTime time) {
    try {
      userBox.put('timestamp', time);
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  void insertUserIsoCode(String isoCode) {
    try {
      userBox.put('isoCode', isoCode);
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  void insertSignUpUserReferralCode(String referralCode) {
    try {
      debugPrint('Saving while refer' + referralCode.toString());
      userBox.put('SignUpUserReferralCode', referralCode.toString());
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  void insertSignUpUserReferralLink(String referralLink) {
    try {
      debugPrint('Saving while refer' + referralLink.toString());

      userBox.put('SignUpUserReferralLink', referralLink.toString());
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  void insertSignUpPaymentLink(String paymentLink) {
    try {
      debugPrint('Saving while refer' + paymentLink.toString());

      userBox.put('SignUpPaymentLink', paymentLink.toString());
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  void insertSelectedBusiness(BusinessModel selectedBusiness) {
    try {
      userBox.put('selectedBusiness', selectedBusiness);
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  // void insertUserDetails(UserDetailsModel userDetailsModel) {
  //   try {
  //     userBox.put('UserDetails', userDetailsModel);
  //   } on Exception catch (e, s) {
  //     debugPrint(e.toString() + '\n' + s.toString());
  //     return null;
  //   }
  // }

  void insertIsCashbookSheetShown(bool value) {
    try {
      userBox.put('cashbookSheet', value);
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
    }
  }

  void insertIsSuspenseSheetShown(bool value) {
    try {
      userBox.put('suspenseSheet', value);
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
    }
  }

  void insertIsSettlementSheetShown(bool value) {
    try {
      userBox.put('settlementSheet', value);
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
    }
  }



  bool? get isAuthenticated {
    try {
      return authBox.get('isAuthenticated') ?? false;
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  String? get dynamicReferralCode {
    try {
      return userBox.get('dynamicReferral') ?? '';
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  String? get SignUpPaymentLink {
    try {
      return userBox.get('SignUpPaymentLink') ?? '';
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  void insertDynamicRefferalCode(String? value) {
    try {
      userBox.put('dynamicReferral', value);
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
    }
  }

  String get userPin {
    try {
      return authBox.get('pin') ?? '';
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return '';
    }
  }

  String get SignUpUserReferralCode {
    try {
      return userBox.get('SignUpUserReferralCode') ?? '';
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return '';
    }
  }

  String get SignUpUserReferralLink {
    try {
      return userBox.get('SignUpUserReferralLink') ?? '';
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return '';
    }
  }

  bool get pinStatus {
    try {
      return authBox.get('pinStatus') ?? false;
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return false;
    }
  }

  bool get fingerPrintStatus {
    try {
      return authBox.get('fingerprintStatus') ?? false;
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return false;
    }
  }

  List get pinTimes {
    try {
      return authBox.get('incorrectPinTimes') ?? [null, null];
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return [null, null];
    }
  }

  String get token {
    try {
      return authBox.get('token');
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return '';
    }
  }

  SignUpModel get userData {
    try {
      return userBox.get('UserData') ??
          SignUpModel(firstName: '', email: '', lastName: '', mobileNo: '');
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return SignUpModel(email: '', firstName: '', lastName: '', mobileNo: '');
    }
  }

  UnAuthModel get unAuthData {
    try {
      return userBox.get('UnAuthData') ??
          UnAuthModel(loginTime: DateTime.now());
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return UnAuthModel(loginTime: DateTime.now());
    }
  }

  DateTime get lastBackupTimeStamp {
    try {
      return userBox.get('timestamp') ?? DateTime.now();
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return DateTime.now();
    }
  }

  String get isoCode {
    try {
      return userBox.get('isoCode') ?? '';
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return 'IN';
    }
  }

  BusinessModel? get selectedBusiness {
    try {
      return userBox.get('selectedBusiness');
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return null;
    }
  }

  // UserDetailsModel get userDetails {
  //   try {
  //     return userBox.get('UserDetails') ?? '' as UserDetailsModel;
  //   } on Exception catch (e, s) {
  //     debugPrint(e.toString() + '\n' + s.toString());
  //     return UserDetailsModel('', '', '', '', '', '');
  //   }
  // }

  bool get isCashbookSheetShown {
    try {
      return userBox.get('cashbookSheet') ?? false;
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return false;
    }
  }

  bool get isSuspenseDialogShown {
    try {
      return userBox.get('suspenseSheet') ?? false;
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return false;
    }
  }

  bool get isSettlementDialogShown {
    try {
      return userBox.get('settlementSheet') ?? false;
    } on Exception catch (e, s) {
      debugPrint(e.toString() + '\n' + s.toString());
      return false;
    }
  }



  Future<void> clearHiveData() async {
    await userBox.clear();
    await authBox.clear();
    insertIsAuthenticated(false);
    // await authBox.clear();
  }
}
