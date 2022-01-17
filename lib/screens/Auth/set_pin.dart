import 'package:flutter/material.dart';
import 'package:urbanledger/Models/login_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/pin_code_strenth.dart';
import 'package:urbanledger/main.dart';
import '../Components/extensions.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';

class SetPinScreen extends StatefulWidget {
  final bool showConfirmPinState;
  final String tempPin;
  final bool isResetPinState;
  final bool isRegister;

  const SetPinScreen(
      {Key? key,
      required this.showConfirmPinState,
      required this.tempPin,
      required this.isResetPinState,
      required this.isRegister})
      : super(key: key);

  @override
  _SetPinScreenState createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final ValueNotifier<String> pinNotifier = ValueNotifier('');
  final ValueNotifier<String> setPinNotifier = ValueNotifier('');
  final ValueNotifier<String> confirmPinNotifier = ValueNotifier('');
  final Repository _repository = Repository();
  static const double profileImage = 100.0;
  // final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool showError = false;

  @override
  void dispose() {
    setPinNotifier.dispose();
    confirmPinNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // _authenticate();
    super.initState();
  }

  /*  void _authenticate() async {
    try {
      final biometricList = await _localAuthentication.getAvailableBiometrics();
      if (biometricList.length != 0) {
        final canCheckBiometrics =
            await _localAuthentication.canCheckBiometrics;
        if (canCheckBiometrics) {
          final _isAuthenticated =
              await _localAuthentication.authenticateWithBiometrics(
                  localizedReason: 'Scan your fingerprint to authenticate',
                  useErrorDialogs: true,
                  stickyAuth: true);
          if (_isAuthenticated)
            Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  } */

  @override
  Widget build(BuildContext context) {
    final coverHeight = MediaQuery.of(context).size.height / 5;
    final top = coverHeight - profileImage / 2;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: gradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: titleName(color: AppTheme.whiteColor),
            centerTitle: true,
          ),
          // bottomSheet: Container(
          //   color: AppTheme.whiteColor,
          //   child: Column(mainAxisSize: MainAxisSize.min, children: [
          //     Center(
          //       child: Text(
          //         'By clicking the register button, you agree to our Terms and Conditions',
          //         style: TextStyle(
          //           color: AppTheme.greyish,
          //           fontSize: 12.5,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //     Container(
          //       width: double.infinity,
          //       margin: EdgeInsets.symmetric(vertical: 15),
          //       padding:
          //           const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          //       child: ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //           primary: validate()
          //               ? AppTheme.purpleActive
          //               : AppTheme.disabledColor,
          //           padding: EdgeInsets.all(15),
          //           shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(10)),
          //         ),
          //         onPressed: isLoading
          //             ? null
          //             : () async {
          //                 setState(() {
          //                   firstNameError =
          //                       validateFirstName(_firstNameController.text);
          //                   lastNameError =
          //                       validateLastName(_lastNameController.text);
          //                   emailError = validateEmail(_emailController.text);
          //                   debugPrint("statement");
          //                 });
          //                 Login() async {
          //                   firstNameError =
          //                       validateFirstName(_firstNameController.text);
          //                   lastNameError =
          //                       validateLastName(_lastNameController.text);
          //                   emailError = validateEmail(_emailController.text);
          //                   debugPrint("statement");
          //                   if (firstNameError == null &&
          //                       lastNameError == null &&
          //                       emailError == null) {
          //                     setState(() {
          //                       isLoading = true;
          //                     });

          //                     final response = await (Repository()
          //                         .userProfileAPI
          //                         .userProfileApi(
          //                             SignUpModel(
          //                               firstName: _firstNameController.text,
          //                               lastName: _lastNameController.text,
          //                               mobileNo:
          //                                   widget.mobile.replaceAll('+', ''),
          //                               email: _emailController.text,
          //                               referral_code: repository
          //                                   .hiveQueries.SignUpUserReferralCode,
          //                               referral_link: repository
          //                                   .hiveQueries.SignUpUserReferralLink,
          //                               paymentLink: repository
          //                                   .hiveQueries.SignUpPaymentLink
          //                                   .toString(),
          //                             ),
          //                             context)
          //                         .timeout(Duration(seconds: 30),
          //                             onTimeout: () async {
          //                       Navigator.of(context).pop();
          //                       return Future.value(null);
          //                     }).catchError((e) {
          //                       setState(() {
          //                         isLoading = false;
          //                       });
          //                       debugPrint(e.toString());
          //                       // ScaffoldMessenger.of(context)
          //                       //     .showSnackBar(SnackBar(
          //                       //   content: CustomText(
          //                       //       'Please check internet connectivity and try again.'),
          //                       // ));
          //                       'Please check internet connectivity and try again.'
          //                           .showSnackBar(context);
          //                       return false;
          //                     }));

