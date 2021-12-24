import 'dart:typed_data';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
// import 'package:screen/screen.dart';
import 'package:device_display_brightness/device_display_brightness.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/curved_round_button.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
// import 'package:screen/screen.dart';
// import 'screen/screen.dart';

class QRScreen extends StatefulWidget {
  // final Image? qr;
  final Uint8List qr;
  QRScreen({required this.qr});
  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  // double _brightness = 1.0;
  // bool _isKeptOn = false;
  final Repository repository = Repository();

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

  @override
  dispose() {
    super.dispose();
    // Screen.keepOn(false);
    // Screen.setBrightness(_brightness);
  }
  onTap(){
    DeviceDisplayBrightness.resetBrightness();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return onTap();
      },
      child: Scaffold(
        bottomNavigationBar: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.065),
          child: CurvedRoundButton(
            onPress: () {
              DeviceDisplayBrightness.resetBrightness();
              Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);
            },
            name: 'Okay got it',
            color: AppTheme.electricBlue,
          ),
        ),
        backgroundColor: AppTheme.paleGrey,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(children: [
              Container(
                height: deviceHeight * 0.2,
                width: double.maxFinite,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    color: Color(0xfff2f1f6),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/back.png'),
                        alignment: Alignment.topCenter)),
              ),
              // AppAssets.backgroundImage.background,
              (deviceHeight * 0.025).heightBox,
              Column(children: [
                (MediaQuery.of(context).padding.top).heightBox,
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  dense: true,
                  leading: Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 22,
                      ),
                      color: Colors.white,
                      onPressed: () {
                        DeviceDisplayBrightness.resetBrightness();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  title: Align(
                    child: new Text(
                      'My QR Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    alignment: Alignment(-1.1, 0),
                  ),
                ),
              ]),
    
              // Column(
              //   children: [
              //     Padding(
              //       padding: EdgeInsets.only(top:200, left:10, right:10),
              //       child: Image.asset(AppAssets.qrScreen),
              //     ),
              //   ],
              // ),
            ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.06),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Image.asset(
                            AppAssets.qrScreen,
                            // height: MediaQuery.of(context).size.height*0.6,
                            // width: MediaQuery.of(context).size.width*4,
                          ),
                        ),
                      ),
                    ),
                    Column(children: [
                      // (MediaQuery.of(context).padding.top).heightBox,
                      // SizedBox(
                      //   height: 15,
                      // ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.04,
                            left: MediaQuery.of(context).size.width * 0.12,
                            right: 45),
                        child: ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xff666666),
                            child: Center(
                              child: Text(
                                getInitials(
                                  '${repository.hiveQueries.userData.firstName.toString().trim()} ${repository.hiveQueries.userData.lastName.toString().trim()}',
                                  '',
                                ),
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: Colors.white, fontSize: 22),
                              ),
                            ),
                          ),
                          title: Align(
                            child: new Text(
                              '${repository.hiveQueries.userData.firstName} ${repository.hiveQueries.userData.lastName}',
                              style: TextStyle(
                                color: AppTheme.electricBlue,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            alignment: Alignment(-1.1, 0),
                          ),
                          subtitle: Align(
                            child: new Text(
                              '${repository.hiveQueries.userData.mobileNo}',
                              style: TextStyle(
                                color: AppTheme.brownishGrey,
                                fontSize: 14,
                                // fontWeight: FontWeight.w500,
                              ),
                            ),
                            alignment: Alignment(-1.1, 0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 60, right: 60),
                        child: DottedLine(
                          direction: Axis.horizontal,
                          lineLength: double.infinity,
                          lineThickness: 0.5,
                          dashLength: 4.0,
                          dashColor: Colors.black,
                          dashRadius: 0.0,
                          dashGapLength: 4.0,
                          dashGapColor: Colors.transparent,
                          dashGapRadius: 0.0,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 32, right: 40),
                        child: Image.memory(
                          widget.qr,
                          width: 250,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ]),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.11,
                      vertical: 10),
                  child: Container(
                    // color: AppTheme.paleGrey,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.paleGrey,
                      borderRadius: BorderRadius.circular(7.5),
                      border: Border.all(
                        color: AppTheme
                            .electricBlue, //                   <--- border color
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          AppAssets.scanCodeBulb,
                          width: 60,
                          // fit: BoxFit.fitWidth,
                        ),
                        // ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Simply show the QR code and\nyour friends can scan and tap!',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppTheme.brownishGrey,
                                ),
                              ),
                            ]),
                        // SizedBox(
                        //   height: 60,
                        //   child: Image.asset(
                        //     AppAssets.scanCodeBulb,
                        //     width: 40,
                        //     fit: BoxFit.fitWidth,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 60,
                        //   child: RichText(
                        //             overflow: TextOverflow.ellipsis,
                        //             text: TextSpan(
                        //                 text: 'Simply show the QR code and\nyour friends can scan and tap!',
                        //                 style: TextStyle(
                        //                   fontSize: 18,
                        //                   color: AppTheme.brownishGrey,
                        //                 ),
                        //                 children: [
                        //                     TextSpan(
                        //                         text: '\nOkay got it',
                        //                         style: TextStyle(
                        //                     fontSize: 18,
                        //                     color: AppTheme.brownishGrey,
                        //                   ),
                        //                   )
                        //                 ]
                        //             ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.05)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
