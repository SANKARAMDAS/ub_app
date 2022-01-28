import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/Models/user_profile_model.dart';
import 'package:urbanledger/Services/APIs/user_profile_api.dart';
// import 'package:urbanledger/Models/user_details_model.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? _country = 'AE';
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? code;
  String? _countryCode = '+971';
  String? _iCountryCode = 'AE';
  bool? _isMobileNoValid;
  UserProfileModel userProfileModel = UserProfileModel();

  final Repository repository = Repository();
  @override
  void initState() {
    dataInit();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void dataInit() {
    if (repository.hiveQueries.userData.firstName.isNotEmpty) {
      _fNameController.text = repository.hiveQueries.userData.firstName;
    }
    if (repository.hiveQueries.userData.lastName.isNotEmpty) {
      _lNameController.text = repository.hiveQueries.userData.lastName;
    }
    if (repository.hiveQueries.userData.email.isNotEmpty) {
      _emailController.text = repository.hiveQueries.userData.email;
    }
    if (repository.hiveQueries.userData.mobileNo.isNotEmpty) {
      code =
          '${repository.hiveQueries.userData.mobileNo[0]}${repository.hiveQueries.userData.mobileNo[1]}';
      if (repository.hiveQueries.userData.mobileNo.length == 12) {
        if (code == '91') {
          _iCountryCode = 'IN';
          _countryCode = '+91';
          debugPrint(repository.hiveQueries.userData.mobileNo);
          var re = RegExp(r'\d{2}'); // replace two digits
          // debugPrint(repository.hiveQueries.userData.mobileNo?.replaceFirst(re, ''));
          _mobileController.text =
              repository.hiveQueries.userData.mobileNo.replaceFirst(re, '');
        }
        if (code == '97') {
          _countryCode = '+971';
          debugPrint(repository.hiveQueries.userData.mobileNo);
          var re = RegExp(r'\d{3}'); // replace three digits
          // debugPrint(repository.hiveQueries.userData.mobileNo?.replaceFirst(re, ''));
          _mobileController.text =
              repository.hiveQueries.userData.mobileNo.replaceFirst(re, '');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.paleGrey,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
          child: NewCustomButton(
            text: 'SAVE',
            textColor: Colors.white,
            textSize: 18.0,
            onSubmit: () async {
              _countryCode = _countryCode!.replaceAll('+', '');
              // await repository.queries.getUserDetails();
              // if(validate()){
              //   await repository.queries.insertUserDetails(
              //     userProfileModel
              //     ..id = "${repository.hiveQueries.userData.id}"
              //     ..profilePic = ""
              //     ..companyName = "${_companyNameController.text.trim()}"
              //     ..firstName = "${_fNameController.text.trim()}"
              //     ..lastName = "${_lNameController.text.trim()}"
              //     ..countryCode = "$_countryCode"
              //     ..mobileNumber = "${_mobileController.text.trim()}"
              //   );
              // }
              if (validate()) {
                // Map<String, String> userData = {
                //   "id": "${repository.hiveQueries.userData.id}",
                //   "profilePic": "",
                //   "companyName": "${_companyNameController.text.trim()}",
                //   "firstName": "${_fNameController.text.trim()}",
                //   "lastName": "${_lNameController.text.trim()}",
                //   "businessEmail": "${_emailController.text.trim()}",
                //   "mobileNumber": "$_countryCode${_mobileController.text.trim()}"
                // };
                // repository.hiveQueries.insertUserDetails(
                //   UserDetailsModel(
                //       "${_fNameController.text.trim()}",
                //       "${_lNameController.text.trim()}",
                //       "$_countryCode${_mobileController.text.trim()}",
                //       "${_emailController.text.trim()}",
                //       "${repository.hiveQueries.userData.id}",
                //       "${_companyNameController.text.trim()}"
                //       )
                //   );
                // debugPrint(userData.toString());
                // var response = await repository.userProfileAPI.postUserdata(userData);
                // debugPrint(response.toString());
              }
            },
          ),
        ),
        body: Stack(children: [
          Container(
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: Color(0xfff2f1f6),
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(AppAssets.backgroundImage2),
                  alignment: Alignment.topCenter),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: 15,
                  right: 15),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.5),
                      radius: MediaQuery.of(context).size.height * 0.09,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/icons/camera.png',
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Color.fromRGBO(185, 206, 249, 1),
                              ),
                              child: Icon(
                                Icons.edit,
                                color: AppTheme.electricBlue,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                // Stack(
                // fit: StackFit.loose,
                // alignment: Alignment.center,
                // children: [
                //   Image.asset(
                //     'assets/icons/camera.png',
                //     height: MediaQuery.of(context).size.height * 0.08,
                //   ),
                //   Container(
                //     padding: EdgeInsets.all(
                //       MediaQuery.of(context).size.height * 0.08,
                //     ),
                //     child: CircleAvatar(
                //         backgroundColor: Colors.white.withOpacity(0.5),
                //         radius: MediaQuery.of(context).size.height * 0.08),
                //   ),
                //   Container(
                //     margin: EdgeInsets.only(top:100, left:100),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(50.0),
                //     ),
                //     child: Padding(
                //       padding: EdgeInsets.symmetric(vertical:50, horizontal:50),
                //       child: Align(
                //         alignment: Alignment.center,
                //         child: Container(
                //           color: Color.fromRGBO(185, 206, 249, 1),
                //           child: Icon(Icons.edit,color: AppTheme.electricBlue,),
                //         ),
                //       ),
                //     ),
                //   ),
                //   ],
                // ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                Flexible(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Container(
                                  // height: 100,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  width: screenWidth(context),
                                  decoration: BoxDecoration(
                                      color: AppTheme.electricBlue,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                    child: Text('PERSONAL INFORMATION',
                                        style: TextStyle(
                                            letterSpacing: 0.5,
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              buildTextFeild(
                                  _companyNameController,
                                  'assets/icons/business_name.png',
                                  'Company Name',
                                  'Enter Company name'),
                              buildTextFeild(
                                  _fNameController,
                                  'assets/icons/user_profile.png',
                                  'First Name',
                                  'Enter First name'),
                              buildTextFeild(
                                  _lNameController,
                                  'assets/icons/user_profile.png',
                                  'Last Name',
                                  'Enter Last name'),
                              SizedBox(height: 15),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Contact information',
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600))),
                              ),
                              SizedBox(height: 5),
                              buildTextFeild(
                                  _emailController,
                                  'assets/icons/email_profile.png',
                                  'Business Email',
                                  'abc@xyz.com'),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Container(
                                  // height: 100,
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: AppTheme.coolGrey,
                                          width: 0.5)),
                                  child: ListTile(
                                    dense: true,
                                    leading: Image.asset(
                                      // 'assets/icons/user.png',
                                      'assets/icons/phone_profile.png',
                                      height: 30,
                                    ),
                                    title: Text(
                                      // 'User name',
                                      'Mobile Number',
                                      style: TextStyle(
                                          color: AppTheme.brownishGrey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Container(
                                      height: 35,
                                      width: double.infinity,
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                            color: AppTheme.coolGrey,
                                            fontSize: 16),
                                        textAlign: TextAlign.left,
                                        decoration: InputDecoration(
                                          prefixIcon: CountryCodePicker(
                                            padding: EdgeInsets.only(top: 0),
                                            dialogSize: Size(
                                                screenWidth(context) * 0.9,
                                                screenHeight(context) * 0.8),
                                            barrierColor: Colors.black45,
                                            initialSelection: _iCountryCode,
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              color: AppTheme.coolGrey,
                                            ),
                                            searchDecoration: InputDecoration(
                                                hintText: "Search",
                                                hintStyle: TextStyle(
                                                    color: AppTheme.greyish)),
                                            onChanged: (value) {
                                              setState(() {
                                                _isMobileNoValid = null;
                                              });
                                              _country = value.code;
                                              _countryCode = value.dialCode;
                                              debugPrint(_country);
                                            },
                                          ),
                                          hintText: '',
                                          alignLabelWithHint: true,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              bottom: 11, top: 11, right: 15),
                                        ),
                                        controller: _mobileController,
                                      ),
                                      //   ),
                                      // ],
                                    ),
                                    // Align(
                                    //   alignment: Alignment(-1.2, 0),
                                    //   child: Text(
                                    //     subTitle,
                                    //     // '${repository.hiveQueries.userData.firstName} ${repository.hiveQueries.userData.lastName}',
                                    //     style: TextStyle(
                                    //         fontSize: 18,
                                    //         fontWeight: FontWeight.w400,
                                    //         color: AppTheme.brownishGrey.withOpacity(0.7)),
                                    //   ),
                                    // ),
                                    // trailing: Icon(
                                    //   Icons.chevron_right_rounded,
                                    //   color: AppTheme.electricBlue,
                                    //   size: 35,
                                    // ),
                                  ),
                                ),
                              )
                            ])))
              ]))
        ]));
  }

  bool validate() {
    debugPrint(_companyNameController.text.length.toString());
    if (_companyNameController.text.length > 50) {
      _showError('Company name allows up to 50 characters.');
      return false;
    } else if (_fNameController.text.length > 20) {
      _showError('First name allows up to 20 characters.');
      return false;
    } else if (_lNameController.text.length > 20) {
      _showError('Last name allows up to 20 characters.');
      return false;
    } else if (_emailController.text.length > 30) {
      _showError('Email allows up to 30 characters.');
      return false;
    } else {
      return true;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppTheme.tomato,
      content: Text(message, textAlign: TextAlign.center),
    ));
  }

  Widget buildTextFeild(TextEditingController ctrl, String imageUrl,
      String title, String subTitle) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        // height: 100,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppTheme.coolGrey, width: 0.5)),
        child: ListTile(
          dense: true,
          leading: Image.asset(
            // 'assets/icons/user.png',
            imageUrl,
            height: 30,
          ),
          title: Text(
            // 'User name',
            title,
            style: TextStyle(
                color: AppTheme.brownishGrey,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          subtitle: Container(
            height: 35,
            width: double.infinity,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: TextField(
              controller: ctrl,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                hintText: subTitle,
                alignLabelWithHint: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 11, top: 11, right: 15),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment(-1.2, 0),
          //   child: Text(
          //     subTitle,
          //     // '${repository.hiveQueries.userData.firstName} ${repository.hiveQueries.userData.lastName}',
          //     style: TextStyle(
          //         fontSize: 18,
          //         fontWeight: FontWeight.w400,
          //         color: AppTheme.brownishGrey.withOpacity(0.7)),
          //   ),
          // ),
          // trailing: Icon(
          //   Icons.chevron_right_rounded,
          //   color: AppTheme.electricBlue,
          //   size: 35,
          // ),
        ),
      ),
    );
  }
}
