import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:urbanledger/Card_module/components/CRoundButton.dart';
import 'package:urbanledger/Card_module/components/back_card_view.dart';
import 'package:urbanledger/Card_module/components/front_card_view.dart';
import 'package:urbanledger/Card_module/components/input_view_pager.dart';
import 'package:urbanledger/Card_module/components/reset_button.dart';
import 'package:urbanledger/Card_module/constants/constanst.dart';
import 'package:urbanledger/Card_module/model/card_info.dart';
import 'package:urbanledger/Card_module/provider/card_cvv_provider.dart';
import 'package:urbanledger/Card_module/provider/card_name_provider.dart';
import 'package:urbanledger/Card_module/provider/card_number_provider.dart';
import 'package:urbanledger/Card_module/provider/card_valid_provider.dart';
import 'package:urbanledger/Card_module/provider/state_provider.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/screens/TransactionScreens/add_cards_provider.dart';
import 'constants/captions.dart';
import 'constants/constanst.dart';

import 'package:urbanledger/screens/Components/custom_widgets.dart';

typedef CardInfoCallback = Function(InputState currentState, CardInfo cardInfo);

class CreditCardInputForm extends StatelessWidget {
  CreditCardInputForm(
      {this.onStateChange,
      this.cardHeight,
      this.frontCardDecoration,
      this.backCardDecoration,
      this.showResetButton = true,
      this.customCaptions,
      this.cardNumber = '',
      this.cardName = '',
      this.cardCVV = '',
      this.cardValid = '',
      this.initialAutoFocus = true,
      this.intialCardState = InputState.NUMBER,
      this.nextButtonTextStyle = kDefaultButtonTextStyle,
      this.prevButtonTextStyle = kDefaultButtonTextStyle,
      this.resetButtonTextStyle = kDefaultButtonTextStyle,
      this.nextButtonDecoration = defaultNextPrevButtonDecoration,
      this.prevButtonDecoration = defaultNextPrevButtonDecoration,
      this.resetButtonDecoration = defaultResetButtonDecoration,
      this.onDoneNavigation});

  final Function? onStateChange;
  final double? cardHeight;
  final BoxDecoration? frontCardDecoration;
  final BoxDecoration? backCardDecoration;
  final bool showResetButton;
  final Map<String, String>? customCaptions;
  final BoxDecoration nextButtonDecoration;
  final BoxDecoration prevButtonDecoration;
  final BoxDecoration resetButtonDecoration;
  final TextStyle nextButtonTextStyle;
  final TextStyle prevButtonTextStyle;
  final TextStyle resetButtonTextStyle;
  final String cardNumber;
  final String cardName;
  final String cardCVV;
  final String cardValid;
  final initialAutoFocus;
  final InputState intialCardState;
  final Function? onDoneNavigation;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StateProvider(intialCardState),
        ),
        ChangeNotifierProvider(
          create: (context) => CardNumberProvider(cardNumber),
        ),
        ChangeNotifierProvider(
          create: (context) => CardNameProvider(cardName),
        ),
        ChangeNotifierProvider(
          create: (context) => CardValidProvider(cardValid),
        ),
        ChangeNotifierProvider(
          create: (context) => CardCVVProvider(cardCVV),
        ),
        Provider(
          create: (_) => Captions(customCaptions: customCaptions),
        ),
      ],
      child: CreditCardInputImpl(
        onCardModelChanged:
            onStateChange as void Function(InputState, CardInfo)?,
        backDecoration: backCardDecoration,
        frontDecoration: frontCardDecoration,
        cardHeight: cardHeight,
        initialAutoFocus: initialAutoFocus,
        showResetButton: showResetButton,
        prevButtonDecoration: prevButtonDecoration,
        nextButtonDecoration: nextButtonDecoration,
        resetButtonDecoration: resetButtonDecoration,
        prevButtonTextStyle: prevButtonTextStyle,
        nextButtonTextStyle: nextButtonTextStyle,
        resetButtonTextStyle: resetButtonTextStyle,
        initialCardState: intialCardState,
        onDoneNavigation: onDoneNavigation,
      ),
    );
  }
}

