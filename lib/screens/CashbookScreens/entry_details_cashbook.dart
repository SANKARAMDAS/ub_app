import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Cashbook/cashbook_cubit.dart';
import 'package:urbanledger/Models/cashbook_entry_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';

class CashbookEntryDetails extends StatefulWidget {
  final CashbookEntryModel cashbookEntryModel;
  final DateTime selectedDate;

  const CashbookEntryDetails(
      {Key? key, required this.cashbookEntryModel, required this.selectedDate})
      : super(key: key);

  @override
  _CashbookEntryDetailsState createState() => _CashbookEntryDetailsState();
}

class _CashbookEntryDetailsState extends State<CashbookEntryDetails> {
  final repository = Repository();
  List<PdfPageImage?> _pageImages = [];
  List<PlatformFile> _pickedFiles = [];

  @override
  void initState() {
    super.initState();
    _pickedFiles = widget.cashbookEntryModel.attachments.map((e) {
      return PlatformFile(path: e != null ? e : null);
    }).toList();
    generateThumbnails(_pickedFiles);
  }

  @override
  void dispose() {
    _pageImages.forEach((e) => e?.dispose());
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      appBar: AppBar(
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 40,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            (screenWidth(context) * 0.035).widthBox,
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(
                  CupertinoIcons.delete,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  primary: AppTheme.tomato,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  final status = await showDeleteConfirmationDialog();
                  if (status ?? false) {
                    final response = await repository.queries
                        .updateCashbookEntryIsDeleted(
                            widget.cashbookEntryModel, 1);
                    if (response != null) {
                      /* if (await checkConnectivity) {
                        final apiResponse = await (repository.cashbookApi
                            .deleteCashbookEntry(
                                widget.cashbookEntryModel.entryId)
                            .catchError((e) {
                          debugPrint(e);
                          return false;
                        }));
                        if (apiResponse) {
                          'Entry deleted successfully'.showSnackBar(context);
                          await repository.queries
                              .deleteCashbookEntry(widget.cashbookEntryModel);
                        }
                      } */
                      BlocProvider.of<CashbookCubit>(context).getCashbookData(
                          DateTime.now(),
                          Provider.of<BusinessProvider>(context, listen: false)
                              .selectedBusiness
                              .businessId);
                      Navigator.of(context).pop();
                    }
                  }
                },
                label: CustomText(
                  'DELETE',
                  size: (18),
                  color: Colors.white,
                  bold: FontWeight.w500,
                ),
              ),
            ),
            (screenWidth(context) * 0.035).widthBox,
          ],
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
                      ListTile(
                        leading: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99),
                              color: Colors.white,
                            ),
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  widget.cashbookEntryModel.entryType ==
                                          EntryType.IN
                                      ? AppTheme.greenColor
                                      : AppTheme.tomato,
                              child: Image.asset(
                                widget.cashbookEntryModel.entryType ==
                                        EntryType.IN
                                    ? AppAssets.inIcon
                                    : AppAssets.outIcon,
                                height: 20,
                              ),
                            )),
                        title: Row(
                          children: [
                            CustomText(
                              widget.cashbookEntryModel.entryType ==
                                      EntryType.IN
                                  ? 'IN'
                                  : 'OUT',
                              color: AppTheme.electricBlue,
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
                              .format(widget.cashbookEntryModel.createdDate),
                          color: Color(0xff666666),
                          size: 14,
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text: '$currencyAED ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        widget.cashbookEntryModel.entryType ==
                                                EntryType.OUT
                                            ? AppTheme.tomato
                                            : AppTheme.greenColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                        text:
                                            '${removeDecimalif0(widget.cashbookEntryModel.amount)}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      if (widget.cashbookEntryModel.attachments.length > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      if (widget.cashbookEntryModel.attachments.length > 0)
                        Divider(
                          color: Color(0xffe5e5e5),
                          thickness: 1.5,
                        ),
                      if (widget.cashbookEntryModel.details!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Details',
                                style: TextStyle(
                                    color: Color(0xff666666),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: CustomText(
                                  widget.cashbookEntryModel.details ?? '',
                                  color: AppTheme.brownishGrey,
                                  bold: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ),
                      if (widget.cashbookEntryModel.details!.isNotEmpty)
                        Divider(
                          thickness: 1,
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                AppRoutes.addEntryRoute,
                                arguments: AddEntryScreenRouteArgs(
                                    widget.cashbookEntryModel,
                                    widget.cashbookEntryModel.entryType,
                                    widget.selectedDate));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppAssets.penIcon,
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
              FutureBuilder<bool>(
                  future: checkConnectivity,
                  builder: (context, snapshot) {
                    return BackupIndicatorWidget(
                      isConnected: snapshot.data ?? false,
                    );
                  })
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
          color: AppTheme.electricBlue,
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
                insetPadding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
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
                      'The changes made will affect the Current Balance',
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
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
              35.0.heightBox
            ],
          ),
      barrierDismissible: false,
      context: context);
}
