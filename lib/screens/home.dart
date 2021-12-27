import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
// import 'package:urbanledger/Models/routeArgs.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Cubits/ImportContacts/import_contacts_cubit.dart';
import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Models/user_model.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/chat_module/data/models/message.dart';
import 'package:urbanledger/chat_module/data/repositories/chat_repository.dart';
import 'package:urbanledger/chat_module/screens/contact/contact_controller.dart';
import 'package:urbanledger/chat_module/screens/home/home_controller.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/Components/shimmer_widgets.dart';
import 'package:urbanledger/screens/TransactionScreens/ReceiveTransaction/receive_transaction_screen.dart';
import 'package:urbanledger/screens/TransactionScreens/add_cards_provider.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:uuid/uuid.dart';

import 'Components/custom_bottom_nav_bar_new.dart';
import 'Components/custom_popup.dart';
import 'TransactionScreens/pay_recieve.dart';
import 'TransactionScreens/pay_transaction.dart';
import 'mobile_analytics/analytics_events.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late HomeController _homeController;
  final Repository repository = Repository();

  int _selectedSortOption = 1;
  int _selectedFilterOption = 1;
  final TextEditingController _searchController = TextEditingController();
  bool hideFilterString = true;
  //ContactController _contactController;
  double animatedHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _homeController = HomeController(context: context);
    calculatePremiumDate();
    getAllCards();

    debugPrint('KYC STATUS : ' +
        Repository().hiveQueries.userData.kycStatus.toString());
    debugPrint('Premium STATUS : ' +
        Repository().hiveQueries.userData.premiumStatus.toString());
    //getKyc();
    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        animatedHeight = 14;
      });
    });

    // _contactController = ContactController(
    //   context: context,
    // );
  }

  bool isEmiratesIdDone = false;
  bool isTradeLicenseDone = false;
  bool status = false;
  bool isPremium = false;
  bool loading = false;
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
  //                               : 'KYC is a mandatory step for\npremium feature.',
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

  // modalSheet() {
  //   return showModalBottomSheet(
  //       context: context,
  //       isDismissible: true,
  //       enableDrag: true,
  //       builder: (context) {
  //         return Container(
  //           color: Color(0xFF737373), //could change this to Color(0xFF737373),
  //           height: (Repository().hiveQueries.userData.kycStatus == 1)
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
  //                   child: (Repository().hiveQueries.userData.kycStatus == 1 &&
  //                           Repository().hiveQueries.userData.premiumStatus ==
  //                               0)
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
  //                 if (Repository().hiveQueries.userData.kycStatus != 1)
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
  //                   child: (Repository().hiveQueries.userData.kycStatus == 1)
  //                       ? NewCustomButton(
  //                           onSubmit: () {
  //                             Navigator.pop(context);
  //                           },
  //                           textColor: Colors.white,
  //                           text: 'OKAY',
  //                           textSize: 14,
  //                         )
  //                       : (Repository().hiveQueries.userData.kycStatus != 1 &&
  //                               Repository()
  //                                       .hiveQueries
  //                                       .userData
  //                                       .premiumStatus !=
  //                                   0)
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

  Future getKyc() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    await KycAPI.kycApiProvider.kycCheker().catchError((e) {
      // Navigator.of(context).pop();
      setState(() {
        loading = false;
      });
      'Something went wrong. Please try again later.'.showSnackBar(context);
    }).then((value) {
      debugPrint('Check the value : ' + value['status'].toString());

      if (value != null && value.toString().isNotEmpty) {
        if (mounted) {
          setState(() {
            Repository().hiveQueries.insertUserData(Repository()
                .hiveQueries
                .userData
                .copyWith(
                    kycStatus:
                        (value['emirates'] == true && value['tl'] == true) &&
                                value['isVerified'] == false
                            ? 2
                            : (value['isVerified'] == true &&
                                    value['status'] == true)
                                ? 1
                                : 0,
                    premiumStatus:
                        value['planDuration'].toString() == 0.toString()
                            ? 0
                            : int.tryParse(value['planDuration']),
                    isEmiratesIdDone: value['emirates'] ?? false,
                    isTradeLicenseDone: value['tl'] ?? false,
                    paymentLink: value['link'] ?? ''));

            // Need to set emirates iD and TradeLicense ID Values
            // isEmiratesIdDone = value['emirates'] ?? false;
            // isTradeLicenseDone = value['tl'] ?? false;
            // status = value['status'] ?? false;
            // isPremium = value['premium'] ?? false;
            // debugPrint('check1' + status.toString());
            // debugPrint('check' + isEmiratesIdDone.toString());
          });
          return true;
        }
      }
    });
    calculatePremiumDate();

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  getAllCards() async {
    Provider.of<AddCardsProvider>(context, listen: false).getCard();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _homeController.dispose();
    // _contactController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _homeController.initProvider();
    // _contactController.initProvider();
    super.didChangeDependencies();
  }

  Future<bool> exitAppDialog(BuildContext context) async {
    debugPrint('qwert');
    return (await showDialog(
          context: context,
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Dialog(
                insetPadding: EdgeInsets.only(left: 20, right: 20, bottom: 35),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0, bottom: 0),
                      child: CustomText(
                        'Do you want to exit app?',
                        color: AppTheme.tomato,
                        bold: FontWeight.w500,
                        size: 18,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: AppTheme.electricBlue,
                                ),
                                child: CustomText(
                                  'YES',
                                  color: Colors.white,
                                  size: (18),
                                  bold: FontWeight.w500,
                                ),
                                onPressed: () {
                                  if (Platform.isAndroid) {
                                    SystemNavigator.pop();
                                  } else if (Platform.isIOS) {
                                    exit(0);
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: AppTheme.electricBlue,
                                ),
                                child: CustomText(
                                  'NO',
                                  color: Colors.white,
                                  size: (18),
                                  bold: FontWeight.w500,
                                ),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  GlobalKey _scaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: _onWillPop,
      onWillPop: () {
        return exitAppDialog(context);
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          key: _scaffold,
          floatingActionButton: ValueListenableBuilder(
              valueListenable: isCustomerAddedNotifier,
              builder: (context, dynamic value, child) {
                if (Provider.of<BusinessProvider>(context, listen: false)
                    .businesses
                    .isNotEmpty)
                  return FutureBuilder<List<CustomerModel>>(
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
                                    var anaylticsEvents =
                                        AnalyticsEvents(context);
                                    await anaylticsEvents.initCurrentUser();
                                    await anaylticsEvents
                                        .sendRecieveButtonEvent();
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
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
                      });
                return Image.asset(
                  AppAssets.switchGreen,
                  scale: 1,
                  height: 75,
                );
              }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          backgroundColor: AppTheme.paleGrey,
          extendBody: true,
          bottomNavigationBar: CustomBottomNavBarNew(),
          body: Container(
            height: deviceHeight,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                color: Color(0xfff2f1f6),
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('assets/images/back.png'),
                    alignment: Alignment.topCenter)),
            child: loading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      (MediaQuery.of(context).padding.top).heightBox,
                      BlocBuilder<ContactsCubit, ContactsState>(
                        buildWhen: (state1, state2) {
                          return true;
                        },
                        builder: (context, state) {
                          if (state is FetchedContacts) {
                            if (state.customerList.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    appBar,
                                    const PayReceiveButtons(
                                      isCustomerEmpty: true,
                                    ),
                                    reportButton(true),
                                    // CustomSearchBar(
                                    //   CtextFormField: TextFormField(
                                    //     // textAlignVertical: TextAlignVertical.center,
                                    //     controller: _searchController,
                                    //     onChanged: (value) {
                                    //       BlocProvider.of<ContactsCubit>(context)
                                    //           .searchContacts(value);
                                    //     },
                                    //     style: TextStyle(
                                    //       fontSize: 17,
                                    //       color: AppTheme.brownishGrey,
                                    //     ),
                                    //     cursorColor: AppTheme.brownishGrey,
                                    //     decoration: InputDecoration(
                                    //         // contentPadding: EdgeInsets.only(top: 15),
                                    //         border: InputBorder.none,
                                    //         hintText: 'Search Customers, Name, phone',
                                    //         hintStyle: TextStyle(
                                    //             color: Color(0xffb6b6b6),
                                    //             fontSize: 17,
                                    //             fontWeight: FontWeight.w500)),
                                    //   ),
                                    //   Suffix: Column(
                                    //     children: [
                                    //       GestureDetector(
                                    //         child: Padding(
                                    //           padding: EdgeInsets.only(right: 15.0),
                                    //           child: Image.asset(
                                    //             AppAssets.filterIcon,
                                    //             color: AppTheme.brownishGrey,
                                    //             height: 18,
                                    //             // scale: 1.5,
                                    //           ),
                                    //         ),
                                    //         onTap: () async {
                                    //           await filterBottomSheet;
                                    //           setState(() {
                                    //             hideFilterString = false;
                                    //           });
                                    //         },
                                    //       ),
                                    //       Positioned(
                                    //         right: 14,
                                    //         top: -3,
                                    //         child: ClipRRect(
                                    //           borderRadius: BorderRadius.circular(25),
                                    //           child: Container(
                                    //             color: AppTheme.tomato,
                                    //             height: 9,
                                    //             width: 9,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    searchField(1, 1),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16, top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Customers List (0)',
                                            style: TextStyle(
                                                color: Color(0xff666666),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Container(
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Color(0xff1058ff)),
                                                  shape: MaterialStateProperty
                                                      .all<OutlinedBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                  )),
                                                  elevation:
                                                      MaterialStateProperty.all<
                                                          double>(0)),
                                              child: SvgPicture.asset(
                                                AppAssets.addCustomerIcon,
                                                height: 24,
                                                width: 24,
                                              ),
                                              onPressed: () async {
                                                // if (BlocProvider.of<
                                                //                 ImportContactsCubit>(
                                                //             context)
                                                //         .state
                                                //         .runtimeType ==
                                                //     SearchedImportedContacts)
                                                //   BlocProvider.of<
                                                //               ImportContactsCubit>(
                                                //           context)
                                                //       .searchImportedContacts(
                                                //           '');
                                                // Navigator.of(context).pushNamed(
                                                //     AppRoutes.addCustomerRoute);
                                                // bool isBankAccount = (await CustomSharedPreferences.get("isBankAccount"));
                                                //     debugPrint(isBankAccount.toString());
                                                // Navigator.of(context).pushNamed(
                                                //     AppRoutes.introscreenRoute);
                                                debugPrint(repository.hiveQueries.unAuthData.seen.toString());
                                              },
                                            ),
                                          ),

                                          // Image.asset(
                                          //   'assets/icons/link.png',
                                          //   scale: 1.2,
                                          // ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                          ).flexible,
                                          Image.asset(
                                            'assets/images/addYourFirstCustomer.png',
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                          ),
                                          Center(
                                            child: CustomText(
                                              'Start adding your\n first customer',
                                              color: AppTheme.brownishGrey,
                                              size: 22,
                                              centerAlign: true,
                                              bold: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ).flexible,
                                  ],
                                ),
                              );
                            }
                            _selectedSortOption = 1;
                            _selectedFilterOption = 1;
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: customerListWithOtherWidgets(
                                  state.customerList,
                                  _selectedFilterOption,
                                  _selectedSortOption),
                            );
                          }
                          if (state is SearchedContacts) {
                            // hideFilterString = false;
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: customerListWithOtherWidgets(
                                  state.searchedCustomerList,
                                  state.selectedFilter,
                                  state.selectedSort),
                            );
                          }
                          if (state is ContactsInitial) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                ),
                                ShimmerButton(),
                                ShimmerButton(),
                                ShimmerButton(),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ShimmerText(),
                                      ShimmerText(),
                                      // Container(
                                      //   child: ElevatedButton(
                                      //     style: ButtonStyle(
                                      //         backgroundColor:
                                      //             MaterialStateProperty.all<
                                      //                 Color>(Color(0xff1058ff)),
                                      //         shape: MaterialStateProperty.all<
                                      //                 OutlinedBorder>(
                                      //             RoundedRectangleBorder(
                                      //           borderRadius:
                                      //               BorderRadius.circular(24),
                                      //         )),
                                      //         elevation: MaterialStateProperty
                                      //             .all<double>(0)),
                                      //     child: SvgPicture.asset(
                                      //       AppAssets.addCustomerIcon,
                                      //       height: 24,
                                      //       width: 24,
                                      //     ),
                                      //     onPressed: () async {
                                      //     },
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ShimmerListTile(),
                                ShimmerListTile(),
                                ShimmerListTile(),
                              ],
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ).flexible,
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget customerListWithOtherWidgets(
      List<CustomerModel> customerList, filterIndex, sortIndex) {
    print(filterIndex);
    return Column(
      children: [
        appBar,
        payReceiveButtons(false),
        reportButton(false),
        searchField(filterIndex ?? 1, sortIndex ?? 1),
        if (!hideFilterString)
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 15),
            child: Container(
              decoration: BoxDecoration(
                  color: AppTheme.carolinaBlue.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      'Showing list of ${getFilterString(filterIndex)} as ${getSortString(sortIndex)}',
                      color: AppTheme.brownishGrey,
                      size: 16,
                    ),
                    GestureDetector(
                      child:
                          Icon(Icons.close_sharp, color: AppTheme.brownishGrey),
                      onTap: () {
                        _selectedFilterOption = 1;
                        _selectedSortOption = 1;
                        BlocProvider.of<ContactsCubit>(context)
                            .filterContacts(1, 1);
                        setState(() {
                          hideFilterString = true;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Customers List (${customerList.length})',
                style: TextStyle(
                    color: Color(0xff666666),
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xff1058ff)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      )),
                      elevation: MaterialStateProperty.all<double>(0)),
                  child: SvgPicture.asset(
                    AppAssets.addCustomerIcon,
                    height: 24,
                    width: 24,
                  ),
                  onPressed: () async {
                    // if (BlocProvider.of<ImportContactsCubit>(context)
                    //         .state
                    //         .runtimeType ==
                    //     SearchedImportedContacts)
                    //   BlocProvider.of<ImportContactsCubit>(context)
                    //       .searchImportedContacts('');
                    // Navigator.of(context).pushNamed(AppRoutes.addCustomerRoute);
                    // final loginTime =
                    //     repository.hiveQueries.unAuthData.loginTime;
                    // final diff = DateTime.now().difference(loginTime!).inDays;
                    // debugPrint(diff.toString());
                    debugPrint(repository.hiveQueries.unAuthData.seen.toString());
                  },
                ),
              ),
              // InkWell(
              //   onTap: () async {
              //     // final path =
              //     //     await CustomerReportPdfGenerator(customerList).savePdf();
              //     // Navigator.of(context)
              //     //     .pushNamed(AppRoutes.pdfPreviewScreen, arguments: path);
              //   },
              //   child: Image.asset(
              //     'assets/icons/link.png',
              //     scale: 1.2,
              //   ),
              // ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        CustomerListWidget(customerList)
      ],
    );
  }

  Widget searchField(int filterIndex, int sortIndex) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.only(
            top: 5,
            bottom: 5,
          ),
          elevation: 3,
          child: Container(
            // width: MediaQuery.of(context).size.width * 0.92,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Image.asset(
                    AppAssets.searchIcon,
                    color: AppTheme.brownishGrey,
                    height: 20,
                    scale: 1.4,
                  ),
                ),
                Container(
                  width: screenWidth(context) * 0.7,
                  child: TextFormField(
                    // textAlignVertical: TextAlignVertical.center,
                    controller: _searchController,
                    onChanged: (value) {
                      BlocProvider.of<ContactsCubit>(context)
                          .searchContacts(value);
                    },
                    style: TextStyle(
                      fontSize: 17,
                      color: AppTheme.brownishGrey,
                    ),
                    cursorColor: AppTheme.brownishGrey,
                    decoration: InputDecoration(
                        // contentPadding: EdgeInsets.only(top: 15),
                        border: InputBorder.none,
                        hintText: 'Search Customer',
                        hintStyle: TextStyle(
                            color: Color(0xffb6b6b6),
                            fontSize: 17,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Image.asset(
                          AppAssets.filterIcon,
                          color: AppTheme.brownishGrey,
                          height: 18,
                          // scale: 1.5,
                        ),
                      ),
                      onTap: () async {
                        await filterBottomSheet;
                        if (_selectedFilterOption != 1 ||
                            _selectedSortOption != 1)
                          setState(() {
                            hideFilterString = false;
                          });
                      },
                    ),
                    if (filterIndex != 1 || sortIndex != 1)
                      Positioned(
                        right: 14,
                        top: -3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            color: AppTheme.tomato,
                            height: 9,
                            width: 9,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

//GestureDetector(
//                       child: Padding(
//                         padding: EdgeInsets.only(right: 15.0),
//                         child: Image.asset(
//                           AppAssets.filterIcon,
//                           color: AppTheme.brownishGrey,
//                           height: 18,
//                           // scale: 1.5,
//                         ),
//                       ),
//                       onTap: () async {
//                         await filterBottomSheet;
//                         setState(() {
//                           hideFilterString = false;
//                         });
//                       },
//                     ),
//                     Positioned(
//                       right: 14,
//                       top: -3,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(25),
//                         child: Container(
//                           color: AppTheme.tomato,
//                           height: 9,
//                           width: 9,
//                         ),
//                       ),
//                     ),
  Widget get appBar => ValueListenableBuilder<Box?>(
        valueListenable: repository.hiveQueries.userBox.listenable(),
        builder: (context, box, _) => box == null
            ? Container()
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Row(
                  children: [
                    Container(
                        // padding: EdgeInsets.all(2),
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(99),
                        //   color: Colors.white,
                        // ),
                        child: ((box.get('UserData') as SignUpModel?)
                                    ?.profilePic
                                    .isEmpty ??
                                true)
                            ? CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white.withOpacity(0.5),
                                backgroundImage:
                                    AssetImage('assets/icons/my-account.png'))
                            : CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white.withOpacity(0.5),
                                backgroundImage: FileImage(File(
                                    (box.get('UserData') as SignUpModel)
                                        .profilePic)))),
                    15.0.widthBox,
                    InkWell(
                      onTap: ((Repository().hiveQueries.userData.kycStatus !=
                                  1) ||
                              (Repository()
                                      .hiveQueries
                                      .userData
                                      .premiumStatus ==
                                  0))
                          ? () async {
                              print("Premium Status " +
                                  repository.hiveQueries.userData.premiumStatus
                                      .toString());
                              debugPrint('qwerty2');
                              debugPrint('KYC STATUS: ' +
                                  Repository()
                                      .hiveQueries
                                      .userData
                                      .kycStatus
                                      .toString());
                              if (Repository().hiveQueries.userData.kycStatus ==
                                  2) {
                                await getKyc();
                                MerchantBankNotAdded.showBankNotAddedDialog(
                                    _scaffold.currentState!.context,
                                    'userKYCVerificationPending');
                              } else if (Repository()
                                      .hiveQueries
                                      .userData
                                      .kycStatus ==
                                  0) {
                                setState(() {
                                  loading = true;
                                });
                                //KYC WHEN USER STARTS A NEW KYC JOURNEY
                                MerchantBankNotAdded.showBankNotAddedDialog(
                                        context, 'userKYCPending')
                                    .then((value) => setState(() {
                                          loading = false;
                                        }));
                              } else if (Repository()
                                          .hiveQueries
                                          .userData
                                          .kycStatus ==
                                      0 &&
                                  Repository()
                                          .hiveQueries
                                          .userData
                                          .isEmiratesIdDone ==
                                      false) {
                                setState(() {
                                  loading = true;
                                });
                                //KYC WHEN USER STARTS EMirates ID Journey but not done TRade License
                                MerchantBankNotAdded.showBankNotAddedDialog(
                                        context, 'EmiratesIdPending')
                                    .then((value) => setState(() {
                                          loading = false;
                                        }));
                              } else if (Repository()
                                          .hiveQueries
                                          .userData
                                          .kycStatus ==
                                      0 &&
                                  Repository()
                                          .hiveQueries
                                          .userData
                                          .isTradeLicenseDone ==
                                      false) {
                                setState(() {
                                  loading = true;
                                });
                                //KYC WHEN USER STARTS EMirates ID Journey but not done TRade License
                                MerchantBankNotAdded.showBankNotAddedDialog(
                                        context, 'TradeLicensePending')
                                    .then((value) => setState(() {
                                          loading = false;
                                        }));
                              } else if (Repository()
                                          .hiveQueries
                                          .userData
                                          .kycStatus ==
                                      1 &&
                                  Repository()
                                          .hiveQueries
                                          .userData
                                          .premiumStatus ==
                                      0) {
                                setState(() {
                                  loading = true;
                                });
                                MerchantBankNotAdded.showBankNotAddedDialog(
                                        context, 'upgradePremium')
                                    .then((value) => setState(() {
                                          loading = false;
                                        }));
                              } else {
                                switchBusinessSheet;
                              }
                            }
                          : () {
                              switchBusinessSheet;
                            },
                      child: Container(
                        // width: screenWidth(context) * 0.5,
                        // color: Colors.amber,
                        constraints: BoxConstraints(
                            maxWidth: screenWidth(context) * 0.5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Consumer<BusinessProvider>(
                                  builder: (context, value, child) {
                                    return Flexible(
                                      child: CustomText(
                                        '${value.selectedBusiness.businessName}',
                                        color: Colors.white,
                                        size: 19,
                                        bold: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  },
                                ),
                                AnimatedSize(
                                  vsync: this,
                                  duration: Duration(seconds: 2),
                                  curve: Curves.easeInBack,
                                  // height: animatedHeight,
                                  child: animatedHeight == 0.0
                                      ? Container()
                                      : CustomText(
                                          'Switch Ledger',
                                          size: 14,
                                          color: Colors.white,
                                          bold: FontWeight.w400,
                                          overflow: TextOverflow.fade,
                                        ),
                                )
                              ],
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 28,
                            )
                          ],
                        ),
                      ),
                    ),
                    //  Spacer(),
                    // Container(
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       InkWell(
                    //         onTap: () {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => UrbanSalary()),
                    //           );
                    //         },
                    //         child: Image.asset(
                    //           'assets/icons/refer-friend.png',
                    //           height: 40,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ],
                  /* trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/icons/currency.png',
                          height: 28,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/icons/settings.png',
                          height: 28,
                        ),
                      )
                    ],
                  ), */
                ),
              ),
      );

  Widget reportButton(bool isCustomerEmpty) => Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: double.infinity, height: 45,

        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(20),
        //   color: Colors.white,
        // ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              primary: Colors.white,
            ),
            onPressed: isCustomerEmpty
                ? () {}
                : () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.customerReportRoute,
                    );
                  },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  isCustomerEmpty
                      ? 'assets/icons/greydoc.png'
                      : 'assets/icons/Document-01.png',
                  height: 26,
                ),
                SizedBox(width: 5),
                CustomText(
                  'View Report',
                  bold: FontWeight.w500,
                  color: isCustomerEmpty
                      ? AppTheme.greyish
                      : AppTheme.brownishGrey,
                  size: 16,
                ),
              ],
            )),
      );

  Widget payReceiveButtons(bool isCustomerEmpty) => FutureBuilder<List<double>>(
      future: repository.queries.getTotalPayReceiveForCustomer(
          Provider.of<BusinessProvider>(context, listen: false)
              .selectedBusiness
              .businessId),
      builder: (context, snapshot) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(6, 5, 6, 0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: IntrinsicHeight(
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  Expanded(
                    child: Container(
                      // width: size.width * 0.425,
                      // height: 95.r,
                      padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: MediaQuery.of(context).size.height * .015),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image.asset(
                          //   isCustomerEmpty
                          //       ? AppAssets.payIconDeactivated
                          //       : AppAssets.payIconActive,
                          //   height: 35,
                          // ),
                          // SizedBox(
                          //   width: 5,
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(text: '', children: [
                                    WidgetSpan(
                                      child: Image.asset(
                                        AppAssets.giveIcon,
                                        height: 18,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' You will Give',
                                      style: TextStyle(
                                        color: isCustomerEmpty
                                            ? AppTheme.greyish
                                            : AppTheme.brownishGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ])),
                              SizedBox(
                                height: 5,
                              ),
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    text: '$currencyAED ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: isCustomerEmpty
                                            ? AppTheme.greyish
                                            : AppTheme.tomato,
                                        fontWeight: FontWeight.w600),
                                    children: [
                                      TextSpan(
                                          text: isCustomerEmpty
                                              ? '0'
                                              : snapshot.data != null
                                                  ? (snapshot.data!.last)
                                                      .getFormattedCurrency
                                                      .replaceAll('-', '')
                                                  : '0',
                                          // text: '46151830',
                                          style: TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                              )
                            ],
                          ).flexible,
                        ],
                      ),
                    ),
                  ),
                  // (screenWidth(context) * 0.01).widthBox,
                  VerticalDivider(
                    color: AppTheme.brownishGrey,
                    indent: 10,
                    endIndent: 10,
                  ),
                  Expanded(
                    child: Container(
                      // width: size.width * 0.425,
                      // height: 95.r,
                      padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: MediaQuery.of(context).size.height * .015),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Image.asset(
                          //   isCustomerEmpty
                          //       ? AppAssets.receiveIconDeactivated
                          //       : AppAssets.receiveIconActive,
                          //   height: 55,
                          // ),
                          // SizedBox(
                          //   width: 5,
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // CustomText(
                              //   'You will Get',
                              //   color: isCustomerEmpty
                              //       ? AppTheme.greyish
                              //       : AppTheme.brownishGrey,
                              //   bold: FontWeight.w500,
                              //   size: 16,
                              // ),
                              RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(text: '', children: [
                                    WidgetSpan(
                                      child: Image.asset(
                                        AppAssets.getIcon,
                                        height: 18,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' You will Get',
                                      style: TextStyle(
                                        color: isCustomerEmpty
                                            ? AppTheme.greyish
                                            : AppTheme.brownishGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    )
                                  ])),
                              SizedBox(
                                height: 5,
                              ),
                              FittedBox(
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      text: '$currencyAED ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: isCustomerEmpty
                                              ? AppTheme.greyish
                                              : AppTheme.greenColor,
                                          fontWeight: FontWeight.w600),
                                      children: [
                                        TextSpan(
                                            text: isCustomerEmpty
                                                ? '0'
                                                : snapshot.data != null
                                                    ? (snapshot.data!.first)
                                                        .getFormattedCurrency
                                                        .replaceAll('-', '')
                                                    : '0',
                                            // text: '46151830',
                                            style: TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                ),
                              )
                            ],
                          ).flexible,
                        ],
                      ),
                    ),
                  ),
                ])),
          ),
        );
      });

  Future<void> get switchBusinessSheet async {
    await showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            constraints: BoxConstraints(maxHeight: 400),
            decoration: BoxDecoration(
                color: AppTheme.justWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            // height: 400,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        /*  Image.asset(
                          AppAssets.appIcon,
                          width: 40,
                          height: 40,
                        ), */
                        10.0.widthBox,

                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // width: screenWidth(context) * 0.35,
                                child: CustomText(
                                  Provider.of<BusinessProvider>(context,
                                          listen: false)
                                      .selectedBusiness
                                      .businessName,
                                  bold: FontWeight.w600,
                                  color: Theme.of(context).primaryColor,
                                  size: 18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              FutureBuilder<int>(
                                  future: repository.queries.getCustomerCount(
                                      Provider.of<BusinessProvider>(context,
                                              listen: false)
                                          .selectedBusiness
                                          .businessId),
                                  builder: (context, snapshot) {
                                    return Container(
                                      // width: screenWidth(context) * 0.35,
                                      child: CustomText(
                                        '${snapshot.data} ${snapshot.data == 1 ? 'Customer' : 'Customers'}',
                                        bold: FontWeight.w400,
                                        color: AppTheme.brownishGrey,
                                        size: 14,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: FutureBuilder<List<double>>(
                              future: repository.queries
                                  .getTotalPayReceiveForCustomer(
                                      Provider.of<BusinessProvider>(context,
                                              listen: false)
                                          .selectedBusiness
                                          .businessId),
                              builder: (context, snapshot) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      // width: screenWidth(context) * 0.24,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Transform.rotate(
                                                angle: 0,
                                                child: Image.asset(
                                                  AppAssets.giveIcon,
                                                  height: 18,
                                                ),
                                              ),
                                              CustomText(
                                                'You will Give',
                                                size: 14,
                                                bold: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                          CustomText(
                                            '$currencyAED',
                                            size: 14,
                                            bold: FontWeight.w700,
                                            color: AppTheme.tomato,
                                          ),
                                          CustomText(
                                            snapshot.data != null
                                                ? (snapshot.data!.last)
                                                    .getFormattedCurrency
                                                    .replaceAll('-', '')
                                                : '0',
                                            bold: FontWeight.w700,
                                            color: AppTheme.tomato,
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    SizedBox(
                                      // width: screenWidth(context) * 0.24,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Transform.rotate(
                                                angle: 0,
                                                child: Image.asset(
                                                  AppAssets.getIcon,
                                                  height: 18,
                                                ),
                                              ),
                                              CustomText(
                                                'You will Get',
                                                size: 14,
                                                bold: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                          CustomText(
                                            '$currencyAED',
                                            size: 14,
                                            color: AppTheme.greenColor,
                                            bold: FontWeight.w700,
                                          ),
                                          CustomText(
                                            snapshot.data != null
                                                ? (snapshot.data!.first)
                                                    .getFormattedCurrency
                                                    .replaceAll('-', '')
                                                : '0',
                                            color: AppTheme.greenColor,
                                            bold: FontWeight.w700,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        )

                        // Spacer(),
                        // Radio(value: true, groupValue: true, onChanged: (_) {}),
                      ],
                    )),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      Provider.of<BusinessProvider>(context, listen: false)
                          .businesses
                          .length,
                  itemBuilder: (BuildContext context, int index) {
                    if (Provider.of<BusinessProvider>(context, listen: false)
                            .businesses[index] ==
                        Provider.of<BusinessProvider>(context, listen: false)
                            .selectedBusiness) return Container();
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _selectedSortOption = 1;
                        _selectedFilterOption = 1;
                        Navigator.of(context).pop();
                        Provider.of<BusinessProvider>(context, listen: false)
                            .updateSelectedBusiness(index: index);
                        print('business Id' +
                            Provider.of<BusinessProvider>(context,
                                    listen: false)
                                .selectedBusiness
                                .businessId);
                        BlocProvider.of<ContactsCubit>(context).getContacts(
                            Provider.of<BusinessProvider>(context,
                                    listen: false)
                                .selectedBusiness
                                .businessId);
                        (Provider.of<BusinessProvider>(context, listen: false)
                                    .selectedBusiness
                                    .businessName +
                                ' is now selected as your active ledger')
                            .showSnackBar(context);
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            children: [
                              /* Image.asset(
                                AppAssets.appIcon,
                                width: 40,
                                height: 40,
                              ), */
                              10.0.widthBox,
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: screenWidth(context) * 0.5,
                                      child: CustomText(
                                        Provider.of<BusinessProvider>(context,
                                                listen: false)
                                            .businesses[index]
                                            .businessName,
                                        bold: FontWeight.w600,
                                        color: Theme.of(context).primaryColor,
                                        size: 18,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    FutureBuilder<int>(
                                        future: repository.queries
                                            .getCustomerCount(
                                                Provider.of<BusinessProvider>(
                                                        context,
                                                        listen: false)
                                                    .businesses[index]
                                                    .businessId),
                                        builder: (context, snapshot) {
                                          return CustomText(
                                            '${snapshot.data} ${snapshot.data == 1 ? 'Customer' : 'Customers'}',
                                            bold: FontWeight.w400,
                                            color: AppTheme.brownishGrey,
                                            size: 14,
                                          );
                                        }),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 9,
                                child: FutureBuilder<List<double>>(
                                    future: repository.queries
                                        .getTotalPayReceiveForCustomer(
                                            Provider.of<BusinessProvider>(
                                                    context,
                                                    listen: false)
                                                .businesses[index]
                                                .businessId),
                                    builder: (context, snapshot) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            // width: screenWidth(context) * 0.24,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Transform.rotate(
                                                      angle: 0,
                                                      child: Image.asset(
                                                        AppAssets.giveIcon,
                                                        height: 18,
                                                      ),
                                                    ),
                                                    CustomText(
                                                      'You will Give',
                                                      size: 14,
                                                      bold: FontWeight.w500,
                                                    ),
                                                  ],
                                                ),
                                                CustomText(
                                                  '$currencyAED',
                                                  size: 14,
                                                  bold: FontWeight.w700,
                                                  color: AppTheme.tomato,
                                                ),
                                                CustomText(
                                                  snapshot.data != null
                                                      ? (snapshot.data!.last)
                                                          .getFormattedCurrency
                                                          .replaceAll('-', '')
                                                      : '0',
                                                  bold: FontWeight.w700,
                                                  color: AppTheme.tomato,
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          SizedBox(
                                            // width: screenWidth(context) * 0.24,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Transform.rotate(
                                                      angle: 0,
                                                      child: Image.asset(
                                                        AppAssets.getIcon,
                                                        height: 18,
                                                      ),
                                                    ),
                                                    CustomText(
                                                      'You will Get',
                                                      size: 14,
                                                      bold: FontWeight.w500,
                                                    ),
                                                  ],
                                                ),
                                                CustomText(
                                                  '$currencyAED',
                                                  size: 14,
                                                  color: AppTheme.greenColor,
                                                  bold: FontWeight.w700,
                                                ),
                                                CustomText(
                                                  snapshot.data != null
                                                      ? (snapshot.data!.first)
                                                          .getFormattedCurrency
                                                          .replaceAll('-', '')
                                                      : '0',
                                                  color: AppTheme.greenColor,
                                                  bold: FontWeight.w700,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              )
                              // Spacer(),
                              // Icon(
                              //   Icons.arrow_forward_ios_rounded,
                              //   size: 20,
                              //   color: AppTheme.brownishGrey,
                              // ),
                              // 8.0.widthBox
                            ],
                          )),
                    );
                  },
                ).flexible,
                // Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.only(bottom: isPlatformiOS() ? 20 : 0),
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: CustomText('Create a new Ledger'.toUpperCase(),
                          color: Colors.white, size: 18, bold: FontWeight.w500),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pushNamed(AppRoutes.addLedgerRoute);
                      }),
                ),
                15.0.heightBox
              ],
            ),
          );
        });
      },
    );
  }

  Future<void> get filterBottomSheet async {
    int selectedFilter = _selectedFilterOption;
    int selectedSort = _selectedSortOption;

    await showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(
                color: AppTheme.justWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            height: 570,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          'Filter by',
                          size: 20,
                          bold: FontWeight.w600,
                          color: AppTheme.brownishGrey,
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.close_sharp,
                            color: AppTheme.greyish,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0, bottom: 12),
                    child: Wrap(
                      spacing: 20,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: selectedFilter == 1
                                ? AppTheme.electricBlue
                                : AppTheme.justWhite,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppTheme.electricBlue),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: CustomText(
                              'All',
                              bold: FontWeight.w500,
                              color: selectedFilter == 1
                                  ? Colors.white
                                  : AppTheme.brownishGrey,
                            ),
                          ),
                          onPressed: () {
                            if (selectedFilter != 1)
                              setState(() {
                                selectedFilter = 1;
                              });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: selectedFilter == 2
                                ? AppTheme.electricBlue
                                : AppTheme.justWhite,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppTheme.electricBlue),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: CustomText(
                              'YOU WILL GET',
                              bold: FontWeight.w500,
                              color: selectedFilter == 2
                                  ? Colors.white
                                  : AppTheme.brownishGrey,
                            ),
                          ),
                          onPressed: () {
                            if (selectedFilter != 2)
                              setState(() {
                                selectedFilter = 2;
                              });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: selectedFilter == 3
                                ? AppTheme.electricBlue
                                : AppTheme.justWhite,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppTheme.electricBlue),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: CustomText(
                              'You will GIVE'.toUpperCase(),
                              bold: FontWeight.w500,
                              color: selectedFilter == 3
                                  ? Colors.white
                                  : AppTheme.brownishGrey,
                            ),
                          ),
                          onPressed: () {
                            if (selectedFilter != 3)
                              setState(() {
                                selectedFilter = 3;
                              });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: selectedFilter == 4
                                ? AppTheme.electricBlue
                                : AppTheme.justWhite,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppTheme.electricBlue),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: CustomText(
                              'NOTHING PENDING',
                              bold: FontWeight.w500,
                              color: selectedFilter == 4
                                  ? Colors.white
                                  : AppTheme.brownishGrey,
                            ),
                          ),
                          onPressed: () {
                            if (selectedFilter != 4)
                              setState(() {
                                selectedFilter = 4;
                              });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: CustomText(
                      'Sort by',
                      size: 20,
                      bold: FontWeight.w600,
                      color: AppTheme.brownishGrey,
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            'Most Recent',
                            size: 16,
                            bold: FontWeight.w500,
                            color: AppTheme.brownishGrey,
                          ),
                          Radio(
                            groupValue: selectedSort,
                            value: 1,
                            onChanged: (dynamic value) {
                              setState(() {
                                selectedSort = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            'Highest Amount',
                            size: 16,
                            bold: FontWeight.w500,
                            color: AppTheme.brownishGrey,
                          ),
                          Radio(
                            groupValue: selectedSort,
                            value: 2,
                            onChanged: (dynamic value) {
                              setState(() {
                                selectedSort = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            'By Name (A-Z)',
                            size: 16,
                            bold: FontWeight.w500,
                            color: AppTheme.brownishGrey,
                          ),
                          Radio(
                            groupValue: selectedSort,
                            value: 3,
                            onChanged: (dynamic value) {
                              setState(() {
                                selectedSort = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            'Oldest',
                            size: 16,
                            bold: FontWeight.w500,
                            color: AppTheme.brownishGrey,
                          ),
                          Radio(
                            groupValue: selectedSort,
                            value: 4,
                            onChanged: (dynamic value) {
                              setState(() {
                                selectedSort = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            'Least Amount',
                            size: 16,
                            bold: FontWeight.w500,
                            color: AppTheme.brownishGrey,
                          ),
                          Radio(
                            groupValue: selectedSort,
                            value: 5,
                            onChanged: (dynamic value) {
                              setState(() {
                                selectedSort = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppTheme.electricBlue,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        _selectedFilterOption = selectedFilter;
                        _selectedSortOption = selectedSort;
                        _searchController.clear();
                        BlocProvider.of<ContactsCubit>(context).filterContacts(
                            _selectedFilterOption, _selectedSortOption);
                        Navigator.of(context).pop();
                      },
                      child: CustomText(
                        'VIEW RESULT',
                        color: Colors.white,
                        size: (18),
                        bold: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  static String getFilterString(int index) {
    String filter;
    switch (index) {
      case 1:
        filter = 'All';
        break;
      case 2:
        filter = 'You will get';
        break;
      case 3:
        filter = 'You will give';
        break;
      case 4:
        filter = 'Nothing pending';
        break;
      default:
        filter = 'All';
        break;
    }
    return filter;
  }

  static String getSortString(int index) {
    String sort;
    switch (index) {
      case 1:
        sort = 'Most Recent';
        break;
      case 2:
        sort = 'Highest Amount';
        break;
      case 3:
        sort = 'By Name (A-Z)';
        break;
      case 4:
        sort = 'Oldest';
        break;
      case 5:
        sort = 'Least Amount';
        break;
      default:
        sort = 'Most Recent';
        break;
    }
    return sort;
  }
}

class CustomerListWidget extends StatefulWidget {
  final List<CustomerModel> _customerList;
  CustomerListWidget(
    this._customerList, {
    Key? key,
  }) : super(key: key);
  @override
  _CustomerListWidgetState createState() => _CustomerListWidgetState();
}

class _CustomerListWidgetState extends State<CustomerListWidget> {
  // static const List<Color> _colors = [
  //   Color.fromRGBO(137, 171, 249, 1),
  //   AppTheme.brownishGrey,
  //   AppTheme.greyish,
  //   AppTheme.electricBlue,
  //   AppTheme.carolinaBlue,
  // ];
  //
  // final Random random = Random();
  CustomerModel _customerModel = CustomerModel();
  ChatRepository _chatRepository = ChatRepository();
  final GlobalKey<State> key = GlobalKey<State>();

  merchantBankNotAddedModalSheet({text}) {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          return Container(
            color: Color(0xFF737373), //could change this to Color(0xFF737373),

            height: MediaQuery.of(context).size.height * 0.27,
            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              //height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                      left: 40.0,
                      right: 40.0,
                      bottom: 10,
                    ),
                    child: Text(
                      '$text',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppTheme.brownishGrey,
                          fontFamily: 'SFProDisplay',
                          fontSize: 18,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Please try again later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppTheme.tomato,
                          fontFamily: 'SFProDisplay',
                          fontSize: 18,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.w700,
                          height: 1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: NewCustomButton(
                      onSubmit: () {
                        Navigator.pop(context);
                      },
                      textColor: Colors.white,
                      text: 'OKAY',
                      textSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  bool isLoading = false;

  Future getKyc() async {
    setState(() {
      isLoading = true;
    });

    await KycAPI.kycApiProvider.kycCheker().catchError((e) {
      // Navigator.of(context).pop();
      setState(() {
        isLoading = false;
      });
      'Something went wrong. Please try again later.'.showSnackBar(context);
    }).then((value) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Check the value : ' + value['status'].toString());

      if (value != null && value.toString().isNotEmpty) {
        if (mounted) {
          setState(() {
            Repository().hiveQueries.insertUserData(Repository()
                .hiveQueries
                .userData
                .copyWith(
                    kycStatus:
                        (value['isVerified'] == true && value['status'] == true)
                            ? 1
                            : (value['emirates'] &&
                                    value['tl'] == true &&
                                    value['status'] == false)
                                ? 2
                                : 0,
                    premiumStatus:
                        value['planDuration'].toString() == 0.toString()
                            ? 0
                            : int.tryParse(value['planDuration']),
                    isEmiratesIdDone: value['emirates'] ?? false,
                    isTradeLicenseDone: value['tl'] ?? false,
                    paymentLink: value['link'] ?? ''));

            //TODO Need to set emirates iD and TradeLicense ID Values
            // isEmiratesIdDone = value['emirates'] ?? false;
            // isTradeLicenseDone = value['tl'] ?? false;
            // status = value['status'] ?? false;
            // isPremium = value['premium'] ?? false;

            // debugPrint('check1' + status.toString());
            // debugPrint('check' + isEmiratesIdDone.toString());
          });
          return;
        }
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.06),
      itemCount: widget._customerList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white),
          child: Dismissible(
            key: Key(widget._customerList[index].toString()),
            background: slideRightBackground(),
            secondaryBackground: slideLeftBackground(),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                debugPrint('right to left');
                CustomLoadingDialog.showLoadingDialog(context, key);
                if (await checkConnectivity) {
                  var cid = await repository.customerApi
                      .getCustomerID(
                          mobileNumber:
                              widget._customerList[index].mobileNo.toString())
                      .catchError((e) {
                    Navigator.of(context).pop();
                    'Something went wrong. Please try again later.'
                        .showSnackBar(context);
                  }).timeout(Duration(seconds: 30), onTimeout: () async {
                    Navigator.of(context).pop();
                    return Future.value(null);
                  });
                  bool? merchantSubscriptionPlan =
                      cid.customerInfo?.merchantSubscriptionPlan ?? false;
                  debugPrint(widget._customerList[index].mobileNo.toString());
                  debugPrint(widget._customerList[index].name);
                  debugPrint(widget._customerList[index].chatId);
                  debugPrint(cid.customerInfo?.id.toString());
                  _customerModel
                    ..name = getName(widget._customerList[index].name,
                        widget._customerList[index].mobileNo)
                    ..mobileNo = widget._customerList[index].mobileNo
                    ..ulId = cid.customerInfo?.id.toString()
                    ..avatar = widget._customerList[index].avatar
                    ..chatId = widget._customerList[index].chatId;
                  final localCustId = await repository.queries
                      .getCustomerId(widget._customerList[index].mobileNo!).catchError((e) {
                    Navigator.of(context).pop();
                    'Something went wrong. Please try again later.'
                        .showSnackBar(context);
                  })
                      .timeout(Duration(seconds: 30), onTimeout: () async {
                    Navigator.of(context).pop();
                    return Future.value(null);
                  });
                  final uniqueId = Uuid().v1();
                  if (localCustId.isEmpty) {
                    final customer = CustomerModel()
                      ..name = getName(widget._customerList[index].name!.trim(),
                          widget._customerList[index].mobileNo!)
                      ..mobileNo = (widget._customerList[index].mobileNo!)
                      ..avatar = widget._customerList[index].avatar
                      ..customerId = uniqueId
                      ..businessId =
                          Provider.of<BusinessProvider>(context, listen: false)
                              .selectedBusiness
                              .businessId
                      ..chatId = widget._customerList[index].chatId
                      ..isChanged = true;
                    await repository.queries
                        .insertCustomer(customer).catchError((e) {
                    Navigator.of(context).pop();
                    'Something went wrong. Please try again later.'
                        .showSnackBar(context);
                  })
                        .timeout(Duration(seconds: 30), onTimeout: () async {
                      Navigator.of(context).pop();
                      return Future.value(null);
                    });
                    if (await checkConnectivity) {
                      final apiResponse = await (repository.customerApi
                          .saveCustomer(
                              customer, context, AddCustomers.ADD_NEW_CUSTOMER)
                          .timeout(Duration(seconds: 30), onTimeout: () async {
                        Navigator.of(context).pop();
                        return Future.value(null);
                      }).catchError((e) {
                    Navigator.of(context).pop();
                    'Something went wrong. Please try again later.'
                        .showSnackBar(context);
                  }));
                      // if (apiResponse.isNotEmpty) {
                      //   ///update chat id here
                      //   await repository.queries
                      //       .updateCustomerIsChanged(0, customer.customerId, apiResponse);
                      // }
                      if (apiResponse) {
                        ///update chat id here
                        final Messages msg =
                            Messages(messages: '', messageType: 100);
                        var jsondata = jsonEncode(msg);
                        final response = await _chatRepository
                            .sendMessage(
                                _customerModel.mobileNo.toString(),
                                _customerModel.name,
                                jsondata,
                                localCustId.isEmpty ? uniqueId : localCustId,
                                Provider.of<BusinessProvider>(context,
                                        listen: false)
                                    .selectedBusiness
                                    .businessId)
                            .timeout(Duration(seconds: 30),
                                onTimeout: () async {
                          Navigator.of(context).pop();
                          return Future.value(null);
                        });
                        final messageResponse = Map<String, dynamic>.from(
                            jsonDecode(response.body));
                        Message _message =
                            Message.fromJson(messageResponse['message']);
                        if (_message.chatId.toString().isNotEmpty) {
                          await repository.queries
                              .updateCustomerIsChanged(0,
                                  _customerModel.customerId!, _message.chatId)
                              .timeout(Duration(seconds: 30),
                                  onTimeout: () async {
                            Navigator.of(context).pop();
                            return Future.value(null);
                          });
                        }
                      }
                    } else {
                          'Please check your internet connection or try again later.'
                              .showSnackBar(context);
                        }
                    BlocProvider.of<ContactsCubit>(context).getContacts(
                        Provider.of<BusinessProvider>(context, listen: false)
                            .selectedBusiness
                            .businessId);
                  }
                  setState(() {
                    debugPrint('Check' + _customerModel.customerId.toString());
                  });
                  if (cid.customerInfo?.id == null) {
                    Navigator.of(context).pop(true);
                    MerchantBankNotAdded.showBankNotAddedDialog(
                        context, 'userNotRegistered');
                  } else if (cid.customerInfo?.bankAccountStatus == false) {
                    Navigator.of(context).pop(true);

                    merchantBankNotAddedModalSheet(
                        text:
                            'We have requested your merchant to add bank account.');
                  } else if (cid.customerInfo?.kycStatus == false) {
                    Navigator.of(context).pop(true);
                    merchantBankNotAddedModalSheet(
                        text:
                            'Your merchant has not completed the KYC or KYC is expired. We have requested merchant to complete KYC.');
                  } else if (merchantSubscriptionPlan == false) {
                    Navigator.of(context).pop(true);
                    debugPrint('Checket');
                    merchantBankNotAddedModalSheet(
                        text:
                            'We have requested your merchant to Switch to Premium now to enjoy the benefits.');
                  } else {
                    // Navigator.of(context).pop(true);
                    // showBankAccountDialog();
                    if (widget._customerList[index].transactionType == null ||
                        widget._customerList[index].transactionAmount == 0) {
                      var anaylticsEvents = AnalyticsEvents(context);
                      await anaylticsEvents.initCurrentUser().catchError((e) {
                    Navigator.of(context).pop();
                    'Something went wrong. Please try again later.'
                        .showSnackBar(context);
                  });
                      await anaylticsEvents.customerDetailsPayEvent().catchError((e) {
                    Navigator.of(context).pop();
                    'Something went wrong. Please try again later.'
                        .showSnackBar(context);
                  });
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PayTransactionScreen(
                      //         model: _customerModel,
                      //         customerId:
                      //             localCustId.isEmpty ? uniqueId : localCustId,
                      //         type: 'DIRECT',
                      //         suspense: false,
                      //         through: 'DIRECT'),
                      //   ),
                      // );
                      Map<String, dynamic> isTransaction = await repository
                          .paymentThroughQRApi
                          .getTransactionLimit(context);
                      if (!(isTransaction)['isError']) {
                        Navigator.of(context).pop(true);
                        // showBankAccountDialog();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PayTransactionScreen(
                                model: _customerModel,
                                customerId: localCustId.isEmpty
                                    ? uniqueId
                                    : localCustId,
                                type: 'DIRECT',
                                suspense: false,
                                through: 'DIRECT'),
                          ),
                        );
                      } else {
                        Navigator.of(context).pop(true);
                        '${(isTransaction)['message']}'.showSnackBar(context);
                      }
                    } else if (widget._customerList[index].transactionType ==
                        TransactionType.Pay) {
                      var anaylticsEvents = AnalyticsEvents(context);
                      await anaylticsEvents.initCurrentUser().catchError((e) {
                    Navigator.of(context).pop();
                    'Something went wrong. Please try again later.'
                        .showSnackBar(context);
                  });
                      await anaylticsEvents.customerDetailsPayEvent().catchError((e) {
                    Navigator.of(context).pop();
                    'Something went wrong. Please try again later.'
                        .showSnackBar(context);
                  });
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PayTransactionScreen(
                      //         model: _customerModel,
                      //         customerId:
                      //             localCustId.isEmpty ? uniqueId : localCustId,
                      //         type: 'DIRECT',
                      //         suspense: false,
                      //         through: 'DIRECT'),
                      //   ),
                      // );
                      Map<String, dynamic> isTransaction = await repository
                          .paymentThroughQRApi
                          .getTransactionLimit(context);
                      if (!(isTransaction)['isError']) {
                        Navigator.of(context).pop(true);
                        // showBankAccountDialog();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PayTransactionScreen(
                                model: _customerModel,
                                customerId: localCustId.isEmpty
                                    ? uniqueId
                                    : localCustId,
                                type: 'DIRECT',
                                suspense: true,
                                through: 'DIRECT'),
                          ),
                        );
                      } else {
                        Navigator.of(context).pop(true);
                        '${(isTransaction)['message']}'.showSnackBar(context);
                      }
                    } else {
                      var anaylticsEvents = AnalyticsEvents(context);
                      await anaylticsEvents.initCurrentUser().catchError((e) {
                    Navigator.of(context).pop();
                    'Something went wrong. Please try again later.'
                        .showSnackBar(context);
                  });
                      await anaylticsEvents.customerDetailsPayEvent().catchError((e) {
                    Navigator.of(context).pop();
                    'Something went wrong. Please try again later.'
                        .showSnackBar(context);
                  });
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PayTransactionScreen(
                      //         model: _customerModel,
                      //         customerId:
                      //             localCustId.isEmpty ? uniqueId : localCustId,
                      //         amount:
                      //             (widget._customerList[index].transactionAmount)!
                      //                 .getFormattedCurrency
                      //                 .replaceAll('-', ''),
                      //         type: 'DIRECT',
                      //         suspense: false,
                      //         through: 'DIRECT'),
                      //   ),
                      // );
                      Map<String, dynamic> isTransaction = await repository
                          .paymentThroughQRApi
                          .getTransactionLimit(context).catchError((e) {
                    Navigator.of(context).pop();
                    'Something went wrong. Please try again later.'
                        .showSnackBar(context);
                  });
                      if (!(isTransaction)['isError']) {
                        Navigator.of(context).pop(true);
                        // showBankAccountDialog();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PayTransactionScreen(
                                model: _customerModel,
                                customerId: localCustId.isEmpty
                                    ? uniqueId
                                    : localCustId,
                                type: 'DIRECT',
                                suspense: false,
                                through: 'DIRECT'),
                          ),
                        );
                      } else {
                        Navigator.of(context).pop(true);
                        '${(isTransaction)['message']}'.showSnackBar(context);
                      }
                    }
                  }
                } else {
                  Navigator.of(context).pop();
                  'Please check your internet connection or try again later.'
                      .showSnackBar(context);
                }
              } else {
                debugPrint('left to right');
                if (await checkConnectivity) {
                  if (Repository().hiveQueries.userData.bankStatus == false) {
                    MerchantBankNotAdded.showBankNotAddedDialog(
                        context, 'userBankNotAdded');
                  } else if (Repository().hiveQueries.userData.kycStatus == 2) {
                    //If KYC is Verification is Pending
                    CustomLoadingDialog.showLoadingDialog(context, key);
                    await getKyc().then((value) {
                      Navigator.of(context).pop();
                      MerchantBankNotAdded.showBankNotAddedDialog(
                          context, 'userKYCVerificationPending');
                    });
                  } else if (Repository().hiveQueries.userData.kycStatus == 0) {
                    //Navigator.of(context).pop(true);
                    //KYC WHEN USER STARTS A NEW KYC JOURNEY
                    MerchantBankNotAdded.showBankNotAddedDialog(
                        context, 'userKYCPending');
                  } else if (Repository().hiveQueries.userData.kycStatus == 0 &&
                      Repository().hiveQueries.userData.isEmiratesIdDone ==
                          false) {
                    //Navigator.of(context).pop(true);
                    //KYC WHEN USER STARTS EMirates ID Journey but not done TRade License
                    MerchantBankNotAdded.showBankNotAddedDialog(
                        context, 'EmiratesIdPending');
                  } else if (Repository().hiveQueries.userData.kycStatus == 0 &&
                      Repository().hiveQueries.userData.isTradeLicenseDone ==
                          false) {
                    // Navigator.of(context).pop(true);
                    //KYC WHEN USER STARTS EMirates ID Journey but not done TRade License
                    MerchantBankNotAdded.showBankNotAddedDialog(
                        context, 'TradeLicensePending');
                  } else if (Repository().hiveQueries.userData.kycStatus == 1 &&
                      Repository().hiveQueries.userData.premiumStatus == 0) {
                    // Navigator.of(context).pop(true);
                    MerchantBankNotAdded.showBankNotAddedDialog(
                        context, 'upgradePremium');
                  }

                  //MERCHANT CHECK
                  // else if (cid.customerInfo?.kycStatus == false) {
                  //   Navigator.of(context).pop(true);
                  //   merchantBankNotAddedModalSheet(
                  //       text:
                  //           'Your merchant has not completed the KYC or KYC is expired. We have requested merchant to complete KYC.');
                  // } else if (merchantSubscriptionPlan == false) {
                  //   Navigator.of(context).pop(true);
                  //   merchantBankNotAddedModalSheet(
                  //       text:
                  //           'We have requested your merchant to Switch to Premium now to enjoy the benefits.');
                  // }

                  else {
                    // CustomLoadingDialog.showLoadingDialog(context, key);
                    // var cid = await repository.customerApi.getCustomerID(
                    //     mobileNumber:
                    //         widget._customerList[index].mobileNo.toString());
                    _customerModel
                      ..name = getName(widget._customerList[index].name,
                          widget._customerList[index].mobileNo)
                      ..mobileNo = widget._customerList[index].mobileNo
                      // ..ulId = cid.customerInfo?.id.toString()
                      ..avatar = widget._customerList[index].avatar
                      ..chatId = widget._customerList[index].chatId;
                    final localCustId = await repository.queries
                        .getCustomerId(widget._customerList[index].mobileNo!);
                    // Navigator.of(context).pop(true);

                    if (widget._customerList[index].transactionType == null ||
                        widget._customerList[index].transactionAmount == 0) {
                      var anaylticsEvents = AnalyticsEvents(context);
                      await anaylticsEvents.initCurrentUser();
                      await anaylticsEvents.customerDetailsPayRequestEvent();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiveTransactionScreen(
                            model: _customerModel,
                            customerId: localCustId,
                          ),
                        ),
                      );
                    } else if (widget._customerList[index].transactionType ==
                        TransactionType.Pay) {
                      var anaylticsEvents = AnalyticsEvents(context);
                      await anaylticsEvents.initCurrentUser();
                      await anaylticsEvents.customerDetailsPayRequestEvent();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiveTransactionScreen(
                              model: _customerModel,
                              customerId: localCustId,
                              amount: (widget
                                      ._customerList[index].transactionAmount)!
                                  .getFormattedCurrency
                                  .replaceAll('-', '')),
                        ),
                      );
                    } else {
                      var anaylticsEvents = AnalyticsEvents(context);
                      await anaylticsEvents.initCurrentUser();
                      await anaylticsEvents.customerDetailsPayRequestEvent();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiveTransactionScreen(
                            model: _customerModel,
                            customerId: localCustId,
                          ),
                        ),
                      );
                    }
                    // Navigator.of(context).pushNamed(
                    //     AppRoutes.requestTransactionRoute,
                    //     arguments:
                    //         ReceiveTransactionArgs(_customerModel, localCustId));
                  }
                } else {
                  // Navigator.of(context).pop();
                  'Please check your internet connection or try again later.'
                      .showSnackBar(context);
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: ListTile(
                leading: CustomProfileImage(
                  avatar: widget._customerList[index].avatar,
                  mobileNo: widget._customerList[index].mobileNo,
                  name: widget._customerList[index].name,
                ),
                // leading: CircleAvatar(
                //   radius: 25,
                //   backgroundColor: _colors[random.nextInt(_colors.length)],
                //   backgroundImage:
                //       widget._customerList[index].avatar?.isEmpty ?? true
                //           ? null
                //           : MemoryImage(widget._customerList[index].avatar!),
                //   child: widget._customerList[index].avatar?.isEmpty ?? true
                //       ? CustomText(
                //           getInitials(
                //               widget._customerList[index].name!.toUpperCase(),
                //               widget._customerList[index].mobileNo),
                //           color: Colors.white,
                //           size: 27,
                //         )
                //       : null,
                // ),
                title: CustomText(
                  getName(widget._customerList[index].name,
                      widget._customerList[index].mobileNo),
                  bold: FontWeight.w500,
                  size: 18,
                ),
                subtitle: CustomText(
                  widget._customerList[index].updatedDate?.duration ?? "",
                  size: 16,
                  color: AppTheme.greyish,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: widget._customerList[index].transactionType ==
                                      TransactionType.Pay ||
                                  widget._customerList[index]
                                          .transactionAmount ==
                                      0
                              ? '+$currencyAED '
                              : '-$currencyAED ',
                          style: TextStyle(
                              color:
                                  widget._customerList[index].transactionType ==
                                              null ||
                                          widget._customerList[index]
                                                  .transactionAmount ==
                                              0
                                      ? AppTheme.greyish
                                      : widget._customerList[index]
                                                  .transactionType ==
                                              TransactionType.Pay
                                          ? AppTheme.greenColor
                                          : AppTheme.tomato,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                          children: [
                            TextSpan(
                                text: (widget._customerList[index]
                                        .transactionAmount)!
                                    .getFormattedCurrency
                                    .replaceAll('-', ''),
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ]),
                    ),
                    CustomText(
                      widget._customerList[index].transactionType == null ||
                              widget._customerList[index].transactionAmount == 0
                          ? 'Nothing Pending'
                          : widget._customerList[index].transactionType ==
                                  TransactionType.Pay
                              ? 'You’ll Get'
                              : 'You’ll Give',
                      color: AppTheme.greyish,
                    )
                  ],
                ),
                onTap: () async {
                  debugPrint(
                      'chatt v ${widget._customerList[index].toJson().toString()}');

                  localCustomerId = widget._customerList[index].customerId!;
                  BlocProvider.of<LedgerCubit>(context)
                      .getLedgerData(widget._customerList[index].customerId!);
                  ContactController.initChat(
                      context, widget._customerList[index].chatId);
                  Navigator.of(context).pushNamed(
                      AppRoutes.transactionListRoute,
                      arguments: TransactionListArgs(
                          false, widget._customerList[index]));
                  await fetchContacts();

                },
              ),
            ),
          ),
        );
      },
    ).flexible;
  }

  Future<void> fetchContacts() async {
    String selectedBusinessId = Provider.of<BusinessProvider>(context, listen: false)
        .selectedBusiness
        .businessId;
    final _customerList =
        await repository.customerApi.getAllCustomers(selectedBusinessId);

    await Future.forEach<CustomerModel>(_customerList,
            (element) async => await repository.queries.insertCustomer(element));
    BlocProvider.of<ContactsCubit>(context,listen: false).getContacts(selectedBusinessId
        );
    setState(() {

    });
    _customerList.forEach((e) async {
      final _ledgerTransactionList =
      await repository.ledgerApi.getLedger(e.customerId);
      _ledgerTransactionList.forEach(
            (e) async =>
        await repository.queries.insertLedgerTransaction(e).catchError((e) {
          debugPrint(e);
          recordError(e, StackTrace.current);
        }),
      );
    });
  }
}

Widget slideLeftBackground() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: AppTheme.greenColor,
    ),
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            " Pay",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}

Widget slideRightBackground() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      color: AppTheme.tomato,
    ),
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Text(
            " Request",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}