class CreditCardInputImpl extends StatefulWidget {
  final CardInfoCallback? onCardModelChanged;
  final double? cardHeight;
  final BoxDecoration? frontDecoration;
  final BoxDecoration? backDecoration;
  final bool? showResetButton;
  final BoxDecoration? nextButtonDecoration;
  final BoxDecoration? prevButtonDecoration;
  final BoxDecoration? resetButtonDecoration;
  final TextStyle? nextButtonTextStyle;
  final TextStyle? prevButtonTextStyle;
  final TextStyle? resetButtonTextStyle;
  final InputState? initialCardState;
  final initialAutoFocus;
  final Function? onDoneNavigation;

  CreditCardInputImpl({
    this.onCardModelChanged,
    this.cardHeight,
    this.showResetButton,
    this.frontDecoration,
    this.backDecoration,
    this.nextButtonTextStyle,
    this.prevButtonTextStyle,
    this.resetButtonTextStyle,
    this.nextButtonDecoration,
    this.prevButtonDecoration,
    this.initialCardState,
    this.initialAutoFocus,
    this.resetButtonDecoration,
    this.onDoneNavigation,
  });

  @override
  _CreditCardInputImplState createState() => _CreditCardInputImplState();
}

class _CreditCardInputImplState extends State<CreditCardInputImpl> {
  late PageController pageController;

  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  final GlobalKey<State> key = GlobalKey<State>();

  final cardHorizontalpadding = 12;
  final cardRatio = 16.0 / 9.0;

  var _currentState;

