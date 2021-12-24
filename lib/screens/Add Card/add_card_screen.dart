//import 'package:card_scanner/card_scanner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Card_module/credit_card_input_form.dart';
import 'package:urbanledger/Card_module/model/card_info.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/screens/TransactionScreens/add_cards_provider.dart';
import 'package:card_scanner/card_scanner.dart';
import './Scan Card/scan_details.dart';

class AddCardScreen extends StatefulWidget {
  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final GlobalKey<State> key = GlobalKey<State>();
  late double deviceHeight;
  double? deviceWidth;
  late CardDetails _cardDetails;
  String? number, cvv, name, validate, cardBrand;
  CardScanOptions scanOptions = CardScanOptions(
    scanCardHolderName: true,
    // enableDebugLogs: true,
    validCardsToScanBeforeFinishingScan: 5,
    possibleCardHolderNamePositions: [
      CardHolderNameScanPosition.aboveCardNumber,
    ],
  );

  Future<void> scanCard() async {
    var cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);
    if (!mounted) return;
     print('rrt : '+cardDetails.toString());
     print('rrt : '+cardDetails!.cardHolderName);
    setState(() {
      _cardDetails = cardDetails;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScanCardDetails(
                    cardNumber: _cardDetails.cardNumber,
                    cardName: _cardDetails.cardHolderName,
                    cardValid: _cardDetails.expiryDate,
                  )));
       print(cardDetails);
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFF2F1F6),
      extendBodyBehindAppBar: true,
      // bottomSheet: Container(
      //   color: Color(0xfff2f1f6),
      //   child: Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
      //     child: NewCustomButton(
      //       text: 'Scan Card Details'.toUpperCase(),
      //       textColor: Colors.white,
      //       textSize: 18.0,
      //       onSubmit: () async {
      //        await scanCard();
      //         // print("abc");
      //         // Navigator.of(context)
      //         //     .push(MaterialPageRoute(builder: (_) => CardList()));
      //         // CustomLoadingDialog.showLoadingDialog(context, key);
      //       },
      //     ),
      //   ),
      // ),
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: deviceHeight * 0.35,
                  width: double.maxFinite,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: Color(0xfff2f1f6),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/back2.png'),
                          alignment: Alignment.topCenter)),
                ),
                SafeArea(
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 22,
                          ),
                          color: Colors.white,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        // SizedBox(
                        //   width: 15,
                        // ),
                        Text(
                          'Add Card Details',
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),

                        Spacer(),
                        InkWell(
                          onTap: () {
                            scanCard();
                          },
                          child: Row(
                            children: [
                              Text(
                                'Scan your card',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Image.asset(
                                'assets/icons/cam.png',
                                height: 20,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(20))),
                //   child: Column(
                //     children: <Widget>[
                //       Container(
                //         margin:
                //             EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Row(
                //               children: [
                //                 IconButton(
                //                   icon: Icon(
                //                     Icons.chevron_left,
                //                     size: 30,
                //                     color: Colors.white,
                //                   ),
                //                   onPressed: () => Navigator.pop(context),
                //                 ),
                //                 SizedBox(
                //                   width: 8,
                //                 ),
                //                 Text(
                //                   'Add Card Details',
                //                   style: TextStyle(
                //                       color: Colors.white, fontSize: 21),
                //                 )
                //               ],
                //             ),
                //             Row(
                //               children: [
                //                 Text(
                //                   'Scan your card',
                //                   style: TextStyle(
                //                       color: Colors.white, fontSize: 18),
                //                 ),
                //                 SizedBox(
                //                   width: 8,
                //                 ),
                //                 Image.asset(
                //                   'assets/icons/cam.png',
                //                   height: 20,
                //                 )
                //               ],
                //             )
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top + appBarHeight,
                    ),
                    (deviceHeight * 0.03).heightBox,
                    Consumer<AddCardsProvider>(
                        builder: (context, addnewCards, _) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: CreditCardInputForm(
                          customCaptions:
                              addnewCards.model?.issuer.toString() != null
                                  ? {'BANKNAME': '${addnewCards.model!.issuer}'}
                                  : {},
                          cardHeight: 220,
                          onDoneNavigation: () async {
                            Map card = {
                              "title": "Test",
                              "number": "${number.toString()}",
                              "cvv": "${cvv.toString()}",
                              "name": "$name",
                              "expdate": "${validate.toString()}",
                              "isdefault": "0"
                            };
                            debugPrint(card.toString());
                            print(
                                'height :' + (deviceHeight * 0.28).toString());

                            await Provider.of<AddCardsProvider>(context,
                                    listen: false)
                                .saveCard(card, context);
                            await Provider.of<AddCardsProvider>(context,
                                    listen: false)
                                .getCard();
                            // Navigator.pop(context);
                          },
                          onStateChange: (currentState, CardInfo cardInfo) {
                            name = cardInfo.name.toString().toUpperCase();
                            validate = cardInfo.validate;
                            cvv = cardInfo.cvv;
                            number = cardInfo.cardNumber;
                          },
                          nextButtonDecoration: buttonDecoration,
                          showResetButton: false,
                          initialAutoFocus: false,
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final cardDecoration = BoxDecoration(
      // boxShadow: <BoxShadow>[
      //   BoxShadow(color: Colors.black54, blurRadius: 15.0, offset: Offset(0, 8))
      // ],
      gradient: LinearGradient(
          colors: [
            Color(0xFF5335D6),
            Color(0xFFBE54FF),
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp),
      borderRadius: BorderRadius.all(Radius.circular(15)));
  final buttonDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(30.0),
    gradient: LinearGradient(
        colors: [
          const Color(0xFF0000),
          const Color(0xFF1058FF),
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp),
  );

  final buttonTextStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18);
}
