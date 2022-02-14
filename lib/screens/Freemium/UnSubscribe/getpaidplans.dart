import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screen/flutter_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Models/get_premium_moodel.dart';
import 'package:urbanledger/Models/plan_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Models/unsubscribe_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/screens/Components/shimmer_widgets.dart';
import 'package:urbanledger/screens/Freemium/UnSubscribe/upgrade_subscription.dart';
import 'package:urbanledger/screens/Freemium/freemium_provider.dart';
import 'package:urbanledger/screens/TransactionScreens/add_cards_provider.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';

class UpgrdUnsubs extends StatefulWidget {
  const UpgrdUnsubs({Key? key}) : super(key: key);

  @override
  _UpgrdUnsubsState createState() => _UpgrdUnsubsState();
}

class _UpgrdUnsubsState extends State<UpgrdUnsubs> {
  bool agree = true;
  int? index = 2;
  List<PlanModel> premiumPlans = [];

  check selected = check.free;
  String? amount;
  String? cardNo;
  String? cardImage;
  String? cardName;
  String? planId;
  String? cardId;
  bool isLoading = true;

  final GlobalKey<State> key = GlobalKey<State>();

  // @override
  void initState() {
    // TODO: implement initState
    super.initState();
   /* getPremiumPlansabc().timeout(Duration(seconds: 30), onTimeout: () async {
      debugPrint("abc");
      Navigator.of(context).pop();
      return Future.value(null);
    });*/
    getPremiumPlansabc();
    Provider.of<FreemiumProvider>(context, listen: false).cardNumber =
        Provider.of<AddCardsProvider>(context, listen: false)
            .selectedCard
            ?.endNumber
            .toString();
    debugPrint('deviceHeight: ' + deviceHeight.toString());
    // getCar();
  }

