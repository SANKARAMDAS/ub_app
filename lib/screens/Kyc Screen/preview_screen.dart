import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';

class EmiratesIdPreviewScreen extends StatefulWidget {
  final imgPath;
  EmiratesIdPreviewScreen({this.imgPath});

  @override
  _EmiratesIdPreviewScreenState createState() =>
      _EmiratesIdPreviewScreenState();
}

class _EmiratesIdPreviewScreenState extends State<EmiratesIdPreviewScreen> {
  GlobalKey _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, AppRoutes.manageKyc3Route);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.white,
            title: Text(
              'Uploading Emirates ID',
              style: TextStyle(
                color: AppTheme.electricBlue,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppTheme.brownishGrey,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, AppRoutes.manageKyc3Route);
              },
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width - 40,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: widget.imgPath!.isNotEmpty
                        ? Image.file(
                            File(widget.imgPath),
                            fit: BoxFit.contain,
                          )
                        : Center(
                            child: Text(
                                'Image was not captured properly\nPlease try again.'),
                          )),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          modalSheet(
                              'Upload in progress',
                              'Your document has been uploading,\nIf you want to cancel it? ',
                              'cancel');
                        },
                        child: Container(
                          child: Image.asset(
                            'assets/images/kyc/icon02.png',
                            // color: Colors.white,
                            height: MediaQuery.of(context).size.height * 0.06,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                      ),
                      InkWell(
                        onTapCancel: () {
                          modalSheet(
                              'Upload in progress',
                              'Your document has been uploading,\nIf you want to cancel it? ',
                              'cancel');
                        },
                        onTap: () async {
                          print('yes');
                          CustomLoadingDialog.showLoadingDialog(context, _key);
                          await KycAPI.kycApiProvider
                              .KycEmiratedID(path: widget.imgPath)
                              .timeout(Duration(seconds: 30),
                                  onTimeout: () async {
                            Navigator.of(context).pop();
                            return Future.value(null);
                          }).then((value) async {
                            print('Checking value' + value.toString());
                            if (value['status'] == false &&
                                value['message'] == 'Expired Document') {
                              Navigator.of(context).pop();
                              modalSheet(
                                  'Expired Emirates ID',
                                  'Your Emirates ID seems to be expired.\nPlease renew your ID.',
                                  'Try again');
                            } else if (value['status'] == false) {
                              Navigator.of(context).pop();
                              print('Failed');
                              modalSheet(
                                  'The image uploaded cannot be read',
                                  'There could be multiple reasons for this\nlike poor or dim lighting, blurry image,\nor glare. Please try once again.',
                                  'Try again');
                            } else {
                              debugPrint('It\'s done ');
                              var anaylticsEvents = AnalyticsEvents(context);
                              await anaylticsEvents.initCurrentUser();
                              await anaylticsEvents.sendEmiratesIdAddedEvent();
                              Repository().hiveQueries.insertUserData(
                                  Repository().hiveQueries.userData.copyWith(
                                        isEmiratesIdDone: true,
                                      ));
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.manageKyc3Route);
                            }
                          });
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.check_circle,
                              color: AppTheme.brownishGrey,
                              size: MediaQuery.of(context).size.height * 0.06,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // padding: EdgeInsets.symmetric(horizontal: 45),
                        child: Image.asset(
                          'assets/images/kyc/icon4.png',
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        // padding: EdgeInsets.symmetric(horizontal: 65),
                        child: Text(
                          "Don't worry your information is secure with us",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          )),
    );
  }

  modalSheet(String title, String tagline, value) {
    // return showModalBottomSheet(
    //     context: context,
    //     isDismissible: true,
    //     enableDrag: true,
    //     builder: (context) {
    //       return Container(
    //         color: Color(0xFF737373), //could change this to Color(0xFF737373),

    //         height: MediaQuery.of(context).size.height * 0.28,
    //         child: Container(
    //           decoration: new BoxDecoration(
    //               color: Colors.white,
    //               borderRadius: new BorderRadius.only(
    //                   topLeft: const Radius.circular(10.0),
    //                   topRight: const Radius.circular(10.0))),
    //           //height: MediaQuery.of(context).size.height * 0.25,
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: <Widget>[
    //               Padding(
    //                 padding: const EdgeInsets.only(
    //                   top: 40.0,
    //                   left: 40.0,
    //                   right: 40.0,
    //                   bottom: 10,
    //                 ),
    //                 child: Text(
    //                   '$title',
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                       color: Color.fromRGBO(233, 66, 53, 1),
    //                       fontFamily: 'SFProDisplay',
    //                       fontSize: 18,
    //                       letterSpacing:
    //                           0 /*percentages not used in flutter. defaulting to zero*/,
    //                       fontWeight: FontWeight.normal,
    //                       height: 1),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(bottom: 10),
    //                 child: Text(
    //                   '$tagline',
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                       color: Color.fromRGBO(102, 102, 102, 1),
    //                       fontFamily: 'SFProDisplay',
    //                       fontSize: 17,
    //                       letterSpacing:
    //                           0 /*percentages not used in flutter. defaulting to zero*/,
    //                       fontWeight: FontWeight.normal,
    //                       height: 1),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(20.0),
    //                 child: value != 'Try again'
    //                     ? Row(
    //                         children: [
    //                           Expanded(
    //                             child: NewCustomButton(
    //                               onSubmit: () {
    //                                 Navigator.pop(context);
    //                               },
    //                               text: 'CANCEL',
    //                               textColor: Colors.white,
    //                               textSize: 14,
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             width: 20,
    //                           ),
    //                           Expanded(
    //                             child: NewCustomButton(
    //                               onSubmit: () {
    //                                 Navigator.of(context).pop();
    //                                 Navigator.pushReplacementNamed(
    //                                     context, AppRoutes.scanEmiratesID);
    //                               },
    //                               text: 'CONFIRM',
    //                               textColor: Colors.white,
    //                               textSize: 14,
    //                             ),
    //                           ),
    //                         ],
    //                       )
    //                     : Expanded(
    //                         child: NewCustomButton(
    //                           onSubmit: () {
    //                             Navigator.popAndPushNamed(
    //                                 context, AppRoutes.scanEmiratesID);
    //                           },
    //                           text: 'Try Again'.toUpperCase(),
    //                           textColor: Colors.white,
    //                           textSize: 14,
    //                         ),
    //                       ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     });
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            constraints: BoxConstraints(maxHeight: 500),
            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              // height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                      left: 40.0,
                      right: 40.0,
                      bottom: 10,
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$title',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppTheme.tomato,
                              fontFamily: 'SFProDisplay',
                              fontSize: 20,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.bold,
                              height: 1),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '$tagline',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppTheme.brownishGrey,
                          fontFamily: 'SFProDisplay',
                          fontSize: 18,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          // fontWeight: FontWeight.w700,
                          height: 1),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: NewCustomButton(
                      onSubmit: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.scanEmiratesID);
                      },
                      text: 'TRY AGAIN'.toUpperCase(),
                      textColor: Colors.white,
                      backgroundColor: AppTheme.electricBlue,
                      textSize: 15.0,
                      fontWeight: FontWeight.bold,
                      // width: 185,
                      height: 50,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
