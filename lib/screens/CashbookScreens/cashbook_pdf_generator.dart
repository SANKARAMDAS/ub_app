import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:urbanledger/Models/cashbook_entry_model.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import '../Components/custom_widgets.dart';

class CashbookPdfGenerator {
  final DateTime startDate;
  final DateTime endDate;
  final List<CashbookPdfModel> transactions;
  final double totalInAmount;
  final double totalOutAmount;
  final double totalInOnlineAmount;
  final double totalOutOnlineAmount;
  final List<dynamic> detailedTransactions;
  final String filterString;
  final String businessName;

  final pdf = pw.Document();
  final bool isDetailed;

  CashbookPdfGenerator(
      {required this.transactions,
      required this.isDetailed,
      required this.detailedTransactions,
      required this.totalInAmount,
      required this.totalOutAmount,
      required this.totalInOnlineAmount,
      required this.totalOutOnlineAmount,
      required this.startDate,
      required this.endDate,
      required this.filterString,
      required this.businessName});

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
            _buildCustomerDetails(context),
            _buildTransactionSummary(context),
            pw.SizedBox(height: 20),
            _tableHeaders(),
            ...generateTable(),
            _tableFooter(context),
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
                child: pw.Text(businessName,
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

  pw.Widget _buildCustomerDetails(pw.Context context) {
    return pw.Padding(
        padding: pw.EdgeInsets.symmetric(horizontal: 30),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Cashbook Statement',
                  style: pw.TextStyle(
                    color: PdfColor.fromHex('#1058ff'),
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  )),
              pw.Text(
                  '${DateFormat('dd MMM yyy').format(startDate)} - ${DateFormat('dd MMM yyy').format(endDate)}' +
                      '($filterString)',
                  style: pw.TextStyle(
                    fontSize: 14,
                  )),
            ]));
  }

  pw.Widget _buildTransactionSummary(pw.Context context) {
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
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 10),
                    pw.Text('Total Cash IN (+)',
                        style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.green,
                            fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Text(
                        '$currencyAED ${fixTo2(totalInAmount).replaceAll('-', '')}',
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                        'Cash : ' +
                            '$currencyAED ${fixTo2(totalInAmount - totalInOnlineAmount).replaceAll('-', '')}',
                        style: pw.TextStyle(fontSize: 12)),
                    pw.Text(
                        'Online : ' +
                            '$currencyAED ${fixTo2(totalInOnlineAmount).replaceAll('-', '')}',
                        style: pw.TextStyle(fontSize: 12)),
                  ]),

              pw.Padding(
                padding: pw.EdgeInsets.only(top: 10),
                child: pw.Text('-', style: pw.TextStyle(fontSize: 14)),
              ),
              // pw.VerticalDivider(
              //   indent: 20,
              //   endIndent: 20,
              //   color: PdfColor.fromHex('#1058ff'),
              // ),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 10),
                    pw.Text('Total Cash OUT (-)',
                        style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.red,
                            fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Text(
                        '$currencyAED ${fixTo2(totalOutAmount).replaceAll('-', '')}',
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                        'Cash : ' +
                            '$currencyAED ${fixTo2(totalOutAmount - totalOutOnlineAmount).replaceAll('-', '')}',
                        style: pw.TextStyle(fontSize: 12)),
                    pw.Text(
                        'Online : ' +
                            '$currencyAED ${fixTo2(totalOutOnlineAmount).replaceAll('-', '')}',
                        style: pw.TextStyle(fontSize: 12)),
                  ]),

              pw.Padding(
                padding: pw.EdgeInsets.only(top: 10),
                child: pw.Text('=', style: pw.TextStyle(fontSize: 14)),
              ),
              // pw.VerticalDivider(
              //   indent: 20,
              //   endIndent: 20,
              //   color: PdfColor.fromHex('#1058ff'),
              // ),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 10),
                    pw.Text('Net Balance',
                        style: pw.TextStyle(
                          fontSize: 14,
                        )),
                    pw.SizedBox(height: 10),
                    pw.RichText(
                      text: pw.TextSpan(
                        children: [
                          pw.TextSpan(
                              text:
                                  '$currencyAED ${fixTo2(totalInAmount - totalOutAmount).replaceAll('-', '')}',
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                                color: fixTo2(totalInAmount - totalOutAmount)
                                        .contains('-')
                                    ? PdfColors.red
                                    : PdfColors.green,
                              )),
                          pw.TextSpan(
                            text: ((totalInAmount - totalOutAmount).isNegative
                                ? ' Dr'
                                : ' Cr'),
                            style: pw.TextStyle(color: PdfColors.black),
                          )
                        ],
                      ),
                    ),
                  ])
            ]),
      ),
    );
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
                    color: PdfColors.grey200,
                    border: pw.Border.all(),
                    borderRadius: pw.BorderRadius.only(
                      topLeft: pw.Radius.circular(10),
                    ),
                    // color: PdfColors.grey200,
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
                      'Total IN',
                      style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green),
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
                      'Total OUT',
                      style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.red),
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
                      'Daily Balance',
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
                      'Cash in Hand',
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
      widgets.add(getTableRow(
          i,
          (i == transactions.length - 1) &&
              detailedTransactions
                      .where((element) =>
                          DateTime(
                              element.createdDate!.year,
                              element.createdDate!.month,
                              element.createdDate!.day) ==
                          transactions[i].date.date)
                      .toList()
                      .length ==
                  0));
      if (isDetailed) {
        final filteredTransactions = detailedTransactions
            .where((element) =>
                DateTime(element.createdDate!.year, element.createdDate!.month,
                    element.createdDate!.day) ==
                transactions[i].date.date)
            .toList();
        for (var j = 0; j < filteredTransactions.length; j++) {
          widgets.add(getDetailedTableRow(
              filteredTransactions[j],
              i == transactions.length - 1 &&
                  j == filteredTransactions.length - 1));
        }
      }
    }

    return widgets;
  }

  getTableRow(int index, bool isLastRow) {
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
                    color: PdfColors.grey200,
                    borderRadius: isLastRow
                        ? pw.BorderRadius.only(
                            bottomLeft: pw.Radius.circular(10),
                          )
                        : pw.BorderRadius.all(pw.Radius.circular(0)),
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          pw.Text(
                            getCol(0, transactions[index]),
                            style: pw.TextStyle(fontSize: 14),
                          ),
                          // pw.SizedBox(height: 2),
                          isDetailed
                              ? pw.Text(
                                  detailedTransactions
                                          .where((element) {
                                            if (element.createdDate == null)
                                              return false;
                                            return DateTime(
                                                    element.createdDate!.year,
                                                    element.createdDate!.month,
                                                    element.createdDate!.day) ==
                                                transactions[index].date.date;
                                          })
                                          .toList()
                                          .isEmpty
                                      ? getCol(5, transactions[index])
                                      : '${detailedTransactions.where((element) => DateTime(element.createdDate!.year, element.createdDate!.month, element.createdDate!.day) == transactions[index].date.date).toList().length} Entries',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                  ),
                                )
                              : pw.Text(
                                  '${detailedTransactions.where((element) => DateTime(element.createdDate!.year, element.createdDate!.month, element.createdDate!.day) == transactions[index].date.date).toList().length} Entries',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                        ]),
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
                      getCol(1, transactions[index]),
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
                    color: PdfColors.grey200,
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      getCol(2, transactions[index]),
                      style: pw.TextStyle(fontSize: 14),
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
                      getCol(3, transactions[index]),
                      style: pw.TextStyle(
                          fontSize: 14,
                          color: transactions[index].dailyBalance == 0
                              ? PdfColors.black
                              : transactions[index].dailyBalance.isNegative
                                  ? PdfColors.red
                                  : PdfColors.green),
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
                    color: PdfColors.grey200,
                    borderRadius: isLastRow
                        ? pw.BorderRadius.only(
                            bottomRight: pw.Radius.circular(10),
                          )
                        : pw.BorderRadius.all(pw.Radius.circular(0)),
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      getCol(4, transactions[index]),
                      style: pw.TextStyle(
                          fontSize: 14,
                          color: transactions[index].cashInHand == 0
                              ? PdfColors.black
                              : transactions[index].cashInHand.isNegative
                                  ? PdfColors.red
                                  : PdfColors.green),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  getDetailedTableRow(CashbookEntryModel model, bool isLastRow) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: 30, right: 30),
      child: pw.Expanded(
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 35,
                  alignment: pw.Alignment.centerLeft,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    // color: PdfColors.grey200,
                    borderRadius: isLastRow
                        ? pw.BorderRadius.only(
                            bottomLeft: pw.Radius.circular(10),
                          )
                        : pw.BorderRadius.all(pw.Radius.circular(0)),
                  ),
                  child: pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Row(children: [
                        pw.Text(
                          DateFormat('hh:mmaa').format(model.createdDate),
                          style: pw.TextStyle(fontSize: 14),
                        ),
                        pw.SizedBox(width: 4),
                        pw.Container(
                            padding: pw.EdgeInsets.all(3),
                            alignment: pw.Alignment.center,
                            decoration: pw.BoxDecoration(
                                color: PdfColors.grey100,
                                borderRadius: pw.BorderRadius.circular(5)),
                            child: pw.Text(
                              model.paymentMode == PaymentMode.Cash
                                  ? 'Cash'
                                  : 'Online',
                              style: pw.TextStyle(
                                fontSize: 8,
                                color: PdfColors.grey400,
                              ),
                            ))
                      ])),
                )),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 35,
                  width: 30,
                  alignment: pw.Alignment.centerLeft,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    // color: PdfColors.grey200,
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      model.entryType == EntryType.IN
                          ? 'AED ${fixTo2(model.amount)}'
                          : '',
                      style: pw.TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                )),
            pw.Expanded(
                flex: 1,
                child: pw.Container(
                  height: 35,
                  width: 60,
                  alignment: pw.Alignment.centerLeft,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    // color: PdfColors.grey200,
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      model.entryType == EntryType.OUT
                          ? 'AED ${fixTo2(model.amount)}'
                          : '',
                      style: pw.TextStyle(fontSize: 14),
                    ),
                  ),
                )),
            pw.Expanded(
                flex: 2,
                child: pw.Container(
                  height: 35,
                  width: 60,
                  alignment: pw.Alignment.centerLeft,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    borderRadius: isLastRow
                        ? pw.BorderRadius.only(
                            bottomRight: pw.Radius.circular(10),
                          )
                        : pw.BorderRadius.all(pw.Radius.circular(0)),
                    // color: PdfColors.grey200,
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Text(
                      '',
                      style: pw.TextStyle(fontSize: 14),
                    ),
                  ),
                )),
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
                  flex: 1,
                  child: pw.Container(
                    height: 50,
                    width: 30,
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
                    alignment: pw.Alignment.centerLeft,
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
                        fixTo2(totalInAmount).replaceAll('-', ''),
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
              pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                    height: 50,
                    alignment: pw.Alignment.centerLeft,
                    width: 60,
                    decoration: pw.BoxDecoration(
                      // borderRadius: pw.BorderRadius.only(
                      // topRight: pw.Radius.circular(10),
                      // bottomRight: pw.Radius.circular(10)),
                      color: PdfColors.grey200,
                    ),
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                        fixTo2(totalOutAmount).replaceAll('-', ''),
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
                    alignment: pw.Alignment.centerLeft,
                    width: 30,
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.only(
                          topRight: pw.Radius.circular(10),
                          bottomRight: pw.Radius.circular(10)),
                      color: PdfColors.grey200,
                    ),
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Text(
                        'AED ' +
                            fixTo2(totalInAmount - totalOutAmount)
                                .replaceAll('-', ''),
                        style: pw.TextStyle(
                          fontSize: 14,
                          // fontWeight: pw.FontWeight.bold,
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

  getCol(int index, CashbookPdfModel transaction) {
    if (index == 0)
      return DateFormat('dd MMM').format(transaction.date);
    else if (index == 1)
      return 'AED ' + fixTo2(transaction.inAmount).replaceAll('-', '');
    else if (index == 2)
      return 'AED ' + fixTo2(transaction.outAmount).replaceAll('-', '');
    else if (index == 3)
      return 'AED ' + fixTo2(transaction.dailyBalance).replaceAll('-', '');
    else if (index == 4)
      return 'AED ' + fixTo2(transaction.cashInHand).replaceAll('-', '');
    else if (index == 5) return '0 Entries';
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
    final file = File("$documentPath/" +
        (isDetailed
            ? "UrbanLedger-Cashbook-Detailed-Report-${DateTime.now()}.pdf"
            : "UrbanLedger-Cashbook-Summary-Report-${DateTime.now()}.pdf"));
    file.writeAsBytesSync(await pdf.save());
    return file.path;
  }
}
