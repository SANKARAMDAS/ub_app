// import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:urbanledger/screens/Components/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
// import 'package:phone_selector/phone_selector.dart';
// import 'package:phone_selector/phone_selector.dart';

class LoginScreen extends StatefulWidget {
  final bool isRegister;

  const LoginScreen({Key? key, required this.isRegister}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _country = 'AE';
  String? _countryCode = '+971';
  int mobileMaxlengh = 9;
  // String _phoneNumber = '';
  final GlobalKey<State> key = GlobalKey<State>();
  FocusNode myFocusNode = FocusNode();
  final TextEditingController _mobileController = TextEditingController();
  bool? _isMobileNoValid;

  @override
  void initState() {
    super.initState();
    // _mobileController.text = '';
    // _getPhoneNumber();
  }

  // _getPhoneNumber() async {
  //   String phoneNumber = '';
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     phoneNumber = (await PhoneSelector.getPhoneNumber())!;
  //     print(phoneNumber);
  //   } catch (e) {
  //     print(e); //_mobileController .focus
  //     // phoneNumber = 'Failed to get Phone Number.';
  //   }
  //   if (mounted) {
  //     setState(() {
  //       _mobileController.text = phoneNumber;
  //     });
  //   }
  // }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
          onPanUpdate: (details) {
      // Swiping in right direction.
      if (details.delta.dx > 20) {
        Navigator.of(context).pop();
      }

      // Swiping in left direction.
      if (details.delta.dx < 0) {

      }
    },
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   //toolbarHeight: 0,
        //   leading: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
        //     // child: IconButton(
        //     //   icon: Icon(Icons.arrow_back_ios),
        //     //   onPressed: () {
        //     //     Navigator.of(context)
        //     //         .pushReplacementNamed(AppRoutes.welcomescreenRoute);
        //     //   },
        //     // ),
        //   ),
        // ),
        // resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        // appBar: AppBar(
        //   toolbarHeight: 0,
        // ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppAssets.backgroundImage),
              Container(
                padding: EdgeInsets.only(bottom: bottom),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(height: 1),
                  (deviceHeight * 0.05).heightBox,
                  // ULLogoWidget(
                  //   height: 80,
                  // ),
                  Flexible(
                      child: Image.asset(AppAssets.portraitLogo,
                          width: MediaQuery.of(context).size.width * 0.4)),
                  (deviceHeight * 0.07).heightBox,
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: CustomText(
                      'Please select the country code and\nenter your mobile number where Urban Ledger\nwill share the OTP for mobile number verification.',
                      centerAlign: true,
                      size: 15,
                      bold: FontWeight.w500,
                      color: AppTheme.coolGrey,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  (deviceHeight * 0.07).heightBox,
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        color: AppTheme.electricBlue,
                        width: 1.0,
                      ),
                    )),
                    child: Container(
                      // height: MediaQuery.of(context).size.height * 0.06,
                      // margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: CountryCodePicker(
                              flagDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              showDropDownButton: false,
                              padding: EdgeInsets.only(top: 10),
                              dialogSize: Size(screenWidth(context) * 0.9,
                                  screenHeight(context) * 0.8),
                              barrierColor: Colors.black45,
                              initialSelection: 'AE',
                              // initialSelection: 'IT',
                              favorite: ['AE', 'IN'],
                              // countryFilter: ['AE', 'IN'],
                              flagWidth: 30,
                              textStyle: TextStyle(
                                fontSize: (22),
                                color: AppTheme.brownishGrey,
                                // fontWeight: FontWeight.bold
                              ),
                              searchDecoration: InputDecoration(
                                  hintText: "Search",
                                  hintStyle:
                                      TextStyle(color: AppTheme.greyish)),
                              onChanged: (value) {
                                setState(() {
                                  _isMobileNoValid = null;
                                });
                                _country = value.code;
                                _countryCode = value.dialCode;
                                print("kjijiji");
                              
                                debugPrint(_country);
                                if(_country == "AE" ){
                                  mobileMaxlengh = 9;
                                }else if(_country == "IN" ){
                                  mobileMaxlengh = 10;
                                }else{

                                    mobileMaxlengh = 14;
                                }
                                  print(mobileMaxlengh);
                              },
                            ),
                          ),
                          Flexible(
                            flex: 7,
                            fit: FlexFit.tight,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: TextFormField(
                                inputFormatters: [
                                  new LengthLimitingTextInputFormatter(mobileMaxlengh),
                                ],
                                controller: _mobileController,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                  fontSize: (19),
                                  color: Color(0xff666666),
                                ),
                                cursorColor: AppTheme.electricBlue,
                                onChanged: (value) {
                                  if (validate()) {
                                    onSubmit();
                                  }
                                  if (_isMobileNoValid == false) {
                                    setState(() {
                                      _isMobileNoValid = null;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                    suffixIconConstraints: BoxConstraints.tight(
                                        Size(20, screenHeight(context) * 0.03)),
                                    suffixIcon:
                                        _mobileController.text.isNotEmpty
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _isMobileNoValid = null;
                                                  });
                                                  _mobileController.clear();
                                                },
                                                icon: Icon(
                                                  Icons.clear,
                                                  size: (22),
                                                  color: AppTheme.greyish,
                                                ),
                                              )
                                            : null,
                                    contentPadding: EdgeInsets.only(top: 10),
                                    border: InputBorder.none,
                                    hintText: 'Phone number',
                                    hintStyle: TextStyle(
                                        fontSize: (19),
                                        color: AppTheme.coolGrey,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _isMobileNoValid == null
                      ? Container()
                      : _isMobileNoValid!
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 4),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'The number entered is invalid. Please enter a valid number.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: AppTheme.tomato,
                                    fontSize: (14),
                                  ),
                                ),
                              ),
                            ),
                  (deviceHeight * 0.10).heightBox,
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        side: BorderSide(
                            color: validate() == true
                                ? AppTheme.electricBlue
                                : AppTheme.coolGrey,
                            width: 2),
                        primary: validate() == true
                            ? Colors.white
                            : AppTheme.coolGrey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: validate() == true
                          ? () async {
                              _isMobileNoValid =
                                  await PhoneNumberUtil.isValidPhoneNumber(
                                      phoneNumber: _countryCode! +
                                          _mobileController.text.trim(),
                                      isoCode: _country!);
                              if (_isMobileNoValid!) {
                                debugPrint(_country);
                                repository.hiveQueries
                                    .insertUserIsoCode(_country!);
                                CustomLoadingDialog.showLoadingDialog(
                                    context, key);
                                final status = widget.isRegister
                                    ? await (repository.registerApi
                                        .signUpOtpRequest((_countryCode! +
                                                _mobileController.text)
                                            .trim()
                                            .replaceAll('+', ''))
                                        .timeout(Duration(seconds: 30),
                                            onTimeout: () async {
                                        Navigator.of(context).pop();
                                        return Future.value(null);
                                      }).catchError((e) {
                                        Navigator.of(context).pop();
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(SnackBar(
                                        //   content: Text('This mobile is already registered with us, please Login with this number.'),
                                        // ));
                                        'This mobile is already registered with us, please Login with this number.'
                                            .showSnackBar(context);

                                        if (e.toString().contains('registered'))
                                          Future.delayed(Duration(seconds: 2),
                                              () {
                                            Navigator.of(context)
                                                .pushReplacementNamed(AppRoutes
                                                    .welcomescreenRoute);
                                          });
                                        return false;
                                      }))
                                    : await (repository.loginApi
                                        .loginOtpRequest((_countryCode! +
                                                _mobileController.text)
                                            .trim()
                                            .replaceAll('+', ''))
                                        .timeout(Duration(seconds: 30),
                                            onTimeout: () async {
                                        Navigator.of(context).pop();
                                        return Future.value(null);
                                      }).catchError((e) {
                                        Navigator.of(context).pop();
                                        debugPrint(e.toString());
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(SnackBar(
                                        //   content: Text(e.toString()),
                                        // ));
                                        '${e.toString()}'.showSnackBar(context);
                                        if (e.toString().contains('register'))
                                          Future.delayed(Duration(seconds: 2),
                                              () {
                                            Navigator.of(context)
                                                .pushReplacementNamed(AppRoutes
                                                    .welcomescreenRoute);
                                          });

                                        return false;
                                      }));
                                if (status) {
                                  await CustomSharedPreferences.setString(
                                      'ph_no_without_co',
                                      _mobileController.text);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushNamed(
                                      AppRoutes.verificationRoute,
                                      arguments: VerificationScreenRouteArgs(
                                          _countryCode! +
                                              ' ' +
                                              _mobileController.text,
                                          widget.isRegister));
                                }
                                /* else {
                            if (!widget.isRegister)
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('User not registered'),
                              ));
                          } */
                              } else
                                setState(() {});
                            }
                          : () {},
                      child: CustomText(
                        'Get OTP',
                        size: (18),
                        color: validate() == true
                            ? AppTheme.electricBlue
                            : AppTheme.coolGrey,
                        // color: AppTheme.electricBlue,
                        bold: FontWeight.w500,
                      ),
                    ),
                  ),
                ]),
              ),
              // SizedBox(height: 100),
              // Spacer()
            ],
          ),
        ),
      ),
    );
  }

  bool validate() {
    if (_country == 'AE' && _mobileController.text.trim().length == 9) {
      return true;
    } else if (_country == 'IN' && _mobileController.text.trim().length == 10) {
      return true;
    } else {
      return false;
    }
  }

  onSubmit() async {
    _isMobileNoValid = await PhoneNumberUtil.isValidPhoneNumber(
        phoneNumber: _countryCode! + _mobileController.text.trim(),
        isoCode: _country!);
    if (_isMobileNoValid!) {
      debugPrint(_country);
      repository.hiveQueries.insertUserIsoCode(_country!);
      CustomLoadingDialog.showLoadingDialog(context, key);
      final status = widget.isRegister
          ? await (repository.registerApi
              .signUpOtpRequest((_countryCode! + _mobileController.text)
                  .trim()
                  .replaceAll('+', ''))
              .timeout(Duration(seconds: 30), onTimeout: () async {
              Navigator.of(context).pop();
              return Future.value(null);
            }).catchError((e) {
              Navigator.of(context).pop();
              // ScaffoldMessenger.of(context)
              //     .showSnackBar(SnackBar(
              //   content: Text('This mobile is already registered with us, please Login with this number.'),
              // ));
              'This mobile is already registered with us, please Login with this number.'
                  .showSnackBar(context);

              if (e.toString().contains('registered'))
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.welcomescreenRoute);
                });
              return false;
            }))
          : await (repository.loginApi
              .loginOtpRequest((_countryCode! + _mobileController.text)
                  .trim()
                  .replaceAll('+', ''))
              .timeout(Duration(seconds: 30), onTimeout: () async {
              Navigator.of(context).pop();
              return Future.value(null);
            }).catchError((e) {
              Navigator.of(context).pop();
              debugPrint(e.toString());
              // ScaffoldMessenger.of(context)
              //     .showSnackBar(SnackBar(
              //   content: Text(e.toString()),
              // ));
              '${e.toString()}'.showSnackBar(context);
              if (e.toString().contains('register'))
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.welcomescreenRoute);
                });

              return false;
            }));
      if (status) {
        await CustomSharedPreferences.setString(
            'ph_no_without_co', _mobileController.text);
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(AppRoutes.verificationRoute,
            arguments: VerificationScreenRouteArgs(
                _countryCode! + ' ' + _mobileController.text,
                widget.isRegister));
      }
      /* else {
                            if (!widget.isRegister)
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('User not registered'),
                              ));
                          } */
    } else
      setState(() {});
  }
  // if (_country == 'IN' || _country == 'AE') {
  //                                 _getPhoneNumber();
  //                               }

  // bool validate() {
  //   String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  //   RegExp regExp = new RegExp(patttern);
  //   if (_mobileController.text.trim().length == 0) {
  //     return false;
  //   } else if (!regExp.hasMatch(_mobileController.text.trim())) {
  //     return true;
  //   }
  //   return true;
  // }
}
