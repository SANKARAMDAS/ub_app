import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/Components/ul_logo_widget.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Image.asset(AppAssets.backgroundImage),
        SizedBox(height: 20),
        (deviceHeight * 0.10).heightBox,
        ULLogoWidget(
          height: 80,
        ),
        (deviceHeight * 0.07).heightBox,
        CustomText(
          'Change the way you\nmanage your Business',
          size: (23),
          color: AppTheme.coolGrey,
          bold: FontWeight.w500,
          centerAlign: true,
        ),
        (deviceHeight * 0.20).heightBox.flexible,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xff1058ff),
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.of(context)
                  .pushNamed(AppRoutes.loginRoute, arguments: true);
            },
            child: CustomText(
              'Sign up',
              size: (18),
              color: Colors.white, 
              bold: FontWeight.w500,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          // margin: EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(15),
              side: BorderSide(color: Color(0xff1058ff), width: 2),
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.loginRoute, arguments: false);
              // Navigator.of(context).pushNamed(AppRoutes.myProfileScreenRoute);
            },
            child: CustomText(
              'Login',
              color: Color(0xff1058ff),
              size: (18),
              bold: FontWeight.w500,
            ),
          ),
        ),
      ]),
    );
  }
}
