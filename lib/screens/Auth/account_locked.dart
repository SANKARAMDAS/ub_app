

import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_theme.dart';

class AccountLocked extends StatefulWidget {
  const AccountLocked({Key? key}) : super(key: key);

  @override
  _AccountLockedState createState() => _AccountLockedState();
}

class _AccountLockedState extends State<AccountLocked> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      appBar: appBar(context),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            top: -60,
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
              top: 0,
              left: 0,
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                children: [
                  // (MediaQuery.of(context).padding.top).heightBox,

                ],
              ))
        ],
      ),
    );
  }

  AppBar appBar(BuildContext context) => AppBar(
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

  );
}
