import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/Utility/dol_durma_clipper.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

import 'Components/custom_text_widget.dart';

class TransactionFailedScreen extends StatefulWidget {
  Map<String, dynamic>? model;
  final CustomerModel? customermodel;

  TransactionFailedScreen({this.model, this.customermodel});

  @override
  _TransactionFailedScreenState createState() =>
      _TransactionFailedScreenState();
}

class _TransactionFailedScreenState extends State<TransactionFailedScreen> {
  GlobalKey _stackKey = GlobalKey();
  GlobalKey _doneKey = GlobalKey();
  List<PdfPageImage?> _pageImages = [];
  List<PlatformFile> _pickedFiles = [];
  final _ssController = ScreenshotController();

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
    await WhatsappShare.shareFile(
      package: Package.whatsapp,
      text: '',
      phone: phone ?? '',
      filePath: [filePath],
    );
  }

  @override
  void initState() {
    super.initState();
    // _pickedFiles = widget.transactionModel.attachments.map((e) {
    //   return PlatformFile(path: e != null ? e : null);
    // }).toList();
    // generateThumbnails(_pickedFiles);
  }

  @override
  void dispose() {
    _pageImages.forEach((e) => e?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Navigator.pop(context, true);
                },
                child: Text('RETRY PAYMENT',
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
                  final RenderBox box = context.findRenderObject() as RenderBox;

                  if (Platform.isAndroid) {
                    final val = await WhatsappShare.isInstalled(
                        package: Package.whatsapp);
                    if (val) {
                      try{
                        await whatsappShare(
                          widget.customermodel?.mobileNo??'911234567890',
                          file.path,
                        );
                      }
                      catch(e){
                        print(e.toString());
                      }
                      // await WhatsappShare.shareFile(
                      //     filePath: [file.path],
                      //     package: Package.whatsapp,
                      //     phone: widget.customermodel?.mobileNo);
                    }
                  } else {
                    await Share.shareFiles([file.path],
                        text: '',
                        // subject: value1!.payLink.toString(),
                        sharePositionOrigin:
                            box.localToGlobal(Offset.zero) & box.size);
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
            top: 100,
            left:0,
            right:0,
            child: Container(
              child: Screenshot(
                controller: _ssController,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ClipPath(
                    clipper: DolDurmaClipper( holeRadius: 40, bottom: 250),
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
                              image: AssetImage("assets/images/payfail_new.png"),
                              height: 200,width: 200,),
                                SizedBox(height: 20,),
                                CustomText(
                                  'Payment Failed!',
                                  size: 24,
                                  color: Colors.red,
                                  bold: FontWeight.w600
                                ),
                                SizedBox(height: 20,),
                                CustomText(
                                  'Please check your card details, security code, and connection',
                                  size: 20,
                                  color: AppTheme.brownishGrey,
                                  bold: FontWeight.w600,
                                  centerAlign: true,
                                ),
                                SizedBox(height: 20,),

                            //   Spacer(),
                            paymentDetails(),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ) ,
              ),
            ),
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
    debugPrint('xxx : ' + widget.model.toString());
    debugPrint('xxx : ' + widget.model!['amount'].toString());
    // debugPrint(
    //     'xxx : ' + widget.model!['transactionData']['amount'].toString());
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          widget.model!.containsKey('card')
              ? Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.28,
                      child: Text(
                        "Card Details: ",
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
                              "${widget.model!['card'].toString().toUpperCase()}",
                              // overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.coolGrey,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
          widget.model!.containsKey('transactionData')
          ? Row(
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
                              "${widget.model!['transactionData']['amount'].toString()} ${widget.model!['transactionData']['currency'].toString()}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.coolGrey,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
              widget.model!.containsKey('amount')
                ? Row(
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
                              "${widget.model!['amount'].toString().toUpperCase()} ${widget.model!['currency'].toString().toUpperCase()}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.coolGrey,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ) : Container(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
          widget.model!.containsKey('transactionData')
              ? Row(
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
                            "${widget.model!['transactionData']['urbanledgerId'].toString().toLowerCase()}",
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.coolGrey,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )
              : Container(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
          widget.model!.containsKey('urbanledgerId')
              ? Row(
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
                            "${widget.model!['urbanledgerId'].toString().toLowerCase()}",
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.coolGrey,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )
              : Container(),
              SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
          widget.model!.containsKey('transactionId')
              ? Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.28,
                      child: Text(
                        "Transaction ID:",
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
                            "${widget.model!['transactionId'].toString().toLowerCase()}",
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.coolGrey,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )
              : Container(),
          
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
         widget.model!.containsKey('transactionData')
              ? Row(
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
                            "${widget.model!['transactionData']['transactionId'].toString().toLowerCase()}",
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.coolGrey,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )
              : Container(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
          widget.model!.containsKey('tansactionOrderId')
              ? Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.28,
                      child: Text(
                        "Order ID:",
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
                            "${widget.model!['tansactionOrderId'].toString().toLowerCase()}",
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.coolGrey,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )
              : Container(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
          widget.model!.containsKey('transactionData')
              ? Row(
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
                              "${widget.model!['transactionData']['paymentMethod'].toString().toUpperCase()}",
                              // overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.coolGrey,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
          widget.model!.containsKey('paymentMethod')
              ? Row(
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
                              "${widget.model!['paymentMethod'].toString().toUpperCase()}",
                              // overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.coolGrey,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.002,
          ),
          widget.model!.containsKey('transactionData')
              ? Row(
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                              DateFormat("E, d MMM y hh:mm a").format(DateTime.fromMillisecondsSinceEpoch(widget.model!['transactionData']['status_at'])),
                              // overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.coolGrey,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
              widget.model!.containsKey('Date')
              ? Row(
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                              DateFormat("E, d MMM y hh:mm a").format(DateTime.parse(widget.model!['Date'])),
                              // overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.coolGrey,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
              widget.model!.containsKey('message')
              ? Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.28,
                      child: Text(
                        "Message :",
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
                              "${widget.model!['message'].toString().toUpperCase()}",
                              // overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.coolGrey,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
