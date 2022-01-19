/* import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_date_picker.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/extensions.dart';

import '../Components/extensions.dart';

class AttachBillScreen extends StatefulWidget {
  final TransactionModel transactionModel;
  final String customerName;

  const AttachBillScreen(
      {Key key, @required this.transactionModel, @required this.customerName})
      : super(key: key);

  @override
  _AttachBillScreenState createState() => _AttachBillScreenState();
}

class _AttachBillScreenState extends State<AttachBillScreen> {
  final Repository repository = Repository();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController _enterDetailsController;
  TextEditingController _enterAmountController;
  DateTime _selectedDate;
  PlatformFile _pickedFile;
  PdfPageImage pageImage;
  TransactionModel _transactionModel;

  @override
  void initState() {
    super.initState();
    _transactionModel = widget.transactionModel;
    _pickedFile = PlatformFile(
        path: widget.transactionModel.attachment1 != null
            ? widget.transactionModel.attachment1
            : null);
    if (_pickedFile != null) generateThumbnail();
    _enterDetailsController =
        TextEditingController(text: widget.transactionModel.details);
    _enterAmountController = TextEditingController(
        text: removeDecimalif0(widget.transactionModel.amount));
  }

  generateThumbnail() async {
    if (_pickedFile.extension == 'pdf') {
      final doc = await PdfDocument.openFile(_pickedFile.path);
      final page = await doc.getPage(1);
      pageImage = await page.render(
          height: 200, width: 487, fullHeight: 600, fullWidth: 487
          // width: (screenWidth(context) * 0.90).toInt(),
          );
      await pageImage.createImageIfNotAvailable();
      setState(() {});
    }
  }

  @override
  void dispose() {
    pageImage?.dispose();
    _enterDetailsController.dispose();
    _enterAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        title: Text(
            widget.transactionModel.transactionType == TransactionType.Receive
                ? 'Receive from ${widget.customerName}'
                : 'Paid to ${widget.customerName}'),
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: saveButton(),
      body: Stack(children: [
        Image.asset('assets/images/back2.png'),
        Column(children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + appBarHeight,
          ),
          (deviceHeight * 0.02).heightBox,
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Enter the Amount',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                height: 100,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: screenWidth(context) * 0.475,
                        alignment: Alignment.centerRight,
                        child: Text(
                          '$currencyAED',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.white,
                        thickness: 2,
                        indent: 1,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 100,
                        width: screenWidth(context) * 0.480,
                        // color: Colors.black,
                        child: TextField(
                          controller: _enterAmountController,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 50,
                              color: Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.bold),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  _selectedDate = await showDatePickerWidget(context);
                  if (_selectedDate != null) setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _selectedDate != null
                            ? DateFormat('EEE, dd MMM yyyy')
                                .format(_selectedDate)
                            : DateFormat('EEE, dd MMM yyyy')
                                .format(widget.transactionModel.date),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'assets/icons/calendar.png',
                        height: 18,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          (deviceHeight * 0.12).heightBox,
          Flexible(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Theme(
                      data: ThemeData(primaryColor: Colors.white),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: TextField(
                          controller: _enterDetailsController,
                          maxLines: 4,
                          minLines: 4,
                          style: TextStyle(color: AppTheme.brownishGrey),
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              hintText: 'Enter details',
                              hintStyle: TextStyle(color: Color(0xff666666)),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white),
                        ),
                      ),
                    )),
                (deviceHeight * 0.04).heightBox,
                GestureDetector(
                  onTap: () async {
                    _pickedFile = await pickFile();
                    if (_pickedFile != null) {
                      if (_pickedFile.extension == 'pdf') {
                        final doc =
                            await PdfDocument.openFile(_pickedFile.path);
                        final page = await doc.getPage(1);
                        pageImage = await page.render(
                            height: 200,
                            width: 487,
                            fullHeight: 600,
                            fullWidth: 487
                            // width: (screenWidth(context) * 0.90).toInt(),
                            );
                        await pageImage.createImageIfNotAvailable();
                      }
                      _transactionModel..attachment1 = _pickedFile.path;
                      setState(() {});
                    }
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: DottedBorder(
                          color: AppTheme.electricBlue,
                          radius: Radius.circular(4),
                          dashPattern: [5, 5, 5, 5],
                          borderType: BorderType.RRect,
                          child: (_pickedFile != null)
                              ? Center(
                                  // height: deviceHeight * 0.25,
                                  child: AspectRatio(
                                    aspectRatio: 487 / 200,
                                    child: _pickedFile.extension == 'pdf'
                                        ? RawImage(
                                            image: pageImage?.imageIfAvailable,
                                            fit: BoxFit.contain,
                                            // scale: 1,
                                          )
                                        : Image.file(
                                            File(_pickedFile?.path ??
                                                _transactionModel.attachment1),
                                            fit: BoxFit.fitWidth,
                                          ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Image.asset(
                                              'assets/icons/addfile.png',
                                              height: 30,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
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
                      _pickedFile != null
                          ? Positioned(
                              right: 0,
                              top: -20,
                              child: IconButton(
                                icon: Icon(
                                  CupertinoIcons.xmark_circle_fill,
                                  color: AppTheme.tomato,
                                ),
                                onPressed: () {
                                  showGeneralDialog(
                                      context: context,
                                      pageBuilder: (context, _, __) =>
                                          SimpleDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            title: CustomText(
                                              'Delete this image?',
                                              centerAlign: true,
                                            ),
                                            titlePadding: EdgeInsets.only(
                                                bottom: 15,
                                                top: 28,
                                                left: 15,
                                                right: 15),
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  (screenWidth(context) * 0.07)
                                                      .widthBox,
                                                  Expanded(
                                                    child: OutlineButton(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      borderSide: BorderSide(
                                                          color:
                                                              Color(0xff1058ff),
                                                          width: 2),
                                                      color: Colors.white,
                                                      onPressed: () {
                                                        _pickedFile = null;
                                                        _transactionModel
                                                            .attachment1 = null;
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {});
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      child: CustomText(
                                                        'YES',
                                                        size: 14,
                                                        color: AppTheme
                                                            .electricBlue,
                                                        bold: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  (screenWidth(context) * 0.01)
                                                      .widthBox,
                                                  Expanded(
                                                    child: RaisedButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      padding: EdgeInsets.only(
                                                          bottom: 8,
                                                          top: 8,
                                                          left: 8,
                                                          right: 8),
                                                      color:
                                                          AppTheme.electricBlue,
                                                      child: CustomText(
                                                        'NO',
                                                        size: 14,
                                                        bold: FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ),
                                                  (screenWidth(context) * 0.07)
                                                      .widthBox,
                                                ],
                                              ),
                                            ],
                                          ));
                                },
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'You can uplaod JPEG, PNG or PDF with max size 10MB',
                      style: TextStyle(
                          color: AppTheme.greyish,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            ),
          ),
          // saveButton(),
        ])
      ]),
    );
  }

  Widget saveButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () async {
            final fileSize = _pickedFile?.path != null
                ? await File(_pickedFile.path).length()
                : 0;
            if (fileSize < 10485760) {
              final response = await repository.queries.updateLedgerTransaction(
                  _transactionModel
                    ..amount = double.tryParse(_enterAmountController.text) ?? 0
                    ..details = _enterDetailsController.text
                    ..customerId = widget.transactionModel.customerId
                    ..date = _transactionModel.date ?? DateTime.now()
                    ..balanceAmount = (widget.transactionModel.balanceAmount ??
                        await repository.queries.getPaidMinusReceived(
                            widget.transactionModel.customerId))
                    ..isChanged = true);
              if (response != null) {
                BlocProvider.of<LedgerCubit>(context)
                    .getLedgerData(widget.transactionModel.customerId);
                Navigator.of(context).pop();
              }
            } else {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Attached File cannot be greater than 10 MB'),
              ));
            }
          },
          color: AppTheme.electricBlue,
          child: Text(
            'SAVE',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          )),
    );
  }

  Future<DateTime> showDatePickerWidget(BuildContext context) async {
    return await showCustomDatePicker(
      context,
      firstDate: DateTime(2000),
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
    );
  }

  Future<PlatformFile> pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      allowedExtensions: allowedExtensions,
      type: FileType.custom,
    );
    return pickedFile == null ? null : pickedFile.files.first;
  }

  List<String> get allowedExtensions => [
        'pdf',
        'doc',
        'docx',
        'jpg',
        'jpeg',
        'png',
      ];
}
 */
