import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:upgrader/upgrader.dart';

class AppUpdate extends StatelessWidget {
  const AppUpdate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.greyBackground,
      appBar: AppBar(
        title: Text('App Update'),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 22,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.none,
              height: deviceHeight * 0.06,
              width: double.infinity,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(AppAssets.backgroundImage),
                      alignment: Alignment.topCenter)),
            ),
            UpgradeAlert(
              dialogStyle: UpgradeDialogStyle.cupertino,
              child: Center(child: Text('Checking...')),
            )
          ],
        ),
      ),
    );
  }
}
