import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
// import 'package:whatsapp_share/whatsapp_share.dart';

class EnterDetails extends StatefulWidget {
  final CustomerModel? customerModel;
  final TransactionModel transactionModel;
  final Function(double? amount, String? details, int? paymentType)?
      sendMessage;

  const EnterDetails({
    Key? key,
    required this.customerModel,
    required this.transactionModel,
    required this.sendMessage,
  }) : super(key: key);
  @override
  _EnterDetailsState createState() => _EnterDetailsState();
}

class _EnterDetailsState extends State<EnterDetails> {
  final repository = Repository();
  List<PdfPageImage?> _pageImages = [];
  List<PlatformFile> _pickedFiles = [];
  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pickedFiles = widget.transactionModel.attachments.map((e) {
      return PlatformFile(path: e != null ? e : null);
    }).toList();
    generateThumbnails(_pickedFiles);
  }

  @override
  void dispose() {
    _pageImages.forEach((e) => e?.dispose());
    super.dispose();
  }

  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary? boundary = _globalKey.currentContext!
        .findAncestorRenderObjectOfType<RenderRepaintBoundary>();
    ui.Image image = await boundary!.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    // var bs64 = base64Encode(pngBytes);
    return pngBytes;
  }

  Future<void> generateThumbnails(List<PlatformFile> files) async {
    for (var file in files) {
      if (file.path!.split('.').last == 'pdf') {
        final doc = await PdfDocument.openFile(file.path!);
        final page = await doc.getPage(1);
        final pageImage = await page.render(
            height: 30, width: 50, fullHeight: 200, fullWidth: 200
            // width: (screenWidth(context) * 0.90).toInt(),
            );
        await pageImage.createImageIfNotAvailable();
        _pageImages.add(pageImage);
      } else {
        _pageImages.add(null);
      }
    }
    setState(() {});
  }

  whatsappShare(String phone, String filePath) async {
    print(phone);
    // await WhatsappShare.shareFile(
    //   package: Package.whatsapp,
    //   text: '',
    //   phone: phone,
    //   filePath: [filePath],
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      appBar: AppBar(
        leadingWidth: 30,
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
        title: Text('Entry Details'),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              (screenWidth(context) * 0.035).widthBox,
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(15),
                    onPrimary: AppTheme.electricBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    final status = await showDeleteConfirmationDialog();
                    if (status ?? false) {
                      final response = await repository.queries
                          .updateLedgerIsDeleted(widget.transactionModel, 1);
                      if (response != null) {
                        deleteLedger();
                        BlocProvider.of<LedgerCubit>(context)
                            .getLedgerData(widget.transactionModel.customerId!);
                        final amt = await repository.queries.getPaidMinusReceived(
                            widget.transactionModel.customerId!);
                        await repository.queries.updateCustomerDetails(
                            amt,
                            amt == 0.0
                                ? null
                                : amt.isNegative
                                    ? TransactionType.Pay
                                    : TransactionType.Receive,
                            widget.transactionModel.customerId);
                        BlocProvider.of<ContactsCubit>(context).getContacts(
                            Provider.of<BusinessProvider>(context, listen: false)
                                .selectedBusiness
                                .businessId);
                        'Entry deleted successfully'.showSnackBar(context);
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: CustomText(
                    'DELETE',
                    size: (18),
                    color: Colors.white,
                    bold: FontWeight.w500,
                  ),
                ),
              ),
              (screenWidth(context) * 0.07).widthBox,
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding:
                        EdgeInsets.only(bottom: 15, top: 15, left: 30, right: 30),
                    primary: AppTheme.electricBlue,
                  ),
                  child: CustomText(
                    'SHARE',
                    size: (18),
                    bold: FontWeight.w500,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    Directory? directory;
                    if (Platform.isAndroid) {
                      directory = await getExternalStorageDirectory();
                    } else {
                      directory = await getApplicationDocumentsDirectory();
                    }
                    File file = File(directory!.path + '/image1.png');
                    file.writeAsBytesSync(await _capturePng());
                    // Share.shareFiles([file.path]);
                    // final val = await WhatsappShare.isInstalled(
                    //     package: Package.whatsapp);
                    // if (val) {
                    //   await whatsappShare(
                    //       widget.customerModel!.mobileNo!, file.path);
                    // }
                  },
                ),
              ),
              (screenWidth(context) * 0.035).widthBox,
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.asset('assets/images/back3.png'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RepaintBoundary(
                        key: _globalKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(8),
                                leading: Container(
                                  padding: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(99),
                                    color: Colors.white,
                                  ),
                                  child: CustomProfileImage(
                                    avatar: widget.customerModel!.avatar,
                                    mobileNo: widget.customerModel!.mobileNo,
                                    name: widget.customerModel!.name,
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    CustomText(
                                      '${widget.customerModel!.name}',
                                      color: Color(0xff1058ff),
                                      size: 23,
                                      bold: FontWeight.w500,
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  ],
                                ),
                                subtitle: CustomText(
                                  DateFormat('dd MMM yyyy - hh:mm aa')
                                      .format(widget.transactionModel.date!),
                                  color: Color(0xff666666),
                                  size: 14,
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      widget.transactionModel.transactionType ==
                                              TransactionType.Pay
                                          ? 'You Gave'
                                          : 'You Got',
                                      color: AppTheme.brownishGrey,
                                      bold: FontWeight.w400,
                                      size: 16,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                          text: '$currencyAED ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: widget.transactionModel
                                                        .transactionType ==
                                                    TransactionType.Pay
                                                ? AppTheme.tomato
                                                : Color(0xff2ed06d),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                            TextSpan(
                                                text:
                                                    '${removeDecimalif0(widget.transactionModel.amount)}',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ]),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              if (widget.transactionModel.attachments.length >
                                  0)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Attachments',
                                        style: TextStyle(
                                            color: Color(0xff666666),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Container(
                                        width: screenWidth(context) * 0.45,
                                        alignment: Alignment.centerRight,
                                        child: Wrap(
                                          children: [
                                            ...getImageDocWidgets(_pickedFiles)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (widget.transactionModel.attachments.length >
                                  0)
                                Divider(
                                  color: Color(0xffe5e5e5),
                                  thickness: 1.5,
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 11, vertical: 18),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Running Balance',
                                      style: TextStyle(
                                          color: Color(0xff666666),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    FutureBuilder<double>(
                                        future: BlocProvider.of<LedgerCubit>(
                                                context)
                                            .getBalanceOnDate(
                                                widget.transactionModel.date!),
                                        builder: (context, snapshot) {
                                          return RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                                text: '$currencyAED ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xff2ed06d),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: [
                                                  TextSpan(
                                                      text: snapshot.data ==
                                                              null
                                                          ? '0'
                                                          : snapshot.data!
                                                                  .isNegative
                                                              ? (snapshot.data)!
                                                                  .getFormattedCurrency
                                                                  .substring(1)
                                                              : (snapshot.data)!
                                                                  .getFormattedCurrency,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ]),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                              if (widget.transactionModel.details.isNotEmpty)
                                Divider(
                                  thickness: 1,
                                ),
                              if (widget.transactionModel.details.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Details',
                                        style: TextStyle(
                                            color: Color(0xff666666),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: CustomText(
                                          widget.transactionModel.details,
                                          color: AppTheme.brownishGrey,
                                          bold: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              Divider(
                                thickness: 1,
                                height: 1,
                              ),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: InkWell(
                          onTap: () {
                            if (widget.transactionModel.isReadOnly) {
                              "This Entry Cannot be Edited"
                                  .showSnackBar(context);
                              return;
                            }
                            Navigator.pushNamed(
                              context,
                              AppRoutes.calculatorRoute,
                              arguments: CalculatorRouteArgs(
                                toTheCustomer:
                                    widget.transactionModel.transactionType ==
                                            TransactionType.Pay
                                        ? true
                                        : false,
                                paymentType:
                                    widget.transactionModel.transactionType ==
                                            TransactionType.Pay
                                        ? 11
                                        : 12,
                                customerModel: widget.customerModel,
                                sendMessage: widget.sendMessage,
                                transactionModel: widget.transactionModel,
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/pen.png',
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Edit Entry',
                                  style: TextStyle(
                                      color: Color(0xff666666),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            AppAssets.messageIcon,
                            height: 35,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'SMS disabled',
                            style: TextStyle(
                                color: Color(0xff666666),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'You gave $currencyAED 10,465 to Cleanex Plastics (9664774391). You will give $currencyAED 9,000 in total.\n\nSee txn history: http://urbanledger.app/a2/yv0MXMF5IYA97g.',
                        style:
                            TextStyle(color: Color(0xff666666), fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              BackupIndicatorWidget(
                isConnected: !widget.transactionModel.isChanged!,
              )
            ]),
          )
        ],
      ),
    );
  }

  Future<void> deleteLedger() async {
    if (await checkConnectivity) {
      final previousBalance = (await repository.queries
          .getPaidMinusReceived(widget.customerModel!.customerId!));
      final apiResponse = await (repository.ledgerApi
          .deleteLedger(
        widget.transactionModel.transactionId!,
        removeDecimalif0(previousBalance),
      )
          .catchError((e) {
        debugPrint(e);
        return false;
      }));
      if (apiResponse) {
        await repository.queries
            .deleteLedgerTransaction(widget.transactionModel);
      }
    } else {
                          'Please check your internet connection or try again later.'
                              .showSnackBar(context);
                        }
  }

  List<Widget> getImageDocWidgets(List<PlatformFile> files) {
    List<Widget> widgets = [];
    if (files.length == _pageImages.length)
      for (int i = 0; i < files.length; i++) {
        widgets.add(imageDocWidget(files[i].path, _pageImages[i]));
      }
    return widgets;
  }

  Widget imageDocWidget(
    String? path,
    PdfPageImage? pageImage,
  ) =>
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: DottedBorder(
          color: Theme.of(context).primaryColor,
          radius: Radius.circular(4),
          dashPattern: [5, 5, 5, 5],
          borderType: BorderType.RRect,
          child: path != null
              ? path.split('.').last == 'pdf'
                  ? GestureDetector(
                      onTap: () async {
                        await OpenFile.open(path);
                      },
                      child: RawImage(
                        image: pageImage?.imageIfAvailable,
                        fit: BoxFit.fill,
                        // scale: 1,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            AppRoutes.photoViewRoute,
                            arguments: path);
                      },
                      child: Image.file(
                        File(path),
                        fit: BoxFit.fitWidth,
                        width: 50,
                        height: 30,
                      ),
                    )
              : Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              'assets/icons/addfile.png',
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Attach Bills',
                                style: TextStyle().copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      );

  Future<bool?> showDeleteConfirmationDialog() async => await showDialog(
      builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Dialog(
                insetPadding: EdgeInsets.only(left: 20, right: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 5),
                      child: CustomText(
                        'Are you sure you want to delete this entry?',
                        color: AppTheme.tomato,
                        bold: FontWeight.w500,
                        size: 18,
                      ),
                    ),
                    CustomText(
                      'Deleting the entry will change your balance ',
                      size: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: AppTheme.electricBlue,
                                ),
                                child: CustomText(
                                  'CANCEL',
                                  color: Colors.white,
                                  size: (18),
                                  bold: FontWeight.w500,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: AppTheme.electricBlue,
                                ),
                                child: CustomText(
                                  'CONFIRM',
                                  color: Colors.white,
                                  size: (18),
                                  bold: FontWeight.w500,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              20.0.heightBox,
            ],
          ),
      barrierDismissible: false,
      context: context);
}
