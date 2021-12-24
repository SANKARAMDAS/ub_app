import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/ul_logo_widget.dart';

class TransactionSaved extends StatefulWidget {
  @override
  _TransactionSavedState createState() => _TransactionSavedState();
}

class _TransactionSavedState extends State<TransactionSaved> {
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    final height = deviceHeight - MediaQuery.of(context).viewPadding.top;
    timer = Timer(Duration(milliseconds: 2000), () {
      Navigator.of(context)..pop()..pop();
      timer.cancel();
    });
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.10,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ULLogoWidget(height: 54,),
                  CustomText(
                    'Track. Remind. Pay.',
                    size: 16,
                    bold: FontWeight.w500,
                    color: AppTheme.brownishGrey,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Image.asset(
              AppAssets.done2Icon,
              height: 400,
              width: double.maxFinite,
            ),
            SizedBox(
              height: height * 0.10,
            ),
            Center(
                child: CustomText(
              'Transaction Saved\nSuccessfully!',
              color: AppTheme.greenColor,
              size: 24,
              centerAlign: true,
              bold: FontWeight.w700,
            ))
          ],
        ),
      ),
    );
  }
}
