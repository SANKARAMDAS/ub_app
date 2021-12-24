import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/screens/Components/extensions.dart';

class CustomAmountFiller extends StatefulWidget {
  Widget CtextFilled;

  CustomAmountFiller({required this.CtextFilled});

  @override
  _CustomAmountFillerState createState() => _CustomAmountFillerState();
}

class _CustomAmountFillerState extends State<CustomAmountFiller> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (deviceHeight * 0.12).heightBox,
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                'Enter the Amount',
                style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    height: 1),
              ),
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'AED',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    thickness: 2,
                    indent: 2,
                    endIndent: 2,
                    color: Colors.white54,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      // width: MediaQuery.of(context).size.width * 0.15,
                      child: widget.CtextFilled,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