          //                     if (response) {
          //                       /*  final registerResponse =
          //                             await RegisterRepository().register(
          //                                 _firstNameController.text +
          //                                     ' ' +
          //                                     _lastNameController.text,
          //                                 _emailController.text); */
          //                       var anaylticsEvents = AnalyticsEvents(context);

          //                       if (_referralController.text.isNotEmpty) {
          //                         // final response = await (Repository()
          //                         //     .userProfileAPI
          //                         //     .sendDynamicReferralCode(
          //                         //         _referralController.text
          //                         //             .toString())
          //                         //     .timeout(Duration(seconds: 30),
          //                         //         onTimeout: () async {
          //                         //   Navigator.of(context).pop();
          //                         //   return false;
          //                         // }).catchError((e) {
          //                         //   setState(() {
          //                         //     isLoading = false;
          //                         //   });
          //                         //   debugPrint(e.toString());
          //                         //   ScaffoldMessenger.of(context)
          //                         //       .showSnackBar(SnackBar(
          //                         //     content: CustomText(
          //                         //         'Please check internet connectivity and try again.'),
          //                         //   ));
          //                         //   return false;
          //                         // }));
          //                         await anaylticsEvents.signUpEvent(true);
          //                         debugPrint('Checking Referral Hit: ' +
          //                             response.toString());
          //                       }
          //                       await anaylticsEvents.signUpEvent(false);
          //                       LoginRepository().login(widget.mobile, context);
          //                       repository.hiveQueries
          //                           .insertIsAuthenticated(true);
          //                       repository.hiveQueries
          //                           .insertUserData(SignUpModel(
          //                         id: '',
          //                         firstName: _firstNameController.text,
          //                         lastName: _lastNameController.text,
          //                         mobileNo: widget.mobile,
          //                         email: _emailController.text,
          //                         paymentLink: repository
          //                             .hiveQueries.SignUpPaymentLink
          //                             .toString(),
          //                         referral_code: repository
          //                             .hiveQueries.SignUpUserReferralCode,
          //                         referral_link: repository
          //                             .hiveQueries.SignUpUserReferralLink,
          //                       ));
          //                       final businesssModel = BusinessModel(
          //                           businessId: Uuid().v1(),
          //                           businessName: 'PERSONAL',
          //                           isChanged: true,
          //                           isDeleted: false,
          //                           deleteAction: false);
          //                       await repository.queries
          //                           .insertBusiness(businesssModel);
          //                       if (await checkConnectivity) {
          //                         final apiResponse = await (repository
          //                             .businessApi
          //                             .saveBusiness(
          //                                 businesssModel, context, false)
          //                             .catchError((e) {
          //                           setState(() {
          //                             isLoading = false;
          //                           });
          //                           'Please check your internet connection or try again later.'
          //                               .showSnackBar(context);
          //                         }));
          //                         if (apiResponse) {
          //                           await repository.queries
          //                               .updateBusinessIsChanged(
          //                                   businesssModel, 0);
          //                         }
          //                       } else {
          //                         Navigator.of(context).pop();
          //                         'Please check your internet connection or try again later.'
          //                             .showSnackBar(context);
          //                       }
          //                       setState(() {
          //                         isLoading = false;
          //                       });
          //                       Future.delayed(Duration(seconds: 1))
          //                           .then((value) {
          //                         Navigator.of(context).pushReplacementNamed(
          //                           AppRoutes.setPinRoute,
          //                           arguments:
          //                               SetPinRouteArgs('', false, false, true),
          //                         );
          //                       });

          //                       // Navigator.of(context)
          //                       //     .pushReplacementNamed(
          //                       //         AppRoutes.welcomeuserRoute,
          //                       //         arguments: _firstNameController
          //                       //                 .text +
          //                       //             ' ' +
          //                       //             _lastNameController.text);
          //                     }
          //                   } else {
          //                     setState(() {});
          //                   }
          //                 }

