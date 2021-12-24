import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import '../Components/extensions.dart';

class CustomCalculator extends StatefulWidget {
  final void Function()? onCPressed;
  final void Function()? onACPressed;
  final void Function()? onMPlusPressed;
  final void Function()? onMMinusPressed;
  final void Function()? onbackSpacePressed;
  final void Function()? on7Pressed;
  final void Function()? on8Pressed;
  final void Function()? on9Pressed;
  final void Function()? onMultiplyPressed;
  final void Function()? onDividePressed;
  final void Function()? onPercentPressed;
  final void Function()? on4Pressed;
  final void Function()? on5Pressed;
  final void Function()? on6Pressed;
  final void Function()? on1Pressed;
  final void Function()? on2Pressed;
  final void Function()? on3Pressed;
  final void Function()? onMinusPressed;
  final void Function()? on0Pressed;
  final void Function()? onDecimalPressed;
  final void Function()? onEqualPressed;
  final void Function()? onAddPressed;

  const CustomCalculator(
      {Key? key,
      required this.onCPressed,
      required this.onACPressed,
      required this.onMPlusPressed,
      required this.onMMinusPressed,
      required this.onbackSpacePressed,
      required this.on7Pressed,
      required this.on8Pressed,
      required this.on9Pressed,
      required this.onMultiplyPressed,
      required this.onDividePressed,
      required this.onPercentPressed,
      required this.on4Pressed,
      required this.on5Pressed,
      required this.on6Pressed,
      required this.on1Pressed,
      required this.on2Pressed,
      required this.on3Pressed,
      required this.onMinusPressed,
      required this.on0Pressed,
      required this.onDecimalPressed,
      required this.onEqualPressed,
      required this.onAddPressed})
      : super(key: key);

  @override
  _CustomCalculatorState createState() => _CustomCalculatorState();
}

class _CustomCalculatorState extends State<CustomCalculator> {
  // List operationalList = [];
  double totalAmount = 0.0;
  bool showAC = false;

  elevatedButtonStyle({Color? color}) => ElevatedButton.styleFrom(
      primary: color ?? Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      textStyle: TextStyle(
        color: Colors.black,
      ));

