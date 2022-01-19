import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Card_module/constants/captions.dart';
import 'package:urbanledger/Card_module/constants/constanst.dart';
import 'package:urbanledger/Card_module/provider/card_cvv_provider.dart';
import 'package:urbanledger/Card_module/provider/card_name_provider.dart';
import 'package:urbanledger/Card_module/provider/card_number_provider.dart';
import 'package:urbanledger/Card_module/provider/card_valid_provider.dart';
import 'package:urbanledger/Card_module/provider/state_provider.dart';
import 'package:urbanledger/Card_module/util/util.dart';
import 'package:urbanledger/Utility/app_services.dart';

class InputViewPager extends StatefulWidget {
  final PageController pageController;
  final isAutoFoucus;

  InputViewPager({required this.pageController, this.isAutoFoucus});

  @override
  _InputViewPagerState createState() => _InputViewPagerState();
}

class _InputViewPagerState extends State<InputViewPager> {
  final List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  final cardHorizontalpadding = 12;
  var _autoValidateMode = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();

  void _validateInputs() {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      setState(() {
        _autoValidateMode =
            AutovalidateMode.always; // Start validating on every change.
      });
      //_showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      // Encrypt and send send payment details to payment gateway
      // _showInSnackBar('Payment card is valid');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final captions = Provider.of<Captions>(context);

    final titleMap = {
      0: captions.getCaption('CARD_NUMBER'),
      1: captions.getCaption('VALID_THRU'),
      2: captions.getCaption('SECURITY_CODE_CVC'),
      3: captions.getCaption('CARDHOLDER_NAME'),
    };

    Provider.of<StateProvider>(context).addListener(() {
      int index = Provider.of<StateProvider>(context, listen: false)
          .getCurrentState()!
          .index;
      widget.pageController.jumpToPage(index);
      if (index < focusNodes.length) {
        FocusScope.of(context).requestFocus(focusNodes[index]);
      } else {
        FocusScope.of(context).unfocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      }
    });

    return Container(
        height: 100,
        width: MediaQuery.of(context).size.width - (4 * cardHorizontalpadding),
        child: PageView.builder(
            // physics: ScrollPhysics(),
            controller: widget.pageController,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: InputForm(
                    isAutoFocus: widget.isAutoFoucus,
                    focusNode: focusNodes[index],
                    title: titleMap[index],
                    index: index,
                    pageController: widget.pageController),
              );
            },
            itemCount: titleMap.length));
  }
}

class InputForm extends StatefulWidget {
  final String? title;
  final int? index;
  final PageController? pageController;
  final FocusNode? focusNode;
  final isAutoFocus;

  InputForm(
      {required this.title,
      this.index,
      this.pageController,
      this.focusNode,
      this.isAutoFocus});

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  var opacicy = 0.3;

  int? maxLength;
  TextInputType? textInputType;
  TextEditingController textController = TextEditingController();

  void onChange() {
    setState(() {
      if (widget.index == widget.pageController!.page!.round()) {
        opacicy = 1;
      } else {
        opacicy = 0.3;
      }
    });
  }

  String? value;

  @override
  void initState() {
    super.initState();

    int index = Provider.of<StateProvider>(context, listen: false)
        .getCurrentState()!
        .index;

    if (widget.index == index) {
      opacicy = 1;
    }

    widget.pageController!.addListener(onChange);

    if (widget.index == InputState.NUMBER.index) {
      String cardNumber =
          Provider.of<CardNumberProvider>(context, listen: false).cardNumber;

      if (CardCompany.AMERICAN_EXPRESS == detectCardCompany(cardNumber)) {
        setState(() {
          print('ktrue');

          maxLength = 18;
        });
      } else {
        setState(() {
          print('kfalse');

          maxLength = 19;
        });
      }
      // maxLength = 20;
      textInputType = TextInputType.number;
    } else if (widget.index == InputState.NAME.index) {
      maxLength = 20;
      textInputType = TextInputType.text;
    } else if (widget.index == InputState.VALIDATE.index) {
      maxLength = 5;
      textInputType = TextInputType.number;
    } else if (widget.index == InputState.CVV.index) {
      String cardNumber =
          Provider.of<CardNumberProvider>(context, listen: false).cardNumber;

      if (CardCompany.AMERICAN_EXPRESS == detectCardCompany(cardNumber)) {
        maxLength = 4;
      } else {
        maxLength = 3;
      }
      textInputType = TextInputType.number;
    }
  }

