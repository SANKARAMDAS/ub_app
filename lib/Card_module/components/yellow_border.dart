import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Card_module/constants/constanst.dart';
import 'package:urbanledger/Card_module/provider/card_name_provider.dart';
import 'package:urbanledger/Card_module/provider/card_number_provider.dart';
import 'package:urbanledger/Card_module/provider/state_provider.dart';
import 'package:urbanledger/Card_module/util/util.dart';

class WhiteBorder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentState =
        Provider.of<StateProvider>(context, listen: true).getCurrentState();

    final align = getAlign(currentState);
    final height = getHeight(currentState, context);
    final width = getWidth(context, currentState);
    final margin = getMargin(currentState);

    return Stack(
      children: [
        AnimatedOpacity(
          opacity: currentState == InputState.DONE ? 0 : 1,
          duration: Duration(milliseconds: 300),
          child: AnimatedAlign(
            child: AnimatedContainer(
              margin: margin,
              duration: Duration(milliseconds: 150),
              decoration: BoxDecoration(
//if else condition here
                  // image: DecorationImage(
                  //   image: AssetImage('assets/images/border.png'),
                  //   fit: BoxFit.fill,
                  // ),
                  ),
              height: height,
              width: width,
            ),
            alignment: align,
            duration: Duration(milliseconds: 300),
          ),
        ),
      ],
    );
  }

  Alignment getAlign(currentState) {
    var align = Alignment.centerLeft;
    switch (currentState) {
      case InputState.NUMBER:
        align = Alignment.centerLeft;
        break;

      case InputState.CVV:
      case InputState.VALIDATE:
      case InputState.DONE:
        align = Alignment.bottomRight;
        break;
      case InputState.NAME:
        align = Alignment.bottomLeft;
        break;
    }
    return align;
  }

  double getHeight(InputState? currentState, context) {
    var height = 0.0;
    switch (currentState) {
      case InputState.NUMBER:
        String cardNumber =
            Provider.of<CardNumberProvider>(context, listen: false).cardNumber;

        if (CardCompany.AMERICAN_EXPRESS == detectCardCompany(cardNumber)) {
          height =
              textSize('1234  5678  123', kCardNumberTextStyle).height + 15;
        } else {
          height =
              textSize('1234  5678  1234', kCardNumberTextStyle).height + 15;
        }
        //height = textSize('123  5678  1234', kCardNumberTextStyle).height + 15;
        break;
      case InputState.NAME:
        height = textSize('hello world', kNametextStyle).height + 15;
        break;
      case InputState.CVV:
      case InputState.VALIDATE:
      case InputState.DONE:
        height = textSize('12/12', kNametextStyle).height + 15;
        break;
    }
    return height;
  }

  double getWidth(context, currentState) {
    var width = 330.0;
    switch (currentState) {
      case InputState.NUMBER:
        Provider.of<CardNumberProvider>(context, listen: false).cardNumber;
        String cardNumber =
            Provider.of<CardNumberProvider>(context, listen: false).cardNumber;

        if (CardCompany.AMERICAN_EXPRESS == detectCardCompany(cardNumber)) {
          width = textSize('XXXX XXXX XXXX XXX ', kCardDefaultTextStyle).width +
              130;
        } else {
          width = textSize('XXXX XXXX XXXX XXXX', kCardDefaultTextStyle).width +
              110;
        }
        // width =
        //     textSize('XXXX XXXX XXXX XXXX', kCardDefaultTextStyle).width + 120;
        break;
      case InputState.NAME:
        String name = Provider.of<CardNameProvider>(context).cardName;
        if (name.isEmpty) {
          name = 'NAME SURNAME';
        }
        width = textSize(name.toUpperCase(), kNametextStyle).width + 10;
        break;
      case InputState.CVV:
      case InputState.VALIDATE:
        width = textSize('MM/YY', kNametextStyle).width + 10;
        break;
    }
    return width;
  }

  getMargin(InputState? currentState) {
    var lefrMargin = 5.0;
    var rightMargin = 0.0;
    switch (currentState) {
      case InputState.NUMBER:
        break;
      case InputState.NAME:
        lefrMargin = 2.5;
        break;
      case InputState.CVV:
      case InputState.DONE:
        break;
      case InputState.VALIDATE:
        rightMargin = 3;

        break;
    }
    return EdgeInsets.only(left: lefrMargin, right: rightMargin);
  }
}
