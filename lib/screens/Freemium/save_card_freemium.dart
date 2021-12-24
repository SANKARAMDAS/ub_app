import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Models/PremiumPurchaseTrackingModel.dart';
import 'package:urbanledger/Models/add_card_model.dart';
import 'package:urbanledger/Services/APIs/freemium_api.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/chat_module/screens/contact/payment_controller.dart';
import 'package:urbanledger/screens/Add%20Card/add_card_screen.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/screens/Freemium/urbanledger_premium_welcome.dart';
import 'package:urbanledger/screens/TransactionScreens/add_cards_provider.dart';
import 'package:urbanledger/screens/transaction_failed.dart';

import 'freemium_provider.dart';

class SaveCardFreemium extends StatefulWidget {
  @override
  _SaveCardFreemiumState createState() => _SaveCardFreemiumState();
}

class _SaveCardFreemiumState extends State<SaveCardFreemium> {
  final TextEditingController _enterDetailsController = TextEditingController();
  bool isTapandpay = false;
  bool isCard = true;
  bool isAmountFilled = false;
  String? _id;
  late PaymentController _paymentController;
  final GlobalKey<State> key = GlobalKey<State>();
  TextEditingController currController = new TextEditingController();
  bool status = false;
  final repository = Repository();
  PremiumStartOrderSession? OSession;

  @override
  void initState() {
    getCar();
    Osess();

    super.initState();
  }

  getCar() async {
    //Provider.of<AddCardsProvider>(context, listen: false).getCardForPremium();
    if (Provider.of<FreemiumProvider>(context, listen: false).cardNumber ==
            null &&
        Provider.of<FreemiumProvider>(context, listen: false)
            .cardNumber!
            .isEmpty) {
      Provider.of<AddCardsProvider>(context, listen: false).getDefault();
    }
  }

  @override
  void didChangeDependencies() {
    //_paymentController.initProvider();
    precacheImage(AssetImage("assets/icons/tapandpay.png"), context);
    precacheImage(AssetImage("assets/icons/Tap & Pay (White)-01.png"), context);
    precacheImage(AssetImage("assets/icons/cards.png"), context);
    precacheImage(
        AssetImage("assets/icons/Cards fill (white)-01.png"), context);
    super.didChangeDependencies();
  }

  final random = Random();
  late Color selectedColor;
  String? cardId;
  @override
  void dispose() {
    super.dispose();
    _enterDetailsController.dispose();
    currController.dispose();
    //_paymentController.dispose();
  }

  Osess() async {
    OSession = await FreemiumAPI.freemiumApi.startOrderSessionPremiumPLan();
  }

