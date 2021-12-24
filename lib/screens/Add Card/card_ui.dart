import 'package:flutter/material.dart';
import 'package:urbanledger/Card_module/constants/constanst.dart';
import 'package:urbanledger/Card_module/util/util.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class CardUi extends StatelessWidget {
  final String? title;
  final String cardNumber;
  final String bankName;
  final String cardHolderName;
  final String? cardImage;
  final dynamic? isDefualt;

  final dynamic? id;

  final String validCard;
  final double? cardHeight;
  final Color backgroundColor;

  const CardUi(
      {Key? key,
      this.title,
      required this.cardNumber,
      required this.bankName,
      required this.cardHolderName,
      required this.validCard,
      this.isDefualt,
      this.id,
      this.cardHeight,
      this.cardImage,
      required this.backgroundColor})
      : super(key: key);

  final cardHorizontalpadding = 20;
  final cardRatio = 16.0 / 9.0;
  @override
  Widget build(BuildContext context) {
    double cardWidth =
        MediaQuery.of(context).size.width - (1.1 * cardHorizontalpadding);
    double? _cardHeight;
    // _cardHeight = 220;
    if (cardHeight != null && cardHeight! > 0) {
      _cardHeight = cardHeight;
    } else {
      _cardHeight = cardWidth / cardRatio;
    }
    return Container(
      height: _cardHeight,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        child: Container(

          decoration: BoxDecoration(
              //  border: Border.all(),
              //  boxShadow: [

              // BoxShadow(
              //   color: Colors.black38,
              //   offset: const Offset(
              //     0.0,
              //     -0.5,
              //   ),
              //   blurRadius: 0.5,
              //   spreadRadius: 0.5,
              // ), ] ,

              borderRadius: BorderRadius.circular(15),
              // color: AppTheme.electricBlue,
              gradient: LinearGradient(colors: [
                backgroundColor,
                backgroundColor.withOpacity(0.8),
                backgroundColor.withOpacity(0.6)
              ])),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // height: MediaQuery.of(context).size.height / 3.3,
          width: cardWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  cardImage != null && cardImage!.isNotEmpty
                      ? Image.network(
                          cardImage.toString(),
                          width: 50,
                          height: 50,
                        )
                      : Container(),
                  // Text(title),
                  Container(
                    width: screenWidth(context) * 0.6,
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: BankNameStatic(bankName: bankName),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 4, left: 5, bottom: 10, right: 0),
                    child: sim,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: wifi,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              CardNumberStatic(cardNumber: cardNumber),
              SizedBox(
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Name on the Card',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(cardHolderName.toString().toUpperCase(),
                          style: kDefaultNameTextStyle.copyWith(fontSize: 16))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Expiry Date',
                        style: TextStyle(
                          fontFamily: 'SFProDisplay',
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // SizedBox(height: 4),
                      CardValidStatic(validCard: validCard),
                    ],
                  ),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class CardLogoStatic extends StatefulWidget {
  final String cardNumber;

  const CardLogoStatic({Key? key, required this.cardNumber}) : super(key: key);

  @override
  _CardLogoStaticState createState() => _CardLogoStaticState();
}

class _CardLogoStaticState extends State<CardLogoStatic> {
  late Widget card;
  @override
  Widget build(BuildContext context) {
    // String cardNumber = Provider.of<CardNumberProvider>(context).cardNumber;

    CardCompany cardCompany = detectCardCompany(widget.cardNumber);
    print('CardCompany:     ' + cardCompany.toString());
    switch (cardCompany) {
      case CardCompany.VISA:
        card = AnimatedOpacity(
          opacity: cardCompany == CardCompany.VISA ? 1 : 0,
          child: visa,
          duration: Duration(milliseconds: 200),
        );
        break;
      case CardCompany.AMERICAN_EXPRESS:
        card = AnimatedOpacity(
          opacity: cardCompany == CardCompany.AMERICAN_EXPRESS ? 1 : 0,
          child: amex,
          duration: Duration(milliseconds: 200),
        );
        break;
      case CardCompany.DISCOVER:
        card = AnimatedOpacity(
          opacity: cardCompany == CardCompany.DISCOVER ? 1 : 0,
          child: discover,
          duration: Duration(milliseconds: 200),
        );
        break;
      case CardCompany.MASTER:
        card = AnimatedOpacity(
          opacity: cardCompany == CardCompany.MASTER ? 1 : 0,
          child: master,
          duration: Duration(milliseconds: 200),
        );
        break;
      case CardCompany.OTHER:
        card = AnimatedOpacity(
          opacity: cardCompany == CardCompany.OTHER ? 1 : 0,
          child: others,
          duration: Duration(milliseconds: 200),
        );
        break;

      default:
    }
    return Container(
        // color: Colors.white,
        child: card
        // Stack(
        //   children: <Widget>[
        //     AnimatedOpacity(
        //       opacity: cardCompany == CardCompany.VISA ? 1 : 0,
        //       child: visa,
        //       duration: Duration(milliseconds: 200),
        //     ),
        //     AnimatedOpacity(
        //         opacity: cardCompany == CardCompany.MASTER ? 1 : 0,
        //         child: master,
        //         duration: Duration(milliseconds: 200)),
        //     AnimatedOpacity(
        //         opacity: cardCompany == CardCompany.DISCOVER ? 1 : 0,
        //         child: discover,
        //         duration: Duration(milliseconds: 200)),
        //     AnimatedOpacity(
        //         opacity: cardCompany == CardCompany.AMERICAN_EXPRESS ? 1 : 0,
        //         child: amex,
        //         duration: Duration(milliseconds: 200)),
        //   ],
        // ),
        );
  }
}

class BankNameStatic extends StatelessWidget {
  final String? bankName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedOpacity(
          opacity: 1,
          child: Text(
            bankName ?? 'BANK NAME',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: Duration(milliseconds: 200),
        ),
      ],
    );
  }

  BankNameStatic({this.bankName});
}

