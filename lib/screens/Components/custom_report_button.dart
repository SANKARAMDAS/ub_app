import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';

class CustomReportButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isCustomerEmpty;

  const CustomReportButton(
      {required this.onPressed, required this.isCustomerEmpty});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPrimary: Colors.white,
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isCustomerEmpty
                    ? 'assets/icons/greydoc.png'
                    : 'assets/icons/Document-01.png',
                height: 26,
              ),
              SizedBox(width: 5),
              CustomText(
                'View Report',
                bold: FontWeight.w500,
                color:
                    isCustomerEmpty ? AppTheme.greyish : AppTheme.brownishGrey,
                size: 16,
              ),
            ],
          )),
    );
  }
}
