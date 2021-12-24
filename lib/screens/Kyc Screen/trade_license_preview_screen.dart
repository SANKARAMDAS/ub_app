import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:urbanledger/Models/signzy_login_model.dart';
import 'package:urbanledger/Models/trade_license_pdf_model.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import 'package:urbanledger/screens/pdf_preview.dart';

import '../../main.dart';

class TradeLiscensePreviewScreen extends StatefulWidget {
  final XFile? imgPath;
  final String? path;

  TradeLiscensePreviewScreen({this.imgPath, this.path});

  @override
  _TradeLiscensePreviewScreenState createState() =>
      _TradeLiscensePreviewScreenState();
}

class _TradeLiscensePreviewScreenState
    extends State<TradeLiscensePreviewScreen> {
  GlobalKey _key = GlobalKey();

  // Future SignzyLogin() async {
  //   var headers = {'Content-Type': 'application/json'};
  //   var request = http.Request('POST',
  //       Uri.parse('https://preproduction.signzy.tech/api/v2/patrons/login'));
  //   request.body = json.encode(
  //       {"username": "vervali_test", "password": "XZ4BQdbbFldD7Fyeg8E2"});
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  //   return response.stream.bytesToString();
  // }
  //
  // Future PdfToImage(userID, pdfLink, id) async {
  //   var headers = {'Authorization': '$id', 'Content-Type': 'application/json'};
  //   var request = http.Request(
  //       'POST',
  //       Uri.parse(
  //           'https://preproduction.signzy.tech/api/v2/patrons/$userID/converters'));
  //   request.body = json.encode({
  //     "task": "pdftojpg",
  //     "essentials": {
  //       "urls": [pdfLink],
  //       "ttl": "31556926"
  //     }
  //   });
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, AppRoutes.manageKyc3Route);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Colors.white,
              title: Text(
                'Uploading Trade Licence',
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
                      child: (widget.path != null && widget.path!.isNotEmpty)
                          ? Container(
                              padding: EdgeInsets.all(10),
                              child: PdfPreviewScreen(
                                path: widget.path.toString(),
                              ),
                            )
                          : Image.file(
                              File(widget.imgPath!.path),
                              fit: BoxFit.cover,
                            )),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                            // padding: EdgeInsets.symmetric(horizontal: 65),
                            // alignment: Alignment.centerLeft,
                            child: Container(
                              child: Image.asset(
                                'assets/images/kyc/icon02.png',
                                // color: Colors.white,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                              ),
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
                            CustomLoadingDialog.showLoadingDialog(
                                context, _key);
                            if ((widget.path != null &&
                                widget.path!.isNotEmpty)) {
                              var uploadApiResponse = await repository.ledgerApi
                                  .uploadAttachment(widget.path!)
                                  .timeout(Duration(seconds: 30),
                                      onTimeout: () async {
                                Navigator.of(context).pop();
                                return Future.value(null);
                              });
                              if (uploadApiResponse.isNotEmpty) {
                                debugPrint('id' + uploadApiResponse.toString());
                                String? url =
                                    baseImageUrl + uploadApiResponse.toString();

                                debugPrint('Check the urlP: ' +
                                    url
                                        .toString()
                                        .replaceAll(' ', '%20')
                                        .toString());

                                await KycAPI.kycApiProvider.sLogin().timeout(
                                    Duration(seconds: 30), onTimeout: () async {
                                  Navigator.of(context).pop();
                                  return Future.value(null);
                                }).then((value) {
                                  debugPrint('Val' + (value).toString());
                                  SignzyModel model =
                                      signzyModelFromJson(value.toString());
                                  Future PdfToImage(
                                      userID, pdfLink, id, ttl) async {
                                    var headers = {
                                      'Authorization': '$id',
                                      'Content-Type': 'application/json'
                                    };
                                    var response = await http
                                        .post(
                                            Uri.parse(
                                                'https://preproduction.signzy.tech/api/v2/patrons/$userID/converters'),
                                            body: json.encode({
                                              "task": "pdftojpg",
                                              "essentials": {
                                                "urls": ["$pdfLink"],
                                                "ttl": "$ttl"
                                              }
                                            }),
                                            headers: headers)
                                        .timeout(Duration(seconds: 30),
                                            onTimeout: () async {
                                      Navigator.of(context).pop();
                                      return Future.value(null);
                                    });

                                    if (response.statusCode == 200) {
                                      print(response.body);
                                      TradeLicensePdfModel tpf =
                                          tradeLicensePdfModelFromJson(
                                              response.body);

                                      debugPrint(
                                          tpf.result!.pdftoJpgs![0].toString());
                                      final apiResponse = await repository
                                          .ledgerApi
                                          .networkImageToFile3(tpf
                                              .result!.pdftoJpgs![0]
                                              .toString())
                                          .timeout(Duration(seconds: 30),
                                              onTimeout: () async {
                                        Navigator.of(context).pop();
                                        return Future.value(null);
                                      });
                                      debugPrint('Checking the path: ' +
                                          apiResponse.toString());
                                      await KycAPI.kycApiProvider
                                          .KycTradeLicsense(
                                              path: apiResponse.toString())
                                          .timeout(Duration(seconds: 30),
                                              onTimeout: () async {
                                        Navigator.of(context).pop();
                                        return Future.value(null);
                                      }).then((value) async {
                                        print('Checking value' +
                                            value.toString());
                                        if (value['status'] == false) {
                                          Navigator.of(context).pop();
                                          print('Failed');
                                          modalSheet(
                                              'The image uploaded cannot be read?',
                                              'There could be multiple reasons for this\nlike poor or dim lighting, blurry image,\nor glare. Please try once again.',
                                              'Try again');
                                        } else {
                                          Repository()
                                              .hiveQueries
                                              .insertUserData(Repository()
                                                  .hiveQueries
                                                  .userData
                                                  .copyWith(
                                                      isTradeLicenseDone: true,
                                                      kycStatus: 2));
                                          var anaylticsEvents = AnalyticsEvents(context);
                                          await anaylticsEvents.initCurrentUser();
                                          await anaylticsEvents.sendTradeLicenseAddedEvent();
                                          debugPrint('It\'s done ' +
                                              value['status'].toString());
                                          Navigator.pushReplacementNamed(
                                              context,
                                              AppRoutes.manageKyc3Route);
                                        }
                                      });
                                    } else {
                                      print(response.reasonPhrase);

                                      return response.statusCode;
                                    }
                                  }

                                  PdfToImage(
                                          model.userId,
                                          url.toString().replaceAll(' ', '%20'),
                                          model.id,
                                          model.ttl)
                                      .then((value) async {
                                    debugPrint(
                                        'PDF2Image: ' + value.toString());
                                    if (value == 400) {
                                      Navigator.of(context).pop();
                                      'Only single page PDF are allowed'
                                          .showSnackBar(context);
                                    }
                                  });
                                });
                              }
                            } else {
                              await KycAPI.kycApiProvider
                                  .KycTradeLicsense(path: widget.imgPath!.path)
                                  .then((value) {
                                print('Checking value' + value.toString());
                                if (value['status'] == false) {
                                  Navigator.of(context).pop();
                                  print('Failed');
                                  modalSheet(
                                      'The image uploaded cannot be read?',
                                      'There could be multiple reasons for this\nlike poor or dim lighting, blurry image,\nor glare. Please try once again.',
                                      'Try again');
                                } else {
                                  Repository().hiveQueries.insertUserData(
                                      Repository()
                                          .hiveQueries
                                          .userData
                                          .copyWith(
                                              isTradeLicenseDone: true,
                                              kycStatus: 2));
                                  // Navigator.of(context).pop();
                                  debugPrint('It\'s done ' +
                                      value['status'].toString());
                                  Navigator.pushReplacementNamed(
                                      context, AppRoutes.manageKyc3Route);
                                }
                              });
                            }
                          },
                          child: Container(
                            // padding: EdgeInsets.symmetric(horizontal: 65),
                            // alignment: Alignment.centerLeft,
                            child: Container(
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
      ),
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
    //                                 // Navigator.popAndPushNamed(
    //                                 //     context, AppRoutes.scanTradeLicense);
    //                                 Navigator.pushReplacementNamed(
    //                                     context, AppRoutes.scanTradeLicense);
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
    //                                 context, AppRoutes.scanTradeLicense);
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
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.scanTradeLicense);
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