          //                 if (_referralController.text.isNotEmpty &&
          //                     _referralController.text.length < 8) {
          //                   setState(() {
          //                     isLoading = false;
          //                   });
          //                   'Invalid referral code. Please check the referral code and try again.'
          //                       .showSnackBar(context);
          //                 } else if (firstNameError == null &&
          //                     lastNameError == null &&
          //                     emailError == null &&
          //                     _referralController.text.isNotEmpty &&
          //                     _referralController.text.length == 8) {
          //                   bool? response1 = await (Repository()
          //                       .userProfileAPI
          //                       .sendDynamicReferralCode(
          //                           _referralController.text.toString()));
          //                   if (response1 == true) {
          //                     'Referral applied successfully'
          //                         .showSnackBar(context);

          //                     if (firstNameError == null &&
          //                         lastNameError == null &&
          //                         emailError == null) {
          //                       debugPrint('Go for Login');
          //                       await Login();
          //                     } else {
          //                       setState(() {
          //                         isLoading = false;
          //                       });
          //                       // 'Please Check the input fields'
          //                       //     .showSnackBar(context);
          //                     }
          //                     setState(() {
          //                       isLoading = false;
          //                     });
          //                   } else {
          //                     setState(() {
          //                       isLoading = false;
          //                     });
          //                     'Invalid referral code. Please check the referral code and try again.'
          //                         .showSnackBar(context);
          //                   }
          //                 } else {
          //                   setState(() {});
          //                   debugPrint('Go for Login');
          //                   if (firstNameError == null &&
          //                       lastNameError == null &&
          //                       _referralController.text.isEmpty &&
          //                       emailError == null) {
          //                     await Login();
          //                   }
          //                   // else{
          //                   //     'Invalid referral code. Please check the referral code and try again.'
          //                   //     .showSnackBar(context);
          //                   // }

