import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class ReportPdfGenerator {
  final List<TransactionModel> transactions;
  final CustomerModel customerModel;
  final pdf = pw.Document();
  final double youWillGet;
  final double youWillGive;
  final DateTime? startDate;
  final DateTime? endDate;
  final String businessName;

  var hindiRegex;
  var arabicRegex;
  var ttfEnglish;
  var ttfHindi;
  var ttfArabic;

  ReportPdfGenerator(
      this.transactions, this.customerModel, this.youWillGet, this.youWillGive,
      {this.startDate, this.endDate, required this.businessName}){
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
            pw.SizedBox(height: 20),
            _buildCustomerDetails(context, ttfEnglish),
            _buildTransactionSummary(context),
            pw.SizedBox(height: 20),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 30),
              child: pw.Text('No. of Entries: ${transactions.length} (All)',
                  style: pw.TextStyle(fontSize: 14, font: ttfEnglish)),
            ),
            _tableHeaders(),
            ...generateTable(),
            _tableFooter(context),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 30),
              child: pw.Text(
                  'Report Generated: ' +
                      DateFormat("hh:mm aa | dd MMM yy").format(DateTime.now()),
                  style: pw.TextStyle(
                      fontSize: 14, color: PdfColors.grey, font: ttfEnglish)),
            ),
            pw.SizedBox(height: 20),
          ];
        }));
  }

  pw.Widget _buildHeader(pw.Context context, pw.MemoryImage headerImage) {
    return pw.Column(children: [
      pw.Stack(alignment: pw.Alignment.center, children: [
        pw.Image(headerImage),
        pw.Padding(
          padding: pw.EdgeInsets.only(right: 30),
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              businessName,
              style: pw.TextStyle(
                color: PdfColors.white,
              ),
            ),
          ),
        ),
      ]),
      if (context.pageNumber > 1) pw.SizedBox(height: 20)
    ]);
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

  pw.Widget _buildCustomerDetails(pw.Context context, pw.Font ttf) {
    var selectedFont =  ttfEnglish;
    switch(checkStringLanguage(customerModel.name!)){
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
        padding: pw.EdgeInsets.symmetric(horizontal: 30),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(customerModel.name! + ' Statement',
                  style: pw.TextStyle(
                      color: PdfColor.fromHex('#7C4DFF'),
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      font: selectedFont)),
              pw.Text('Phone Number: ' + customerModel.mobileNo!,
                  style: pw.TextStyle(fontSize: 14, font: ttf)),
              pw.Text(
                  startDate == null && endDate == null
                      ? '(${DateFormat('dd MMM yyyy').format(DateTime.now())})'
                      : '(${DateFormat('dd MMM yyy').format(startDate!)} - ${DateFormat('dd MMM yyy').format(endDate!)})',
                  style: pw.TextStyle(fontSize: 14, font: ttf)),
            ]));
  }

  pw.Widget _buildTransactionSummary(pw.Context context) {
    var selectedFont =  ttfEnglish;
    switch(checkStringLanguage(customerModel.name!)){
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
      padding: pw.EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: pw.Container(
        height: 100,
        alignment: pw.Alignment.center,
        decoration: pw.BoxDecoration(
            color: PdfColors.white,
            border: pw.Border.all(),
            borderRadius: pw.BorderRadius.circular(10)),
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      'Opening Balance',
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text('$currencyAED 0.00',
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      startDate == endDate ? '' : '',
                    ),
                  ]),
              pw.VerticalDivider(
                indent: 20,
                endIndent: 20,
                color: PdfColor.fromHex('#7C4DFF'),
              ),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      'Total Debit (-)',
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                        '$currencyAED ${fixTo2(youWillGet).replaceAll('-', '')}',
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      '',
                    ),
                  ]),
              pw.VerticalDivider(
                indent: 20,
                endIndent: 20,
                color: PdfColor.fromHex('#7C4DFF'),
              ),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      'Total Credit (+)',
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                        '$currencyAED ${fixTo2(youWillGive).replaceAll('-', '')}',
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      '',
                    ),
                  ]),
              pw.VerticalDivider(
                indent: 20,
                endIndent: 20,
                color: PdfColor.fromHex('#7C4DFF'),
              ),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      'Net Balance',
                    ),
                    pw.SizedBox(height: 10),
                    pw.RichText(
                      text: pw.TextSpan(
                        children: [
                          pw.TextSpan(
                            text: fixTo2(youWillGet - youWillGive)
                                .replaceAll('-', ''),
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                                color: (youWillGet - youWillGive).isNegative
                                    ? PdfColors.red
                                    : PdfColors.green),
                          ),
                          pw.TextSpan(
                            text: ((youWillGet - youWillGive).isNegative
                                ? ' Dr'
                                : ' Cr'),
                            style: pw.TextStyle(color: PdfColors.black),
                          )
                        ],
                      ),
                    ),
                    // pw.Text(
                    //     '$currencyAED ${fixTo2(youWillGet - youWillGive)}',
                    //     style: pw.TextStyle(
                    //         fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      '(${customerModel.name!.split(' ').first} will ${(youWillGet - youWillGive).isNegative ? 'get' : 'give'})',
                        style: pw.TextStyle(
                            font: selectedFont)),
                  ])
            ]),
      ),
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'Date',
      'Details',
      'Debit (-)',
      'Credit (+)',
      'Balance'
    ];

    return pw.Padding(
        padding: pw.EdgeInsets.only(left: 30, right: 30, bottom: 30, top: 10),
        child: pw.Table.fromTextArray(
          border: pw.TableBorder.all(),
          cellAlignment: pw.Alignment.centerLeft,
          headerDecoration: pw.BoxDecoration(
            color: PdfColors.grey200,
          ),
          headerHeight: 50,
          cellHeight: 40,
          columnWidths: {
            0: pw.FixedColumnWidth(30),
            1: pw.FixedColumnWidth(30),
            2: pw.FixedColumnWidth(30),
            3: pw.FixedColumnWidth(30),
            4: pw.FixedColumnWidth(30)
          },
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerLeft,
            4: pw.Alignment.centerLeft,
          },
          headerStyle: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
          cellPadding: pw.EdgeInsets.all(10),
          cellStyle: const pw.TextStyle(
            fontSize: 14,
          ),
          rowDecoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(
                width: .5,
              ),
            ),
          ),
          headers: List<String>.generate(
            tableHeaders.length,
            (col) => tableHeaders[col],
          ),
          data: List<List<String>>.generate(
            transactions.length,
            (row) => List<String>.generate(
              tableHeaders.length,
              (col) => getCol(col, transactions[row]),
            ),
          ),
        ));
  }

  _tableHeaders() {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: 30, right: 30, top: 10),
      child: pw.Expanded(
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 50,
                  alignment: pw.Alignment.centerLeft,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    borderRadius: pw.BorderRadius.only(
                      topLeft: pw.Radius.circular(10),
                    ),
                    color: PdfColors.grey200,
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      'Date',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                )),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 50,
                  width: 30,
                  alignment: pw.Alignment.centerLeft,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    color: PdfColors.grey200,
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      'Details',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                )),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 50,
                  width: 60,
                  alignment: pw.Alignment.centerLeft,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    color: PdfColors.grey200,
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      'Debit (-)',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                )),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 50,
                  width: 60,
                  alignment: pw.Alignment.centerLeft,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    color: PdfColors.grey200,
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      'Credit (+)',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                )),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 50,
                  width: 60,
                  alignment: pw.Alignment.centerLeft,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.only(
                      topRight: pw.Radius.circular(10),
                    ),
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      'Balance',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  List<pw.Widget> generateTable() {
    List<pw.Widget> widgets = [];

    for (var i = 0; i < transactions.length; i++) {
      widgets.add(getTableRow(transactions[i], i == transactions.length - 1));
    }

    return widgets;
  }

  getTableRow(TransactionModel transaction, bool isLastRow) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: 30, right: 30),
      child: pw.Expanded(
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 50,
                  alignment: pw.Alignment.centerLeft,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    color: PdfColors.white,
                    borderRadius: isLastRow
                        ? pw.BorderRadius.only(
                            bottomLeft: pw.Radius.circular(10),
                          )
                        : pw.BorderRadius.all(pw.Radius.circular(0)),
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      getCol(0, transaction),
                      style: pw.TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                )),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 50,
                  width: 30,
                  alignment: pw.Alignment.centerLeft,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    color: PdfColors.white,
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      getCol(1, transaction),
                      style: pw.TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                )),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 50,
                  width: 60,
                  alignment: pw.Alignment.centerLeft,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    color: PdfColors.white,
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      getCol(2, transaction),
                      style: pw.TextStyle(fontSize: 14, color: PdfColors.red),
                    ),
                  ),
                )),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 50,
                  width: 60,
                  alignment: pw.Alignment.centerLeft,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    color: PdfColors.white,
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      getCol(3, transaction),
                      style: pw.TextStyle(fontSize: 14, color: PdfColors.green),
                    ),
                  ),
                )),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 50,
                  alignment: pw.Alignment.centerLeft,
                  width: 60,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    color: PdfColors.white,
                    borderRadius: isLastRow
                        ? pw.BorderRadius.only(
                            bottomRight: pw.Radius.circular(10),
                          )
                        : pw.BorderRadius.all(pw.Radius.circular(0)),
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.RichText(
                      text: pw.TextSpan(
                        children: [
                          pw.TextSpan(
                            text: fixTo2(transaction.balanceAmount)
                                .replaceAll('-', ''),
                            style: pw.TextStyle(
                                fontSize: 14,
                                color: transaction.balanceAmount!.isNegative
                                    ? PdfColors.red
                                    : PdfColors.green),
                          ),
                          pw.TextSpan(
                            text: (transaction.balanceAmount!.isNegative
                                ? ' Dr'
                                : ' Cr'),
                            style: pw.TextStyle(color: PdfColors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  pw.Widget _tableFooter(pw.Context context) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 30),
      child: pw.Expanded(
        child: pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black),
            borderRadius: pw.BorderRadius.circular(10),
          ),
          child: pw.Row(
            children: [
              pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                    height: 50,
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
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                        'Grand Total',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
              pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    height: 50,
                    width: 30,
                    decoration: pw.BoxDecoration(
                      // border: pw.Border(
                      //   bottom: pw.BorderSide(),
                      // ),
                      color: PdfColors.grey200,
                    ),
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                        fixTo2(youWillGet).replaceAll('-', ''),
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
              pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    height: 50,
                    width: 60,
                    decoration: pw.BoxDecoration(
                      // border: pw.Border(
                      //   bottom: pw.BorderSide(),
                      // ),
                      color: PdfColors.grey200,
                    ),
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                        fixTo2(youWillGive),
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
              pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    height: 50,
                    width: 60,
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.only(
                          topRight: pw.Radius.circular(10),
                          bottomRight: pw.Radius.circular(10)),
                      color: PdfColors.grey200,
                    ),
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                        fixTo2(youWillGet - youWillGive).replaceAll('-', ''),
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  getCol(int index, TransactionModel transactionModel) {
    if (index == 0)
      return DateFormat('dd MMM yyyy').format(transactionModel.date!);
    else if (index == 1)
      return transactionModel.details;
    else if (index == 2)
      return transactionModel.transactionType == TransactionType.Receive
          ? ''
          : fixTo2(transactionModel.amount);
    else if (index == 3)
      return transactionModel.transactionType == TransactionType.Pay
          ? ''
          : fixTo2(transactionModel.amount);
    else if (index == 4)
      return fixTo2(transactionModel.balanceAmount).replaceAll('-', '') +
          (transactionModel.balanceAmount!.isNegative ? ' Dr' : ' Cr');
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
    final file = File("$documentPath/TransactionReport-${DateTime.now()}.pdf");
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
