import 'package:country_code_picker/country_code_picker.dart';
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
import 'package:phone_selector/phone_selector.dart';

class LoginScreen extends StatefulWidget {
  final bool isRegister;

  const LoginScreen({Key? key, required this.isRegister}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _country = 'AE';
  String? _countryCode = '+971';
  String _phoneNumber = '';
  final GlobalKey<State> key = GlobalKey<State>();

  final TextEditingController _mobileController = TextEditingController();
  bool? _isMobileNoValid;

  @override
  void initState() {
    super.initState();
    // _mobileController.text = '';
    _getPhoneNumber();
  }

  _getPhoneNumber() async {
    String phoneNumber = '';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      phoneNumber = (await PhoneSelector.getPhoneNumber())!;
      print(phoneNumber);
    } catch (e) {
      print(e); //_mobileController .focus
      // phoneNumber = 'Failed to get Phone Number.';
    }
    if (mounted) {
      setState(() {
        _mobileController.text = phoneNumber;
      });
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppTheme.paleBlue,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.welcomescreenRoute);
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
        bottomNavigationBar: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.015,
              vertical: MediaQuery.of(context).size.height * 0.02),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15),
              // side: BorderSide(
              //     color: validate() == true
              //         ? Color(0xff1058ff)
              //         : AppTheme.disabledColor,
              //     width: 2),
              primary: validate() == true
                  ? AppTheme.purpleActive
                  : AppTheme.disabledColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
            ),
            onPressed: validate() == true
                ? () async {
                    _isMobileNoValid = await PhoneNumberUtil.isValidPhoneNumber(
                        phoneNumber:
                            _countryCode! + _mobileController.text.trim(),
                        isoCode: _country!);
                    if (_isMobileNoValid!) {
                      debugPrint(_country);
                      repository.hiveQueries.insertUserIsoCode(_country!);
                      CustomLoadingDialog.showLoadingDialog(context, key);
                      final status = widget.isRegister
                          ? await (repository.registerApi
                              .signUpOtpRequest(
                                  (_countryCode! + _mobileController.text)
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
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.of(context).pushReplacementNamed(
                                      AppRoutes.welcomescreenRoute);
                                });
                              return false;
                            }))
                          : await (repository.loginApi
                              .loginOtpRequest(
                                  (_countryCode! + _mobileController.text)
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
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.of(context).pushReplacementNamed(
                                      AppRoutes.welcomescreenRoute);
                                });

                              return false;
                            }));
                      if (status) {
                        await CustomSharedPreferences.setString(
                            'ph_no_without_co', _mobileController.text);
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(
                            AppRoutes.verificationRoute,
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
                : () {},
            child: CustomText(
              'Get OTP',
              size: (18),
              color:
                  validate() == true ? AppTheme.whiteColor : AppTheme.coolGrey,
              // color: AppTheme.electricBlue,
              bold: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: Container(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               
                Flexible(
                    child: Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05),
                      child: Column(children: [
                  Text(
                      'Continue with Mobile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.purpleActive),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Text(
                      'Enter your Mobile Number\nwhere we can share OTP for verification.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.brownishGrey),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                  ),
                ]),
                    )),
                Flexible(
                  child: Stack(children: [
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.15),
                        child: Image.asset(AppAssets.loginArtImage)),
                  ]),
                ),
                // (deviceHeight * 0.03).heightBox,
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      color: Color(0xff1058ff),
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
                            padding: EdgeInsets.only(top: 10),
                            dialogSize: Size(screenWidth(context) * 0.9,
                                screenHeight(context) * 0.8),
                            barrierColor: Colors.black45,
                            initialSelection: 'AE',
                            // initialSelection: 'IT',
                            favorite: ['AE', 'IN'],
                            // countryFilter: ['AE', 'IN'],
                            flagWidth: 40,
                            textStyle: TextStyle(
                                fontSize: (19),
                                color: AppTheme.brownishGrey,
                                fontWeight: FontWeight.bold),
                            searchDecoration: InputDecoration(
                                hintText: "Search",
                                hintStyle: TextStyle(color: AppTheme.greyish)),
                            onChanged: (value) {
                              setState(() {
                                _isMobileNoValid = null;
                              });
                              _country = value.code;
                              _countryCode = value.dialCode;
                              if (_country == 'IN' || _country == 'AE') {
                                _getPhoneNumber();
                              }
                              debugPrint(_country);
                            },
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: TextFormField(
                              controller: _mobileController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                  fontSize: (19),
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.bold),
                              cursorColor: Color(0xff1058ff),
                              onChanged: (value) {
                                if (_isMobileNoValid == false) {
                                  setState(() {
                                    _isMobileNoValid = null;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                  suffixIconConstraints: BoxConstraints.tight(
                                      Size(20, screenHeight(context) * 0.03)),
                                  suffixIcon: _mobileController.text.isNotEmpty
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
                                  hintText: 'Enter your Mobile Number',
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
                            padding: const EdgeInsets.only(left: 20.0, top: 4),
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
                SizedBox(height: MediaQuery.of(context).size.height*0.05)
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    if (_mobileController.text.trim().length < 10 ||
        _mobileController.text.trim().length > 10) {
      return false;
    } else {
      return true;
    }
  }

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
