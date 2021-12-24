import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Models/add_card_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/chat_module/screens/contact/payment_controller.dart';
import 'package:urbanledger/screens/Add%20Card/add_card_screen.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Freemium/urbanledger_premium_welcome.dart';
import 'package:urbanledger/screens/TransactionScreens/add_cards_provider.dart';

class ConfirmationScreen2 extends StatefulWidget {
  // final CustomerModel? model;

  final String? amount;
  final String? planId;

// I/flutter ( 5184): 917738242013
// I/flutter ( 5184): Hemant
// I/flutter ( 5184): cc90ea33136dfad070a9ccb5b1806b3db100cb92
// I/flutter ( 5184): 609d012faef47b34fa8005c5

  ConfirmationScreen2({this.amount, this.planId});

  @override
  _ConfirmationScreen2State createState() => _ConfirmationScreen2State();
}

class _ConfirmationScreen2State extends State<ConfirmationScreen2> {
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

  @override
  void initState() {
    getCar();
    super.initState();
  }

  getCar() async {
    Provider.of<AddCardsProvider>(context, listen: false).getCard().catchError((e) {
                                          
                                          Navigator.of(context).pop();
                                          'Something went wrong. Please try again later.'
                                              .showSnackBar(context);
                                        });
  }

  @override
  void didChangeDependencies() {
    // _paymentController.initProvider();
    precacheImage(AssetImage("assets/icons/tapandpay.png"), context);
    precacheImage(AssetImage("assets/icons/Tap & Pay (White)-01.png"), context);
    precacheImage(AssetImage("assets/icons/cards.png"), context);
    precacheImage(
        AssetImage("assets/icons/Cards fill (white)-01.png"), context);
    super.didChangeDependencies();
  }

  final random = Random();
  late Color selectedColor;

  @override
  void dispose() {
    super.dispose();
    _enterDetailsController.dispose();
    currController.dispose();
    _paymentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.amount != null)
      currController.text = widget.amount!.replaceAll('-', '');

