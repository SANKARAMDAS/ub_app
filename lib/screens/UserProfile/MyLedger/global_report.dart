import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Models/business_model.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/extensions.dart';

import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/global_pdf_generator.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/global_summary_pdf_generator.dart';

class GlobalReport extends StatefulWidget {
  const GlobalReport({Key? key}) : super(key: key);

  @override
  _GlobalReportState createState() => _GlobalReportState();
}

class _GlobalReportState extends State<GlobalReport> {
  final Repository repository = Repository();
  int _selectedFilter = 0;
  int _selectedSort = 0;
  DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime lastDate =
      DateTime.now().date.add(Duration(hours: 23, minutes: 59, seconds: 59));
  double totalPay = 0.0;
  double totalReceive = 0.0;
  // late Future<List<double>> payReceive;
  List<GlobalReportModel> businesses = [];
  bool isLoading = true;
  bool hideFilterString = true;

  @override
  void initState() {
    // payReceive = getGlobalGiveGet();
    getBusinessData();
    super.initState();
  }

  void getBusinessData() {
    businesses.clear();
    totalPay = 0;
    totalReceive = 0;
    Future.forEach<BusinessModel>(
        Provider.of<BusinessProvider>(context, listen: false).businesses,
        (element) async {
      final data = await repository.queries.getCustomerTransactionDataOnDate(
          startDate, lastDate, element.businessId);
      totalPay += data[1];
      totalReceive += data[2];
      businesses.add(GlobalReportModel(
          data.first,
          data[1],
          data[2],
          element.businessName,
          (data.last as List).map((e) {
            return GlobalCustomerModel(
                e['NAME'],
                e['MOBILENO'],
                ((double.tryParse(e['RECEIVE'].toString()) ?? 0) -
                            (double.tryParse(e['PAY'].toString()) ?? 0))
                        .isNegative
                    ? TransactionType.Pay
                    : TransactionType.Receive,
                ((double.tryParse(e['RECEIVE'].toString()) ?? 0) -
                    (double.tryParse(e['PAY'].toString()) ?? 0)));
          }).toList()));
    }).then((value) {
      applySort();
      setState(() {
        if (isLoading) isLoading = false;
      });
    });
  }

