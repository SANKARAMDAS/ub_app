import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urbanledger/Card_module/constants/constanst.dart';
import 'package:urbanledger/Card_module/util/util.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Add%20Card/Scan%20Card/scaned_card_ui.dart';
import 'package:urbanledger/screens/Add%20Card/card_ui.dart';
import 'package:urbanledger/screens/Components/curved_round_button.dart';

import 'package:flutter/cupertino.dart';
import 'package:urbanledger/screens/Components/extensions.dart';

class ScanCardDetails extends StatefulWidget {
  final String cardNumber;
  final String cardValid;
  final String cardName;

  const ScanCardDetails(
      {Key? key,
      required this.cardNumber,
      required this.cardValid,
      required this.cardName})
      : super(key: key);

  @override
  _ScanCardDetailsState createState() => _ScanCardDetailsState();
}

class _ScanCardDetailsState extends State<ScanCardDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String finaloutput = '';
  late TextEditingController _numberController = TextEditingController(
      // text: widget.cardNumber
      text: getOutputNumber(widget.cardNumber));
  late TextEditingController _dateController =
      TextEditingController(text: widget.cardValid

          // text: getValidDate(widget.cardValid)
          //
          );
  late TextEditingController _nameController =
      TextEditingController(text: widget.cardName
          // text: getValidDate(widget.cardValid)
          );
  late TextEditingController _cvvController = TextEditingController(
      // text: widget.cardValid
      // text: getValidDate(widget.cardValid)
      );
  CreditCardValidator _ccValidator = CreditCardValidator();

  @override
  void initState() {
    // getOutputNumber(widget.cardNumber);
    super.initState();
  }

  @override
  void dispose() {
    _numberController.dispose();
    _dateController.dispose();
    _nameController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  int maxLength = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF2F1F6),
        extendBodyBehindAppBar: true,
        bottomSheet: Container(
            width: double.infinity,
            color: Color(0xFFF2F1F6),
            child: CurvedRoundButton(
                color: AppTheme.electricBlue,
                name: 'SAVE',
                onPress: _numberController.text.isNotEmpty &&
                        _nameController.text.isNotEmpty &&
                        _cvvController.text.isNotEmpty && _cvvController.text.length > 2 &&
                        _dateController.text.isNotEmpty
                    ? () {
                        if (validate() == true) {
                          debugPrint('sssssssss'+"${_dateController.text}");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ScanedCard(
                                    cardCVV: "${_cvvController.text}",
                                    cardName: "${_nameController.text}",
                                    cardNumber: "${_numberController.text}",
                                    cardValid: "${_dateController.text}",
                                  )));
                        }
                      }
                    : null)),
        body: Stack(alignment: Alignment.topCenter, children: [
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
              child: Column(
            children: [
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
                      Text('Credit/Debit Card')
                    ],
                  )),
              SizedBox(height: 100),
              // Form(
              //   key: _formKey,
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   child:
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    // height: 250,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 0),
                            child: Container(
                              height: 60,
                              // color: Colors.amber,
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  new LengthLimitingTextInputFormatter(16),
                                  new CardNumberInputFormatter()
                                ],
                                // validator: FieldValidator.validateName(value),
                                controller: _numberController,
                                onChanged: (v) {
                                  clearFormating(_numberController.text);
                                  if (_numberController.text.isNotEmpty &&
                                      _nameController.text.isNotEmpty &&
                                      _cvvController.text.isNotEmpty &&
                                      _dateController.text.isNotEmpty)
                                    setState(() {});
                                },
                                validator: (value) {
                                  validateCardNumWithLuhnAlgorithm(
                                      value!.trim().toString());
                                  if (CardCompany.AMERICAN_EXPRESS ==
                                      detectCardCompany(
                                          _numberController.text)) {
                                    setState(() {
                                      print('ktrue');

                                      maxLength = 4;
                                    });
                                  } else {
                                    setState(() {
                                      print('kfalse');

                                      maxLength = 3;
                                    });
                                  }
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: finaloutput,
                                    hintStyle: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600),
                                    // alignLabelWithHint: true,
                                    labelText: 'Card Number',
                                    labelStyle: TextStyle(
                                        color: Colors.black, fontSize: 17),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always),
                              ),
                            ),
                          )),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: CardLogoStatic(
                                cardNumber:
                                    clearFormating(_numberController.text)),
                          )
                        ]),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0),
                          child: Container(
                            height: 60,
                            // color: Colors.amber,
                            child: TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your name.';
                                }
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 5),
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600),
                                alignLabelWithHint: true,
                                labelText: 'Name on the Card',
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0),
                          child: Container(
                            height: 60,
                            // color: Colors.amber,
                            child: TextFormField(
                              controller: _dateController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                new LengthLimitingTextInputFormatter(4),
                                new CardMonthInputFormatter()
                              ],
                              validator: (value) {
                                validateDate(value!);
                              },
                              onChanged: (v) {
                                if (_numberController.text.isNotEmpty &&
                                    _nameController.text.isNotEmpty &&
                                    _cvvController.text.isNotEmpty &&
                                    _dateController.text.isNotEmpty)
                                  setState(() {});
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  // hintText: ,
                                  // hintStyle:
                                  //     TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                                  // alignLabelWithHint: true,
                                  labelText: 'Expiry',
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 17),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0),
                          child: Container(
                            height: 90,
                            // color: Colors.amber,
                            child: TextFormField(
                              controller: _cvvController,
                              keyboardType: TextInputType.number,
                              maxLength: maxLength,
                              // obscureText: true, discussed with Nitin sir not to obscure CVV
                              validator: (value) {
                                validateCVV(value.toString());
                                if (CardCompany.AMERICAN_EXPRESS ==
                                    detectCardCompany(_numberController.text)) {
                                  setState(() {
                                    maxLength = 4;
                                  });
                                } else {
                                  setState(() {
                                    maxLength = 3;
                                  });
                                }

                                if (value!.length != maxLength) {
                                  return 'CVV is invalid';
                                }
                              },
                              onChanged: (v) {
                                if (_numberController.text.isNotEmpty &&
                                    _nameController.text.isNotEmpty &&
                                    _cvvController.text.isNotEmpty &&
                                    _dateController.text.isNotEmpty)
                                  setState(() {});
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: '',
                                  // alignLabelWithHint: true,
                                  labelText: 'Secure Code',
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 17),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
              // )
            ],
          ))
        ]));
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

  String? validateCVV(String value) {
    if (value.isEmpty) {
      return 'This field is required';
    }

    if (value.length == maxLength) {
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

  bool? validate() {
    if (_cvvController.text.isEmpty) {
      'CVV field is required.'.showSnackBar(context);
      return false;
    } else if (_nameController.text.isEmpty) {
      'Card Holder Name field is required.'.showSnackBar(context);
      return false;
    } else if (_numberController.text.isEmpty) {
      'Card Number field is required.'.showSnackBar(context);
      return false;
    } else if (_dateController.text.isEmpty) {
      'Expiry Date field is required.'.showSnackBar(context);
      return false;
    } else {
      if (CardCompany.AMERICAN_EXPRESS ==
          detectCardCompany(_numberController.text.toString())) {
        debugPrint('bbbb1');
        if (_cvvController.text.length != 4) {
          'CVV length doesn\'t match.'.showSnackBar(context);
          return false;
        } else {
          return true;
        }
      } else {
        debugPrint('bbbb2');
        if (_cvvController.text.length != 3) {
          'CVV length doesn\'t match.'.showSnackBar(context);
          return false;
        } else {
          return true;
        }
      }
      // return true;
    }
  }

  // bool validateAndSave() {
  //   if (_cvvController.text.isNotEmpty) {
  //     if (CardCompany.AMERICAN_EXPRESS ==
  //         detectCardCompany(_numberController.text)) {
  //       if (_cvvController.text.length != 4) {
  //         return false;
  //       }
  //     } else {
  //       if (_cvvController.text.length != 3) {
  //         return false;
  //       }
  //     }
  //   } else if (_nameController.text.isEmpty) {
  //     return false;
  //   } else if (_numberController.text.isEmpty) {
  //     return false;
  //   } else if (_dateController.text.isEmpty) {
  //     return false;
  //   } else {
  //     return true;
  //   }

  //   // if (_cvvController.text.isNotEmpty &&
  //   //     _nameController.text.isNotEmpty &&
  //   //     _numberController.text.isNotEmpty &&
  //   //     _dateController.text.isNotEmpty) {
  //   //   Navigator.of(context).push(MaterialPageRoute(
  //   //       builder: (_) => ScanedCard(
  //   //             cardCVV: "${_cvvController.text}",
  //   //             cardName: "${_nameController.text}",
  //   //             cardNumber: "${_numberController.text}",
  //   //             cardValid: "${_dateController.text}",
  //   //           )));
  //   // }
  //   // final FormState? form = _formKey.currentState;
  //   // if (_formKey.currentState!.validate()) {
  //   //   print('Form is valid');

  //   //   Navigator.of(context).push(MaterialPageRoute(
  //   //       builder: (_) => ScanedCard(
  //   //             cardCVV: "${_cvvController.text}",
  //   //             cardName: "${_nameController.text}",
  //   //             cardNumber: "${_numberController.text}",
  //   //             cardValid: "${_dateController.text}",
  //   //           )));
  //   // } else {
  //   //   print('Form is invalid');
  //   // }
  // }

  String getOutputNumber(String? numbergiven) {
    var numberLength = widget.cardNumber.length;
    var numbers = [];
    for (var i = 0; i < numberLength; i += 4) {
      numbers.add(numbergiven!.substring(i, i + 4));
    }

    var finalNumber = numbers.join(' - ');
    return finalNumber;
  }

  String getValidDate(String dategiven) {
    var data = dategiven;
    var numbers = [];
    if (data.length == 4) {
      numbers.add(data.substring(0, 1));
      numbers.add(data.substring(1, 3));
      return numbers.join('/');
    } else {
      numbers.add(data.substring(0, 2));
      numbers.add(data.substring(2, 4));
      return numbers.join('/');
    }
    // for (int i = 0; i < data.length; i++) {
    //   numbers.add(data.substring(i, i + 2));
    //   // var nonZeroIndex = i + 1;
    //   // if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
    //   //   buffer.write('/');
    //   // }
    // }
    // return numbers.join('/');
  }

  String clearFormating(String text) {
    String newText = text.replaceAll(' - ', '');
    return newText;
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' - '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
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