    return Scaffold(
      backgroundColor: Color(0xFFF2F1F6),
      extendBodyBehindAppBar: true,
      bottomSheet: Container(
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
                            width: 19,
                            height: 19,
                            child:
                                Image.asset('assets/icons/Add New Card-01.png'),
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
                                  fontSize: 16,
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
              isCard == true
                  ? SizedBox(
                      height: 20,
                    )
                  : Container(),
              isAmountFilled == true &&
                      ((isCard == true &&
                          (cc.selectedCard?.id != null &&
                              cc.selectedCard!.id!.isNotEmpty))) &&
                      cc.card!.isNotEmpty
                  ? CurvedRoundButton(
                      color: AppTheme.electricBlue,
                      name: isCard ? 'Pay' : 'Continue',
                      onPress: isCard == true
                          ? () {
                              CustomLoadingDialog.showLoadingDialog(
                                  context, key);

                              _id = '60e5c626771927cb954b8700';
                              double amount = double.parse(currController.text);
                              // //widget.sendMessage!(amount, null, 1);
                              Map payDetails = {
                                "card_id": "${cc.selectedCard?.id}",
                                "amount": amount.toInt().toString(),
                                "currency": "AED",
                                "send_to": "60e58ebe771927cb954b86d5"
                              };
                              debugPrint(payDetails.toString());
                              Provider.of<AddCardsProvider>(context,
                                      listen: false)
                                  .paymentThroughCard(payDetails)
                                  .catchError((e) {
                                Navigator.of(context).pop();
                                'Something went wrong. Please try again later.'
                                    .showSnackBar(context);
                              }).then((value) async {
                                debugPrint('Checks' + value.toString());

                                if (value['status'] == true) {
                                  Map<String, dynamic> data = {
                                    "planId": "${widget.planId}",
                                    "cardId": "${cc.selectedCard?.id}"
                                  };
                                  cc.selectedCard = null;
                                  debugPrint(data.toString());
                                  if (await checkConnectivity) {
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
                                    Navigator.of(context).pop();
                                    'Please check your internet connection or try again later.'
                                        .showSnackBar(context);
                                  }
                                } else {
                                  Navigator.of(context).pop(true);
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           TransactionFailedScreen(
                                  //         model: value,
                                  //         customermodel: widget.model,
                                  //       ),
                                  //     ));
                                }
                              });
                            }
                          : () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             BankAddedSuccessfully()));
                            },
                    )
                  : CurvedRoundButton(
                      name: isCard ? 'Pay' : 'Continue',
                      color: AppTheme.greyish,
                      onPress: () {},
                    ),
            ],
          );
        }),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: deviceHeight * 0.31,
                width: double.maxFinite,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: Color(0xfff2f1f6),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/back2.png'),
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              SafeArea(
                child: AppBar(
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 22,
                        ),
                        color: Colors.white,
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                      // SizedBox(
                      //   width: 15,
                      // ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.037,
                  ),
                  Image.asset(
                    'assets/images/UL logo BOX-01.png',
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Text(
                      'UrbanLedger ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 34,
                        fontFamily: 'SFProDisplay',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      'Premium Subscription ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        fontFamily: 'SFProDisplay',
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth(context),
                    alignment: Alignment.center,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              // width:
                              //     screenWidth(context) *
                              //         0.475,
                              alignment: Alignment.centerRight,
                              child: Text(
                                '$currencyAED  ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                  // alignment: Alignment
                                  //     .centerLeft,
                                  // height: height * 0.12,
                                  // width:
                                  //     screenWidth(context) *
                                  //         0.480,
                                  // color: Colors.black,
                                  child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: CustomText(
                                  widget.amount.toString(),
                                  bold: FontWeight.w700,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              )),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  // SizedBox(
                  //   height: MediaQuery.of(context).padding.top + appBarHeight,
                  // ),
                  (deviceHeight * 0.38).heightBox,
                  //Enter Details -Widget
                  // Flexible(
                  //   child: ListView(
                  //     padding: EdgeInsets.zero,
                  //     children: [
                  //       Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  //           child: Theme(
                  //             data: ThemeData(primaryColor: Colors.white),
                  //             child: ClipRRect(
                  //               borderRadius: BorderRadius.circular(4),
                  //               child: TextField(
                  //                 controller: _enterDetailsController,
                  //                 maxLines: 4,
                  //                 minLines: 4,
                  //                 style: TextStyle(color: AppTheme.brownishGrey),
                  //                 textCapitalization: TextCapitalization.sentences,
                  //                 decoration: InputDecoration(
                  //                     hintText: 'Enter Details',
                  //                     hintStyle:
                  //                         TextStyle(color: Color(0xff666666)),
                  //                     enabledBorder: InputBorder.none,
                  //                     focusedBorder: InputBorder.none,
                  //                     filled: true,
                  //                     fillColor: Colors.white),
                  //               ),
                  //             ),
                  //           )),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: IntrinsicWidth(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // InkWell(
                          //   onTap: () {
                          //     setState(() {
                          //       isTapandpay = !isTapandpay;
                          //       isCard = false;
                          //       FocusScope.of(context).unfocus();
                          //     });
                          //   },
                          //   child: Column(
                          //     children: [
                          //       Container(
                          //         padding: EdgeInsets.all(15),
                          //         color: isTapandpay
                          //             ? AppTheme.electricBlue
                          //             : Colors.white,
                          //         height: 62,
                          //         width: 62,
                          //         child: isTapandpay
                          //             ? Image.asset(
                          //                 AppAssets.tapPayIcon,
                          //                 fit: BoxFit.contain,
                          //                 height: 14,
                          //                 color: Colors.white,
                          //               )
                          //             : Image.asset(
                          //                 AppAssets.tapPayIcon,
                          //                 height: 14,
                          //                 fit: BoxFit.contain,
                          //               ),
                          //       ),
                          //       SizedBox(
                          //         height: 5,
                          //       ),
                          //       CustomText(
                          //         'Tap & Pay',
                          //         color: Color(0xFF666666),
                          //         centerAlign: true,
                          //         size: 14,
                          //         fontFamily: 'SFProDisplay',
                          //         bold: FontWeight.normal,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.15,
                          // ),
                          // InkWell(
                          //   onTap: () {
                          //     setState(() {
                          //       if (isAmountFilled) {
                          //         setState(() {
                          //           isCard = !isCard;
                          //           isTapandpay = false;
                          //           FocusScope.of(context).unfocus();
                          //         });
                          //       } else {
                          //         ScaffoldMessenger.of(context)
                          //             .showSnackBar(SnackBar(
                          //           content: Text('Please enter amount.'),
                          //           behavior: SnackBarBehavior.floating,
                          //           margin: EdgeInsets.only(
                          //               bottom: 50, left: 15, right: 15, top: 15),
                          //         ));
                          //       }
                          //       FocusScope.of(context).unfocus();
                          //     });
                          //   },
                          //   child: Column(
                          //     children: [
                          //       Container(
                          //           decoration: BoxDecoration(
                          //               color: isCard
                          //                   ? AppTheme.electricBlue
                          //                   : AppTheme.electricBlue,
                          //               borderRadius:
                          //                   BorderRadius.all(Radius.circular(5))),
                          //           padding: EdgeInsets.all(15),
                          //           // color: isCard
                          //           //     ? AppTheme.electricBlue
                          //           //     : Colors.white,
                          //           height: 62,
                          //           width: 62,
                          //           child: isCard
                          //               ? Image.asset(
                          //                   AppAssets.cardsIcon,
                          //                   color: Colors.white,
                          //                   width: 14,
                          //                   fit: BoxFit.contain,
                          //                   height: 14,
                          //                 )
                          //               : Image.asset(
                          //                   AppAssets.cardsIcon,
                          //                   color: Colors.white,
                          //                   width: 14,
                          //                   fit: BoxFit.contain,
                          //                   height: 14,
                          //                 )),
                          //       SizedBox(
                          //         height: 5,
                          //       ),
                          //       CustomText(
                          //         'Cards',
                          //         color: Color(0xFF666666),
                          //         centerAlign: true,
                          //         size: 14,
                          //         fontFamily: 'SFProDisplay',
                          //         bold: FontWeight.normal,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    (deviceHeight * 0.5).heightBox,
                    // isCard == true && isAmountFilled == true

                    Container(
                      child: Consumer<AddCardsProvider>(
                          builder: (context, cart, child) {
                        debugPrint('Card' + cart.card!.length.toString());

                        return (cart.card!.isEmpty)
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
                                  // // InkWell(
                                  // //   onTap: () {
                                  // //     Navigator.push(
                                  // //         context,
                                  // //         MaterialPageRoute(
                                  // //           builder: (context) =>
                                  // //               AddCardScreen(),
                                  // //         ));
                                  // //     setState(() {});
                                  // //   },
                                  // //   child: Row(
                                  // //     mainAxisAlignment:
                                  // //         MainAxisAlignment.center,
                                  // //     children: [
                                  // //       Container(
                                  // //         width: 19,
                                  // //         height: 19,
                                  // //         child: Image.asset(
                                  // //             'assets/icons/Add New Card-01.png'),
                                  // //       ),
                                  // //       SizedBox(
                                  // //         width: 5,
                                  // //       ),
                                  // //       Text(
                                  // //         'Add New Card',
                                  // //         style: TextStyle(
                                  // //             fontFamily: 'SFProDisplay',
                                  // //             color: AppTheme.electricBlue,
                                  // //             fontSize: 16,
                                  // //             fontWeight: FontWeight.w600,
                                  // //             letterSpacing:
                                  // //                 0 /*percentages not used in flutter. defaulting to zero*/,
                                  // //             height: 1),
                                  // //       ),
                                  // //     ],
                                  // //   ),
                                  // // ),
                                  // // SizedBox(
                                  // //   height: 20,
                                  // // ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    height: deviceHeight * 0.37,
                                    child: ListView.builder(
                                      itemCount: cart.card!.length,
                                      itemBuilder: (context, int index) {
                                        CardDetailsModel cards =
                                            cart.card![index];

                                        return Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 3),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 0,
                                          ),
                                          width: 335,
                                          height: 55,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Color(0xffebebeb),
                                              width: 1,
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: RadioListTile(
                                              contentPadding:
                                                  EdgeInsets.only(left: 5),
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .trailing,
                                              value: cart.card![index],
                                              groupValue: cart.selectedCard,
                                              onChanged: (CardDetailsModel?
                                                  currentUser) {
                                                setState(() {
                                                  cart.selectedCard =
                                                      currentUser;
                                                  print(cart.selectedCard?.id
                                                      .toString());
                                                });
                                              },
                                              title: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  cards.cardImage!.isNotEmpty
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
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "${cards.endNumber.toString().replaceAll('x', '*').replaceAll(' ', ' - ')}",
                                                    style: TextStyle(
                                                      color: Color(0xff666666),
                                                      fontSize: 18,
                                                      fontFamily:
                                                          "SFProDisplay",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    height: 22,
                                                    width: 28,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () =>
                                                              showDialog(
                                                                  builder:
                                                                      (context) =>
                                                                          Dialog(
                                                                            insetPadding: EdgeInsets.only(
                                                                                left: 20,
                                                                                right: 20,
                                                                                top: deviceHeight * 0.77), // already
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                                                                                  child: CustomText(
                                                                                    'Are you sure you want to delete this card?',
                                                                                    color: AppTheme.tomato,
                                                                                    bold: FontWeight.w500,
                                                                                    size: 18,
                                                                                  ),
                                                                                ),
                                                                                // CustomText(
                                                                                //   'Delete entry will change your balance ',
                                                                                //   size: 16,
                                                                                // ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: Container(
                                                                                          margin: EdgeInsets.symmetric(vertical: 10),
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                                          child: RaisedButton(
                                                                                            padding: EdgeInsets.all(15),
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            color: AppTheme.electricBlue,
                                                                                            child: CustomText(
                                                                                              'CANCEL',
                                                                                              color: Colors.white,
                                                                                              size: (18),
                                                                                              bold: FontWeight.w500,
                                                                                            ),
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop(false);
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: Container(
                                                                                          margin: EdgeInsets.symmetric(vertical: 10),
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                          child: RaisedButton(
                                                                                            padding: EdgeInsets.all(15),
                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                            color: AppTheme.electricBlue,
                                                                                            child: CustomText(
                                                                                              'CONFIRM',
                                                                                              color: Colors.white,
                                                                                              size: (18),
                                                                                              bold: FontWeight.w500,
                                                                                            ),
                                                                                            onPressed: () async {
                                                                                              Navigator.of(context).pop(true);
                                                                                              await cart.deleleCard(cards.id);
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                  barrierDismissible:
                                                                      false,
                                                                  context:
                                                                      context),

                                                          // onTap: () async {
                                                          //   await cart
                                                          //       .deleleCard(
                                                          //           cards.id);
                                                          // },
                                                          child: Container(
                                                            child: Image.asset(
                                                              'assets/images/Delete-01.png',
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Map card = {
                                                        "isdefault":
                                                            "${cards.isdefault == 0 ? 1 : 0}",
                                                        "id":
                                                            "${cards.id.toString()}",
                                                      };
                                                      cart.editCard(
                                                        id: cards.id.toString(),
                                                        value:
                                                            cards.isdefault == 0
                                                                ? 1
                                                                : 0,
                                                      );
                                                      cart.getCard();
                                                    },
                                                    child: Container(
                                                      height: 20,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          cards.isdefault
                                                                      .toString() ==
                                                                  '1'
                                                              ? Container(
                                                                  // height: 15,
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/on.png',
                                                                  ),
                                                                )
                                                              : Container(
                                                                  // height: 15,
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/WO_Default-01.png',
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  // Container(
                                                  //   width: 14,
                                                  //   child: Radio(
                                                  //     value: cart.card![index]
                                                  //                 .isdefault ==
                                                  //             1
                                                  //         ? cart.card![index]
                                                  //         : cart.card![index],

                                                  //     groupValue:
                                                  //         cart.selectedCard,

                                                  //     onChanged:
                                                  //         (Cards? currentUser) {
                                                  //       setState(() {
                                                  //         cart.selectedCard =
                                                  //             currentUser;
                                                  //         print(cart
                                                  //             .selectedCard?.id
                                                  //             .toString());
                                                  //       });
                                                  //     },
                                                  //     // selected:
                                                  //     //     cart.selectedCard ==
                                                  //     //         cart.card![index],
                                                  //     activeColor:
                                                  //         AppTheme.electricBlue,
                                                  //   ),
                                                  // ),
                                                ],
                                              )),
                                        );

                                        //
                                        // Container(
                                        //   margin: EdgeInsets.symmetric(
                                        //       vertical: 5),
                                        //   padding: EdgeInsets.symmetric(
                                        //       horizontal: 5, vertical: 5),
                                        //   width: 335,
                                        //   height: 55,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius:
                                        //         BorderRadius.circular(12),
                                        //     border: Border.all(
                                        //       color: Color(0xffebebeb),
                                        //       width: 1,
                                        //     ),
                                        //     color: Colors.white,
                                        //   ),
                                        //   child: Row(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment
                                        //             .spaceAround,
                                        //     children: [
                                        //       Image.asset(
                                        //         'assets/icons/Mastero-01.png',
                                        //         height: 35,
                                        //       ),
                                        //       Text(
                                        //         "${cards.endNumber.toString().replaceAll('x', '*').replaceAll(' ', '-')}",
                                        //         style: TextStyle(
                                        //           color: Color(0xff666666),
                                        //           fontSize: 18,
                                        //           fontFamily:
                                        //               "SFProDisplay",
                                        //           fontWeight:
                                        //               FontWeight.w700,
                                        //         ),
                                        //       ),
                                        //       Container(
                                        //         height: 22,
                                        //         width: 28,
                                        //         child: Row(
                                        //           mainAxisSize:
                                        //               MainAxisSize.min,
                                        //           mainAxisAlignment:
                                        //               MainAxisAlignment
                                        //                   .center,
                                        //           crossAxisAlignment:
                                        //               CrossAxisAlignment
                                        //                   .center,
                                        //           children: [
                                        //             InkWell(
                                        //               onTap: () =>
                                        //                   showDialog(
                                        //                       builder:
                                        //                           (context) =>
                                        //                               Dialog(
                                        //                                 insetPadding: EdgeInsets.only(
                                        //                                     left: 20,
                                        //                                     right: 20,
                                        //                                     top: deviceHeight * 0.77),
                                        //                                 shape:
                                        //                                     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        //                                 child:
                                        //                                     Column(
                                        //                                   mainAxisSize: MainAxisSize.min,
                                        //                                   children: [
                                        //                                     Padding(
                                        //                                       padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                                        //                                       child: CustomText(
                                        //                                         'Are you sure you want to delete this card?',
                                        //                                         color: AppTheme.tomato,
                                        //                                         bold: FontWeight.w500,
                                        //                                         size: 18,
                                        //                                       ),
                                        //                                     ),
                                        //                                     // CustomText(
                                        //                                     //   'Delete entry will change your balance ',
                                        //                                     //   size: 16,
                                        //                                     // ),
                                        //                                     Padding(
                                        //                                       padding: const EdgeInsets.all(8.0),
                                        //                                       child: Row(
                                        //                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        //                                         children: [
                                        //                                           Expanded(
                                        //                                             child: Container(
                                        //                                               margin: EdgeInsets.symmetric(vertical: 10),
                                        //                                               padding: const EdgeInsets.symmetric(horizontal: 10),
                                        //                                               child: RaisedButton(
                                        //                                                 padding: EdgeInsets.all(15),
                                        //                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        //                                                 color: AppTheme.electricBlue,
                                        //                                                 child: CustomText(
                                        //                                                   'CANCEL',
                                        //                                                   color: Colors.white,
                                        //                                                   size: (18),
                                        //                                                   bold: FontWeight.w500,
                                        //                                                 ),
                                        //                                                 onPressed: () {
                                        //                                                   Navigator.of(context).pop(false);
                                        //                                                 },
                                        //                                               ),
                                        //                                             ),
                                        //                                           ),
                                        //                                           Expanded(
                                        //                                             child: Container(
                                        //                                               margin: EdgeInsets.symmetric(vertical: 10),
                                        //                                               padding: const EdgeInsets.symmetric(horizontal: 15),
                                        //                                               child: RaisedButton(
                                        //                                                 padding: EdgeInsets.all(15),
                                        //                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        //                                                 color: AppTheme.electricBlue,
                                        //                                                 child: CustomText(
                                        //                                                   'CONFIRM',
                                        //                                                   color: Colors.white,
                                        //                                                   size: (18),
                                        //                                                   bold: FontWeight.w500,
                                        //                                                 ),
                                        //                                                 onPressed: () async {
                                        //                                                   Navigator.of(context).pop(true);
                                        //                                                   await cart.deleleCard(cards.id);
                                        //                                                 },
                                        //                                               ),
                                        //                                             ),
                                        //                                           )
                                        //                                         ],
                                        //                                       ),
                                        //                                     )
                                        //                                   ],
                                        //                                 ),
                                        //                               ),
                                        //                       barrierDismissible:
                                        //                           false,
                                        //                       context:
                                        //                           context),

                                        //               // onTap: () async {
                                        //               //   await cart
                                        //               //       .deleleCard(
                                        //               //           cards.id);
                                        //               // },
                                        //               child: Container(
                                        //                 child: Image.asset(
                                        //                   'assets/images/Delete-01.png',
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //       InkWell(
                                        //         onTap: () {
                                        //           Map card = {
                                        //             "isdefault":
                                        //                 "${cards.isdefault == 0 ? 1 : 0}",
                                        //             "id":
                                        //                 "${cards.id.toString()}",
                                        //           };
                                        //           cart.editCard(
                                        //             id: cards.id.toString(),
                                        //             value:
                                        //                 cards.isdefault == 0
                                        //                     ? 1
                                        //                     : 0,
                                        //           );
                                        //           cart.getCard();
                                        //         },
                                        //         child: Container(
                                        //           height: 20,
                                        //           child: Row(
                                        //             mainAxisSize:
                                        //                 MainAxisSize.min,
                                        //             mainAxisAlignment:
                                        //                 MainAxisAlignment
                                        //                     .center,
                                        //             crossAxisAlignment:
                                        //                 CrossAxisAlignment
                                        //                     .center,
                                        //             children: [
                                        //               cards.isdefault == 1
                                        //                   ? Container(
                                        //                       // height: 15,
                                        //                       child: Image
                                        //                           .asset(
                                        //                         'assets/images/on.png',
                                        //                       ),
                                        //                     )
                                        //                   : Container(
                                        //                       // height: 15,
                                        //                       child: Image
                                        //                           .asset(
                                        //                         'assets/images/WO_Default-01.png',
                                        //                       ),
                                        //                     ),
                                        //             ],
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       Container(
                                        //         width: 14,
                                        //         child: Radio(
                                        //           value: cart.card![index]
                                        //                       .isdefault ==
                                        //                   1
                                        //               ? cart.card![index]
                                        //               : cart.card![index],

                                        //           groupValue:
                                        //               cart.selectedCard,

                                        //           onChanged:
                                        //               (Cards? currentUser) {
                                        //             setState(() {
                                        //               cart.selectedCard =
                                        //                   currentUser;
                                        //               print(cart
                                        //                   .selectedCard?.id
                                        //                   .toString());
                                        //             });
                                        //           },
                                        //           // selected:
                                        //           //     cart.selectedCard ==
                                        //           //         cart.card![index],
                                        //           activeColor:
                                        //               AppTheme.electricBlue,
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // );

                                        //
                                      },
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
