import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urbanledger/Models/cashbook_entry_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';

class CashbookListView extends StatelessWidget {
  final List<CashbookEntryModel> cashbookList;
  final DateTime selectedDate;
  final void Function() refreshUI;
  const CashbookListView(
      {Key? key,
      required this.cashbookList,
      required this.selectedDate,
      required this.refreshUI})
      : super(key: key);
/*
ResponsiveWrapper(
                          child: Container(
                            // height: height * 0.30,
                            child: keyBoard(),
                          ),
                          maxWidth: 1200,
                          minWidth: 480,
                          shrinkWrap: true,
                          defaultScale: true,
                          
                        )
*/

  @override
  Widget build(BuildContext context) {
    final deviceWidth = screenWidth(context) - 60;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Container(
            height: 70,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    width: (deviceWidth * 0.31) + 20,
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                      left: 10.0,
                      right: 10.0,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: CustomText(
                            DateFormat("dd MMM").format(selectedDate),
                            bold: FontWeight.w700,
                            size: 18,
                            color: AppTheme.brownishGrey,
                          ),
                        ),
                        FittedBox(
                          child: CustomText(
                            'Entries (${cashbookList.length})',
                            bold: FontWeight.bold,
                            size: 18,
                            color: AppTheme.greyish,
                          ),
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    color: AppTheme.greyish,
                    thickness: 0,
                    width: 1,
                  ),
                  Container(
                    width: (deviceWidth * 0.30) + 15,
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                      left: 10.0,
                      right: 10.0,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText(
                          'Out',
                          bold: FontWeight.w700,
                          size: 18,
                          color: AppTheme.brownishGrey,
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: CustomText(
                            '$currencyAED ${(getTotalOUTAmount().getFormattedCurrency)}',
                            bold: FontWeight.bold,
                            size: 18,
                            color: AppTheme.tomato,
                          ),
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    color: AppTheme.greyish,
                    thickness: 0,
                    width: 1,
                  ),
                  Expanded(
                    child: Container(
                      // width: (deviceWidth * 0.30) + 18,
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                        left: 10.0,
                        right: 10.0,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FittedBox(
                            child: CustomText(
                              'In',
                              bold: FontWeight.w700,
                              size: 18,
                              color: AppTheme.brownishGrey,
                            ),
                          ),
                          FittedBox(
                            child: CustomText(
                              '$currencyAED ${(getTotalINAmount().getFormattedCurrency)}',
                              bold: FontWeight.bold,
                              size: 18,
                              color: AppTheme.greenColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          EntryList(
            deviceWidth: deviceWidth,
            cashbookList: cashbookList,
            selectedDate: selectedDate,
            refreshUI: refreshUI,
          )
        ],
      ),
    );
  }

  double getTotalOUTAmount() {
    double amount = 0;
    final inList = cashbookList
        .where((element) => element.entryType == EntryType.OUT)
        .toList();
    inList.forEach((element) {
      amount += element.amount;
    });
    return amount;
  }

  double getTotalINAmount() {
    double amount = 0;
    final inList = cashbookList
        .where((element) => element.entryType == EntryType.IN)
        .toList();
    inList.forEach((element) {
      amount += element.amount;
    });
    return amount;
  }
}

class EntryList extends StatelessWidget {
  final double deviceWidth;
  final List<CashbookEntryModel> cashbookList;
  final DateTime selectedDate;
  final void Function() refreshUI;

  const EntryList(
      {Key? key,
      required this.deviceWidth,
      required this.cashbookList,
      required this.selectedDate,
      required this.refreshUI})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: deviceHeight * 0.61,
      margin: EdgeInsets.only(top: 8),
      child: ListView.builder(
        itemCount: cashbookList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(AppRoutes.entryDetailsCashbook,
                      arguments: CashbookEntryDetailsArgs(
                          cashbookList[index], selectedDate))
                  .then((value) {
                refreshUI();
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                height: 75,
                                margin: EdgeInsets.all(5),
                                width: (deviceWidth * 0.31) - 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        FittedBox(
                                          child: CustomText(
                                            DateFormat('hh:mm aa').format(
                                                cashbookList[index]
                                                    .createdDate),
                                            bold: FontWeight.w700,
                                            size: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        5.0.widthBox,
                                        Container(
                                          decoration: BoxDecoration(
                                              color: AppTheme
                                                  .circularAvatarTextColor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 2),
                                          child: CustomText(
                                            cashbookList[index].paymentMode ==
                                                    PaymentMode.Online
                                                ? 'Online'
                                                : 'Cash',
                                            size: 10,
                                            color: AppTheme.greyish,
                                          ),
                                        )
                                      ],
                                    ),
                                    if (cashbookList[index].details!.isNotEmpty)
                                      FittedBox(
                                        child: CustomText(
                                          cashbookList[index].details ?? '',
                                          // bold: FontWeight.w600,
                                          size: 14,
                                          color: AppTheme.brownishGrey,
                                        ),
                                      ),
                                    if (cashbookList[index].attachments.length >
                                        0)
                                      FittedBox(
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              AppAssets.attachmentIcon,
                                              height: 14,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            CustomText(
                                              'Attachments  (${cashbookList[index].attachments.length})',
                                              bold: FontWeight.w600,
                                              size: 14,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            VerticalDivider(
                              color: AppTheme.greyish,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: (deviceWidth * 0.30) - 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    cashbookList[index].entryType ==
                                            EntryType.IN
                                        ? CustomText('')
                                        : FittedBox(
                                            child: CustomText(
                                              '$currencyAED ${(cashbookList[index].amount).getFormattedCurrency}',
                                              bold: FontWeight.w500,
                                              size: 16,
                                              color: AppTheme.tomato,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            VerticalDivider(
                              color: AppTheme.greyish,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: (deviceWidth * 0.30) - 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    cashbookList[index].entryType ==
                                            EntryType.OUT
                                        ? CustomText('')
                                        : FittedBox(
                                            child: CustomText(
                                              '$currencyAED ${(cashbookList[index].amount).getFormattedCurrency}',
                                              bold: FontWeight.w500,
                                              size: 16,
                                              color: AppTheme.greenColor,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ).flexible;
  }
}
