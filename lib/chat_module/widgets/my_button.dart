import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_services.dart';

class MyButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final bool disabled;

  MyButton({
    required this.title,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: this.disabled ? .4 : 1,
      child: Container(
        height: 45,
        child: Material(
          color: AppTheme.electricBlue,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            highlightColor: this.disabled ? Colors.transparent : null,
            splashColor: this.disabled ? Colors.transparent : null,
            onTap: this.onTap as void Function()?,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                this.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