  @override
  void dispose() {
    widget.pageController!.removeListener(onChange);

    super.dispose();
  }

  var isInit = false;
  CreditCardValidator _ccValidator = CreditCardValidator();

  @override
  Widget build(BuildContext context) {
    String? textValue = "";

    if (widget.index == InputState.NUMBER.index) {
      textValue =
          Provider.of<CardNumberProvider>(context, listen: false).cardNumber;
    } else if (widget.index == InputState.NAME.index) {
      textValue =
          Provider.of<CardNameProvider>(context, listen: false).cardName;
    } else if (widget.index == InputState.VALIDATE.index) {
      textValue =
          Provider.of<CardValidProvider>(context, listen: false).cardValid;
    } else if (widget.index == InputState.CVV.index) {
      textValue = Provider.of<CardCVVProvider>(context).cardCVV;
    }

    int index = Provider.of<StateProvider>(context, listen: false)
        .getCurrentState()!
        .index;

    return Opacity(
      opacity: opacicy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   widget.title,
          //   style: TextStyle(fontSize: 12, color: Colors.black38),
          // ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  width: ((widget.index == InputState.CVV.index) ||
                          (widget.index == InputState.VALIDATE.index))
                      ? MediaQuery.of(context).size.width * 0.27
                      : MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    obscuringCharacter: String.fromCharCode(0xFF0A),
                    textAlign: (widget.index == InputState.CVV.index)?TextAlign.center:TextAlign.start,
                    style: (widget.index == InputState.CVV.index)
                        ? TextStyle(fontSize: 18)
                        : TextStyle(
                            fontSize: 22,
                            fontFamily: 'Iceberg',
                          ),
                    // textInputAction: (widget.index == InputState.NAME.index)
                    //     ? TextInputAction.done
                    //     : TextInputAction.next,
                    autocorrect: false,
                    obscureText:
                        (widget.index == InputState.CVV.index) ? true : false,
                    autofocus: widget.isAutoFocus && widget.index == index,
                    controller: textController
                      ..value = textController.value.copyWith(
                        text: textValue,
                        selection: TextSelection.fromPosition(
                          TextPosition(offset: textValue!.length),
                        ),
                      ),
                    focusNode: widget.focusNode,
                    keyboardType: textInputType,
                    maxLength: maxLength,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (String newValue) {
                      if (widget.index == InputState.NUMBER.index) {
                        Provider.of<StateProvider>(context, listen: false)
                            .gotoState(InputState.NUMBER);
                        Provider.of<CardNumberProvider>(context, listen: false)
                            .setNumber(newValue);
                        if (newValue.length == maxLength) {
                          debugPrint('max length' +
                              validateCardNumWithLuhnAlgorithm(newValue).toString());

                          if (validateCardNumWithLuhnAlgorithm(newValue) == null) {
                            FocusScope.of(context).nextFocus();

                            widget.pageController!.nextPage(
                                duration: Duration(seconds: 1),
                                curve: Curves.decelerate);
                          }
                        }
                      } else if (widget.index == InputState.VALIDATE.index) {
                        Provider.of<StateProvider>(context, listen: false)
                            .gotoState(InputState.VALIDATE);

                        Provider.of<CardValidProvider>(context, listen: false)
                            .setValid(newValue);
                        if (newValue.length == 2) {
                          if (newValue[0] == '0' || newValue[0] == '1') {

                            if (newValue[0] == '0'&&
                                int.tryParse(newValue[1])! >= 1 &&
                                int.tryParse(newValue[1])! <= 9) {
                                  print("true");
                              Provider.of<CardValidProvider>(context, listen: false)
                                  .setValid(newValue);
                            }
                             else if (newValue[0] == '1' &&
                                int.tryParse(newValue[1])! <= 2) {
                              Provider.of<CardValidProvider>(context, listen: false)
                                  .setValid(newValue);
                            }
                            else {
                            newValue='';
                            Provider.of<CardValidProvider>(context, listen: false)
                                .setValid('');
                          }
                          } else {
                            newValue='';
                            Provider.of<CardValidProvider>(context, listen: false)
                                .setValid('');
                          }
                        }

                        if (newValue.length == maxLength) {
                          debugPrint('max length' +
                              validateDate(newValue.toString()).toString());
                          if (validateDate(newValue) == null) {
                            FocusScope.of(context).nextFocus();
                            widget.pageController!.nextPage(
                                duration: Duration(seconds: 1),
                                curve: Curves.decelerate);
                          }
                        }
                      } else if (widget.index == InputState.CVV.index) {
                        Provider.of<StateProvider>(context, listen: false)
                            .gotoState(InputState.CVV);
                        Provider.of<CardCVVProvider>(context, listen: false)
                            .setCVV(newValue);
                        if (newValue.length == maxLength) {
                          debugPrint('max length' +
                              validateCVV(newValue.toString()).toString());
                          // FocusScope.of(context).unfocus();
                          if (validateCVV(newValue.toString()) == null) {
                            FocusScope.of(context).nextFocus();

                            widget.pageController!.nextPage(
                                duration: Duration(seconds: 1),
                                curve: Curves.decelerate);
                          }
                        }
                      } else if (widget.index == InputState.NAME.index) {
                        Provider.of<StateProvider>(context, listen: false)
                            .gotoState(InputState.NAME);
                        Provider.of<CardNameProvider>(context, listen: false)
                            .setName(newValue);
                        if (newValue.length == maxLength) {
                          widget.focusNode!.unfocus();
                          widget.pageController!.nextPage(
                              duration: Duration(seconds: 1),
                              curve: Curves.decelerate);
                        }
                      }
                    },
                    validator: (value) {
                      if (widget.index == InputState.NUMBER.index) {
                        return validateCardNumWithLuhnAlgorithm(
                            value!.trim().toString());
                      } else if (widget.index == InputState.VALIDATE.index) {
                        return validateDate(value!);
                      } else if (widget.index == InputState.CVV.index) {
                        return validateCVV(value!);
                      } else if (widget.index == InputState.NAME.index) {
                        value!.isEmpty;
                      }
                      return null;
                    },
                    inputFormatters: (widget.index == InputState.VALIDATE.index)
                        ? [
                            WhitelistingTextInputFormatter.digitsOnly,
                            new LengthLimitingTextInputFormatter(5),
                            CardMonthInputFormatter(),
                          ]
                        : (widget.index == InputState.CVV.index)
                            ? [WhitelistingTextInputFormatter(RegExp("[0-9]"))]
                            : [],

                    decoration: InputDecoration(
                      isDense: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      counter: SizedBox(
                        height: 0,
                      ),
                      errorStyle: TextStyle(
                          color: Color(0xFFE94235),
                          fontWeight: FontWeight.w600,
                          fontSize: 8),
                      labelText: widget.title,
                      labelStyle: TextStyle(
                          color: AppTheme.electricBlue,
                          fontSize: 14,
                          fontFamily: ''),
                      hintText: ((widget.index == InputState.NUMBER.index)
                          ? 'XXXX XXXX XXXX XXXX'
                          : (widget.index == InputState.VALIDATE.index)
                              ? 'MM/YY'
                              : (widget.index == InputState.CVV.index)
                                  ? 'CVV'
                                  : 'Cardholder Name'),
                      hintStyle: kHDefaultNameTextStyle.copyWith(
                          fontSize: 25, letterSpacing: 3.5),
                      suffixIcon: (widget.index == InputState.CVV.index)
                          ? Consumer<CardNumberProvider>(builder: (context, num, _) {
                              return Container(
                                  child: IconButton(
                                      icon: Image.asset(
                                        'assets/images/info.png',
                                        height: 15,
                                      ),
                                      onPressed: () {
                                        bool isShowBot =
                                            num.cardNumber.toString().isEmpty;
                                        bool check = (CardCompany.AMERICAN_EXPRESS ==
                                            detectCardCompany(num.cardNumber));
                                        showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(15),
                                                        topRight:
                                                            Radius.circular(15))),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 30, vertical: 15),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Container(
                                                      padding:
                                                          EdgeInsets.only(bottom: 35),
                                                      child: Image.asset(
                                                        'assets/images/rec.png',
                                                        height: 7,
                                                      ),
                                                    ),
                                                    isShowBot == true
                                                        ? Column(
                                                            mainAxisSize:
                                                                MainAxisSize.min,
                                                            children: <Widget>[
                                                              // Container(
                                                              //   padding:
                                                              //       EdgeInsets.only(
                                                              //           bottom: 35),
                                                              //   child: Image.asset(
                                                              //     'assets/images/rec.png',
                                                              //     height: 7,
                                                              //   ),
                                                              // ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  RichText(
                                                                    text:
                                                                        new TextSpan(
                                                                      // Note: Styles for TextSpans must be explicitly defined.
                                                                      // Child text spans will inherit styles from parent
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff666666),
                                                                          fontFamily:
                                                                              'SFProDisplay',
                                                                          fontSize:
                                                                              16),
                                                                      children: <
                                                                          TextSpan>[
                                                                        new TextSpan(
                                                                            text:
                                                                                'For Visa, MasterCard, JCB,\nDiscover the'),
                                                                        new TextSpan(
                                                                            text:
                                                                                ' 3 digits ',
                                                                            style: new TextStyle(
                                                                                fontWeight:
                                                                                    FontWeight.bold)),
                                                                        new TextSpan(
                                                                            text:
                                                                                'on\nthe back of your card.'),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Image.asset(
                                                                    'assets/images/debitback.png',
                                                                    height: 90,
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 30,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  RichText(
                                                                    text:
                                                                        new TextSpan(
                                                                      // Note: Styles for TextSpans must be explicitly defined.
                                                                      // Child text spans will inherit styles from parent
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff666666),
                                                                          fontFamily:
                                                                              'SFProDisplay',
                                                                          fontSize:
                                                                              16),
                                                                      children: <
                                                                          TextSpan>[
                                                                        new TextSpan(
                                                                            text:
                                                                                'For American Express the\n'),
                                                                        new TextSpan(
                                                                            text:
                                                                                '4 digits ',
                                                                            style: new TextStyle(
                                                                                fontWeight:
                                                                                    FontWeight.bold)),
                                                                        new TextSpan(
                                                                            text:
                                                                                'on the back of\nyour card.'),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Image.asset(
                                                                    'assets/images/debitfront.png',
                                                                    height: 90,
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        : !check
                                                            ? Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Text(
                                                                    'For Visa, MasterCard, JCB,\nDiscover the 3 digits on\nthe back of your card.',
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xff666666),
                                                                        fontFamily:
                                                                            'SFProDisplay',
                                                                        fontSize: 16),
                                                                  ),
                                                                  Image.asset(
                                                                    'assets/images/debitback.png',
                                                                    height: 90,
                                                                  )
                                                                ],
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'For American Express the\n4 digits on the back of\nyour card.',
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xff666666),
                                                                        fontFamily:
                                                                            'SFProDisplay',
                                                                        fontSize: 16),
                                                                  ),
                                                                  Image.asset(
                                                                    'assets/images/debitfront.png',
                                                                    height: 90,
                                                                  )
                                                                ],
                                                              ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      }));
                            })
                          : null,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.black38),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Color(0xff1058FF)),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ),
              ),
             /* if((widget.index == InputState.CVV.index))
                Consumer<CardNumberProvider>(builder: (context, num, _) {
                  return Container(
                      child: IconButton(
                          icon: Image.asset(
                            'assets/images/info.png',
                            height: 15,
                          ),
                          onPressed: () {
                            bool isShowBot =
                                num.cardNumber.toString().isEmpty;
                            bool check = (CardCompany.AMERICAN_EXPRESS ==
                                detectCardCompany(num.cardNumber));
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight:
                                            Radius.circular(15))),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 15),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                          EdgeInsets.only(bottom: 35),
                                          child: Image.asset(
                                            'assets/images/rec.png',
                                            height: 7,
                                          ),
                                        ),
                                        isShowBot == true
                                            ? Column(
                                          mainAxisSize:
                                          MainAxisSize.min,
                                          children: <Widget>[
                                            // Container(
                                            //   padding:
                                            //       EdgeInsets.only(
                                            //           bottom: 35),
                                            //   child: Image.asset(
                                            //     'assets/images/rec.png',
                                            //     height: 7,
                                            //   ),
                                            // ),
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceAround,
                                              children: [
                                                RichText(
                                                  text:
                                                  new TextSpan(
                                                    // Note: Styles for TextSpans must be explicitly defined.
                                                    // Child text spans will inherit styles from parent
                                                    style: TextStyle(
                                                        color: Color(
                                                            0xff666666),
                                                        fontFamily:
                                                        'SFProDisplay',
                                                        fontSize:
                                                        16),
                                                    children: <
                                                        TextSpan>[
                                                      new TextSpan(
                                                          text:
                                                          'For Visa, MasterCard, JCB,\nDiscover the'),
                                                      new TextSpan(
                                                          text:
                                                          ' 3 digits ',
                                                          style: new TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold)),
                                                      new TextSpan(
                                                          text:
                                                          'on\nthe back of your card.'),
                                                    ],
                                                  ),
                                                ),
                                                Image.asset(
                                                  'assets/images/debitback.png',
                                                  height: 90,
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceAround,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                RichText(
                                                  text:
                                                  new TextSpan(
                                                    // Note: Styles for TextSpans must be explicitly defined.
                                                    // Child text spans will inherit styles from parent
                                                    style: TextStyle(
                                                        color: Color(
                                                            0xff666666),
                                                        fontFamily:
                                                        'SFProDisplay',
                                                        fontSize:
                                                        16),
                                                    children: <
                                                        TextSpan>[
                                                      new TextSpan(
                                                          text:
                                                          'For American Express the\n'),
                                                      new TextSpan(
                                                          text:
                                                          '4 digits ',
                                                          style: new TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold)),
                                                      new TextSpan(
                                                          text:
                                                          'on the back of\nyour card.'),
                                                    ],
                                                  ),
                                                ),
                                                Image.asset(
                                                  'assets/images/debitfront.png',
                                                  height: 90,
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                            : !check
                                            ? Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceAround,
                                          children: [
                                            Text(
                                              'For Visa, MasterCard, JCB,\nDiscover the 3 digits on\nthe back of your card.',
                                              style: TextStyle(
                                                  color: Color(
                                                      0xff666666),
                                                  fontFamily:
                                                  'SFProDisplay',
                                                  fontSize: 16),
                                            ),
                                            Image.asset(
                                              'assets/images/debitback.png',
                                              height: 90,
                                            )
                                          ],
                                        )
                                            : Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceAround,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                              'For American Express the\n4 digits on the back of\nyour card.',
                                              style: TextStyle(
                                                  color: Color(
                                                      0xff666666),
                                                  fontFamily:
                                                  'SFProDisplay',
                                                  fontSize: 16),
                                            ),
                                            Image.asset(
                                              'assets/images/debitfront.png',
                                              height: 90,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }));
                })*/
            ],
          )
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

  String? validateCreditCardInfo({
    String? ccNum,
  }) {
    var ccNumResults = _ccValidator.validateCCNum(ccNum!);
    // var expDateResults = _ccValidator.validateExpDate(expDate);
    // var cvvResults = _ccValidator.validateCVV(cvv, ccNumResults.ccType);

    if (ccNumResults.isPotentiallyValid) {
      return null;
    } else {
      return 'Oops! It seems that you have entered an incorrect card number.';
    }
  }
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}