class CardValidStatic extends StatelessWidget {
  final String validCard;

  const CardValidStatic({Key? key, required this.validCard}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String inputCardValid = '';
    // = Provider.of<CardValidProvider>(context).cardValid;

    // var defaultCardValid = 'MM/YY';
    // Provider.of<Captions>(context)
    //     .getCaption('MM_YY')!
    //     .substring(inputCardValid.length);

    inputCardValid = validCard.replaceAll("/", "");

    switch (inputCardValid.length) {
      case 3:
        inputCardValid =
            inputCardValid[0] + inputCardValid[1] + '/' + inputCardValid[2];
        break;
      case 4:
        inputCardValid = inputCardValid[0] +
            inputCardValid[1] +
            '/' +
            inputCardValid[2] +
            inputCardValid[3];
        break;
    }

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              
              validCard.toString(),
              style: kValidtextStyle,
            ),
            // Text(
            //   defaultCardValid,
            //   style: kDefaultValidTextStyle,
            // )
          ],
        ));
  }
}

class CardNumberStatic extends StatefulWidget {
  final String cardNumber;

  CardNumberStatic({Key? key, required this.cardNumber}) : super(key: key);

  @override
  _CardNumberStaticState createState() => _CardNumberStaticState();
}

class _CardNumberStaticState extends State<CardNumberStatic> {
  String defaultNumber = '';
  String finaloutput = '';

  @override
  initState() {
    //getOutputNumebr();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Card Number',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontSize: 8,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    widget.cardNumber.toString().toUpperCase(),
                    style: kCardNumberTextStyle,
                  ),
                  // Text(
                  //  '',
                  //   style: kCardDefaultTextStyle,
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getOutputNumebr() {
    final numberLength = widget.cardNumber.replaceAll(" ", "").length;

    for (int i = 1; i <= 16 - numberLength; i++) {
      defaultNumber = 'X' + defaultNumber;
      if (i % 4 == 0 && i != 16) {
        defaultNumber = ' ' + defaultNumber;
      }
    }
    var numbers = [];
    for (var i = 0; i < numberLength; i += 4) {
      numbers.add(widget.cardNumber.substring(i, i + 4));
    }

    finaloutput = widget.cardNumber;
  }
}

class BackCardViewStatic extends StatelessWidget {
  final height;
  final Color backgroundColor;
  final String cardCVV;
  final String cardNumber;
  final String cardName;

  BackCardViewStatic(
      {this.height,
      required this.backgroundColor,
      required this.cardCVV,
      required this.cardName,
      required this.cardNumber});
  final cardRatio = 16.0 / 9.0;
  final cardHorizontalpadding = 20;

  @override
  Widget build(BuildContext context) {
    double cardWidth =
        MediaQuery.of(context).size.width - (1.1 * cardHorizontalpadding);
    double? _cardHeight;
    // _cardHeight = 220;
    if (height != null && height! > 0) {
      _cardHeight = height;
    } else {
      _cardHeight = cardWidth / cardRatio;
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: Container(
        margin: EdgeInsets.only(bottom: 5),
        height: _cardHeight,
        width: cardWidth,
        decoration: BoxDecoration(
            // border: Border.all(),
            borderRadius: BorderRadius.circular(15),
            // color: AppTheme.electricBlue,
            gradient: LinearGradient(colors: [
              backgroundColor,
              backgroundColor.withOpacity(0.9),
              backgroundColor.withOpacity(0.6)
            ])),
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25),
              height: 35,
              color: Colors.black,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: CardSignStatic(cardName: cardName)),
            AnimatedOpacity(
              opacity: 1,
              duration: Duration(milliseconds: 300),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5),
                      border: Border.all(
                        color: Colors
                            .yellow, //                   <--- border color
                        width: 1.0,
                      ),
                    ),
                    child: Container(
                      height: 45,
                      width: 75,
                    ),
                  )),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(right: 30),
                  child: GestureDetector(
                      onTap: () {},
                      child: CardCVVStatic(
                        cardCVV: cardCVV,
                      )),
                )),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 30),
                  child: wifi,
                )),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5, right: 30),
                  child: CardLogoStatic(cardNumber: cardNumber),
                )),
          ],
        ),
      ),
    );
  }
}

class CardCVVStatic extends StatelessWidget {
  final String cardCVV;

  const CardCVVStatic({Key? key, required this.cardCVV}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        height: 40,
        width: 70,
        color: Color(0xFFEBEBEB),
        child: Center(
          child: Text(
            cardCVV.toString().replaceAll(RegExp(r'[0-9]'), '*'),
            style: kCVCTextStyle,
          ),
        ),
      ),
    );
  }
}

class CardSignStatic extends StatelessWidget {
  final String cardName;
  const CardSignStatic({Key? key, required this.cardName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String cardNametemp = '';
    if (cardName.isNotEmpty) {
      cardNametemp = cardName
          .split(' ')
          .map((e) => e.isNotEmpty
              ? '${e[0].toUpperCase()}${e.substring(1).toLowerCase()}'
              : e)
          .join(' ');
    }

    return Container(
      margin: EdgeInsets.only(left: 15),
      height: 40,
      width: 240,
      color: Color(0xFFC4C4C4),
      child: Center(
        child: Text(
          cardNametemp,
          style: kSignTextStyle,
        ),
      ),
    );
  }
}
