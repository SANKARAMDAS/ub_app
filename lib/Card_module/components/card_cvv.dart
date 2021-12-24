import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Card_module/constants/constanst.dart';
import 'package:urbanledger/Card_module/provider/card_cvv_provider.dart';

class CardCVV extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CardCVVProvider>(
      builder: (context, value, child) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFFEBEBEB),
                  borderRadius: BorderRadius.circular(4)),
              height: 28,
              width: 94,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    value.cardCVV.toString().replaceAll(RegExp(r'[0-9]'), '*'),
                    style: kCVCTextStyle,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