  // calculateAmount() {
  //   for (int i = 0; i < operationalList.length; i++) {
  //     if (i % 2 == 0) operationalList[i];
  //   }
  //   calculatedAmountNotifier.value = totalAmount;
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildRow1(),
        buildRow2(),
        buildRow3(),
        buildRow4(),
        buildRow5()
      ],
    );
  }

  Widget buildRow1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth(context) * 0.020),
            child: ElevatedButton(
              style: elevatedButtonStyle(color: AppTheme.calculatorBlue),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(
                  showAC ? 'AC' : 'C',
                  color: Colors.black,
                  bold: FontWeight.w500,
                  size: 18,
                ),
              ),
              onPressed: showAC
                  ? () {
                      widget.onACPressed!();
                      setState(() {
                        showAC = false;
                      });
                    }
                  : () {
                      widget.onCPressed!();
                      if (memoryAmountNotifier.value > 0 ||
                          memoryAmountNotifier.value < 0)
                        setState(() {
                          showAC = true;
                        });

                      // operationalList.clear();
                    },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth(context) * 0.020),
            child: ElevatedButton(
              style: elevatedButtonStyle(color: AppTheme.calculatorBlue),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(
                  'M+',
                  color: Colors.black,
                  bold: FontWeight.w500,
                  size: 18,
                ),
              ),
              onPressed: widget.onMPlusPressed,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth(context) * 0.020),
            child: ElevatedButton(
                style: elevatedButtonStyle(color: AppTheme.calculatorBlue),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomText(
                    'M-',
                    color: Colors.black,
                    bold: FontWeight.w500,
                    size: 18,
                  ),
                ),
                onPressed: widget.onMMinusPressed),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            style: elevatedButtonStyle(color: AppTheme.calculatorBlue),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Icon(
                Icons.backspace_outlined,
                color: Colors.black,
              ),
            ),
            onPressed: widget.onbackSpacePressed,
          ),
        )
      ],
    );
  }

  Widget buildRow2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth(context) * 0.020),
            child: ElevatedButton(
              style: elevatedButtonStyle(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(
                  '7',
                  color: Colors.black,
                  bold: FontWeight.w500,
                  size: 18,
                ),
              ),
              onPressed: widget.on7Pressed,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth(context) * 0.020),
            child: ElevatedButton(
              style: elevatedButtonStyle(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(
                  '8',
                  color: Colors.black,
                  bold: FontWeight.w500,
                  size: 18,
                ),
              ),
              onPressed: widget.on8Pressed,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth(context) * 0.020),
            child: ElevatedButton(
              style: elevatedButtonStyle(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(
                  '9',
                  color: Colors.black,
                  bold: FontWeight.w500,
                  size: 18,
                ),
              ),
              onPressed: widget.on9Pressed,
            ),
          ),
        ),
        Expanded(
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppTheme.calculatorBlue,
                    // padding: EdgeInsets.only(left: 0, right: 0),
                    // minimumSize: Size(35, 38)
                  ),
                  child: CustomText(
                    '÷',
                    color: Colors.black,
                    bold: FontWeight.w500,
                    size: 18,
                  ),
                  onPressed: widget.onDividePressed,
                ),
              ),
              (screenWidth(context) * 0.010).widthBox,
              Flexible(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // minimumSize: Size(35, 38),
                    primary: AppTheme.calculatorBlue,
                  ),
                  child: CustomText(
                    '%',
                    color: Colors.black,
                    bold: FontWeight.w500,
                    size: 18,
                  ),
                  onPressed: widget.onPercentPressed,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildRow3() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth(context) * 0.020),
            child: ElevatedButton(
              style: elevatedButtonStyle(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(
                  '4',
                  color: Colors.black,
                  bold: FontWeight.w500,
                  size: 18,
                ),
              ),
              onPressed: widget.on4Pressed,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth(context) * 0.020),
            child: ElevatedButton(
              style: elevatedButtonStyle(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(
                  '5',
                  color: Colors.black,
                  bold: FontWeight.w500,
                  size: 18,
                ),
              ),
              onPressed: widget.on5Pressed,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth(context) * 0.020),
            child: ElevatedButton(
              style: elevatedButtonStyle(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(
                  '6',
                  color: Colors.black,
                  bold: FontWeight.w500,
                  size: 18,
                ),
              ),
              onPressed: widget.on6Pressed,
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            style: elevatedButtonStyle(color: AppTheme.calculatorBlue),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: CustomText(
                'x',
                color: Colors.black,
                bold: FontWeight.w500,
                size: 18,
              ),
            ),
            onPressed: widget.onMultiplyPressed,
          ),
        )
      ],
    );
  }

  Widget buildRow4() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth(context) * 0.020),
            child: ElevatedButton(
              style: elevatedButtonStyle(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(
                  '1',
                  color: Colors.black,
                  bold: FontWeight.w500,
                  size: 18,
                ),
              ),
              onPressed: widget.on1Pressed,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth(context) * 0.020),
            child: ElevatedButton(
              style: elevatedButtonStyle(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(
                  '2',
                  color: Colors.black,
                  bold: FontWeight.w500,
                  size: 18,
                ),
              ),
              onPressed: widget.on2Pressed,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth(context) * 0.020),
            child: ElevatedButton(
              style: elevatedButtonStyle(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(
                  '3',
                  color: Colors.black,
                  bold: FontWeight.w500,
                  size: 18,
                ),
              ),
              onPressed: widget.on3Pressed,
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            style: elevatedButtonStyle(color: AppTheme.brownishGrey),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: CustomText(
                '-',
                color: Colors.white,
                bold: FontWeight.w500,
                size: 18,
              ),
            ),
            onPressed: widget.onMinusPressed,
          ),
        )
      ],
    );
  }

  Widget buildRow5() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth(context) * 0.020),
            child: ElevatedButton(
              style: elevatedButtonStyle(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(
                  '0',
                  color: Colors.black,
                  bold: FontWeight.w500,
                  size: 18,
                ),
              ),
              onPressed: widget.on0Pressed,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth(context) * 0.020),
            child: ElevatedButton(
              style: elevatedButtonStyle(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(
                  '.',
                  color: Colors.black,
                  bold: FontWeight.w500,
                  size: 18,
                ),
              ),
              onPressed: widget.onDecimalPressed,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth(context) * 0.020),
            child: ElevatedButton(
              style: elevatedButtonStyle(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(
                  '=',
                  color: Colors.black,
                  bold: FontWeight.w500,
                  size: 18,
                ),
              ),
              onPressed: widget.onEqualPressed,
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            style: elevatedButtonStyle(color: AppTheme.brownishGrey),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: CustomText(
                '+',
                color: Colors.white,
                bold: FontWeight.w500,
                size: 18,
              ),
            ),
            onPressed: widget.onAddPressed,
          ),
        )
      ],
    );
  }
}
