import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Cashbook/cashbook_cubit.dart';
import 'package:urbanledger/Models/cashbook_entry_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/CashbookScreens/cashbook_list_view.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import '../Components/extensions.dart';

class CashbookList extends StatefulWidget {
  @override
  _CashbookListState createState() => _CashbookListState();
}

class _CashbookListState extends State<CashbookList> {
  final Repository repository = Repository();
  bool isHightSubtracted = false;
  late double height;
  DateTime selectedDate = DateTime.now().date;
  late bool enableInOut;

  @override
  void initState() {
    super.initState();
    enableInOut = selectedDate == DateTime.now().date;
  }

  @override
  Widget build(BuildContext context) {
    if (!isHightSubtracted) {
      height =
          deviceHeight - appBarHeight - MediaQuery.of(context).viewPadding.top;
      isHightSubtracted = true;
    }
    if (!repository.hiveQueries.isCashbookSheetShown)
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        showCashbookBottomSheet(context);
      });

    return Scaffold(
      backgroundColor: AppTheme.greyBackground,
      bottomNavigationBar: bottomButtons(context),
      appBar: AppBar(
        title: Text('Cashbook'),
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
          Padding(
            padding: EdgeInsets.only(right: 20, top: 15, bottom: 15),
            child: GestureDetector(
              child: Image.asset(AppAssets.helpIcon, height: 10),
              onTap: () {
                showCashbookBottomSheet(context);
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.cashbookExpenseRoute)
                  .then((value) {
                if (value != null) {
                  selectedDate = (value as DateTime).date;
                  if (selectedDate != DateTime.now().date) {
                    enableInOut = false;
                  } else {
                    enableInOut = true;
                  }
                  setState(() {});
                }
              });
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
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  14.0.heightBox,
                  cashSummaryTiles(context, height),
                  // reportButton(false, context),
                  BlocBuilder<CashbookCubit, CashbookState>(
                      builder: (context, state) {
                    if (state is FetchedCashbookTransactions)
                      return state.cashbookEntryList.isEmpty
                          ? emptyEntriesView()
                          : CashbookListView(
                              cashbookList: state.cashbookEntryList,
                              selectedDate: selectedDate,
                              refreshUI: () {
                                setState(() {});
                              }).flexible;
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cashSummaryTiles(BuildContext context, double height) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 5, vertical: deviceHeight * .015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(text: '', children: [
                                WidgetSpan(
                                  child: Image.asset(
                                    AppAssets.receiveIconActive,
                                    height: 22,
                                  ),
                                ),
                                TextSpan(
                                  text: ' Cash in Hand',
                                  style: TextStyle(
                                    color: AppTheme.brownishGrey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ])),
                          SizedBox(
                            height: 5,
                          ),
                          FutureBuilder<double>(
                              future: repository.queries
                                  .getTotalCashInHandUntilDate(
                                      selectedDate,
                                      Provider.of<BusinessProvider>(context,
                                              listen: false)
                                          .selectedBusiness
                                          .businessId),
                              builder: (context, snapshot) {
                                return SizedBox(
                                  width: screenWidth(context) * 0.4,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                          text: '$currencyAED  ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: snapshot.data == null
                                                  ? AppTheme.greenColor
                                                  : (snapshot.data!.isNegative
                                                      ? AppTheme.tomato
                                                      : AppTheme.greenColor),
                                              fontWeight: FontWeight.w600),
                                          children: [
                                            TextSpan(
                                                text: snapshot.data == null
                                                    ? '0'
                                                    : (snapshot.data!.isNegative
                                                        ? (snapshot.data)!
                                                            .getFormattedCurrency
                                                            .replaceAll('-', '')
                                                        : (snapshot.data)!
                                                            .getFormattedCurrency),
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ]),
                                    ),
                                  ),
                                ).flexible;
                              })
                        ],
                      ),
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
                  padding: EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: MediaQuery.of(context).size.height * .015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(text: '', children: [
                                WidgetSpan(
                                  child: Image.asset(
                                    AppAssets.moneyBagIcon,
                                    height: 22,
                                  ),
                                ),
                                TextSpan(
                                  text: ' Today’s Balance',
                                  style: TextStyle(
                                    color: AppTheme.brownishGrey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ])),
                          SizedBox(
                            height: 5,
                          ),
                          FutureBuilder<double>(
                              future: repository.queries.dailyBalance(
                                  selectedDate,
                                  Provider.of<BusinessProvider>(context,
                                          listen: false)
                                      .selectedBusiness
                                      .businessId),
                              builder: (context, snapshot) {
                                return SizedBox(
                                  width: screenWidth(context) * 0.4,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                          text: '$currencyAED  ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: snapshot.data == null
                                                  ? AppTheme.greenColor
                                                  : (snapshot.data!.isNegative
                                                      ? AppTheme.tomato
                                                      : AppTheme.greenColor),
                                              fontWeight: FontWeight.w600),
                                          children: [
                                            TextSpan(
                                                text: snapshot.data == null
                                                    ? '0'
                                                    : (snapshot.data!.isNegative
                                                        ? (snapshot.data)!
                                                            .getFormattedCurrency
                                                            .replaceAll('-', '')
                                                        : (snapshot.data)!
                                                            .getFormattedCurrency),
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ]),
                                    ),
                                  ),
                                ).flexible;
                              })
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget emptyEntriesView() => Container(
        height: height * 0.77,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: deviceHeight * 0.1,
            ).flexible,
            Image.asset(
              AppAssets.emptyEntriesImage,
              height: deviceHeight * 0.3,
            ),
            FittedBox(
              child: CustomText(
                selectedDate == DateTime.now().date
                    ? 'Hi! Let\'s make today\'s entries'
                    : 'No entries exist for ' +
                        DateFormat('dd MMM').format(selectedDate),
                color: AppTheme.brownishGrey,
                size: 20,
                centerAlign: true,
                bold: FontWeight.w500,
              ),
            ),
            if (selectedDate != DateTime.now().date)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: FittedBox(
                  child: CustomText(
                    'To add entries for this day use below button',
                    color: AppTheme.brownishGrey,
                    size: 18,
                    centerAlign: true,
                    bold: FontWeight.w400,
                  ),
                ),
              ),
            if (selectedDate == DateTime.now().date)
              SizedBox(
                height: deviceHeight * 0.1,
              ).flexible,
            if (selectedDate == DateTime.now().date)
              CustomText(
                'Add your first Cashbook\n entry here',
                color: AppTheme.brownishGrey,
                size: 22,
                centerAlign: true,
                bold: FontWeight.bold,
              ),
            SizedBox(height: 20),
            if (selectedDate == DateTime.now().date)
              Icon(
                Icons.arrow_drop_down,
                size: 62,
                color: AppTheme.electricBlue,
              )
          ],
        ),
      ).flexible;

  Widget bottomButtons(BuildContext context) => SafeArea(
    child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                // color: Colors.white,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                child: Container(
                  height: deviceHeight * 0.07,
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenWidth(context) * 0.05,
                      ),
                      if (!enableInOut)
                        Container(
                          width: screenWidth(context) * 0.9,
                          height: deviceHeight * 0.045,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: AppTheme.electricBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () async {
                              final status = await showAddEntryDialog();
                              if (status != null) {
                                enableInOut = status;
                                setState(() {});
                              }
                            },
                            child: FittedBox(
                              child: Text(
                                'ADD ENTRY TO ' +
                                    DateFormat('dd MMM')
                                        .format(selectedDate)
                                        .toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17),
                              ),
                            ),
                          ),
                        ),
                      if (enableInOut)
                        Container(
                          width: screenWidth(context) * 0.425,
                          height: deviceHeight * 0.045,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: AppTheme.electricBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.addEntryRoute,
                                      arguments: AddEntryScreenRouteArgs(
                                          null, EntryType.OUT, selectedDate))
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            child: FittedBox(
                              child: Row(
                                children: [
                                  Image.asset(
                                    AppAssets.outIcon,
                                    height: deviceHeight * 0.02,
                                  ),
                                  5.0.widthBox,
                                  Text(
                                    'OUT',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (enableInOut)
                        SizedBox(
                          width: screenWidth(context) * 0.05,
                        ),
                      if (enableInOut)
                        Container(
                          width: screenWidth(context) * 0.425,
                          height: deviceHeight * 0.045,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: AppTheme.electricBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.addEntryRoute,
                                      arguments: AddEntryScreenRouteArgs(
                                          null, EntryType.IN, selectedDate))
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            child: FittedBox(
                              child: Row(
                                children: [
                                  Image.asset(
                                    AppAssets.inIcon,
                                    height: deviceHeight * 0.02,
                                  ),
                                  5.0.widthBox,
                                  Text(
                                    'IN',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        width: screenWidth(context) * 0.05,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
  );

  Future<bool?> showAddEntryDialog() async => await showDialog(
      builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Dialog(
                insetPadding: EdgeInsets.only(left: 20, right: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 5),
                      child: CustomText(
                        'Add entry to previous date?',
                        color: AppTheme.tomato,
                        bold: FontWeight.w500,
                        size: 18,
                      ),
                    ),
                    CustomText(
                      'Changes made will affect current balance',
                      size: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: AppTheme.electricBlue,
                                ),
                                child: CustomText(
                                  'CANCEL',
                                  color: Colors.white,
                                  size: (18),
                                  bold: FontWeight.w500,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: AppTheme.electricBlue,
                                ),
                                child: CustomText(
                                  'ADD NOW',
                                  color: Colors.white,
                                  size: (18),
                                  bold: FontWeight.w500,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              35.0.heightBox,
            ],
          ),
      barrierDismissible: false,
      context: context);

  showCashbookBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 335,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
              SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomText(
                        'Manage your daily cash transactions',
                        size: 18,
                        color: AppTheme.brownishGrey,
                        bold: FontWeight.w500,
                      ),
                      15.0.heightBox,
                      Row(
                        children: [
                          Image.asset(
                            AppAssets.moneyBagIcon,
                            height: 40,
                          ),
                          2.0.widthBox,
                          FittedBox(
                              child: CustomText(
                            'Today’s balance : Daily total IN minus total OUT',
                            size: 18,
                            color: AppTheme.brownishGrey,
                            bold: FontWeight.w400,
                          ))
                        ],
                      ),
                      15.0.heightBox,
                      Row(
                        children: [
                          Image.asset(
                            AppAssets.receiveIconActive,
                            height: 40,
                          ),
                          2.0.widthBox,
                          FittedBox(
                              child: CustomText(
                            'Cash in hand : Current cash balance in drawer',
                            size: 18,
                            color: AppTheme.brownishGrey,
                            bold: FontWeight.w400,
                          ))
                        ],
                      ),
                      15.0.heightBox,
                      Row(
                        children: [
                          Image.asset(
                            AppAssets.reportIcon2,
                            height: 40,
                          ),
                          2.0.widthBox,
                          FittedBox(
                              fit: BoxFit.fill,
                              child: CustomText(
                                'PDF Reports : Download monthly or daily reports',
                                size: 18,
                                color: AppTheme.brownishGrey,
                                bold: FontWeight.w400,
                              ))
                        ],
                      ),
                      23.0.heightBox,
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              repository.hiveQueries
                                  .insertIsCashbookSheetShown(true);
                            },
                            child: CustomText(
                              'OK',
                              size: (18),
                              bold: FontWeight.w500,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: AppTheme.electricBlue,
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            )),
                      )
                    ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
