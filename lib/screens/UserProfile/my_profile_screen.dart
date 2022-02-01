import 'dart:io';
import 'dart:typed_data';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:urbanledger/Cubits/Notifications/notificationlist_cubit.dart';
import 'package:urbanledger/Models/notification_list_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/chat_module/data/local_database/db_provider.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Add%20Card/card_list.dart';
import 'package:urbanledger/screens/AddBankAccount/user_bank_account_provider.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/custom_popup.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:urbanledger/screens/UserProfile/inappbrowser.dart';
import 'package:urbanledger/screens/UserProfile/notifications_module/badge.dart';
import 'package:urbanledger/screens/UserProfile/notifications_module/user_notifications.dart';
import 'package:urbanledger/screens/UserProfile/user_profile_new.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';

class MyProfileScreen extends StatefulWidget {
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final GlobalKey<State> key = GlobalKey<State>();
  final GlobalKey key1 = GlobalKey();
  final GlobalKey key2 = GlobalKey();
  final GlobalKey key3 = GlobalKey();
  final GlobalKey key4 = GlobalKey();
  final GlobalKey key5 = GlobalKey();

  bool isLoading = false;
  bool isNotAccount = false;
  bool loading = false;
  var fileName;
  String? uniquePaymentLink = '';
  final theImage = Image.asset(
    AppAssets.kycIcon,
    height: 30,
  );
  final theImage2 = Image.asset(
    AppAssets.ledgerIcon,
    height: 30,
  );
  final theImage3 = Image.asset(
    AppAssets.saveCardsIcon,
    height: 30,
  );
  final theImage4 = Image.asset(
    AppAssets.bankIcon,
    height: 30,
  );
  final theImage5 = Image.asset(
    AppAssets.settingsIcon,
    height: 30,
  );
  final theImage6 = Image.asset(
    AppAssets.aboutUsIcon,
    height: 30,
  );
  final theImage7 = Image.asset(
    AppAssets.signOutIcon,
    height: 30,
  );
  final theImage8 = Image.asset(
    AppAssets.helpIcon2,
    height: 30,
  );
  final theImage9 = Image.asset(
    AppAssets.analyticsIcon,
    height: 30,
  );
  final theImage10 = Image.asset(
    AppAssets.transactionsIcon,
    height: 30,
  );
  final theImage11 = Image.asset(
    AppAssets.referIcon,
    height: 30,
  );
  final theImage12 = Image.asset(
    AppAssets.settlementHistoryProfileIcon,
    height: 30,
  );

