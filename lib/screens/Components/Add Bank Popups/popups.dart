import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_theme.dart';

class BankAccountPopUps extends StatelessWidget {
  final String title;
  final String image;

  const BankAccountPopUps({Key? key, required this.title, required this.image})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            // height: screenHeight(context) / 5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 15),
                  child: Text(title,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                ),
                Image.asset(image, height: 70),
                SizedBox(height: 7),
                _customButton('OK', () {})
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customButton(String title, Function ontap) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: AppTheme.electricBlue,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
              child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18),
          )),
        ),
      ),
    );
  }
}
