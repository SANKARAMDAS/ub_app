import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Models/plan_model.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/shimmer_widgets.dart';
import 'package:urbanledger/screens/Freemium/confirmation_screen_1.dart';
import 'package:urbanledger/screens/Freemium/freemium_provider.dart';

import '../../main.dart';

class UrbanLedgerPremium extends StatefulWidget {
  @override
  _UrbanLedgerPremiumState createState() => _UrbanLedgerPremiumState();
}

class _UrbanLedgerPremiumState extends State<UrbanLedgerPremium> {
  bool agree = true;
  int? index = 2;
  List<PlanModel> premiumPlans = [];
  final GlobalKey<State> key = GlobalKey<State>();
  bool isEmiratesIdDone = false;
  bool isTradeLicenseDone = false;
  bool status = false;
  bool isPremium = false;
  bool isLoading = true;
  String? planPurchase;

// Future getKyc() async {
//     setState(() {
//       isLoading = true;
//     });
//     await KycAPI.kycApiProvider.kycCheker().catchError((e) {
//       setState(() {
//         isLoading = false;
//       });
//       'Something went wrong. Please try again later.'.showSnackBar(context);
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

    getPremiumPlans();
    // getKyc();
    calculatePremiumDate();
  }

  Future<void> getPremiumPlans() async {
    Provider.of<FreemiumProvider>(context, listen: false).clearSubcription();
    if (mounted) {
      setState(() {
        index =
            Provider.of<FreemiumProvider>(context, listen: false).index ?? 2;
      });
    }
    debugPrint('index: ' + index.toString());
    repository.freemiumApi.getPremiumPlans().timeout(Duration(seconds: 30),
        onTimeout: () async {
      Navigator.of(context).pop();
      return Future.value(null);
    }).then((value) {
      // Navigator.of(context).pop();
      premiumPlans = value;
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    debugPrint('ade50 :' + premiumPlans.length.toString());
    // return premiumPlans;
  }

  void _doSomething() {
    // Navigator.of(context).pushNamed(AppRoutes.confirmationScreen1Route,
    //     arguments: FreemiumConfirmationArgs(premiumPlans));
    debugPrint(index.toString());
    // if(){
    //   displayModalBottomSheet(context);
    // }
    Provider.of<FreemiumProvider>(context, listen: false).index = index;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen1(
          planModel: premiumPlans,
          // index: index,
        ),
      ),
    );
  }

  displayModalBottomSheet(BuildContext context) {
    final GlobalKey<State> key = GlobalKey<State>();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.12,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: Offset(0, -15), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8),
                  padding: EdgeInsets.only(bottom: 22.0),
                  child: Image.asset(
                    'assets/icons/handle.png',
                    scale: 1.5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: NewCustomButton(
                        onSubmit: () async {
                          // Navigator.pushNamed(context, AppRoutes.payTransactionRoute);
                        },
                        text: 'Pay'.toUpperCase(),
                        textColor: Colors.white,
                        backgroundColor: AppTheme.electricBlue,
                        textSize: 15.0,
                        fontWeight: FontWeight.bold,
                        // width: 185,
                        height: 40,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: NewCustomButton(
                        onSubmit: () async {},
                        text: 'Request'.toUpperCase(),
                        textColor: Colors.white,
                        backgroundColor: AppTheme.electricBlue,
                        textSize: 15.0,
                        fontWeight: FontWeight.bold,
                        // width: 185,
                        height: 40,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      appBar: AppBar(
        title: Text('UrbanLedger Premium'),
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

            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/images/BG.png",
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
            // Image.asset("assets/images/BG.png", fit: BoxFit.cover,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 30, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image.asset(
                      //   'assets/images/Benifits.png',
                      //   // height: 55,
                      //   width: 250,
                      //   alignment: Alignment.center,
                      // ),
                      // SizedBox(height: 5),
                      isLoading == false
                      ? Container(
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                left: 45,
                                right: 45,
                              ),
                              // decoration: BoxDecoration(
                              //   boxShadow: [
                              //               BoxShadow(
                              //                 color:
                              //                     Colors.grey.withOpacity(0.1),
                              //                     spreadRadius: 2,
                              //                 blurRadius: 15,
                              //                 offset: Offset(0,
                              //                     1),
                              //               ),
                              //             ],
                              // ),
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
                                  130.0.heightBox,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      80.0.widthBox,
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppTheme.greyish,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                      SizedBox(width: 10),
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
                                      80.0.widthBox,
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppTheme.greyish,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                      SizedBox(width: 10),
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
                                      80.0.widthBox,
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppTheme.greyish,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                      SizedBox(width: 10),
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
                          ],
                        ),
                      ):shimmerTicket,
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
                      ):Container(),
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
                              'Premium ',
                              style: TextStyle(
                                color: AppTheme.brownishGrey,
                                fontFamily: 'SFProDisplay',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ):Container(),
                      SizedBox(height: 10),
                      isLoading == false
                      ? Container(
                        height: 255,
                        // color: Colors.amber,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(top: 5.0),
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: premiumPlans.length,
                          shrinkWrap: true,
                          itemBuilder: (context, int i) {
                            return Padding(
                                padding: i == premiumPlans.length
                                    ? const EdgeInsets.only(right: 0)
                                    : const EdgeInsets.only(left: 8, right: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    //           cardId = Provider.of<FreemiumProvider>(context,
                                    //     listen: false)
                                    // .planID
                                    setState(() {
                                      index = i;
                                      Provider.of<FreemiumProvider>(context,
                                              listen: false)
                                          .index = i;
                                      Provider.of<FreemiumProvider>(context,
                                              listen: false)
                                          .planID = premiumPlans[i].id;

                                      debugPrint('index: ' + index.toString());
                                    });
                                  },
                                  child: Container(
                                    height: 250,
                                    width: 190,
                                    decoration: BoxDecoration(
                                        color: index == i
                                            ? Color.fromRGBO(240, 245, 255, 1)
                                            : Colors.white,
                                        border: Border.all(
                                            color: index == i
                                                ? Color.fromRGBO(
                                                    16, 88, 255, 0.5)
                                                : AppTheme
                                                    .circularAvatarTextColor),
                                        borderRadius: BorderRadius.circular(10)
                                        /*  image: DecorationImage(
                                                    image: AssetImage(
                                                      'assets/images/Ticket.png',
                                                    ),
                                                  ),
                                                  boxShadow: [
                                                    index == i
                                                        ? BoxShadow(
                                                            color: AppTheme
                                                                .electricBlue
                                                                .withOpacity(0.3),
                                                            blurRadius: 7,
                                                            offset: Offset(0, 0),
                                                          )
                                                        : BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(0.1),
                                                            blurRadius: 7,
                                                            offset: Offset(0, 0),
                                                          ),
                                                  ], */
                                        ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        premiumPlans[i].discount != 0
                                            ? CustomText(
                                                '${premiumPlans[i].discount.toString()}% OFF',
                                                size: 22,
                                                bold: FontWeight.w800,
                                                color: AppTheme.greenColor,
                                              )
                                            : SizedBox(
                                                height: 22,
                                              ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        CustomText(
                                          'AED',
                                          size: 18,
                                          bold: FontWeight.w600,
                                          color: AppTheme.brownishGrey,
                                        ),
                                        CustomText(
                                          removeDecimalif0(
                                              premiumPlans[i].amount -
                                                  (premiumPlans[i].amount *
                                                          (premiumPlans[i]
                                                              .discount)) /
                                                      100),
                                          size: 38,
                                          bold: FontWeight.w800,
                                          color: AppTheme.brownishGrey,
                                        ),
                                        CustomText(
                                          premiumPlans[i].name.toLowerCase(),
                                          size: 18,
                                          bold: FontWeight.w600,
                                          color: AppTheme.brownishGrey,
                                        ),
                                        premiumPlans[i].discount != 0
                                            ? Text(
                                                'AED ${(premiumPlans[i].amount)}',
                                                style: TextStyle(
                                                  color: AppTheme.greyish,
                                                  decorationColor:
                                                      AppTheme.greyish,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              )
                                            : Container(),
                                        SizedBox(height: 15),
                                        CustomText(
                                          'Per active user, per\n${premiumPlans[i].days == 365 ? 'year billed annually' : 'month'}',
                                          size: 14,
                                          bold: FontWeight.w400,
                                          color: AppTheme.brownishGrey,
                                          centerAlign: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                // GestureDetector(
                                //   onTap: () {
                                //     setState(() {
                                //       // index = 2;
                                //       index = 2;
                                //       Provider.of<FreemiumProvider>(
                                //               context,
                                //               listen: false)
                                //           .index = 2;
                                //       debugPrint(
                                //           'index: ' + index.toString());
                                //     });
                                //   },
                                //   child: Container(
                                //     height: 250,
                                //     width: 200,
                                //     decoration: BoxDecoration(
                                //       // border: index == 2 ? Border.all(color: AppTheme.electricBlue, width: 1) : Border.all(color: Colors.transparent,width: 0),
                                //       image: DecorationImage(
                                //         image: AssetImage(
                                //           'assets/images/Ticket.png',
                                //         ),
                                //       ),
                                //       boxShadow: [
                                //         index == 2
                                //             ? BoxShadow(
                                //                 color: AppTheme
                                //                     .electricBlue
                                //                     .withOpacity(0.3),
                                //                 blurRadius: 7,
                                //                 offset: Offset(0, 0),
                                //               )
                                //             : BoxShadow(
                                //                 color: Colors.grey
                                //                     .withOpacity(0.1),
                                //                 blurRadius: 7,
                                //                 offset: Offset(0, 0),
                                //               ),
                                //       ],
                                //     ),
                                //     child: Column(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.center,
                                //       children: [
                                //         5.0.heightBox,
                                //         CustomText(
                                //           '${premiumPlans[1].discount.toString()}% OFF',
                                //           size: 22,
                                //           bold: FontWeight.w800,
                                //           color: AppTheme.greenColor,
                                //         ),
                                //         SizedBox(
                                //           height: 10,
                                //         ),
                                //         CustomText(
                                //           'AED',
                                //           size: 18,
                                //           bold: FontWeight.w600,
                                //           color: AppTheme.brownishGrey,
                                //         ),
                                //         CustomText(
                                //           removeDecimalif0(premiumPlans[1]
                                //                   .amount -
                                //               (premiumPlans[1].amount *
                                //                       (premiumPlans[1]
                                //                           .discount)) /
                                //                   100),
                                //           size: 38,
                                //           bold: FontWeight.w800,
                                //           color: AppTheme.brownishGrey,
                                //         ),
                                //         CustomText(
                                //           premiumPlans[1].name.toString(),
                                //           size: 18,
                                //           bold: FontWeight.w600,
                                //           color: AppTheme.brownishGrey,
                                //         ),
                                //         SizedBox(
                                //           height: 3,
                                //         ),
                                //         Text(
                                //           'AED ${(premiumPlans[i].amount) * 12}',
                                //           style: TextStyle(
                                //             color: AppTheme.greyish,
                                //             decorationColor:
                                //                 AppTheme.greyish,
                                //             decoration: TextDecoration
                                //                 .lineThrough,
                                //             fontSize: 18,
                                //             fontWeight: FontWeight.w700,
                                //           ),
                                //         ),
                                //         // CustomText(
                                //         //   'AED600',
                                //         //   size: 18,
                                //         //   bold: FontWeight.bold,
                                //         //   color: AppTheme.greyish,
                                //         //   underline:
                                //         //       TextDecoration.lineThrough,

                                //         // ),
                                //         SizedBox(
                                //           height: 6,
                                //         ),
                                //         CustomText(
                                //           'Per active user, per\nyear billed annually',
                                //           size: 14,
                                //           bold: FontWeight.w400,
                                //           color: AppTheme.brownishGrey,
                                //           centerAlign: true,
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),

                                );
                          },
                        ),
                      ):Container(),
                      isLoading == false
                      ? Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: ElevatedButton(
                          onPressed: agree ? _doSomething : null,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: CustomText('UPGRADE NOW'.toUpperCase(),
                              color: Colors.white,
                              size: 18,
                              bold: FontWeight.w500),
                          //isChecked ? displayMessage : null,
                        ),
                      ):Container(),
                      5.0.heightBox,
                      isLoading == false
                      ? Container(
                        height: MediaQuery.of(context).size.height * 0.02,
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
                            Text(
                              'I have read and agree to the Terms and Conditions',
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ):Container(),
                      // ElevatedButton(
                      //     onPressed: agree ? _doSomething : null,
                      //     child: Text('Continue')),
                      //child: Text("Countinue"),

                      // Container(
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Container(
                      //         padding: const EdgeInsets.only(top: 5.0),
                      //         width: double.infinity,
                      //         margin: const EdgeInsets.symmetric(
                      //             horizontal: 10, vertical: 20),
                      //         child: ElevatedButton(
                      //           onPressed: () {
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       ConfirmationScreen1()),
                      //             );
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             padding: EdgeInsets.all(18),
                      //             shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(10)),
                      //           ),
                      //           child: CustomText('UPGRADE NOW'.toUpperCase(),
                      //               color: Colors.white,
                      //               size: 18,
                      //               bold: FontWeight.w500),
                      //           //isChecked ? displayMessage : null,
                      //         ), //child: Text("Countinue"),
                      //       ),
                      //
                    ],
                  ),
                ).flexible,
              ],
            ),
            // Container(
            //   alignment: Alignment.bottomCenter,
            //   decoration: BoxDecoration(
            //     color: Color(0xfff2f1f6),
            //     image: DecorationImage(
            //       fit: BoxFit.cover,
            //       image: AssetImage("assets/images/BG.png"),
            //       alignment: Alignment.bottomCenter,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget get shimmerTicket => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(child: ShimmerText()),
                Center(child: ShimmerText()),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(child: ShimmerText()),
                Center(child: ShimmerText()),
              ],
            ),
          ),
          //   ],
          // )
        ]),
      );

  Widget listPremium(List<PlanModel> listData) {
    return ListView.builder(
      itemCount: listData.length,
      itemBuilder: (context, i) {
        return Text(listData[i].name);
      },
    );
  }
}
