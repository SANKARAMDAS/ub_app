import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/global_report.dart';

class GlobalPdfGenerator {
  final DateTime startDate;
  final DateTime endDate;
  final int selectedFilter;
  final List<GlobalReportModel> businesses;
  final pdf = pw.Document();

  var hindiRegex;
  var arabicRegex;
   var ttfEnglish;
   var ttfHindi;
  var ttfArabic;

  GlobalPdfGenerator(
      {required this.startDate,
      required this.endDate,
      required this.businesses,
      required this.selectedFilter}){
    generateArabicRegex();
    generateHindiRegex();

  }

  Future<void> writeOnPdf() async {
    final headerImage = pw.MemoryImage(
      (await rootBundle.load(AppAssets.headerImage)).buffer.asUint8List(),
    );

    final footerImage = pw.MemoryImage(
      (await rootBundle.load(AppAssets.footerImage)).buffer.asUint8List(),
    );

    final pdfBackgroundImage = pw.MemoryImage(
      (await rootBundle.load(AppAssets.pdfBackgroundImage))
          .buffer
          .asUint8List(),
    );

    final Uint8List fontDataEnglish =
        (await rootBundle.load('assets/fonts/Quivira.otf'))
            .buffer
            .asUint8List();

    final Uint8List fontDataHindi =
    (await rootBundle.load('assets/fonts/Hind-Regular.ttf'))
        .buffer
        .asUint8List();

    final Uint8List fontDataArabic =
    (await rootBundle.load('assets/fonts/IBMPlexSansArabic-Regular.ttf'))
        .buffer
        .asUint8List();






     ttfEnglish = pw.Font.ttf(fontDataEnglish.buffer.asByteData());
     ttfHindi = pw.Font.ttf(fontDataHindi.buffer.asByteData());
     ttfArabic = pw.Font.ttf(fontDataArabic.buffer.asByteData());



    pdf.addPage(pw.MultiPage(
        // margin: pw.EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        footer: (context) => _buildFooter(context, footerImage),
        header: (context) => _buildHeader(context, headerImage),
        pageTheme: _buildTheme(PdfPageFormat.a4, pdfBackgroundImage, ttfEnglish),
        build: (context) {
          return [
            pw.SizedBox(height: 30),
            _buildLedgerSubHead(context),
            ...generateTablesData(context),
            pw.SizedBox(height: 20),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 30),
              child: pw.Text(
                  'Report Generated: ' +
                      DateFormat("hh:mm aa | dd MMM yy").format(DateTime.now()),
                  style: pw.TextStyle(fontSize: 14, color: PdfColors.grey)),
            ),
            pw.SizedBox(height: 20),
          ];
        }));
  }

  pw.Widget _buildHeader(pw.Context context, pw.MemoryImage headerImage) {
    return pw.Image(headerImage);
  }

  pw.Widget _buildFooter(pw.Context context, pw.MemoryImage footerImage) {
    return pw.Column(children: [
      pw.Padding(
          padding: pw.EdgeInsets.only(right: 30, top: 10, bottom: 10),
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
                'Page ' +
                    context.pageNumber.toString() +
                    'of ' +
                    context.pagesCount.toString(),
                style: pw.TextStyle(
                  fontSize: 14,
                )),
          )),
      pw.Image(footerImage)
    ]);
  }

  pw.PageTheme _buildTheme(PdfPageFormat pageFormat,
      pw.MemoryImage pdfBackgroundImage, pw.Font ttf) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData(
          defaultTextStyle: pw.TextStyle(font: ttf, fontBold: ttf),
          overflow: pw.TextOverflow.clip),
      margin: pw.EdgeInsets.zero,
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Image(pdfBackgroundImage),
      ),
    );
  }

  pw.Widget _buildLedgerSubHead(pw.Context context) {
    return pw.Padding(
        padding: pw.EdgeInsets.symmetric(horizontal: 30),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Individual Report',
                  style: pw.TextStyle(
                    color: PdfColor.fromHex('#1058ff'),
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  )),
              pw.Text(
                  selectedFilter == 3
                      ? '(As of Today - ${DateFormat('dd MMM yyyy').format(DateTime.now())})'
                      : '(${DateFormat('dd MMM yyy').format(startDate)} - ${DateFormat('dd MMM yyy').format(endDate)})',
                  style: pw.TextStyle(
                    fontSize: 14,
                  )),
            ]));
  }

  List<pw.Widget> generateTablesData(pw.Context context) {
    List<pw.Widget> widgets = [];
    for (var business in businesses) {
      widgets.addAll(getTable(context, business));
    }
    return widgets;
  }

  getTable(pw.Context context, GlobalReportModel reportModel) {
    return [
      _buildLedgerSummary(context, reportModel),
      _tableHeaders(reportModel),
      ...generateTableRow(reportModel),
      _tableFooter(context, reportModel),
    ];
  }

  pw.Widget _buildLedgerSummary(
      pw.Context context, GlobalReportModel reportModel) {
    var selectedFont =  ttfEnglish;
    switch(checkStringLanguage(reportModel.businessname)){
      case LANGUANGE_TYPE.HINDI:{
        selectedFont = ttfHindi;

      }break;
      case LANGUANGE_TYPE.ARABIC:{
        selectedFont = ttfArabic;
      }break;
      case LANGUANGE_TYPE.ENGLISH:{
        selectedFont = ttfEnglish;

      }break;
      default:{
        selectedFont = ttfEnglish;
      }break;


    }
  
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 0),
      child: pw.Container(
        height: 60,
        alignment: pw.Alignment.center,
        decoration: pw.BoxDecoration(
            color: PdfColors.white,
            border: pw.Border.all(color: PdfColors.grey700),
            borderRadius: pw.BorderRadius.circular(10)),
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Ledger',
                        style: pw.TextStyle(
                            fontSize: 14, color: PdfColors.grey700)),
                    pw.SizedBox(height: 5),
                    pw.Text('${reportModel.businessname}',
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold,font:selectedFont)),
                  ]),
              pw.VerticalDivider(
                indent: 20,
                endIndent: 20,
                color: PdfColor.fromHex('#1058ff'),
              ),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('You will Give',
                        style: pw.TextStyle(
                            fontSize: 14, color: PdfColors.grey700)),
                    pw.SizedBox(height: 5),
                    pw.Text(
                        '$currencyAED ${fixTo2(reportModel.receive).replaceAll('-', '')}',
                        style: pw.TextStyle(
                            color: PdfColors.red,
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold)),
                  ]),
              pw.VerticalDivider(
                indent: 20,
                endIndent: 20,
                color: PdfColor.fromHex('#1058ff'),
              ),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('You will Get',
                        style: pw.TextStyle(
                          color: PdfColors.grey700,
                          fontSize: 14,
                        )),
                    pw.SizedBox(height: 5),
                    pw.Text(
                        '$currencyAED ${fixTo2(reportModel.pay).replaceAll('-', '')}',
                        style: pw.TextStyle(
                            color: PdfColors.green,
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold)),
                  ])
            ]),
      ),
    );
  }

  pw.Widget _tableHeaders(GlobalReportModel reportModel) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: 30, right: 30, top: 0),
      child: pw.Expanded(
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 35,
                  width: 60,
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      'Customers (${reportModel.customerCount})',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey700,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                )),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 35,
                  width: 60,
                )),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 35,
                  width: 60,
                  alignment: pw.Alignment.centerRight,
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      'You\'ll Get',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey700,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                )),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 35,
                  width: 60,
                  alignment: pw.Alignment.centerRight,
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      'You\'ll Give',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey700,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  List<pw.Widget> generateTableRow(GlobalReportModel reportModel) {
    List<pw.Widget> widgets = [];

    for (var i = 0; i < reportModel.globalCustomers.length; i++) {
      widgets.add(getTableRow(reportModel.globalCustomers[i],
          i == reportModel.globalCustomers.length - 1, i == 0));
    }

    return widgets;
  }

  pw.Widget getTableRow(
      GlobalCustomerModel customer, bool isLastRow, bool isFirstRow) {
    var customerNameFont =  ttfEnglish;
    switch(checkStringLanguage(customer.name)){
      case LANGUANGE_TYPE.HINDI:{
        customerNameFont = ttfHindi;

      }break;
      case LANGUANGE_TYPE.ARABIC:{
        customerNameFont = ttfArabic;
      }break;
      case LANGUANGE_TYPE.ENGLISH:{
        customerNameFont = ttfEnglish;

      }break;
      default:{
        customerNameFont = ttfEnglish;
      }break;


    }
    var customerPhoneFont =  ttfEnglish;
    switch(checkStringLanguage(customer.name)){
      case LANGUANGE_TYPE.HINDI:{
        customerPhoneFont = ttfHindi;

      }break;
      case LANGUANGE_TYPE.ARABIC:{
        customerPhoneFont = ttfArabic;
      }break;
      case LANGUANGE_TYPE.ENGLISH:{
        customerPhoneFont = ttfEnglish;

      }break;
      default:{
        customerPhoneFont = ttfEnglish;
      }break;


    }
    return pw.Flexible(
        child: pw.Padding(
      padding: pw.EdgeInsets.only(left: 30, right: 30),
      child: pw.DecoratedBox(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey700),
            color: PdfColors.white,
            borderRadius: isFirstRow && isLastRow
                ? pw.BorderRadius.only(
                    topLeft: pw.Radius.circular(10),
                    bottomLeft: pw.Radius.circular(10),
                    topRight: pw.Radius.circular(10),
                    bottomRight: pw.Radius.circular(10),
                  )
                : isFirstRow
                    ? pw.BorderRadius.only(
                        topLeft: pw.Radius.circular(10),
                        topRight: pw.Radius.circular(10),
                      )
                    : isLastRow
                        ? pw.BorderRadius.only(
                            bottomLeft: pw.Radius.circular(10),
                            bottomRight: pw.Radius.circular(10),
                          )
                        : pw.BorderRadius.all(pw.Radius.circular(0)),
          ),
          child: pw.Container(
              constraints: pw.BoxConstraints(maxHeight: 60),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Expanded(
                      child: pw.Container(
                    // height: 35,
                    alignment: pw.Alignment.centerLeft,
                    // decoration: pw.BoxDecoration(
                    //   color: PdfColors.white,
                    // ),
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                        customer.name,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          font:customerNameFont
                        ),
                      ),
                    ),
                  )),
                  pw.VerticalDivider(
                    color: PdfColors.grey700,
                  ),
                  // pw.VerticalDivider(color: PdfColors.grey700),
                  pw.Expanded(
                      child: pw.Container(
                    // height: 35,
                    width: 60,
                    alignment: pw.Alignment.center,
                    // decoration: pw.BoxDecoration(
                    //   // border: pw.Border.all(color: PdfColors.grey700),
                    //   color: PdfColors.white,
                    // ),
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                        customer.mobile,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          font: customerPhoneFont
                        ),
                      ),
                    ),
                  )),
                  pw.VerticalDivider(
                    color: PdfColors.grey700,
                  ),
                  pw.Expanded(
                      child: pw.Container(
                    // height: 35,
                    width: 60,
                    alignment: pw.Alignment.centerRight,
                    // decoration: pw.BoxDecoration(
                    //   // border: pw.Border.all(color: PdfColors.grey700),
                    //   color: PdfColors.white,
                    // ),
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                        customer.type == TransactionType.Pay
                            ? fixTo2(customer.amount).replaceAll('-', '')
                            : '',
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.green,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
                  pw.VerticalDivider(
                    color: PdfColors.grey700,
                  ),
                  pw.Expanded(
                      child: pw.Container(
                    // height: 35,
                    width: 60,
                    alignment: pw.Alignment.centerRight,
                    // decoration: pw.BoxDecoration(
                    //   border: pw.Border.all(color: PdfColors.grey700),
                    //   color: PdfColors.white,
                    //   borderRadius: isFirstRow && isLastRow
                    //       ? pw.BorderRadius.only(
                    //           topRight: pw.Radius.circular(10),
                    //           bottomRight: pw.Radius.circular(10),
                    //         )
                    //       : isFirstRow
                    //           ? pw.BorderRadius.only(
                    //               topRight: pw.Radius.circular(10),
                    //             )
                    //           : isLastRow
                    //               ? pw.BorderRadius.only(
                    //                   bottomRight: pw.Radius.circular(10),
                    //                 )
                    //               : pw.BorderRadius.all(pw.Radius.circular(0)),
                    // ),
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                        customer.type == TransactionType.Receive
                            ? fixTo2(customer.amount).replaceAll('-', '')
                            : '',
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.red,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
                ],
              ))),
    ));
  }

  pw.Widget _tableFooter(pw.Context context, GlobalReportModel reportModel) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 5),
      child: pw.Expanded(
        child: pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey700),
            borderRadius: pw.BorderRadius.circular(10),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    height: 40,
                    width: 60,
                    alignment: pw.Alignment.centerLeft,
                    decoration: pw.BoxDecoration(
                      // border: pw.Border(
                      //   left: pw.BorderSide(),
                      //   bottom: pw.BorderSide(),
                      // ),
                      borderRadius: pw.BorderRadius.only(
                          topLeft: pw.Radius.circular(10),
                          bottomLeft: pw.Radius.circular(10)),
                      color: PdfColors.grey200,
                    ),
                    child: pw.Padding(
                      padding: pw.EdgeInsets.only(
                          top: 15, left: 10, right: 10, bottom: 10),
                      child: pw.Text(
                        'Net Balance',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
              pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    height: 40,
                    width: 60,
                    decoration: pw.BoxDecoration(
                      // border: pw.Border(
                      //   bottom: pw.BorderSide(),
                      // ),
                      color: PdfColors.grey200,
                    ),
                  )),
              pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    height: 40,
                    width: 60,
                    alignment: pw.Alignment.centerRight,
                    decoration: pw.BoxDecoration(
                      // border: pw.Border(
                      //   bottom: pw.BorderSide(),
                      // ),
                      color: PdfColors.grey200,
                    ),
                    child: pw.Padding(
                      padding: pw.EdgeInsets.only(
                          top: 15, left: 10, right: 10, bottom: 10),
                      child: pw.Text(
                        fixTo2(reportModel.pay).replaceAll('-', ''),
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
              pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    height: 40,
                    width: 60,
                    alignment: pw.Alignment.centerRight,
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.only(
                          topRight: pw.Radius.circular(10),
                          bottomRight: pw.Radius.circular(10)),
                      color: PdfColors.grey200,
                    ),
                    child: pw.Padding(
                      padding: pw.EdgeInsets.only(
                          top: 15, left: 10, right: 10, bottom: 10),
                      child: pw.Text(
                        fixTo2(reportModel.receive).replaceAll('-', ''),
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> savePdf() async {
    await writeOnPdf();
    final documentDirectory = await Directory(Platform.isIOS
            ? (await getApplicationDocumentsDirectory()).path
            : (await getExternalStorageDirectories(
                        type: StorageDirectory.documents))!
                    .first
                    .path +
                '/Pdf')
        .create();
    final documentPath = documentDirectory.path;
    final file =
        File("$documentPath/GlobalDetailedReport-${DateTime.now()}.pdf");
    file.writeAsBytesSync(await pdf.save());
    return file.path;
  }

  LANGUANGE_TYPE checkStringLanguage(String text){
    if(hindiRegex.hasMatch(text)){
      return LANGUANGE_TYPE.HINDI;

    }
    else if(arabicRegex.hasMatch(text)){
      return LANGUANGE_TYPE.ARABIC;

    }
    else{
      return LANGUANGE_TYPE.ENGLISH;
    }



  }



   generateHindiRegex(){
    var numberOfHindiCharacters = 128;
    var unicodeShift = 0x0900;
    var hindiAlphabet = [];
    for (var i = 0; i < numberOfHindiCharacters; i++) {
      //  print("u0" + (unicodeShift + i).toString());
      hindiAlphabet.add("\\u0" + (unicodeShift + i).toRadixString(16));
    }
     hindiRegex = RegExp("(?:^|\\s)[" + hindiAlphabet.join("") + "]+?(?:\\s|\$)");
    // var string1 = "व";


  }
  generateArabicRegex(){
    var numberOfArabicCharacters = 256;
    var unicodeShift = 0x0600;
    var arabicAlphabet = [];
    for (var i = 0; i < numberOfArabicCharacters; i++) {
      //  print("u0" + (unicodeShift + i).toString());
      arabicAlphabet.add("\\u0" + (unicodeShift + i).toRadixString(16));
    }
    arabicRegex = RegExp("(?:^|\\s)[" + arabicAlphabet.join("") + "]+?(?:\\s|\$)");
    // var string1 = "व";


  }
}
enum LANGUANGE_TYPE{ARABIC,HINDI,ENGLISH}
