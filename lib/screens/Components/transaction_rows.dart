import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/chat_module/data/repositories/chat_repository.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import '../../Utility/app_constants.dart';
import 'package:urbanledger/Models/customer_model.dart';

class LedgerList extends StatelessWidget {
  final List<TransactionModel> ledgerTransactionList;
  final CustomerModel? customerModel;
  final Function(double? amount, String? details, int? paymentType)?
      sendMessage;

  final Future<double> Function(DateTime date) getBalance;

  const LedgerList(
      {Key? key,
      required this.ledgerTransactionList,
      required this.customerModel,
      this.sendMessage,
      required this.getBalance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: ledgerTransactionList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return InkWell(
              onTap: customerModel == null
                  ? () {}
                  : ledgerTransactionList[index].isPayment
                      ? () async {
                          final response = await ChatRepository()
                              .getTransactionDetails(
                                  ledgerTransactionList[index]
                                      .paymentTransactionId);
                          if (response != null)
                            Navigator.pushNamed(
                              context,
                              AppRoutes.paymentDetailsRoute,
                              arguments: TransactionDetailsArgs(
                                urbanledgerId: response['urbanledgerId'],
                                transactionId: response['transactionId'],
                                to: response['to'],
                                toEmail: response['toEmail'],
                                from: response['from'],
                                fromEmail:
                                    repository.hiveQueries.userData.email,
                                completed: response['completed'],
                                paymentMethod: response['paymentMethod'],
                                amount: response['amount'].toString(),
                                cardImage: (response)['cardImage'],
                                endingWith: (response)['endingWith'],
                                customerName: customerModel?.name ?? '',
                                mobileNo: customerModel!.mobileNo,
                              ),
                            );
                        }
                      : () {
                          Navigator.pushNamed(
                              context, AppRoutes.enterDetailsRoute,
                              arguments: EnterDetailsRouteArgs(customerModel,
                                  ledgerTransactionList[index], sendMessage));
                        },
              child: Container(
                padding: customerModel == null
                    ? EdgeInsets.zero
                    : EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Card(
                      margin: EdgeInsets.only(
                        bottom: 1,
                        top: 1,
                      ),
                      child: Container(
                        width: screenWidth(context) * 0.39,
                        height: screenHeight(context) * 0.1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (ledgerTransactionList[index]
                                  .details
                                  .isNotEmpty)
                                Container(
                                  width: screenWidth(context) * 0.39,
                                  child: Text(
                                    ledgerTransactionList[index].details,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              Container(
                                margin: EdgeInsets.only(
                                  bottom: 4,
                                  top: 4,
                                  right: 2,
                                ),
                                child: FutureBuilder<double>(
                                    future: getBalance(
                                        ledgerTransactionList[index].date!),
                                    builder: (context, snapshot) {
                                      if (snapshot.data != null)
                                        return RichText(
                                          text: TextSpan(
                                              text: 'Bal. ',
                                              style: TextStyle(
                                                  color: Color(0xff666666),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500),
                                              children: [
                                                TextSpan(text: '$currencyAED '),
                                                TextSpan(
                                                    text: snapshot
                                                            .data!.isNegative
                                                        ? (snapshot.data)!
                                                            .getFormattedCurrency
                                                            .substring(1)
                                                        : (snapshot.data)!
                                                            .getFormattedCurrency,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff666666),
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ]),
                                        );
                                      return RichText(
                                        text: TextSpan(
                                            text: 'Bal. ',
                                            style: TextStyle(
                                                color: Color(0xff666666),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
                                            children: [
                                              TextSpan(text: '$currencyAED '),
                                              TextSpan(
                                                  text: '0',
                                                  style: TextStyle(
                                                      color: Color(0xff666666),
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      );
                                    }),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 0),
                                child: RichText(
                                  text: TextSpan(
                                    text: DateFormat('dd MMM yyyy | hh:mmaa')
                                        .format(
                                            ledgerTransactionList[index].date!),
                                    style: TextStyle(
                                      color: Color(0xff666666),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                              if (ledgerTransactionList[index]
                                      .attachments
                                      .length >
                                  0)
                                FittedBox(
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        AppAssets.attachmentIcon,
                                        height: 14,
                                      ),
                                      CustomText(
                                        'Attachments  (${ledgerTransactionList[index].attachments.length})',
                                        bold: FontWeight.w600,
                                        size: 14,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(bottom: 2, top: 2, right: 1),
                      child: Container(
                        alignment: Alignment.topRight,
                        height: screenHeight(context) * 0.1,
                        width: screenWidth(context) * 0.26,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, right: 15, bottom: 15, left: 15),
                          child: Text(
                            ledgerTransactionList[index].transactionType ==
                                    TransactionType.Pay
                                ? '-$currencyAED ${(ledgerTransactionList[index].amount)!.getFormattedCurrency}'
                                : '',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(
                        bottom: 2,
                        top: 2,
                      ),
                      child: Container(
                        width: screenWidth(context) * 0.256,
                        height: screenHeight(context) * 0.1,
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, right: 15, bottom: 15, left: 15),
                          child: Text(
                            ledgerTransactionList[index].transactionType ==
                                    TransactionType.Receive
                                ? '+$currencyAED ${(ledgerTransactionList[index].amount)!.getFormattedCurrency}'
                                : '',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: AppTheme.greenColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
