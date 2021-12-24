import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Card_module/components/yellow_border.dart';
import 'package:urbanledger/Card_module/constants/captions.dart';
import 'package:urbanledger/Card_module/util/util.dart';

import '../constants/constanst.dart';
import '../provider/state_provider.dart';
import 'card_logo.dart';
import 'card_name.dart';
import 'card_number.dart';
import 'card_valid.dart';

class FrontCardView extends StatelessWidget {
  final height;
  final decoration;

  FrontCardView({this.height, this.decoration});

  @override
  Widget build(BuildContext context) {
    final captions = Provider.of<Captions>(context);

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      height: height,
      decoration: decoration,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: <Widget>[
            WhiteBorder(),
            GestureDetector(
              onTap: () {
                Provider.of<StateProvider>(context, listen: false)
                    .gotoState(InputState.NUMBER);
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: CardNumber(),
              ),
            ),
            Positioned(
              top: -10,
              bottom: 0,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topLeft,
                child: CardLogo(),
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: BankName(
                  bankName: captions.getCaption('BANKNAME'),
                )),
            SizedBox(
              height: 50,
            ),
            Positioned(
              top: 22,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 5, bottom: 10, right: 0),
                  child: sim,
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 0,
              right: 1,
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: wifi,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // Text(
                    //   captions.getCaption('CARDHOLDER_NAME').toString(),
                    //   style: TextStyle(
                    //     fontFamily: 'SFProDisplay',
                    //     fontSize: 10,
                    //     color: Colors.white,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    GestureDetector(
                        onTap: () {
                          Provider.of<StateProvider>(context, listen: false)
                              .gotoState(InputState.NAME);
                        },
                        child: CardName()),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // Text(
                    //   captions.getCaption('VALID_THRU')!,
                    //   style: TextStyle(
                    //     fontFamily: 'SFProDisplay',
                    //     fontSize: 10,
                    //     color: Colors.white,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    GestureDetector(
                        onTap: () {
                          Provider.of<StateProvider>(context, listen: false)
                              .gotoState(InputState.VALIDATE);
                        },
                        child: CardValid()),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
