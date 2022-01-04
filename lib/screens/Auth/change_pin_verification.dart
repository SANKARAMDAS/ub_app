import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';

class ChangePinVerification extends StatefulWidget {
  final String token;
  final bool fromSettings;
  ChangePinVerification(
      {Key? key, required this.token, required this.fromSettings})
      : super(key: key);
  @override
  _ChangePinVerificationState createState() => _ChangePinVerificationState();
}

class _ChangePinVerificationState extends State<ChangePinVerification> {
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

  TextEditingController _pinController = TextEditingController();
  // final repository = Repository();
  final GlobalKey<State> key = GlobalKey<State>();
  bool isResendOtpClickable = true;
  int _resendOtpCount = 30;
  late bool _serviceEnabled;
  late AnimationController _controller;
  // final location = Location();
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
    super.dispose();
  }

  //final status = await repository.changePinApi

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              (screenWidth(context) * 0.01).widthBox,
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.only(
                        bottom: 15, top: 15, left: 30, right: 30),
                    primary: Theme.of(context).primaryColor,
                  ),
                  child: CustomText(
                    'SUBMIT',
                    size: 18,
                    color: Colors.white,
                  ),
                  onPressed: validate() == true
                      ? () async {
                          final status = await repository.changePinApi
                              .verifyChangePin(
                            widget.token,
                            _digit1! + _digit2! + _digit3! + _digit4!,
                          )
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
                            Navigator.of(context).pop();
                            return false;

                            // _pinController.clear();
                          });
                          if (status) {
                            repository.hiveQueries.insertUserPin('');
                            Navigator.of(context)
                              ..pop()
                              ..pop()
                              ..pushNamed(
                                  widget.fromSettings
                                      ? AppRoutes.setNewPinRoute
                                      : AppRoutes.setPinRoute,
                                  arguments:
                                      SetPinRouteArgs('', false, true, false));
                          } //else {
                          //   Navigator.pop(context);
                          //}
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      AppAssets.backgroundImage,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  (deviceHeight * 0.09).heightBox,
                  ULLogoWidget(
                    height: 80,
                  ),
                  (deviceHeight * 0.09).heightBox,
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'We have sent a 6-digit OTP\nto ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppTheme.coolGrey,
                            fontSize: (15),
                          ),
                          children: [
                            TextSpan(
                              text: 'Code Sent to +' +
                                  repository.hiveQueries.userData.mobileNo,
                            ),
                          ]),
                    ),
                  ),
                  (deviceHeight * 0.04).heightBox,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
                          child: otpTextField(
                            controller: oneController,
                            onSaved: (value) => _digit1 = value,
                            focusNode: firstFocusNode,
                            nextFocusNode: secondFocusNode,
                          ),
                        ).flexible,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
                          child: otpTextField(
                            controller: twoController,
                            onSaved: (value) => _digit2 = value,
                            focusNode: secondFocusNode,
                            nextFocusNode: thirdFocusNode,
                            previousFocusNode: firstFocusNode,
                          ),
                        ).flexible,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
                          child: otpTextField(
                            controller: threeController,
                            onSaved: (value) => _digit3 = value,
                            focusNode: thirdFocusNode,
                            nextFocusNode: fourthFocusNode,
                            previousFocusNode: secondFocusNode,
                          ),
                        ).flexible,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
                          child: otpTextField(
                            controller: fourController,
                            onSaved: (value) => _digit4 = value,
                            focusNode: fourthFocusNode,
                            nextFocusNode: fifthFocusNode,
                            previousFocusNode: thirdFocusNode,
                          ),
                        ).flexible,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
                          child: otpTextField(
                              controller: fiveController,
                              onSaved: (value) => _digit5 = value,
                              focusNode: fifthFocusNode,
                              nextFocusNode: sixthFocusNode,
                              previousFocusNode: fourthFocusNode),
                        ).flexible,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
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
                  (deviceHeight * 0.03).heightBox,
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 15.0),
                    child: Row(
                      children: [
                        InkWell(
                          child: CustomText(
                            isResendOtpClickable
                                ? 'RESEND CODE'
                                : 'RESEND CODE IN ',
                            size: (18),
                            color: isResendOtpClickable
                                ? AppTheme.electricBlue
                                : Colors.grey,
                            bold: FontWeight.w800,
                          ),
                          onTap: isResendOtpClickable
                              ? () {
                                  clearTextControllers();
                                  setState(() {
                                    isResendOtpClickable = false;
                                    _resendOtpCount = 30;
                                  });
                                  //startTimer();

                                  _controller.forward();
                                }
                              : () {},
                        ),
                        if (!isResendOtpClickable)
                          Countdown(
                            animation: StepTween(
                              begin: 30,
                              end: 0,
                            ).animate(_controller)
                              ..addStatusListener((status) {
                                if (status == AnimationStatus.completed) {
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
                  (deviceHeight * 0.04).heightBox,
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
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
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
                  if (validate()) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                },
          keyboardType: TextInputType.phone,
          // obscureText: true,
          maxLength: 1,
          cursorColor: AppTheme.coolGrey,
          style: TextStyle(
              color: AppTheme.coolGrey,
              fontSize: 28,
              fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            counterText: '',
            hintText: '_',
            hintStyle: TextStyle(color: AppTheme.coolGrey),
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
}

class Countdown extends AnimatedWidget {
  Countdown({Key? key, this.animation})
      : super(key: key, listenable: animation!);
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
        color: Theme.of(context).primaryColor,
      ),
    );*/

    return CustomText(
      '${timerText}',
      size: (18),
      color: AppTheme.electricBlue,
      bold: FontWeight.w800,
    );
  }
}
