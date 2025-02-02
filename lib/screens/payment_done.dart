import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/Utility/dol_durma_clipper.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';

import 'package:whatsapp_share/whatsapp_share.dart';

import 'Components/curved_round_button.dart';
import 'package:screenshot/screenshot.dart';

class PaymentDoneScreen extends StatefulWidget {
  var model;
  final CustomerModel? customermodel;

  @override
  _PaymentDoneScreenState createState() => _PaymentDoneScreenState();

  PaymentDoneScreen({this.model, this.customermodel});
}

class _PaymentDoneScreenState extends State<PaymentDoneScreen> {
  GlobalKey _stackKey = GlobalKey();
  bool _isDoneButtonVisibile = true;
  final _ssController = ScreenshotController();
  Future<Uint8List> _capturePng() async {
    /*  setState(() {
      _isDoneButtonVisibile= false;
    });*/
    RenderRepaintBoundary? boundary = _stackKey.currentContext!
        .findAncestorRenderObjectOfType<RenderRepaintBoundary>();
    ui.Image image = await boundary!.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    /* setState(() {
      _isDoneButtonVisibile= true;
    });*/
    // var bs64 = base64Encode(pngBytes);
    return pngBytes;
  }

  Future<void> generateThumbnails(List<PlatformFile> files) async {
    for (var file in files) {
      // if (file.path!.split('.').last == 'pdf') {
      //   final doc = await PdfDocument.openFile(file.path!);
      //   final page = await doc.getPage(1);
      //   final pageImage = await page.render(
      //       height: 30, width: 50, fullHeight: 200, fullWidth: 200
      //     // width: (screenWidth(context) * 0.90).toInt(),
      //   );
      //   await pageImage.createImageIfNotAvailable();
      //   _pageImages.add(pageImage);
      // } else {
      //   _pageImages.add(null);
      // }
    }
    setState(() {});
  }

  whatsappShare(String? phone, String filePath) async {
    print(phone);
    // await WhatsappShare.shareFile(
    //   package: Package.whatsapp,
    //   text: '',
    //   phone: phone ?? '',
    //   filePath: [filePath],
    // );
  }

  onTap() {
    Navigator.of(context)
      ..pop()
      ..pop()
      ..pop();
  }

