import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Models/PremiumPurchaseTrackingModel.dart';
import 'package:urbanledger/Models/plan_model.dart';
import 'package:urbanledger/Services/APIs/freemium_api.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Add%20Card/add_card_screen.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/screens/Freemium/freemium_provider.dart';
import 'package:urbanledger/screens/Freemium/save_card_freemium.dart';
import 'package:urbanledger/screens/Freemium/urbanledger_premium_welcome.dart';
import 'package:urbanledger/screens/TransactionScreens/add_cards_provider.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import 'package:urbanledger/screens/transaction_failed.dart';

class ConfirmationScreen1 extends StatefulWidget {
  List<PlanModel> planModel = [];

  // ConfirmationScreen1({Key? key}, required this.planModel) : super(key: key);
  ConfirmationScreen1({required this.planModel});
  @override
  _ConfirmationScreen1State createState() => _ConfirmationScreen1State();
}

class _ConfirmationScreen1State extends State<ConfirmationScreen1> {
  check selected = check.yearly;
  String? amount;
  String? cardNo;
  String? cardImage;
  String? cardName;
  String? planId;
  String? cardId;
  PremiumStartOrderSession? OSession;
  bool isEmiratesIdDone = false;
  bool isTradeLicenseDone = false;
  bool status = false;
  bool checkedValue = true;
  bool isPremium = false;
  bool isLoading = false;

