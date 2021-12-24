import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/chat_module/data/models/message.dart';
import 'package:urbanledger/chat_module/data/repositories/chat_repository.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/galleryQR.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import 'package:uuid/uuid.dart';
import 'package:urbanledger/screens/Components/extensions.dart';

class ScanQR extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  late Barcode result;
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<State> key = GlobalKey<State>();
  bool found = false;
  Timer? _timer;
  String qrData = '';
  String requestId = '';
  // String qrData2 = '';
  // String title;
  // String subtitle;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  void dispose() {
    controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xff666666),
      child: Stack(
        children: [
          _buildQrView(context),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 40, left: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 35,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.45),
              child: Text(
                'Please align the QR within the Scanner',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
          if (found == true)
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.6),
                child: Text(
                  'QR Code Found',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.45, right: 10),
              child: flashIcons(),
            ),
          ),
          // if (found == true)
          //   Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Padding(
          //       padding: EdgeInsets.only(
          //           top: MediaQuery.of(context).size.height * 0.1),
          //       child: popUpScreen(),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget flashIcons() {
    return Column(
      children: [
        IconButton(
          icon: Image.asset(
            'assets/icons/Tourch-01.png',
            width: 70,
          ),
          onPressed: () async {
            await controller.toggleFlash();
            setState(() {});
          },
        ),
        // SizedBox(
        //   height: 10,
        // ),
        // IconButton(
        //   icon: Image.asset(
        //     'assets/icons/Image-01.png',
        //     width: 70,
        //   ),
        //   onPressed: () async {},
        // ),
        GalleryQRButton(),
      ],
    );
  }

  // Widget popUpScreen() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(15), topRight: Radius.circular(15)),
  //       color: Colors.white,
  //     ),
  //     width: double.infinity,
  //     height: MediaQuery.of(context).size.height * 0.2,

  //     // child: Text('Invalid format'),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(
  //           height: 20,
  //         ),
  //         Padding(
  //           padding: EdgeInsets.symmetric(
  //               horizontal: MediaQuery.of(context).size.width * 0.05),
  //           child: Row(
  //             children: [
  //               Image.asset(
  //                 'assets/icons/Wrong-01.png',
  //                 width: 35,
  //               ),
  //               SizedBox(width: 10),
  //               Text(
  //                 // title!,
  //                 style: TextStyle(
  //                     fontSize: 24,
  //                     fontWeight: FontWeight.bold,
  //                     color: AppTheme.brownishGrey),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.symmetric(
  //               horizontal: MediaQuery.of(context).size.width * 0.05,
  //               vertical: MediaQuery.of(context).size.height * 0.01),
  //           child: Text(
  //             // subtitle!,
  //             style: TextStyle(
  //                 fontSize: 18,
  //                 // fontWeight: FontWeight.bold,
  //                 color: AppTheme.brownishGrey),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         Container(
  //           width: double.infinity,
  //           padding: EdgeInsets.symmetric(horizontal: 20),
  //           // margin: EdgeInsets.only(bottom:10),
  //           child: Expanded(
  //             child: OutlineButton(
  //               padding: EdgeInsets.all(15),
  //               borderSide: BorderSide(color: Color(0xff1058ff), width: 2),
  //               color: Colors.white,
  //               onPressed: () async {
  //                 setState(() {
  //                   found = false;
  //                   controller.resumeCamera();
  //                 });
  //               },
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10)),
  //               child: CustomText(
  //                 'TRY AGAIN',
  //                 size: (18),
  //                 color: AppTheme.electricBlue,
  //                 bold: FontWeight.w500,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      cameraFacing: CameraFacing.back,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.black,
          borderRadius: 0,
          borderLength: 1,
          borderWidth: 1,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
      debugPrint('controller :${this.controller}');
    });

    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      debugPrint('qws : ' + result.code.toString());
      Uri paths = Uri.parse(result.code.toString());
      debugPrint(paths.queryParameters['customer_id']);
      if (paths.queryParameters['customer_id'] != null) {
        controller.pauseCamera();
        // requestId = paths.queryParameters['customer_id'].toString();
        setState(() {
          found = true;
        });
        getStaticQRData(paths.queryParameters['customer_id']!);
        // var map = jsonDecode(result.code);
        // if (paths.queryParameters['customer_id'] != null) {
        //   CustomLoadingDialog.showLoadingDialog(context, key);
        //   final id = await getlocalCustId((map)['mobile_no'], (map)['name'])
        //       .timeout(Duration(seconds: 30), onTimeout: () async {
        //     Navigator.of(context).pop();
        //     return Future.value(null);
        //   });
        //   Navigator.pushReplacementNamed(
        //     context,
        //     AppRoutes.payTransactionRoute,
        //     arguments: QRDataArgs(
        //         customerModel: CustomerModel()
        //           ..customerId = id
        //           ..name = (map)['name']
        //           ..mobileNo = (map)['mobile_no'],
        //         customerId: (map)['customer_id'],
        //         type: 'QRCODE',
        //         suspense: true,
        //         through: 'STATICQRCODE'),
        //   );
        // }
        //else {
        //     getQRData();
        //   }
      } else if (paths.queryParameters['request_id'] != null) {
        CustomLoadingDialog.showLoadingDialog(context, key);
        controller.pauseCamera();
        qrData = paths.queryParameters['request_id'].toString();
        setState(() {
          found = true;
        });
        getQRData();
      } else if (paths.queryParameters['request_mid'] != null) {
        CustomLoadingDialog.showLoadingDialog(context, key);
        controller.pauseCamera();
        qrData = paths.queryParameters['request_mid'].toString();
        setState(() {
          found = true;
        });
        getQRGalleryData();
      } else {
        controller.pauseCamera();
        // setState(() {
        //   found = true;
        // });
        debugPrint('falseee');
      }

      // switch (result.format.formatName) {
      //   case 'UPC_E':
      //     found = true;
      //     // title = 'Invalid format UPC_E';
      //     // subtitle = 'Oops, something went wrong. Try again.';
      //     controller.pauseCamera();
      //     break;
      //   case 'CODE_39':
      //     found = true;
      //     // title = 'Invalid format CODE_39';
      //     // subtitle = 'Oops, something went wrong. Try again.';
      //     controller.pauseCamera();
      //     break;
      //   case 'CODE_93':
      //     found = true;
      //     // title = 'Invalid format CODE_93';
      //     // subtitle = 'Oops, something went wrong. Try again.';
      //     controller.pauseCamera();
      //     break;
      //   case 'CODE_128':
      //     found = true;
      //     // title = 'Invalid format CODE_128';
      //     // subtitle = 'Oops, something went wrong. Try again.';
      //     controller.pauseCamera();
      //     break;
      //   case 'UPC_A':
      //     found = true;
      //     // title = 'Invalid format UPC_A';
      //     // subtitle = 'Oops, something went wrong. Try again.';
      //     controller.pauseCamera();
      //     break;
      //   case 'EAN_13':
      //     found = true;
      //     // title = 'Invalid format EAN_13';
      //     // subtitle = 'Oops, something went wrong. Try again.';
      //     controller.pauseCamera();
      //     break;
      //   case 'EAN_8':
      //     found = true;
      //     // title = 'Invalid format EAN_8';
      //     // subtitle = 'Oops, something went wrong. Try again.';
      //     controller.pauseCamera();
      //     break;
      //   case 'CODABAR':
      //     found = true;
      //     // title = 'Invalid format CODABAR';
      //     // subtitle = 'Oops, something went wrong. Try again.';
      //     controller.pauseCamera();
      //     break;
      //   case 'RSS_EXPANDED':
      //     found = true;
      //     // title = 'Invalid format RSS_EXPANDED';
      //     // subtitle = 'Oops, something went wrong. Try again.';
      //     controller.pauseCamera();
      //     break;
      //   case 'PDF_417':
      //     found = true;
      //     // title = 'Invalid format PDF_417';
      //     // subtitle = 'Oops, something went wrong. Try again.';
      //     controller.pauseCamera();
      //     break;
      //   case 'DATA_MATRIX':
      //     found = true;
      //     // title = 'Invalid format DATA_MATRIX';
      //     // subtitle = 'Oops, something went wrong. Try again.';

      //     controller.pauseCamera();
      //     break;
      //   case 'ITF':
      //     found = true;
      //     // title = 'Invalid format ITF';
      //     // subtitle = 'Oops, something went wrong. Try again.';
      //     controller.pauseCamera();
      //     break;
      //   case 'AZTEC':
      //     found = true;
      //     // title = 'Invalid format AZTEC';
      //     // subtitle = 'Oops, something went wrong. Try again.';
      //     controller.pauseCamera();
      //     break;
      //   case 'QR_CODE':
      //     // found=true;

      //     // bool _validURL = Uri.parse(result.code).isAbsolute;
      //     // debugPrint(_validURL.toString());
      //     // if(result.code.isNotEmpty){
      //     //   debugPrint(result.code);
      //     //   debugPrint('hello '+result.code);

      //     //   controller.pauseCamera();
      //     // }

      //     break;
      //   default:
      //     // debugPrint(result.format.formatName);
      //     // debugPrint('correct');
      //     // controller.pauseCamera();
      //     break;
      // }
    });
    // if(qrData.toString().isNotEmpty)
    // {

    //   controller.pauseCamera();
    // }
  }

  Future<void> getQRData() async {
    Map<String, dynamic> data =
        await repository.paymentThroughQRApi.getQRData(qrData);
    // debugPrint((data)['customer_id']);
    // debugPrint('(data).toString()');
    // debugPrint((data).toString());
    // Navigator.pushNamed(context, AppRoutes.payTransactionRoute, arguments: data);
    if (await checkConnectivity) {
      final id = await getlocalCustId((data)['mobileNo'],
              (data)['firstName'] + ' ' + (data)['lastName'])
          .timeout(Duration(seconds: 30), onTimeout: () async {
        Navigator.of(context).pop();
        return Future.value(null);
      });

      Map<String, dynamic> isTransaction =
          await repository.paymentThroughQRApi.getTransactionLimit(context);
      if (!(isTransaction)['isError']) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.payTransactionRoute,
          arguments: QRDataArgs(
              customerModel: CustomerModel()
                ..ulId = (data)['customer_id']
                ..name = (data)['firstName'] + ' ' + (data)['lastName']
                ..mobileNo = (data)['mobileNo'],
              customerId: id,
              amount: (data)['amount'],
              currency: (data)['currency'],
              note: (data)['note'],
              type: 'QRCODE',
              suspense: false,
              requestId: qrData,
              through: 'DYNAMICQRCODE'),
        );
      } else {
        Navigator.of(context).pop(true);
        '${(isTransaction)['message']}'.showSnackBar(context);
      }
    }else {
      Navigator.of(context).pop();
      'Please check your internet connection or try again later.'
          .showSnackBar(context);
    }
  }

  Future<void> getStaticQRData(String qrData2) async {
    Map<String, dynamic> data =
        await repository.paymentThroughQRApi.getStaticQRData(qrData2);
    debugPrint(data.toString());
    if (await checkConnectivity) {
      final id = await getlocalCustId(
              (data)['customerProfile']['mobile_no'],
              (data)['customerProfile']['first_name'] +
                  ' ' +
                  (data)['customerProfile']['last_name'])
          .timeout(Duration(seconds: 30), onTimeout: () async {
        Navigator.of(context).pop();
        return Future.value(null);
      });

      Map<String, dynamic> isTransaction =
          await repository.paymentThroughQRApi.getTransactionLimit(context);
      if (!(isTransaction)['isError']) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.payTransactionRoute,
          arguments: QRDataArgs(
              customerModel: CustomerModel()
                ..customerId = id
                ..name = (data)['customerProfile']['first_name'] +
                    ' ' +
                    (data)['customerProfile']['last_name']
                ..mobileNo = (data)['customerProfile']['mobile_no'],
              customerId: (data)['customerProfile']['_id'],
              type: 'QRCODE',
              suspense: true,
              through: 'STATICQRCODE'),
        );
      } else {
        Navigator.of(context).pop(true);
        '${(isTransaction)['message']}'.showSnackBar(context);
      }
    }else {
      Navigator.of(context).pop();
      'Please check your internet connection or try again later.'
          .showSnackBar(context);
    }
  }

  Future<void> getQRGalleryData() async {
    Map<String, dynamic> data =
        await repository.paymentThroughQRApi.getQRGalleryData(qrData);
    if (await checkConnectivity) {
      final id = await getlocalCustId((data)['mobileNo'],
              (data)['firstName'] + ' ' + (data)['lastName'])
          .timeout(Duration(seconds: 30), onTimeout: () async {
        Navigator.of(context).pop();
        return Future.value(null);
      });

      Map<String, dynamic> isTransaction =
          await repository.paymentThroughQRApi.getTransactionLimit(context);
      if (!(isTransaction)['isError']) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.payTransactionRoute,
          arguments: QRDataArgs(
              customerModel: CustomerModel()
                ..ulId = (data)['customer_id']
                ..name = (data)['firstName'] + ' ' + (data)['lastName']
                ..mobileNo = (data)['mobileNo'],
              customerId: id,
              amount: (data)['amount'].toString(),
              currency: (data)['currency'],
              note: (data)['note'],
              type: 'QRCODE',
              suspense: true,
              requestId: qrData,
              through: 'APIQRCODE'),
        );
      } else {
        Navigator.of(context).pop(true);
        '${(isTransaction)['message']}'.showSnackBar(context);
      }
    }else {
      Navigator.of(context).pop();
      'Please check your internet connection or try again later.'
          .showSnackBar(context);
    }
  }

  Future<String> getlocalCustId(String mobileNo, String name) async {
    final localCustId = await repository.queries
        .getCustomerId(mobileNo)
        .timeout(Duration(seconds: 30), onTimeout: () async {
      Navigator.of(context).pop();
      return Future.value(null);
    });
    final uniqueId = Uuid().v1();
    if (localCustId.isEmpty) {
      final customer = CustomerModel()
        ..name = getName(name.trim(), mobileNo)
        ..mobileNo = mobileNo
        ..customerId = uniqueId
        ..businessId = Provider.of<BusinessProvider>(context, listen: false)
            .selectedBusiness
            .businessId
        ..isChanged = true;
      await repository.queries.insertCustomer(customer);
      if (await checkConnectivity) {
        final apiResponse = await (repository.customerApi
            .saveCustomer(customer, context, AddCustomers.ADD_NEW_CUSTOMER)
            .timeout(Duration(seconds: 30), onTimeout: () async {
          Navigator.of(context).pop();
          return Future.value(null);
        }).catchError((e) {
          recordError(e, StackTrace.current);
          return false;
        }));

        if (apiResponse) {
          ///update chat id here
          final Messages msg = Messages(messages: '', messageType: 100);
          var jsondata = jsonEncode(msg);
          final response = await ChatRepository()
              .sendMessage(
                  customer.mobileNo.toString(),
                  customer.name,
                  jsondata,
                  customer.customerId ?? '',
                  Provider.of<BusinessProvider>(context, listen: false)
                      .selectedBusiness
                      .businessId)
              .timeout(Duration(seconds: 30), onTimeout: () async {
            Navigator.of(context).pop();
            return Future.value(null);
          });
          final messageResponse =
              Map<String, dynamic>.from(jsonDecode(response.body));
          Message _message = Message.fromJson(messageResponse['message']);
          if (_message.chatId.toString().isNotEmpty) {
            await repository.queries.updateCustomerIsChanged(
                0, customer.customerId!, _message.chatId);
          }
        }
      }else {
      Navigator.of(context).pop();
      'Please check your internet connection or try again later.'
          .showSnackBar(context);
    }
      BlocProvider.of<ContactsCubit>(context)
          .getContacts(Provider.of<BusinessProvider>(context, listen: false)
              .selectedBusiness
              .businessId)
          .timeout(Duration(seconds: 30), onTimeout: () async {
        Navigator.of(context).pop();
        return Future.value(null);
      });
    }
    return localCustId.isEmpty ? uniqueId : localCustId;
  }
}