  @override
  void initState() {
    super.initState();

    _currentState = widget.initialCardState;

    pageController = PageController(
      viewportFraction: 0.92,
      initialPage: widget.initialCardState!.index,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newState = Provider.of<StateProvider>(context).getCurrentState();

    final name = Provider.of<CardNameProvider>(context).cardName;

    final cardNumber = Provider.of<CardNumberProvider>(context).cardNumber;

    final valid = Provider.of<CardValidProvider>(context).cardValid;

    final cvv = Provider.of<CardCVVProvider>(context).cardCVV;

    final captions = Provider.of<Captions>(context);

    if (newState != _currentState) {
      _currentState = newState;

      Future(() {
        widget.onCardModelChanged!(
            _currentState,
            CardInfo(
                name: name, cardNumber: cardNumber, validate: valid, cvv: cvv));
      });
    }

    double cardWidth =
        MediaQuery.of(context).size.width - (1.1 * cardHorizontalpadding);

    double? cardHeight;
    if (widget.cardHeight != null && widget.cardHeight! > 0) {
      cardHeight = widget.cardHeight;
    } else {
      cardHeight = cardWidth / cardRatio;
    }

    final frontDecoration = widget.frontDecoration != null
        ? widget.frontDecoration
        : defaultCardDecoration;
    final backDecoration = widget.backDecoration != null
        ? widget.backDecoration
        : defaultCardDecoration;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Consumer<StateProvider>(builder: (context, st, _) {
              _currentState = st.getCurrentState();
              // debugPrint('before Status ' +
              //     '${cardKey?.currentState?.controller?.status.toString()}');
              if (InputState.VALIDATE == _currentState) {
                if (validateDate(valid) == null &&
                    cardKey.currentState!.isFront == true) {
                  print('yes');
                  cardKey.currentState!.controller!.reverse();
                  // cardKey.currentState!.toggleCard();

                } else if (validateDate(valid) == null) {
                  debugPrint(
                      'IS FRONT' + cardKey.currentState!.isFront.toString());
                  debugPrint(
                      'IS FRONT' + cardKey.currentState!.isFront.toString());

                  if (cardKey.currentState!.isFront == true) {
                    cardKey.currentState!.toggleCard();
                  }

                  // debugPrint('After Status ' +
                  //     '${cardKey?.currentState?.controller?.status.toString()}');
                }
                //setState(() {});
              }
              if (_currentState == InputState.CVV) {
                // debugPrint('CVV Status ' +
                //     '${cardKey?.currentState?.controller?.status.toString()}');
                if (cardKey.currentState!.isFront == true) {
                  cardKey.currentState!.toggleCard();
                }
                if (validateCVV(cvv) == null) {
                  debugPrint(
                      'IS FRONT' + cardKey.currentState!.isFront.toString());
                  cardKey.currentState!.controller!.reverse();
                }
                //cardKey.currentState!.controller!.reverse();
                //setState(() {});
              }
              if (_currentState == InputState.DONE) {
                //setState(() {});

                // cardKey.currentState!.toggleCard();
                // cardKey.currentState!.toggleCard();
                // cardKey.currentState!.toggleCard();
                // cardKey.currentState!.toggleCard();

                //setState(() {});
              }
              return FlipCard(
                speed: 300,

                //flipOnTouch: true,
                // flipOnTouch: (_currentState == InputState.CVV) ||
                //     (_currentState == InputState.NAME) ||
                //     (_currentState == InputState.DONE),
                key: cardKey,
                front: FrontCardView(
                  height: cardHeight! + cardHeight * 0.12,
                  decoration: frontDecoration,
                ),
                back: BackCardView(
                    height: cardHeight + cardHeight * 0.12,
                    decoration: backDecoration),
              );
            }),
          ),
          SizedBox(
            height: 50,
          ),
          Stack(
            children: [
              AnimatedOpacity(
                opacity: _currentState == InputState.DONE ? 0 : 1,
                duration: Duration(milliseconds: 500),
                child: InputViewPager(
                  isAutoFoucus: widget.initialAutoFocus,
                  pageController: pageController,
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                      opacity: widget.showResetButton! &&
                              _currentState == InputState.DONE
                          ? 1
                          : 0,
                      duration: Duration(milliseconds: 500),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ResetButton(
                          decoration: widget.resetButtonDecoration,
                          textStyle: widget.resetButtonTextStyle,
                          onTap: () {
                            if (!widget.showResetButton!) {
                              return;
                            }

                            Provider.of<StateProvider>(context, listen: false)
                                .moveFirstState();
                            pageController.animateToPage(0,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn);

                            if (!cardKey.currentState!.isFront) {
                              cardKey.currentState!.toggleCard();
                            }
                          },
                        ),
                      ))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // AnimatedOpacity(
              //   opacity: _currentState == InputState.NUMBER ||
              //           _currentState == InputState.DONE
              //       ? 0
              //       : 1,
              //   duration: Duration(milliseconds: 500),
              //   child: RoundButton(
              //       decoration: widget.prevButtonDecoration,
              //       textStyle: widget.prevButtonTextStyle,
              //       buttonTitle: captions.getCaption('PREV'),
              //       onTap: () {
              //         if (InputState.DONE == _currentState) {
              //           return;
              //         }
              //
              //         if (InputState.NUMBER != _currentState) {
              //           pageController.previousPage(
              //               duration: Duration(milliseconds: 300),
              //               curve: Curves.easeIn);
              //         }
              //
              //         if (InputState.NAME == _currentState) {
              //           cardKey.currentState.toggleCard();
              //         }
              //         Provider.of<StateProvider>(context, listen: false)
              //             .movePrevState();
              //       }),
              // ),
              // SizedBox(
              //   width: 10,
              // ),

              SizedBox(
                width: 25,
              )
            ],
          ),
          Consumer<StateProvider>(
            builder: (BuildContext context, St, _) {
              _currentState = St.getCurrentState();
              print(_currentState.toString());
              return _currentState == InputState.DONE &&
                      (Provider.of<CardNameProvider>(context)
                              .cardName
                              .toString()
                              .isNotEmpty &&
                          validateCardNumWithLuhnAlgorithm(
                                Provider.of<CardNumberProvider>(context)
                                    .cardNumber
                                    .toString(),
                              ) ==
                              null &&
                          validateDate(
                                Provider.of<CardValidProvider>(context)
                                    .cardValid
                                    .toString(),
                              ) ==
                              null &&
                          validateCVV(
                                Provider.of<CardCVVProvider>(context)
                                    .cardCVV
                                    .toString(),
                              ) ==
                              null)
                  ? AnimatedOpacity(
                      opacity: 1,
                      duration: Duration(milliseconds: 500),
                      // child: CButton(
                      //     name: 'ADD CARD',
                      //     onPress: () {
                      //       // CustomLoadingDialog.showLoadingDialog(context, key);
                      //       widget.onDoneNavigation!();
                      //       // Navigator.pop(context, true);
                      //       debugPrint('here');
                      //       Provider.of<AddCardsProvider>(context,
                      //               listen: false)
                      //           .getCard();
                      //       Navigator.of(context)..pop();
                      //       // Fluttertoast.showToast(
                      //       //     msg: "Card added successfully");
                      //       'Card added successfully'.showSnackBar(context);
                      //       setState(() {});
                      //     }),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.027),
                        child: NewCustomButton(
                            onSubmit: () {
                              // CustomLoadingDialog.showLoadingDialog(context, key);
                              widget.onDoneNavigation!();
                              // Navigator.pop(context, true);
                              debugPrint('here');
                              Provider.of<AddCardsProvider>(context,
                                      listen: false)
                                  .getCard();
                              Navigator.of(context)..pop();
                              // Fluttertoast.showToast(
                              //     msg: "Card added successfully");
                              'Card added successfully'.showSnackBar(context);
                              setState(() {});
                            },
                            text: 'ADD CARD',
                            textSize: 20,
                            textColor: Colors.white),
                      ),
                    )
                  : AnimatedOpacity(
                      opacity: _currentState == InputState.DONE ? 0 : 1,
                      duration: Duration(milliseconds: 500),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Consumer<StateProvider>(
                            builder: (context, state, _) {
                          _currentState = state.getCurrentState();
                          return (Provider.of<CardNameProvider>(context)
                                      .cardName
                                      .toString()
                                      .isNotEmpty &&
                                  validateCardNumWithLuhnAlgorithm(
                                        Provider.of<CardNumberProvider>(context)
                                            .cardNumber
                                            .toString(),
                                      ) ==
                                      null &&
                                  validateDate(
                                        Provider.of<CardValidProvider>(context)
                                            .cardValid
                                            .toString(),
                                      ) ==
                                      null &&
                                  validateCVV(
                                        Provider.of<CardCVVProvider>(context)
                                            .cardCVV
                                            .toString(),
                                      ) ==
                                      null)
                              ? NewCustomButton(
                                  onSubmit: () {
                                    if (InputState.NAME != _currentState) {
                                      setState(() {
                                        pageController.nextPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeIn);
                                      });
                                    }
                                    if (InputState.VALIDATE == _currentState) {
                                      cardKey.currentState!.toggleCard();
                                      setState(() {});
                                    }
                                    if (_currentState == InputState.CVV) {
                                      cardKey.currentState!.controller!
                                          .reverse();
                                      setState(() {});
                                    }
                                    if (_currentState == InputState.DONE) {
                                      setState(() {});
                                      cardKey.currentState!.toggleCard();
                                      cardKey.currentState!.toggleCard();
                                      setState(() {});
                                    }

                                    Provider.of<StateProvider>(context,
                                            listen: false)
                                        .moveNextState();
                                    setState(() {});
                                  },
                                  text: (_currentState == InputState.NAME ||
                                          _currentState == InputState.DONE
                                      ? captions.getCaption('DONE')
                                      : captions.getCaption('NEXT'))!,
                                  textSize: 20,
                                  textColor: Colors.white)
                              : Container();
                        }),
                      ),
                      // child: CButton(
                      //   name: (_currentState == InputState.NAME ||
                      //           _currentState == InputState.DONE
                      //       ? captions.getCaption('DONE')
                      //       : captions.getCaption('NEXT'))!,
                      //   onPress: () {
                      //     print('rrc');
                      //     if (InputState.NAME != _currentState) {
                      //       pageController.nextPage(
                      //           duration: Duration(milliseconds: 300),
                      //           curve: Curves.easeIn);
                      //     }
                      //     if (InputState.VALIDATE == _currentState) {
                      //       cardKey.currentState!.toggleCard();
                      //     }
                      //     if (_currentState == InputState.CVV) {
                      //       cardKey.currentState!.controller!.reverse();
                      //     }
                      //
                      //     Provider.of<StateProvider>(context, listen: false)
                      //         .moveNextState();
                      //   },
                      // ),
                    );
            },
          ),
        ],
      ),
    );
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
