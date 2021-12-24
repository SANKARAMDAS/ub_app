import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:urbanledger/Utility/app_services.dart';

class AnalyticsPDFGenerator {
  final int amount;

  final pdf = pw.Document();
  AnalyticsPDFGenerator({required this.amount});

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

    pdf.addPage(pw.MultiPage(
        // margin: pw.EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        footer: (context) => _buildFooter(context, footerImage),
        header: (context) => _buildHeader(context, headerImage),
        pageTheme: _buildTheme(PdfPageFormat.a4, pdfBackgroundImage, ttf),
        build: (context) {
          return [
            pw.SizedBox(height: 30),
            // _buildCustomerDetails(context),
            // _buildTransactionSummary(context),
            pw.SizedBox(height: 20),
            // _tableHeaders(),
            // ...generateTable(),
            // _tableFooter(context),
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
    return pw.Column(children: [
      pw.Stack(alignment: pw.Alignment.center, children: [
        pw.Image(headerImage),
        pw.Padding(
            padding: pw.EdgeInsets.only(right: 30),
            child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('qwerty',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                    )))),
      ]),
      if (context.pageNumber > 1) pw.SizedBox(height: 20),
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
                    ' of ' +
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
}