import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/Components/shimmer_widgets.dart';

import 'kyc_provider.dart';

class ManageKycScreen3 extends StatefulWidget {
  @override
  _ManageKycScreen3State createState() => _ManageKycScreen3State();
}

class _ManageKycScreen3State extends State<ManageKycScreen3> {
  @override
  void initState() {
    super.initState();
    getKyc();
    calculatePremiumDate();
  }

  bool isEmiratesIdDone = Repository().hiveQueries.userData.isEmiratesIdDone;
  bool isTradeLicenseDone =
      Repository().hiveQueries.userData.isTradeLicenseDone;
  bool status =
      Repository().hiveQueries.userData.kycStatus2 == 'Approved' ? true : false;
  bool checkedValue = true;
  bool isPremium = false;
  bool isLoading = false;

  Future getKyc() async {
    setState(() {
      isLoading = true;
    });
    debugPrint('qwerttyy : ' +
        Repository().hiveQueries.userData.isEmiratesIdDone.toString());
    await KycAPI.kycApiProvider.kycCheker().catchError((e) {
      setState(() {
        isLoading = false;
      });
      'Something went wrong. Please try again later.'.showSnackBar(context);
    }).then((value) {
      setState(() {
        isLoading = false;
      });
    });
    calculatePremiumDate();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, AppRoutes.myProfileScreenRoute);
        return true;
      },
      child: isLoading == true
          ? Material(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: deviceHeight * 0.13,
                      ),
                      Container(
                        // height: deviceHeight * 0.37,
                        margin:
                            EdgeInsets.symmetric(horizontal: 55, vertical: 30),
                        child: ShimmerButton(),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        alignment: Alignment.centerLeft,
                        child: ShimmerText(),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: ShimmerContainer(),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        alignment: Alignment.centerLeft,
                        child: ShimmerText(),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Column(
                          children: [
                            ShimmerContainer(),
                            ShimmerListTile3(),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: ShimmerButton(),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Material(
              color: Color(0xffE5E5E5),
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: deviceHeight * 0.17,
                        width: double.maxFinite,
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                            color: Color(0xffE5E5E5),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/images/back.png'),
                                alignment: Alignment.topCenter)),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 55),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, AppRoutes.myProfileScreenRoute);
                                },
                                child: Icon(
                                  Icons.chevron_left,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  'Complete KYC',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'SFProDisplay',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 21),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 42),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '2 Steps are required for Emirates ID &\nUAE Trade License KYC verification.\nIt takes less than 2 minutes.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xff666666),
                                    fontFamily: 'SFProDisplay',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                              // Text(
                              //   'it takes less than  2 minutes',
                              //   style: TextStyle(
                              //       color: Color(0xff666666),
                              //       fontFamily: 'SFProDisplay',
                              //       fontWeight: FontWeight.w600,
                              //       fontSize: 18),
                              // ),
                            ],
                          )),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Step 1',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xff1058FF),
                              fontFamily: 'SFProDisplay',
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                      ),
                      InkWell(
                        onTap: checkedValue == false
                            ? () {}
                            : (repository.hiveQueries.userData
                                            .tradeLicenseVerified ==
                                        'Rejected' ||
                                    repository
                                            .hiveQueries.userData.kycStatus2 ==
                                        'Expired')
                                ? () {
                                    if (repository.hiveQueries.userData
                                                .isEmiratesIdDone ==
                                            true &&
                                        (repository.hiveQueries.userData
                                                    .kycStatus2 ==
                                                'Rejected' ||
                                            repository.hiveQueries.userData
                                                    .kycStatus2 ==
                                                'Expired')) {
                                      Navigator.pushReplacementNamed(
                                          context, AppRoutes.scanEmiratesID);
                                    } else if (repository.hiveQueries.userData
                                                .isTradeLicenseDone ==
                                            true &&
                                        (repository.hiveQueries.userData
                                                    .kycStatus2 ==
                                                'Rejected' ||
                                            repository.hiveQueries.userData
                                                    .kycStatus2 ==
                                                'Expired')) {
                                      Navigator.pushReplacementNamed(
                                          context, AppRoutes.scanTradeLicense);
                                    }
                                  }
                                : () {
                                    if (repository.hiveQueries.userData
                                            .isEmiratesIdDone ==
                                        false) {
                                      Navigator.pushReplacementNamed(
                                          context, AppRoutes.scanEmiratesID);
                                    } else {
                                      Navigator.pushReplacementNamed(
                                          context, AppRoutes.scanTradeLicense);
                                    }
                                  },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Image.asset(
                                      'assets/icons/emiratesid.png',
                                      height: 65,
                                    ),
                                  ),
                                  isEmiratesIdDone == true
                                      ? Text(
                                          'Emirates ID',
                                          style: TextStyle(
                                              color: Color(0xff666666),
                                              fontFamily: 'SFProDisplay',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 21),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // SizedBox(
                                            //   height: 10,
                                            // ),
                                            Text(
                                              'Emirates ID',
                                              style: TextStyle(
                                                  color: Color(0xff666666),
                                                  fontFamily: 'SFProDisplay',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 21),
                                            ),
                                            Text(
                                              'Scan Back Side of Emirates ID',
                                              style: TextStyle(
                                                  color: Color(0xff666666),
                                                  fontFamily: 'SFProDisplay',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                              repository.hiveQueries.userData
                                          .isEmiratesIdDone ==
                                      false
                                  ? Icon(
                                      Icons.chevron_right,
                                      size: 32,
                                      color: Color(0xff666666),
                                    )
                                  : repository.hiveQueries.userData
                                                  .isEmiratesIdDone ==
                                              true &&
                                          (repository.hiveQueries.userData
                                                      .emiratesIdVerified ==
                                                  'Rejected' ||
                                              repository.hiveQueries.userData
                                                      .kycStatus2 ==
                                                  'Expired')
                                      ? Icon(
                                          Icons.chevron_right,
                                          size: 32,
                                          color: Color(0xff666666),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.green,
                                          radius: 20,
                                          child: Center(
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Step 2',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xff1058FF),
                              //Color(0xffB6B6B6)      color: Color(0xff1058FF),
                              fontFamily: 'SFProDisplay',
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                      ),
                      InkWell(
                        onTap: repository.hiveQueries.userData.isEmiratesIdDone ==
                                        true &&
                                    repository.hiveQueries.userData
                                            .isTradeLicenseDone ==
                                        false && checkedValue == true
                                ? () {
                                    Navigator.pushReplacementNamed(
                                        context, AppRoutes.scanTradeLicense);
                                  }
                                : () {},
                            // checkedValue == false
                            //     ? () {}
                            //     : (repository.hiveQueries.userData
                            //                     .tradeLicenseVerified ==
                            //                 'Rejected' ||
                            //             repository.hiveQueries.userData
                            //                     .kycStatus2 ==
                            //                 'Expired')
                            //         ? () {
                            //             if (repository.hiveQueries.userData
                            //                         .isEmiratesIdDone ==
                            //                     true &&
                            //                 (repository.hiveQueries.userData
                            //                             .kycStatus2 ==
                            //                         'Rejected' ||
                            //                     repository.hiveQueries.userData
                            //                             .kycStatus2 ==
                            //                         'Expired')) {
                            //               Navigator.pushReplacementNamed(
                            //                   context,
                            //                   AppRoutes.scanEmiratesID);
                            //             } else if (repository
                            //                         .hiveQueries
                            //                         .userData
                            //                         .isTradeLicenseDone ==
                            //                     true &&
                            //                 (repository.hiveQueries.userData
                            //                             .kycStatus2 ==
                            //                         'Rejected' ||
                            //                     repository.hiveQueries.userData
                            //                             .kycStatus2 ==
                            //                         'Expired')) {
                            //               Navigator.pushReplacementNamed(
                            //                   context,
                            //                   AppRoutes.scanTradeLicense);
                            //             }
                            //           }
                            //         : () {
                            //             if (repository.hiveQueries
                            //                         .userData.isEmiratesIdDone ==
                            //                     true &&
                            //                 repository.hiveQueries.userData
                            //                         .isTradeLicenseDone ==
                            //                     false &&
                            //                 checkedValue == true) {
                            //               Navigator.pushReplacementNamed(
                            //                   context,
                            //                   AppRoutes.scanTradeLicense);
                            //             }
                            //           },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 25),
                          decoration: BoxDecoration(
                            color: repository.hiveQueries.userData
                                        .isEmiratesIdDone ==
                                    false
                                ? AppTheme.greyish
                                : repository.hiveQueries.userData
                                                .isTradeLicenseDone ==
                                            true &&
                                        (repository.hiveQueries.userData
                                                    .tradeLicenseVerified ==
                                                'Rejected' ||
                                            repository.hiveQueries.userData
                                                    .kycStatus2 ==
                                                'Expired')
                                    ? AppTheme.greyish
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Image.asset(
                                      'assets/icons/tradelisc.png',
                                      height: 65,
                                    ),
                                  ),
                                  Text(
                                    'UAE Trade License',
                                    style: TextStyle(
                                        color: Color(0xff666666),
                                        fontFamily: 'SFProDisplay',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 21),
                                  ),
                                ],
                              ),
                              repository.hiveQueries.userData
                                          .isTradeLicenseDone ==
                                      false
                                  ? Icon(
                                      Icons.chevron_right,
                                      size: 32,
                                      color: Color(0xff666666),
                                    )
                                  : repository.hiveQueries.userData
                                                  .isTradeLicenseDone ==
                                              true &&
                                          (repository.hiveQueries.userData
                                                      .tradeLicenseVerified ==
                                                  'Rejected' ||
                                              repository.hiveQueries.userData
                                                      .kycStatus2 ==
                                                  'Expired')
                                      ? Icon(
                                          Icons.chevron_right,
                                          size: 32,
                                          color: Color(0xff666666),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.green,
                                          radius: 20,
                                          child: Center(
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: double.maxFinite,
                        // height: MediaQuery.of(context).size.height * 0.2,
                        child: CheckboxListTile(
                          title: Text(
                            'I agree to the Terms and Conditions set by\nUrban Ledger for the use of this service.',
                            style: TextStyle(
                                fontFamily: 'SFProDisplay', fontSize: 17),
                          ),
                          value: checkedValue,
                          onChanged: (newValue) {
                            setState(() {
                              checkedValue = newValue!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 5.0),
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: ElevatedButton(
                          onPressed: checkedValue == false
                              ? () {}
                              : (repository.hiveQueries.userData
                                              .tradeLicenseVerified ==
                                          'Rejected' ||
                                      repository.hiveQueries.userData
                                              .kycStatus2 ==
                                          'Expired')
                                  ? () {
                                      if (repository.hiveQueries.userData
                                                  .isEmiratesIdDone ==
                                              true &&
                                          (repository.hiveQueries.userData
                                                      .kycStatus2 ==
                                                  'Rejected' ||
                                              repository.hiveQueries.userData
                                                      .kycStatus2 ==
                                                  'Expired')) {
                                        Navigator.pushReplacementNamed(
                                            context, AppRoutes.scanEmiratesID);
                                      } else if (repository.hiveQueries.userData
                                                  .isTradeLicenseDone ==
                                              true &&
                                          (repository.hiveQueries.userData
                                                      .kycStatus2 ==
                                                  'Rejected' ||
                                              repository.hiveQueries.userData
                                                      .kycStatus2 ==
                                                  'Expired')) {
                                        Navigator.pushReplacementNamed(context,
                                            AppRoutes.scanTradeLicense);
                                      }
                                    }
                                  : (repository.hiveQueries.userData
                                                  .isEmiratesIdDone ==
                                              true &&
                                          repository.hiveQueries.userData
                                                  .isTradeLicenseDone ==
                                              true)
                                      ? () async {
                                          await Provider.of<KycProvider>(
                                                  context,
                                                  listen: false)
                                              .updateKyc();
                                          // Navigator.popAndPushNamed(context,
                                          //     AppRoutes.myProfileScreenRoute);
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  AppRoutes.mainRoute);
                                        }
                                      : () {
                                          if (repository.hiveQueries.userData
                                                  .isEmiratesIdDone ==
                                              false) {
                                            Navigator.pushReplacementNamed(
                                                context,
                                                AppRoutes.scanEmiratesID);
                                          } else {
                                            Navigator.pushReplacementNamed(
                                                context,
                                                AppRoutes.scanTradeLicense);
                                          }
                                        },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(18),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              primary: checkedValue == false
                                  ? AppTheme.greyish
                                  : AppTheme.electricBlue),
                          child: CustomText(
                              (repository.hiveQueries.userData
                                              .tradeLicenseVerified ==
                                          'Rejected' ||
                                      repository.hiveQueries.userData
                                              .kycStatus2 ==
                                          'Expired')
                                  ? 'SCAN NOW'
                                  : (repository.hiveQueries.userData
                                                  .isEmiratesIdDone ==
                                              true &&
                                          repository.hiveQueries.userData
                                                  .isTradeLicenseDone ==
                                              true)
                                      ? 'DONE'
                                      : 'SCAN NOW'.toUpperCase(),
                              color: Colors.white,
                              size: 18,
                              bold: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
