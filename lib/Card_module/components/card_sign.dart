import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Card_module/constants/constanst.dart';
import 'package:urbanledger/Card_module/provider/card_name_provider.dart';

class CardSign extends StatelessWidget {
  const CardSign({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CardNameProvider>(
      builder: (context, provider, child) {
        String cardName = provider.cardName;

        if (cardName.isNotEmpty) {
          cardName = cardName
              .split(' ')
              .map((e) => e.isNotEmpty
                  ? '${e[0].toUpperCase()}${e.substring(1).toLowerCase()}'
                  : e)
              .join(' ');
        }

        return Container(
          margin: EdgeInsets.only(left: 15),
          height: 40,
          width: 220,
          color: Color(0xFFC4C4C4),
          child: Center(
            child: Text(
              '',
              style: kSignTextStyle,
            ),
          ),
        );
      },
    );
  }
}
