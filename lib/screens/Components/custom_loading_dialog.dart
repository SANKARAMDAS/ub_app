import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_services.dart';

class CustomLoadingDialog {
  static Future<void> showLoadingDialog(BuildContext context, [GlobalKey? key]) async {
    return showDialog<void>(context: context, barrierDismissible: false, builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false, 
        child:
          Center(
            child:CircularProgressIndicator(
              color: AppTheme.electricBlue,
            ),
          )
      );
    });
  } 
}