          //                 }
          //               },
          //         child: isLoading
          //             ? CircularProgressIndicator()
          //             : CustomText(
          //                 'Register',
          //                 color: validate()
          //                     ? AppTheme.whiteColor
          //                     : AppTheme.coolGrey,
          //                 size: (18),
          //                 bold: FontWeight.bold,
          //               ),
          //       ),
          //     ),
          //   ]),
          // ),
          body: Container(
            child: Stack(alignment: Alignment.topCenter, children: [
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.04,
                  child: topContainer),
              Container(
                  margin: EdgeInsets.only(top: coverHeight),
                  padding: EdgeInsets.only(top: 100),
                  // height:
                  //     MediaQuery.of(context).size.height - coverHeight - 84,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.25),
                        child: Image.asset(AppAssets.pinArtImage),
                      ),
                    ],
                  )),
              Positioned(
                  top: top,
                  // left: MediaQuery.of(context).size.width * 0.38,
                  // right: MediaQuery.of(context).size.width * 0.38,
                  child: topProfile),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    // margin: EdgeInsets.only(
                    //   top: MediaQuery.of(context).size.height * .6,
                    // ),
                    height: MediaQuery.of(context).size.height * .3,
                    color: AppTheme.whiteColor,
                    alignment: Alignment.bottomCenter,
                    child: keyBoard()),
              ),
            ]),
          ),
          // body: Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Flexible(
          //       flex: 1,
          //       child: Stack(
          //         alignment: Alignment.topCenter,
          //         children: [
          //           // Container(
          //           //   child: RichText(text: TextSpan(
          //           //     children: [
          //           //       TextSpan(
          //           //         text: 'Sign Up',
          //           //         style: TextStyle(
          //           //           fontSize: 30,
          //           //           color: AppTheme.whiteColor
          //           //         ),
          //           //       ),

          //           //     ]
          //           //   )),
          //           // ),
          //         Positioned(
          //           top: top,
          //           child: buildProfileImage()),
          //         ],
          //       ),
          //     ),
          //     Flexible(
          //       flex: 3,
          //       child: Container(
          //         // height: 250,
          //         color: AppTheme.whiteColor,
          //       ),
          //     ),
          //   ],

          // ),
        ),
      ),
    );
  }

  Widget get topProfile => Column(
        children: [
          !widget.showConfirmPinState
              ? ValueListenableBuilder<String>(
                  valueListenable: setPinNotifier,
                  builder: (context, value, _) {
                    return Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // pinBox(value.length > 0),
                              PinField(
                                  showError: showError,
                                  isFilled: value.length > 0,
                                  isSetField: true),
                              PinField(
                                  showError: showError,
                                  isFilled: value.length > 1,
                                  isSetField: true),
                              PinField(
                                  showError: showError,
                                  isFilled: value.length > 2,
                                  isSetField: true),
                              PinField(
                                  showError: showError,
                                  isFilled: value.length > 3,
                                  isSetField: true),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ]);
                  })
              : ValueListenableBuilder<String>(
                  valueListenable: confirmPinNotifier,
                  builder: (context, value, _) {
                    return Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // // SizedBox(
                          // //   height: 12,
                          // // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Image.asset(AppAssets.lock1Icon),
                          //     // SizedBox(
                          //     //   width: 8,
                          //     // ),
                          //     Text(
                          //       'Confirm PIN',
                          //       style: TextStyle(
                          //           fontSize: 24,
                          //           color: Colors.white,
                          //           fontWeight: FontWeight.w600),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // pinBox(value.length > 0),
                              PinField(
                                  showError: showError,
                                  isFilled: value.length > 0,
                                  isSetField: false),
                              PinField(
                                  showError: showError,
                                  isFilled: value.length > 1,
                                  isSetField: false),
                              PinField(
                                  showError: showError,
                                  isFilled: value.length > 2,
                                  isSetField: false),
                              PinField(
                                  showError: showError,
                                  isFilled: value.length > 3,
                                  isSetField: false),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ]);
                  }),
          showError && widget.showConfirmPinState
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    alignment: Alignment.center,
                    child: CustomText(
                      'Incorrect PIN. Enter again',
                      size: 16,
                      color: AppTheme.brownishGrey,
                      bold: FontWeight.w600,
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: CustomText(
                      '',
                      size: 16,
                      color: AppTheme.brownishGrey,
                      bold: FontWeight.w600,
                    ),
                  ),
                ),
        ],
      );

  Widget get topContainer => Container(
        // margin: EdgeInsets.only(top: 30),
        alignment: Alignment.center,
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: widget.showConfirmPinState ? 'Confirm Pin': 'Set Pin',
                style: TextStyle(
                    color: AppTheme.whiteColor,
                    fontSize: 36,
                    height: 1,
                    fontFamily: 'Hind'),
              ),
              TextSpan(
                text: '\n${repository.hiveQueries.userData.mobileNo}',
                // textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppTheme.whiteColor,
                    fontSize: 22,
                    height: 1,
                    fontFamily: 'Hind'),
              )
            ])),
        // child: Text('Sign Up',
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     color: AppTheme.whiteColor,
        //     fontSize: 40,
        //     fontFamily: 'Hind'
        //   ),
        // ),
      );

  Widget keyBoard() {
    return SingleChildScrollView(
      child: Column(
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
      ),
    );
  }

  Widget keyBoardButton(String number) => MaterialButton(
        color: AppTheme.whiteColor,
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

  Future<void> inputTextToField(String str) async {
    if (!widget.showConfirmPinState) {
      if (setPinNotifier.value.length < 4) {
        setPinNotifier.value = setPinNotifier.value + str;
        if (setPinNotifier.value.length == 4) {
          if (await PincodeStrenth()
              .checkPincodeStrenth(setPinNotifier.value)) {
            setState(() {
              showError = true;
            });
            showWeakPinDialog(context);
          } else {
            Navigator.of(context).pushNamed(AppRoutes.setPinRoute,
                arguments: SetPinRouteArgs(setPinNotifier.value, true,
                    widget.isResetPinState, widget.isRegister));
          }
        }
      }
    } else {
      if (confirmPinNotifier.value.length < 4) {
        confirmPinNotifier.value = confirmPinNotifier.value + str;
        if (confirmPinNotifier.value.length == 4) {
          if (widget.tempPin == confirmPinNotifier.value) {
            _repository.hiveQueries.insertUserPin(confirmPinNotifier.value);
            _repository.hiveQueries.setPinStatus(true);
            _repository.hiveQueries.setFingerPrintStatus(true);
            if (widget.showConfirmPinState && widget.isResetPinState) {
              debugPrint('CCCCCCCCCC : ' +
                  _repository.hiveQueries.userData.toString());
              LoginModel loginModel = LoginModel(
                mobileNo: _repository.hiveQueries.userData.mobileNo,
                pin: confirmPinNotifier.value,
                status: true,
              );
              repository.queries.checkLoginUser(loginModel);
              'Pin Reset Successful'.showSnackBar(context);
              await Future.delayed(Duration(seconds: 1));
            }
            debugPrint(
                'CCCCCCCCCC : ' + _repository.hiveQueries.userData.toString());
            LoginModel loginModel = LoginModel(
              mobileNo: _repository.hiveQueries.userData.mobileNo,
              pin: confirmPinNotifier.value,
              status: true,
            );
            repository.queries.checkLoginUser(loginModel);
            Navigator.of(context)
              ..pop()
              ..pop();
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            Navigator.of(context).pushNamed(widget.isRegister
                ? AppRoutes.welcomeuserRoute
                : AppRoutes.mainRoute);
            // Navigator.of(context).pushNamed(AppRoutes.introscreenRoute, arguments: IntroRouteArgs(widget.isRegister));
          } else {
            Future.delayed(Duration(milliseconds: 300), () {
              confirmPinNotifier.value = '';
              setState(() {
                showError = true;
              });
              // Navigator.of(context).pushReplacementNamed(AppRoutes.welcomescreenRoute);
            });
          }
        }
      }
    }
  }

  showWeakPinDialog(BuildContext ctx) {
    return showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: ctx,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(ctx).size.height * 0.3,
            child: SizedBox.expand(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Scaffold(
                      body: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: 16),
                              alignment: Alignment.center,
                              child: Text('Weak PIN',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500))),
                          SizedBox(
                            height: 8,
                          ),
                          Image.asset(
                            AppAssets.weak_pin,
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: CustomText(
                                'The PIN you have entered can be easily guessed. Do you want to proceed with this PIN?',
                                size: 18,
                                centerAlign: true,
                                color: AppTheme.brownishGrey,
                                bold: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      )),
                      bottomNavigationBar: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(ctx).pop();
                                    Navigator.of(ctx).pushNamed(
                                        AppRoutes.setPinRoute,
                                        arguments: SetPinRouteArgs(
                                            setPinNotifier.value,
                                            true,
                                            widget.isResetPinState,
                                            widget.isRegister));
                                  },
                                  child: CustomText(
                                    'YES',
                                    size: (18),
                                    bold: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(15),
                                    primary: AppTheme.electricBlue,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  )),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    setPinNotifier.value = '';
                                    Navigator.of(context).pop();
                                  },
                                  child: CustomText(
                                    'NO',
                                    size: (18),
                                    bold: FontWeight.w500,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      elevation: 0)),
                            ),
                          )
                        ],
                      ),
                    ))),
            margin: EdgeInsets.only(bottom: 12, left: 16, right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(new Radius.circular(12.0)),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  void deleteText() {
    if (showError)
      setState(() {
        showError = false;
      });
    if (confirmPinNotifier.value.length != 0) {
      confirmPinNotifier.value = confirmPinNotifier.value
          .substring(0, confirmPinNotifier.value.length - 1);
    } else if (setPinNotifier.value.length != 0) {
      setPinNotifier.value =
          setPinNotifier.value.substring(0, setPinNotifier.value.length - 1);
    }
  }
}

