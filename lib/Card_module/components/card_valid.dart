
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Card_module/constants/captions.dart';
import 'package:urbanledger/Card_module/constants/constanst.dart';
import 'package:urbanledger/Card_module/provider/card_valid_provider.dart';
import 'package:urbanledger/Card_module/provider/state_provider.dart';

class CardValid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String inputCardValid = Provider.of<CardValidProvider>(context).cardValid;

    var defaultCardValid = Provider.of<Captions>(context)
        .getCaption('MM_YY')!
        .substring(inputCardValid.length);
    final defaultNameHeader =
    Provider.of<Captions>(context).getCaption('VALID_THRU');

    inputCardValid = inputCardValid.replaceAll("/", "");

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

    return Consumer<StateProvider>(builder: (context, state, _) {
      InputState inputState = InputState.VALIDATE;
      state.getCurrentState();
      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          (state.getCurrentState() == inputState &&
              (inputCardValid.isNotEmpty && defaultCardValid.isNotEmpty))
              ? Container(
            child: Stack(
              children: [
                // Positioned(
                //   left: 8,
                //   bottom: 25,
                //   child: Text(
                //     'Expiry Date',
                //     textAlign: TextAlign.left,
                //     style: TextStyle(
                //         color: Color.fromRGBO(255, 255, 255, 1),
                //         fontFamily: 'SF Pro Display',
                //         fontSize: 14,
                //         letterSpacing:
                //             0 /*percentages not used in flutter. defaulting to zero*/,
                //         fontWeight: FontWeight.normal,
                //         height: 1),
                //   ),
                // ),
                Image.asset(
                  'assets/images/bordervalid.png',
                  height: 35,
                ),
              ],
            ),
          )
              : Container(
            margin: EdgeInsets.only(bottom: 25, right: 18),
            child: // Figma Flutter Generator NamesurnameWidget - TEXT
            Text(
              defaultNameHeader!,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: "SFProDisplay",
                  fontSize: 10,
                  letterSpacing:
                  0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
          ),
          Container(
              margin: (state.getCurrentState() == inputState &&
                  (inputCardValid.isNotEmpty &&
                      defaultCardValid.isNotEmpty))
                  ? EdgeInsets.only(bottom: 3, right: 15,)
                  : EdgeInsets.only(top: 20, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    inputCardValid,
                    style: kValidtextStyle,
                  ),
                  Text(
                    defaultCardValid,
                    style: kDefaultValidTextStyle,
                  )
                ],
              )),
        ],
      );
    });
  }
}
