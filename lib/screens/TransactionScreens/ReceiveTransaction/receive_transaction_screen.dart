import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

// import 'package:share/share.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/generate_link_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Services/APIs/payment_through_generated_link.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/chat_module/screens/contact/contact_controller.dart';
import 'package:urbanledger/chat_module/screens/contact/request_controller.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/Custom_Amount_Filler.dart';
import 'package:urbanledger/screens/Components/Custom_Amount_SS.dart';
import 'package:urbanledger/screens/Components/custom_popup.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';

class ReceiveTransactionScreen extends StatefulWidget {
  final CustomerModel model;
  final String customerId;
  final String? amount;
  final Function(double amount, String details, int paymentType)? sendMessage;

  ReceiveTransactionScreen(
      {required this.model,
      this.sendMessage,
      required this.customerId,
      this.amount});

  @override
  _ReceiveTransactionScreenState createState() =>
      _ReceiveTransactionScreenState();
}

class _ReceiveTransactionScreenState extends State<ReceiveTransactionScreen> {
  final GlobalKey<State> key = GlobalKey<State>();
  final TextEditingController _enterDetailsController = TextEditingController();
  bool isQRCode = false;
  bool isViaLink = false;
  bool isULChat = false;
  bool isAmountFilled = false;
  bool isPressed = false;
  late RequestController _requestController;
  String? _id;

  TextEditingController currController = TextEditingController();

  GlobalKey _stackKey = GlobalKey();
  bool isDefault = false;
  List<PlatformFile> _pickedFiles = [];
  List<PdfPageImage?> _pageImages = [];
  List<String> attachmentIds = [];
  var uploadApiResponse;
  Future<Uint8List> _capturePng() async {
    final RenderRepaintBoundary boundary =
        _stackKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    // var bs64 = base64Encode(pngBytes);
    return pngBytes;
  }

  //
  // whatsappShare(String? phone, String filePath) async {
  //   print(phone);
  //   await WhatsappShare.shareFile(
  //     package: Package.whatsapp,
  //     text: '',
  //     phone: phone ?? '',
  //     filePath: [filePath],
  //   );
  // }

  @override
  void initState() {
    debugPrint(widget.model.ulId.toString());
    _requestController = RequestController(
      context: context,
    );
    super.initState();
    data();
  }

  data() {
    debugPrint('qwertyuio :' + widget.amount.toString());
    if (widget.amount != null && widget.amount!.isNotEmpty) {
      debugPrint('has data :');
      currController.text = widget.amount.toString();
      isAmountFilled = true;
    }
    // else {
    //   debugPrint('no data :');
    //   currController.text = '';
    // }
  }

