import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/AddBankAccount/user_bank_account_provider.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';

class BankAddedSuccessfully extends StatefulWidget {
  Map model;
  BankAddedSuccessfully({required this.model});
  @override
  _BankAddedSuccessfullyState createState() => _BankAddedSuccessfullyState();
}

class _BankAddedSuccessfullyState extends State<BankAddedSuccessfully> {
  GlobalKey _stackKey = GlobalKey();
  List<PdfPageImage?> _pageImages = [];
  List<PlatformFile> _pickedFiles = [];

  @override
  void initState() {
    getRecentBankAcc();
    super.initState();
  }

  getRecentBankAcc() async {
    await Provider.of<UserBankAccountProvider>(context, listen: false)
        .getUserBankAccount();
  }

  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary? boundary = _stackKey.currentContext!
        .findAncestorRenderObjectOfType<RenderRepaintBoundary>();
    ui.Image image = await boundary!.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
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

  @override
  void dispose() {
    _pageImages.forEach((e) => e?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F1F6),
      extendBodyBehindAppBar: true,
      bottomSheet: Container(
          // margin: EdgeInsets.only(left: 20, right: 20),
          width: double.infinity,
          color: Color(0xFFF2F1F6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CurvedRoundButton(
                      color: AppTheme.electricBlue,
                      name: 'Done',
                      onPress: () {
                        print('Done Button Pressed');
                        // Navigator.of(context)..pop()..pop();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.mainRoute);
                      })
                ]),
          )),
      body: RepaintBoundary(
        child: Stack(
          key: _stackKey,
          // alignment: Alignment.topCenter,
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
            // Padding(
            //   padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
            //   child: Image.asset(
            //     'assets/images/bankaccadd.png',
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height * 0.8,
            //   ),
            // ),
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    top: (deviceHeight * 0.5) -
                        (deviceHeight > 800.0 ? 580 : 500),
                    left: 0,
                    right: 0,
                    child: Container(
                        // alignment: Alignment.center,
                        // height: deviceHeight * 0.9,
                        // color: Colors.amber,
                        margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: deviceHeight * 0.25,
                            bottom: deviceHeight * 0.22),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                    'assets/images/bankaccadd.png'))),
                        child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.46,
                              ),
                              buildAmounts(),
                              // Builder(
                              //   builder: (BuildContext context) {
                              //     return GestureDetector(
                              //       onTap: () async {
                              //         // debugPrint(widget.customermodel?.mobileNo);
                              //         Directory? directory;
                              //         if (Platform.isAndroid) {
                              //           directory =
                              //               await getExternalStorageDirectory();
                              //         } else {
                              //           directory =
                              //               await getApplicationDocumentsDirectory();
                              //         }
                              //         File file =
                              //             File(directory!.path + '/image1.png');
                              //         file.writeAsBytesSync(
                              //             await _capturePng());
                              //         // Share.shareFiles([file.path]);
                              //         final val =
                              //             await WhatsappShare.isInstalled(
                              //                 package: Package.whatsapp);
                              //         if (val) {
                              //           // await whatsappShare(
                              //           //   // widget.customermodel?.mobileNo, file.path,
                              //           // );
                              //           // await WhatsappShare.shareFile(
                              //           //     filePath: [file.path],
                              //           //     package: Package.whatsapp,
                              //           //     phone: widget.model.mobileNo!);
                              //         }
                              //       },
                              //       /*child: Container(
                              //     padding: EdgeInsets.symmetric(
                              //         vertical: 8, horizontal: 20),
                              //     margin: EdgeInsets.only(top: 16),
                              //     decoration: BoxDecoration(
                              //         color: Color(0xff1058FF),
                              //         borderRadius: BorderRadius.only(
                              //             topLeft: Radius.circular(15),
                              //             topRight: Radius.circular(15))),
                              //     child: Text(
                              //       'SHARE',
                              //       style: TextStyle(
                              //           color: Colors.white,
                              //           fontWeight: FontWeight.w500,
                              //           fontSize: 16),
                              //     ),
                              //   ),*/
                              //     );
                              //   },
                              // ),
                            ])),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: screenHeight(context) * 0.11,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                width: screenWidth(context),
                child: Text(
                  'It will take 30 minutes for us to activate your account. You can start collecting payments after 30 minutes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAmounts() {
    // return Consumer<UserBankAccountProvider>(
    //     builder: (context, userBankAccount, child) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildAmount('Account\nHolder Name ',
              '\n${widget.model['account_holders_name']}'),
          buildAmount('Bank Name ', '    ${widget.model['selected_bank_id']}'),
          // buildAmount(
          //     'Bank Name: ', '${userBankAccount.account[0].selectedBankId}'),
          // buildAmount(
          //     'IBAN Number: ', '${userBankAccount.account[0].ibannNumber}'),
          buildAmount('IBAN Number ', '${widget.model['ibann_number']}'),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 50.0),
          //   child: Text(
          //     'It will take 30 minutes for us to activate your account. You can start collecting payments after 30 minutes',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       color: Color(0xFF666666),
          //       fontSize: 18,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
    // });
  }

  Widget CButton({
    required BuildContext context,
    String? Name,
  }) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.060, //0.060
          left: MediaQuery.of(context).size.width * 0.040,
          right: MediaQuery.of(context).size.width * 0.040),
      child: RaisedButton(
        padding: EdgeInsets.all(15),
        color: Color(0xFFF2F1F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: AppTheme.electricBlue,
            width: 1,
          ),
        ),
        onPressed: () {
          Navigator.popAndPushNamed(context, AppRoutes.mainRoute);
        },
        child: Text(
          '$Name'.toUpperCase(),
          style: TextStyle(
              color: AppTheme.electricBlue,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Padding buildAmount(String title, String details) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          CustomText(
            title + ':',
            bold: FontWeight.bold,
            color: Color.fromRGBO(102, 102, 102, 1),
            fontFamily: 'SFProDisplay',
            size: MediaQuery.of(context).size.width * 0.035,
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: CustomText(
              details,
              bold: FontWeight.bold,
              fontFamily: 'SFProDisplay',
              color: Color.fromRGBO(182, 182, 182, 1),
              size: MediaQuery.of(context).size.width * 0.035,
            ),
          ),
        ]),
      ),
    );
  }
}

