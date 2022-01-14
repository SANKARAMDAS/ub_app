import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urbanledger/Models/business_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Models/user_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/chat_module/data/repositories/login_repository.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/text_formatter.dart';
import 'package:urbanledger/screens/UserProfile/inappbrowser.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import 'package:uuid/uuid.dart';

import '../Components/extensions.dart';

class SignUpScreen extends StatefulWidget {
  final String mobile;

  const SignUpScreen({Key? key, required this.mobile}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  String? firstNameError;
  String? lastNameError;
  String? emailError;
  bool isLoading = false;
  bool isReferralEditable = true;
  String? referralShowText;
  final double profileImage = 100;

  @override
  void initState() {
    // getReferalCode();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
  }

  getReferalCode() {
    debugPrint('checking re: ' +
        Repository().hiveQueries.dynamicReferralCode.toString());
    setState(() {
      if (Repository().hiveQueries.dynamicReferralCode.toString().isNotEmpty) {
        _referralController.text =
            Repository().hiveQueries.dynamicReferralCode.toString();

        isReferralEditable = false;
      }
    });
  }

  makeReferalEditable() {
    setState(() {
      isReferralEditable = true;
    });
  }

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
          bottomSheet: Container(
            color: AppTheme.whiteColor,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Center(
                child: Text(
                  'By clicking the register button, you agree to our Terms and Conditions',
                  style: TextStyle(
                    color: AppTheme.greyish,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 15),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 15),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      firstNameError = validateFirstName(
                                          _firstNameController.text);
                                      lastNameError = validateLastName(
                                          _lastNameController.text);
                                      emailError =
                                          validateEmail(_emailController.text);
                                      debugPrint("statement");
                                    });
                                    Login() async {
                                      firstNameError = validateFirstName(
                                          _firstNameController.text);
                                      lastNameError = validateLastName(
                                          _lastNameController.text);
                                      emailError =
                                          validateEmail(_emailController.text);
                                      debugPrint("statement");
                                      if (firstNameError == null &&
                                          lastNameError == null &&
                                          emailError == null) {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        final response = await (Repository()
                                            .userProfileAPI
                                            .userProfileApi(
                                                SignUpModel(
                                                  firstName:
                                                      _firstNameController.text,
                                                  lastName:
                                                      _lastNameController.text,
                                                  mobileNo: widget.mobile
                                                      .replaceAll('+', ''),
                                                  email: _emailController.text,
                                                  referral_code: repository
                                                      .hiveQueries
                                                      .SignUpUserReferralCode,
                                                  referral_link: repository
                                                      .hiveQueries
                                                      .SignUpUserReferralLink,
                                                  paymentLink: repository
                                                      .hiveQueries
                                                      .SignUpPaymentLink
                                                      .toString(),
                                                ),
                                                context)
                                            .timeout(Duration(seconds: 30),
                                                onTimeout: () async {
                                          Navigator.of(context).pop();
                                          return Future.value(null);
                                        }).catchError((e) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          debugPrint(e.toString());
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //   content: CustomText(
                                          //       'Please check internet connectivity and try again.'),
                                          // ));
                                          'Please check internet connectivity and try again.'
                                              .showSnackBar(context);
                                          return false;
                                        }));

                                        if (response) {
                                          /*  final registerResponse =
                                      await RegisterRepository().register(
                                          _firstNameController.text +
                                              ' ' +
                                              _lastNameController.text,
                                          _emailController.text); */
                                          var anaylticsEvents =
                                              AnalyticsEvents(context);

                                          if (_referralController
                                              .text.isNotEmpty) {
                                            // final response = await (Repository()
                                            //     .userProfileAPI
                                            //     .sendDynamicReferralCode(
                                            //         _referralController.text
                                            //             .toString())
                                            //     .timeout(Duration(seconds: 30),
                                            //         onTimeout: () async {
                                            //   Navigator.of(context).pop();
                                            //   return false;
                                            // }).catchError((e) {
                                            //   setState(() {
                                            //     isLoading = false;
                                            //   });
                                            //   debugPrint(e.toString());
                                            //   ScaffoldMessenger.of(context)
                                            //       .showSnackBar(SnackBar(
                                            //     content: CustomText(
                                            //         'Please check internet connectivity and try again.'),
                                            //   ));
                                            //   return false;
                                            // }));
                                            await anaylticsEvents
                                                .signUpEvent(true);
                                            debugPrint(
                                                'Checking Referral Hit: ' +
                                                    response.toString());
                                          }
                                          await anaylticsEvents
                                              .signUpEvent(false);
                                          LoginRepository()
                                              .login(widget.mobile, context);
                                          repository.hiveQueries
                                              .insertIsAuthenticated(true);
                                          repository.hiveQueries
                                              .insertUserData(SignUpModel(
                                            id: '',
                                            firstName:
                                                _firstNameController.text,
                                            lastName: _lastNameController.text,
                                            mobileNo: widget.mobile,
                                            email: _emailController.text,
                                            paymentLink: repository
                                                .hiveQueries.SignUpPaymentLink
                                                .toString(),
                                            referral_code: repository
                                                .hiveQueries
                                                .SignUpUserReferralCode,
                                            referral_link: repository
                                                .hiveQueries
                                                .SignUpUserReferralLink,
                                          ));
                                          final businesssModel = BusinessModel(
                                              businessId: Uuid().v1(),
                                              businessName: 'PERSONAL',
                                              isChanged: true,
                                              isDeleted: false,
                                              deleteAction: false);
                                          await repository.queries
                                              .insertBusiness(businesssModel);
                                          if (await checkConnectivity) {
                                            final apiResponse =
                                                await (repository.businessApi
                                                    .saveBusiness(
                                                        businesssModel,
                                                        context,
                                                        false)
                                                    .catchError((e) {
                                           
                                              setState(() {
                                                isLoading = false;
                                              });
                                               'Please check your internet connection or try again later.'
                                                .showSnackBar(context);
                                            }));
                                            if (apiResponse) {
                                              await repository.queries
                                                  .updateBusinessIsChanged(
                                                      businesssModel, 0);
                                            }
                                          } else {
                                            Navigator.of(context).pop();
                                            'Please check your internet connection or try again later.'
                                                .showSnackBar(context);
                                          }
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Future.delayed(Duration(seconds: 1))
                                              .then((value) {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                              AppRoutes.setPinRoute,
                                              arguments: SetPinRouteArgs(
                                                  '', false, false, true),
                                            );
                                          });

                                          // Navigator.of(context)
                                          //     .pushReplacementNamed(
                                          //         AppRoutes.welcomeuserRoute,
                                          //         arguments: _firstNameController
                                          //                 .text +
                                          //             ' ' +
                                          //             _lastNameController.text);
                                        }
                                      } else {
                                        setState(() {});
                                      }
                                    }

                                    if (_referralController.text.isNotEmpty &&
                                        _referralController.text.length < 8) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      'Invalid referral code. Please check the referral code and try again.'
                                          .showSnackBar(context);
                                    } else if (firstNameError == null &&
                                        lastNameError == null &&
                                        emailError == null &&
                                        _referralController.text.isNotEmpty &&
                                        _referralController.text.length == 8) {
                                      bool? response1 = await (Repository()
                                          .userProfileAPI
                                          .sendDynamicReferralCode(
                                              _referralController.text
                                                  .toString()));
                                      if (response1 == true) {
                                        'Referral applied successfully'
                                            .showSnackBar(context);

                                        if (firstNameError == null &&
                                            lastNameError == null &&
                                            emailError == null) {
                                          debugPrint('Go for Login');
                                          await Login();
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          // 'Please Check the input fields'
                                          //     .showSnackBar(context);
                                        }
                                        setState(() {
                                          isLoading = false;
                                        });
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        'Invalid referral code. Please check the referral code and try again.'
                                            .showSnackBar(context);
                                      }
                                    } else {
                                      setState(() {});
                                      debugPrint('Go for Login');
                                      if (firstNameError == null &&
                                          lastNameError == null &&
                                          _referralController.text.isEmpty &&
                                          emailError == null) {
                                        await Login();
                                      }
                                      // else{
                                      //     'Invalid referral code. Please check the referral code and try again.'
                                      //     .showSnackBar(context);
                                      // }

                                    }
                                  },
                            child: isLoading
                                ? CircularProgressIndicator()
                                : CustomText(
                                    'REGISTER',
                                    color: Colors.white,
                                    size: (18),
                                    bold: FontWeight.w500,
                                  ),
                          ),
                        ),
            ]),
          ),
          body: Container(
            child: Column(
              children: [
                Stack(children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                                color: AppTheme.whiteColor,
                                fontSize: 40,
                                height: 1,
                                fontFamily: 'Hind'),
                          ),
                          TextSpan(
                            text: '\n${widget.mobile}',
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
                  ),
                  Container(
                    margin: EdgeInsets.only(top: coverHeight),
                    height:
                        MediaQuery.of(context).size.height - coverHeight - 84,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                  ),
                  Positioned(
                      top: top,
                      left: MediaQuery.of(context).size.width * 0.38,
                      right: MediaQuery.of(context).size.width * 0.38,
                      child: Container(
                        width: profileImage,
                        height: profileImage,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(color: AppTheme.coolGrey, width: 1),
                          color: AppTheme.whiteColor,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.black54.withOpacity(0.2),
                                blurRadius: 5.0,
                                offset: Offset(2, 3))
                          ],
                        ),
                        child: Image.asset(AppAssets.userIcon1),
                      )),
                ])
              ],
            ),
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

  String? validateEmail(value) {
    if (value!.isEmpty) return 'Please enter your Email ID';

    // if (value.length > 30) return Constants.enterValidEmail;
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = new RegExp(pattern as String);

    if (!regex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? validateFirstName(value) {
    if (value!.isEmpty) return 'Please enter your First Name';

    if (value.length < 3 || value.length > 15) {
      return 'First Name must be between 3 to 15 characters long';
    }

    // if (value.length > 20) {
    //   return Constants.enterValidName;
    // }

    Pattern pattern = r'^[a-zA-Z\. ]+$';

    RegExp regex = new RegExp(pattern as String);

    if (!regex.hasMatch(value)) {
      return 'Enter valid First Name';
    }
    return null;
  }

  String? validateLastName(value) {
    if (value!.isEmpty) return 'Please enter your Last Name';

    if (value.length < 3 || value.length > 15) {
      return 'Last Name must be between 3 to 15 characters long';
    }

    // if (value.length > 20) {
    //   return Constants.enterValidName;
    // }

    Pattern pattern = r'^[a-zA-Z\. ]+$';

    RegExp regex = new RegExp(pattern as String);

    if (!regex.hasMatch(value)) {
      return 'Enter valid Last Name';
    }

    return null;
  }
}

class SignUpTextField extends StatelessWidget {
  const SignUpTextField({
    Key? key,
    required GlobalKey<FormState> formKey,
    required this.hintText,
    required this.keyboardType,
    required this.controller,
    required this.validator,
    required this.onChanged,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String? p1) validator;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: keyboardType == TextInputType.emailAddress
          ? TextCapitalization.none
          : TextCapitalization.words,
      style: TextStyle(
          color: AppTheme.brownishGrey,
          fontSize: (16),
          fontWeight: FontWeight.w500),
      onChanged: onChanged,
      cursorColor: AppTheme.brownishGrey,
      maxLength: keyboardType == TextInputType.emailAddress ? 30 : 20,
      inputFormatters: [
        ModifiedLengthLimitingTextInputFormatter(
            keyboardType == TextInputType.emailAddress ? 30 : 20),
      ],
      // buildCounter: counter(),
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.only(left: 15, bottom: 5, top: 20),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Color(0xff1058ff),
          )),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Color(0xff1058ff),
          )),
          suffixIconConstraints: BoxConstraints.tight(Size(25, 25)),
          suffixIcon: controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    controller.clear();
                    onChanged!('');
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                    child: Icon(
                      Icons.clear,
                      size: (22),
                      color: AppTheme.greyish,
                    ),
                  ),
                )
              : null,
          hintText: hintText,
          counterText: '',
          hintStyle: TextStyle(
            color: Color(0xffb6b6b6),
            fontSize: (16),
          ),
          errorStyle:
              TextStyle(color: AppTheme.tomato, fontWeight: FontWeight.w500)),
    );
  }
}
