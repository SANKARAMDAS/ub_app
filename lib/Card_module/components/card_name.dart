import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Card_module/constants/captions.dart';
import 'package:urbanledger/Card_module/constants/constanst.dart';
import 'package:urbanledger/Card_module/provider/card_name_provider.dart';
import 'package:urbanledger/Card_module/provider/state_provider.dart';

class CardName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final defaultName =
        Provider.of<Captions>(context).getCaption('NAME_SURNAME');
    final defaultNameHeader =
        Provider.of<Captions>(context).getCaption('CARDHOLDER_NAME');
    final String name =
        Provider.of<CardNameProvider>(context).cardName.toUpperCase();

    return Consumer<StateProvider>(builder: (context, state, _) {
      InputState inputState = InputState.NAME;
      state.getCurrentState();
      return Stack(
        children: [
          (state.getCurrentState() == inputState && name.isNotEmpty)
              ? Image.asset(
                  'assets/images/nameborder.png',
                  height: 45,
                )
              : Container(
                  margin: EdgeInsets.only(bottom: 20, left: 8),
                  child: // Figma Flutter Generator NamesurnameWidget - TEXT
                      Text(
                    (state.getCurrentState() == inputState && name.isNotEmpty)
                        ? defaultNameHeader!
                        : defaultNameHeader.toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        // fontFamily: 'Iceberg',
                        fontSize: 10,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                ),
          Container(
            margin: (state.getCurrentState() == inputState && name.isNotEmpty)
                ? EdgeInsets.only(top: 18, left: 8)
                : EdgeInsets.only(top: 12, left: 8),
            child: Text(
                (state.getCurrentState() == inputState || name.isNotEmpty)
                    ? name
                    : defaultName.toString().toUpperCase(),
                style:
                    (state.getCurrentState() == inputState || name.isNotEmpty)
                        ? kNametextStyle
                        : kDefaultNameTextStyle),
          ),
        ],
      );
    });
  }
}