  @override
  void didChangeDependencies() {
    _requestController.initProvider();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();

    currController.dispose();
    _requestController.dispose();
    _enterDetailsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F1F6),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Builder(
          builder: (BuildContext context) {
            return NewCustomButton(
                onSubmit: () async {
                  if ((isQRCode == true ||
                          isViaLink == true ||
                          isULChat == true) &&
                      isAmountFilled == true &&
                      isPressed != true) {
                    if (isQRCode == true) {
                      CustomLoadingDialog.showLoadingDialog(context, key);
                      setState(() {
                        isPressed = true;
                      });
                      debugPrint('QR' + isQRCode.toString());
                      if (await checkConnectivity) {
                        var cid = await repository.customerApi
                            .getCustomerID(mobileNumber: widget.model.mobileNo)
                            .timeout(Duration(seconds: 30),
                                onTimeout: () async {
                                  setState(() {
                                  isPressed = false;
                                });
                          Navigator.of(context).pop();
                          'Please check internet connectivity and try again.'
                                    .showSnackBar(context);
                          return Future.value(null);
                        }).catchError((e){
                          setState(() {
                                  isPressed = false;
                                });
                          Navigator.of(context).pop();
                          'Please check internet connectivity and try again.'
                                    .showSnackBar(context);
                        });

                        if (cid.customerInfo?.id == null) {
                          Navigator.of(context).pop(true);
                          MerchantBankNotAdded.showBankNotAddedDialog(
                                  context, 'userNotRegistered')
                              .then((value) {
                            // Navigator.of(context).pop();
                            setState(() {
                              isPressed = false;
                            });
                          });
                        } else {
                          if (isAmountFilled == true) {
                            // CustomLoadingDialog.showLoadingDialog(context, key);
                            debugPrint('qqww : '+widget.model.toJson().toString());
                            Map<String, dynamic> data = {
                              "amount":
                                  '${currController.text.trim().toString().replaceAll(',', '')}',
                              "currency": '$currencyAED',
                              "note": "${_enterDetailsController.text.trim()}",
                              "bills": '',
                              "from_customer":
                              cid.customerInfo?.id,
                              "request_through": "DYNAMICQRCODE"
                            };
                            debugPrint('ffg: ' + data.toString());
                            if (await checkConnectivity) {
                              final response = await repository
                                  .paymentThroughQRApi
                                  .sendQRData(data)
                                  .timeout(Duration(seconds: 30),
                                      onTimeout: () async {
                                        setState(() {
                                  isPressed = false;
                                });
                                Navigator.of(context).pop();
                                'Please check internet connectivity and try again.'
                                    .showSnackBar(context);
                                return Future.value(null);
                              }).catchError((e){
                                setState(() {
                                  isPressed = false;
                                });
                                Navigator.of(context).pop();
                                'Please check internet connectivity and try again.'
                                    .showSnackBar(context);
                              });
                              final qrData = response.last;
                              if (response.first != null) {
                                final previousBalance = (await repository
                                    .queries
                                    .getPaidMinusReceived(widget.customerId));
                                await BlocProvider.of<LedgerCubit>(context)
                                    .addLedger(
                                        TransactionModel()
                                          ..transactionId = response.first
                                          ..amount = double.tryParse(
                                                  currController.text
                                                      .trim()
                                                      .replaceAll(',', '')) ??
                                              0
                                          ..transactionType =
                                              TransactionType.Receive
                                          ..customerId = widget.customerId
                                          ..date = DateTime.now()
                                          ..attachments = _pickedFiles
                                              .map((e) => e.path)
                                              .toList()
                                          ..details =
                                              '${_enterDetailsController.text}'
                                          ..balanceAmount = previousBalance +
                                              (double.tryParse(currController
                                                      .text
                                                      .trim()
                                                      .replaceAll(',', '')) ??
                                                  0)
                                          ..isChanged = true
                                          ..isDeleted = false
                                          ..isPayment = false
                                          ..isReadOnly = true
                                          ..business =
                                              Provider.of<BusinessProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedBusiness
                                                  .businessId
                                          ..createddate = DateTime.now(),
                                        () {},
                                        context);
                              }
                              var anaylticsEvents = AnalyticsEvents(context);
                              await anaylticsEvents.initCurrentUser();
                              await anaylticsEvents
                                  .generatedDynamicQrCodeEvent(data);
                              await anaylticsEvents
                                  .requestPaymentEvent(jsonEncode(data));

                              Navigator.of(context).pop();
                              Navigator.pushNamed(context, AppRoutes.qrScreen,
                                      arguments: qrData)
                                  .then((value) {
                                setState(() {
                                  isPressed = false;
                                });
                              });
                            } else {
                              setState(() {
                                  isPressed = false;
                                });
                              Navigator.of(context).pop();
                              'Please check your internet connection or try again later.'
                                  .showSnackBar(context);
                            }
                          } else {
                            'Please enter amount.'.showSnackBar(context);
                          }
                        }
                      } else {
                        setState(() {
                                  isPressed = false;
                                });
                        Navigator.of(context).pop();
                        'Please check your internet connection or try again later.'
                            .showSnackBar(context);
                      }
                    } else if (isViaLink == true) {
                      if (await checkConnectivity) {
                        CustomLoadingDialog.showLoadingDialog(context, key);
                        Directory? directory;
                        if (Platform.isAndroid) {
                          directory = await getExternalStorageDirectory();
                        } else {
                          directory = await getApplicationDocumentsDirectory();
                        }
                        File file = File(directory!.path + '/image1.png');
                        file.writeAsBytesSync(await _capturePng());
                        debugPrint('Link' + isViaLink.toString());
                        var anaylticsEvents = AnalyticsEvents(context);
                        await anaylticsEvents.initCurrentUser();
                        await anaylticsEvents
                            .generatedDynamicPaymentLinkEvent();
                        getLink('whatsapp', [file.path]);
                      } else {
                        // Navigator.of(context).pop();
                        'Please check your internet connection or try again later.'
                            .showSnackBar(context);
                      }
                    } else {
                      if (await checkConnectivity) {
                        // Map<String, dynamic> data = {
                        //   "amount":
                        //       '${currController.text.trim().toString().replaceAll(',', '')}',
                        //   "currency": '$currencyAED',
                        //   "note": "${_enterDetailsController.text.trim()}",
                        //   "bills": '',
                        //   "request_through": "CHAT"
                        // };
                        CustomLoadingDialog.showLoadingDialog(context, key);
                        // final response = await repository.paymentThroughQRApi
                        //     .sendQRData(data)
                        //     .timeout(Duration(seconds: 30), onTimeout: () async {
                        //   Navigator.of(context).pop();
                        //   return Future.value(null);
                        // });
                        try {
                          Directory? directory;
                          if (Platform.isAndroid) {
                            directory = await getExternalStorageDirectory();
                          } else {
                            directory =
                                await getApplicationDocumentsDirectory();
                          }
                          File file = File(directory!.path + '/image1.png');
                          file.writeAsBytesSync(await _capturePng());
                          debugPrint('UL' + isULChat.toString());
                          getLink('chat', [file.path]);
                        } catch (e) {
                          print(e.toString());
                        }
                      } else {
                        // Navigator.of(context).pop();
                        'Please check your internet connection or try again later.'
                            .showSnackBar(context);
                      }
                    }
                  }
                },
                backgroundColor: (isQRCode == true ||
                            isViaLink == true ||
                            isULChat == true) &&
                        isAmountFilled == true &&
                        isPressed == false
                    ? AppTheme.electricBlue
                    : AppTheme.coolGrey,
                text: isQRCode == true ? 'QR CODE' : 'SHARE',
                textSize: 20,
                textColor: Colors.white);
          },
        ),
      ),
      body: Stack(
        children: [
          RepaintBoundary(
            key: _stackKey,
            child: Container(
              height: 320,
              // margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/BG-12.jpg'))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  (deviceHeight * 0.03).heightBox,
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      'Payment Request for',
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                          height: 1),
                    ),
                  ),
                  CustomAmountSS(
                    CtextFilled: TextFormField(
                      controller: currController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r"^\d*\.?\d*")),
                      ],
                      autofocus: false,
                      onChanged: (value) {
                        setState(() {
                          isAmountFilled = (currController.text.isEmpty ||
                                      currController.text.length == 0) ||
                                  (int.tryParse(currController.text) == 0)
                              ? false
                              : true;
                        });
                      },
                      onTap: () {
                        setState(() {
                          debugPrint(isAmountFilled.toString());
                          isViaLink = false;
                        });
                      },
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.2),
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                          hintText: "0"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // _selectedDate = await showDatePickerWidget(context);
                      // if (_selectedDate != null) setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        'On ${DateFormat('dd MMMM yyyy').format(DateTime.now())}',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        Text(
                          'Requested by ${Provider.of<BusinessProvider>(context).selectedBusiness.businessName}',
                          style: TextStyle(
                              color: AppTheme.brownishGrey,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${repository.hiveQueries.userData.firstName} | ${repository.hiveQueries.userData.mobileNo}',
                          style: TextStyle(
                              color: AppTheme.brownishGrey,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        Text(
                          'Click on link below to make payment',
                          style: TextStyle(
                              color: AppTheme.brownishGrey,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: AppTheme.brownishGrey,
                          size: 45,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Color(0xfff2f1f6),
                  child: Stack(
                    children: [
                      Container(
                        height: deviceHeight * 0.31,
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
                      SafeArea(
                        child: AppBar(
                          automaticallyImplyLeading: false,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  size: 22,
                                ),
                                color: Colors.white,
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              CustomProfileImage(
                                avatar: widget.model.avatar,
                                mobileNo: widget.model.mobileNo,
                                name: widget.model.name,
                              ),
                              // CircleAvatar(
                              //   radius: 22,
                              //   backgroundColor: Colors.white,
                              //   child: CircleAvatar(
                              //     radius: 20,
                              //     backgroundColor:
                              //         _colors[random.nextInt(_colors.length)],
                              //     backgroundImage: widget.model!.avatar == null ||
                              //             widget.model!.avatar!.isEmpty
                              //         ? null
                              //         : MemoryImage(widget.model!.avatar!),
                              //     child: widget.model!.avatar == null ||
                              //             widget.model!.avatar!.isEmpty
                              //         ? CustomText(
                              //             getInitials(widget.model!.name!.trim(),
                              //                 widget.model!.mobileNo!.trim()),
                              //             color: AppTheme.circularAvatarTextColor,
                              //             size: 22,
                              //           )
                              //         : null,
                              //   ),
                              // ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    '${widget.model.name}',
                                    color: Colors.white,
                                    size: 18,
                                    bold: FontWeight.w600,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // Navigator.of(context)
                                      //     .pushNamed(AppRoutes.customerProfileRoute);
                                    },
                                    child: Text(
                                      '${widget.model.mobileNo}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          actions: [
                            // Icon(
                            //   Icons.more_vert,
                            //   color: Colors.white,
                            //   size: 30,
                            // ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      // RepaintBoundary(
                      //   key: _stackKey,
                      //   child: Container(height: 320,margin: EdgeInsets.only(top: 10),
                      //     decoration: BoxDecoration(
                      //       image: DecorationImage(
                      //         image: AssetImage('assets/images/BG-12.jpg')
                      //       )
                      //     ),child:  Column(
                      //         crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.start,
                      //         children: [
                      //
                      //           CustomAmountFiller(
                      //             CtextFilled: TextFormField(
                      //               controller: currController,
                      //               autofocus: false,
                      //               onChanged: (value) {
                      //                 setState(() {
                      //                   isAmountFilled = (currController.text.isEmpty ||
                      //                       currController.text.length == 0) ||
                      //                       (int.tryParse(currController.text) == 0)
                      //                       ? false
                      //                       : true;
                      //                 });
                      //               },
                      //               onTap: () {
                      //                 setState(() {
                      //                   debugPrint(isAmountFilled.toString());
                      //                   isViaLink = false;
                      //                 });
                      //               },
                      //               keyboardType: TextInputType.phone,
                      //               style: TextStyle(
                      //                   color: Colors.white,
                      //                   fontSize: 32,
                      //                   fontWeight: FontWeight.bold),
                      //               decoration: InputDecoration(
                      //                   border: InputBorder.none,
                      //                   focusedBorder: InputBorder.none,
                      //                   enabledBorder: InputBorder.none,
                      //                   errorBorder: InputBorder.none,
                      //                   disabledBorder: InputBorder.none,
                      //                   hintStyle: TextStyle(
                      //                       color: Colors.white.withOpacity(0.2),
                      //                       fontSize: 32,
                      //                       fontWeight: FontWeight.bold),
                      //                   hintText: "0"),
                      //             ),
                      //           ),
                      //           GestureDetector(
                      //             onTap: () async {
                      //               // _selectedDate = await showDatePickerWidget(context);
                      //               // if (_selectedDate != null) setState(() {});
                      //             },
                      //             child: Padding(
                      //               padding: EdgeInsets.symmetric(vertical: 2),
                      //               child: Text(
                      //                 'Requesting to ${widget.model.name}',
                      //                 style: TextStyle(
                      //                     fontSize: 14,
                      //                     color: Colors.white,
                      //                     fontWeight: FontWeight.w500),
                      //               ),
                      //             ),
                      //           ),Container(margin: EdgeInsets.only(top: 50) ,
                      //             child: Column(
                      //               children: [
                      //                 Text('Requested by Niraj Pvt Ltd',style: TextStyle(color: AppTheme.brownishGrey,fontSize: 17,fontWeight: FontWeight.w500
                      //
                      //                 ),),SizedBox(height: 10,),
                      //                 Text('Niraj | 95648 95978',style: TextStyle(color: AppTheme.brownishGrey,fontSize: 13,fontWeight: FontWeight.w500
                      //
                      //                 ),),
                      //               ],
                      //             ),
                      //           ),
                      //           Container(margin: EdgeInsets.only(top: 30) ,
                      //             child: Column(
                      //               children: [
                      //                 Text('Click on link below to make payment',style: TextStyle(color: AppTheme.brownishGrey,fontSize: 17,fontWeight: FontWeight.w500
                      //
                      //                 ),),
                      //                 Icon(Icons.arrow_drop_down,color: AppTheme.brownishGrey,size: 45,)
                      //               ],
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //   ),
                      // ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomAmountFiller(
                              CtextFilled: TextFormField(
                                controller: currController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"^\d*\.?\d*")),
                                ],
                                autofocus: false,
                                onChanged: (value) {
                                  setState(() {
                                    isAmountFilled = (currController
                                                    .text.isEmpty ||
                                                currController.text.length ==
                                                    0) ||
                                            (int.tryParse(
                                                    currController.text) ==
                                                0)
                                        ? false
                                        : true;
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                    debugPrint(isAmountFilled.toString());
                                    isViaLink = false;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.2),
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold),
                                    hintText: "0"),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                // _selectedDate = await showDatePickerWidget(context);
                                // if (_selectedDate != null) setState(() {});
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  'Requesting to ${widget.model.name}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          (deviceHeight * 0.35).heightBox,
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: IntrinsicWidth(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // InkWell(
                                  //   onTap: () {
                                  //     setState(() {
                                  //       isTapandpay = !isTapandpay;
                                  //       isViaLink = false;
                                  //       FocusScope.of(context).unfocus();
                                  //     });
                                  //   },
                                  //   child: Column(
                                  //     children: [
                                  //       Container(
                                  //         padding: EdgeInsets.all(15),
                                  //         color: isTapandpay
                                  //             ? AppTheme.electricBlue
                                  //             : Colors.white,
                                  //         height: 62,
                                  //         width: 62,
                                  //         child: isTapandpay
                                  //             ? Image.asset(
                                  //                 AppAssets.tapPayIcon,
                                  //                 color: Colors.white,
                                  //                 width: 10,
                                  //                 fit: BoxFit.contain,
                                  //                 height: 10,
                                  //               )
                                  //             : Image.asset(
                                  //                 AppAssets.tapPayIcon,
                                  //                 width: 10,
                                  //                 height: 10,
                                  //                 fit: BoxFit.contain,
                                  //               ),
                                  //       ),
                                  //       SizedBox(
                                  //         height: 5,
                                  //       ),
                                  //       CustomText(
                                  //         'Tap & Pay',
                                  //         color: Color(0xFF666666),
                                  //         centerAlign: true,
                                  //         size: 17,
                                  //         fontFamily: 'SFProDisplay',
                                  //         bold: FontWeight.w400,
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   width: MediaQuery.of(context).size.width * 0.1,
                                  // ),
                                  // InkWell(
                                  //   onTap: () async {
                                  //     debugPrint(isAmountFilled.toString());
                                  //     if (isAmountFilled) {
                                  //       isQRCode = true;
                                  //       isViaLink = false;
                                  //       isULChat = false;
                                  //     //   CustomLoadingDialog.showLoadingDialog(
                                  //     //       context, key);
                                  //     //   Map<String, dynamic> data = {
                                  //     //     "amount": '${currController.text.trim()}',
                                  //     //     "currency": 'AED',
                                  //     //     "note":
                                  //     //         "${_enterDetailsController.text.trim()}",
                                  //     //     "bills": ''
                                  //     //   };
                                  //     //   final Uint8List qrData = await repository
                                  //     //       .paymentThroughQRApi
                                  //     //       .sendQRData(data);
                                  //     //   Navigator.pushNamed(
                                  //     //       context, AppRoutes.qrScreen,
                                  //     //       arguments: qrData);
                                  //     // } else {
                                  //     //   ScaffoldMessenger.of(context)
                                  //     //       .showSnackBar(SnackBar(
                                  //     //     content: Text('Please enter amount.'),
                                  //     //     behavior: SnackBarBehavior.floating,
                                  //     //     margin: EdgeInsets.only(
                                  //     //         bottom: 50,
                                  //     //         left: 15,
                                  //     //         right: 15,
                                  //     //         top: 15),
                                  //     //   ));
                                  //     }
                                  //   },
                                  //   child: Column(
                                  //     children: [
                                  //       Container(
                                  //         padding: EdgeInsets.all(10),
                                  //         decoration: BoxDecoration(
                                  //           borderRadius: BorderRadius.circular(5),
                                  //           color: isQRCode
                                  //             ? AppTheme.electricBlue
                                  //             : Colors.white,
                                  //         ),
                                  //         height: 62,
                                  //         width: 62,
                                  //         child: Image.asset(
                                  //           AppAssets.qrIcon,
                                  //           // color: Colors.white,
                                  //           width: 10,
                                  //           fit: BoxFit.contain,
                                  //           height: 10,
                                  //         ),
                                  //       ),
                                  //       SizedBox(
                                  //         height: 5,
                                  //       ),
                                  //       CustomText(
                                  //         'QR Code',
                                  //         color: Color(0xFF666666),
                                  //         centerAlign: true,
                                  //         size: 17,
                                  //         fontFamily: 'SFProDisplay',
                                  //         bold: FontWeight.w400,
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   width: MediaQuery.of(context).size.width * 0.1,
                                  // ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isQRCode = !isQRCode;
                                        isULChat = false;
                                        isViaLink = false;
                                        FocusScope.of(context).unfocus();
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: isQRCode
                                                ? AppTheme.electricBlue
                                                : Colors.white,
                                          ),
                                          height: 62,
                                          width: 62,
                                          child: isQRCode
                                              ? Image.asset(
                                                  AppAssets.qrIcon,
                                                  color: Colors.white,
                                                  width: 10,
                                                  fit: BoxFit.contain,
                                                  height: 10,
                                                )
                                              : Image.asset(
                                                  AppAssets.qrIcon,
                                                  width: 10,
                                                  fit: BoxFit.contain,
                                                  height: 10,
                                                ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomText(
                                          'QR Code',
                                          color: Color(0xFF666666),
                                          centerAlign: true,
                                          size: 17,
                                          fontFamily: 'SFProDisplay',
                                          bold: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isViaLink = !isViaLink;
                                        isULChat = false;
                                        isQRCode = false;
                                        FocusScope.of(context).unfocus();
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: isViaLink
                                                ? AppTheme.electricBlue
                                                : Colors.white,
                                          ),
                                          height: 62,
                                          width: 62,
                                          child: isViaLink
                                              ? Image.asset(
                                                  AppAssets.viaLinkIcon,
                                                  color: Colors.white,
                                                  width: 10,
                                                  fit: BoxFit.contain,
                                                  height: 10,
                                                )
                                              : Image.asset(
                                                  AppAssets.viaLinkIcon,
                                                  width: 10,
                                                  fit: BoxFit.contain,
                                                  height: 10,
                                                ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomText(
                                          'Via Link',
                                          color: Color(0xFF666666),
                                          centerAlign: true,
                                          size: 17,
                                          fontFamily: 'SFProDisplay',
                                          bold: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (isAmountFilled) {
                                          isULChat = !isULChat;
                                          isViaLink = false;
                                          isQRCode = false;
                                        } else {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //   content:
                                          //       Text('Please enter amount.'),
                                          //   behavior: SnackBarBehavior.floating,
                                          //   margin: EdgeInsets.only(
                                          //       bottom: 50,
                                          //       left: 15,
                                          //       right: 15,
                                          //       top: 15),
                                          // ));
                                          'Please enter amount.'
                                              .showSnackBar(context);
                                        }
                                        FocusScope.of(context).unfocus();
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: isULChat
                                                ? AppTheme.electricBlue
                                                : Colors.white,
                                          ),
                                          height: 62,
                                          width: 62,
                                          child: isULChat
                                              ? Image.asset(
                                                  AppAssets.chatIcon01,
                                                  color: Colors.white,
                                                  // width: 10,
                                                  fit: BoxFit.contain,
                                                  height: 10,
                                                )
                                              : Image.asset(
                                                  AppAssets.chatIcon01,
                                                  // width: 10,
                                                  fit: BoxFit.contain,
                                                  height: 10,
                                                ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomText(
                                          'UL Chat',
                                          color: Color(0xFF666666),
                                          centerAlign: true,
                                          size: 17,
                                          fontFamily: 'SFProDisplay',
                                          bold: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).padding.top +
                                  appBarHeight,
                            ),
                            (deviceHeight * 0.38).heightBox,
                            (isQRCode == true ||
                                        isViaLink == true ||
                                        isULChat == true) &&
                                    isAmountFilled == true
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    // height: 300,
                                    child: Column(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0, vertical: 0),
                                            child: Theme(
                                              data: ThemeData(
                                                  primaryColor: Colors.white),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                child: TextField(
                                                  controller:
                                                      _enterDetailsController,
                                                  maxLines: 4,
                                                  minLines: 4,
                                                  style: TextStyle(
                                                      color: AppTheme
                                                          .brownishGrey),
                                                  textCapitalization:
                                                      TextCapitalization
                                                          .sentences,
                                                  decoration: InputDecoration(
                                                      hintText: 'Enter Details',
                                                      hintStyle: TextStyle(
                                                          color: Color(
                                                              0xff666666)),
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      filled: true,
                                                      fillColor: Colors.white),
                                                ),
                                              ),
                                            )),
                                        (deviceHeight * 0.04).heightBox,
                                        if (_pickedFiles.length < 1)
                                          GestureDetector(
                                            onTap: () async {
                                              pickAttachment();
                                            },
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  child: DottedBorder(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    radius: Radius.circular(10),
                                                    dashPattern: [5, 5, 5, 5],
                                                    borderType:
                                                        BorderType.RRect,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 20),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Image.asset(
                                                                  AppAssets
                                                                      .addFileIcon,
                                                                  height: 30,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8.0),
                                                                  child: Text(
                                                                    'Attach Bills',
                                                                    style: TextStyle().copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (_pickedFiles.length > 0)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Wrap(
                                              alignment: WrapAlignment.center,
                                              runSpacing: 10,
                                              children: [
                                                ...getImageDocWidgets(
                                                    _pickedFiles.where((e) {
                                                  return e.path != null;
                                                }).toList()),
                                                if (_pickedFiles.length < 5)
                                                  GestureDetector(
                                                    onTap: () {
                                                      pickAttachment();
                                                    },
                                                    child: DottedBorder(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      radius:
                                                          Radius.circular(10),
                                                      dashPattern: [5, 5, 5, 5],
                                                      borderType:
                                                          BorderType.RRect,
                                                      child: Container(
                                                        color: Colors.white,
                                                        height: 40,
                                                        width: 60,
                                                        child: Icon(
                                                            Icons.add_a_photo,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 8),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'You can upload JPEG, PNG or PDF with max size 5MB',
                                              style: TextStyle(
                                                  color: AppTheme.greyish,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cButton({
    required BuildContext context,
    String? name,
  }) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.060,
          left: MediaQuery.of(context).size.width * 0.040,
          right: MediaQuery.of(context).size.width * 0.040),
      child: RaisedButton(
        padding: EdgeInsets.all(15),
        color: AppTheme.electricBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {},
        child: Text(
          '$name'.toUpperCase(),
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  pickAttachment() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 130,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 6,
                    width: 42,
                    decoration: BoxDecoration(
                        color: AppTheme.greyish,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          pickFileAndGenerateThumbnail(context, 0);
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Image.asset(
                                AppAssets.documentIcon,
                                height: 40,
                              ),
                              5.0.heightBox,
                              Text(
                                'Document',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.brownishGrey,
                                ),
                              )
                            ]),
                      ),
                      GestureDetector(
                        onTap: () {
                          pickFileAndGenerateThumbnail(context, 1);
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.asset(
                                AppAssets.galleryIcon,
                                height: 40,
                              ),
                              5.0.heightBox,
                              Text(
                                'Gallery',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.brownishGrey,
                                ),
                              )
                            ]),
                      ),
                      GestureDetector(
                        onTap: () {
                          pickFileAndGenerateThumbnail(context, 2);
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Image.asset(
                                AppAssets.cameraIcon01,
                                height: 40,
                              ),
                              5.0.heightBox,
                              Text(
                                'Camera',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.brownishGrey,
                                ),
                              )
                            ]),
                      ),
                    ]),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> pickFileAndGenerateThumbnail(
      BuildContext context, int type) async {
    final _pickedFile = type == 0
        ? await pickFile()
        : type == 1
            ? await pickImage(ImageSource.gallery)
            : await pickImage(ImageSource.camera);
    if (_pickedFile == null) return;
    if (_pickedFiles.length < 5) {
      if ((await File(_pickedFile.path!).length()) < 5242880) {
        _pickedFiles.add(_pickedFile);
        if (_pickedFile.extension == 'pdf') {
          final doc = await PdfDocument.openFile(_pickedFile.path!);
          final page = await doc.getPage(1);
          final pageImage = await page.render(
              height: 40, width: 60, fullHeight: 100, fullWidth: 487
              // width: (screenWidth(context) * 0.90).toInt(),
              );
          await pageImage.createImageIfNotAvailable();
          _pageImages.add(pageImage);
        } else {
          _pageImages.add(null);
        }
        setState(() {});
        Navigator.of(context).pop();
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text('Attached File cannot be greater than 5 MB'),
        // ));
        Navigator.of(context).pop();
        'Attached File cannot be greater than 5 MB'.showSnackBar(context);
      }
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: CustomText('You have already added max attachments'),
      //   ),
      // );
      'You have already added max attachments'.showSnackBar(context);
    }
  }

  List<Widget> getImageDocWidgets(List<PlatformFile> files) {
    List<Widget> widgets = [];
    for (int i = 0; i < files.length; i++) {
      widgets.add(imageDocWidget(files[i].path!, _pageImages[i], i));
    }
    return widgets;
  }

  Widget imageDocWidget(String path, PdfPageImage? pageImage, int index) =>
      Padding(
        padding: EdgeInsets.only(right: 20),
        child: GestureDetector(
          onTap: () async {
            await showDeleteImageDialog(index);
          },
          child: DottedBorder(
            color: AppTheme.electricBlue,
            radius: Radius.circular(10),
            dashPattern: [5, 5, 5, 5],
            borderType: BorderType.RRect,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                path.split('.').last == 'pdf'
                    ? pageImage?.imageIfAvailable == null
                        ? Container()
                        : RawImage(
                            image: pageImage!.imageIfAvailable,
                            fit: BoxFit.contain,
                            // scale: 1,
                          )
                    : path == null
                        ? Container()
                        : Image.file(
                            File(path),
                            height: 40,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                if (path != null)
                  Positioned(
                    right: -15,
                    top: -12,
                    child: Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: AppTheme.tomato,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

  showDeleteImageDialog(int index) async => await showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) => SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: CustomText(
              'Delete this image?',
              centerAlign: true,
            ),
            titlePadding:
                EdgeInsets.only(bottom: 15, top: 28, left: 15, right: 15),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  (screenWidth(context) * 0.07).widthBox,
                  Expanded(
                    child: OutlineButton(
                      padding: EdgeInsets.all(8),
                      borderSide:
                          BorderSide(color: AppTheme.electricBlue, width: 2),
                      color: Colors.white,
                      onPressed: () {
                        _pickedFiles.removeAt(index);
                        _pageImages.removeAt(index);
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: CustomText(
                        'YES',
                        size: 14,
                        color: AppTheme.electricBlue,
                        bold: FontWeight.w500,
                      ),
                    ),
                  ),
                  (screenWidth(context) * 0.01).widthBox,
                  Expanded(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                          EdgeInsets.only(bottom: 8, top: 8, left: 8, right: 8),
                      color: AppTheme.electricBlue,
                      child: CustomText(
                        'NO',
                        size: 14,
                        bold: FontWeight.w500,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  (screenWidth(context) * 0.07).widthBox,
                ],
              ),
            ],
          ));

  Future<PlatformFile?> pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      allowedExtensions: allowedExtensions,
      type: FileType.custom,
    );
    return pickedFile == null ? null : pickedFile.files.first;
  }

  Future<PlatformFile?> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    return pickedFile == null ? null : PlatformFile(path: pickedFile.path);
  }

  List<String> get allowedExtensions => [
        'pdf',
        'doc',
        'docx',
        // 'jpg',
        // 'jpeg',
        // 'png',
      ];

  getLink(type, List<String> path) async {
    // CustomLoadingDialog.showLoadingDialog(context, key);
    int va = 0;
    var cid = await repository.customerApi
        .getCustomerID(mobileNumber: widget.model.mobileNo).catchError((e){
          setState(() {
                                  isPressed = false;
                                });
                                Navigator.of(context).pop();
          'Please check internet connectivity and try again.'
                                    .showSnackBar(context);
        });
    if (await checkConnectivity) {
      for (var image in _pickedFiles) {
        setState(() {
          va += 1;
          debugPrint(va.toString());
        });

        uploadApiResponse =
            await repository.ledgerApi.uploadAttachment(image.path!);
        if (uploadApiResponse.isNotEmpty) {
          debugPrint('id' + uploadApiResponse.toString());
          attachmentIds.add(uploadApiResponse.toString());
        }
      }
    } else {
      Navigator.of(context).pop();
      setState(() {
                                  isPressed = false;
                                });
      'Please check your internet connection or try again later.'
          .showSnackBar(context);
    }
    if (type == 'chat') {
      if (cid.customerInfo?.id == null) {
        Navigator.of(context).pop(true);
        MerchantBankNotAdded.showBankNotAddedDialog(
            context, 'userNotRegistered');
      } else {
        double? amount = double.tryParse(
            currController.text.trim().toString().replaceAll(',', ''));
        final data = {
          "amount":
              '${currController.text.trim().toString().replaceAll(',', '')}',
          "currency": 'AED',
          "note": "${_enterDetailsController.text.trim()}",
          "bills": attachmentIds,
          "from_customer": widget.model.customerId,
          "request_through": "CHAT"
        };
        final String requestId =
            await repository.paymentThroughQRApi.getRequestId(data).catchError((e){
              setState(() {
                                  isPressed = false;
                                });
              Navigator.of(context).pop(true);
              'Please check internet connectivity and try again.'
                                    .showSnackBar(context);
            });

        debugPrint('qwerty' + widget.customerId.toString());

        var anaylticsEvents = AnalyticsEvents(context);
        await anaylticsEvents.initCurrentUser();
        await anaylticsEvents.requestPaymentEvent(jsonEncode(data));

        _requestController.sendMessage(
            _id,
            widget.model.chatId ?? null,
            '${widget.model.name?.trim()}',
            widget.model.mobileNo,
            amount,
            '${_enterDetailsController.text}',
            attachmentIds.length,
            '$requestId',
            5);
        final previousBalance =
            (await repository.queries.getPaidMinusReceived(widget.customerId));
        await BlocProvider.of<LedgerCubit>(context).addLedger(
            TransactionModel()
              ..transactionId = requestId
              ..amount = double.tryParse(
                      currController.text.trim().replaceAll(',', '')) ??
                  0
              ..transactionType = TransactionType.Receive
              ..customerId = widget.customerId
              ..date = DateTime.now()
              ..attachments = _pickedFiles.map((e) => e.path).toList()
              ..details = '${_enterDetailsController.text}'
              ..balanceAmount = previousBalance +
                  (double.tryParse(
                          currController.text.trim().replaceAll(',', '')) ??
                      0)
              ..isChanged = true
              ..isDeleted = false
              ..isPayment = false
              ..isReadOnly = true
              ..business = Provider.of<BusinessProvider>(context, listen: false)
                  .selectedBusiness
                  .businessId
              ..createddate = DateTime.now(),
            () {},
            context);
        ContactController.initChat(context, widget.model.chatId);

        widget.model.customerId = widget.customerId;
        // Navigator.popAndPushNamed(context, AppRoutes.transactionListRoute,
        //       arguments: TransactionListArgs(true, widget.model));
        Navigator.of(context)
          ..pop()
          ..popAndPushNamed(AppRoutes.transactionListRoute,
              arguments: TransactionListArgs(true, widget.model));
      }
    } else {
      debugPrint(cid.toJson().toString());
      print(cid.customerInfo?.id != null
          ? "${(cid.customerInfo?.id.toString())}"
          : "${(cid.id.toString())}");
      Map<String, dynamic> linkInput = {
        "send_to": cid.customerInfo?.id != null
            ? "${(cid.customerInfo?.id.toString())}"
            : "${(cid.id.toString())}",
        "type": "${type.toString().toLowerCase()}",
        "amount": "${currController.text.toString().replaceAll(',', '')}",
        "currency": "AED",
        "message": "${_enterDetailsController.text}",
        "attachments": "$attachmentIds",
        "request_through": "DYNAMICQRCODE"
      };
      debugPrint('linkInput : ' + linkInput.toString());
      GeneratelinkModel? value1;
      await PaymentThroughGeneratedLinkAPI.generateLinkProvider
          .generateLink(paymentDetails: linkInput)
          .then((value) async {
        final previousBalance =
            (await repository.queries.getPaidMinusReceived(widget.customerId));
        await BlocProvider.of<LedgerCubit>(context).addLedger(
            TransactionModel()
              ..transactionId = value.payLink!.split('/').last
              ..amount = double.tryParse(
                      currController.text.trim().replaceAll(',', '')) ??
                  0
              ..transactionType = TransactionType.Receive
              ..customerId = widget.customerId
              ..date = DateTime.now()
              ..attachments = _pickedFiles.map((e) => e.path).toList()
              ..details = '${_enterDetailsController.text}'
              ..balanceAmount = previousBalance +
                  (double.tryParse(
                          currController.text.trim().replaceAll(',', '')) ??
                      0)
              ..isChanged = true
              ..isDeleted = false
              ..isPayment = false
              ..isReadOnly = true
              ..business = Provider.of<BusinessProvider>(context, listen: false)
                  .selectedBusiness
                  .businessId
              ..createddate = DateTime.now(),
            () {},
            context);

        Navigator.of(context).pop();
        setState(() {
          value1 = value;
        });
      });
      final RenderBox box = context.findRenderObject() as RenderBox;
      var anaylticsEvents = AnalyticsEvents(context);
      await anaylticsEvents.initCurrentUser();
      await anaylticsEvents.requestPaymentEvent(jsonEncode(linkInput));

      await Share.shareFiles(path,
          text: value1!.template.toString(),
          // subject: value1!.payLink.toString(),
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }
}
