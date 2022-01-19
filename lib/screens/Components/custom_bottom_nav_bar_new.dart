import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Cashbook/cashbook_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/custom_popup.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/TransactionScreens/pay_recieve.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';

class CustomBottomNavBarNew extends StatefulWidget {
  @override
  _CustomBottomNavBarNewState createState() => _CustomBottomNavBarNewState();
}

class _CustomBottomNavBarNewState extends State<CustomBottomNavBarNew> {
  final GlobalKey<State> key = GlobalKey<State>();
  bool isLoading = false;
  bool isEmiratesIdDone = false;
  bool isTradeLicenseDone = false;
  bool status = false;
  bool isPremium = false;
  // modalSheet() {
  //   return showModalBottomSheet(
  //       context: context,
  //       isDismissible: true,
  //       enableDrag: true,
  //       builder: (context) {
  //         return Container(
  //           color: Color(0xFF737373), //could change this to Color(0xFF737373),
  //           height: (isEmiratesIdDone == false &&
  //                   isTradeLicenseDone == false &&
  //                   isPremium == true)
  //               ? MediaQuery.of(context).size.height * 0.3
  //               : MediaQuery.of(context).size.height * 0.4,
  //           child: Container(
  //             decoration: new BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: new BorderRadius.only(
  //                     topLeft: const Radius.circular(10.0),
  //                     topRight: const Radius.circular(10.0))),
  //             //height: MediaQuery.of(context).size.height * 0.25,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Padding(
  //                   padding: const EdgeInsets.only(
  //                     top: 40.0,
  //                     left: 40.0,
  //                     right: 40.0,
  //                     bottom: 10,
  //                   ),
  //                   child: (isEmiratesIdDone == false &&
  //                           isTradeLicenseDone == false &&
  //                           isPremium == true)
  //                       ? Text(
  //                           'You have already purchased the Premium Subscription.',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               color: AppTheme.brownishGrey,
  //                               fontFamily: 'SFProDisplay',
  //                               fontSize: 18,
  //                               letterSpacing:
  //                                   0 /*percentages not used in flutter. defaulting to zero*/,
  //                               fontWeight: FontWeight.normal,
  //                               height: 1),
  //                         )
  //                       : Text(
  //                           (isEmiratesIdDone == true &&
  //                                   isTradeLicenseDone == true)
  //                               ? 'KYC verification is pending.\nPlease try after some time.'
  //                               : 'KYC is a mandatory step for\nPremium features.',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               color: Color.fromRGBO(233, 66, 53, 1),
  //                               fontFamily: 'SFProDisplay',
  //                               fontSize: 18,
  //                               letterSpacing:
  //                                   0 /*percentages not used in flutter. defaulting to zero*/,
  //                               fontWeight: FontWeight.normal,
  //                               height: 1),
  //                         ),
  //                 ),
  //                 if (isPremium == false)
  //                   Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Container(
  //                               margin: EdgeInsets.symmetric(horizontal: 10),
  //                               child: Image.asset(
  //                                 'assets/icons/emiratesid.png',
  //                                 height: 35,
  //                               ),
  //                             ),
  //                             Text(
  //                               'Emirates ID',
  //                               style: TextStyle(
  //                                   color: Color(0xff666666),
  //                                   fontFamily: 'SFProDisplay',
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 17),
  //                             ),
  //                           ],
  //                         ),
  //                         isTradeLicenseDone == false
  //                             ? Icon(
  //                                 Icons.chevron_right,
  //                                 size: 32,
  //                                 color: Color(0xff666666),
  //                               )
  //                             : CircleAvatar(
  //                                 backgroundColor: Colors.green,
  //                                 radius: 20,
  //                                 child: Center(
  //                                   child: Icon(
  //                                     Icons.check,
  //                                     color: Colors.white,
  //                                   ),
  //                                 ),
  //                               )
  //                       ],
  //                     ),
  //                   ),
  //                 if (isPremium == false)
  //                   Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Container(
  //                               margin: EdgeInsets.symmetric(horizontal: 10),
  //                               child: Image.asset(
  //                                 'assets/icons/tradelisc.png',
  //                                 height: 35,
  //                               ),
  //                             ),
  //                             Text(
  //                               'UAE Trade License',
  //                               style: TextStyle(
  //                                   color: Color(0xff666666),
  //                                   fontFamily: 'SFProDisplay',
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 17),
  //                             ),
  //                           ],
  //                         ),
  //                         isTradeLicenseDone == false
  //                             ? Icon(
  //                                 Icons.chevron_right,
  //                                 size: 32,
  //                                 color: Color(0xff666666),
  //                               )
  //                             : CircleAvatar(
  //                                 backgroundColor: Colors.green,
  //                                 radius: 20,
  //                                 child: Center(
  //                                   child: Icon(
  //                                     Icons.check,
  //                                     color: Colors.white,
  //                                   ),
  //                                 ),
  //                               )
  //                       ],
  //                     ),
  //                   ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(20.0),
  //                   child: (isEmiratesIdDone == true &&
  //                           isTradeLicenseDone == true)
  //                       ? NewCustomButton(
  //                           onSubmit: () {
  //                             Navigator.pop(context);
  //                           },
  //                           textColor: Colors.white,
  //                           text: 'OKAY',
  //                           textSize: 14,
  //                         )
  //                       : (isEmiratesIdDone == false &&
  //                               isTradeLicenseDone == false &&
  //                               isPremium == true)
  //                           ? Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.pop(context);
  //                                     },
  //                                     text: 'CANCEL',
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   width: 20,
  //                                 ),
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       if (status == false) {
  //                                         modalSheet();
  //                                       } else {
  //                                         Navigator.popAndPushNamed(context,
  //                                             AppRoutes.urbanLedgerPremium);
  //                                       }
  //                                     },
  //                                     text: 'Upgrade'.toUpperCase(),
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                               ],
  //                             )
  //                           : Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.pop(context);
  //                                     },
  //                                     text: 'CANCEL',
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   width: 20,
  //                                 ),
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.popAndPushNamed(
  //                                           context, AppRoutes.manageKyc3Route);
  //                                     },
  //                                     text: 'COMPLETE KYC',
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

// Future getKyc() async {
//     setState(() {
//       isLoading = true;
//     });
//     await KycAPI.kycApiProvider.kycCheker().catchError((e) {
//       setState(() {
//         isLoading = false;
//       });
//       'Please check your internet connection or try again later.'.showSnackBar(context);
//     }).then((value) {
//       setState(() {
//         isLoading = false;
//       });
//     });
//     calculatePremiumDate();
//     setState(() {
//       isLoading = false;
//     });
//   }

  @override
  void initState() {
    super.initState();
    //Future.delayed(Duration(seconds: 1), () => getKyc()).catchError((err) {});
    // getKyc();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 72,
          padding: EdgeInsets.symmetric(horizontal: 26, vertical: 12),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(
                    5.0,
                    5.0,
                  ),
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    AppAssets.homeSelectedIcon,
                    scale: 1.5,
                    height: 26,
                    color: AppTheme.electricBlue,
                  ),
                  Expanded(
                    child: Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.electricBlue,
                      ),
                    ),
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  BlocProvider.of<CashbookCubit>(context).getCashbookData(
                      DateTime.now(),
                      Provider.of<BusinessProvider>(context, listen: false)
                          .selectedBusiness
                          .businessId);
                  Navigator.of(context).pushNamed(AppRoutes.cashbookListRoute);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  // mainAxisSize: MainAxisSize.min,

                  children: [
                    Image.asset(
                      AppAssets.cashbookIcon,
                      scale: 1.5,
                      height: 26,
                    ),
                    Expanded(
                      child: Text(
                        'CashBook',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  /*   var anaylticsEvents =
                  AnalyticsEvents(context);
                  await anaylticsEvents.initCurrentUser();
                  await anaylticsEvents.sendRecieveButtonEvent();
                  CustomLoadingDialog.showLoadingDialog(context, key);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PayRequestScreen(),
                  ));*/
                },
                child: Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0,
                        child: Image.asset(
                          AppAssets.cashbookIcon,
                          scale: 1.5,
                          height: 26,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Send/Receive',
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              isLoading == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : InkWell(
                      onTap: () async {
                        if (await kycChecker(context)) {
                          await calculatePremiumDate();

                          if (Repository().hiveQueries.userData.premiumStatus ==
                              0) {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.urbanLedgerPremiumRoute);

                            // CustomLoadingDialog.showLoadingDialog(context, key);
                          } else {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.upgrdUnsubsRoute);

                            // CustomLoadingDialog.showLoadingDialog(context, key);
                          }
                        }
                        // else if (Repository()
                        //     .hiveQueries
                        //     .userData
                        //     .kycStatus ==
                        //     1 &&
                        //     Repository()
                        //         .hiveQueries
                        //         .userData
                        //         .premiumStatus ==
                        //         0) {
                        //   MerchantBankNotAdded.showBankNotAddedDialog(
                        //       context, 'upgradePremium');
                        // }
                      },

                      // onTap: (status == false)
                      //     ? () {
                      //         modalSheet();
                      //       }
                      //     : () {
                      //         Navigator.of(context)
                      //             .pushNamed(AppRoutes.urbanLedgerPremiumRoute);
                      //
                      //         CustomLoadingDialog.showLoadingDialog(context, key);
                      //       },
                      // onTap: () {
                      //   // MerchantBankNotAdded.showBankNotAddedDialog(context,
                      //   //     'merchantBankNotAdded'
                      //   //     );
                      //   MerchantBankNotAdded.showBankNotAddedDialog(context,
                      //       'upgradePremium'
                      //       );
                      //   // MerchantBankNotAdded.showBankNotAddedDialog(context,
                      //   //     'userNotRegistered'
                      //   //     );
                      //   // MerchantBankNotAdded.showBankNotAddedDialog(context,
                      //   //     'userBankNotAdded'
                      //   //     );
                      //   MerchantBankNotAdded.showBankNotAddedDialog(context,
                      //       'userKYCVerificationPending'
                      //       );
                      //   // MerchantBankNotAdded.showBankNotAddedDialog(context,
                      //   //     'userKYCPending'
                      //   //     );
                      //   // MerchantBankNotAdded.showBankNotAddedDialog(context,
                      //   //     'merchantKYCPending'
                      //   //     );
                      //   // MerchantBankNotAdded.showBankNotAddedDialog(context,
                      //   //     'EmiratesIdPending'
                      //   //     );
                      //   MerchantBankNotAdded.showBankNotAddedDialog(context,
                      //       'TradeLicensePending'
                      //       );
                      // },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            AppAssets.moreIcon,
                            scale: 1.5,
                            height: 26,
                          ),
                          Expanded(
                            child: Text(
                              Repository().hiveQueries.userData.premiumStatus ==
                                      0
                                  ? 'Upgrade'
                                  : 'Premium',
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.myProfileScreenRoute);
                },
                // onTap: () {
                //   Navigator.pushNamed(context, AppRoutes.myProfileScreenRoute);
                //   // Navigator.push(
                //   //   context,
                //   //   MaterialPageRoute(builder: (context) => myProfileScreenRoute()),
                //   // );
                // },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      AppAssets.profileIcon,
                      scale: 1.5,
                      height: 26,
                    ),
                    Expanded(
                      child: Text(
                        'My Account',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        //  centerSwitchIcon
      ],
    );
  }

  Widget get centerSwitchIcon => ValueListenableBuilder(
      valueListenable: isCustomerAddedNotifier,
      builder: (context, dynamic value, child) {
        if (Provider.of<BusinessProvider>(context, listen: false)
            .businesses
            .isNotEmpty)
          return Positioned(
            bottom: 23,
            child: FutureBuilder<List<CustomerModel>>(
                future: Repository().queries.getCustomers(
                    Provider.of<BusinessProvider>(context, listen: false)
                        .selectedBusiness
                        .businessId),
                builder: (context, snapshot) {
                  if (snapshot.data != null)
                    return InkWell(
                      onTap: snapshot.data!.length == 0
                          ? () {}
                          : () async {
                              var anaylticsEvents = AnalyticsEvents(context);
                              await anaylticsEvents.initCurrentUser();
                              await anaylticsEvents.sendRecieveButtonEvent();
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PayRequestScreen(),
                              ));
                            },
                      child: Image.asset(
                        snapshot.data!.length == 0
                            ? AppAssets.switchGrey
                            : AppAssets.switchGreen,
                        scale: 1,
                        height: 75,
                      ),
                    );

                  return Image.asset(
                    AppAssets.switchGreen,
                    scale: 1,
                    height: 75,
                  );
                }),
          );
        return Positioned(
            bottom: 23,

            // left: MediaQuery.of(context).size.width / 2.45,
            // top: 700,
            child: Image.asset(
              AppAssets.switchGreen,
              scale: 1,
              height: 75,
            ));
      });
}
