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
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Freemium/freemium_provider.dart';
import 'package:urbanledger/screens/Freemium/save_card_freemium.dart';
import 'package:urbanledger/screens/Freemium/urbanledger_premium_welcome.dart';
import 'package:urbanledger/screens/TransactionScreens/add_cards_provider.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import 'package:urbanledger/screens/transaction_failed.dart';

class UpgradeSubscription extends StatefulWidget {
  List<PlanModel> planModel = [];

  // ConfirmationScreen1({Key? key}, required this.planModel) : super(key: key);
  UpgradeSubscription({required this.planModel});

  @override
  _UpgradeSubscriptionState createState() => _UpgradeSubscriptionState();
}

class _UpgradeSubscriptionState extends State<UpgradeSubscription> {
  check selected = check.yearly;
  String? amount;
  String? cardNo;
  String? cardImage;
  String? cardName;
  String? planId;
  String? cardId;
  PremiumStartOrderSession? OSession;
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
    var fProv = Provider.of<FreemiumProvider>(context, listen: false);
    if (fProv.index == 0) {
      debugPrint('0 :');
      selected = check.monthly;
      amount = widget.planModel[0].amount.toString();
    } else {
      debugPrint('1 :');
      selected = check.yearly;
      amount = removeDecimalif0(widget.planModel[1].amount -
          (widget.planModel[1].amount * (widget.planModel[1].discount)) / 100);
    }
    // amount = removeDecimalif0(widget.planModel[1].amount -
    //     (widget.planModel[1].amount * (widget.planModel[1].discount)) / 100);
    planId = widget.planModel[1].id;
    fProv.planID = planId;
    fProv.amountID = amount;
    await Provider.of<AddCardsProvider>(context, listen: false).getCard();
  }

  @override
  Widget build(BuildContext context) {
    var fProv = Provider.of<FreemiumProvider>(context, listen: false);
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
            builder: (context, card, child) {
              var CC =
                  Provider.of<AddCardsProvider>(context, listen: true).card;
              fProv.cardID = card.selectedCard?.id.toString();

              card.card!.forEach((element) {
                if (element.isdefault.toString() == '1') {
                  cardNo = element.endNumber!
                      .replaceRange(0, 5, '')
                      .replaceAll(' ', ' - ')
                      .toUpperCase();
                  cardImage = element.cardImage;
                  cardName = element.hashedName;
                  cardId = fProv.cardID != null && fProv.cardID!.isNotEmpty
                      ? fProv.cardID
                      : element.id;
                }
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
                    child: CC!.isEmpty
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
                        : Consumer<FreemiumProvider>(
                            builder: (context, fprov, _) {
                            return PayCustomButton(
                              onSubmit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SaveCardFreemium()),
                                );
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                              prefixImage1: cardImage,
                              imageSize1: 14,
                              text1: 'Pay using'.toUpperCase(),
                              textSize1: 16,
                              textColor1: Colors.white,
                              backgroundColor: AppTheme.electricBlue,
                              text2:
                                  '${fprov.cardNumber != null ? fprov.cardNumber : cardNo.toString()}',
                              textSize2: 16,
                              textColor2: Colors.white,
                              suffixImage1: "assets/icons/UP_Arrow-01.png",
                              imageSize2: 8,
                            );
                          }),
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
                        /*: NewCustomButton(
                            onSubmit: () async {
                              if (fProv.cardID != null) {
                                cardId = fProv.cardID.toString();
                                debugPrint('Plan ID:' +
                                    fProv.planID.toString() +
                                    ' ' +
                                    'Card id : ' +
                                    fProv.cardID.toString());
                                CustomLoadingDialog.showLoadingDialog(
                                    context, key);
                                Map payDetails = {
                                  "card_id": cardId,
                                  "amount": amount,
                                  "currency": "AED",
                                  "send_to": "60eda791f9f00d49bbe2eacb"
                                };
                                debugPrint(payDetails.toString());
                                Provider.of<AddCardsProvider>(context,
                                        listen: false)
                                    .paymentThroughCard(payDetails)
                                    .timeout(Duration(seconds: 30),
                                        onTimeout: () async {
                                  Navigator.of(context).pop();
                                  return Future.value(null);
                                }).then((value) async {
                                  debugPrint('Checks' + value.toString());

                                  if (value['status'] == true) {
                                    Map<String, dynamic> data = {
                                      "planId": fProv.planID.toString(),
                                      "cardId": fProv.cardID.toString(),
                                      "order_id": "6177ae12129c070c307aa038"
                                    };
                                    // cc.selectedCard = null;
                                    debugPrint(data.toString());
                                    bool subscriptionResponse = await repository
                                        .freemiumApi
                                        .purchaseSubscriptionPlan(data);
                                    if (subscriptionResponse == true) {
                                      fProv.cardNumber = null;
                                      await KycAPI.kycApiProvider
                                          .kycCheker()
                                          .then((value) {
                                        bool? isPremium =
                                            value['premium'] ?? false;
                                        setState(() {
                                          Repository()
                                              .hiveQueries
                                              .insertUserData(
                                                Repository()
                                                    .hiveQueries
                                                    .userData
                                                    .copyWith(
                                                        premiumStatus: isPremium ==
                                                                true
                                                            ? int.parse(value[
                                                                'planDuration'])
                                                            : 0,
                                                        premiumExpDate: DateTime
                                                            .parse(value[
                                                                    'expDate']
                                                                .toString())),
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
                                      debugPrint('subscription failed');
                                    }
                                  } else {
                                    Navigator.of(context).pop(true);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TransactionFailedScreen(
                                            model: value,
                                            // customermodel: widget.model,
                                          ),
                                        ));
                                  }
                                });
                              } else {
                                // cardId = cardId;
                                debugPrint(
                                    'Plan ID:' + fProv.planID.toString());
                                CustomLoadingDialog.showLoadingDialog(
                                    context, key);
                                Map payDetails = {
                                  "card_id": cardId,
                                  "amount": amount,
                                  "currency": "AED",
                                  "send_to": "60eda791f9f00d49bbe2eacb"
                                };
                                debugPrint(payDetails.toString());
                                Provider.of<AddCardsProvider>(context,
                                        listen: false)
                                    .paymentThroughCard(payDetails)
                                    .timeout(Duration(seconds: 30),
                                        onTimeout: () async {
                                  Navigator.of(context).pop();
                                  return Future.value(null);
                                }).then((value) async {
                                  debugPrint('Checks' + value.toString());

                                  if (value['status'] == true) {
                                    Map<String, dynamic> data = {
                                      "planId": fProv.planID.toString(),
                                      "cardId": cardId
                                    };
                                    // cc.selectedCard = null;
                                    debugPrint(data.toString());
                                    bool subscriptionResponse = await repository
                                        .freemiumApi
                                        .purchaseSubscriptionPlan(data);
                                    if (subscriptionResponse) {
                                      Navigator.of(context).pop(true);
                                      fProv.cardID = null;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UrbanLedgerPremiumWelcome()),
                                      );
                                    } else {
                                      debugPrint('subscription failed');
                                    }
                                  } else {
                                    Navigator.of(context).pop(true);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TransactionFailedScreen(
                                            model: value,
                                            // customermodel: widget.model,
                                          ),
                                        ));
                                  }
                                });
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
                            },
                            text: 'pay $currencyAED $amount'.toUpperCase(),
                            textColor: Colors.white,
                            backgroundColor: AppTheme.electricBlue,
                            textSize: 18.0,
                            fontWeight: FontWeight.bold,
                            // width: 185,
                          ),*/
                    :NewCustomButton(
                    onSubmit: OSession!=null?() async {
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

                         print(OSession);

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
                         else{
                           Navigator.of(context).pop();
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
                             //await getKyc();

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
                    }:(){},
                    text: 'pay $currencyAED $amount'.toUpperCase(),
                    textColor: Colors.white,
                    backgroundColor: AppTheme.electricBlue,
                    textSize: 18.0,
                    fontWeight: FontWeight.bold,
                    // width: 185,
                  )
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
          title: Text('Upgrade Subscription'),
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

                            fProv.planID = planId;
                            fProv.amountID = amount;
                            debugPrint('Checking from provider' +
                                fProv.planID.toString());
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
                                          color: AppTheme.electricBlue,
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
