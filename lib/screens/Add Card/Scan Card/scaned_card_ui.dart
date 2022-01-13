import 'package:connectivity/connectivity.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Card_module/components/card_logo.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Add%20Card/card_list.dart';
import 'package:urbanledger/screens/Add%20Card/card_ui.dart';
import 'package:urbanledger/screens/Components/curved_round_button.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/TransactionScreens/add_cards_provider.dart';
import 'package:urbanledger/screens/main_screen.dart';

class ScanedCard extends StatefulWidget {
  final String cardName;
  final String cardNumber;
  final String cardCVV;
  final String cardValid;

  const ScanedCard(
      {Key? key,
      required this.cardName,
      required this.cardNumber,
      required this.cardCVV,
      required this.cardValid})
      : super(key: key);

  @override
  _ScanedCardState createState() => _ScanedCardState();
}

class _ScanedCardState extends State<ScanedCard> {
  late final String cardNumber;
  late final String cardValid;
  final GlobalKey<State> key = GlobalKey<State>();

  @override
  void initState() {
    clearFormating();
    print('Card CVV number : ' + widget.cardCVV);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF2F1F6),
        extendBodyBehindAppBar: true,
        bottomSheet: Container(
          width: double.infinity,
          color: Color(0xFFF2F1F6),
          child: (widget.cardName.isNotEmpty &&
                  validateCardNumWithLuhnAlgorithm(widget.cardNumber) == null &&
                  validateDate(widget.cardValid) == null &&
                  validateCVV(widget.cardCVV) == null)
              ? CurvedRoundButton(
                  color: AppTheme.electricBlue,
                  name: 'SAVE',
                  onPress: () async {
                    if (await checkConnectivity) {
                      CustomLoadingDialog.showLoadingDialog(context, key);
                      Map card = {
                        // "title": "Test",
                        "number": "${widget.cardNumber.toString()}",
                        "cvv": "${widget.cardCVV.toString()}",
                        "name": "${widget.cardName}",
                        "expdate": "${widget.cardValid.toString()}",
                        "isdefault": "0"
                      };
                      debugPrint(card.toString());
                      await Provider.of<AddCardsProvider>(context,
                              listen: false)
                          .saveCard(card, context)
                          .then((value) async {
                        debugPrint('wwwwww: ' + value.toString());
                        await Provider.of<AddCardsProvider>(context,
                                listen: false)
                            .getCard();
                      }).catchError((onError) {
                        
                        Navigator.of(context).pop();
                        'Please check your internet connection or try again later.'
                            .showSnackBar(context);
                      });
                      /* Navigator.of(context)
                        .popAndPushNamed(AppRoutes.cardList);*/

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => CardList()),
                          ModalRoute.withName(AppRoutes.myProfileScreenRoute));
                      CustomLoadingDialog.showLoadingDialog(context);
                      // Navigator.of(context)
                      //     .popUntil((predicate) => predicate.isFirst);
                      // Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      //     builder: (context) => MainScreen()));
                      // Navigator.of(context).popUntil((route) => route.isFirst);
                      // Navigator.of(context)
                      //     .pushReplacementNamed(AppRoutes.mainRoute);
                    } else {
                      'Check your internet connectivity.'
                            .showSnackBar(context);
                    }
                  })
              : CurvedRoundButton(
                  color: AppTheme.greyish, name: 'SAVE', onPress: () async {}),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(alignment: Alignment.topCenter, children: [
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
                child: Column(children: [
              AppBar(
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 22,
                        ),
                        color: Colors.white,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      SizedBox(width: 0),
                      Text('Your Card')
                    ],
                  )),
              SizedBox(height: 70),
              FlipCard(
                back: BackCardViewStatic(
                  cardCVV: widget.cardCVV,
                  cardNumber: cardNumber,
                  cardName: '',
                  backgroundColor: Colors.purple,
                ),
                front: CardUi(
                    cardNumber: cardNumber,
                    bankName: 'Bank Name',
                    cardHolderName: widget.cardName,
                    validCard: cardValid,
                    backgroundColor: Colors.purple),
              ),
              SizedBox(height: 70),
              Image.asset('assets/images/yourCardAdded.png',
                  width: screenWidth(context) / 2.5, fit: BoxFit.cover),
              SizedBox(height: 35),
              Text(
                'Successfully Done!',
                style: TextStyle(
                    color: Color.fromRGBO(46, 208, 109, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: 22),
              )
            ]))
          ]),
        ));
  }

  clearFormating() {
    cardNumber = widget.cardNumber.replaceAll(' - ', ' ');
    cardValid = widget.cardValid.replaceAll('/', '/');
  }

  String? validateCardNumWithLuhnAlgorithm(String input) {
    if (input.isEmpty) {
      return 'This field is required';
    }

    input = getCleanedNumber(input);

    if (input.length < 8) {
      // No need to even proceed with the validation if it's less than 8 characters
      return 'Oops! It seems that you have entered an incorrect card number.';
    }

    int sum = 0;
    int length = input.length;
    for (var i = 0; i < length; i++) {
      // get digits in reverse order
      int digit = int.parse(input[length - i - 1]);

      // every 2nd number multiply with 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 == 0) {
      return null;
    }

    return 'Oops! It seems that you have entered an incorrect card number.';
  }

  static String? validateDate(String value) {
    if (value.isEmpty) {
      return 'This field is required';
    }

    int year;
    int month;
    // The value contains a forward slash if the month and year has been
    // entered.
    if (value.contains(new RegExp(r'(\/)'))) {
      var split = value.split(new RegExp(r'(\/)'));
      // The value before the slash is the month while the value to right of
      // it is the year.
      month = int.parse(split[0]);
      year = int.parse(split[1]);
    } else {
      // Only the month was entered
      month = int.parse(value.substring(0, (value.length)));
      year = -1; // Lets use an invalid year intentionally
    }

    if ((month < 1) || (month > 12)) {
      // A valid month is between 1 (January) and 12 (December)
      return 'Declined! Wrong expiry date.';
    }

    var fourDigitsYear = convertYearTo4Digits(year);
    if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
      // We are assuming a valid year should be between 1 and 2099.
      // Note that, it's valid doesn't mean that it has not expired.
      return 'Declined! Wrong expiry date.';
    }

    if (!hasDateExpired(month, year)) {
      return "Declined! Wrong expiry date.";
    }
    return null;
  }

  /// Convert the two-digit year to four-digit year if necessary
  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static bool hasDateExpired(int month, int year) {
    return !(month == null || year == null) && isNotExpired(year, month);
  }

  static bool isNotExpired(int year, int month) {
    // It has not expired if both the year and date has not passed
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is less than current month.
    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static bool hasYearPassed(int year) {
    int fourDigitsYear = convertYearTo4Digits(year);
    var now = DateTime.now();
    // The year has passed if the year we are currently, is greater than card's
    // year
    return fourDigitsYear < now.year;
  }

  static String? validateCVV(String value) {
    if (value.isEmpty) {
      return 'This field is required';
    }

    if (value.length < 3 || value.length > 4) {
      return "CVV is invalid";
    }
    return null;
  }

  static String getCleanedNumber(String text) {
    RegExp regExp = new RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }
}
