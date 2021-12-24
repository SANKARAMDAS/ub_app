// import 'dart:html';
// import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:screen/screen.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:device_display_brightness/device_display_brightness.dart';
// import 'package:flutter/services.dart';
//import 'package:screen/screen.dart';
// import 'screen/screen.dart';

class ProfileQR extends StatefulWidget {
  final Uint8List qrCode;
  ProfileQR({
    required this.qrCode,
  });

  @override
  _ProfileQRState createState() => _ProfileQRState();
}

class _ProfileQRState extends State<ProfileQR> {
  // double _brightness = 1.0;
  // bool _isKeptOn = false;

  double _brightness = 0.0;
  double addbrightness = 0.0;

  @override
  void initState() {
    super.initState();
    _getBrightness();
  }

  void _getBrightness() {
    DeviceDisplayBrightness.getBrightness().then((value) {
      setState(() {
        // debugPrint('asd: ' + value.toString());
        addbrightness = 1.0 - value;
        _brightness = value + addbrightness;
        // debugPrint('asd: ' + _brightness.toString());
        DeviceDisplayBrightness.setBrightness(_brightness);
      });
    });
  }

  // @override
  // dispose() {
  //   super.dispose();
  //   Screen.keepOn(false);
  //   Screen.setBrightness(_brightness);
  // }
  onTap(){
    DeviceDisplayBrightness.resetBrightness();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('qrData.toString()');
    // debugPrint(qrCode.toString());
    return WillPopScope(
      onWillPop: () {
        return onTap();
      },
      child: Scaffold(
        backgroundColor: AppTheme.paleGrey,
        bottomSheet: Container(
          color: AppTheme.paleGrey,
          // margin: EdgeInsets.only(bottom: 70),
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.2,
              vertical: MediaQuery.of(context).size.height * 0.02),
          child: NewCustomButton(
            prefixImage: AppAssets.qrCodeIcon,
            imageSize: 25.0,
            imageColor: Colors.white,
            onSubmit: () {
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (context) => QRViewExample()));
              DeviceDisplayBrightness.resetBrightness();
              Navigator.of(context).pushNamed(AppRoutes.scanQRRoute);
            },
            text: 'Open code Scanner',
            textColor: Colors.white,
            backgroundColor: AppTheme.electricBlue,
            textSize: 18.0,
            fontWeight: FontWeight.w500,
            // width: 185,
            height: 45,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 30),
                child: IconButton(
                  onPressed: () {
                    DeviceDisplayBrightness.resetBrightness();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    size: 30,
                    color: AppTheme.brownishGrey,
                  ),
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Image.memory(
                widget.qrCode,
                width: MediaQuery.of(context).size.width * 0.6,
                fit: BoxFit.fitWidth,
              ),
            ),
            // Container(
            //  margin: EdgeInsets.symmetric(vertical: 10),
            //  child: Text(
            //    'john.mathew@adib',
            //    style: TextStyle(color: AppTheme.brownishGrey, fontSize: 20),
            //  ),
            //),
            SizedBox(
              height: 35,
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text(
                '${repository.hiveQueries.userData.firstName} ${repository.hiveQueries.userData.lastName}',
                style: TextStyle(
                    color: AppTheme.brownishGrey,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                '${repository.hiveQueries.userData.email}',
                style: TextStyle(color: AppTheme.brownishGrey, fontSize: 20),
              ),
            ),
            Container(
              // margin: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                '${repository.hiveQueries.userData.mobileNo.substring(0, repository.hiveQueries.isoCode.length)} ${repository.hiveQueries.userData.mobileNo.substring(repository.hiveQueries.isoCode.length)}',
                style: TextStyle(color: AppTheme.brownishGrey, fontSize: 20),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text(
                'Scan my QR code to pay',
                style: TextStyle(color: AppTheme.brownishGrey, fontSize: 20),
              ),
            ),
            //Spacer(),
            // SizedBox(height: 150),
          ],
        ),
      ),
    );
  }
}