  Future<void> getPremiumPlansabc() async {
    debugPrint("XYZ");
    Provider.of<FreemiumProvider>(context, listen: false).clearSubcription();
    index = Provider.of<FreemiumProvider>(context, listen: false).index ?? 2;
    debugPrint('index: abc' + index.toString());

    await Provider.of<FreemiumProvider>(context, listen: false)
        .getPremiumPlans()
        .timeout(Duration(seconds: 30), onTimeout: () async {
      debugPrint("abc");
      Navigator.of(context).pop();
      // return Future.value(null);
    });
    await Provider.of<FreemiumProvider>(context, listen: false).getStats();
    debugPrint("123");
    repository.freemiumApi.getPremiumPlans().timeout(Duration(seconds: 30),
        onTimeout: () async {
      debugPrint("abc");
      Navigator.of(context).pop();

      return Future.value(null);
    }).then((value) {
      // Navigator.of(context).pop();
      premiumPlans = value;

      // debugPrint('yearly:' + premiumPlans[1].name);
      if (Repository().hiveQueries.userData.premiumStatus == 2) {
        selected = check.yearly;
      } else if (Repository().hiveQueries.userData.premiumStatus == 1) {
        selected = check.monthly;
      } else {
        selected = check.free;
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    debugPrint('ade50 :' + premiumPlans.length.toString());
    // return premiumPlans;
  }

  @override
  Widget build(BuildContext context) {
    // FlutterScreen.setBrightness(1);
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      appBar: AppBar(
        title: Text('Premium Member'),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 22,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: deviceHeight * 0.06,
              width: double.maxFinite,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: Color(0xfff2f1f6),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(AppAssets.backgroundImage),
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.06),
              child: Container(
                // height: 500,
                decoration: BoxDecoration(
                  color: Color(0xfff2f1f6),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      "assets/images/BG.png",
                    ),
                    // alignment: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            isLoading == false
                                ? Container(
                                    child: Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                            left: 45,
                                            right: 45,
                                          ),
                                          child: Image.asset(
                                            'assets/images/Freemiumcard.png',
                                            width: 420,
                                            height: 380,
                                            // alignment: Alignment.center,
                                          ),
                                        ),
                                        Container(
                                          width: 420,
                                          // height:
                                          //     MediaQuery.of(context).size.height / 2.4,
                                          // height: deviceHeight * 0.9,
                                          // color: Colors.amber,

                                          child: Column(
                                            children: [
                                              // 130.0.heightBox,
                                              SizedBox(
                                                height: 130.0,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  // 80.0.widthBox,
                                                  SizedBox(
                                                    width: 80.0,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: AppTheme.greyish,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Image.asset(
                                                        'assets/icons/ledger.png',
                                                        height: 25,
                                                        width: 25,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Container(
                                                    child: CustomText(
                                                      'Multiple ledgers support for\nyour different businesses. ',
                                                      color:
                                                          AppTheme.brownishGrey,
                                                      size: 18,
                                                      bold: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  // 80.0.widthBox,
                                                  SizedBox(
                                                    width: 80.0,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: AppTheme.greyish,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Image.asset(
                                                        'assets/icons/freemium2.png',
                                                        height: 25,
                                                        width: 25,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Container(
                                                    child: CustomText(
                                                      'Global summary of your\ndifferent businesses in one\nplace.',
                                                      color:
                                                          AppTheme.brownishGrey,
                                                      size: 18,
                                                      bold: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  // 80.0.widthBox,
                                                  SizedBox(
                                                    width: 80.0,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: AppTheme.greyish,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Image.asset(
                                                        'assets/icons/freemium.png',
                                                        height: 25,
                                                        width: 25,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  FittedBox(
                                                    child: CustomText(
                                                      'Access to payment collection\nfeatures like payment links and\nQR code-based payments.',
                                                      color:
                                                          AppTheme.brownishGrey,
                                                      size: 18,
                                                      bold: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : shimmerTicket,
                            isLoading == false
                                ? Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: Image.asset(
                                        'assets/images/crown.png',
                                        height: 55,
                                        width: 55,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  )
                                : Container(),
                            isLoading == false
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        // alignment: Alignment.center,
                                        // padding: EdgeInsets.symmetric(horizontal: 1),
                                        child: Text(
                                          'UrbanLedger ',
                                          style: TextStyle(
                                            color: AppTheme.electricBlue,
                                            fontFamily: 'SFProDisplay',
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      // SizedBox(width: 1),
                                      Container(
                                        // alignment: Alignment.center,
                                        // padding: EdgeInsets.symmetric(horizontal: 5),
                                        child: Text(
                                          'Premium',
                                          style: TextStyle(
                                            color: AppTheme.brownishGrey,
                                            fontFamily: 'SFProDisplay',
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            isLoading == false
                                ? Container(
                                    // margin: EdgeInsets.only(
                                    // top: MediaQuery.of(context).size.height * 0.08),
                                    //PREMIUM CARD FOR P PLAN

                                    child: Consumer<FreemiumProvider>(
                                        builder: (context, GetPlans, _) {
                                      return GetPlans.gpp != null &&
                                              GetPlans.gpp?.data != null &&
                                              GetPlans.gpp!.data!.isNotEmpty
                                          ? ListView.builder(
                                              itemCount: 1,
                                              // itemCount: 2,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              reverse: true,
                                              itemBuilder: (context, int i) {
                                                // debugPrint('monthly:' + premiumPlans[i].name);

                                                MyPlans planDetail =
                                                    GetPlans.gpp!.data![i];
                                                return Container(
                                                  height: deviceHeight > 800.0
                                                      ? deviceHeight >= 1000
                                                          ? (deviceHeight *
                                                              0.50) //50
                                                          : (deviceHeight *
                                                              0.58) //58
                                                      : (deviceHeight *
                                                          0.70), //70
                                                  // height: deviceHeight > 800.0 ?(deviceHeight *
                                                  //     0.60):(deviceHeight *
                                                  //     0.7), //0.8 originally
                                                  // deviceHeight * 0.5 - 41,
                                                  child: AspectRatio(
                                                    aspectRatio: 1.0,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: GestureDetector(
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      40),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  border: Border
                                                                      .all(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            16,
                                                                            88,
                                                                            255,
                                                                            0.5),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Color.fromRGBO(
                                                                            240,
                                                                            245,
                                                                            255,
                                                                            1),
                                                                        // color: Colors.white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(4),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          // mainAxisAlignment:
                                                                          //     MainAxisAlignment.end,
                                                                          children: [
                                                                            planDetail.plan?.discount == 0
                                                                                ? Container()
                                                                                : Container(
                                                                                    margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
                                                                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                                                    decoration: BoxDecoration(
                                                                                      color: Color.fromRGBO(242, 255, 247, 1),
                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                      border: Border.all(color: AppTheme.greenColor),
                                                                                    ),
                                                                                    child: Text(
                                                                                      '${planDetail.plan?.discount}% OFF',
                                                                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.greenColor),
                                                                                    ),
                                                                                    // child: premiumPlans[i]
                                                                                    //             .discount !=
                                                                                    //         0
                                                                                    //     ? CustomText(
                                                                                    //         '${premiumPlans[i].discount.toString()}% OFF',
                                                                                    //         size: 22,
                                                                                    //         bold:
                                                                                    //             FontWeight.w800,
                                                                                    //         color: AppTheme
                                                                                    //             .greenColor,
                                                                                    //       )
                                                                                    //     : SizedBox(
                                                                                    //         height: 22,
                                                                                    //       ),
                                                                                  ),

                                                                            //
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                            width: planDetail.plan?.discount != 0
                                                                                ? MediaQuery.of(context).size.width * 0.03
                                                                                : MediaQuery.of(context).size.width * 0.22),
                                                                        planDetail.plan?.activeStatus ==
                                                                                true
                                                                            ? Container(
                                                                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
                                                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                                                decoration: BoxDecoration(
                                                                                  color: AppTheme.electricBlue,
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  mainAxisSize: MainAxisSize.min,
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
                                                                                    Text(
                                                                                      'Current Plan',
                                                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                                // child: Text(
                                                                                //   'Current Plan',
                                                                                //   style: TextStyle(
                                                                                //       fontSize: 16,
                                                                                //       fontWeight:
                                                                                //           FontWeight.w400,
                                                                                //       color: Colors.white),
                                                                                // ),
                                                                                )
                                                                            : Container(),
                                                                        Spacer(),
                                                                        planDetail.plan?.activeStatus ==
                                                                                true
                                                                            ? Container(
                                                                                height: 22,
                                                                                width: 22,
                                                                                decoration: BoxDecoration(shape: BoxShape.circle, color: planDetail.plan?.activeStatus == true ? Color.fromRGBO(78, 216, 167, 1) : Colors.white, border: Border.all(width: 2, color: AppTheme.greencyan)),
                                                                                child: planDetail.plan?.activeStatus == true
                                                                                    ? Padding(
                                                                                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                                                                        child: Icon(
                                                                                          Icons.check,
                                                                                          size: 13.0,
                                                                                          color: Colors.white,
                                                                                        ))
                                                                                    : Container(),
                                                                              )
                                                                            : Container(),
                                                                        20.0.widthBox,
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          CustomText(
                                                                            'AED',
                                                                            size:
                                                                                20,
                                                                            bold:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                AppTheme.brownishGrey,
                                                                            centerAlign:
                                                                                true,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                4,
                                                                          ),
                                                                          CustomText(
                                                                            // '${GetPlans.gpp!.plans![i].amount.toString()}',
                                                                            removeDecimalif0(planDetail.plan!.amount!.toDouble() -
                                                                                (planDetail.plan!.amount!.toDouble() * ((planDetail.plan!.discount)!.toDouble())) / 100),
                                                                            size:
                                                                                40,
                                                                            bold:
                                                                                FontWeight.w900,
                                                                            color:
                                                                                AppTheme.brownishGrey,
                                                                            centerAlign:
                                                                                true,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                4,
                                                                          ),
                                                                          CustomText(
                                                                            '${planDetail.plan!.name!.toLowerCase()}',
                                                                            size:
                                                                                20,
                                                                            bold:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                AppTheme.brownishGrey,
                                                                            centerAlign:
                                                                                true,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          CustomText(
                                                                        'Per active user, bill ${planDetail.plan!.name!.toLowerCase()}',
                                                                        // 'Per active user, per\n${premiumPlans[i].name ? 'year billed annually' : 'month'}',
                                                                        size:
                                                                            14,
                                                                        bold: FontWeight
                                                                            .w400,
                                                                        color: AppTheme
                                                                            .brownishGrey,
                                                                        centerAlign:
                                                                            true,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    planDetail.plan!.discount !=
                                                                            0
                                                                        ? Text(
                                                                            'AED ${(planDetail.plan!.amount)}',
                                                                            style:
                                                                                TextStyle(
                                                                              color: AppTheme.greyish,
                                                                              decorationColor: AppTheme.greyish,
                                                                              decoration: TextDecoration.lineThrough,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          )
                                                                        : Container(),
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        'Validity Of Premium Plan: ' +
                                                                            DateFormat("dd MMM yyyy").format(DateTime.parse(planDetail.createdAt.toString())).toString() +
                                                                            ' - ' +
                                                                            // DateFormat(
                                                                            //         "dd MMM yyyy")
                                                                            //     .format(DateTime.parse(planDetail.createdAt.toString()).add(Duration(
                                                                            //         days:
                                                                            //             planDetail.plan!.days!)))
                                                                            DateFormat("dd MMM yyyy").format(DateTime.parse(planDetail.expiryAt.toString())).toString(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                AppTheme.tomato),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 2),
                                                              // analyticsData()

                                                              Expanded(
                                                                child:
                                                                    AspectRatio(
                                                                  aspectRatio:
                                                                      2.0,
                                                                  child: Column(
                                                                    // mainAxisAlignment:
                                                                    //     MainAxisAlignment
                                                                    //         .center,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      SizedBox(
                                                                          height:
                                                                              2),
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              Colors.white,

                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                20,
                                                                          ),
                                                                          // decoration: BoxDecoration(
                                                                          //     borderRadius:
                                                                          //         BorderRadius
                                                                          //             .circular(
                                                                          //                 10)),
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Column(
                                                                                  // mainAxisAlignment:
                                                                                  //     MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                      child: Row(
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: Container(
                                                                                              padding: new EdgeInsets.only(top: 1.0),
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text("Links", style: TextStyle(color: AppTheme.electricBlue, fontSize: 18.0, fontWeight: FontWeight.w500)),
                                                                                                  SizedBox(
                                                                                                    height: 2,
                                                                                                  ),
                                                                                                  Text(GetPlans.linkCount.toString(), style: TextStyle(color: AppTheme.brownishGrey, fontSize: 22.0, fontWeight: FontWeight.w900)), //api for total links
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(50),
                                                                                            ),
                                                                                            padding: const EdgeInsets.all(1.0),
                                                                                            child: Image.asset(
                                                                                              'assets/icons/TotalLink.png',
                                                                                              height: MediaQuery.of(context).size.height * 0.08,
                                                                                              width: MediaQuery.of(context).size.width * 0.08,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 5),
                                                                                    Container(
                                                                                      child: Text("Total links\ngenerated till date", style: TextStyle(color: AppTheme.brownishGrey, fontSize: 18.0, fontWeight: FontWeight.w400)),
                                                                                    ),
                                                                                    SizedBox(height: 15),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Text("AED", //for now static
                                                                                            style: TextStyle(color: AppTheme.electricBlue, fontSize: 20.0, fontWeight: FontWeight.w500)),
                                                                                        SizedBox(
                                                                                          height: 3,
                                                                                        ),
                                                                                        Text("${GetPlans.amountViaLink!.getFormattedCurrency.toString()}",
                                                                                            maxLines: 1,
                                                                                            overflow: TextOverflow.ellipsis, //for now static
                                                                                            style: TextStyle(color: AppTheme.brownishGrey, fontSize: 22.0, fontWeight: FontWeight.w900)), //api for total links
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(height: 15),
                                                                                    Container(
                                                                                      child: Text("Total amount\ncollected through links", style: TextStyle(color: AppTheme.brownishGrey, fontSize: 18.0, fontWeight: FontWeight.w400)),
                                                                                    ),
                                                                                    SizedBox(height: 15),
                                                                                    Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          // padding:
                                                                                          //     new EdgeInsets.only(top: 1.0),
                                                                                          child: Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              //     decoration:
                                                                                              //     BoxDecoration(
                                                                                              //   borderRadius:
                                                                                              //       BorderRadius.circular(50),
                                                                                              // ),
                                                                                              // padding:
                                                                                              //     const EdgeInsets.all(1.0),
                                                                                              Image.asset(
                                                                                                'assets/icons/TranactionHistory.png',
                                                                                                height: 20,
                                                                                                width: 20,
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 5,
                                                                                              ),
                                                                                              GestureDetector(
                                                                                                child: Text("Transaction history", style: TextStyle(color: AppTheme.electricBlue, fontSize: 14.0, fontWeight: FontWeight.w500)),
                                                                                                onTap: () {
                                                                                                  Navigator.pushNamed(context, AppRoutes.premiumtranactionlistRoute);
                                                                                                },
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        // Container(
                                                                                        //   decoration:
                                                                                        //       BoxDecoration(
                                                                                        //     borderRadius:
                                                                                        //         BorderRadius.circular(50),
                                                                                        //   ),
                                                                                        //   padding:
                                                                                        //       const EdgeInsets.all(1.0),
                                                                                        //   child:
                                                                                        //       Image.asset(
                                                                                        //     'assets/icons/TotalLink.png',
                                                                                        //     height:
                                                                                        //         45,
                                                                                        //     width:
                                                                                        //         45,
                                                                                        //   ),
                                                                                        // ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                padding: new EdgeInsets.only(top: 5.0, bottom: 14.0),
                                                                                width: MediaQuery.of(context).size.width * 0.009,
                                                                                height: double.infinity,
                                                                                child: AspectRatio(aspectRatio: 1, child: VerticalDivider(color: AppTheme.greyish)),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.02,
                                                                              ),
                                                                              Expanded(
                                                                                child: Column(
                                                                                  // mainAxisAlignment:
                                                                                  //     MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                      child: Row(
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          Expanded(
                                                                                            child: Container(
                                                                                              // padding:
                                                                                              //     new EdgeInsets.only(top: 1.0),
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text("QR code", style: TextStyle(color: AppTheme.electricBlue, fontSize: 18.0, fontWeight: FontWeight.w500)),
                                                                                                  SizedBox(
                                                                                                    height: 2,
                                                                                                  ),
                                                                                                  Text(GetPlans.qrCount.toString(), style: TextStyle(color: AppTheme.brownishGrey, fontSize: 22.0, fontWeight: FontWeight.w900)), //api for total links
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(50),
                                                                                            ),
                                                                                            padding: const EdgeInsets.all(1.0),
                                                                                            child: Image.asset(
                                                                                              'assets/icons/TotalQA.png',
                                                                                              height: MediaQuery.of(context).size.height * 0.08,
                                                                                              width: MediaQuery.of(context).size.width * 0.08,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 5),
                                                                                    Container(
                                                                                      child: Text("Total times QR code\n was used", style: TextStyle(color: AppTheme.brownishGrey, fontSize: 18.0, fontWeight: FontWeight.w400)),
                                                                                    ),
                                                                                    SizedBox(height: 15),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Text("AED", //for now static
                                                                                            style: TextStyle(color: AppTheme.electricBlue, fontSize: 20.0, fontWeight: FontWeight.w500)),
                                                                                        SizedBox(
                                                                                          height: 3,
                                                                                        ),
                                                                                        Text("${GetPlans.amountViaQr!.getFormattedCurrency.toString()}", //for now static
                                                                                            maxLines: 1,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            style: TextStyle(color: AppTheme.brownishGrey, fontSize: 22.0, fontWeight: FontWeight.w900)), //api for total links
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(height: 15),
                                                                                    Container(
                                                                                      child: Text("Total amount collected\nthrough QR codes", style: TextStyle(color: AppTheme.brownishGrey, fontSize: 18.0, fontWeight: FontWeight.w400)),
                                                                                    ),
                                                                                    SizedBox(height: 15),
                                                                                    Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          // padding:
                                                                                          //     new EdgeInsets.only(top: 1.0),
                                                                                          child: Row(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              //     decoration:
                                                                                              //     BoxDecoration(
                                                                                              //   borderRadius:
                                                                                              //       BorderRadius.circular(50),
                                                                                              // ),
                                                                                              // padding:
                                                                                              //     const EdgeInsets.all(1.0),
                                                                                              Image.asset(
                                                                                                'assets/icons/TranactionHistory.png',
                                                                                                height: 20,
                                                                                                width: 20,
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 5,
                                                                                              ),
                                                                                              GestureDetector(
                                                                                                child: Text("Transaction history", style: TextStyle(color: AppTheme.electricBlue, fontSize: 14.0, fontWeight: FontWeight.w500)),
                                                                                                onTap: () {
                                                                                                  Navigator.pushNamed(context, AppRoutes.premiumtranactionlistRoute);
                                                                                                },
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        // Container(
                                                                                        //   decoration:
                                                                                        //       BoxDecoration(
                                                                                        //     borderRadius:
                                                                                        //         BorderRadius.circular(50),
                                                                                        //   ),
                                                                                        //   padding:
                                                                                        //       const EdgeInsets.all(1.0),
                                                                                        //   child:
                                                                                        //       Image.asset(
                                                                                        //     'assets/icons/TotalLink.png',
                                                                                        //     height:
                                                                                        //         45,
                                                                                        //     width:
                                                                                        //         45,
                                                                                        //   ),
                                                                                        // ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          await showDialog(
                                                                              builder: (context) => Dialog(
                                                                                    insetPadding: EdgeInsets.only(
                                                                                      left: 17,
                                                                                      right: 17,
                                                                                    ),
                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.all(1.0),
                                                                                            child: Image.asset(
                                                                                              'assets/images/Subscription.png',
                                                                                              height: 200,
                                                                                              width: 500,
                                                                                              // fit: BoxFit.none,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  // 80.0.widthBox,
                                                                                                  SizedBox(
                                                                                                    width: 55.0,
                                                                                                  ),
                                                                                                  Container(
                                                                                                    child: Image.asset(
                                                                                                      'assets/icons/Error-01.png',
                                                                                                      height: 35,
                                                                                                      width: 35,
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(width: 25),
                                                                                                  Expanded(
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.only(right: 0.0),
                                                                                                      child: Container(
                                                                                                        child: CustomText(
                                                                                                          true ? "You have ${Provider.of<FreemiumProvider>(context, listen: false).endDate.difference(DateTime.now()).inDays.toString()} days left with premium\nplan, are you sure you don't want to\ncontinue with the UrbanLedger\nPremium plan? " : 'Are you sure you don\'t\nwant to continue with the\nUrbanLedger Premium plan? ',
                                                                                                          color: AppTheme.tomato,
                                                                                                          size: 18,
                                                                                                          bold: FontWeight.w600,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 15,
                                                                                              ),
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  SizedBox(
                                                                                                    width: 55.0,
                                                                                                  ),
                                                                                                  Container(
                                                                                                    decoration: BoxDecoration(
                                                                                                      border: Border.all(
                                                                                                        color: Colors.white,
                                                                                                      ),
                                                                                                      borderRadius: BorderRadius.circular(50),
                                                                                                    ),
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                      child: Image.asset(
                                                                                                        'assets/icons/UP_Arrow-01.png',
                                                                                                        height: 25,
                                                                                                        width: 25,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(width: 19),
                                                                                                  Container(
                                                                                                    child: CustomText(
                                                                                                      'You will lose access to amazing\nfeatures like: ',
                                                                                                      color: AppTheme.tomato,
                                                                                                      size: 18,
                                                                                                      bold: FontWeight.w500,
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(height: 15),
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  // 80.0.widthBox,
                                                                                                  SizedBox(
                                                                                                    width: 55.0,
                                                                                                  ),
                                                                                                  Container(
                                                                                                    decoration: BoxDecoration(
                                                                                                      border: Border.all(
                                                                                                        color: AppTheme.greyish,
                                                                                                      ),
                                                                                                      borderRadius: BorderRadius.circular(50),
                                                                                                    ),
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                      child: Image.asset(
                                                                                                        'assets/icons/ledger.png',
                                                                                                        height: 25,
                                                                                                        width: 25,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(width: 19),
                                                                                                  Container(
                                                                                                    child: CustomText(
                                                                                                      'Multiple ledgers support for\nyour different businesses. ',
                                                                                                      color: AppTheme.brownishGrey,
                                                                                                      size: 18,
                                                                                                      bold: FontWeight.w400,
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(height: 15),
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  // 80.0.widthBox,
                                                                                                  SizedBox(
                                                                                                    width: 55.0,
                                                                                                  ),
                                                                                                  Container(
                                                                                                    decoration: BoxDecoration(
                                                                                                      border: Border.all(
                                                                                                        color: AppTheme.greyish,
                                                                                                      ),
                                                                                                      borderRadius: BorderRadius.circular(50),
                                                                                                    ),
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                      child: Image.asset(
                                                                                                        'assets/icons/freemium2.png',
                                                                                                        height: 25,
                                                                                                        width: 25,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(width: 19),
                                                                                                  Container(
                                                                                                    child: CustomText(
                                                                                                      'Global summary of your\ndifferent businesses in one\nplace.',
                                                                                                      color: AppTheme.brownishGrey,
                                                                                                      size: 18,
                                                                                                      bold: FontWeight.w400,
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(height: 15),
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  // 80.0.widthBox,
                                                                                                  SizedBox(
                                                                                                    width: 55.0,
                                                                                                  ),
                                                                                                  Container(
                                                                                                    decoration: BoxDecoration(
                                                                                                      border: Border.all(
                                                                                                        color: AppTheme.greyish,
                                                                                                      ),
                                                                                                      borderRadius: BorderRadius.circular(50),
                                                                                                    ),
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                      child: Image.asset(
                                                                                                        'assets/icons/freemium.png',
                                                                                                        height: 25,
                                                                                                        width: 25,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(width: 19),
                                                                                                  FittedBox(
                                                                                                    child: CustomText(
                                                                                                      'Access to payment collection\nfeatures like payment links and\nQR code-based payments.',
                                                                                                      color: AppTheme.brownishGrey,
                                                                                                      size: 18,
                                                                                                      bold: FontWeight.w400,
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        // CustomText(
                                                                                        //   'Delete entry will change your balance ',
                                                                                        //   size: 16,
                                                                                        // ),
                                                                                        SizedBox(height: 15),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                            children: [
                                                                                              Expanded(
                                                                                                flex: 1,
                                                                                                child: NewCustomButton(
                                                                                                  onSubmit: () async {
                                                                                                    CustomLoadingDialog.showLoadingDialog(context, key);
                                                                                                    if (await checkConnectivity) {
                                                                                                      UnsubscribeModel? response = await repository.unsubsApi.putunSubscribePlan().timeout(Duration(seconds: 30), onTimeout: () async {
                                                                                                        Navigator.of(context).pop();
                                                                                                        return Future.value(null);
                                                                                                      });
                                                                                                      if (response?.status ?? false) {
                                                                                                        setState(() {
                                                                                                          Repository().hiveQueries.insertUserData(Repository().hiveQueries.userData.copyWith(premiumStatus: 0));
                                                                                                        });
                                                                                                        Provider.of<BusinessProvider>(context, listen: false).updateSelectedBusiness(index: 0);

                                                                                                        BlocProvider.of<ContactsCubit>(context).getContacts(Provider.of<BusinessProvider>(context, listen: false).selectedBusiness.businessId).timeout(Duration(seconds: 30), onTimeout: () async {
                                                                                                          Navigator.of(context).pop();
                                                                                                          return Future.value(null);
                                                                                                        });
                                                                                                        Navigator.of(context)
                                                                                                          ..pop()
                                                                                                          ..pop();
                                                                                                        Navigator.of(context).popAndPushNamed(AppRoutes.unsubscribeplanRoute, arguments: FreemiumConfirmationArgs(planModel: premiumPlans));
                                                                                                        // Navigator.popAndPush(
                                                                                                        //   context,
                                                                                                        //   MaterialPageRoute(
                                                                                                        //     builder: (context) =>
                                                                                                        //         UnSubscribePlan(
                                                                                                        //       planModel:
                                                                                                        //           premiumPlans,
                                                                                                        //       // index: index,
                                                                                                        //     ),
                                                                                                        //   ),
                                                                                                        // );
                                                                                                      } else {
                                                                                                        'Something went wrong'.showSnackBar(context);
                                                                                                      }
                                                                                                    } else {
                                                                                                      Navigator.of(context).pop();
                                                                                                      'Please check your internet connection or try again later.'.showSnackBar(context);
                                                                                                    }
                                                                                                  },

                                                                                                  text: 'confirm'.toUpperCase(),
                                                                                                  textColor: Colors.white,
                                                                                                  backgroundColor: AppTheme.electricBlue,
                                                                                                  textSize: 18.0,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  // width: 185,
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 8,
                                                                                              ),
                                                                                              Expanded(
                                                                                                flex: 1,
                                                                                                child: NewCustomButton(
                                                                                                  onSubmit: () {
                                                                                                    Navigator.of(context).pop(false);
                                                                                                  },

                                                                                                  text: 'cancel'.toUpperCase(),
                                                                                                  textColor: Colors.white,
                                                                                                  backgroundColor: AppTheme.electricBlue,
                                                                                                  textSize: 18.0,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  // width: 185,
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                              barrierDismissible: false,
                                                                              context: context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'UNSUBSCRIBE',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                AppTheme.electricBlue,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            decoration:
                                                                                TextDecoration.underline,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              10),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              })
                                          : Container();
                                    }),
                                  )
                                : Container(),
                            SizedBox(
                              height: 10,
                            ),

                            // Container(
                            //   padding: EdgeInsets.all(2.0),
                            //   width: 350,
                            //   height: 200,
                            //   child: Card(
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(15.0),
                            //     ),
                            //     color: Colors.white,
                            //     // elevation: 10,
                            //   ),
                            // ),
                            // Container(
                            //   padding: EdgeInsets.all(2.0),
                            //   width: 350,
                            //   height: 200,
                            //   child: Card(
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(15.0),
                            //     ),
                            //     color: Colors.white,
                            //     // elevation: 10,
                            //   ),
                            // ),
                            SizedBox(
                              height: 1,
                            ),
                            isLoading == false
                                ? Consumer<FreemiumProvider>(
                                    builder: (context, GetPlans, snapshot) {
                                    return GetPlans.gpp != null &&
                                            GetPlans.gpp?.data != null &&
                                            GetPlans.gpp!.data!.isNotEmpty
                                        ? Container(
                                            // margin: EdgeInsets.only(
                                            //     left:
                                            //         MediaQuery.of(context).size.width * 0.03),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 4),
                                            width: double.infinity,
                                            child: ElevatedButton(
                                                onPressed: agree == false
                                                    ? () {}
                                                    : () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UpgradeSubscription(
                                                                    planModel:
                                                                        premiumPlans,
                                                                  )),
                                                          // arguments: FreemiumConfirmationArgs(
                                                          //     planModel: premiumPlans)
                                                        );
                                                      },
                                                child: CustomText(
                                                  'upgrade now'.toUpperCase(),
                                                  color: AppTheme.whiteColor,
                                                  size: (18),
                                                  bold: FontWeight.bold,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    padding: EdgeInsets.all(15),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    primary: agree == true
                                                        ? AppTheme.electricBlue
                                                        : AppTheme.coolGrey)),
                                          )
                                        : Container();
                                  })
                                : Container(),

                            SizedBox(
                              height: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    isLoading == false
                        ? Container(
                            // height: MediaQuery.of(context).size.height * 0.02,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: agree,
                                  onChanged: (value) {
                                    setState(() {
                                      agree = value!;
                                    });
                                  },
                                ),
                                CustomText(
                                  'I have read and agree to the Terms and Conditions',
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: ShimmerText()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get shimmerTicket => Container(
        child: Column(children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.2),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: ShimmerText()),
                ]),
          ),
          ShimmerListTile(),
          ShimmerListTile(),
          ShimmerListTile(),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          Center(child: ShimmerText()),
          Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              alignment: Alignment.center,
              child: ShimmerButton()),
          Center(child: ShimmerText()),
          Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.2),
              alignment: Alignment.center,
              child: ShimmerButton()),
          Center(child: ShimmerText()),
          Center(child: ShimmerText()),
          Center(child: ShimmerText()),
          //   ],
          // )
        ]),
      );

  // Widget analyticsData() {
  //   return Container(
  //       margin: EdgeInsets.symmetric(horizontal: 40),
  //       decoration: BoxDecoration(
  //           color: Colors.white,
  //           border: Border.all(
  //             color: Color.fromRGBO(16, 88, 255, 0.5),
  //           ),
  //           borderRadius: BorderRadius.circular(10)),
  //       child: Column(
  //         children: [
  //           Row(
  //             children: [
  //               Container(
  //                 margin: EdgeInsets.only(
  //                     left: MediaQuery.of(context).size.width * 0.03),
  //                 padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
  //                 decoration: BoxDecoration(
  //                   color: Color.fromRGBO(242, 255, 247, 1),
  //                   borderRadius: BorderRadius.circular(5),
  //                   border: Border.all(color: AppTheme.greenColor),
  //                 ),
  //                 child: Text(
  //                   '20% OFF',
  //                   style: TextStyle(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.w900,
  //                       color: AppTheme.greenColor),
  //                 ),
  //               ),
  //               Container(
  //                 height: 22,
  //                 width: 22,
  //                 decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     color: planDetail.plan?.activeStatus == true
  //                         ? Color.fromRGBO(78, 216, 167, 1)
  //                         : Colors.white,
  //                     border: Border.all(width: 2, color: AppTheme.greencyan)),
  //                 child: planDetail.plan?.activeStatus == true
  //                     ? Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 3.0),
  //                         child: Icon(
  //                           Icons.check,
  //                           size: 13.0,
  //                           color: Colors.white,
  //                         ))
  //                     : Container(),
  //               )
  //             ],
  //           ),
  //         ],
  //       ));
  // }
}

enum check { monthly, yearly, free }
