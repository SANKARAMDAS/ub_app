import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urbanledger/Cubits/UserProfile/user_profile_cubit.dart';
import 'package:urbanledger/Models/user_model.dart';
import 'package:urbanledger/Models/user_profile_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';

class UserProfileNew extends StatefulWidget {
  @override
  _UserProfileNewState createState() => _UserProfileNewState();
}

class _UserProfileNewState extends State<UserProfileNew> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  // final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // bool showCompanyError = false;
  bool showNameError = false;
  bool showLnameError = false;
  //  bool showFnameError = false;
  bool showEmailError = false;

  File? _image;
  final picker = ImagePicker();
  bool isRead = true;
  var fileName;
  final Repository repository = Repository();
  String _userId = '';
  bool isEmailVerified= false;
  bool isEmailSend = false;
  final GlobalKey<State> key = GlobalKey<State>();

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // _mobileController.dispose();
    _fNameController.dispose();
    _lNameController.dispose();
    // _companyNameController.dispose();
    _emailController.dispose();
  }

  Future<bool> getImageFromCamera() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      if ((await File(pickedFile.path).length()) < 5242880) {
        _image = File(pickedFile.path);
        setState(() {});
        return true;
      } else {
        'File size exceeds the maximum limit of 5MB'.showSnackBar(context);
        return false;
      }
    }
    return false;
  }

  Future<bool> getImageFromGallery() async {
    final pickedfile = await picker.getImage(source: ImageSource.gallery);

    if (pickedfile != null) {
      if ((await File(pickedfile.path).length()) < 5242880) {
        _image = File(pickedfile.path);
        setState(() {});
        return true;
      } else {
        'File size exceeds the maximum limit of 5MB'.showSnackBar(context);
        return false;
      }
    }
    return false;
  }

  var uploadApiResponse;

  Future<bool?> _showPicker(context) async {
    return await showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () async {
                        final status = await getImageFromGallery();
                        Navigator.of(context).pop(status);
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () async {
                      final status = await getImageFromCamera();
                      Navigator.of(context).pop(status);
                    },
                  ),
                  ListTile(
                      leading: Icon(CupertinoIcons.delete),
                      title: Text('Delete Photo'),
                      onTap: () async {
                        uploadApiResponse = null;
                        _image = null;
                        Navigator.of(context).pop(false);
                      }),
                ],
              ),
            ),
          );
        });
  }

  getProfile() {
    fileName = repository.hiveQueries.userData.profilePic;
    fileName = (fileName.split('/').last);

    // _companyNameController.text = ;
    _emailController.text = repository.hiveQueries.userData.email;
    _mobileController.text = repository.hiveQueries.userData.mobileNo;
    _fNameController.text = repository.hiveQueries.userData.firstName;
    _lNameController.text = repository.hiveQueries.userData.lastName;
    _image = File(repository.hiveQueries.userData.profilePic);
    _userId = repository.hiveQueries.userData.id;
    isEmailVerified = repository.hiveQueries.userData.email_status;
    if(!isEmailVerified){
      fetchProfileData();
    }
  }

  fetchProfileData() async {
  await BlocProvider.of<UserProfileCubit>(context,listen:false).getUserProfileData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
        backgroundColor: AppTheme.paleGrey,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 22.0),
          child: NewCustomButton(
            text: isRead == true ? 'EDIT' : 'SAVE',
            textColor: Colors.white,
            textSize: 18.0,
            onSubmit: () async {
              if (isRead == true) {
                setState(() {
                  isRead = !isRead;
                });
              } else {
                if (!showNameError && !showLnameError && !showEmailError) {
                  debugPrint('Check13' +
                      repository.hiveQueries.SignUpPaymentLink.toString());
                  await repository.userProfileAPI
                      .userProfileApi(SignUpModel(
                    firstName: "${_fNameController.text.trim()}",
                    lastName: "${_lNameController.text.trim()}",
                    mobileNo:
                        "${_mobileController.text.trim().replaceAll('+', '')}",
                    email: "${_emailController.text.trim()}",
                    id: repository.hiveQueries.userData.id,
                    referral_code:
                        repository.hiveQueries.SignUpUserReferralCode,
                    referral_link:
                        repository.hiveQueries.SignUpUserReferralCode,
                    profilePic: "$uploadApiResponse",
                  ),context)
                      .then((value) async {
                    if (value) {
                      var anaylticsEvents = AnalyticsEvents(context);
                      await anaylticsEvents.initCurrentUser();
                      await anaylticsEvents.updateUserProfileDetailsEvent();
                      debugPrint('Check12' +
                          repository.hiveQueries.SignUpPaymentLink.toString());
                      repository.hiveQueries.insertUserData(
                          repository.hiveQueries.userData.copyWith(
                        firstName: _fNameController.text.trim(),
                        lastName: _lNameController.text.trim(),
                        mobileNo:
                            _mobileController.text.trim().replaceAll('+', ''),
                        referral_link:
                            repository.hiveQueries.SignUpUserReferralLink,
                        referral_code:
                            repository.hiveQueries.SignUpUserReferralCode,
                        email: _emailController.text.trim(),
                        profilePic: _image?.path ?? '',
                      ));
                      Navigator.of(context).pop(true);
                    }
                    debugPrint(value.toString());
                    'Profile Updated Successfully'.showSnackBar(context);
                  });
                }
              }
            },
          ),
        ),
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.chevron_left,
                size: 35,
                color: Colors.white,
              )),
          title: CustomText('My Account'),
        ),
        body: SafeArea(
          child: Stack(children: [
            Container(
              alignment: Alignment.topCenter,
              height: deviceHeight * 0.3,
              clipBehavior: Clip.none,
              decoration: BoxDecoration(
                color: Color(0xfff2f1f6),
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage(AppAssets.backgroundImage3),
                    alignment: Alignment.topCenter),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    // top: MediaQuery.of(context).size.height * 0.1,
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
                        radius: MediaQuery.of(context).size.height * 0.075,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: fileName == 'null' || _image == null
                                  ? Image.asset(
                                      'assets/icons/my-account.png',
                                      // height:
                                      //     MediaQuery.of(context).size.height *
                                      //         0.05,
                                    )
                                  : Container(
                                      width: 200,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child: Image.file(
                                            _image!,
                                            fit: BoxFit.fill,
                                          )),
                                    ),
                            ),
                            if (!isRead)
                              InkWell(
                                onTap: () async {
                                  final status = await _showPicker(context);
                                  if (status != null) {
                                    if (status) {
                                      uploadApiResponse = await repository
                                          .ledgerApi
                                          .uploadAttachment(
                                              _image!.path.toString());
                                      debugPrint('Image ID for Profile PIC' +
                                          uploadApiResponse.toString());
                                    }
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(bottom: 10, right: 10),
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
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  15.0.heightBox,
                  if (!isRead)
                    CustomText(
                      'You can uplaod JPEG or PNG with max size 5MB',
                      color: Colors.white,
                      size: 12,
                    ),
                  SizedBox(
                      height:
                          MediaQuery.of(context).size.height * .062), //( / 15)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      // height: 100,
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * .018),
                      // width: screenWidth(context),
                      /*decoration: BoxDecoration(
                          color: AppTheme.electricBlue,
                          borderRadius: BorderRadius.circular(12)),*/
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Personal Information',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold))),
                    ),
                  ),

                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // SizedBox(height: 4),
                            /*  buildTextFeild(
                                    'assets/icons/business_name.png',
                                    'Company Name',
                                    '',
                                    (value) {
                                      setState(() {});
                                      if (BusinessNameValidator(value!) == null) {
                                        return '';
                                      } else {
                                        return BusinessNameValidator(value);
                                      }
                                    },
                                    _companyNameController,
                                    test,
                                    (e) {
                                      setState(() {
                                        BusinessNameValidator(e);
                                      });
                                    }), */
                            buildTextFeild(
                                'assets/icons/user_profile.png',
                                'First Name',
                                '',
                                _fNameController, onChanged: (e) {
                              final status = checkForError(1);
                              setState(() {
                                showNameError = status;
                              });
                            }),
                            if (showNameError)
                              Container(
                                margin: EdgeInsets.only(left: 16, top: 2),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _fNameController.text.trim().isEmpty
                                      ? 'First name is required'
                                      : 'First name must be between 3 to 15 characters long',
                                  style: TextStyle(color: Colors.red),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            SizedBox(height: 16),
                            buildTextFeild(
                                'assets/icons/user_profile.png',
                                'Last Name',
                                '',
                                _lNameController, onChanged: (e) {
                              final status = checkForError(2);
                              setState(() {
                                showLnameError = status;
                              });
                            }),
                            if (showLnameError)
                              Container(
                                margin: EdgeInsets.only(left: 16, top: 2),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _lNameController.text.trim().isEmpty
                                      ? 'Last name is required'
                                      : 'Last name must be between 3 to 15 characters long',
                                  style: TextStyle(color: Colors.red),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            SizedBox(height: 28),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Contact Information',
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                  Flexible(
                                    child: BlocConsumer<UserProfileCubit,UserProfileState>(listener:(ctx,state){

                                    },builder: (ctx,state){
                                      if(state is FetchingUserProfileState){

                                        return Center(child:CircularProgressIndicator());
                                      }
                                      if (state is FetchedUserProfileState) {
                                        if(state.userProfile !=null){
                                          isEmailVerified=state.userProfile.userProfile?.emailStatus??false;

                                          repository.hiveQueries.insertUserData(
                                              repository.hiveQueries.userData.copyWith(
                                                  email_status: isEmailVerified
                                              ));
                                          return isEmailVerified?Container(
                                            child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  side: BorderSide(
                                                    color: Color(0xFF2ED06D),
                                                    width: 0.5,
                                                  ),
                                                ),

                                                color: Color(0xFFE9FFF3),
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 8, vertical: 5),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Image(
                                                          height: 16,
                                                          width: 16,
                                                          image: new AssetImage(AppAssets.emailVerified)),
                                                      /*ImageIcon(

                                                  AssetImage(AppAssets.emailVerified),
                                                  size: 20,
                                                ),*/
                                                      SizedBox(width: 4,),

                                                      Flexible(child: Container(
                                                          margin: EdgeInsets.only(right: 4),child: Text('Email verified')))
                                                    ],),) ),
                                          ):GestureDetector(
                                            onTap:isEmailSend?(){
                                              'You have already sent a verification email, Please try again later.'.showSnackBar(context);

                                            }: () async {
                                              CustomLoadingDialog.showLoadingDialog(context, key);
                                              await repository.userProfileAPI
                                                  .userEmailAuthentication(_userId, context).then((value){
                                                Navigator.of(context).pop();
                                                if(value.isNotEmpty){
                                                  if(value['status'] == 200) {
                                                    '${value['msg']}'
                                                        .showSnackBar(context);

                                                    setState(() {
                                                      isEmailSend = true;
                                                    });

                                                  }
                                                  else{
                                                    'Verification Email not sent.'
                                                        .showSnackBar(context);

                                                  }
                                                }

                                              });
                                            },
                                            child: Container(
                                              child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    side: BorderSide(
                                                      color:  Color(0xFF1058FF),
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  color: Color(0xFFE0EAFF),
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 4, vertical: 4),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Image(
                                                            height: 16,
                                                            width: 16,
                                                            image: new AssetImage(AppAssets.resendEmailVerification)),
                                                        SizedBox(width: 4,),

                                                        Flexible(child: Container(
                                                            margin: EdgeInsets.only(right: 4),
                                                            child: Text('Resend email verfication')))
                                                      ],),) ),
                                            ),
                                          );
                                        }

                                        return Container();



                                      }
                                      return isEmailVerified?Container(
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                              side: BorderSide(
                                                color: Color(0xFF2ED06D),
                                                width: 0.5,
                                              ),
                                            ),

                                            color: Color(0xFFE9FFF3),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4, vertical: 4),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image(
                                                      height: 20,
                                                      width: 20,
                                                      image: new AssetImage(AppAssets.emailVerified)),
                                                  /*ImageIcon(

                                                  AssetImage(AppAssets.emailVerified),
                                                  size: 20,
                                                ),*/
                                                  SizedBox(width: 4,),

                                                  Flexible(child: Text('Email verified'))
                                                ],),) ),
                                      ):GestureDetector(
                                        onTap:isEmailSend?(){
                                          'You have already sent a verification email, Please try again later.'.showSnackBar(context);

                                        }: () async {
                                          CustomLoadingDialog.showLoadingDialog(context, key);
                                          await repository.userProfileAPI
                                              .userEmailAuthentication(_userId, context).then((value){
                                            if(value.isNotEmpty){
                                              Navigator.of(context).pop();
                                              if(value['status'] == 200) {
                                                '${value['msg']}'
                                                    .showSnackBar(context);

                                                setState(() {
                                                  isEmailSend = true;
                                                });

                                              }
                                              else{
                                                'Verification Email not sent.'
                                                    .showSnackBar(context);

                                              }
                                            }

                                          });
                                        },
                                        child: Container(
                                          child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.0),
                                                side: BorderSide(
                                                  color:  Color(0xFF1058FF),
                                                  width: 0.5,
                                                ),
                                              ),
                                              color: Color(0xFFE0EAFF),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4, vertical: 4),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Image(
                                                        height: 20,
                                                        width: 20,
                                                        image: new AssetImage(AppAssets.resendEmailVerification)),
                                                    SizedBox(width: 4,),

                                                    Flexible(child: Text('Resend email verfication'))
                                                  ],),) ),
                                        ),
                                      );;
                                    },),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            buildTextFeild(
                                'assets/icons/email_profile.png',
                                'Business Email',
                                '',
                                _emailController, onChanged: (e) {
                              final status = checkForError(3);
                              setState(() {
                                showEmailError = status;
                              });
                            }),
                            if (showEmailError)
                              //CustomText
                              Container(
                                margin: EdgeInsets.only(left: 16, top: 2),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _emailController.text.trim().isEmpty
                                      ? 'Business Email is required'
                                      : !_emailController.text.isValidEmail
                                          ? 'Please enter a valid email address '
                                          : 'Business Email must be between 6 to 30 characters long',
                                  style: TextStyle(color: Colors.red),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            SizedBox(height: 16),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0),
                              child: Container(
                                // height: 100,
                                margin: EdgeInsets.only(top: 0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(
                                      top: 5, left: 15, right: 15),
                                  dense: true,
                                  leading: Image.asset(
                                    // 'assets/icons/user.png',
                                    'assets/icons/phone_profile.png',
                                    height: 30, scale: 0.7,
                                    color: Color.fromRGBO(212, 212, 212, 0.8),
                                  ),
                                  title: Text(
                                    // 'User name',
                                    'Mobile Number',
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(212, 212, 212, 0.8),
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  subtitle: Container(
                                    // height: 35,
                                    width: double.infinity,
                                    padding: EdgeInsets.zero,
                                    margin: EdgeInsets.zero,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CountryCodePicker(
                                          enabled: false,
                                          padding: EdgeInsets.only(top: 01),
                                          barrierColor: Colors.black45,
                                          dialogSize: Size(
                                              screenWidth(context) * 0.9,
                                              screenHeight(context) * 0.8),
                                          initialSelection:
                                              repository.hiveQueries.isoCode,
                                          textStyle: TextStyle(
                                              fontSize: 21,
                                              color: Color.fromRGBO(
                                                  212, 212, 212, 0.8),
                                              fontWeight: FontWeight.normal),
                                          onChanged: (value) {},
                                        ),
                                        CustomText(
                                          _mobileController.text.isEmpty
                                              ? ''
                                              : _mobileController.text
                                                  .replaceAll('+', '')
                                                  .substring(2),
                                          size: 21,
                                          color: Color.fromRGBO(
                                              212, 212, 212, 0.8),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                          ]),
                    ),
                  )
                ]))
          ]),
        ));
  }

  Widget buildTextFeild(String imageUrl, String title, String subTitle,
      TextEditingController ctrl,
      {void Function(String)? onChanged}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: Container(
        // height: 100,
        // margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.only(top: 13, left: 15, right: 15),
          minVerticalPadding: 0,

          dense: true,
          leading: Image.asset(
            // 'assets/icons/user.png',
            imageUrl, color: Color(0xff666666),
            height: 33, scale: 0.7,
          ),
          title: Text(
            // 'User name',
            title,
            style: TextStyle(
                color: AppTheme.brownishGrey,
                fontFamily: 'SFProDisplay',
                fontSize: 20,
                fontWeight: FontWeight.w400),
          ),
          subtitle: Container(
            width: double.infinity,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: TextFormField(
              readOnly: isRead,
              style: TextStyle(
                  color: Color(0xffB6B6B6),
                  fontFamily: 'SFProDisplay',
                  fontSize: 23),
              onChanged: onChanged,
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
                contentPadding: EdgeInsets.only(bottom: 5, top: -10, right: 15),
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
          //   color: Color(0xff1058ff),
          //   size: 35,
          // ),
        ),
      ),
    );
  }

  bool checkForError(int id) {
    switch (id) {
      case 1:
        if (_fNameController.text.trim().length >= 16 ||
            _fNameController.text.trim().length < 3) {
          return true;
        } else {
          return false;
        }

      case 2:
        if (_lNameController.text.trim().length >= 16 ||
            _lNameController.text.trim().length < 3) {
          return true;
        } else {
          return false;
        }
      case 3:
        if (_emailController.text.trim().length >= 31 ||
            _emailController.text.trim().length < 6 ||
            !_emailController.text.isValidEmail) {
          return true;
        } else {
          return false;
        }

      case 4:
        if (_mobileController.text.length != 10) {
          return true;
        } else {
          return false;
        }

      default:
    }
    return false;
  }

  String? BusinessNameValidator(String value) {
    if (value.isEmpty) return 'Please enter Company Name';

    if (value.length < 3) {
      return 'Company name must be between 3 to 50 characters long';
    }

    if (value.length >= 50) {
      return 'Company name must be between 3 to 50 characters long ';
    }

    Pattern pattern = r'^[a-zA-Z\. ]+$';

    RegExp regex = new RegExp(pattern as String);

    if (!regex.hasMatch(value)) {
      return Constants.enterValidName;
    }

    return null;
  }

  String? firstNameValidator(String value) {
    if (value.isEmpty) return 'Please enter First Name';

    if (value.length < 3) {
      return 'First name must be between 3 to 20 characters long';
    }

    if (value.length >= 20) {
      return 'First name must be between 3 to 20 characters long';
    }

    Pattern pattern = r'^[a-zA-Z\. ]+$';

    RegExp regex = new RegExp(pattern as String);

    if (!regex.hasMatch(value)) {
      return Constants.enterValidName;
    }

    return null;
  }

  String? lastNameValidator(String value) {
    if (value.isEmpty) return 'Please enter Last Name';

    if (value.length < 3) {
      return 'Last name must be between 3 to 20 characters long';
    }

    if (value.length >= 20) {
      return 'Last name must be between 3 to 20 characters  long';
    }

    Pattern pattern = r'^[a-zA-Z\. ]+$';

    RegExp regex = new RegExp(pattern as String);

    if (!regex.hasMatch(value)) {
      return Constants.enterValidName;
    }

    return null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty) return 'Please enter a valid email address';

    if (value.length > 30)
      return 'Business email must be between 6 to 30 characters long';
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = new RegExp(pattern as String);

    if (!regex.hasMatch(value.trim())) {
      return Constants.enterValidEmail;
    }
    return null;
  }
}