  getRecentBankAcc() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });

      await Provider.of<UserBankAccountProvider>(context, listen: false)
          .getUserBankAccount();
      isNotAccount =
          Provider.of<UserBankAccountProvider>(context, listen: false)
              .isAccount;
      debugPrint(isNotAccount.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    data();

    // getKyc();
    // getRecentBankAcc();
    calculatePremiumDate();
  }

  data() {
    fileName = repository.hiveQueries.userData.profilePic;
    fileName = (fileName.split('/').last);
    uniquePaymentLink =
        Repository().hiveQueries.userData.paymentLink.toString();
    getNotificationListData();
  }

  getNotificationListData() async {
    await BlocProvider.of<NotificationListCubit>(context)
        .getNotificationListData();
  }

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
  //           height: (status == true)
  //               ? MediaQuery.of(context).size.height * 0.25
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
  //                   child: (status == true && isPremium == false)
  //                       ? Text(
  //                           'Please upgrade your Urban Ledger account in order to access this feature.',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               color: AppTheme.brownishGrey,
  //                               fontFamily: 'SFProDisplay',
  //                               fontSize: 18,
  //                               letterSpacing:
  //                                   0 /*percentages not used in flutter. defaulting to zero*/,
  //                               fontWeight: FontWeight.bold,
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
  //                 if (status == false)
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
  //                 if (status == false)
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
  //                                       Navigator.popAndPushNamed(context,
  //                                           AppRoutes.urbanLedgerPremium);
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

  // showBankAccountDialog() async => await showDialog(
  //     builder: (context) => Dialog(
  //           insetPadding:
  //               EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.75),
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 15.0, bottom: 5),
  //                 child: CustomText(
  //                   "No Bank Account Found.",
  //                   color: AppTheme.tomato,
  //                   bold: FontWeight.w500,
  //                   size: 18,
  //                 ),
  //               ),
  //               CustomText(
  //                 'Please Add Your Bank Account.',
  //                 size: 16,
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     Expanded(
  //                       child: Container(
  //                         margin: EdgeInsets.symmetric(vertical: 10),
  //                         padding: const EdgeInsets.symmetric(horizontal: 10),
  //                         child: RaisedButton(
  //                           padding: EdgeInsets.all(15),
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10)),
  //                           color: AppTheme.electricBlue,
  //                           child: CustomText(
  //                             'Add Account'.toUpperCase(),
  //                             color: Colors.white,
  //                             size: (18),
  //                             bold: FontWeight.w500,
  //                           ),
  //                           onPressed: () {
  //                             Navigator.pop(context, true);
  //                             Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) => AddBankAccount()));
  //                           },
  //                         ),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Container(
  //                         margin: EdgeInsets.symmetric(vertical: 10),
  //                         padding: const EdgeInsets.symmetric(horizontal: 15),
  //                         child: RaisedButton(
  //                           padding: EdgeInsets.all(15),
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10)),
  //                           color: AppTheme.electricBlue,
  //                           child: CustomText(
  //                             'Not now'.toUpperCase(),
  //                             color: Colors.white,
  //                             size: (18),
  //                             bold: FontWeight.w500,
  //                           ),
  //                           onPressed: () {
  //                             Navigator.of(context).pop(true);
  //                           },
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //     barrierDismissible: false,
  //     context: context);

  // Future getKyc() async {
  //   if (mounted) {
  //     setState(() {
  //       loading = true;
  //     });
  //   }
  //   await KycAPI.kycApiProvider.kycCheker().catchError((e) {
  //     // Navigator.of(context).pop();
  //     setState(() {
  //       isLoading = false;
  //     });
  //     'Please check your internet connection or try again later.'.showSnackBar(context);
  //   }).then((value) {
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  //   calculatePremiumDate();
  //   setState(() {
  //     loading = false;
  //   });
  // }

  @override
  void didChangeDependencies() {
    precacheImage(theImage.image, context);
    precacheImage(theImage2.image, context);
    precacheImage(theImage3.image, context);
    precacheImage(theImage4.image, context);
    precacheImage(theImage5.image, context);
    precacheImage(theImage6.image, context);
    precacheImage(theImage7.image, context);
    precacheImage(theImage8.image, context);
    precacheImage(theImage9.image, context);
    precacheImage(theImage10.image, context);
    precacheImage(theImage11.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);
          return true;
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(AppAssets.topGradient),
                alignment: Alignment.topCenter),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leadingWidth: 30,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.only(left: 10),
                width: 0,
                alignment: Alignment.center,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xff666666),
                    size: 22,
                  ),
                  // color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.mainRoute);
                  },
                ),
              ),
              title: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                    decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    // child: CircleAvatar(
                    //   radius: 22,
                    child: Image.asset(AppAssets.myAccountIcon,
                        width: 30,),
                    // ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.of(context).pushNamed(AppRoutes.customerProfileRoute,
                      //     arguments: customerModel);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfileNew()),
                      ).then((value) {
                        if (value != null) {
                          if (value) setState(() {});
                        }
                      });
                    },
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: const Text(
                              // '${repository.hiveQueries.userData.firstName} ${repository.hiveQueries.userData.lastName}',
                              'My Account',
                              style: TextStyle(
                                color: AppTheme.brownishGrey,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Repository().hiveQueries.userData.premiumStatus != 0
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 18),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              // width: 126,
                              height: 27,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Color(0xffebebeb),
                                  width: 1,
                                ),
                                color: AppTheme.electricBlue,
                              ),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Container(
                                        child: Image.asset(
                                          'assets/images/crown.png',
                                          height: 15,
                                          width: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    FittedBox(
                                      child: Container(
                                        child: Text(
                                          'Premium',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'SFProDisplay',
                                              fontWeight: FontWeight
                                                  .w500, //FontWeight.w500
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ]),
                            )
                          : Container(),
                      BlocConsumer<NotificationListCubit,
                          NotificationListState>(
                        listener: (context, state) {
                          // do stuff here based on BlocA's state
                        },
                        buildWhen: (previous, current) {
                          return current != previous;
                          // return true/false to determine whether or not
                          // to rebuild the widget with state
                        },
                        builder: (context, state) {
                          if (state is FetchedNotificationListState) {
                            List<NotificationData> data =
                                state.notificationList;
                            int unreadNotifications = data
                                .where((element) => element.read == false)
                                .toList()
                                .length;
                            return Badge(
                              child: InkWell(
                                child: Image.asset(
                                  AppAssets.notification_bell,
                                  color: AppTheme.electricBlue,
                                  height: 50,
                                  width: 50,
                                ),
                                onTap: () async {
                                  await showNotificationListDialog(
                                      context, data);

                                  setState(() {});
                                },
                              ),
                              value: unreadNotifications.toString() ?? '0',
                              color: Colors.grey,
                              countColor: Colors.white,
                            );
                          }

                          return Container();

                          // return widget here based on BlocA's state
                        },
                      ),

                      /*BlocBuilder<NotificationListCubit,
                  NotificationListState>(
                  builder: (context, state) {

                  })*/
                    ],
                  )
                ],
              ),
            ),
            body: loading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    children: [
                      appBar,
                      // userDetails,
                      const SizedBox(height: 30),
                    /*  CustomList(
                        icon: theImage,
                        text: 'Test Screen',
                        onSubmit: () {
                          //Navigator.pushNamed(context, AppRoutes.userProfileRoute);
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.accountLockedRoute);
                        },
                      ),
                      divider,*/

                      CustomList(
                        icon: theImage,
                        text: 'Complete Your KYC',
                        onSubmit: () {
                          //Navigator.pushNamed(context, AppRoutes.userProfileRoute);
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.manageKyc1Route);
                        },
                      ),
                      divider,

                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.068,
                            right: MediaQuery.of(context).size.width * 0.05),
                        child: CustomExpansionTile(
                          initiallyExpanded: false,
                          key: key1,
                          childrenPadding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.16,
                              right: 20),
                          trailingIconSize: 30,
                          title: CustomText('My Ledger',
                              color: AppTheme.brownishGrey,
                              size: 16,
                              bold: FontWeight.bold),
                          leading: theImage2,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: CustomText(
                                'Backup Information',
                                bold: FontWeight.w400,
                                color: AppTheme.brownishGrey,
                              ),
                              trailing: Icon(Icons.chevron_right_rounded),
                              onTap: () {
                                Navigator.pushNamed(context,
                                        AppRoutes.backUpInformationRoute)
                                    .then((value) {
                                  key1.currentState!.initState();
                                  key1.currentState!.build(context);
                                });
                              },
                            ),
                            Divider(
                              color: AppTheme.coolGrey,
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const CustomText(
                                'Manage Ledgers',
                                bold: FontWeight.w400,
                                color: AppTheme.brownishGrey,
                              ),
                              trailing: Icon(Icons.chevron_right_rounded),
                              onTap: () async {
                                if (await kycAndPremium(context)) {
                                  // setState(() {
                                  //   loading = true;
                                  // });
                                  Navigator.pushNamed(
                                      context, AppRoutes.myBusinessRoute);
                                  //     .then((value) {
                                  //   key1.currentState!.initState();
                                  //   key1.currentState!.build(context);
                                  // }).then((value) => loading = true);
                                }
                              },
                              // : () {
                              //     Navigator.pushNamed(context,
                              //             AppRoutes.myBusinessRoute)
                              //         .then((value) {
                              //       key1.currentState!.initState();
                              //       key1.currentState!.build(context);
                              //     });
                              //   },
                            ),
                            Divider(
                              color: AppTheme.coolGrey,
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: CustomText(
                                'Global Report',
                                bold: FontWeight.w400,
                                color: AppTheme.brownishGrey,
                              ),
                              trailing: Icon(Icons.chevron_right_rounded),
                              onTap: () async {
                                if (await allChecker(context)) {
                                  // setState(() {
                                  //   loading = true;
                                  // });
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.globalReportRoute);
                                  //     .then((value) {
                                  //   key1.currentState!.initState();
                                  //   key1.currentState!.build(context);
                                  // }).then((value) => loading = true);
                                }
                              },
                            ),
                            /* Divider(
                      color: AppTheme.coolGrey,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: CustomText(
                        'Individual Report',
                        bold: FontWeight.w400,
                        color: AppTheme.brownishGrey,
                      ),
                      trailing: Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.individualReportRoute)
                            .then((value) {
                          key1.currentState!.initState();
                          key1.currentState!.build(context);
                        });
                      },
                    ), */
                            // 20.0.heightBox,
                          ],
                        ),
                      ),
                      divider,
                      CustomList(
                        icon: theImage9,
                        text: 'Account Insights',
                        onSubmit: () async {
                          if (await allChecker(context)) {
                            Navigator.pushNamed(
                                context, AppRoutes.mobileAnalyticsRoute);
                          }
                        },
                      ),

                      divider,
                      CustomList(
                        icon: theImage10,
                        text: 'Unrecognized Transaction',
                        onSubmit: () {
                          //Navigator.pushNamed(context, AppRoutes.userProfileRoute);
                          Navigator.pushNamed(
                              context, AppRoutes.suspenseAccountRoute);
                        },
                      ),

                      // Padding

                      divider,
                      CustomList(
                        icon: theImage3,
                        text: 'My Saved Cards',
                        onSubmit: () {
                          /* Navigator.of(context)
                            .pushNamed(AppRoutes.savedCardsRoute);*/
                          /*Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => CardList()));*/
                          Navigator.of(context)
                              .pushNamed(AppRoutes.cardListRoute);
                          CustomLoadingDialog.showLoadingDialog(context, key);
                        },
                      ),
                      divider,

                      CustomList(
                        icon: theImage4,
                        text: 'My Bank Account',
                        onSubmit: () {
                          debugPrint('Bank status from Local DB: ' +
                              Repository()
                                  .hiveQueries
                                  .userData
                                  .bankStatus
                                  .toString());
                          Navigator.of(context)
                              .pushNamed(AppRoutes.profileBankAccountRoute);
                          CustomLoadingDialog.showLoadingDialog(context, key);
                        },
                      ),
                      divider,

                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.068,
                            right: MediaQuery.of(context).size.width * 0.05),
                        child: CustomExpansionTile(
                            initiallyExpanded: false,
                            key: key2,
                            childrenPadding:
                                EdgeInsets.only(left: 70, right: 20),
                            trailingIconSize: 30,
                            title: CustomText('Settings',
                                color: AppTheme.brownishGrey,
                                size: 16,
                                bold: FontWeight.bold),
                            leading: theImage5,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: CustomText(
                                  'App Lock and Security',
                                  bold: FontWeight.w400,
                                  color: AppTheme.brownishGrey,
                                ),
                                trailing: Icon(Icons.chevron_right_rounded),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.pinSetupRoute);
                                  key2.currentState!.initState();
                                  key2.currentState!.build(context);
                                },
                              ),
                              Divider(
                                color: Colors.grey,
                                indent: 0,
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: CustomText(
                                  'App Update',
                                  bold: FontWeight.w400,
                                  color: AppTheme.brownishGrey,
                                ),
                                trailing: Icon(Icons.chevron_right_rounded),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.appUpdateRoute);
                                  key2.currentState!.initState();
                                  key2.currentState!.build(context);
                                },
                              ),
                            ]),
                      ),

                      divider,

                      Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.068,
                              right: MediaQuery.of(context).size.width * 0.05),
                          child: CustomExpansionTile(
                              initiallyExpanded: false,
                              key: key3,
                              childrenPadding:
                                  EdgeInsets.only(left: 70, right: 20),
                              trailingIconSize: 30,
                              title: CustomText('Help Center',
                                  color: AppTheme.brownishGrey,
                                  size: 16,
                                  bold: FontWeight.bold),
                              leading: theImage8,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: CustomText(
                                    'Help Topics',
                                    bold: FontWeight.w400,
                                    color: AppTheme.brownishGrey,
                                  ),
                                  trailing: Icon(Icons.chevron_right_rounded),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UlAppBrowser(
                                          url: 'https://urbanledger.app/help',
                                          title: 'Help',
                                        ),
                                      ),
                                    );
                                    key3.currentState!.initState();
                                    key3.currentState!.build(context);
                                  },
                                ),
                                Divider(
                                  color: Colors.grey,
                                  indent: 0,
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: CustomText(
                                    'Contact Us',
                                    bold: FontWeight.w400,
                                    color: AppTheme.brownishGrey,
                                  ),
                                  trailing: Icon(Icons.chevron_right_rounded),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UlAppBrowser(
                                          url:
                                              'https://urbanledger.app/contact/',
                                          title: 'Contact Us',
                                        ),
                                      ),
                                    );
                                    key3.currentState!.initState();
                                    key3.currentState!.build(context);
                                  },
                                ),
                              ])),

                      divider,
                      CustomList(
                        icon: theImage12,
                        text: 'Settlement History',
                        onSubmit: () {
                          //Navigator.pushNamed(context, AppRoutes.userProfileRoute);
                          Navigator.pushNamed(
                              context, AppRoutes.settlementHistoryRoute);
                        },
                      ),

                      divider,

                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.068,
                            right: MediaQuery.of(context).size.width * 0.05),
                        child: CustomExpansionTile(
                          initiallyExpanded: false,
                          key: key4,
                          childrenPadding: EdgeInsets.only(left: 70, right: 20),
                          trailingIconSize: 30,
                          title: CustomText('About Us',
                              color: AppTheme.brownishGrey,
                              size: 16,
                              bold: FontWeight.bold),
                          leading: theImage6,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: CustomText(
                                'About Urban Ledger',
                                bold: FontWeight.w400,
                                color: AppTheme.brownishGrey,
                              ),
                              trailing: Icon(Icons.chevron_right_rounded),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UlAppBrowser(
                                      url: 'https://urbanledger.app/help/about',
                                      title: 'About Urban Ledger',
                                    ),
                                  ),
                                );
                                key4.currentState!.initState();
                                key4.currentState!.build(context);
                              },
                            ),
                            Divider(
                              color: Colors.grey,
                              indent: 0,
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: CustomText(
                                'Privacy Policy',
                                bold: FontWeight.w400,
                                color: AppTheme.brownishGrey,
                              ),
                              trailing: Icon(Icons.chevron_right_rounded),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UlAppBrowser(
                                      url:
                                          'https://urbanledger.app/cookie-policy',
                                      title: 'Privacy Policy',
                                    ),
                                  ),
                                );
                                key4.currentState!.initState();
                                key4.currentState!.build(context);
                              },
                            ),
                            Divider(
                              color: Colors.grey,
                              indent: 0,
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: CustomText(
                                'Terms and Conditions',
                                bold: FontWeight.w400,
                                color: AppTheme.brownishGrey,
                              ),
                              trailing: Icon(Icons.chevron_right_rounded),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UlAppBrowser(
                                      url:
                                          'https://urbanledger.app/terms-and-conditions',
                                      title: 'Terms and Conditions',
                                    ),
                                  ),
                                );
                                key1.currentState!.initState();
                                key1.currentState!.build(context);
                              },
                            ),
                          ],
                        ),
                      ),

                      //   padding: EdgeInsets.only(
                      //       top: 7, left: 30, bottom: 7, right: 20),
                      //   child: ListTile(
                      //     onTap: () async {
                      //       Navigator.pushNamed(context, AppRoutes.suspenseAccountRoute);

                      //       // await repository.loginApi.logout();
                      //       // restartAppNotifier.value = !restartAppNotifier.value;

                      //     },
                      //     dense: true,
                      //     leading: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         // CircleAvatar(
                      //         //   radius: 22,
                      //         Container(
                      //           child: theImage9,
                      //         ),
                      //         // ),
                      //       ],
                      //     ),
                      //     title: Text(
                      //       'Transactions',
                      //       style: TextStyle(
                      //           color: AppTheme.brownishGrey,
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.bold),
                      //     ),
                      //   ),
                      // ),

                      divider,
                      Padding(
                        padding: EdgeInsets.only(
                            top: 7,
                            left: MediaQuery.of(context).size.width * 0.068,
                            bottom: 7,
                            right: MediaQuery.of(context).size.width * 0.05),
                        child: ListTile(
                          onTap: () async {
                            await repository.hiveQueries.clearHiveData();
                            await repository.queries.clearULTables();
                            await DBProvider.db.clearDatabase();
                            await CustomSharedPreferences.setBool(
                                'chatSync', false);
                            await CustomSharedPreferences.remove(
                                'primaryBusiness');
                            repository.hiveQueries.insertUnAuthData(repository
                                .hiveQueries.unAuthData
                                .copyWith(seen: true));
                            // await repository.loginApi.logout();
                            // restartAppNotifier.value = !restartAppNotifier.value;
                            RestartWidget.restartApp(context);
                          },
                          dense: true,
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // CircleAvatar(
                              //   radius: 22,
                              Container(
                                child: theImage7,
                              ),
                              // ),
                            ],
                          ),
                          title: Text(
                            'Signout',
                            style: TextStyle(
                                color: AppTheme.brownishGrey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      /* Container(
                      height: 380,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage(
                          AppAssets.reffriendIcon,
                        ),
                        // alignment: Alignment.topCenter
                      )),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                              ),
                              child: CustomList(
                                icon: theImage11,
                                text: 'Refer A Friend',
                                onSubmit: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.referFriendstRoute);
                                },
                              ),
                            ), */
                      // SizedBox(height: 20),
                      bottom
                      //       ]),
                      // ),

                      // Stack(
                      //   alignment: AlignmentDirectional.topCenter,
                      //   children: [
                      //     Padding(
                      //       padding: EdgeInsets.only(top: 10),
                      //       child: CustomList(
                      //         icon: AppAssets.referIcon,
                      //         text: 'Refer a Friend',
                      //         onSubmit: () {},
                      //       ),
                      //     ),
                      //     Image.asset(
                      //       AppAssets.referBackgroundIcon,
                      //       fit: BoxFit.fitWidth,
                      //     ),
                      //     Spacer(),
                      //
                      //   ],
                      // ),
                    ],
                  ),
          ),
        ));
  }

  Widget get appBar => Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenWidth(context) * 0.5,
              padding: EdgeInsets.only(top: 0),
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                  vertical: 0),
              child: Consumer<BusinessProvider>(builder: (context, value, _) {
                return Text(
                  value.selectedBusiness.businessName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.electricBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                );
              }),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfileNew()),
                ).then((value) {
                  if (value != null) {
                    if (value) setState(() {});
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.1, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.5),
                      radius: MediaQuery.of(context).size.height * 0.05,
                      child: Align(
                        alignment: Alignment.center,
                        child: (fileName == 'null') ||
                                (repository.hiveQueries.userData.profilePic
                                        .toString()
                                        .isEmpty &&
                                    repository.hiveQueries.userData.profilePic
                                        .isEmpty)
                            ? Image.asset(
                                'assets/icons/my-account.png',
                                // height:
                                //     MediaQuery.of(context).size.height * 0.05,
                              )
                            : Container(
                                width: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Image.file(
                                    File(repository
                                        .hiveQueries.userData.profilePic),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                      ),
                    ),

                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: screenWidth(context) * 0.37,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${repository.hiveQueries.userData.firstName} ${repository.hiveQueries.userData.lastName}',
                            style: TextStyle(
                                color: AppTheme.brownishGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10),
                          Text(
                            '+${repository.hiveQueries.userData.mobileNo.replaceAll('+', '')}',
                            style: TextStyle(
                                color: AppTheme.brownishGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${repository.hiveQueries.userData.email}',
                            style: TextStyle(
                                color: AppTheme.brownishGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   width: 30,
                    // ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5, left: 5),
                          child: Text(
                            'Unique QR Code',
                            style: TextStyle(
                                color: AppTheme.brownishGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (await allChecker(context)) {
                              CustomLoadingDialog.showLoadingDialog(
                                  context, key);
                              Uint8List qrData = await repository
                                  .paymentThroughQRApi
                                  .getQRCode()
                                  .timeout(Duration(seconds: 30),
                                      onTimeout: () async {
                                Navigator.of(context).pop();
                                return Future.value(null);
                              });
                              if (qrData.isNotEmpty) {
                                var anaylticsEvents = AnalyticsEvents(context);
                                await anaylticsEvents.initCurrentUser();
                                await anaylticsEvents
                                    .generateGlobalQrcodeEvent();
                                Navigator.of(context).pop(true);
                                Navigator.of(context).pushNamed(
                                  AppRoutes.profileQRRoute,
                                  arguments: UserQRArgs(qrCode: qrData),
                                );
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5, left: 3),
                            child: Image.asset(
                              AppAssets.qrCode,
                              width: 99,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.13, right: 25),
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'Unique Payment Link',
                style: TextStyle(
                  color: AppTheme.brownishGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 0.5, color: AppTheme.coolGrey),
                      color: Color.fromRGBO(236, 236, 236, 1),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        if (await allChecker(context)) {
                          FlutterClipboard.copy('https:ul.co/payinvite/l2g363')
                              .then((value) => print('Link copied'));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.41,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              uniquePaymentLink!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppTheme.brownishGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              debugPrint('AAAAAAA' +
                                  repository.hiveQueries.userData.bankStatus
                                      .toString());
                              debugPrint('DD' +
                                  Repository()
                                      .hiveQueries
                                      .userData
                                      .kycStatus
                                      .toString());
                              if (await allChecker(context)) {
                                debugPrint('Link copied');
                                Clipboard.setData(ClipboardData(
                                        text: Repository()
                                            .hiveQueries
                                            .userData
                                            .paymentLink
                                            .toString()))
                                    .then((result) {
                                  // show toast or snackbar after successfully save
                                  // Fluttertoast.showToast(
                                  //     msg: "Link copied");
                                  'Link copied'.showSnackBar(context);
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                color: (AppTheme.electricBlue),
                              ),
                              child: Text(
                                'COPY LINK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TapDebouncer(
                    cooldown: const Duration(milliseconds: 1000),
                    onTap: () async {
                      if (await allChecker(context)) {
                        debugPrint('loading status:' + loading.toString());
                        if (loading == false) {
                          setState(() {
                            loading = true;
                          });
                          final RenderBox box =
                              context.findRenderObject() as RenderBox;

                          Share.share(
                                  Repository()
                                      .hiveQueries
                                      .userData
                                      .paymentLink
                                      .toString(),
                                  subject: Repository()
                                      .hiveQueries
                                      .userData
                                      .paymentLink
                                      .toString(),
                                  sharePositionOrigin:
                                      box.localToGlobal(Offset.zero) & box.size)
                              .then((value) async {
                            var anaylticsEvents = AnalyticsEvents(context);
                            await anaylticsEvents.initCurrentUser();
                            await anaylticsEvents.shareGlobalPaymentLinkEvent();
                            setState(() {
                              loading = false;
                            });
                          });
                        }
                      }
                    },
                    // your tap handler moved here
                    builder: (BuildContext context, TapDebouncerFunc? onTap) {
                      return GestureDetector(
                        onTap: onTap,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppTheme.electricBlue,
                          ),
                          child: Text(
                            'SHARE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // isLoading == true
                  //     ? Center(
                  //         child: CircularProgressIndicator(),
                  //       )
                  //     : GestureDetector(
                  //         onTap: () async {
                  //           if (Repository().hiveQueries.userData.bankStatus ==
                  //               false) {
                  //             MerchantBankNotAdded.showBankNotAddedDialog(
                  //                 context, 'userBankNotAdded');
                  //           } else if ((Repository()
                  //                       .hiveQueries
                  //                       .userData
                  //                       .kycStatus !=
                  //                   1) ||
                  //               (Repository()
                  //                       .hiveQueries
                  //                       .userData
                  //                       .premiumStatus !=
                  //                   0)) {
                  //             if (Repository().hiveQueries.userData.kycStatus ==
                  //                 2) {
                  //               //If KYC is Verification is Pending
                  //               debugPrint('Checking pop');
                  //               await getKyc().then((value) =>
                  //                   MerchantBankNotAdded.showBankNotAddedDialog(
                  //                       context, 'userKYCVerificationPending'));
                  //             } else if (Repository()
                  //                     .hiveQueries
                  //                     .userData
                  //                     .kycStatus ==
                  //                 0) {
                  //               //KYC WHEN USER STARTS A NEW KYC JOURNEY
                  //               MerchantBankNotAdded.showBankNotAddedDialog(
                  //                   context, 'userKYCPending');
                  //             } else if (Repository()
                  //                         .hiveQueries
                  //                         .userData
                  //                         .kycStatus ==
                  //                     0 &&
                  //                 Repository()
                  //                         .hiveQueries
                  //                         .userData
                  //                         .isEmiratesIdDone ==
                  //                     false) {
                  //               //KYC WHEN USER STARTS EMirates ID Journey but not done TRade License
                  //               MerchantBankNotAdded.showBankNotAddedDialog(
                  //                   context, 'EmiratesIdPending');
                  //             } else if (Repository()
                  //                         .hiveQueries
                  //                         .userData
                  //                         .kycStatus ==
                  //                     0 &&
                  //                 Repository()
                  //                         .hiveQueries
                  //                         .userData
                  //                         .isTradeLicenseDone ==
                  //                     false) {
                  //               //KYC WHEN USER STARTS EMirates ID Journey but not done TRade License
                  //               MerchantBankNotAdded.showBankNotAddedDialog(
                  //                   context, 'TradeLicensePending');
                  //             } else if (Repository()
                  //                         .hiveQueries
                  //                         .userData
                  //                         .kycStatus ==
                  //                     1 &&
                  //                 Repository()
                  //                         .hiveQueries
                  //                         .userData
                  //                         .premiumStatus ==
                  //                     0) {
                  //               MerchantBankNotAdded.showBankNotAddedDialog(
                  //                   context, 'upgradePremium');
                  //             } else {
                  //               debugPrint(
                  //                   'loading status:' + loading.toString());
                  //               if (loading == false) {
                  //                 setState(() {
                  //                   loading = true;
                  //                 });
                  //                 final RenderBox box =
                  //                     context.findRenderObject() as RenderBox;

                  //                 Share.share('https:ul.co/payinvite/l2g363',
                  //                         subject:
                  //                             'https:ul.co/payinvite/l2g363',
                  //                         sharePositionOrigin:
                  //                             box.localToGlobal(Offset.zero) &
                  //                                 box.size)
                  //                     .then((value) {
                  //                   setState(() {
                  //                     loading = false;
                  //                   });
                  //                 });
                  //               }
                  //             }
                  //           }
                  //         },
                  //         child: Container(
                  //           padding: EdgeInsets.all(10),
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(20),
                  //             color: AppTheme.electricBlue,
                  //           ),
                  //           child: Text(
                  //             'SHARE',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.w500,
                  //               fontSize: 14,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget get bottom => Container(
        // width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'V.1.0.0',
              style: TextStyle(color: AppTheme.brownishGrey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 2),
              child: SvgPicture.asset(
                AppAssets.logo,
                height: 40,
                color: AppTheme.brownishGrey,
              ),
            ),
            const Text(
              'Track. Remind. Pay.',
              style: TextStyle(color: AppTheme.brownishGrey, fontSize: 12),
            ),
          ],
        ),
      );

  Widget get divider => const SizedBox(
        height: 20,
      );

  showNotificationListDialog(
      BuildContext context, List<NotificationData> dataList) {
    return showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: SizedBox.expand(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: UserNotifications(
                      dataList: dataList,
                    ))),
            margin: EdgeInsets.only(bottom: 12, left: 16, right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(new Radius.circular(12.0)),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}

class CustomList extends StatelessWidget {
  final String text;
  final Widget icon;
  final Function? onSubmit;

  const CustomList({
    required this.text,
    required this.icon,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 7,
          left: MediaQuery.of(context).size.width * 0.068,
          bottom: 7,
          right: MediaQuery.of(context).size.width * 0.05),
      child: ListTile(
        onTap: () {
          onSubmit!();
        },
        dense: true,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // CircleAvatar(
            //   radius: 22,
            Container(
              child: icon,
            ),
            // ),
          ],
        ),
        title: Text(
          text,
          style: TextStyle(
              color: AppTheme.brownishGrey,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppTheme.brownishGrey,
          size: 30,
        ),
      ),
    );
  }
}
