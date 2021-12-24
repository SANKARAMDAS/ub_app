import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/ul_logo_widget.dart';

import '../Components/extensions.dart';

class WelcomeUser extends StatefulWidget {
  @override
  _WelcomeUserState createState() => _WelcomeUserState();
}

class _WelcomeUserState extends State<WelcomeUser> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    await Permission.contacts.request();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    timer = Timer(Duration(milliseconds: 1500), () {
      Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);

      // Navigator.of(context).pushReplacementNamed(
      //   AppRoutes.setPinRoute,
      //   arguments: SetPinRouteArgs('', false, false),
      // );
      timer.cancel();
    });
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(alignment: Alignment.topCenter, children: [
        AppAssets.backgroundImage.background,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              repository.hiveQueries.userData.firstName +
                  ' ' +
                  repository.hiveQueries.userData.lastName,
              size: 25,
              color: AppTheme.electricBlue,
            ),
            SizedBox(
              height: 10,
            ),
            CustomText(
              'Welcome to',
              size: 25,
              color: AppTheme.brownishGrey,
              bold: FontWeight.w500,
            ),
            (deviceHeight * 0.10).heightBox,
            ULLogoWidget(height: 80,),
            CustomText(
              'Track. Remind. Pay.',
              size: 20,
              color: AppTheme.brownishGrey,
              bold: FontWeight.w500,
            )
          ],
        )
      ]),
    );
  }
}