  void applySort() {
    switch (_selectedSort) {
      case 1:
        businesses.sort((a, b) => a.businessname.compareTo(b.businessname));
        // setState(() {});
        break;
      case 2:
        businesses.sort((a, b) => a.receive.compareTo(b.receive));
        businesses = businesses.reversed.toList();
        // setState(() {});
        break;
      case 3:
        businesses.sort((a, b) => a.pay.compareTo(b.pay));
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      appBar: AppBar(
        title: Text('Global Report'),
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
        actions: [
          GestureDetector(
            onTap: () {
              filterTransactionSheet();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20, top: 18, bottom: 18),
              child: Image.asset(
                AppAssets.filterIcon,
                height: 15,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              downloadPdfSheet();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
              child: Image.asset(
                AppAssets.reportIcon,
                height: 15,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            clipBehavior: Clip.none,
            height: deviceHeight * 0.1,
            width: double.infinity,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(AppAssets.backgroundImage),
                    alignment: Alignment.topCenter)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      20.0.heightBox,
                      Container(
                        decoration: BoxDecoration(
                            color: AppTheme.electricBlue,
                            borderRadius: BorderRadius.circular(15)),
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        child: CustomText(
                          'Global Summary',
                          color: Colors.white,
                          size: 16,
                          bold: FontWeight.w600,
                        ),
                      ),
                      20.0.heightBox,
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(text: '', children: [
                                        WidgetSpan(
                                          child: Image.asset(
                                            AppAssets.giveIcon,
                                            height: 18,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' You will Give',
                                          style: TextStyle(
                                            color: AppTheme.brownishGrey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ])),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        text: '$currencyAED ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.tomato,
                                            fontWeight: FontWeight.w700),
                                        children: [
                                          TextSpan(
                                              text: totalReceive
                                                  .getFormattedCurrency
                                                  .replaceAll('-', ''),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700)),
                                        ]),
                                  )
                                ],
                              ),
                            ),
                            VerticalDivider(
                              color: AppTheme.brownishGrey,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // CustomText(
                                  //   'You will Get',
                                  //   color: isCustomerEmpty
                                  //       ? AppTheme.greyish
                                  //       : AppTheme.brownishGrey,
                                  //   bold: FontWeight.w500,
                                  //   size: 16,
                                  // ),
                                  RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(text: '', children: [
                                        WidgetSpan(
                                          child: Image.asset(
                                            AppAssets.getIcon,
                                            height: 18,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' You will Get',
                                          style: TextStyle(
                                            color: AppTheme.brownishGrey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        )
                                      ])),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        text: '$currencyAED ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.greenColor,
                                            fontWeight: FontWeight.w700),
                                        children: [
                                          TextSpan(
                                              text: totalPay
                                                  .getFormattedCurrency
                                                  .replaceAll('-', ''),
                                              // text: '46151830',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700)),
                                        ]),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      20.0.heightBox,
                    ],
                  ),
                ),
                10.0.heightBox,
                dateTiles(context),
                10.0.heightBox,
                if (!hideFilterString)
                  Container(
                    // width: 100,
                    decoration: BoxDecoration(
                        color: AppTheme.carolinaBlue.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: CustomText(
                              'Showing list of ${getSortString(_selectedSort)} for ${getDurationString(_selectedFilter)}',
                              color: AppTheme.brownishGrey,
                              size: 16,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            child: Icon(Icons.close_sharp,
                                color: AppTheme.brownishGrey),
                            onTap: () {
                              _selectedFilter = 0;
                              _selectedSort = 0;
                              final value1 = thisMonth();
                              if (value1.first != null && value1.last != null)
                                setState(() {
                                  startDate = value1.first;
                                  lastDate = value1.last;
                                });
                              hideFilterString = true;
                              getBusinessData();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                15.0.heightBox,
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        // color: Colors.black,
                        margin: EdgeInsets.only(left: 10),
                        child: CustomText(
                          'Ledger',
                          color: AppTheme.brownishGrey,
                          size: 14,
                          bold: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: RichText(
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(text: '', children: [
                              WidgetSpan(
                                child: Image.asset(
                                  AppAssets.giveIcon,
                                  height: 18,
                                ),
                              ),
                              TextSpan(
                                text: ' You will Give',
                                style: TextStyle(
                                  color: AppTheme.brownishGrey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ])),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: RichText(
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(text: '', children: [
                            WidgetSpan(
                              child: Image.asset(
                                AppAssets.getIcon,
                                height: 18,
                              ),
                            ),
                            TextSpan(
                              text: ' You will Get',
                              style: TextStyle(
                                color: AppTheme.brownishGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            )
                          ]),
                        ),
                      ),
                    )
                  ],
                ),
                15.0.heightBox,
                isLoading
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(color: AppTheme.electricBlue,),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: businesses.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            businesses[index].businessname,
                                            size: 14,
                                            color: Colors.black,
                                            bold: FontWeight.w700,
                                          ),
                                          5.0.heightBox,
                                          CustomText(
                                            'Customers ' +
                                                '(${businesses[index].customerCount})',
                                            bold: FontWeight.w500,
                                            color: AppTheme.brownishGrey,
                                            size: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    thickness: 0.7,
                                  ),
                                  Expanded(
                                      child: RichText(
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        text: '-$currencyAED ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.tomato,
                                            fontWeight: FontWeight.w500),
                                        children: [
                                          TextSpan(
                                              text: (businesses[index].receive)
                                                  .getFormattedCurrency
                                                  .replaceAll('-', ''),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700)),
                                        ]),
                                  )),
                                  VerticalDivider(
                                    thickness: 0.7,
                                  ),
                                  Expanded(
                                      child: RichText(
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        text: '+$currencyAED ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.greenColor,
                                            fontWeight: FontWeight.w500),
                                        children: [
                                          TextSpan(
                                              text: businesses[index]
                                                  .pay
                                                  .getFormattedCurrency
                                                  .replaceAll('-', ''),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700)),
                                        ]),
                                  )),
                                ],
                              ),
                            ),
                          );
                        },
                      ).flexible,
              ],
            ),
          )
        
        ],
      )),
    );
  }

  Widget dateTiles(BuildContext context) {
    return Container(
      // height: deviceHeight * 0.13,
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 5, vertical: deviceHeight * .015),
                child: GestureDetector(
                  onTap: () async {
                    final selectedDate = await showCustomDatePicker(context,
                        firstDate: DateTime(DateTime.now().year - 5),
                        initialDate: startDate,
                        lastDate: lastDate);
                    if (selectedDate != null) {
                      startDate = selectedDate;
                      _selectedFilter = 5;

                      getBusinessData();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAssets.dateIcon,
                        color: AppTheme.electricBlue,
                        height: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        DateFormat('dd MMM yyyy').format(startDate),
                        style: TextStyle(
                            color: AppTheme.brownishGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          20.0.widthBox,
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: MediaQuery.of(context).size.height * .015),
                child: GestureDetector(
                  onTap: () async {
                    final selectedDate = await showCustomDatePicker(context,
                        firstDate: startDate,
                        initialDate: lastDate,
                        lastDate: DateTime.now().date);
                    if (selectedDate != null) {
                      lastDate = selectedDate;
                      _selectedFilter = 5;
                      getBusinessData();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAssets.dateIcon,
                        color: AppTheme.electricBlue,
                        height: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        DateFormat('dd MMM yyyy').format(lastDate),
                        style: TextStyle(
                            color: AppTheme.brownishGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Future<List<double>> getGlobalGiveGet() async {
  //   double totalPay = 0.0;
  //   double totalReceive = 0.0;
  //   await Future.forEach<BusinessModel>(
  //       Provider.of<BusinessProvider>(context, listen: false).businesses,
  //       (element) async {
  //     final result = await repository.queries
  //         .getTotalPayReceiveForCustomer(element.businessId);
  //     totalPay += result.first;
  //     totalReceive += result.last;
  //   });

  //   return [totalPay, totalReceive];
  // }

  Future<void> filterTransactionSheet() async {
    int tempRadioOption = _selectedFilter;
    int tempSortOption = _selectedSort;
    await showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            decoration: BoxDecoration(
                color: AppTheme.justWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            // height: 570,
            constraints: BoxConstraints(maxHeight: 560),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          'Sort by',
                          size: 20,
                          bold: FontWeight.w600,
                          color: AppTheme.brownishGrey,
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.close_sharp,
                            color: AppTheme.greyish,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0, bottom: 12),
                    child: Wrap(
                      spacing: 10,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: tempSortOption == 1
                                ? AppTheme.electricBlue
                                : AppTheme.justWhite,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppTheme.electricBlue),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: CustomText(
                              'A-Z',
                              bold: FontWeight.w500,
                              color: tempSortOption == 1
                                  ? Colors.white
                                  : AppTheme.brownishGrey,
                            ),
                          ),
                          onPressed: () {
                            if (tempSortOption != 1)
                              setState(() {
                                tempSortOption = 1;
                              });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: tempSortOption == 2
                                ? AppTheme.electricBlue
                                : AppTheme.justWhite,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppTheme.electricBlue),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            child: CustomText(
                              'Highest you will give',
                              bold: FontWeight.w500,
                              color: tempSortOption == 2
                                  ? Colors.white
                                  : AppTheme.brownishGrey,
                            ),
                          ),
                          onPressed: () {
                            if (tempSortOption != 2)
                              setState(() {
                                tempSortOption = 2;
                              });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: tempSortOption == 3
                                ? AppTheme.electricBlue
                                : AppTheme.justWhite,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppTheme.electricBlue),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            child: CustomText(
                              'Highest you will get',
                              bold: FontWeight.w500,
                              color: tempSortOption == 3
                                  ? Colors.white
                                  : AppTheme.brownishGrey,
                            ),
                          ),
                          onPressed: () {
                            if (tempSortOption != 3)
                              setState(() {
                                tempSortOption = 3;
                              });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: CustomText(
                      'Select report duration',
                      size: 20,
                      bold: FontWeight.w600,
                      color: AppTheme.brownishGrey,
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            'This month',
                            size: 16,
                            bold: tempRadioOption == 0
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: AppTheme.brownishGrey,
                          ),
                          Radio(
                            groupValue: tempRadioOption,
                            value: 0,
                            onChanged: (value) {
                              tempRadioOption = value as int;
                              final value1 = thisMonth();
                              if (value1.first != null && value1.last != null)
                                setState(() {
                                  startDate = value1.first;
                                  lastDate = value1.last;
                                });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            'Single Day',
                            size: 16,
                            bold: tempRadioOption == 1
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: AppTheme.brownishGrey,
                          ),
                          Radio(
                            value: 1,
                            groupValue: tempRadioOption,
                            onChanged: (value) {
                              tempRadioOption = value as int;
                              singleDay().then((value) {
                                if (value.first != null && value.last != null)
                                  setState(() {
                                    startDate = value.first;
                                    lastDate = value.last;
                                  });
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            'Last 3 Months',
                            size: 16,
                            bold: tempRadioOption == 2
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: AppTheme.brownishGrey,
                          ),
                          Radio(
                            value: 2,
                            groupValue: tempRadioOption,
                            onChanged: (value) {
                              tempRadioOption = value as int;
                              final value1 = last3Months();
                              if (value1.first != null && value1.last != null)
                                setState(() {
                                  startDate = value1.first;
                                  lastDate = value1.last;
                                });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            'All',
                            size: 16,
                            bold: tempRadioOption == 3
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: AppTheme.brownishGrey,
                          ),
                          Radio(
                            value: 3,
                            groupValue: tempRadioOption,
                            onChanged: (value) async {
                              tempRadioOption = value as int;
                              all().then((value) {
                                if (value.first != null && value.last != null)
                                  setState(() {
                                    startDate = value.first;
                                    lastDate = value.last;
                                  });
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            'Date Range',
                            size: 16,
                            bold: tempRadioOption == 4
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: AppTheme.brownishGrey,
                          ),
                          Radio(
                            value: 4,
                            groupValue: tempRadioOption,
                            onChanged: (value) async {
                              tempRadioOption = value as int;
                              dateRangeFilter().then((value) {
                                if (value.first != null && value.last != null)
                                  setState(() {
                                    startDate = value.first;
                                    lastDate = value.last;
                                  });
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppTheme.electricBlue,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        _selectedSort = tempSortOption;
                        _selectedFilter = tempRadioOption;
                        hideFilterString = false;
                        /* switch (tempRadioOption) {
                          case 0:
                            thisMonth(tempRadioOption);
                            break;
                          case 1:
                            singleDay(tempRadioOption);
                            break;
                          case 2:
                            last3Months(tempRadioOption);
                            break;
                          case 3:
                            all(tempRadioOption);
                            break;
                          case 4:
                            dateRangeFilter(tempRadioOption);
                            break;
                          default:
                            thisMonth(tempRadioOption);
                        } */
                        getBusinessData();
                        Navigator.of(context).pop();
                      },
                      child: CustomText(
                        'VIEW RESULT',
                        color: Colors.white,
                        size: (18),
                        bold: FontWeight.w500,
                      ),
                    ),
                  ),
                  20.0.heightBox,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List> singleDay() async {
    DateTime? _start;
    DateTime? _end;

    final selectedDate = await showCustomDatePicker(context,
        firstDate: DateTime(2000),
        initialDate: DateTime.now(),
        lastDate: DateTime.now());
    if (selectedDate != null) {
      // _selectedFilter = tempRadioOption;
      _start =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      _end = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);
      // getBusinessData();
      // Navigator.of(context).pop();
    }
    return [_start, _end];
  }

  List lastWeek() {
    DateTime? _start;
    DateTime? _end;
    // _selectedFilter = tempRadioOption;
    _start = (DateTime.now().subtract(Duration(days: 7)))
        .subtract(Duration(days: DateTime.now().weekday - 1))
        .date;
    _end = (DateTime.now().subtract(Duration(days: 7)))
        .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday))
        .date
        .add(Duration(hours: 23, minutes: 59, seconds: 59));
    // getBusinessData();
    // Navigator.of(context).pop();
    return [_start, _end];
  }

  List last3Months() {
    DateTime? _start;
    DateTime? _end;
    // _selectedFilter = tempRadioOption;
    _start = DateTime(DateTime.now().year, DateTime.now().month - 2, 1);
    _end =
        DateTime.now().date.add(Duration(hours: 23, minutes: 59, seconds: 59));
    // getBusinessData();
    // Navigator.of(context).pop();
    return [_start, _end];
  }

  Future<List> all() async {
    DateTime? _start;
    DateTime? _end;
    final date = await repository.queries.oldestCustomerTransactionData();
    _start = date;
    _end =
        DateTime.now().date.add(Duration(hours: 23, minutes: 59, seconds: 59));
    // _selectedFilter = tempRadioOption;
    // getBusinessData();

    // Navigator.of(context).pop();
    return [_start, _end];
  }

  List thisMonth() {
    DateTime? _start;
    DateTime? _end;
    // _selectedFilter = tempRadioOption;
    _start = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _end =
        DateTime.now().date.add(Duration(hours: 23, minutes: 59, seconds: 59));
    // getBusinessData();
    // Navigator.of(context).pop();
    return [_start, _end];
  }

  Future<List> dateRangeFilter() async {
    DateTime? _start;
    DateTime? _end;
    final selectedDate = await showCustomDatePicker(context,
        firstDate: DateTime(DateTime.now().year - 5),
        initialDate: startDate,
        lastDate: lastDate);
    if (selectedDate != null) {
      final selectedDate1 = await showCustomDatePicker(context,
          firstDate: selectedDate,
          initialDate: lastDate,
          lastDate: DateTime.now());
      if (selectedDate1 != null) {
        _start = selectedDate;
        // _selectedFilter = tempRadioOption;
        _end = selectedDate1;
        // getBusinessData();
      }
    }
    return [_start, _end];
    // Navigator.of(context).pop();
  }

  static String getSortString(int index) {
    switch (index) {
      case 0:
        return 'Businesses';
      case 1:
        return 'A-Z';
      case 2:
        return 'Highest you will give';
      case 3:
        return 'Highest you will get';
      default:
    }
    return '';
  }

  static String getDurationString(int index) {
    switch (index) {
      case 0:
        return 'this month';
      case 1:
        return 'single day';
      case 2:
        return 'last 3 months';

      case 3:
        return 'all records';
      case 4:
        return 'selected date range';

      default:
    }
    return '';
  }

  Future<void> downloadPdfSheet() async {
    int tempRadioOption = 0;
    bool isLoading = false;
    await showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            height: 240,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 6,
                      width: 42,
                      decoration: BoxDecoration(
                          color: AppTheme.greyish,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 10, bottom: 10),
                  child: Text(
                    'Select Report Type',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppTheme.brownishGrey),
                  ),
                ),
                RadioListTile(
                  dense: true,
                  activeColor: AppTheme.electricBlue,
                  value: 0,
                  groupValue: tempRadioOption,
                  onChanged: (value) {
                    setState(() {
                      tempRadioOption = value as int;
                    });
                  },
                  title: Text(
                    'Detailed Report',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppTheme.brownishGrey),
                  ),
                ),
                RadioListTile(
                  dense: true,
                  activeColor: AppTheme.electricBlue,
                  value: 1,
                  groupValue: tempRadioOption,
                  onChanged: (value) {
                    setState(() {
                      tempRadioOption = value as int;
                    });
                  },
                  title: Text(
                    'Summary Report',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppTheme.brownishGrey),
                  ),
                ),
                10.0.heightBox,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator(color: AppTheme.electricBlue,))
                      : NewCustomButton(
                          text: 'DOWNLOAD',
                          textSize: 18,
                          textColor: Colors.white,
                          onSubmit: isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final businessList = businesses;
                                  if (tempRadioOption == 0)
                                    businessList.removeWhere((element) =>
                                        element.customerCount == 0);
                                  final path = tempRadioOption == 0
                                      ? await GlobalPdfGenerator(
                                              businesses: businessList,
                                              endDate: lastDate,
                                              startDate: startDate,
                                              selectedFilter: _selectedFilter)
                                          .savePdf()
                                      : await GlobalSummaryPdfGenerator(
                                              businesses: businessList,
                                              endDate: lastDate,
                                              startDate: startDate,
                                              selectedFilter: _selectedFilter,
                                              totalPay: totalReceive,
                                              totalReceive: totalPay)
                                          .savePdf();
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.of(context).pop();
                                  await showNotification(
                                      1,
                                      'GlobalReport Pdf Downloaded',
                                      path.split('/').last,
                                      {'pdfPath': path});
                                  // Navigator.of(context).pushNamed(
                                  //     AppRoutes.pdfPreviewScreen,
                                  //     arguments: path);
                                },
                        ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class GlobalReportModel extends Equatable {
  final int customerCount;
  final double pay;
  final double receive;
  final String businessname;
  final List<GlobalCustomerModel> globalCustomers;

  GlobalReportModel(this.customerCount, this.pay, this.receive,
      this.businessname, this.globalCustomers);

  @override
  List<Object?> get props => [customerCount, pay, receive, businessname];
}

class GlobalCustomerModel extends Equatable {
  final String name;
  final String mobile;
  final TransactionType type;
  final double amount;

  GlobalCustomerModel(this.name, this.mobile, this.type, this.amount);

  @override
  List<Object?> get props => [name, mobile, type, amount];
}
