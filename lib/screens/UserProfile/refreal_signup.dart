import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urbanledger/Models/business_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Models/user_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/chat_module/data/repositories/login_repository.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:uuid/uuid.dart';

class RefSignUp extends StatefulWidget {
  // final String mobile;
  RefSignUp({
    Key? key,
  }) : super(key: key);

  @override
  _RefSignUpState createState() => _RefSignUpState();
}

class _RefSignUpState extends State<RefSignUp> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _trashController = TextEditingController();
  String? firstNameError;
  String? lastNameError;
  String? emailError;
  bool isLoading = false;
  String? referral = "Sankaram";

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _trashController.dispose();
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
            // key: _formKey,
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
                  height: MediaQuery.of(context).size.height * 0.708,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 4.0),
                        child: SignUpTextField(
                            formKey: _formKey,
                            onChanged: (value) {
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
                      if (firstNameError != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                        child: SignUpTextField(
                            formKey: _formKey,
                            onChanged: (value) {
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
                      if (lastNameError != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: CustomText(
                            emailError ?? '',
                            color: AppTheme.tomato,
                            bold: FontWeight.w500,
                            size: 12,
                          ),
                        ),
                      SizedBox(height: 110).flexible, //flexible.
                      Spacer(),
                      Container(
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
                                'Referral program is applicable for new user',
                                style: TextStyle(
                                  color: AppTheme.brownishGrey,
                                  fontSize: 18.0,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 10,
                                  left: 50,
                                  right: 50,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        // padding: EdgeInsets.only(left: 15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                              width: 0.5,
                                              color: AppTheme.coolGrey),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Image.asset(
                                            //   // widget.suspenseData.status == 0
                                            //   // ? AppAssets.transactionFailed :
                                            //   AppAssets.transactionSuccess,
                                            //   height: 15,
                                            // ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: TextField(
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Enter referral code",
                                                  hintStyle: TextStyle(
                                                    color: AppTheme.greyish,
                                                  ),
                                                  prefix: Image.asset(
                                                    AppAssets
                                                        .transactionSuccess,
                                                    height: 15,
                                                    width: 15,
                                                  ),
                                                  suffix: Image.asset(
                                                    AppAssets.delete1Icon,
                                                    height: 15,
                                                    width: 15,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                                // formKey: _formKey,
                                                onChanged: (value) {},
                                                // controller: _trashController.clear,

                                                keyboardType:
                                                    TextInputType.name,

                                                // child: Text(
                                                //   // widget.suspenseData.status == 0 ?
                                                //   referal.toString(),
                                                //   overflow: TextOverflow.ellipsis,
                                                //   style: TextStyle(
                                                //     color: AppTheme.brownishGrey,
                                                //     fontWeight: FontWeight.w500,
                                                //     fontSize: 14,
                                                //   ),
                                                // ),
                                                //:
                                              ),
                                            ),
                                            // SizedBox(width: 0),
                                            // GestureDetector(
                                            //   onTap: () async {
                                            //     setState(() {
                                            //       referal = "";
                                            //       'Referral Code Removed'
                                            //           .showSnackBar(context);
                                            //     });
                                            //   },
                                            //   child: Image.asset(
                                            //     AppAssets.delete1Icon,
                                            //     height: 15,
                                            //     width: 15,
                                            //   ),
                                            // ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 15),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppTheme.electricBlue,
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {},
                          //isLoading
                          // ? null
                          // : () async {
                          //     firstNameError = validateFirstName(
                          //         _firstNameController.text);
                          //     lastNameError = validateLastName(
                          //         _lastNameController.text);
                          //     emailError =
                          //         validateEmail(_emailController.text);
                          //     debugPrint("statement");
                          //     if (firstNameError == null &&
                          //         lastNameError == null &&
                          //         emailError == null) {
                          //       setState(() {
                          //         isLoading = true;
                          //       });
                          //       final response = await (Repository()
                          //           .userProfileAPI
                          //           .userProfileApi(SignUpModel(
                          //             firstName: _firstNameController.text,
                          //             lastName: _lastNameController.text,
                          //             mobileNo:
                          //                 widget.mobile.replaceAll('+', ''),
                          //             email: _emailController.text,
                          //           ))
                          //           .catchError((e) {
                          //         setState(() {
                          //           isLoading = false;
                          //         });
                          //         ScaffoldMessenger.of(context)
                          //             .showSnackBar(SnackBar(
                          //           content: CustomText(e.toString()),
                          //         ));
                          //         return false;
                          //       }));
                          //       if (response) {
                          //         /*  final registerResponse =
                          //         await RegisterRepository().register(
                          //             _firstNameController.text +
                          //                 ' ' +
                          //                 _lastNameController.text,
                          //             _emailController.text); */
                          //         LoginRepository().login(widget.mobile);
                          //         repository.hiveQueries
                          //             .insertIsAuthenticated(true);
                          //         repository.hiveQueries
                          //             .insertUserData(SignUpModel(
                          //           id: '',
                          //           firstName: _firstNameController.text,
                          //           lastName: _lastNameController.text,
                          //           mobileNo: widget.mobile,
                          //           email: _emailController.text,
                          //         ));
                          //         final businesssModel = BusinessModel(
                          //             businessId: Uuid().v1(),
                          //             businessName: 'PERSONAL',
                          //             isChanged: true,
                          //             isDeleted: false,
                          //             deleteAction: false);
                          //         await repository.queries
                          //             .insertBusiness(businesssModel);
                          //         if (await checkConnectivity) {
                          //           final apiResponse = await (repository
                          //               .businessApi
                          //               .saveBusiness(businesssModel)
                          //               .catchError((e) {
                          //             debugPrint(e);
                          //             setState(() {
                          //               isLoading = false;
                          //             });
                          //             recordError(e, StackTrace.current);
                          //             return false;
                          //           }));
                          //           if (apiResponse) {
                          //             await repository.queries
                          //                 .updateBusinessIsChanged(
                          //                     businesssModel, 0);
                          //           }
                          //         }
                          //         setState(() {
                          //           isLoading = false;
                          //         });
                          //         Navigator.of(context)
                          //             .pushReplacementNamed(
                          //           AppRoutes.setPinRoute,
                          //           arguments: SetPinRouteArgs(
                          //               '', false, false, true),
                          //         );
                          //         // Navigator.of(context)
                          //         //     .pushReplacementNamed(
                          //         //         AppRoutes.welcomeuserRoute,
                          //         //         arguments: _firstNameController
                          //         //                 .text +
                          //         //             ' ' +
                          //         //             _lastNameController.text);
                          //       }
                          //     } else {
                          //       setState(() {});
                          //     }
                          //   },

                          // child: isLoading
                          //     ? CircularProgressIndicator()
                          child: CustomText(
                            'REGISTER',
                            color: Colors.white,
                            size: (18),
                            bold: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: CustomText(
                            'By clicking the register button,\n you agree to our Terms and Conditions',
                            centerAlign: true,
                            color: AppTheme.greyish,
                            bold: FontWeight.w500,
                            size: (15)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
          suffixIcon: GestureDetector(
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
          ),
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
