import 'package:flutter/gestures.dart';
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
import 'package:urbanledger/Utility/uppercase_text_formatter.dart';
import 'package:urbanledger/chat_module/data/repositories/login_repository.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/text_formatter.dart';
import 'package:urbanledger/screens/UserProfile/inappbrowser.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../Components/extensions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, required this.mobile}) : super(key: key);

  final String mobile;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? emailError;
  String? firstNameError;
  bool isLoading = false;
  bool isReferralEditable = true;
  String? lastNameError;
  static const double profileImage = 100.0;
  String? referralShowText;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
  }

  @override
  void initState() {
    // getReferalCode();
    super.initState();
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

  String cleanUpExtraWhiteSpace(String input){
    final _whitespaceRE = RegExp(r"(?! )\s+| \s+");
   return input.split(_whitespaceRE).join(" ");

  }

  bool validate() {
    Pattern pattern = r'^[a-zA-Z\. ]+$';
    RegExp regex = new RegExp(pattern as String);
    Pattern pattern2 =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex2 = new RegExp(pattern2 as String);
    if (_firstNameController.text.trim().isEmpty) {
      debugPrint('1');
      return false;
    } else if (_firstNameController.text.trim().length < 3 ||
        _firstNameController.text.trim().length > 15) {
      debugPrint('2');
      return false;
    } else if (!regex.hasMatch(_firstNameController.text.trim())) {
      debugPrint('3');
      return false;
    } else if (_lastNameController.text.trim().isEmpty) {
      debugPrint('4');
      return false;
    } else if (_lastNameController.text.trim().length < 3 ||
        _lastNameController.text.trim().length > 15) {
      debugPrint('5');
      return false;
    } else if (!regex.hasMatch(_lastNameController.text.trim())) {
      debugPrint('6');
      return false;
    } else if (_emailController.text.trim().isEmpty) {
      debugPrint('7');
      return false;
    } else if (!regex2.hasMatch(_emailController.text.trim())) {
      debugPrint('9');
      return false;
    } else {
      debugPrint('GGGGGGGGGG');
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Form(
            key: _formKey,
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Image.asset(AppAssets.backgroundImage),
                    height: 200,
                  ),
                  CustomText(
                    'Sign Up',
                    size: (25),
                    color: AppTheme.brownishGrey,
                    bold: FontWeight.bold,
                  ),
                  const SizedBox(height: 5),
                  const Text('Please provide a few details about yourself.',
                      style: TextStyle(
                        color: AppTheme.greyish,
                        fontSize: (15),
                      )),
                  const SizedBox(height: 10),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 4.0),
                          child: Focus(
                          onFocusChange: (focused){
                            if(!focused){
                              var resultText = '';
                              List<String> text = _firstNameController.text.split(' ');
                              List<String> capitalizeList =   text.map((e){
                                return e.capitalizeFirstCharacter();
                              }).toList();
                              resultText = capitalizeList.join(" ");
                              print('lastname : '+resultText);

                              _firstNameController.text = resultText;
                            }

                          },
                          child: SignUpTextField(
                              formKey: _formKey,
                              // prefixIcon: AppAssets.userIcon1,
                              onChanged: (value) {
                                debugPrint('QQQ1');
                                validate();
                                debugPrint('QQQ2'+validate().toString());
                                if (value.length == 0) {
                                  setState(() {
                                    firstNameError = null;
                                  });
                                  return;
                                }


                                firstNameError = validateFirstName(value);
                                setState(() {});
                              },
                              validator: (value) {
                                return validateFirstName(value);
                              },
                              controller: _firstNameController,
                              keyboardType: TextInputType.name,
                              hintText: 'First Name'),
                        ),
                        ),
                        if (firstNameError != null)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: CustomText(
                              firstNameError ?? '',
                              color: AppTheme.tomato,
                              bold: FontWeight.w500,
                              size: 12,
                            ),
                          ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 4.0),
                          child: Focus(
                          onFocusChange: (focused){
                            if(!focused){
                              var resultText = '';
                              List<String> text = _lastNameController.text.split(' ');
                            List<String> capitalizeList =   text.map((e){
                                return e.capitalizeFirstCharacter();
                              }).toList();
                              resultText = capitalizeList.join(" ");
                              print('lastname : '+resultText);

                              _lastNameController.text = resultText;
                            }
                          },
                          child: SignUpTextField(
                              // prefixIcon: AppAssets.userIcon1,
                              formKey: _formKey,
                              onChanged: (value) {
                                validate();
                                if (value.length == 0) {
                                  setState(() {
                                    lastNameError = null;

                                  });
                                  return;
                                }
                                lastNameError = validateLastName(value);
                                setState(() {});
                              },
                              validator: (value) {
                                return validateLastName(value);
                              },
                              controller: _lastNameController,
                              keyboardType: TextInputType.name,
                              hintText: 'Last Name'),
                        ),
                        ),
                        if (lastNameError != null)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: CustomText(
                              lastNameError ?? '',
                              color: AppTheme.tomato,
                              bold: FontWeight.w500,
                              size: 12,
                            ),
                          ),
                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 4.0),
                          child: SignUpTextField(
                              formKey: _formKey,
                              onChanged: (value) {
                                if (value.length == 0) {
                                  setState(() {
                                    emailError = null;
                                  });
                                  return;
                                }
                                emailError = validateEmail(value);
                                setState(() {});
                              },
                              validator: (value) {
                                return validateEmail(value);
                              },
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'Email ID'),
                        ),
                        if (emailError != null)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: CustomText(
                              emailError ?? '',
                              color: AppTheme.tomato,
                              bold: FontWeight.w500,
                              size: 12,
                            ),
                          ),
                        SizedBox(height: 95).flexible,
                        Spacer(),
                        /* Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 15),
                          child: Center(
                            child: Column(
                              children: [
                                Image.asset(
                                  AppAssets.ref8Icon,
                                  width: 70,
                                ),
                                Text(
                                  'Referral program is applicable for new users',
                                  style: TextStyle(
                                    color: AppTheme.brownishGrey,
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(height: 8,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      child: Container(
                                          alignment: Alignment.center,


                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                            border: Border.all(
                                                width: 0.5,
                                                color: AppTheme.coolGrey),
                                            color: Colors.white,
                                          ),
                                          child: Container(
                                            width:
                                            MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.45,//added line
                                            // padding: EdgeInsets.only(left: 15),
                                            height: MediaQuery.of(context)
                                                .size
                                                .height *
                                                0.05 ,


                                            // padding:
                                            //     EdgeInsets.symmetric(
                                            //   horizontal: 3,
                                            // ),
                                            child: (!isReferralEditable)
                                                ? Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .all(
                                                        8.0),
                                                    child: Image
                                                        .asset(
                                                      AppAssets
                                                          .transactionSuccess,
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8,),
                                                  Text(_referralController.text,style: TextStyle(
                                                    color: AppTheme
                                                        .electricBlue,
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                  )),
                                                  SizedBox(width: 8,),
                                                  InkWell(
                                                    onTap:
                                                        () async {
                                                      makeReferalEditable();

                                                      _referralController
                                                          .clear();
                                                      'Referral Code Removed'
                                                          .showSnackBar(
                                                          context);



                                                    },
                                                    child:
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          8.0),
                                                      child: Image
                                                          .asset(
                                                        AppAssets
                                                            .delete1Icon,
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                    ),
                                                  )



                                                ],
                                              ),
                                            )
                                                :  Center(
                                              child: TextField(
                                                textCapitalization:
                                                TextCapitalization
                                                    .characters,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      8),
                                                  UpperCaseTextFormatter()
                                                ],
                                                controller:
                                                _referralController,
                                                // textCapitalization: TextCapitalization.characters,
                                                textAlign:
                                                TextAlign
                                                    .center,
                                                decoration:
                                                InputDecoration(
                                                  fillColor: AppTheme
                                                      .electricBlue,
                                                  hintText:
                                                  "Enter referral code",
                                                  hintStyle:
                                                  TextStyle(
                                                    color: AppTheme
                                                        .greyish,
                                                    fontSize: 16,
                                                  ),
                                                  // suffix: InkWell(
                                                  //   onTap: () async {
                                                  //     _referralController
                                                  //         .clear();
                                                  //   },
                                                  //   child: Image.asset(
                                                  //     AppAssets
                                                  //         .delete1Icon,
                                                  //     height: 20,
                                                  //     width: 20,
                                                  //   ),
                                                  // ),
                                                  border:
                                                  InputBorder
                                                      .none,
                                                  isDense: true,// this will remove the default content padding
                                                  // now you can customize it here or add padding widget
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                ),
                                                keyboardType:
                                                TextInputType
                                                    .text,
                                                onChanged: (value){
                                                  if(value.length==8){
                                                    setState(() {
                                                      isReferralEditable= false;
                                                    });
                                                  }


                                                },
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),*/
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 10),
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
                                          // final businesssModel = BusinessModel(
                                          //     businessId: Uuid().v1(),
                                          //     businessName: 'PERSONAL',
                                          //     isChanged: true,
                                          //     isDeleted: false,
                                          //     deleteAction: false);
                                          // await repository.queries
                                          //     .insertBusiness(businesssModel);
                                          // if (await checkConnectivity) {
                                          //   final apiResponse =
                                          //       await (repository.businessApi
                                          //           .saveBusiness(
                                          //               businesssModel,
                                          //               context,
                                          //               false)
                                          //           .catchError((e) {
                                           
                                          //     setState(() {
                                          //       isLoading = false;
                                          //     });
                                          //      'Please check your internet connection or try again later.'
                                          //       .showSnackBar(context);
                                          //   }));
                                          //   if (apiResponse) {
                                          //     await repository.queries
                                          //         .updateBusinessIsChanged(
                                          //             businesssModel, 0);
                                          //   }
                                          // } else {
                                          //   Navigator.of(context).pop();
                                          //   'Please check your internet connection or try again later.'
                                          //       .showSnackBar(context);
                                          // }
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
                                ? CircularProgressIndicator(color: AppTheme.electricBlue,)
                                : CustomText(
                                    'REGISTER',
                                    color: Colors.white,
                                    size: (18),
                                    bold: FontWeight.w500,
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UlAppBrowser(
                                  url:
                                      'https://urbanledger.app/terms-and-conditions',
                                  title: 'Terms & Conditions',
                                ),
                              ),
                            );
                          },
                          child: Center(
                            child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text:
                                        'By clicking the register button,\n you agree to our ',
                                    style: TextStyle(
                                      color: AppTheme.greyish,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Terms and Conditions',
                                    style: TextStyle(
                                      color: AppTheme.electricBlue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  )
                                ])),
                          ),
                        )
                        // Center(
                        //   child: CustomText(
                        //       'By clicking the register button,\n you agree to our Terms and Conditions',
                        //       centerAlign: true,
                        //       color: AppTheme.greyish,
                        //       bold: FontWeight.w500,
                        //       size: (15)),
                        // ),
                      ],
                    ),
                  ),

                  // Flexible(child: (deviceHeight * 0.05).heightBox)
                ]),
          ),
        ),
      ),
    );
  }

  Widget get topProfile => SizedBox(
        width: profileImage,
        height: profileImage,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(color: AppTheme.coolGrey, width: 1),
            color: AppTheme.whiteColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black54.withOpacity(0.1),
                  blurRadius: 7.0,
                  spreadRadius: 5.0,
                  offset: Offset(-3, 3))
            ],
          ),
          child: Image.asset(AppAssets.userIcon1),
        ),
      );

  Widget get topContainer => Container(
        // margin: EdgeInsets.only(top: 30),
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
      );
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
            color: AppTheme.electricBlue,
          )),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: AppTheme.electricBlue,
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