  @override
  Widget build(BuildContext context) {
    print('Device Height ' + deviceHeight.toString());
    return WillPopScope(
      onWillPop: () {
        return onTap();
      },
      child: Scaffold(
        backgroundColor: AppTheme.paleGrey,
        extendBody: true,
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 8, 8, 8),
                child: ElevatedButton(
                  onPressed: () {
                    print('Done Button Pressed');
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.mainRoute);
                  },
                  child: Text('DONE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500)),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // <-- Radius
                      ),
                      primary: AppTheme.electricBlue,
                      padding: EdgeInsets.symmetric(vertical: 12)),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 30, 8),
                child: ElevatedButton(
                  onPressed: () async {
                    debugPrint('qwerty');
                    debugPrint(widget.customermodel?.mobileNo);
                    File file = await captureScreenShot();

                    //Share.shareFiles([file.path]);
                    final RenderBox box =
                        context.findRenderObject() as RenderBox;
                    final val = await WhatsappShare.isInstalled(
                        package: Package.whatsapp);
                    if (Platform.isAndroid) {
                      if (val) {
                        await whatsappShare(
                          widget.customermodel?.mobileNo,
                          file.path,
                        );
                      }
                    } else {
                      if (val) {
                        await whatsappShare(
                          widget.customermodel?.mobileNo,
                          file.path,
                        );
                      }
                    }
                  },
                  child: Text('SHARE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500)),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // <-- Radius
                      ),
                      primary: AppTheme.electricBlue,
                      padding: EdgeInsets.symmetric(vertical: 12)),
                ),
              ),
            ),
          ],
        ),
        body: bodyWidget(),
        // Container(
        //   height: deviceHeight,
        //   alignment: Alignment.center,
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Padding(
        //         padding: EdgeInsets.only(bottom: 10),
        //         child: Image.asset(
        //           'assets/icons/transaction_failed-01.png',
        //           width: MediaQuery.of(context).size.width * 0.45,
        //         ),
        //       ),

        //       Text(
        //         'Transaction Failed',
        //         style: TextStyle(
        //             color: Color.fromRGBO(233, 66, 53, 1),
        //             fontWeight: FontWeight.bold,
        //             fontSize: 24),
        //       ),
        //       SizedBox(
        //         height: MediaQuery.of(context).size.height * 0.025,
        //       ),
        //       Text(
        //         'Oops, something went wrong. Try again.',
        //         style: TextStyle(
        //             color: AppTheme.brownishGrey,
        //             fontWeight: FontWeight.w500,
        //             fontSize: 16),
        //       ),
        //       SizedBox(
        //         height: MediaQuery.of(context).size.height * 0.03,
        //       ),
        //       paymentDetails(),
        //       // Spacer(),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  Widget bodyWidget() {
    return Container(
      height: 500,
      width: 500,
      child: Stack(
        // alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: deviceHeight * 0.21,
            width: double.maxFinite,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: Color(0xfff2f1f6),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/back2.png'),
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            // alignment: Alignment.topCenter,
            child: Container(
                child: Screenshot(
              controller: _ssController,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //         fit: BoxFit.fill,
                //         image:
                //             AssetImage("assets/images/paysuccess.png"))),
                child: ClipPath(
                  clipper: DolDurmaClipper(holeRadius: 40, bottom: 250),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: Colors.white,
                    ),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(36),
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        // color: Colors.blue,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                fit: BoxFit.fill,
                                image:
                                    AssetImage("assets/images/paysucc_new.png"),
                                height: 200,
                                width: 200,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomText('Payment Successful!',
                                  size: 24,
                                  color: Colors.greenAccent,
                                  bold: FontWeight.w600),
                              SizedBox(
                                height: 20,
                              ),
                              // CustomText(
                              //   'Please check your card details, security code, and connection',
                              //   size: 20,
                              //   color: AppTheme.brownishGrey,
                              //   bold: FontWeight.w600,
                              //   centerAlign: true,
                              // ),
                              SizedBox(
                                height: 20,
                              ),

                              //   Spacer(),
                              paymentDetails(),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Future<File> captureScreenShot() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    /*  File file =
    File(directory!.path + '/image1.png');*/
    /*file.writeAsBytesSync(
                                              await _capturePng());*/

    //  Uint8List  captureImg = await _ssController.captureFromWidget(paymentDetails());
    var path = directory!.path;
    _ssController.captureAndSave(path, //set path where screenshot will be saved
        fileName: 'image1.png');
    File file = File.fromUri(Uri.parse(path + '/image1.png'));

    return file;
  }

  Widget paymentDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.28,
                child: Text(
                  "Amount:",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.brownishGrey,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                        "${widget.model['amount'].toString().toUpperCase()}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.coolGrey,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.28,
                child: Text(
                  "Urban Ledger ID:",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.brownishGrey,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                      "${widget.model['urbanledgerId'].toString().toLowerCase()}",
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.coolGrey,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.28,
                child: Text(
                  "Transaction ID:",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.brownishGrey,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                      "${widget.model['transactionId'].toString().toLowerCase()}",
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.coolGrey,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.28,
                child: Text(
                  "Payment Method:",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.brownishGrey,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                        "${widget.model['paymentMethod'].toString().toUpperCase()}",
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.coolGrey,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.28,
                child: Text(
                  "Date & Time:",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.brownishGrey,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                      DateFormat("E, d MMM y hh:mm a").format(
                          DateTime.parse(widget.model['Date'].toString())),
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.coolGrey,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// Widget paymentDetails() {
//   DateTime dt = DateTime.parse(widget.model['Date'].toString());
//   print(DateFormat("EEE, d MMM yyyy HH:mm:ss").format(dt));
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: 50),
//     child: Column(
//       children: [
//         SizedBox(
//           height: MediaQuery.of(context).size.height * 0.018,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.28,
//               child: Text(
//                 "Amount:",
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: AppTheme.brownishGrey,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//             Text("AED 500",
//                 textAlign: TextAlign.right,
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: Color(0xffB6B6B6),
//                     fontWeight: FontWeight.w500)),
//           ],
//         ),
//         SizedBox(
//           height: MediaQuery.of(context).size.height * 0.01,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.28,
//               child: Text(
//                 "Urban Ledger ID:",
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: AppTheme.brownishGrey,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//             Text("AED 500",
//                 textAlign: TextAlign.right,
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: Color(0xffB6B6B6),
//                     fontWeight: FontWeight.w500)),
//           ],
//         ),
//         SizedBox(
//           height: MediaQuery.of(context).size.height * 0.01,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.28,
//               child: Text(
//                 "Transaction ID:",
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: AppTheme.brownishGrey,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//             Text("AED 500",
//                 textAlign: TextAlign.right,
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: Color(0xffB6B6B6),
//                     fontWeight: FontWeight.w500)),
//           ],
//         ),
//         SizedBox(
//           height: MediaQuery.of(context).size.height * 0.01,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.28,
//               child: Text(
//                 "Payment Method:",
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: AppTheme.brownishGrey,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//             Text("Tap and Pay ending in 1598",
//                 textAlign: TextAlign.right,
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: Color(0xffB6B6B6),
//                     fontWeight: FontWeight.w500)),
//           ],
//         ),
//         SizedBox(
//           height: MediaQuery.of(context).size.height * 0.01,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.28,
//               child: Text(
//                 "Date & Time:",
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: AppTheme.brownishGrey,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//             Text(
//                 "${DateFormat("EEE, d MMM yyyy").format(dt)}" +
//                     ' & '
//                         '${DateFormat("H:mma").format(dt)}',
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: Color(0xffB6B6B6),
//                     fontWeight: FontWeight.w500)),
//           ],
//         ),
//       ],
//     ),
//   );
// }
}
