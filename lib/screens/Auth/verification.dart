// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Models/login_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/ul_logo_widget.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import '../../chat_module/data/repositories/login_repository.dart';

import '../Components/extensions.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNo;
  final bool isRegister;

  const VerificationScreen(
      {Key? key, required this.phoneNo, required this.isRegister})
      : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Repository repository = Repository();
  String? _digit1, _digit2, _digit3, _digit4, _digit5, _digit6;
  FocusNode firstFocusNode = FocusNode();
  FocusNode secondFocusNode = FocusNode();
  FocusNode thirdFocusNode = FocusNode();
  FocusNode fourthFocusNode = FocusNode();
  FocusNode fifthFocusNode = FocusNode();
  FocusNode sixthFocusNode = FocusNode();
  final TextEditingController oneController = TextEditingController();
  final TextEditingController twoController = TextEditingController();
  final TextEditingController threeController = TextEditingController();
  final TextEditingController fourController = TextEditingController();
  final TextEditingController fiveController = TextEditingController();
  final TextEditingController sixController = TextEditingController();

  final GlobalKey<State> key = GlobalKey<State>();
  late bool _serviceEnabled;
  final location = Location();
  bool isResendOtpClickable = false;
  int _resendOtpCount = 30;
  // late Timer _timer;

  late AnimationController _controller;
  // final FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
    super.initState();
    /*  Future.delayed(Duration(milliseconds: 250)).then((value) {
      if (widget.phoneNo != null)
        _sendVerificationCode(widget.phoneNo.replaceAll(' ', ''));
    }); */
    oneController.text = ' ';
    twoController.text = ' ';
    threeController.text = ' ';
    fourController.text = ' ';
    fiveController.text = ' ';
    sixController.text = ' ';

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 30));


  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Future.delayed(const Duration(seconds: 1), () {

// Here you can write your code

      if(mounted) {
        _controller.forward();
      }

    });

  }

  @override
  void dispose() {
    oneController.dispose();
    twoController.dispose();
    threeController.dispose();
    fourController.dispose();
    fiveController.dispose();
    sixController.dispose();
    firstFocusNode.dispose();
    secondFocusNode.dispose();
    thirdFocusNode.dispose();
    fourthFocusNode.dispose();
    fifthFocusNode.dispose();
    sixthFocusNode.dispose();
    // _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  checkService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppTheme.paleBlue,
        bottomNavigationBar: Padding(
          padding: isPlatformiOS()? EdgeInsets.only(
            bottom: 25,
          ): EdgeInsets.only(
            bottom: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              (screenWidth(context) * 0.035).widthBox,
              /* Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(15),
                    side: BorderSide(color: isResendOtpClickable?AppTheme.electricBlue:Colors.grey, width: 2),
                    // color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    clearTextControllers();
                    isResendOtpClickable = false;
                    // _sendVerificationCode(widget.phoneNo.replaceAll(' ', ''));
                  },
                  child: CustomText(
                    'RESEND OTP',
                    size: (18),
                    color: isResendOtpClickable?AppTheme.electricBlue:Colors.grey,
                    bold: FontWeight.w500,
                  ),
                ),
              ),
              (screenWidth(context) * 0.07).widthBox,*/
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.only(
                        bottom: 15, top: 15, left: 30, right: 30),
                    primary: validate() == true
                        ? AppTheme.purpleActive
                        : AppTheme.disabledColor,
                  ),
                  child: CustomText(
                    'VERIFY OTP',
                    size: (18),
                    bold: FontWeight.bold,
                    color: validate() == true
                        ? AppTheme.whiteColor
                        : AppTheme.coolGrey,
                  ),
                  onPressed: validate() == true
                      ? () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      //TODO: To handle location permission when denied.

                            // await checkService();
                            // final _location = await location.getLocation();
                            CustomLoadingDialog.showLoadingDialog(context, key);
                            final status = widget.isRegister
                                ? await (repository.registerApi
                                        .registerOtpVerification(
                                            _digit1! +
                                                _digit2! +
                                                _digit3! +
                                                _digit4!,
                                            // _location.latitude,
                                            // _location.longitude,
                                            0,
                                            0))
                                    .timeout(Duration(seconds: 30),
                                        onTimeout: () async {
                                    Navigator.of(context).pop();
                                    return Future.value(null);
                                  }).catchError((e) {
                                    oneController.text = ' ';
                                    twoController.text = ' ';
                                    threeController.text = ' ';
                                    fourController.text = ' ';
                                    fiveController.text = ' ';
                                    sixController.text = ' ';
                                    setState(() {});
                                    e.toString().showSnackBar(context);
                                    debugPrint('Incorrect12345');
                                    // Navigator.of(context).pop();
                                    // return 'Incorrect';
                                  })
                                : await (repository.loginApi
                                        .loginOtpVerification(
                                            _digit1! +
                                                _digit2! +
                                                _digit3! +
                                                _digit4!,
                                            // _location.latitude,
                                            // _location.longitude,
                                            0,
                                            0))
                                    .catchError((e) {
                                    oneController.text = ' ';
                                    twoController.text = ' ';
                                    threeController.text = ' ';
                                    fourController.text = ' ';
                                    fiveController.text = ' ';
                                    sixController.text = ' ';
                                    debugPrint('KKKKKKKKKKKKK');
                                    setState(() {});
                                    e.toString().showSnackBar(context);
                                    Navigator.of(context).pop();
                                    return 'Incorrect';
                                  });
                            debugPrint('abcdnfndfnsdf' + status.toString());
                            if (status.isNotEmpty) {
                              if (status == 'isNotRegister') {
                                Navigator.of(context)
                                  ..pop()
                                  ..pop()
                                  ..pushReplacementNamed(AppRoutes.signupRoute,
                                      arguments:
                                          widget.phoneNo.replaceAll(' ', ''));
                              }
                              if (status == 'Incorrect') return;
                              _formKey.currentState!.reset();
                              if (!widget.isRegister) {
                                debugPrint("isREgister");
                                // await analytics.logLogin();
                                LoginRepository().login(
                                    widget.phoneNo.replaceAll(' ', ''),
                                    context);
                                repository.hiveQueries
                                    .insertIsAuthenticated(true);
                                LoginModel loginModel = LoginModel(
                                    mobileNo: widget.phoneNo
                                        .replaceAll(' ', '')
                                        .replaceAll('+', ''));
                                bool isLogin = await Repository()
                                    .queries
                                    .isLoginUser(loginModel);
                                debugPrint("qqqqqqqd : " + isLogin.toString());
                                if (isLogin) {
                                  Navigator.of(context)
                                    ..pop()
                                    ..pop()
                                    ..pushReplacementNamed(
                                        AppRoutes.pinLoginRoute,
                                        arguments: PinRouteArgs(
                                            widget.phoneNo.replaceAll(' ', ''),
                                            true));
                                } else {
                                  if (repository.hiveQueries.userPin.isEmpty) {
                                    if (repository.hiveQueries.userData
                                        .firstName.isEmpty) {
                                      Future.delayed(Duration(seconds: 1))
                                          .then((value) {
                                        Navigator.of(context)
                                          ..pop()
                                          ..pop()
                                          ..pushReplacementNamed(
                                              AppRoutes.signupRoute,
                                              arguments: widget.phoneNo
                                                  .replaceAll(' ', ''));
                                      });
                                    } else {
                                      Navigator.of(context)
                                        ..pop()
                                        ..pop()
                                        ..pushReplacementNamed(
                                            AppRoutes.setPinRoute,
                                            arguments: SetPinRouteArgs(
                                                '', false, false, true));
                                    }
                                  } else {
                                    Navigator.of(context)
                                      ..pop()
                                      ..pop()
                                      ..pushReplacementNamed(
                                          AppRoutes.pinLoginRoute,
                                          arguments: PinRouteArgs(
                                              widget.phoneNo
                                                  .replaceAll(' ', ''),
                                              true));
                                  }
                                }
                              } else {
                                //  await analytics.logSignUp(signUpMethod: 'SignUp');
                                /*    var anaylticsEvents = await AnalyticsEvents(context);
                            anaylticsEvents.signUpEvent(withReferral);*/

                                Navigator.of(context)
                                  ..pop()
                                  ..pop()
                                  ..pushReplacementNamed(AppRoutes.signupRoute,
                                      arguments:
                                          widget.phoneNo.replaceAll(' ', ''));
                              }
                            
                      } else {
                        Navigator.of(context)
                          ..pop()
                          ..pop()
                          ..pushReplacementNamed(AppRoutes.signupRoute,
                              arguments:
                              widget.phoneNo.replaceAll(' ', ''));
                      }
                    }
                  }
                      : () {},

                ),
              ),
              (screenWidth(context) * 0.035).widthBox,
            ],
          ),
        ),
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Image.asset(AppAssets.backButtonIcon,
                        width: MediaQuery.of(context).size.width * 0.9))),
            title: Container(
                // margin: EdgeInsets.symmetric(vertical: 500),
                child: Image.asset(AppAssets.landscapeLogo,
                    width: MediaQuery.of(context).size.width * 0.4)),
            centerTitle: true),
        body: Center(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex:1,
                      child: Column(children: [
                   
                    Text(
                      'Verify Mobile Number',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.purpleActive),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Text(
                      'We have sent a 6-Digit OTP to\n${widget.phoneNo}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.brownishGrey),
                    ),
                    
                  ])),
                  // Flexible(
                  //   flex: 2,
                  //   child: Stack(children: [
                  //     Container(
                  //         margin: EdgeInsets.symmetric(
                  //             horizontal:
                  //                 MediaQuery.of(context).size.width * 0.2),
                  //         child: Image.asset(AppAssets.otpArtImage)),
                  //   ]),
                  // ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  // (deviceHeight * 0.03).heightBox,
                  Text(
                    'Sit back and relax while we try to read\nthe OTP from your device.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.brownishGrey),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 7.0, vertical: 15.0),
                          child: otpTextField(
                            controller: oneController,
                            onSaved: (value) => _digit1 = value,
                            focusNode: firstFocusNode,
                            nextFocusNode: secondFocusNode,
                          ),
                        ).flexible,
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 7.0, vertical: 15.0),
                          child: otpTextField(
                            controller: twoController,
                            onSaved: (value) => _digit2 = value,
                            focusNode: secondFocusNode,
                            nextFocusNode: thirdFocusNode,
                            previousFocusNode: firstFocusNode,
                          ),
                        ).flexible,
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 7.0, vertical: 15.0),
                          child: otpTextField(
                            controller: threeController,
                            onSaved: (value) => _digit3 = value,
                            focusNode: thirdFocusNode,
                            nextFocusNode: fourthFocusNode,
                            previousFocusNode: secondFocusNode,
                          ),
                        ).flexible,
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 7.0, vertical: 15.0),
                          child: otpTextField(
                            controller: fourController,
                            onSaved: (value) => _digit4 = value,
                            focusNode: fourthFocusNode,
                            nextFocusNode: fifthFocusNode,
                            previousFocusNode: thirdFocusNode,
                          ),
                        ).flexible,
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 7.0, vertical: 15.0),
                          child: otpTextField(
                              controller: fiveController,
                              onSaved: (value) => _digit5 = value,
                              focusNode: fifthFocusNode,
                              nextFocusNode: sixthFocusNode,
                              previousFocusNode: fourthFocusNode),
                        ).flexible,
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 7.0, vertical: 15.0),
                          child: otpTextField(
                            controller: sixController,
                            focusNode: sixthFocusNode,
                            nextFocusNode: sixthFocusNode,
                            previousFocusNode: fifthFocusNode,
                            onSaved: (value) => _digit6 = value,
                          ),
                        ).flexible,
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 15.0),
                    child: Row(
                      children: [
                        InkWell(
                          child: CustomText(
                            isResendOtpClickable
                                ? 'RESEND OTP'
                                : 'RESEND CODE IN ',
                            size: (18),
                            color: isResendOtpClickable
                                ? AppTheme.redColor
                                : AppTheme.brownishGrey,
                            bold: FontWeight.w800,
                          ),
                          onTap:isResendOtpClickable? (){
                            clearTextControllers();
                            setState(() {
                              isResendOtpClickable = false;
                              _resendOtpCount = 30;
                            });
                            //startTimer();

                            if(mounted) {
                              _controller.forward();
                            }
                          }:(){},
                        ),
                        if(!isResendOtpClickable)
                          Countdown(
                            animation: StepTween(
                              begin: 30,
                              end: 0,
                            ).animate(_controller)..addStatusListener((status) {
                              if(status == AnimationStatus.completed){
                                _controller.reset();
                                setState(() {
                                  isResendOtpClickable = true;
                                });
                              }
                            }),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }

  Widget otpTextField(
      {required FocusNode focusNode,
        required void Function(String?) onSaved,
        FocusNode? nextFocusNode,
        FocusNode? previousFocusNode,
        required TextEditingController controller}) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        // border: Border(
        //   bottom: BorderSide(width: 3.0, color: AppTheme.coolGrey),
        // ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
          // border: Border.all(
          //   color: AppTheme.coolGrey,
          //   width: 0.5
          // ),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white),
      child: Align(
        alignment: Alignment.center,
        child: TextFormField(
          controller: controller,
          enableInteractiveSelection: false,
          textAlign: TextAlign.center,
          focusNode: focusNode,
          onSaved: onSaved,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value!.isEmpty || value.isValidOneDigitNumber == false) {
              return ' ';
            } else {
              return null;
            }
          },
          onChanged: nextFocusNode == null
              ? null
              : (value) {
            if (value.length > 0 && value != "") {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).requestFocus(previousFocusNode);
            }
            if(validate()){
              FocusScope.of(context).requestFocus(FocusNode());
            }
          },
          keyboardType: TextInputType.phone,
          // obscureText: true,
          maxLength: 1,
          cursorColor: AppTheme.coolGrey,
          cursorHeight: 50,
          style: TextStyle(
              color: AppTheme.blackColor,
              fontSize: 40,
              fontFamily: "Hind",
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            counterText: '',
            // hintText: '_',
            // hintStyle: TextStyle(color: AppTheme.coolGrey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }

  bool validate() {
    if (oneController.text.trim().isEmpty) {
      return false;
    } else if (twoController.text.trim().isEmpty) {
      return false;
    } else if (threeController.text.trim().isEmpty) {
      return false;
    } else if (fourController.text.trim().isEmpty) {
      return false;
    } else if (fiveController.text.trim().isEmpty) {
      return false;
    } else if (sixController.text.trim().isEmpty) {
      return false;
    } else {
      return true;
    }
  }


  //********************************************************************************* */
  // BUSINESS LOGIC
  //********************************************************************************* */

  // String _verificationID;
  // final _auth = FirebaseAuth.instance;

  void clearTextControllers() {
    oneController.clear();
    twoController.clear();
    threeController.clear();
    fourController.clear();
    fiveController.clear();
    sixController.clear();
  }




/* Future<void> _sendVerificationCode(String phone) async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
            setState(() {
              oneController.text = credential.smsCode.substring(0, 1);
              twoController.text = credential.smsCode.substring(1, 2);
              threeController.text = credential.smsCode.substring(2, 3);
              fourController.text = credential.smsCode.substring(3, 4);
              fiveController.text = credential.smsCode.substring(4, 5);
              sixController.text = credential.smsCode.substring(5, 6);
            });
            // debugPrint(_otp);
            final user =
                await _auth.signInWithCredential(credential).catchError((e) {
              debugPrint(e.toString());
              return null;
            });
            if (user != null) {
              final userStatus = await checkUserAvailability().catchError((e) {
                scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: CustomText(e),
                ));
                return null;
              });
              if (!userStatus) {
                Navigator.of(context)
                  ..pop()
                  ..pop()
                  ..pushReplacementNamed(AppRoutes.signupRoute,
                      arguments: phone);
              } else {
                LoginRepository().login(phone);
                repository.hiveQueries.insertIsAuthenticated(true);
                Navigator.of(context)
                  ..pop()
                  ..pop()
                  ..pushReplacementNamed(repository.hiveQueries.userPin == null
                      ? AppRoutes.setPinRoute
                      : AppRoutes.pinLoginRoute);
              }
            } else {
              scaffoldKey?.currentState?.showSnackBar(SnackBar(
                content: Text("Authentication Failed"),
              ));
            }
          },
          verificationFailed: (FirebaseAuthException exception) {
            debugPrint(exception.code);
            debugPrint(exception.message);
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text(exception.message),
            ));
          },
          forceResendingToken: 1,
          codeSent: (String verificationId, [int forceResendingToken]) async {
            // Update the UI - wait for the user to enter the SMS code
            _verificationID = verificationId;

            // // Create a PhoneAuthCredential with the code
            // PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
            //     verificationId: verificationId, smsCode: _otp);
            // // Sign the user in (or link) with the credential
            // await auth.signInWithCredential(phoneAuthCredential);
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> _signInWithPhoneNumber(String smsCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationID,
        smsCode: smsCode,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      if (user.uid != null)
        return true;
      else
        return false;
    } catch (e, s) {
      debugPrint(e);
      debugPrint(s);
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
              e.toString().contains('[firebase_auth/invalid-verification-code]')
                  ? 'The OTP you\'ve entered is incorrect'
                  : e.toString().split('] ').last),
        ),
      );
      return false;
    }
  } */

/* Future<bool> checkUserAvailability() async {
    final response = await Repository()
        .registerApi
        .checkUserAvailability(widget.phoneNo.replaceAll(' ', ''));
    return response;
  } */
}

class Countdown extends AnimatedWidget {
  Countdown({Key? key, this.animation}) : super(key: key, listenable: animation!);
  Animation<int>? animation;


  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation!.value);

    String timerText =
        '0${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')} secs';

    /*return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 110,
        color: AppTheme.electricBlue,
      ),
    );*/

    return CustomText(
      '${timerText}',
      size: (18),
      color: AppTheme.redColor,
      bold: FontWeight.w800,
    );
  }
}