//import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:urbanledger/Utility/app_theme.dart';
// import 'package:urbanledger/screens/AddBankAccount/user_bank_account_provider.dart';
// import 'package:urbanledger/screens/home.dart';
//
// class BankAddedSuccessfully extends StatefulWidget {
//   @override
//   _BankAddedSuccessfullyState createState() => _BankAddedSuccessfullyState();
// }
//
// class _BankAddedSuccessfullyState extends State<BankAddedSuccessfully> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomSheet: Container(
//         color: Color(0xFFF2F1F6),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               child: CButton(Name: 'Done', context: context),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: Color(0xFFF2F1F6),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/icons/Payment_Done-01.png',
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height * 0.3,
//               ),
//               Text(
//                 'Bank Account Added',
//                 style: TextStyle(
//                     color: AppTheme.electricBlue,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold),
//               )
//             ],
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           Container(
//             width: double.maxFinite,
//             padding: EdgeInsets.only(left: 25, right: 10),
//             child: Consumer<UserBankAccountProvider>(
//                 builder: (context, userBankAccount, child) {
//               return Flexible(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           'Account Holder Name: ',
//                           textAlign: TextAlign.start,
//                           style: TextStyle(
//                             color: Color(0xFF666666),
//                             fontSize: 18,
//                           ),
//                         ),
//                         Text(
//                           '${userBankAccount.account[0].accountHolderName}',
//                           textAlign: TextAlign.start,
//                           style: TextStyle(
//                             color: Color(0xFF666666),
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           'Bank Name: ',
//                           textAlign: TextAlign.start,
//                           style: TextStyle(
//                             color: Color(0xFF666666),
//                             fontSize: 18,
//                           ),
//                         ),
//                         Text(
//                           '${userBankAccount.account[0].selectBankName}',
//                           textAlign: TextAlign.start,
//                           style: TextStyle(
//                             color: Color(0xFF666666),
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           'IBAN Number: ',
//                           textAlign: TextAlign.start,
//                           style: TextStyle(
//                             color: Color(0xFF666666),
//                             fontSize: 18,
//                           ),
//                         ),
//                         Text(
//                           'AE${userBankAccount.account[0].iBanNumber}',
//                           textAlign: TextAlign.start,
//                           style: TextStyle(
//                             color: Color(0xFF666666),
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             }),
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 50.0),
//             child: Text(
//               'It will take 30 minutes for us to activate your account. You can start collecting payments after 30 minutes',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Color(0xFF666666),
//                 fontSize: 18,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget CButton({
//     required BuildContext context,
//     String? Name,
//   }) {
//     return Padding(
//       padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).size.height * 0.060,
//           left: MediaQuery.of(context).size.width * 0.040,
//           right: MediaQuery.of(context).size.width * 0.040),
//       child: RaisedButton(
//         padding: EdgeInsets.all(15),
//         color: Color(0xFFF2F1F6),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//           side: BorderSide(
//             color: AppTheme.electricBlue,
//             width: 1,
//           ),
//         ),
//         onPressed: () {
//           Navigator.pop(context);
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => HomeScreen(),
//             ),
//           );
//         },
//         child: Text(
//           '$Name'.toUpperCase(),
//           style: TextStyle(
//               color: AppTheme.electricBlue,
//               fontSize: 16,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
