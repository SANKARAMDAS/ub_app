import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Cashbook/cashbook_cubit.dart';
import 'package:urbanledger/Models/cashbook_entry_model.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/CashbookScreens/cashbook_pdf_generator.dart';
import 'package:urbanledger/screens/Components/custom_date_picker.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';

class CashbookExpense extends StatefulWidget {
  @override
  _CashbookExpenseState createState() => _CashbookExpenseState();
}

class _CashbookExpenseState extends State<CashbookExpense> {
  bool isHightSubtracted = false;
  late double height;
  int _selectedFilter = 0;
  DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime lastDate = DateTime.now().date;
  List transactions = [];
  List<CashbookPdfModel> pdfModelList = [];
  double totalInAmount = 0;
  double totalOutAmount = 0;
  double totalOutOnlineAmount = 0;
  double totalInOnlineAmount = 0;

  List getDefaultDatesList() {
    List dates = [];
    for (var i = 0; i <= lastDate.difference(startDate).inDays; i++) {
      dates.add(startDate.date.add(Duration(days: i)));
    }
    return dates.reversed.toList();
  }

  @override
  void initState() {
    super.initState();
    transactions = getDefaultDatesList();
  }

  @override
  Widget build(BuildContext context) {
    if (!isHightSubtracted) {
      height =
          deviceHeight - appBarHeight - MediaQuery.of(context).viewPadding.top;
      isHightSubtracted = true;
    }
    return Scaffold(
      backgroundColor: AppTheme.greyBackground,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
          child: NewCustomButton(
            text: 'DOWNLOAD',
            textColor: Colors.white,
            onSubmit: transactions.isEmpty
                ? null
                : () {
                    downloadPdfSheet();
                  },
            textSize: 18,
            // backgroundColor: Color.fromRGBO(185, 206, 249,1),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Cashbook Report'),
        leading: IconButton(
          onPressed: () {
            // BlocProvider.of<CashbookCubit>(context)
            //     .sortCashbookTransactions(null);
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 22,
          ),
        ),
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(right: 20, top: 15, bottom: 15),
        //     child: GestureDetector(
        //       child: Image.asset(AppAssets.helpIcon, height: 10),
        //       onTap: () {},
        //     ),
        //   ),
        // ],
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.none,
              height: deviceHeight * 0.05,
              width: double.infinity,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(AppAssets.backgroundImage),
                      alignment: Alignment.topCenter)),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  dateTiles(context),
                  // SizedBox(height: 5,),
                  dateFilter,
                  SizedBox(
                    height: 15,
                  ),
                  listHeader,
                  scrollBody()
                ])),
          ],
        ),
      ),
    );
  }

  Widget scrollBody() {
    if (transactions.isEmpty) {
      return Container(
        height: height * 0.58,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // entryHeaderRow(state.ledgerTransactionList.length),
              Container(
                margin: EdgeInsets.only(top: height * 0.07),
                child: Image.asset(
                  AppAssets.emptyLedgerImage,
                  height: height * 0.25,
                ),
              ),
              Center(
                child: CustomText(
                  'No Entries Found',
                  color: AppTheme.brownishGrey,
                  size: 22,
                  centerAlign: true,
                  bold: FontWeight.bold,
                ),
              ).flexible,
              /* Icon(
                      Icons.arrow_drop_down,
                      size: 62,
                      color: AppTheme.electricBlue,
                    ) */
            ],
          ),
        ),
      ).flexible;
    }
    return Container(
      height: height * 0.80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListBody(
            cashbookEntryList: transactions,
          ),
          // listBody(state.cashbookEntryList)
        ],
      ),
    ).flexible;
  }

  Widget get listHeader => Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.16,
              child: Text(
                'DATE',
                style: TextStyle(
                    color: Color(0xff666666),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                // color: Colors.black,
                // width: MediaQuery.of(context).size.width * 0.29,
                alignment: Alignment.centerRight,
                child: Text(
                  'DAILY BALANCE',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: AppTheme.brownishGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            20.0.widthBox,
            Expanded(
              child: Container(
                // color: Colors.brown,
                // width: MediaQuery.of(context).size.width * 0.29,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'CASH IN HAND',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: AppTheme.brownishGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    35.0.widthBox,
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget get dateFilter => Container(
        width: double.infinity,
        height: 50,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 1, bottom: 1),
                  child: Text(
                    'Select report duration',
                    style: TextStyle(fontSize: 16, color: AppTheme.coolGrey),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 1, top: 1, bottom: 1),
                  child: NewCustomButton(
                    text: getSelectedFilterName(_selectedFilter),
                    textColor: AppTheme.brownishGrey,
                    onSubmit: () async {
                      await filterTransactionSheet();
                      setState(() {});
                    },
                    textSize: 15,
                    backgroundColor: Color.fromRGBO(185, 206, 249, 1),
                    fontWeight: FontWeight.w600,
                    suffixImage: 'assets/icons/down.png',
                    imageColor: AppTheme.brownishGrey,
                    imageSize: 10,
                  ),
                ),
              ],
            )),
      );

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
              elevation: 8,
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
                      transactions = getDefaultDatesList();
                      setState(() {});
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
              elevation: 8,
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
                      transactions = getDefaultDatesList();
                      setState(() {});
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
                        DateFormat('dd MMM yyyy')
                            .format(lastDate)
                            .toUpperCase(),
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

  static String getSelectedFilterName(int selectedOption) {
    switch (selectedOption) {
      case 0:
        return 'THIS MONTH';
      case 1:
        return 'SINGLE DAY';
      case 2:
        return 'LAST WEEK';
      case 3:
        return 'LAST MONTH';
      case 4:
        return 'ALL';
      case 5:
        return 'DATE RANGE';
      default:
        return 'THIS MONTH';
    }
  }

  String getSelectedFilterNameCap(int selectedOption) {
    switch (selectedOption) {
      case 0:
        return 'This Month';
      case 1:
        return 'Single Day';
      case 2:
        return 'Last Week';
      case 3:
        return 'Last Month';
      case 4:
        return 'All';
      case 5:
        return 'Date Range';
      default:
        return 'This Month';
    }
  }

  Future<void> filterTransactionSheet() async {
    int tempRadioOption = _selectedFilter;
    await showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            height: 390,
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
                    'Select report duration',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppTheme.brownishGrey),
                  ),
                ),
                RadioListTile(
                  dense: true,
                  activeColor: Theme.of(context).primaryColor,
                  value: 0,
                  groupValue: tempRadioOption,
                  onChanged: (value) {
                    tempRadioOption = value as int;
                    thisMonth(tempRadioOption);
                  },
                  title: Text(
                    'This month',
                    style: TextStyle(
                        fontWeight: tempRadioOption == 0
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 16,
                        color: AppTheme.brownishGrey),
                  ),
                ),
                RadioListTile(
                  dense: true,
                  activeColor: Theme.of(context).primaryColor,
                  value: 1,
                  groupValue: tempRadioOption,
                  onChanged: (value) {
                    tempRadioOption = value as int;
                    singleDay(tempRadioOption);
                  },
                  title: Text(
                    'Single Day',
                    style: TextStyle(
                        fontWeight: tempRadioOption == 1
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 16,
                        color: AppTheme.brownishGrey),
                  ),
                ),
                RadioListTile(
                  dense: true,
                  activeColor: Theme.of(context).primaryColor,
                  value: 2,
                  groupValue: tempRadioOption,
                  onChanged: (value) {
                    tempRadioOption = value as int;
                    lastWeek(tempRadioOption);
                  },
                  title: Text(
                    'Last Week',
                    style: TextStyle(
                        fontWeight: tempRadioOption == 2
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 16,
                        color: AppTheme.brownishGrey),
                  ),
                ),
                RadioListTile(
                  dense: true,
                  activeColor: Theme.of(context).primaryColor,
                  value: 3,
                  groupValue: tempRadioOption,
                  onChanged: (value) {
                    tempRadioOption = value as int;
                    lastMonth(tempRadioOption);
                  },
                  title: Text(
                    'Last Month',
                    style: TextStyle(
                        fontWeight: tempRadioOption == 3
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 16,
                        color: AppTheme.brownishGrey),
                  ),
                ),
                RadioListTile(
                  dense: true,
                  activeColor: Theme.of(context).primaryColor,
                  value: 4,
                  groupValue: tempRadioOption,
                  onChanged: (value) async {
                    tempRadioOption = value as int;
                    final date =
                        await repository.queries.getOldestDateCashbookRecord();
                    if (date == null) {
                      transactions = [];
                      _selectedFilter = tempRadioOption;
                    } else {
                      startDate = date;
                      lastDate = DateTime.now().date;
                      transactions = getDefaultDatesList();
                      _selectedFilter = tempRadioOption;
                    }
                    Navigator.of(context).pop();
                  },
                  title: Text(
                    'All',
                    style: TextStyle(
                        fontWeight: tempRadioOption == 4
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 16,
                        color: AppTheme.brownishGrey),
                  ),
                ),
                RadioListTile(
                  dense: true,
                  activeColor: AppTheme.electricBlue,
                  value: 5,
                  groupValue: tempRadioOption,
                  onChanged: (value) async {
                    tempRadioOption = value as int;
                    dateRangeFilter(tempRadioOption);
                  },
                  title: Text(
                    'Date Range',
                    style: TextStyle(
                        fontWeight: tempRadioOption == 5
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 16,
                        color: AppTheme.brownishGrey),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> singleDay(tempRadioOption) async {
    final selectedDate = await showCustomDatePicker(context,
        firstDate: DateTime(2000),
        initialDate: DateTime.now(),
        lastDate: DateTime.now());
    if (selectedDate != null) {
      _selectedFilter = tempRadioOption;
      lastDate = startDate =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      transactions = getDefaultDatesList();
      Navigator.of(context).pop();
    }
  }

  void lastWeek(tempRadioOption) {
    _selectedFilter = tempRadioOption;
    startDate = (DateTime.now().subtract(Duration(days: 7)))
        .subtract(Duration(days: DateTime.now().weekday - 1))
        .date;
    lastDate = (DateTime.now().subtract(Duration(days: 7)))
        .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday))
        .date;
    transactions = getDefaultDatesList();
    Navigator.of(context).pop();
  }

  void lastMonth(tempRadioOption) {
    _selectedFilter = tempRadioOption;
    startDate = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
    lastDate = DateTime(DateTime.now().year, DateTime.now().month, 0);
    transactions = getDefaultDatesList();
    Navigator.of(context).pop();
  }

  void thisMonth(tempRadioOption) {
    _selectedFilter = tempRadioOption;
    startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    lastDate = DateTime.now().date;
    transactions = getDefaultDatesList();
    Navigator.of(context).pop();
  }

  void dateRangeFilter(tempRadioOption) async {
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
        startDate = selectedDate;
        _selectedFilter = tempRadioOption;
        lastDate = selectedDate1;
        transactions = getDefaultDatesList();
      }
    }
    Navigator.of(context).pop();
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
                  activeColor: Theme.of(context).primaryColor,
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
                  activeColor: Theme.of(context).primaryColor,
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
                  child: NewCustomButton(
                    text: 'DOWNLOAD',
                    textSize: 18,
                    textColor: Colors.white,
                    onSubmit: isLoading
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                            });
                            pdfModelList.clear();
                            totalInAmount = 0;
                            totalOutAmount = 0;
                            totalInOnlineAmount = 0;
                            totalOutOnlineAmount = 0;
                            final detailedEntries = await repository.queries
                                .getCashbookEntrysBetweenDate(
                                    startDate,
                                    lastDate,
                                    Provider.of<BusinessProvider>(context,
                                            listen: false)
                                        .selectedBusiness
                                        .businessId);
                            await Future.wait(transactions.map((element) async {
                              final dailyBalance = await repository.queries
                                  .dailyBalance(
                                      element,
                                      Provider.of<BusinessProvider>(context,
                                              listen: false)
                                          .selectedBusiness
                                          .businessId);
                              final cashInHand = await repository.queries
                                  .getTotalCashInHandUntilDate(
                                      element,
                                      Provider.of<BusinessProvider>(context,
                                              listen: false)
                                          .selectedBusiness
                                          .businessId);
                              final inAmount = await repository.queries
                                  .getTotalCashInHand(
                                      element,
                                      Provider.of<BusinessProvider>(context,
                                              listen: false)
                                          .selectedBusiness
                                          .businessId);
                              final outAmount = await repository.queries
                                  .getTotalCashOutToday(
                                      element,
                                      Provider.of<BusinessProvider>(context,
                                              listen: false)
                                          .selectedBusiness
                                          .businessId);
                              final onlineAmount = await repository.queries
                                  .getTotalOnlineAmount(
                                      element,
                                      Provider.of<BusinessProvider>(context,
                                              listen: false)
                                          .selectedBusiness
                                          .businessId);
                              final inOnlineAmount = await repository.queries
                                  .getTotalInOnlineAmount(
                                      element,
                                      Provider.of<BusinessProvider>(context,
                                              listen: false)
                                          .selectedBusiness
                                          .businessId);
                              final outOnlineAmount = await repository.queries
                                  .getTotalOutOnlineAmount(
                                      element,
                                      Provider.of<BusinessProvider>(context,
                                              listen: false)
                                          .selectedBusiness
                                          .businessId);
                              totalInAmount += inAmount;
                              totalOutAmount += outAmount;
                              totalInOnlineAmount += inOnlineAmount;
                              totalOutOnlineAmount += outOnlineAmount;
                              pdfModelList.add(
                                CashbookPdfModel(
                                    date: element,
                                    dailyBalance: dailyBalance,
                                    cashInHand: cashInHand,
                                    inAmount: inAmount,
                                    outAmount: outAmount,
                                    onlineAmount: onlineAmount),
                              );
                            }));

                            final path = await CashbookPdfGenerator(
                                    isDetailed: tempRadioOption == 0,
                                    transactions:
                                        pdfModelList.reversed.toList(),
                                    detailedTransactions:
                                        detailedEntries.reversed.toList(),
                                    totalInAmount: totalInAmount,
                                    totalOutAmount: totalOutAmount,
                                    totalInOnlineAmount: totalInOnlineAmount,
                                    totalOutOnlineAmount: totalOutOnlineAmount,
                                    startDate: startDate,
                                    endDate: lastDate,
                                    businessName: Provider.of<BusinessProvider>(
                                            context,
                                            listen: false)
                                        .selectedBusiness
                                        .businessName,
                                    filterString: getSelectedFilterNameCap(
                                        _selectedFilter))
                                .savePdf();
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.of(context).pop();
                            await showNotification(
                              1,
                              'Cashbook Pdf Downloaded',
                              path.split('/').last,
                              {'pdfPath': path},
                            );
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