  final GlobalKey<State> key = GlobalKey<State>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCar();
    Osess();
  }

  Osess() async {
    setState(() {
      isLoading = true;
    });
    OSession = await FreemiumAPI.freemiumApi.startOrderSessionPremiumPLan();
    setState(() {
      isLoading = false;
    });
  }

  cancelOsession({PremiumStartOrderSession? OSession}) async {
    await FreemiumAPI.freemiumApi
        .cancelOrderSessionPremiumPLan(orderID: OSession!.id);
  }

  getCar() async {
    // debugPrint('1 :'+widget.planModel[2].amount.toString());
    if (mounted) {
      if (Provider.of<FreemiumProvider>(context, listen: false).index == 0) {
        if (mounted) {
          setState(() {
            debugPrint('0 :');
            selected = check.monthly;
            amount = widget.planModel[0].amount.toString();
            planId = widget.planModel[0].id;
            debugPrint('Init:' + planId.toString());
            debugPrint('Init:' + amount.toString());
          });
        }
        Provider.of<FreemiumProvider>(context, listen: false).planID = planId;
        Provider.of<FreemiumProvider>(context, listen: false).amountID = amount;
        Provider.of<AddCardsProvider>(context, listen: false).getCard();
      } else {
        if (mounted) {
          setState(() {
            debugPrint('1 :');
            selected = check.yearly;
            planId = widget.planModel[1].id;
            amount = removeDecimalif0(widget.planModel[1].amount -
                (widget.planModel[1].amount * (widget.planModel[1].discount)) /
                    100);
          });
        }
      }
      // amount = removeDecimalif0(widget.planModel[1].amount -
      //     (widget.planModel[1].amount * (widget.planModel[1].discount)) / 100);
      setState(() {
        planId = widget.planModel[1].id;
      });
      Provider.of<FreemiumProvider>(context, listen: false).planID = planId;
      Provider.of<FreemiumProvider>(context, listen: false).amountID = amount;
      Provider.of<AddCardsProvider>(context, listen: false).getCard();
    }

    if (selected == check.monthly) {
      Provider.of<FreemiumProvider>(context, listen: false).planID =
          widget.planModel[0].id;
    } else {
      Provider.of<FreemiumProvider>(context, listen: false).planID =
          widget.planModel[1].id;
    }
  }

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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        cancelOsession(OSession: OSession);
        Navigator.of(context).pop(true);
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.paleGrey,
        bottomNavigationBar: isLoading?Container():Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Consumer<AddCardsProvider>(
            builder: (ctx, card, child) {
              Provider.of<FreemiumProvider>(context, listen: true).cardID =
                  card.selectedCard?.id.toString();
              card.card!.forEach((element) {
                // if (element.isdefault.toString() == '1') {
                cardNo = element.endNumber!
                    .replaceRange(0, 5, '')
                    .replaceAll(' ', ' - ')
                    .toUpperCase();
                cardImage = element.cardImage;
                cardName = element.hashedName;
                cardId = (Provider.of<FreemiumProvider>(context, listen: true)
                                .cardID !=
                            null &&
                        Provider.of<FreemiumProvider>(context, listen: true)
                            .cardID!
                            .isNotEmpty
                    ? Provider.of<FreemiumProvider>(context, listen: false)
                        .cardID
                    : element.id);
                // }
                debugPrint('carddd ' + element.endNumber.toString());
                debugPrint('carddd ' + element.toJson().toString());
              });
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    flex: 1,
                    child: Provider.of<AddCardsProvider>(context, listen: true)
                            .card!
                            .isEmpty
                        ? NewCustomButton(
                            onSubmit: () {
                              // );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddCardScreen(),
                                  ));

                              if (mounted) {
                                setState(() {});
                              }
                            },

                            text: 'Add new card'.toUpperCase(),
                            textColor: Colors.white,
                            backgroundColor: AppTheme.electricBlue,
                            textSize: 18.0,
                            fontWeight: FontWeight.bold,
                            // width: 185,
                          )
                        : PayCustomButton(
                            onSubmit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SaveCardFreemium()),
                              );
                            },
                            prefixImage1: cardImage,
                            imageSize1: 14,
                            text1: 'Pay using'.toUpperCase(),
                            textSize1: 16,
                            textColor1: Colors.white,
                            text2:
                                '${Provider.of<FreemiumProvider>(context).cardNumber != null ? Provider.of<FreemiumProvider>(context).cardNumber : cardNo.toString()}',
                            textSize2: 16,
                            textColor2: Colors.white,
                            suffixImage1: "assets/icons/UP_Arrow-01.png",
                            imageSize2: 8,
                          ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 1,
                    child: card.card!.isEmpty
                        ? NewCustomButton(
                            onSubmit: () {},
                            text: 'pay $currencyAED $amount'.toUpperCase(),
                            textColor: Colors.white,
                            backgroundColor: AppTheme.coolGrey,
                            textSize: 18.0,
                            fontWeight: FontWeight.bold,
                            // width: 185,
                          )
                        : NewCustomButton(
                            onSubmit:OSession !=null? () async {

                              try{
                                setState(() {});
                                if (Provider.of<FreemiumProvider>(context,
                                    listen: false)
                                    .cardID !=
                                    null) {
                                  cardId = Provider.of<FreemiumProvider>(context,
                                      listen: false)
                                      .cardID
                                      .toString();
                                  debugPrint('Plan ID:' +
                                      Provider.of<FreemiumProvider>(context,
                                          listen: false)
                                          .planID
                                          .toString() +
                                      ' ' +
                                      'Card id : ' +
                                      Provider.of<FreemiumProvider>(context,
                                          listen: false)
                                          .cardID
                                          .toString());
                                  CustomLoadingDialog.showLoadingDialog(
                                      context, key);
                                  Map payDetails = {
                                    "card_id": cardId,
                                    "amount": amount,
                                    "currency": "AED",
                                    "send_to": "60eda791f9f00d49bbe2eacb"
                                  };

                                  debugPrint('Init' + payDetails.toString());
                                  // Provider.of<AddCardsProvider>(context,
                                  //         listen: false)
                                  //     .paymentThroughCard(payDetails)
                                  //     .timeout(Duration(seconds: 30),
                                  //         onTimeout: () async {
                                  //   Navigator.of(context).pop();
                                  //   return Future.value(null);
                                  // }).then((value) async {
                                  //   debugPrint('Checks' + value.toString());
                                  //
                                  // });

                                  if (OSession != null &&
                                      OSession!.id!.isNotEmpty) {
                                    Map<String, dynamic> data = {
                                      "planId": widget
                                          .planModel[
                                      selected == check.monthly ? 0 : 1]
                                          .id,
                                      "cardId": Provider.of<FreemiumProvider>(
                                          context,
                                          listen: false)
                                          .cardID
                                          .toString(),
                                      "order_id": "${OSession!.id}",
                                    };
                                    // cc.selectedCard = null;
                                    debugPrint('Init' + data.toString());
                                    var subscriptionResponse = await repository
                                        .freemiumApi
                                        .purchaseSubscriptionPlan(data);
                                    if (subscriptionResponse['status'] == true) {
                                      var anaylticsEvents =
                                      AnalyticsEvents(context);
                                      await anaylticsEvents.initCurrentUser();
                                      await anaylticsEvents
                                          .sendPremiumPurchaseEvent();

                                      Provider.of<FreemiumProvider>(context,
                                          listen: false)
                                          .cardNumber = null;
                                      await KycAPI.kycApiProvider
                                          .kycCheker()
                                          .then((value) {
                                        bool? isPremium =
                                            value['premium'] ?? false;
                                        setState(() {
                                          Repository().hiveQueries.insertUserData(
                                            Repository()
                                                .hiveQueries
                                                .userData
                                                .copyWith(
                                              premiumStatus: isPremium ==
                                                  true
                                                  ? int.parse(value[
                                              'planDuration'])
                                                  : 0,
                                              premiumExpDate:
                                              DateTime.parse(
                                                  value['expDate']
                                                      .toString()),
                                            ),
                                          );
                                        });
                                      });

                                      Navigator.of(context).pop(true);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UrbanLedgerPremiumWelcome()),
                                      );
                                    } else {
                                      Navigator.of(context).pop(true);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionFailedScreen(
                                                  model: subscriptionResponse,
                                                  // customermodel: widget.model,
                                                ),
                                          ));
                                    }
                                  }
                                } else {
                                  // cardId = cardId;
                                  debugPrint('Plan ID:' +
                                      Provider.of<FreemiumProvider>(context,
                                          listen: false)
                                          .planID
                                          .toString());
                                  CustomLoadingDialog.showLoadingDialog(
                                      context, key);
                                  Map payDetails = {
                                    "card_id": cardId,
                                    "amount": amount,
                                    "currency": "AED",
                                    "send_to": "60eda791f9f00d49bbe2eacb"
                                  };
                                  debugPrint(payDetails.toString());
                                  // Provider.of<AddCardsProvider>(context,
                                  //         listen: false)
                                  //     .paymentThroughCard(payDetails)
                                  //     .timeout(Duration(seconds: 30),
                                  //         onTimeout: () async {
                                  //   Navigator.of(context).pop();
                                  //   return Future.value(null);
                                  // }).then((value) async {
                                  //   debugPrint('Checks' + value.toString());
                                  //
                                  //
                                  // });

                                  if (OSession != null &&
                                      OSession!.id!.isNotEmpty) {
                                    Map<String, dynamic> data = {
                                      "planId": Provider.of<FreemiumProvider>(
                                          context,
                                          listen: false)
                                          .planID
                                          .toString(),
                                      "cardId": cardId,
                                      "order_id": "${OSession!.id}",
                                    };
                                    // cc.selectedCard = null;
                                    debugPrint(data.toString());
                                    var subscriptionResponse = await repository
                                        .freemiumApi
                                        .purchaseSubscriptionPlan(data);
                                    if (subscriptionResponse['status'] == true) {
                                      var anaylticsEvents =
                                      AnalyticsEvents(context);
                                      await anaylticsEvents.initCurrentUser();
                                      await anaylticsEvents
                                          .sendPremiumPurchaseEvent();
                                      // await getKyc();

                                      Navigator.of(context).pop(true);
                                      Provider.of<FreemiumProvider>(context,
                                          listen: false)
                                          .cardID = null;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UrbanLedgerPremiumWelcome()),
                                      );
                                    } else {
                                      Navigator.of(context).pop(true);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionFailedScreen(
                                                  model: subscriptionResponse,
                                                  // customermodel: widget.model,
                                                ),
                                          ));
                                    }
                                  } else {
                                    Navigator.pop(context);
                                  }
                                }
                              }
                              catch(e){
                                print(e);
                                Navigator.of(context).pop();

                              }

                              // if (Provider.of<FreemiumProvider>(context,
                              //             listen: false)
                              //         .cardID
                              //         .toString()
                              //         .isNotEmpty &&
                              //     Provider.of<FreemiumProvider>(context,
                              //             listen: false)
                              //         .planID
                              //         .toString()
                              //         .isNotEmpty) {

                              // }
                            }:(){

                            },
                            text: 'pay $currencyAED $amount'.toUpperCase(),
                            textColor: Colors.white,
                            backgroundColor: AppTheme.electricBlue,
                            textSize: 18.0,
                            fontWeight: FontWeight.bold,
                            // width: 185,
                          ),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                ],
              );
            },
          ),
        ),
        extendBody: true,
        appBar: AppBar(
          title: Text('Select your subscription plan'),
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              onPressed: () {
                cancelOsession(OSession: OSession);
                Navigator.of(context).pop(true);
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                size: 22,
              ),
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/plan-background-1.png'),
                      alignment: Alignment.bottomCenter),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.08),
                child: ListView.builder(
                    itemCount: widget.planModel.length,
                    shrinkWrap: true,
                    itemBuilder: (context, int i) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = i == 0 ? check.monthly : check.yearly;

                              amount = removeDecimalif0(
                                  widget.planModel[i].amount -
                                      (widget.planModel[i].amount *
                                              (widget.planModel[i].discount)) /
                                          100);
                              planId = widget.planModel[i].id;
                              debugPrint('Check Plain ID' + planId.toString());
                            });

                            Provider.of<FreemiumProvider>(context,
                                    listen: false)
                                .planID = planId;
                            Provider.of<FreemiumProvider>(context,
                                    listen: false)
                                .amountID = amount;
                            debugPrint('Checking from provider' +
                                Provider.of<FreemiumProvider>(context,
                                        listen: false)
                                    .planID
                                    .toString());
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                color: selected.index == i
                                    ? Color.fromRGBO(240, 245, 255, 1)
                                    : Colors.white,
                                border: Border.all(
                                    color: selected.index == i
                                        ? Color.fromRGBO(16, 88, 255, 0.5)
                                        : AppTheme.circularAvatarTextColor),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                15.0.widthBox,
                                Image.asset(
                                  'assets/images/crown.png',
                                  height: 45,
                                  width: 35,
                                ),
                                12.0.widthBox,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.planModel[i].name} Subscription',
                                      style: TextStyle(
                                          color: Color(0xff1058ff),
                                          fontWeight:
                                              FontWeight.w700, //FontWeight.w500
                                          fontSize: 18),
                                    ),
                                    if (widget.planModel[i].discount != 0)
                                      CustomText(
                                        '${widget.planModel[i].discount.toString()}% OFF',
                                        size: 16,
                                        bold: FontWeight.w800,
                                        color: AppTheme.greenColor,
                                      ),
                                    if (widget.planModel[i].discount != 0)
                                      Text(
                                        'AED ${(widget.planModel[i].amount)}',
                                        style: TextStyle(
                                          color: AppTheme.greyish,
                                          decorationColor: AppTheme.greyish,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Text(
                                      'AED ',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'SFProDisplay',
                                          fontWeight:
                                              FontWeight.w600, //FontWeight.w500
                                          fontSize: 18),
                                    ),
                                    Text(
                                      removeDecimalif0(
                                          widget.planModel[i].amount -
                                              (widget.planModel[i].amount *
                                                      (widget.planModel[i]
                                                          .discount)) /
                                                  100),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'SFProDisplay',
                                          fontWeight:
                                              FontWeight.w900, //FontWeight.w500
                                          fontSize: 32),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selected.index == i
                                          ? Color.fromRGBO(78, 216, 167, 1)
                                          : Colors.white,
                                      // color: Colors.white,
                                      border: Border.all(
                                          width: 2, color: AppTheme.greencyan)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Icon(
                                        Icons.check,
                                        size: 13.0,
                                        color: Colors.white,
                                      )),
                                ),
                                20.0.widthBox
                              ],
                            ),
                          ),
                        ),
                      );

                      // Container(
                      //   margin: EdgeInsets.symmetric(horizontal: 10),
                      //   child: Card(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     child: ListTile(
                      //       onTap: () {
                      //         setState(() {
                      //           selected = check.yearly;
                      //           amount = removeDecimalif0(widget
                      //                   .planModel[1].amount -
                      //               (widget.planModel[1].amount *
                      //                       (widget.planModel[1].discount)) /
                      //                   100);
                      //           planId = widget.planModel[1].id;
                      //         });
                      //         Provider.of<FreemiumProvider>(context,
                      //                 listen: false)
                      //             .planID = planId;
                      //         debugPrint('Checking from provider' +
                      //             Provider.of<FreemiumProvider>(context,
                      //                     listen: false)
                      //                 .planID
                      //                 .toString());
                      //         Provider.of<FreemiumProvider>(context,
                      //                 listen: false)
                      //             .amountID = amount;
                      //       },
                      //       leading: Image.asset(
                      //         'assets/images/crown.png',
                      //         height: 45,
                      //         width: 35,
                      //       ),
                      //       title: Row(
                      //         mainAxisAlignment:
                      //             MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Column(
                      //             crossAxisAlignment:
                      //                 CrossAxisAlignment.start,
                      //             children: [
                      //               Text(
                      //                 '${widget.planModel[1].name} Subscription',
                      //                 style: TextStyle(
                      //                     color: Color(0xff1058ff),
                      //                     fontFamily: 'SFProDisplay',
                      //                     fontWeight: FontWeight
                      //                         .w500, //FontWeight.w500
                      //                     fontSize: 20),
                      //               ),
                      //               SizedBox(
                      //                 height: 2,
                      //               ),
                      //               Text(
                      //                 '${widget.planModel[1].discount}% OFF',
                      //                 style: TextStyle(
                      //                     color: Colors.green,
                      //                     fontFamily: 'SFProDisplay',
                      //                     fontWeight: FontWeight
                      //                         .w500, //FontWeight.w500
                      //                     fontSize: 18),
                      //               ),
                      //               SizedBox(
                      //                 height: 2,
                      //               ),
                      //               Text(
                      //                 'AED ${widget.planModel[1].amount}',
                      //                 style: TextStyle(
                      //                     color: AppTheme.greyish,
                      //                     fontFamily: 'SFProDisplay',
                      //                     decoration:
                      //                         TextDecoration.lineThrough,
                      //                     fontWeight: FontWeight
                      //                         .w500, //FontWeight.w500
                      //                     fontSize: 12),
                      //               ),
                      //               SizedBox(
                      //                 height: 2,
                      //               ),
                      //             ],
                      //           ),
                      //           RichText(
                      //             text: new TextSpan(
                      //               // Note: Styles for TextSpans must be explicitly defined.
                      //               // Child text spans will inherit styles from parent
                      //               style: TextStyle(
                      //                   color: Color(0xff666666),
                      //                   fontFamily: 'SFProDisplay',
                      //                   fontSize: 16),
                      //               children: <TextSpan>[
                      //                 new TextSpan(
                      //                   text: 'AED ',
                      //                   style: TextStyle(
                      //                       color: Colors.black54,
                      //                       fontFamily: 'SFProDisplay',
                      //                       fontWeight: FontWeight
                      //                           .w500, //FontWeight.w500
                      //                       fontSize: 22),
                      //                 ),
                      //                 new TextSpan(
                      //                   text: removeDecimalif0(
                      //                       widget.planModel[1].amount -
                      //                           (widget.planModel[1].amount *
                      //                                   (widget.planModel[1]
                      //                                       .discount)) /
                      //                               100),
                      //                   style: TextStyle(
                      //                       color: Colors.black54,
                      //                       fontFamily: 'SFProDisplay',
                      //                       fontWeight: FontWeight
                      //                           .w900, //FontWeight.w500
                      //                       fontSize: 28),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       trailing: Container(
                      //         height: 22,
                      //         width: 22,
                      //         decoration: BoxDecoration(
                      //             shape: BoxShape.circle,
                      //             color: selected == check.yearly
                      //                 ? Color.fromRGBO(78, 216, 167, 1)
                      //                 : Colors.white,
                      //             border: Border.all(
                      //                 width: 2, color: AppTheme.greencyan)),
                      //         child: Padding(
                      //             padding: const EdgeInsets.all(3.0),
                      //             child: Icon(
                      //               Icons.check,
                      //               size: 13.0,
                      //               color: Colors.white,
                      //             )),
                      //       ),
                      //       dense: true,
                      //     ),
                      //   ),
                      // ),

                      // SizedBox(
                      //   height: 50,
                      // ),
                      // Container(
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/plan.png',
                      //         height: MediaQuery.of(context).size.height * 0.3,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   // height: MediaQuery.of(context).size.height * 0.0999,
                      //   height: 170,
                      // ),
                    }),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}

enum check { monthly, yearly }
