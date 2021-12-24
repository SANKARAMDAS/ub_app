import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Card_module/constants/constanst.dart';
import 'package:urbanledger/Card_module/provider/card_number_provider.dart';
import 'package:urbanledger/Card_module/provider/state_provider.dart';
import 'package:urbanledger/Card_module/util/util.dart';

class CardNumber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String defaultNumber = '';
    String cardNumber =
        Provider.of<CardNumberProvider>(context, listen: true).cardNumber;
    final currentState =
        Provider.of<StateProvider>(context, listen: true).getCurrentState();

    InputState state = InputState.NUMBER;
    if (CardCompany.AMERICAN_EXPRESS == detectCardCompany(cardNumber)) {
      final numberLength = cardNumber.replaceAll(" ", "").length;

      for (int i = 1; i <= 15 - numberLength; i++) {
        defaultNumber = 'X' + defaultNumber;
        if (i % 4 == 0 && i != 15) {
          defaultNumber = ' ' + defaultNumber;
        }
      }
    } else {
      final numberLength = cardNumber.replaceAll(" ", "").length;

      for (int i = 1; i <= 16 - numberLength; i++) {
        defaultNumber = 'X' + defaultNumber;
        if (i % 4 == 0 && i != 16) {
          defaultNumber = ' ' + defaultNumber;
        }
      }
    }

    return Container(
      height: 55,
      decoration: state.index == currentState!.index
          ? BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/border.png'),
                fit: BoxFit.fill,
              ),
            )
          : BoxDecoration(),
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.only(left: 7, top: 10,right: 7),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(
            children: <Widget>[
              Text(
                cardNumber,
                style: kCardNumberTextStyle,
              ),
              Text(
                defaultNumber,
                style: kCardDefaultTextStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