class ListBody extends StatelessWidget {
  final List cashbookEntryList;

  const ListBody({
    Key? key,
    required this.cashbookEntryList,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: cashbookEntryList.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return GestureDetector(
            onTap: () {
              BlocProvider.of<CashbookCubit>(context).getCashbookData(
                  cashbookEntryList[index],
                  Provider.of<BusinessProvider>(context, listen: false)
                      .selectedBusiness
                      .businessId);
              Navigator.of(context).pop(cashbookEntryList[index]);
            },
            child: Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    // padding: EdgeInsets.symmetric(vertical:5, horizontal:5),
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Text(
                      DateFormat('dd MMM').format(cashbookEntryList[index]),
                      style: TextStyle(
                          color: Color(0xff666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  FutureBuilder<double>(
                      future: repository.queries.dailyBalance(
                          cashbookEntryList[index],
                          Provider.of<BusinessProvider>(context, listen: false)
                              .selectedBusiness
                              .businessId),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: Container(
                            // color: Colors.black,
                            // width: MediaQuery.of(context).size.width * 0.28,
                            alignment: Alignment.centerRight,
                            child: Text(
                              '$currencyAED ' +
                                  (snapshot.data == null
                                      ? '0'
                                      : (snapshot.data!.isNegative
                                          ? removeDecimalif0(snapshot.data)
                                              .replaceAll('-', '')
                                          : removeDecimalif0(snapshot.data))),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  // color: Color(0xff666666),
                                  color: snapshot.data == null
                                      ? AppTheme.brownishGrey
                                      : (snapshot.data!.isNegative
                                          ? AppTheme.tomato
                                          : snapshot.data == 0
                                              ? AppTheme.brownishGrey
                                              : AppTheme.greenColor),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      }),
                  15.0.widthBox,
                  FutureBuilder<double>(
                      future: repository.queries.getTotalCashInHandUntilDate(
                          cashbookEntryList[index],
                          Provider.of<BusinessProvider>(context, listen: false)
                              .selectedBusiness
                              .businessId),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: Container(
                            // color: Colors.brown,
                            // width: MediaQuery.of(context).size.width * 0.28,
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '$currencyAED ' +
                                      (snapshot.data == null
                                          ? '0'
                                          : (snapshot.data!.isNegative
                                              ? removeDecimalif0(snapshot.data)
                                                  .replaceAll('-', '')
                                              : removeDecimalif0(
                                                  snapshot.data))),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      // color: Color(0xff666666),
                                      color: snapshot.data == null
                                          ? AppTheme.brownishGrey
                                          : (snapshot.data!.isNegative
                                              ? AppTheme.tomato
                                              : snapshot.data == 0
                                                  ? AppTheme.brownishGrey
                                                  : AppTheme.greenColor),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ).flexible,
                                20.0.widthBox,
                                Icon(Icons.arrow_forward_ios,
                                    color: AppTheme.electricBlue, size: 16),
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