  cancelOsession({PremiumStartOrderSession? OSession}) async {
    await FreemiumAPI.freemiumApi
        .cancelOrderSessionPremiumPLan(orderID: OSession!.id);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        cancelOsession(OSession: OSession);
        Navigator.of(context).pop(true);
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF2F1F6),
        extendBodyBehindAppBar: true,
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Consumer<AddCardsProvider>(builder: (context, cc, _) {
            isAmountFilled = (currController.text.isEmpty ||
                        currController.text.length == 0) ||
                    (int.tryParse(currController.text) == 0)
                ? false
                : true;
            return Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/addYourCard.png'),
                  ),
                  // height: 100,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
                SizedBox(height: 5),
                InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddCardScreen(),
                              ));
                          await cc.getCard();
                          setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 25,
                              // height: 25,
                              child: Image.asset(
                                  'assets/icons/Add New Card-01.png'),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                'Add New Card',
                                style: TextStyle(
                                    fontFamily: 'SFProDisplay',
                                    color: AppTheme.electricBlue,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    height: 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(bottom: 20, left: 15, right: 15),
                  child: NewCustomButton(
                      onSubmit: () async {
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
                        } else {
                          cardId = Provider.of<FreemiumProvider>(context,
                                  listen: false)
                              .planID
                              .toString();
                          debugPrint('Plan ID:' +
                              Provider.of<FreemiumProvider>(context,
                                      listen: false)
                                  .planID
                                  .toString());
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
                        CustomLoadingDialog.showLoadingDialog(context, key);

                        // _id = '60e5c626771927cb954b8700';
                        // double amount = double.parse(amount);
                        // //widget.sendMessage!(amount, null, 1);
                        Map payDetails = {
                          "card_id": Provider.of<FreemiumProvider>(context,
                                  listen: false)
                              .cardID
                              .toString(),
                          "amount": Provider.of<FreemiumProvider>(context,
                                  listen: false)
                              .amountID
                              .toString(),
                          "currency": "AED",
                          "send_to": "60eda791f9f00d49bbe2eacb"
                        };
                        debugPrint(payDetails.toString());
                        // Provider.of<AddCardsProvider>(context, listen: false)
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
                        // // }

                        if (OSession != null && OSession!.id!.isNotEmpty) {
                          Map<String, dynamic> data = {
                            "planId": Provider.of<FreemiumProvider>(context,
                                    listen: false)
                                .planID
                                .toString(),
                            "cardId": Provider.of<FreemiumProvider>(context,
                                    listen: false)
                                .cardID
                                .toString(),
                            "order_id": "${OSession!.id.toString()}"
                          };
                          // cc.selectedCard = null;
                          debugPrint(data.toString());
                          var subscriptionResponse = await repository
                              .freemiumApi
                              .purchaseSubscriptionPlan(data);
                          if (subscriptionResponse['status']) {
                            Provider.of<FreemiumProvider>(context,
                                    listen: false)
                                .cardNumber = null;
                            await KycAPI.kycApiProvider
                                .kycCheker()
                                .then((value) {
                              debugPrint('Kyc Checker: ' + value.toString());
                              bool? isPremium = value['premium'] ?? false;
                              setState(() {
                                Repository().hiveQueries.insertUserData(
                                      Repository()
                                          .hiveQueries
                                          .userData
                                          .copyWith(
                                              premiumStatus: isPremium == true
                                                  ? int.parse(
                                                      value['planDuration'])
                                                  : 0,
                                              premiumExpDate: DateTime.parse(
                                                  value['expDate'].toString())),
                                    );
                              });
                              debugPrint('Check after purchase: ' +
                                  Repository()
                                      .hiveQueries
                                      .userData
                                      .premiumStatus
                                      .toString());
                            });
                            Navigator.of(context).pop(true);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UrbanLedgerPremiumWelcome()),
                            );
                          } else {
                            // await KycAPI.kycApiProvider.kycCheker().then((value) {
                            //   bool? isPremium = value['premium'] ?? false;
                            //   setState(() {
                            //     Repository().hiveQueries.insertUserData(
                            //         Repository().hiveQueries.userData.copyWith(
                            //             premiumStatus: isPremium == true
                            //                 ? value['planDuration']
                            //                 : 0));
                            //   });
                            // });
                            Navigator.of(context).pop(true);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionFailedScreen(
                                    model: subscriptionResponse,
                                    // customermodel: widget.model,
                                  ),
                                ));
                          }
                        } else {
                          Navigator.pop(context);
                          debugPrint('ELse');
                        }
                      },
                      text: 'PROCEED',
                      textSize: 22,
                      textColor: Colors.white),
                ),
              ],
            );
          }),

          /*
            Container(
              width: double.infinity,
              color: Color(0xFFF2F1F6),
              child: Consumer<AddCardsProvider>(builder: (context, cc, _) {
                isAmountFilled = (currController.text.isEmpty ||
                            currController.text.length == 0) ||
                        (int.tryParse(currController.text) == 0)
                    ? false
                    : true;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset('assets/images/yourCardAdded.png'),
                      ),
                      height: 120,
                      width: 90,
                    ),
                    InkWell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddCardScreen(),
                                  ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 25,
                                  height: 25,
                                  child: Image.asset(
                                      'assets/icons/Add New Card-01.png'),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    'Add New Card',
                                    style: TextStyle(
                                        fontFamily: 'SFProDisplay',
                                        color: AppTheme.electricBlue,
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        height: 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.only(bottom: 20, left: 15, right: 15),
                      child: NewCustomButton(
                          onSubmit: () async {
                            if (Provider.of<FreemiumProvider>(context,
                                        listen: false)
                                    .cardID !=
                                null) {
                              cardId = Provider.of<FreemiumProvider>(context,
                                      listen: false)
                                  .planID
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
                            } else {
                              cardId = Provider.of<FreemiumProvider>(context,
                                      listen: false)
                                  .planID
                                  .toString();
                              debugPrint('Plan ID:' +
                                  Provider.of<FreemiumProvider>(context,
                                          listen: false)
                                      .planID
                                      .toString());
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
                            CustomLoadingDialog.showLoadingDialog(context, key);

                            // _id = '60e5c626771927cb954b8700';
                            // double amount = double.parse(amount);
                            // //widget.sendMessage!(amount, null, 1);
                            Map payDetails = {
                              "card_id": Provider.of<FreemiumProvider>(context,
                                          listen: false)
                                      .cardID
                                      .toString() ??
                                  cardId,
                              "amount": Provider.of<FreemiumProvider>(context,
                                          listen: false)
                                      .amountID
                                      .toString() ??
                                  '480',
                              "currency": "AED",
                              "send_to": "60eda791f9f00d49bbe2eacb"
                            };
                            debugPrint(payDetails.toString());
                            Provider.of<AddCardsProvider>(context, listen: false)
                                .paymentThroughCard(payDetails)
                                .then((value) async {
                              debugPrint('Checks' + value.toString());

                              if (value['status'] == true) {
                                Map<String, dynamic> data = {
                                  "planId": Provider.of<FreemiumProvider>(context,
                                          listen: false)
                                      .planID
                                      .toString(),
                                  "cardId": Provider.of<FreemiumProvider>(context,
                                          listen: false)
                                      .cardID
                                      .toString()
                                };
                                // cc.selectedCard = null;
                                debugPrint(data.toString());
                                bool subscriptionResponse = await repository
                                    .freemiumApi
                                    .purchaseSubscriptionPlan(data);
                                if (subscriptionResponse) {
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
                                await KycAPI.kycApiProvider
                                    .kycCheker()
                                    .then((value) {
                                  bool? isPremium = value['premium'] ?? false;
                                  Repository()
            .hiveQueries
            .insertUserData(Repository().hiveQueries.userData.copyWith(
                                      premiumStatus: isPremium == true
                                          ? value['planDuration']
                                          : 0));
                                });
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
                            // }
                          },
                          text: 'PROCEED',
                          textSize: 22,
                          textColor: Colors.white),
                    ),
                  ],
                );
              }),
            ),
             */
        ),

        // bottomSheet: Container(
        //   width: double.infinity,
        //   color: Color(0xFFF2F1F6),
        //   child: Consumer<AddCardsProvider>(builder: (context, cc, _) {
        //     isAmountFilled = (currController.text.isEmpty ||
        //                 currController.text.length == 0) ||
        //             (int.tryParse(currController.text) == 0)
        //         ? false
        //         : true;
        //     return Column(
        //       mainAxisSize: MainAxisSize.min,
        //       crossAxisAlignment: CrossAxisAlignment.stretch,
        //       children: [
        //         Container(
        //           child: Align(
        //             alignment: Alignment.center,
        //             child: Image.asset('assets/images/yourCardAdded.png'),
        //           ),
        //           height: 120,
        //           width: 90,
        //         ),
        //         InkWell(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               InkWell(
        //                 onTap: () {
        //                   Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                         builder: (context) => AddCardScreen(),
        //                       ));
        //                 },
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                     Container(
        //                       width: 25,
        //                       height: 25,
        //                       child:
        //                           Image.asset('assets/icons/Add New Card-01.png'),
        //                     ),
        //                     SizedBox(
        //                       width: 5,
        //                     ),
        //                     Container(
        //                       margin: EdgeInsets.symmetric(vertical: 15),
        //                       child: Text(
        //                         'Add New Card',
        //                         style: TextStyle(
        //                             fontFamily: 'SFProDisplay',
        //                             color: AppTheme.electricBlue,
        //                             fontSize: 21,
        //                             fontWeight: FontWeight.bold,
        //                             letterSpacing:
        //                                 0 /*percentages not used in flutter. defaulting to zero*/,
        //                             height: 1),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //         SizedBox(height: 20),
        //         Container(
        //           margin: EdgeInsets.only(bottom: 20, left: 15, right: 15),
        //           child: NewCustomButton(
        //               onSubmit: () {
        //                     Navigator.of(context).pop(true);
        //               },
        //               text: 'PROCEED',
        //               textSize: 22,
        //               textColor: Colors.white),
        //         ),
        //       ],
        //     );
        //   }),
        // ),
        extendBody: true,
        appBar: AppBar(
          title: Text('Save Cards'),
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

        body: SafeArea(
          bottom: false,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: Text(
                            'CREDIT AND DEBIT CARDS',
                            style: TextStyle(
                                color: AppTheme.brownishGrey,
                                fontFamily: 'SFProDisplay',
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: Consumer<AddCardsProvider>(
                              builder: (context, cart, child) {
                            debugPrint('Card' + cart.card!.length.toString());

                            return (Provider.of<AddCardsProvider>(context,
                                        listen: true)
                                    .card!
                                    .isEmpty)
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/images/Add Card Illustration-01.png',
                                          height: deviceHeight * 0.28,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10),
                                        height: deviceHeight * 0.45,
                                        child: ListView.builder(
                                          itemCount:
                                              Provider.of<AddCardsProvider>(
                                                      context,
                                                      listen: true)
                                                  .card!
                                                  .length,
                                          itemBuilder: (context, int index) {
                                            CardDetailsModel cards =
                                                cart.card![index];
                                            // Provider.of<FreemiumProvider>(context,
                                            //             listen: false)
                                            //         .cardID =
                                            //     cart.selectedCard?.id.toString();

                                            return Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 3, horizontal: 5),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 5,
                                                ),
                                                // width: 335,
                                                // height: 55,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Color(0xffebebeb),
                                                    width: 1,
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      cart.selectedCard =
                                                          cart.card![index];

                                                      // print(cart.selectedCard?.id
                                                      //     .toString());
                                                    });

                                                    Provider.of<FreemiumProvider>(
                                                                context,
                                                                listen: false)
                                                            .cardID =
                                                        cart.selectedCard?.id
                                                            .toString();
                                                    Provider.of<FreemiumProvider>(
                                                            context,
                                                            listen: false)
                                                        .AddCardNumber(
                                                            CardNumber: cart
                                                                .selectedCard
                                                                ?.endNumber
                                                                .toString());

                                                    debugPrint(
                                                        'Checking from Card provider ' +
                                                            Provider.of<FreemiumProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .cardID
                                                                .toString());
                                                  },
                                                  child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 5),
                                                    title: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                        ),
                                                        cards.cardImage!
                                                                .isNotEmpty
                                                            ? Image.network(
                                                                cards.cardImage
                                                                    .toString(),
                                                                height: 30,
                                                              )
                                                            : Image.asset(
                                                                'assets/icons/Mastero-01.png',
                                                                height: 35,
                                                              ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                        ),
                                                        // Text(
                                                        //   // "${cards.endNumber.toString().replaceAll(' ', '')}".toUpperCase(),
                                                        //   "${cards.cardType}",
                                                        //   style: TextStyle(
                                                        //     color:
                                                        //         Color(0xff666666),
                                                        //     fontSize: 18,
                                                        //     fontFamily:
                                                        //         "SFProDisplay",
                                                        //     fontWeight:
                                                        //         FontWeight.w700,
                                                        //   ),
                                                        // ),
                                                        RichText(
                                                            text: TextSpan(
                                                                children: [
                                                              TextSpan(
                                                                text:
                                                                    "${cards.cardType}",
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xff666666),
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      "SFProDisplay",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: "\n${cards.endNumber.toString().replaceAll(' ', '')}"
                                                                    .toUpperCase(),
                                                                style:
                                                                    TextStyle(
                                                                  color: AppTheme
                                                                      .electricBlue,
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      "SFProDisplay",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ])),
                                                      ],
                                                    ),
                                                    trailing: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 20),
                                                      child: Container(
                                                        height: 22,
                                                        width: 22,
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: cart.selectedCard ==
                                                                        cart.card![
                                                                            index]
                                                                    ? AppTheme
                                                                        .electricBlue
                                                                    : Colors
                                                                        .white,
                                                                // color: Colors.white,
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: AppTheme
                                                                        .brownishGrey)),
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Icon(
                                                              Icons.check,
                                                              size: 13.0,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                ));
                                          },
                                          reverse: true,
                                        ),
                                      ),
                                    ],
                                  );
                          }),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  userNotRegisteredDialog({text, text2}) async => await showDialog(
      builder: (context) => Dialog(
            // backgroundColor: AppTheme.electricBlue,
            insetPadding:
                EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.70),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical:10, horizontal:10),
                //   child: Image.asset(AppAssets.notregistered,width: MediaQuery.of(context).size.width * 0.5,),
                // ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 5, left: 15, right: 15),
                  child: CustomText(
                    text,
                    centerAlign: true,
                    color: AppTheme.tomato,
                    bold: FontWeight.w500,
                    size: 18,
                  ),
                ),
                // CustomText(
                //   'Link your Bank Account?',
                //   color: AppTheme.brownishGrey,
                //   bold: FontWeight.w500,
                //   size: 18,
                // ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: RaisedButton(
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            // color: Color.fromRGBO(137, 172, 255, 1),
                            color: AppTheme.electricBlue,
                            child: CustomText(
                              'Got it'.toUpperCase(),
                              color: Colors.white,
                              size: (18),
                              bold: FontWeight.w500,
                            ),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: Container(
                      //     margin: EdgeInsets.symmetric(vertical: 10),
                      //     padding: const EdgeInsets.symmetric(horizontal: 15),
                      //     child: RaisedButton(
                      //       padding: EdgeInsets.all(15),
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(10)),
                      //       // color: Color.fromRGBO(137, 172, 255, 1),
                      //       color: AppTheme.electricBlue,
                      //       child: CustomText(
                      //         'invite'.toUpperCase(),
                      //         color: Colors.white,
                      //         size: (18),
                      //         bold: FontWeight.w500,
                      //       ),
                      //       onPressed: () async {
                      //         Navigator.of(context).pop(true);
                      //         final RenderBox box =
                      //             context.findRenderObject() as RenderBox;

                      //         await Share.share(
                      //             'Hey! I’m inviting you to use Urban Ledger (an amazing app to manage small businesses). It helps keep track of payables/receivables from our customers/suppliers. It also helps us collect payments digitally through unique payment links. https://bit.ly/app-store-link',
                      //             subject: 'https://bit.ly/app-store-link',
                      //             sharePositionOrigin:
                      //                 box.localToGlobal(Offset.zero) &
                      //                     box.size);
                      //       },
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                )
              ],
            ),
          ),
      barrierDismissible: false,
      context: context);

// final List<Color> _colors = [
//   Color.fromRGBO(137, 171, 249, 1),
//   AppTheme.brownishGrey,
//   AppTheme.greyish,
//   AppTheme.electricBlue,
// ];
// Random random = Random();
}
