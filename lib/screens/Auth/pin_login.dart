import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/error_codes.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Cubits/ImportContacts/import_contacts_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/login_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/chat_module/data/models/message.dart';
import 'package:urbanledger/chat_module/data/repositories/chat_repository.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:app_settings/app_settings.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import 'package:uuid/uuid.dart';

class PinLoginScreen extends StatefulWidget {
  final String mobileNo;
  final bool isLogin;
  const PinLoginScreen(
      {Key? key, required this.mobileNo, required this.isLogin})
      : super(key: key);
  @override
  PinLoginPageState createState() => PinLoginPageState();
}

class PinLoginPageState extends State<PinLoginScreen> {
  final ValueNotifier<String> pinNotifier = ValueNotifier('');
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final GlobalKey<State> key = GlobalKey<State>();
  final Repository _repository = Repository();
  int incorrectPinCount = 0;
  late DateTime? pinTime;
  late DateTime? tempTime;
  int secondsRemaining = 0;
  double viewInsetsBottom = 0.0;
  double height = deviceHeight - appBarHeight;
  bool isHightSubtracted = false;
  late bool isFingerPrintOn;
  late bool isPinOn;
  bool isFingerPrintDisabledFromPhone = false;
  String businessId = '';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ImportContactsCubit>(context).getContactsFromDevice();
    isFingerPrintOn = _repository.hiveQueries.fingerPrintStatus;
    isPinOn = _repository.hiveQueries.pinStatus;
    pinTime = _repository.hiveQueries.pinTimes.first;
    tempTime = _repository.hiveQueries.pinTimes.last;
    if (pinTime != null) {
      final sec = DateTime.now().difference(pinTime!).inSeconds;
      // debugPrint(sec.toString());
      if (sec < 1800) {
        secondsRemaining = 1800 - sec;
        incorrectPinCount = 4;
      } else if (sec >= 1800) {
        incorrectPinCount = 0;
        pinTime = null;
        tempTime = null;
        _repository.hiveQueries.insertIncorrectPinTime([null, null]);
      }
    }
    if (isFingerPrintOn) {
      if (incorrectPinCount < 4) {
        _authenticate();
      }
    }
  }

  static const iosStrings = const IOSAuthMessages(
      cancelButton: 'cancel',
      goToSettingsButton: 'settings',
      goToSettingsDescription: 'Please set up your Touch ID.',
      lockOut: 'Please reenable your Touch ID');

  void _authenticate() async {
    try {
      final biometricList = await _localAuthentication.getAvailableBiometrics();
      if (biometricList.length != 0) {
        final canCheckBiometrics =
            await _localAuthentication.canCheckBiometrics;
        if (canCheckBiometrics) {
          final _isAuthenticated = await _localAuthentication.authenticate(
              localizedReason: 'Scan your fingerprint to authenticate',
              useErrorDialogs: true,
              biometricOnly: true,
              iOSAuthStrings: iosStrings,
              stickyAuth: true);
          if (_isAuthenticated) {
            //     if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            // if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            // if (Navigator.of(context).canPop()) Navigator.of(context).pop();

            bool isStatic =
                await (CustomSharedPreferences.contains('StaticQRData'));
            bool isDynamic =
                await (CustomSharedPreferences.contains('DynamicQRData'));
            bool isMerchant =
                await (CustomSharedPreferences.contains('MerchantQRData'));
            bool isKYC = (await CustomSharedPreferences.get("isKYC")) ?? false;
            bool isBankAccount =
                (await CustomSharedPreferences.get("isBankAccount")) ?? false;
            if (isStatic) {
              CustomLoadingDialog.showLoadingDialog(context, key);
              debugPrint('isStatic : ' + isStatic.toString());
              String data1 =
                  await (CustomSharedPreferences.get('StaticQRData'));
              Map<String, dynamic> staticQRData = jsonDecode(data1);
              Provider.of<BusinessProvider>(context, listen: false)
                  .updateSelectedBusiness();
              final id = await getlocalCustId(
                      (staticQRData)['customerProfile']['mobile_no'],
                      (staticQRData)['customerProfile']['first_name'] +
                          ' ' +
                          (staticQRData)['customerProfile']['last_name'])
                  .timeout(Duration(seconds: 30), onTimeout: () async {
                // Navigator.of(context).pop();
                return Future.value(null);
              });
              // debugPrint('aas: ${id.toString()}');
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(
                  context, AppRoutes.payTransactionRoute,
                  arguments: QRDataArgs(
                      customerModel: CustomerModel()
                        ..customerId = id
                        ..name = (staticQRData)['customerProfile']
                                ['first_name'] +
                            ' ' +
                            (staticQRData)['customerProfile']['last_name']
                        ..mobileNo =
                            (staticQRData)['customerProfile']['mobile_no'],
                      customerId: (staticQRData)['customerProfile']['_id'],
                      type: 'QRCODE',
                      suspense: true,
                      through: 'STATICQRCODE'));
              // } else {
              //   Navigator.of(context).pop(true);
              //   '${(isTransaction)['message']}'.showSnackBar(context);
              // }
            } else if (isDynamic) {
              CustomLoadingDialog.showLoadingDialog(context, key);
              final data2 =
                  await (CustomSharedPreferences.get('DynamicQRData'));
              Map<String, dynamic> dynamicQRData = jsonDecode(data2);
              Provider.of<BusinessProvider>(context, listen: false)
                  .updateSelectedBusiness();
              final id = await getlocalCustId(
                      (dynamicQRData)['mobileNo'],
                      (dynamicQRData)['firstName'] +
                          ' ' +
                          (dynamicQRData)['lastName'])
                  .timeout(Duration(seconds: 30), onTimeout: () async {
                // Navigator.of(context).pop();
                return Future.value(null);
              });
              // Navigator.pop(context);
              debugPrint('AAAAAAAA' + dynamicQRData.toString());
              // Map<String, dynamic> isTransaction =
              //     await repository.paymentThroughQRApi.getTransactionLimit();
              // if (!(isTransaction)['isError']) {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(
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
                    requestId: (dynamicQRData)['request_id'],
                    amount: (dynamicQRData)['amount'].toString(),
                    currency: (dynamicQRData)['currency'],
                    note: (dynamicQRData)['note'],
                    type: 'QRCODE',
                    suspense: false,
                    through: 'DYNAMICQRCODE'),
              );
              // } else {
              //   Navigator.of(context).pop(true);
              //   '${(isTransaction)['message']}'.showSnackBar(context);
              // }
            } else if (isMerchant) {
              CustomLoadingDialog.showLoadingDialog(context, key);
              String data2 =
                  await (CustomSharedPreferences.get('MerchantQRData'));
              Map<String, dynamic> merchantQRData = jsonDecode(data2);
              Provider.of<BusinessProvider>(context, listen: false)
                  .updateSelectedBusiness();
              final id = await getlocalCustId(
                      (merchantQRData)['mobileNo'],
                      (merchantQRData)['firstName'] +
                          ' ' +
                          (merchantQRData)['lastName'])
                  .timeout(Duration(seconds: 30), onTimeout: () async {
                // Navigator.of(context).pop();
                return Future.value(null);
              });
              // Uri paths = Uri.parse((merchantQRData)['url'].toString());
              // (path.split('.').last)
              // debugPrint('requested id : '+(merchantQRData)['url'].split('=').last);
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.payTransactionRoute,
                arguments: QRDataArgs(
                    customerModel: CustomerModel()
                      ..ulId = (merchantQRData)['customer_id']
                      ..name = (merchantQRData)['firstName'] +
                          ' ' +
                          (merchantQRData)['lastName']
                      ..mobileNo = (merchantQRData)['mobileNo'],
                    customerId: id,
                    amount: (merchantQRData)['amount'].toString(),
                    currency: (merchantQRData)['currency'],
                    note: (merchantQRData)['note'],
                    type: 'QRCODE',
                    suspense: true,
                    requestId: (merchantQRData)['url'].split('=').last,
                    through: 'APIQRCODE'),
              );
              // }
            } else if (isKYC) {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.manageKyc1Route);
            } else if (isBankAccount) {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.profileBankAccountRoute);
              CustomLoadingDialog.showLoadingDialog(context, key);
            } else {
              Navigator.of(context).pushNamed(AppRoutes.mainRoute);
            }
          }
        }
      } else {
        isFingerPrintDisabledFromPhone = true;
      }
    } on PlatformException catch (e) {
      if (e.code == notAvailable) {
        if (isFingerPrintDisabledFromPhone) {
          isFingerPrintDisabledFromPhone = false;
        } else
          isFingerPrintDisabledFromPhone = true;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    pinNotifier.dispose();
    // _localAuthentication.stopAuthentication();
  }

  Future<String> getlocalCustId(String mobileNo, String name) async {
    final localCustId = await repository.queries
        .getCustomerId(mobileNo)
        .timeout(Duration(seconds: 30), onTimeout: () async {
      Navigator.of(context).pop();
      return Future.value(null);
    });
    Provider.of<BusinessProvider>(context, listen: false)
        .updateSelectedBusiness();
    businessId = Provider.of<BusinessProvider>(context, listen: false)
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

  Future<bool?> showWarningDialog() async => await showDialog(
      builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Dialog(
                insetPadding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 5, left: 20, right: 20),
                      child: CustomText(
                        'Please Enable Fingerprint from Settings to Continue.',
                        bold: FontWeight.w500,
                        color: AppTheme.brownishGrey,
                        size: 18,
                        centerAlign: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: AppTheme.electricBlue,
                                ),
                                child: CustomText(
                                  'CANCEL',
                                  color: Colors.white,
                                  size: (18),
                                  bold: FontWeight.w500,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    primary: AppTheme.electricBlue),
                                child: CustomText(
                                  'SETTINGS',
                                  color: Colors.white,
                                  size: (18),
                                  bold: FontWeight.w500,
                                ),
                                onPressed: () async {
                                  AppSettings.openSecuritySettings();
                                  // _authenticate();
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              25.0.heightBox,
            ],
          ),
      barrierDismissible: false,
      context: context);

  @override
  Widget build(BuildContext context) {
    viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    if (!isHightSubtracted) {
      height = height - MediaQuery.of(context).viewPadding.top;
      isHightSubtracted = true;
    }
    Future.delayed(Duration(seconds: 1), () {
      // debugPrint(isFingerPrintDisabledFromPhone.toString());
      // debugPrint(isPinOn.toString());

      if (isFingerPrintDisabledFromPhone && !isPinOn)
        // WidgetsBinding.instance?.addPostFrameCallback((_) {
        showWarningDialog();
      // });
    });
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.none,
              height:
                  (!isPinOn && isFingerPrintOn) ? height * 0.2 : height * 0.35,
              width: double.infinity,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(AppAssets.backgroundImage2),
                      alignment: Alignment.topCenter)),
            ),
            (!isPinOn && isFingerPrintOn)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      15.0.heightBox,
                      Center(child: commonLogoWithTagline(height)),
                      (height * 0.1).heightBox,
                      Image.asset(
                        AppAssets.fingerPrintClipArtImage,
                        height: height * 0.4,
                      ),
                      (height * 0.1).heightBox,
                      CustomText(
                        'Allow Touch ID',
                        size: 18,
                        bold: FontWeight.w700,
                        color: AppTheme.brownishGrey,
                      ),
                      10.0.heightBox,
                      CustomText(
                        'Use Touch ID for Faster and Secure\naccess to your Account',
                        centerAlign: true,
                        size: 16,
                        bold: FontWeight.w500,
                        color: AppTheme.brownishGrey,
                      ),
                      20.0.heightBox,
                      GestureDetector(
                        onTap: () {
                          _authenticate();
                        },
                        child: Image.asset(
                          AppAssets.fingerprintIcon,
                          height: height * 0.1,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      // 15.0.heightBox,
                      commonLogoWithTagline(height),
                      Text(
                        'Enter Urban Ledger PIN',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      ValueListenableBuilder<String>(
                          valueListenable: pinNotifier,
                          builder: (context, value, _) {
                            return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  pinBox(value.length > 0),
                                  pinBox(value.length > 1),
                                  pinBox(value.length > 2),
                                  pinBox(value.length > 3),
                                ]);
                          }),
                      (height * 0.07).heightBox,
                      incorrectPinCount > 0
                          ? Column(
                              children: [
                                CustomText(
                                  incorrectPinCount > 3
                                      ? 'Too many incorrect attempts.'
                                      : 'You have entered an invalid PIN.\n You have ${4 - incorrectPinCount} more attempts left.',
                                  size: 16,
                                  bold: FontWeight.w400,
                                  color: AppTheme.brownishGrey,
                                ),
                                if (incorrectPinCount > 3)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        'Please try again in ',
                                        size: 16,
                                        bold: FontWeight.w400,
                                        color: AppTheme.brownishGrey,
                                      ),
                                      CountDownTimer(
                                        secondsRemaining: secondsRemaining,
                                        countDownTimerStyle: TextStyle(),
                                        whenTimeExpires: () {
                                          incorrectPinCount = 0;
                                          pinTime = null;
                                          tempTime = null;
                                          _repository.hiveQueries
                                              .insertIncorrectPinTime(
                                                  [pinTime, tempTime]);
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                10.0.heightBox,
                                TextButton(
                                    onPressed: () async {
                                      CustomLoadingDialog.showLoadingDialog(
                                          context);
                                      final token = await _repository
                                          .changePinApi
                                          .changePinRequest();
                                      Navigator.of(context).popAndPushNamed(
                                          AppRoutes.changePinVerification,
                                          arguments:
                                              ChangePinVArgs(token, false));
                                    },
                                    child: CustomText(
                                      'FORGOT PIN?',
                                      size: 16,
                                      bold: FontWeight.w600,
                                      color: Theme.of(context).primaryColor,
                                    ))
                              ],
                            )
                          : Image.asset(
                              AppAssets.pinClipartImage,
                              height: height * 0.3,
                            ),
                      Spacer(),
                      if (incorrectPinCount < 4)
                        ResponsiveWrapper(
                          child: Container(
                            // height: height * 0.30,
                            child: keyBoard(),
                          ),
                          maxWidth: 1200,
                          minWidth: 480,
                          shrinkWrap: true,
                          defaultScale: true,
                        )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget pinField(bool isFilled) => Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Column(
          children: [
            CustomText(
              isFilled ? '*' : '',
              size: 30,
              color: AppTheme.brownishGrey,
            ),
            Container(
              color: AppTheme.brownishGrey,
              height: 3,
              width: 30,
            )
          ],
        ),
      );

  Widget keyBoard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            keyBoardButton('1'),
            keyBoardButton('2'),
            keyBoardButton('3')
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            keyBoardButton('4'),
            keyBoardButton('5'),
            keyBoardButton('6')
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            keyBoardButton('7'),
            keyBoardButton('8'),
            keyBoardButton('9')
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MaterialButton(
              onPressed: () {},
            ),
            keyBoardButton('0'),
            MaterialButton(
                shape: CircleBorder(),
                onPressed: () {
                  deleteText();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/icons/Delete_Back-01.png',
                      width: 25.0, height: 25.0),
                )),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
      ],
    );
  }

  Widget keyBoardButton(String number) => MaterialButton(
        shape: CircleBorder(),
        splashColor: AppTheme.buttonSplashGrey,
        onPressed: () {
          inputTextToField(number);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(number,
              style: TextStyle(
                  color: AppTheme.brownishGrey,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center),
        ),
      );

  Widget pinBox(bool value) => Padding(
        padding: EdgeInsets.all(10),
        child: new Container(
            height: 75,
            width: 50,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
                color: Colors.white,
                border: new Border.all(width: 2.0, color: Colors.white),
                borderRadius: new BorderRadius.circular(7)),
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: value ? AppTheme.brownishGrey : Colors.white),
            )),
      );

  void inputTextToField(String str) async {
    if (pinNotifier.value.length <= 4) {
      pinNotifier.value = pinNotifier.value + str;
    }
    if (pinNotifier.value.length == 4) {
      LoginModel loginModel = LoginModel(
          mobileNo: Repository().hiveQueries.userData.mobileNo,
          pin: pinNotifier.value);
      bool isLogin = await Repository().queries.fetchLoginUser(loginModel);
      if (isLogin) {
        repository.hiveQueries.setPinStatus(true);
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
        bool isStatic =
            await (CustomSharedPreferences.contains('StaticQRData'));
        bool isDynamic =
            await (CustomSharedPreferences.contains('DynamicQRData'));
        bool isMerchant =
            await (CustomSharedPreferences.contains('MerchantQRData'));
        bool isKYC = (await CustomSharedPreferences.get("isKYC")) ?? false;
        bool isBankAccount =
            (await CustomSharedPreferences.get("isBankAccount")) ?? false;
        if (isStatic) {
          CustomLoadingDialog.showLoadingDialog(context, key);
          debugPrint('isStatic : ' + isStatic.toString());
          String data1 = await (CustomSharedPreferences.get('StaticQRData'));
          Map<String, dynamic> staticQRData = jsonDecode(data1);
          Provider.of<BusinessProvider>(context, listen: false)
              .updateSelectedBusiness();
          final id = await getlocalCustId(
                  (staticQRData)['customerProfile']['mobile_no'],
                  (staticQRData)['customerProfile']['first_name'] +
                      ' ' +
                      (staticQRData)['customerProfile']['last_name'])
              .timeout(Duration(seconds: 30), onTimeout: () async {
            // Navigator.of(context).pop();
            return Future.value(null);
          });
          // debugPrint('aas: ${id.toString()}');
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, AppRoutes.payTransactionRoute,
              arguments: QRDataArgs(
                  customerModel: CustomerModel()
                    ..customerId = id
                    ..name = (staticQRData)['customerProfile']['first_name'] +
                        ' ' +
                        (staticQRData)['customerProfile']['last_name']
                    ..mobileNo = (staticQRData)['customerProfile']['mobile_no'],
                  customerId: (staticQRData)['customerProfile']['_id'],
                  type: 'QRCODE',
                  suspense: true,
                  through: 'STATICQRCODE'));
          // } else {
          //   Navigator.of(context).pop(true);
          //   '${(isTransaction)['message']}'.showSnackBar(context);
          // }
        } else if (isDynamic) {
          CustomLoadingDialog.showLoadingDialog(context, key);
          String data2 = await (CustomSharedPreferences.get('DynamicQRData'));
          Map<String, dynamic> dynamicQRData = jsonDecode(data2);
          Provider.of<BusinessProvider>(context, listen: false)
              .updateSelectedBusiness();
          final id = await getlocalCustId(
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
          Navigator.pushReplacementNamed(
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
                requestId: (dynamicQRData)['request_id'],
                type: 'QRCODE',
                suspense: false,
                through: 'DYNAMICQRCODE'),
          );
          // } else {
          //   Navigator.of(context).pop(true);
          //   '${(isTransaction)['message']}'.showSnackBar(context);
          // }
        } else if (isMerchant) {
          CustomLoadingDialog.showLoadingDialog(context, key);
          String data2 = await (CustomSharedPreferences.get('MerchantQRData'));
          Map<String, dynamic> merchantQRData = jsonDecode(data2);
          Provider.of<BusinessProvider>(context, listen: false)
              .updateSelectedBusiness();
          final id = await getlocalCustId(
                  (merchantQRData)['mobileNo'],
                  (merchantQRData)['firstName'] +
                      ' ' +
                      (merchantQRData)['lastName'])
              .timeout(Duration(seconds: 30), onTimeout: () async {
            // Navigator.of(context).pop();
            return Future.value(null);
          });
          // Uri paths = Uri.parse((merchantQRData)['url'].toString());
          // (path.split('.').last)
          // debugPrint('requested id : '+(merchantQRData)['url'].split('=').last);
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.payTransactionRoute,
            arguments: QRDataArgs(
                customerModel: CustomerModel()
                  ..ulId = (merchantQRData)['customer_id']
                  ..name = (merchantQRData)['firstName'] +
                      ' ' +
                      (merchantQRData)['lastName']
                  ..mobileNo = (merchantQRData)['mobileNo'],
                customerId: id,
                amount: (merchantQRData)['amount'].toString(),
                currency: (merchantQRData)['currency'],
                note: (merchantQRData)['note'],
                type: 'QRCODE',
                suspense: true,
                requestId: (merchantQRData)['url'].split('=').last,
                through: 'APIQRCODE'),
          );
          // }
        } else if (isKYC) {
          Navigator.of(context).pushNamed(AppRoutes.manageKyc1Route);
        } else if (isBankAccount) {
          Navigator.of(context)
              .pushReplacementNamed(AppRoutes.profileBankAccountRoute);
          CustomLoadingDialog.showLoadingDialog(context, key);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);
        }
      } else {
        await Future.delayed(Duration(milliseconds: 200));
        setState(() {
          incorrectPinCount++;
          if (incorrectPinCount == 4) {
            pinTime = DateTime.now();
            tempTime = pinTime;
            tempTime = tempTime!.add(Duration(minutes: 30));
            secondsRemaining = tempTime!.difference(pinTime!).inSeconds;
            _repository.hiveQueries.insertIncorrectPinTime([pinTime, tempTime]);
            setState(() {});
          }
        });
        pinNotifier.value = '';
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text('Please recheck your pin and try again.'),
        // ));
      }
    }
  }

  void deleteText() {
    if (pinNotifier.value.length != 0) {
      pinNotifier.value =
          pinNotifier.value.substring(0, pinNotifier.value.length - 1);
    }
  }

  Widget commonLogoWithTagline(double height) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Image(
            image: AssetImage('assets/images/logo.png'),
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.33,
          ),
        ),
        CustomText(
          'Track. Remind. Pay.',
          size: 18,
          bold: FontWeight.w500,
          color: Colors.white,
        ),
        SizedBox(
          height: height * 0.04,
        ),
      ],
    );
  }
}
