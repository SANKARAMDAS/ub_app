import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Card_module/components/card_logo.dart';
import 'package:urbanledger/Card_module/constants/constanst.dart';
import 'package:urbanledger/Card_module/provider/state_provider.dart';
import 'package:urbanledger/Card_module/util/util.dart';

import 'card_cvv.dart';
import 'card_sign.dart';

class BackCardView extends StatelessWidget {
  final height;
  final decoration;

  BackCardView({this.height, this.decoration});

  @override
  Widget build(BuildContext context) {
    final currentState =
        Provider.of<StateProvider>(context, listen: false).getCurrentState();
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      height: height,
      decoration: decoration,
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 25),
            height: 35,
            color: Colors.black,
          ),
          Align(alignment: Alignment.centerLeft, child: CardSign()),
          AnimatedOpacity(
            opacity: currentState != InputState.DONE ? 1 : 0,
            duration: Duration(milliseconds: 300),
            child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(right: 26, bottom: 10),
                  child: Container(
                    child: Image.asset(
                      'assets/images/secure.png', fit: BoxFit.contain,
                      height: 46,
                      // width: 35,
                    ),
                  ),
                )),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(right: 30),
                child: GestureDetector(
                    onTap: () {
                      Provider.of<StateProvider>(context, listen: false)
                          .gotoState(InputState.CVV);
                    },
                    child: CardCVV()),
              )),
          Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 30),
                child: wifi,
              )),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10, right: 30),
                child: CardLogo(),
              )),
        ],
      ),
    );
  }
}