Widget pinBox(bool value) => Padding(
      padding: EdgeInsets.all(22),
      child: new Container(
          height: 20,
          width: 20,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border.all(width: 2.0, color: Colors.white),
              borderRadius: new BorderRadius.circular(20)),
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: value ? AppTheme.brownishGrey : Colors.white),
          )),
    );

class PinField extends StatelessWidget {
  const PinField({
    Key? key,
    required this.showError,
    required this.isFilled,
    required this.isSetField,
  }) : super(key: key);

  final bool showError;

  ///
  final bool isFilled;
  final bool isSetField;

  ///

  @override
  Widget build(BuildContext context) => Padding(
        // padding: const EdgeInsets.only(left: 15.0, right: 15),
        padding: EdgeInsets.all(10),
        child: new Container(
          height: 80,
          width: 50,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black54.withOpacity(0.1),
                    blurRadius: 7.0,
                    spreadRadius: 5.0,
                    offset: Offset(0, 0))
              ],
              color: Colors.white,
              border: new Border.all(width: 2.0, color: Colors.white),
              borderRadius: new BorderRadius.circular(7)),
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isFilled ? AppTheme.brownishGrey : Colors.white),
          ),
        ),
        // child: Column(
        //   children: [
        //     // CustomText(
        //     //   isFilled ? '*' : '',
        //     //   size: 30,
        //     //   color: AppTheme.brownishGrey,
        //     // ),
        //     10.0.heightBox,
        //     Container(
        //       height: 20,
        //       width: 20,
        //       decoration: BoxDecoration(
        //           color: isFilled ? AppTheme.brownishGrey : Colors.white,
        //           borderRadius: BorderRadius.circular(15)),
        //     ),
        //     10.0.heightBox,
        //     Container(
        //       color: showError && !isSetField
        //           ? AppTheme.tomato
        //           : AppTheme.brownishGrey,
        //       height: 3,
        //       width: 30,
        //     )
        //   ],
        // ),
      );
}
