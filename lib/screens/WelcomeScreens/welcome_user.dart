import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/ul_logo_widget.dart';
import 'package:urbanledger/screens/UserProfile/my_profile_screen.dart';

import '../Components/extensions.dart';

class WelcomeUser extends StatefulWidget {
  @override
  _WelcomeUserState createState() => _WelcomeUserState();
}

class _WelcomeUserState extends State<WelcomeUser> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // late Timer timer;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    await Permission.contacts.request();
  }

  Widget get divider => const SizedBox(
        height: 20,
      );

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    // timer = Timer(Duration(milliseconds: 1500), () {
    //   Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);

    // Navigator.of(context).pushReplacementNamed(
    //   AppRoutes.setPinRoute,
    //   arguments: SetPinRouteArgs('', false, false),
    // );
    //   timer.cancel();
    // });
    return Scaffold(
      backgroundColor: AppTheme.paleBlue,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Hello, ${repository.hiveQueries.userData.firstName} ${repository.hiveQueries.userData.lastName}',
                      style: TextStyle(
                          fontFamily: "Hind",
                          color: AppTheme.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Welcome to',
                      style: TextStyle(
                          fontFamily: "Hind",
                          fontSize: 44,
                          color: AppTheme.purpleActive,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.3, 
                        vertical: MediaQuery.of(context).size.height*0.05),
                    child: Image.asset(AppAssets.portraitLogo),
                  )
                  ],
                ),
              ),
              // Flexible(
              //     flex: 2,
              //     child: ),
              Flexible(
                flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Select a',
                          style: TextStyle(
                              fontFamily: "Hind",
                              fontSize: 18,
                              color: AppTheme.brownishGrey,
                              fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: ' Profile ',
                          style: TextStyle(
                              fontFamily: "Hind",
                              fontSize: 18,
                              color: AppTheme.purpleActive,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'for a seamless experience\n',
                          style: TextStyle(
                              fontFamily: "Hind",
                              fontSize: 18,
                              color: AppTheme.brownishGrey,
                              fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: 'with Urban ledger App.',
                          style: TextStyle(
                              fontFamily: "Hind",
                              fontSize: 18,
                              color: AppTheme.brownishGrey,
                              fontWeight: FontWeight.w600),
                        ),
                      ])),
                      SizedBox(height: MediaQuery.of(context).size.height*0.02),
                  CustomList(
                    icon: AppAssets.userIcon1,
                    text: 'Personal',
                    onSubmit: () async {
                      final response = (Repository()
                          .userProfileAPI
                          .userTypeChangeApi('PERSONAL', context));

                      await CustomSharedPreferences.setString(
                          //set flag
                          'accounttype',
                          'PERSONAL');
                      // String data1 =
                      //     await (CustomSharedPreferences.get('accounttype'));

                      //Navigator.pushNamed(context, AppRoutes.userProfileRoute);
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.mainRoute);
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02),
                  CustomList(
                    icon: AppAssets.busnIcon,
                    text: 'Business',
                    onSubmit: () async {
                      final response = (Repository()
                          .userProfileAPI
                          .userTypeChangeApi('BUSINESS', context));

                      await CustomSharedPreferences.setString(
                          //set flag
                          'accounttype',
                          'BUSINESS');
                      // String data1 =
                      //     await (CustomSharedPreferences.get('accounttype'));

                      //Navigator.pushNamed(context, AppRoutes.userProfileRoute);
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.mainRoute);
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.03),
                  Text('You can change your profile anytime while using our app.',
                  style: TextStyle(fontWeight: FontWeight.w500, color: AppTheme.brownishGrey),),
                  SizedBox(height: MediaQuery.of(context).size.height*0.03),
                ],
              ))
            ]),
      ),
    );
  }
}

class CustomList extends StatelessWidget {
  const CustomList({
    required this.text,
    required this.icon,
    this.onSubmit,
  });

  final String icon;
  final Function? onSubmit;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(7),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: AppTheme.blackColor.withOpacity(0.1), blurRadius: 7.0, spreadRadius: 3, offset: Offset(-5, 5))
        ],
      ),
      child: ListTile(
        tileColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onTap: () {
          onSubmit!();
        },
        dense: true,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
// CircleAvatar(
            //   radius: 22,
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Image.asset(
                icon,
                height: 35,
                color: AppTheme.purpleActive,
              ),
            ),
            // ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: VerticalDivider(
                color: AppTheme.purpleActive,
                // width: 3.0,
                thickness: 2.0,
              ),
            ),
          ],
        ),
        title: Text(
          text,
          style: TextStyle(
              color: AppTheme.brownishGrey,
              // color: AppTheme.brownishGrey,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(
          Icons.arrow_forward,
          color: AppTheme.purpleActive,
          size: 24,
        ),
      ),
    );
  }
}
