import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/global_report.dart';

class GlobalSummaryPdfGenerator {
  final DateTime startDate;
  final DateTime endDate;
  final int selectedFilter;
  final List<GlobalReportModel> businesses;
  final double totalPay;
  final double totalReceive;
  final pdf = pw.Document();

  GlobalSummaryPdfGenerator({
    required this.startDate,
    required this.endDate,
    required this.businesses,
    required this.selectedFilter,
    required this.totalPay,
    required this.totalReceive,
  });

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

    final Uint8List fontData =
        (await rootBundle.load('assets/fonts/Quivira.otf'))
            .buffer
            .asUint8List();

    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    final giveIcon = pw.Image(
        pw.MemoryImage(
          (await rootBundle.load(
            AppAssets.giveIcon,
          ))
              .buffer
              .asUint8List(),
        ),
        height: 18);

    final getIcon = pw.Image(
        pw.MemoryImage(
          (await rootBundle.load(
            AppAssets.getIcon,
          ))
              .buffer
              .asUint8List(),
        ),
        height: 18);

    pdf.addPage(pw.MultiPage(
        // margin: pw.EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        footer: (context) => _buildFooter(context, footerImage),
        header: (context) => _buildHeader(context, headerImage),
        pageTheme: _buildTheme(PdfPageFormat.a4, pdfBackgroundImage, ttf),
        build: (context) {
          return [
            pw.SizedBox(height: 30),
            _buildLedgerSubHead(context),
            ...getTable(context, businesses, giveIcon, getIcon),
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
              pw.Text('Global Report',
                  style: pw.TextStyle(
                    color: PdfColor.fromHex('#7C4DFF'),
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

  List<pw.Widget> getTable(
      pw.Context context,
      List<GlobalReportModel> reportModels,
      pw.Widget giveIcon,
      pw.Widget getIcon) {
    return [
      _buildLedgerSummary(context, giveIcon, getIcon),
      ...generateTableRow(reportModels),
    ];
  }

  pw.Widget _buildLedgerSummary(
      pw.Context context, pw.Widget giveIcon, pw.Widget getIcon) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 0),
      child: pw.Container(
        height: 85,
        alignment: pw.Alignment.center,
        decoration: pw.BoxDecoration(
            color: PdfColors.white,
            border: pw.Border.all(color: PdfColors.grey700),
            borderRadius: pw.BorderRadius.circular(10)),
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Expanded(
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                          color: PdfColor.fromHex('#7C4DFF'),
                          borderRadius: pw.BorderRadius.circular(15)),
                      padding: pw.EdgeInsets.only(
                          left: 15, right: 15, top: 5, bottom: 5),
                      child: pw.Text(
                        'Global Summary',
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ])),
              pw.VerticalDivider(
                indent: 20,
                endIndent: 20,
                color: PdfColors.white,
              ),
              pw.Expanded(
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            giveIcon,
                            pw.Text('You will Give',
                                style: pw.TextStyle(
                                    fontSize: 14, color: PdfColors.grey700)),
                          ]),
                      pw.SizedBox(height: 5),
                      pw.Text(
                          '$currencyAED ${fixTo2(totalPay).replaceAll('-', '')}',
                          style: pw.TextStyle(
                              color: PdfColors.red,
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold)),
                    ]),
              ),
              pw.VerticalDivider(
                indent: 20,
                endIndent: 20,
                color: PdfColor.fromHex('#7C4DFF'),
              ),
              pw.Expanded(
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            getIcon,
                            pw.Text('You will Get',
                                style: pw.TextStyle(
                                  color: PdfColors.grey700,
                                  fontSize: 14,
                                )),
                          ]),
                      pw.SizedBox(height: 5),
                      pw.Text(
                          '$currencyAED ${fixTo2(totalReceive).replaceAll('-', '')}',
                          style: pw.TextStyle(
                              color: PdfColors.green,
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold)),
                    ]),
              )
            ]),
      ),
    );
  }

  List<pw.Widget> generateTableRow(List<GlobalReportModel> reportModels) {
    List<pw.Widget> widgets = [];

    for (var i = 0; i < reportModels.length; i++) {
      widgets.add(getTableRow(reportModels[i]));
    }

    return widgets;
  }

  pw.Widget getTableRow(GlobalReportModel globalReportModel) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 0),
      child: pw.Container(
        height: 85,
        alignment: pw.Alignment.center,
        decoration: pw.BoxDecoration(
            color: PdfColors.white,
            border: pw.Border.all(color: PdfColors.grey700),
            borderRadius: pw.BorderRadius.circular(10)),
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Expanded(
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('Ledger',
                          style: pw.TextStyle(
                              fontSize: 14, color: PdfColors.grey700)),
                      pw.SizedBox(height: 5),
                      pw.Text('${globalReportModel.businessname}',
                          style: pw.TextStyle(
                              fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      pw.Text('Customers (${globalReportModel.customerCount})',
                          style: pw.TextStyle(
                              color: PdfColors.grey700,
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold)),
                    ]),
              ),
              pw.VerticalDivider(
                indent: 20,
                endIndent: 20,
                color: PdfColor.fromHex('#7C4DFF'),
              ),
              pw.Expanded(
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('You will Give',
                          style: pw.TextStyle(
                              fontSize: 14, color: PdfColors.grey700)),
                      pw.SizedBox(height: 5),
                      pw.Text(
                          '$currencyAED ${fixTo2(globalReportModel.receive).replaceAll('-', '')}',
                          style: pw.TextStyle(
                              color: PdfColors.red,
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold)),
                    ]),
              ),
              pw.VerticalDivider(
                indent: 20,
                endIndent: 20,
                color: PdfColor.fromHex('#7C4DFF'),
              ),
              pw.Expanded(
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('You will Get',
                          style: pw.TextStyle(
                            color: PdfColors.grey700,
                            fontSize: 14,
                          )),
                      pw.SizedBox(height: 5),
                      pw.Text(
                          '$currencyAED ${fixTo2(globalReportModel.pay).replaceAll('-', '')}',
                          style: pw.TextStyle(
                              color: PdfColors.green,
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold)),
                    ]),
              )
            ]),
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
        File("$documentPath/GlobalSummaryReport-${DateTime.now()}.pdf");
    file.writeAsBytesSync(await pdf.save());
    return file.path;
  }
}
