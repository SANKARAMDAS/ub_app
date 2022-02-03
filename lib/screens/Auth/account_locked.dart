

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/arguments/account_locked_argument.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountLocked extends StatefulWidget {
  const AccountLocked({Key? key}) : super(key: key);

  @override
  _AccountLockedState createState() => _AccountLockedState();
}

class _AccountLockedState extends State<AccountLocked> {
  @override
  Widget build(BuildContext context) {

    final args =
    ModalRoute.of(context)!.settings.arguments as AccountLockedArgument;

    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
     // appBar: appBar(context),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            top: -50,
            left: 0,
            child: Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage(AppAssets.backgroundImage),
                        alignment: Alignment.topCenter))),
          ),
          Positioned.fill(
              top: 160,
              left: 0,
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(AppAssets.landscapeLogo, width: MediaQuery.of(context).size.width*0.6),
                  SizedBox(height: 60,),
                  Image.asset(AppAssets.error_account_locked_logo, width: MediaQuery.of(context).size.width*0.15),
                  SizedBox(height: 20,),
                  CustomText('Account Locked!', color:AppTheme.redColor,size: 20,bold: FontWeight.w500,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomText('${args.message}', color:AppTheme.redColor,size: 20,bold: FontWeight.w500,centerAlign: true,),
                  ),
                  SizedBox(height: 20,),
                  Expanded(child: Image.asset(AppAssets.account_locked_icon, width: MediaQuery.of(context).size.width*0.5)),


                ],
              ))
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.only(
                        bottom: 15, top: 15, left: 30, right: 30),
                    primary: AppTheme.purpleActive,
                  elevation: 0
                ),
                child: CustomText(
                  'CONTACT US',
                  size: (18),
                  bold: FontWeight.w500,
                  color: Colors.white,
                ),
                onPressed:  () {
                  _launchURL('https://urbanledger.app/contact');
                },

              ),
            ),
          ],
        ),
      ),
    );


  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  /*AppBar appBar(BuildContext context) => AppBar(
    elevation: 0,
    title: Text('Settlement History'),
    leading: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: IconButton(
        // onPressed: () => Navigator.of(context)..pop(),
        onPressed: () async {
          Navigator.pop(context);

          // Navigator.popAndPushNamed(
          //     context, AppRoutes.myProfileScreenRoute);
        },
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          size: 20,
        ),
      ),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: 20, top: 15, bottom: 15),
        child: GestureDetector(
          child: Image.asset(AppAssets.helpIcon, height: 10),
          onTap: () {
          },
        ),
      ),
    ],

  );*/
}
