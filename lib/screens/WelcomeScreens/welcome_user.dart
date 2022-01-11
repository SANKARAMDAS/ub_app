import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
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
  // late Timer timer;

  final theImage = Image.asset(
    AppAssets.persIcon,
    height: 30,
  );
  final theImage2 = Image.asset(
    AppAssets.busnIcon,
    height: 30,
  );

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  @override
  void didChangeDependencies() {
    precacheImage(theImage.image, context);
    precacheImage(theImage2.image, context);
    super.didChangeDependencies();
  }

  Future<void> requestPermission() async {
    await Permission.contacts.request();
  }

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
      backgroundColor: AppTheme.greyBackground,
      extendBodyBehindAppBar: true,
      body: Stack(alignment: Alignment.topCenter, children: [
        AppAssets.backgroundImage.background,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (deviceHeight * 0.1).heightBox,
            CustomText(
              repository.hiveQueries.userData.firstName +
                  ' ' +
                  repository.hiveQueries.userData.lastName,
              size: 25,
              color: AppTheme.electricBlue,
            ),
            // SizedBox(
            //   height: 10,
            // ),
            CustomText(
              'Welcome to',
              size: 25,
              color: AppTheme.brownishGrey,
              bold: FontWeight.w500,
            ),
            (deviceHeight * 0.08).heightBox,
            ULLogoWidget(
              height: 80,
            ),
            CustomText(
              'Track. Remind. Pay.',
              size: 20,
              color: AppTheme.brownishGrey,
              bold: FontWeight.w500,
            ),
            (deviceHeight * 0.08).heightBox,
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Select a',
                  style: TextStyle(
                    color: AppTheme.brownishGrey,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                  children: [
                    TextSpan(
                      text: ' Profile',
                      style: TextStyle(
                        color: AppTheme.brownishGrey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextSpan(
                      text: ' for a seamless experience\n',
                      style: TextStyle(
                        color: AppTheme.brownishGrey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextSpan(
                      text: 'with UrbanLedger App.',
                      style: TextStyle(
                        color: AppTheme.brownishGrey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            CustomList(
              icon: theImage,
              text: 'Personal',
              onSubmit: () {
                //Navigator.pushNamed(context, AppRoutes.userProfileRoute);
                Navigator.pushReplacementNamed(context, AppRoutes.mainRoute);
              },
            ),
            divider,
            Container(
              // width: 100.0,
              // height: 100.0,
              child: CustomList(
                icon: theImage2,
                text: 'Business',
                onSubmit: () {
                  //Navigator.pushNamed(context, AppRoutes.userProfileRoute);
                  Navigator.pushReplacementNamed(context, AppRoutes.mainRoute);
                },
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'You can change your profile anytime while using our app.',
              style: TextStyle(
                color: AppTheme.brownishGrey,
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        )
      ]),
    );
  }

  Widget get divider => const SizedBox(
        height: 20,
      );
}

class CustomList extends StatelessWidget {
  final String text;
  final Widget icon;
  final Function? onSubmit;

  const CustomList({
    required this.text,
    required this.icon,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.only(left: 20.0, right: 30.0),
      // padding: EdgeInsets.only(
      //                       left: MediaQuery.of(context).size.width * 0.068,
      //                       right: MediaQuery.of(context).size.width * 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
// decoration: BoxDecoration(
      //   border: Border.all(
      //     color: Colors.white, // red as border color
      //   ),
      //   borderRadius: BorderRadius.circular(10.0),
      //   color: Colors.white,
      // ),
      child: Padding(
        padding: EdgeInsets.only(
            top: 7,
            left: MediaQuery.of(context).size.width * 0.01,
            bottom: 7,
            right: MediaQuery.of(context).size.width * 0.001),
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
                child: icon,
              ),
              // ),
              VerticalDivider(
                color: AppTheme.electricBlue,
                // width: 3.0,
                thickness: 1.0,
              ),
            ],
          ),
          title: Text(
            text,
            style: TextStyle(
                color: Colors.black,
                // color: AppTheme.brownishGrey,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.electricBlue,
            size: 30,
          ),
        ),
      ),
    );
  }
}
