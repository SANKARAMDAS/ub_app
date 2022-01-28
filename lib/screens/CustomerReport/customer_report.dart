import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/CustomerReport/customer_pdf_generator.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import '../../Utility/app_constants.dart';

class CustomerReport extends StatefulWidget {
  @override
  _CustomerReportState createState() => _CustomerReportState();
}

class _CustomerReportState extends State<CustomerReport> {
  bool isHightSubtracted = false;
  late double height;
  late TextEditingController searchController = TextEditingController();
  final Repository repository = Repository();
  List<CustomerModel> customers = [];
  double youWillGet = 0;
  double youWillGive = 0;
  DateTime? startDate;
  DateTime? lastDate;
  int _selectedFilter = 0;
  final ValueNotifier<double?> updateYouGaveTile = ValueNotifier(null);
  final ValueNotifier<double?> updateYouGotTile = ValueNotifier(null);
  DateTime? firstRecordDate;

  @override
  void initState() {
    BlocProvider.of<ContactsCubit>(context).filterContacts(1, 1);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    updateYouGaveTile.dispose();
    updateYouGotTile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isHightSubtracted) {
      height =
          deviceHeight - appBarHeight - MediaQuery.of(context).viewPadding.top;
      isHightSubtracted = true;
    }
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<ContactsCubit>(context).filterContacts(1, 1);
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: AppTheme.paleGrey,
          bottomNavigationBar: bottomDownloadButton(context),
          appBar: AppBar(
            title: const Text('View Report'),
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                onPressed: () {
                  BlocProvider.of<ContactsCubit>(context).filterContacts(1, 1);
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 22,
                ),
              ),
            ),
          ),
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Container(
                  clipBehavior: Clip.none,
                  height: height * 0.17,
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(AppAssets.backgroundImage),
                          alignment: Alignment.topCenter)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Column(
                    children: [
                      (height * 0.01).heightBox,
                      balanceSummary(context),
                      searchField(context, 1, 1),
                      payReceiveButtons(context),
                      entries()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget balanceSummary(context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppTheme.electricBlue,
              width: 0.5,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Net Balance',
                    style: TextStyle(
                        color: AppTheme.electricBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  ValueListenableBuilder<double?>(
                      valueListenable: updateYouGaveTile,
                      builder: (context, youGave, _) {
                        return ValueListenableBuilder<double?>(
                            valueListenable: updateYouGotTile,
                            builder: (context, youGot, _) {
                              return RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyText2,
                                  children: [
                                    TextSpan(
                                      text: '$currencyAED  ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.electricBlue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ((youGave ?? 0) + (youGot ?? 0))
                                              .isNegative
                                          ? removeDecimalif0(((youGave ?? 0) +
                                                  (youGot ?? 0)))
                                              .substring(1)
                                          : removeDecimalif0(
                                              ((youGave ?? 0) + (youGot ?? 0))),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.electricBlue,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                      }),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: AppTheme.electricBlue,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final selectedDate = await showCustomDatePicker(context,
                          firstDate: DateTime(DateTime.now().year - 5),
                          initialDate: startDate ?? DateTime.now(),
                          lastDate: lastDate ?? DateTime.now());
                      if (selectedDate != null) {
                        startDate = selectedDate;

                        _selectedFilter = 4;
                        BlocProvider.of<ContactsCubit>(context)
                            .sortCustomersByDateRange(
                                DateTime(startDate!.year, startDate!.month,
                                    startDate!.day),
                                (lastDate != null)
                                    ? DateTime(lastDate!.year, lastDate!.month,
                                        lastDate!.day)
                                    : DateTime.now().date);

                        setState(() {});
                      }
                    },
                    child: Text(
                      startDate == null
                          ? 'START DATE'
                          : DateFormat('dd MMM yyyy')
                              .format(startDate!)
                              .toUpperCase(),
                      style: TextStyle(
                          color: AppTheme.electricBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color: AppTheme.electricBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text: lastDate == null
                              ? 'END DATE'
                              : DateFormat('dd MMM yyyy')
                                  .format(lastDate!)
                                  .toUpperCase(),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final selectedDate = await showCustomDatePicker(
                                  context,
                                  firstDate: startDate ?? firstRecordDate!.date,
                                  initialDate: lastDate ?? DateTime.now(),
                                  lastDate: DateTime.now());
                              if (selectedDate != null) {
                                lastDate = selectedDate;

                                _selectedFilter = 4;
                                BlocProvider.of<ContactsCubit>(context)
                                    .sortCustomersByDateRange(
                                        (startDate != null)
                                            ? DateTime(
                                                startDate!.year,
                                                startDate!.month,
                                                startDate!.day)
                                            : firstRecordDate!.date,
                                        DateTime(lastDate!.year,
                                            lastDate!.month, lastDate!.day));

                                setState(() {});
                              }
                            },
                        ),
                        WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Image.asset(
                              AppAssets.dateIcon,
                              height: 18,
                              color: AppTheme.electricBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  static String getSelectedFilterName(int selectedOption) {
    switch (selectedOption) {
      case 0:
        return 'ALL';
      case 1:
        return 'SINGLE DAY';
      case 2:
        return 'LAST WEEK';
      case 3:
        return 'LAST MONTH';
      case 4:
        return 'DATE RANGE';
      default:
        return 'ALL';
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                RadioListTile(
                  dense: true,
                  activeColor: AppTheme.electricBlue,
                  value: 0,
                  groupValue: tempRadioOption,
                  onChanged: (value) {
                    tempRadioOption = value as int;

                    setState(() {});
                  },
                  title: Text(
                    'All',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: tempRadioOption == 0
                            ? Colors.black
                            : AppTheme.brownishGrey),
                  ),
                ),
                RadioListTile(
                  dense: true,
                  activeColor: AppTheme.electricBlue,
                  value: 1,
                  groupValue: tempRadioOption,
                  onChanged: (value) {
                    tempRadioOption = value as int;

                    setState(() {});
                  },
                  title: Text(
                    'Single Day',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: tempRadioOption == 1
                            ? Colors.black
                            : AppTheme.brownishGrey),
                  ),
                ),
                RadioListTile(
                  dense: true,
                  activeColor: AppTheme.electricBlue,
                  value: 2,
                  groupValue: tempRadioOption,
                  onChanged: (value) {
                    tempRadioOption = value as int;

                    setState(() {});
                  },
                  title: Text(
                    'Last Week',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: tempRadioOption == 2
                            ? Colors.black
                            : AppTheme.brownishGrey),
                  ),
                ),
                RadioListTile(
                  dense: true,
                  value: 3,
                  groupValue: tempRadioOption,
                  onChanged: (value) {
                    tempRadioOption = value as int;

                    setState(() {});
                  },
                  title: Text(
                    'Last Month',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: tempRadioOption == 3
                            ? Colors.black
                            : AppTheme.brownishGrey),
                  ),
                ),
                RadioListTile(
                  dense: true,
                  activeColor: AppTheme.electricBlue,
                  value: 4,
                  groupValue: tempRadioOption,
                  onChanged: (value) async {
                    tempRadioOption = value as int;

                    setState(() {});
                  },
                  title: Text(
                    'Date Range',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: tempRadioOption == 4
                            ? Colors.black
                            : AppTheme.brownishGrey),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppTheme.electricBlue,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'SET DURATION',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      onPressed: () async {
                        if (tempRadioOption == 0) {
                          startDate = null;
                          lastDate = null;
                          _selectedFilter = tempRadioOption;
                          BlocProvider.of<ContactsCubit>(context)
                              .sortCustomersByDateRange(null, null);
                        } else if (tempRadioOption == 1) {
                          final selectedDate = await showCustomDatePicker(
                              context,
                              firstDate: DateTime(2000),
                              initialDate: DateTime.now(),
                              lastDate: DateTime.now());
                          if (selectedDate != null) {
                            _selectedFilter = tempRadioOption;
                            lastDate = startDate = DateTime(selectedDate.year,
                                selectedDate.month, selectedDate.day);
                            BlocProvider.of<ContactsCubit>(context)
                                .sortCustomersByDateRange(startDate, lastDate);
                            searchController.clear();
                          }
                        } else if (tempRadioOption == 2) {
                          _selectedFilter = tempRadioOption;
                          startDate = (DateTime.now()
                                  .subtract(Duration(days: 7)))
                              .subtract(
                                  Duration(days: DateTime.now().weekday - 1))
                              .date;
                          lastDate =
                              (DateTime.now().subtract(Duration(days: 7)))
                                  .add(Duration(
                                      days: DateTime.daysPerWeek -
                                          DateTime.now().weekday))
                                  .date;
                          BlocProvider.of<ContactsCubit>(context)
                              .sortCustomersByDateRange(startDate, lastDate);
                          searchController.clear();
                        } else if (tempRadioOption == 3) {
                          _selectedFilter = tempRadioOption;
                          startDate = DateTime(
                              DateTime.now().year, DateTime.now().month - 1, 1);
                          lastDate = DateTime(
                              DateTime.now().year, DateTime.now().month, 0);
                          BlocProvider.of<ContactsCubit>(context)
                              .sortCustomersByDateRange(startDate, lastDate);
                          searchController.clear();
                        } else if (tempRadioOption == 4) {
                          final selectedDate = await showCustomDatePicker(
                              context,
                              firstDate: DateTime(DateTime.now().year - 5),
                              initialDate: startDate ?? DateTime.now(),
                              lastDate: lastDate ?? DateTime.now());
                          if (selectedDate != null) {
                            final selectedDate1 = await showCustomDatePicker(
                                context,
                                firstDate: selectedDate,
                                initialDate: lastDate ?? DateTime.now(),
                                lastDate: DateTime.now());
                            if (selectedDate1 != null) {
                              startDate = selectedDate;
                              _selectedFilter = tempRadioOption;
                              lastDate = selectedDate1;
                              _selectedFilter = 4;
                              BlocProvider.of<ContactsCubit>(context)
                                  .sortCustomersByDateRange(
                                      DateTime(startDate!.year,
                                          startDate!.month, startDate!.day),
                                      DateTime(lastDate!.year, lastDate!.month,
                                          lastDate!.day));
                              searchController.clear();
                            }
                          }
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget payReceiveButtons(context) => Container(
        width: double.infinity,
        // color: Colors.white,
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    // width: 158,
                    // height: 95.r,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 10.0.widthBox,
                        // Image.asset(
                        //   AppAssets.payIconActive,
                        //   height: 35,
                        // ),
                        // SizedBox(
                        //   width: 5,
                        // ),
                        ValueListenableBuilder<double?>(
                            valueListenable: updateYouGaveTile,
                            builder: (context, value, _) {
                              return Column(
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
                                          text: ' You Gave',
                                          style: TextStyle(
                                            color: AppTheme.brownishGrey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
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
                                          fontSize: 16,
                                          color: AppTheme.tomato,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                              text: value?.getFormattedCurrency
                                                      .replaceAll('-', '') ??
                                                  '0',
                                              style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  )
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  color: AppTheme.brownishGrey,
                  indent: 10,
                  endIndent: 10,
                ),
                Expanded(
                  child: Container(
                    // width: 158,
                    // height: 95,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 10.0.widthBox,
                        // Image.asset(
                        //   AppAssets.receiveIconActive,
                        //   height: 55,
                        // ),
                        // SizedBox(
                        //   width: 5,
                        // ),
                        ValueListenableBuilder<double?>(
                            valueListenable: updateYouGotTile,
                            builder: (context, value, _) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                                          text: ' You Got',
                                          style: TextStyle(
                                            color: AppTheme.brownishGrey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.greenColor,
                                        ),
                                        children: [
                                          TextSpan(
                                              text: value?.getFormattedCurrency
                                                      .replaceAll('-', '') ??
                                                  '0',
                                              style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  )
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget searchField(BuildContext context, int filterIndex, int sortIndex) =>
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        elevation: 3,
        child: Container(
          // width: MediaQuery.of(context).size.width * 0.92,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Image.asset(
                  AppAssets.searchIcon,
                  color: AppTheme.brownishGrey,
                  height: 20,
                  scale: 1.4,
                ),
              ),
              Container(
                width: screenWidth(context) * 0.48,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10),
                child: TextFormField(
                  controller: searchController,
                  onChanged: (value) {
                    BlocProvider.of<ContactsCubit>(context)
                        .searchContacts(value);
                  },
                  style: TextStyle(
                    fontSize: 17,
                    color: AppTheme.brownishGrey,
                  ),
                  cursorColor: AppTheme.brownishGrey,
                  decoration: InputDecoration(
                      // contentPadding: EdgeInsets.only(top: 15),
                      border: InputBorder.none,
                      hintText: 'Search Entries',
                      hintStyle: TextStyle(
                          color: AppTheme.greyish,
                          fontSize: 17,
                          fontWeight: FontWeight.w500)),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await filterTransactionSheet();
                    setState(() {});
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppTheme.calculatorBlue,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            getSelectedFilterName(_selectedFilter),
                            size: 16,
                            color: AppTheme.electricBlue,
                            bold: FontWeight.w500,
                          ),
                          Icon(
                            CupertinoIcons.chevron_down,
                            size: 22,
                            color: AppTheme.brownishGrey,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  get emptyEntriesView => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          entryHeaderRow(0),
          SizedBox(
            height: 5,
          ),
          Container(
            height: height * 0.58,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ).flexible,
                  Image.asset(
                    'assets/images/addYourFirstCustomer.png',
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  Center(
                    child: CustomText(
                      'No Entries!',
                      color: AppTheme.brownishGrey,
                      size: 22,
                      centerAlign: true,
                      bold: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ).flexible,
        ],
      ).flexible;

  Widget entries() {
    return BlocBuilder<ContactsCubit, ContactsState>(
      buildWhen: (state1, state2) {
        return true;
      },
      builder: (context, state) {
        if (state is FetchedContacts) {
          customers = state.customerList;
          customers = customers
              .where((element) => element.transactionAmount != 0)
              .toList();
          Future.delayed(Duration.zero, () {
            getTotalPaid();
            getTotalReceived();
          });

          if (customers.isEmpty) {
            updateYouGotTile.value = null;
            return emptyEntriesView;
          }
          if (firstRecordDate == null)
            firstRecordDate = customers.last.updatedDate!.date;
          return Container(
            height: height * 0.58,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                entryHeaderRow(customers.length),
                CustomerListWidget(customers),
              ],
            ),
          ).flexible;
        }
        if (state is SearchedContacts) {
          customers = state.searchedCustomerList;
          customers = customers
              .where((element) => element.transactionAmount != 0)
              .toList();
          // customers.removeWhere((element) => element.transactionAmount == 0);
          Future.delayed(Duration.zero, () {
            getTotalPaid();
            getTotalReceived();
          });
          if (customers.isEmpty) {
            return emptyEntriesView;
          }
          if (firstRecordDate == null)
            firstRecordDate = customers.last.updatedDate!.date;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              entryHeaderRow(customers.length),
              CustomerListWidget(customers),
            ],
          ).flexible;
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget entryHeaderRow(int count) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 20, left: 10),
          child: Row(
            children: [
              Container(
                width: screenWidth(context) * 0.43,
                child: Text(
                  'Entries ($count)',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.brownishGrey),
                ),
              ),
              Container(
                width: screenWidth(context) * 0.17,
                alignment: Alignment.centerRight,
                child: Text(
                  'You Gave',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: screenWidth(context) * 0.24,
                alignment: Alignment.centerRight,
                child: Text(
                  'You Got',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        10.0.heightBox,
      ],
    );
  }

  Widget bottomDownloadButton(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: updateYouGotTile,
        builder: (context, snapshot, _) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, isPlatformiOS() ? 20: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppTheme.electricBlue,
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: customers.isEmpty
                  ? null
                  : () async {
                      final path = await CustomerReportPdfGenerator(
                              customers,
                              updateYouGaveTile.value ?? 0,
                              updateYouGotTile.value ?? 0,
                              businessName: Provider.of<BusinessProvider>(
                                      context,
                                      listen: false)
                                  .selectedBusiness
                                  .businessName)
                          .savePdf();
                      await showNotification(1, 'Pdf Downloaded',
                          path.split('/').last, {'pdfPath': path});
                      // Navigator.of(context).pushNamed(
                      //     AppRoutes.pdfPreviewScreen,
                      //     arguments: path);
                    },
              child: CustomText('Download'.toUpperCase(),
                  color: Colors.white, size: 18, bold: FontWeight.w500),
            ),
          );
        });
  }

  void getTotalPaid() {
    double amount = 0;
    customers.forEach((element) {
      if (element.transactionType == TransactionType.Pay)
        amount += element.transactionAmount!;
    });
    updateYouGaveTile.value = amount;
  }

  void getTotalReceived() {
    double amount = 0;
    customers.forEach((element) {
      if (element.transactionType == TransactionType.Receive)
        amount += element.transactionAmount!;
    });
    updateYouGotTile.value = amount;
  }
}

class CustomerListWidget extends StatefulWidget {
  final List<CustomerModel> _customerList;
  CustomerListWidget(
    this._customerList, {
    Key? key,
  }) : super(key: key);
  @override
  _CustomerListWidgetState createState() => _CustomerListWidgetState();
}

class _CustomerListWidgetState extends State<CustomerListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: widget._customerList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.zero,
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
                          if (widget._customerList[index].name!.isNotEmpty)
                            Container(
                              width: screenWidth(context) * 0.39,
                              child: Text(
                                widget._customerList[index].name!,
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
                            child: RichText(
                              text: TextSpan(
                                  text: 'Bal. ',
                                  style: TextStyle(
                                      color: Color(0xff666666),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                  children: [
                                    TextSpan(text: '$currencyAED '),
                                    TextSpan(
                                        text: widget._customerList[index]
                                                .transactionAmount!.isNegative
                                            ? removeDecimalif0(widget
                                                    ._customerList[index]
                                                    .transactionAmount)
                                                .substring(1)
                                            : removeDecimalif0(widget
                                                ._customerList[index]
                                                .transactionAmount),
                                        style: TextStyle(
                                            color: widget._customerList[index]
                                                        .transactionType ==
                                                    TransactionType.Pay
                                                ? Color(0xff666666)
                                                : Color(0xff666666),
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 0),
                            child: RichText(
                              text: TextSpan(
                                text: DateFormat('dd MMM yyyy | hh:mmaa')
                                    .format(widget
                                        ._customerList[index].updatedDate!),
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 13,
                                ),
                              ),
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
                        widget._customerList[index].transactionType ==
                                TransactionType.Pay
                            ? '-$currencyAED ${removeDecimalif0(widget._customerList[index].transactionAmount).substring(1)}'
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
                    width: screenWidth(context) * 0.257,
                    height: screenHeight(context) * 0.1,
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, right: 15, bottom: 15, left: 15),
                      child: Text(
                        widget._customerList[index].transactionType ==
                                TransactionType.Receive
                            ? '+$currencyAED ${removeDecimalif0(widget._customerList[index].transactionAmount)}'
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
          );
        }).flexible;
  }
}
