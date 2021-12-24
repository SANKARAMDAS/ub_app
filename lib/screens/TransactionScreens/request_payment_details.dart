import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/l10n/messages_de.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/chat_module/data/models/message.dart';
import 'package:urbanledger/chat_module/data/models/user.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_profile_image.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/TransactionScreens/pay_transaction.dart';

class RequestPaymentDetails extends StatefulWidget {
  final String customerId;
  final String? firstName;
  final String? lastName;
  final String? mobileNo;
  final String? amount;
  final String? currency;
  final String? note;
  final String? requestId;
  final List<String> bills;
  final Message message;
  final User? user;
  final Function() declinePayment;

  RequestPaymentDetails(
      {Key? key,
      required this.customerId,
      this.firstName,
      this.lastName,
      this.mobileNo,
      this.amount,
      this.currency,
      this.note = '',
      this.requestId,
      required this.bills,
      required this.message,
      this.user,
      required this.declinePayment})
      : super(key: key);

  @override
  _RequestPaymentDetailsState createState() => _RequestPaymentDetailsState();
}

class _RequestPaymentDetailsState extends State<RequestPaymentDetails> {
  TextEditingController _enterDetailsController = TextEditingController();
  List<PdfPageImage?> _pageImages = [];
  List<PlatformFile> _pickedFiles = [];
  String? attachment;
  List<String> stringList = [];
  bool cancelled = false;
  CustomerModel _customerModel = CustomerModel();
  final format = new DateFormat("dd MMM yy - HH:mm a");
  @override
  void initState() {
    data();
    super.initState();
  }

  data() async {
    for (var item in widget.bills) {
      stringList.add(await repository.ledgerApi.networkImageToFile(item));
    }
    _pickedFiles = stringList.map((e) {
      return PlatformFile(path: e);
    }).toList();
    generateThumbnails(_pickedFiles);
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

  String messageDate(int milliseconds) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return format.format(date);
  }

  @override
  void dispose() {
    _pageImages.forEach((e) => e?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _enterDetailsController.text = widget.note ?? '';
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.0),
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
        title: Text('Request Details'),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // if(widget.message.from != widget.user?.id)
            (screenWidth(context) * 0.035).widthBox,
            if (widget.message.from != widget.user?.id &&
                widget.message.paymentCancel!)
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(15),
                    onPrimary: AppTheme.electricBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    _customerModel
                      ..customerId = widget.customerId
                      ..name = '${widget.firstName} ${widget.lastName}'
                      ..mobileNo = widget.mobileNo;
                    Map<String, dynamic> isTransaction = await repository
                        .paymentThroughQRApi
                        .getTransactionLimit(context);
                    if (!(isTransaction)['isError']) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PayTransactionScreen(
                              model: _customerModel,
                              customerId: widget.customerId,
                              amount: widget.amount
                                  .toString()
                                  .replaceAll(RegExp(r"([.]*0)(?!.*\d)"), ""),
                              requestId: widget.requestId,
                              type: 'DIRECT',
                              suspense: false,
                              through: 'DIRECT'),
                        ),
                      );
                    } else {
                      Navigator.of(context).pop(true);
                      '${(isTransaction)['message']}'.showSnackBar(context);
                    }
                  },
                  child: CustomText(
                    'PAY',
                    size: (18),
                    color: Colors.white,
                    bold: FontWeight.w500,
                  ),
                ),
              ),
            if (widget.message.from != widget.user?.id &&
                widget.message.paymentCancel!)
              (screenWidth(context) * 0.07).widthBox,
            Expanded(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    EdgeInsets.only(bottom: 15, top: 15, left: 30, right: 30),
                color: Theme.of(context).primaryColor,
                child: CustomText(
                  widget.message.from != widget.user?.id &&
                          widget.message.paymentCancel == true
                      ? 'DECLINE'
                      : widget.message.from == widget.user?.id &&
                              widget.message.paymentCancel == true
                          ? 'CANCEL'
                          : (widget.message.from == widget.user?.id &&
                                  widget.message.paymentCancel == false)
                              ? 'CANCELLED'
                              : 'DECLINED',
                  size: (18),
                  bold: FontWeight.w500,
                  color: Colors.white,
                ),
                onPressed: !widget.message.paymentCancel!
                    ? null
                    : cancelled == true
                        ? () {}
                        : () async {
                            setState(() {
                              widget.message.paymentCancel = false;
                            });
                            widget.declinePayment();
                          },
              ),
            ),
            (screenWidth(context) * 0.035).widthBox,
          ],
        ),
      ),
      body: Stack(
        children: [
          Image.asset('assets/images/back.png'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.only(
                                    top: 8, bottom: 8, left: 20, right: 20),
                                leading: Container(
                                  padding: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(99),
                                    color: Colors.white,
                                  ),
                                  child: CustomProfileImage(
                                    // avatar: widget.customerModel!.avatar,
                                    mobileNo: '+${widget.mobileNo}',
                                    name:
                                        '${widget.firstName ?? 'USER'} ${widget.lastName ?? ''}',
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Flexible(
                                      // child: Container(
                                      child: Text(
                                        '${widget.firstName ?? 'USER'} ${widget.lastName ?? ''}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Color(0xff1058ff),
                                          fontSize: 23,
                                          fontWeight: FontWeight.w500,
                                        ),

                                        // ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  ],
                                ),
                                // subtitle: CustomText(
                                //   DateFormat('dd MMM yyyy - hh:mm aa')
                                //       .format(widget.transactionModel.date!),
                                //   color: Color(0xff666666),
                                //   size: 14,
                                // ),
                                subtitle: CustomText(
                                  // '10 June 2021 - 07:50 PM',
                                  messageDate(widget.message.sendAt!),
                                  color: Color(0xff666666),
                                  size: 14,
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      'Requested',
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
                                            color: AppTheme.tomato,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                            TextSpan(
                                                text: '${widget.amount}',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ]),
                                    )
                                  ],
                                ),
                              ),
                              if (widget.message.attachmentCount != 0)
                                Divider(
                                  thickness: 1,
                                ),
                              // if (widget.transactionModel.attachments.length >
                              //     0)
                              if (widget.message.attachmentCount != 0)
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
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              if (_enterDetailsController.text.isNotEmpty)
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 20),
                    child: Theme(
                      data: ThemeData(primaryColor: Colors.white),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: TextField(
                          readOnly: true,
                          controller: _enterDetailsController,
                          maxLines: 4,
                          minLines: 4,
                          style: TextStyle(color: AppTheme.brownishGrey),
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              hintText: 'Enter Details',
                              hintStyle: TextStyle(color: Color(0xff666666)),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white),
                        ),
                      ),
                    )),
            ]),
          )
        ],
      ),
    );
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
      builder: (context) => Dialog(
            insetPadding:
                EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.77),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                  'Delete entry will change your balance ',
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: RaisedButton(
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: AppTheme.electricBlue,
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: RaisedButton(
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: AppTheme.electricBlue,
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
                )
              ],
            ),
          ),
      barrierDismissible: false,
      context: context);
}
