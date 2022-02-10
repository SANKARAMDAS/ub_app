import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
import 'package:urbanledger/Cubits/SettlementHistory/settlement_history_cubit.dart';
import 'package:urbanledger/Cubits/Suspense/suspense_cubit.dart';
import 'package:urbanledger/Models/SuspenseAccountModel.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/settlement_history_model.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Services/APIs/suspense_account_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/chat_module/data/models/message.dart';
import 'package:urbanledger/chat_module/data/repositories/chat_repository.dart';
import 'package:urbanledger/chat_module/screens/contact/payment_controller.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/SuspenseAccount/suspense_transaction_details.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:urbanledger/screens/arguments/settlement_history_argument.dart';
import 'package:uuid/uuid.dart';
import 'package:urbanledger/screens/Components/shimmer_widgets.dart';


class SettlementHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettlementHistoryCubit>(
      create: (context) =>
          SettlementHistoryCubit()..getSettlementHistoryData(true),
      child: _SettlementHistoryScreen(),
    );
  }
}

class _SettlementHistoryScreen extends StatefulWidget {
  @override
  _SettlementHistoryScreenState createState() =>
      _SettlementHistoryScreenState();
}

class _SettlementHistoryScreenState extends State<_SettlementHistoryScreen> {
  ChatRepository _chatRepository = ChatRepository();
  late PaymentController _paymentController;
  final Repository repository = Repository();
  int _selectedFilter = 2;
  int _selectedSort = 0;
  DateTime startDate =
      DateTime(DateTime.now().year, DateTime.now().month - 2, 1);
  DateTime lastDate =
      DateTime.now().date.add(Duration(hours: 23, minutes: 59, seconds: 59));
  final TextEditingController _searchController = TextEditingController();
  bool hideFilterString = true;
  bool isDataFiltered = false;
  bool isListSortedWithApp = false;
  bool isListSortedWithLink = false;
  bool isListSortedWithQrCode = false;
  bool checkedValue = false;

  /* bool isTap = false;
  bool isLinkTap = false;
  bool isQrCodeTap = false;*/

  // Color? color;

  @override
  void initState() {
    super.initState();

    //unAuthorizedTranaction();
    // color = Colors.transparent;
    // delDataFromSuspenseAccount();

    _paymentController = PaymentController(
      context: context,
    );
    if (!repository.hiveQueries.isSettlementDialogShown)
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        showSettlementHistoryBottomSheet(context,false);
      });
    //MoveSingleCustomerDataFromSuspenseAccount();
  }

  bool isSelectedAll = false; // Selected All

  bool isEmiratesIdDone = false;
  bool isTradeLicenseDone = false;
  bool status = false;
  bool isPremium = false;
  bool loading = false;
  List isChecked = [];
  List<SettlementHistoryData> data = [];
  List<SettlementHistoryData> data2 = [];
  List<SettlementHistoryData> filteredList = [];

  /* int? QrCount = 0;
  int? LinkCount = 0;
  int? AppCount = 0;*/
/*  List<SuspenseData> QrCount = [];
  List<SuspenseData> LinkCount = [];
  List<SuspenseData> AppCount = [];*/
  List<dynamic> pieData = [];

  Map<String, dynamic> dataMap = {
    "links": 0,
    "qrcode": 0,
    "app": 0,
  };

/*  Future<void> unAuthorizedTranaction() async {
    pieData = await repository.queries.unAuthorizedTranaction();

    debugPrint('pieData' + pieData[0].toString());
    dataMap = pieData[0];
    debugPrint('Check the value ' + dataMap['links'].toString());
  }*/

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /* Provider.of<BusinessProvider>(context, listen: false)
            .getBusinesses()
            .then((value) {
          if (value > 0) {
            Provider.of<BusinessProvider>(context, listen: false)
                .updateSelectedBusiness();
            BlocProvider.of<ContactsCubit>(context).getContacts(
                Provider.of<BusinessProvider>(context, listen: false)
                    .selectedBusiness
                    .businessId);
          }
        });
        moveApiLedger();*/
        Navigator.pop(context);

        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: AppTheme.paleGrey,
          appBar: appBar(context),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                top: -60,
                left: 0,
                child: Container(
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage(AppAssets.backgroundImage),
                            alignment: Alignment.topCenter))),
              ),
              Positioned.fill(
                  top: 0,
                  left: 0,
                  child: loading == true
                      ? Center(
                          child: CircularProgressIndicator(color: AppTheme.electricBlue,),
                        )
                      : Column(
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            // (MediaQuery.of(context).padding.top).heightBox,
                            BlocBuilder<SettlementHistoryCubit,
                                SettlementHistoryState>(
                              builder: (context, state) {
                                if (state is FetchingSettlementHistory)
                                  return Container(
                                    child: Column(
                                      children: [
                                        ShimmerListTile(),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05),
                                        Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.1),
                                            alignment: Alignment.centerLeft,
                                            child: ShimmerText()),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                          ),
                                          alignment: Alignment.center,
                                          child: ShimmerButton(),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1),
                                          alignment: Alignment.center,
                                          child: ShimmerButton(),
                                        ),
                                        Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.1),
                                            alignment: Alignment.center,
                                            child: ShimmerButton()),
                                        Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.1),
                                            alignment: Alignment.center,
                                            child: ShimmerButton()),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1),
                                          alignment: Alignment.center,
                                          child: ShimmerButton(),
                                        ),
                                      ],
                                    ),
                                  );

                                if (state is FetchedSettlementHistory) {
                                  data = state.settlementHistoryDataList;
                                  data.sort((a, b) {
                                    var adate = a
                                        .createdAt; //before -> var adate = a.expiry;
                                    var bdate =
                                        b.createdAt; //var bdate = b.expiry;
                                    return -adate!.compareTo(bdate!);
                                  });

                                  if (data.isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          payReceiveButtons(true),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Image.asset(
                                                    'assets/images/Suspense account image-01.png',
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  // _selectedFilter = 0;
                                  _selectedSort = 0;

                                  /*LinkCount = data.where((element) {
                            return element.type == 'LINK';
                          }).toList();

                          AppCount = data.where((element) {
                            return element.type == 'DIRECT';
                          }).toList();

                          QrCount = data.where((element) {
                            return element.type == 'QRCODE';
                          }).toList();*/

                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: customerListWithOtherWidgets(
                                        data, _selectedFilter, _selectedSort),
                                  );
                                }
                                if (state is SearchedSettlementHistory) {
                                  // hideFilterString = false;
                                  data = state.searchedSettlementHistoryList;

                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: customerListWithOtherWidgets(data,
                                        _selectedFilter, state.selectedSort),
                                  );
                                }
                                return Container();
                              },
                            ).flexible,
                          ],
                        ))
            ],
          ),
        ),
      ),
    );
  }

  Widget customerListWithOtherWidgets(
      List<SettlementHistoryData> settlementHistoryList,
      filterIndex,
      sortIndex) {
    //customerList = [];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        payReceiveButtons(false),
        Expanded(
          child: Column(
            children: [
              // searchField(filterIndex ?? 1, sortIndex ?? 1),
              if (!hideFilterString)
                filterIndex != null && sortIndex != null
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, top: 15),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppTheme.carolinaBlue.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                filterIndex != null && sortIndex != null
                                    ? CustomText(
                                        'Showing list of ${getDurationString(filterIndex)}${getSortString(sortIndex)}',
                                        color: AppTheme.brownishGrey,
                                        size: 16,
                                      )
                                    : Container(),
                                GestureDetector(
                                  child: Icon(Icons.close_sharp,
                                      color: AppTheme.brownishGrey),
                                  onTap: () {
                                    _selectedFilter = 2;
                                    _selectedSort = 0;

                                    BlocProvider.of<SettlementHistoryCubit>(
                                            context)
                                        .getSettlementHistoryData(false);
                                    setState(() {
                                      hideFilterString = true;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 15, top: 15),
                    child: Text(
                      // if ('${isChecked.length <= 1}') {
                      //    return '${isChecked.length} Transaction Selected',
                      // }
                      // else{
                      //   '${isChecked.length} Transactions Selected',
                      // }
                      settlementHistoryList.length <= 1
                          ? '${settlementHistoryList.length} Transaction'
                          : '${settlementHistoryList.length} Transactions',
                      style: TextStyle(
                          color: Color(0xff666666),
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.0, top: 8),
                      child: Image.asset(
                        AppAssets.filterIcon,
                        color: AppTheme.brownishGrey,
                        height: 18,
                        // scale: 1.5,
                      ),
                    ),
                    onTap: () async {
                      await filterBottomSheet(context);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              settlementHistoryList.isEmpty
                  ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            child: Container(
                                alignment: Alignment.center,
                                height: 250,
                                child: Image.asset(
                                  AppAssets.noTransactionsFound,
                                )),
                          ),
                        ],
                      ),
                    )
                  : getList(settlementHistoryList)
            ],
          ),
        )
      ],
    );
  }

  Widget searchField(int filterIndex, int sortIndex) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  width: screenWidth(context) * 0.7,
                  child: TextFormField(
                    // textAlignVertical: TextAlignVertical.center,
                    controller: _searchController,
                    onChanged: (value) {
                      BlocProvider.of<SuspenseCubit>(context)
                          .searchTransactions(value);
                    },
                    style: TextStyle(
                      fontSize: 17,
                      color: AppTheme.brownishGrey,
                    ),
                    cursorColor: AppTheme.brownishGrey,
                    decoration: InputDecoration(
                        // contentPadding: EdgeInsets.only(top: 15),
                        border: InputBorder.none,
                        hintText: 'Search Customers, Name, Phone',
                        hintStyle: TextStyle(
                            color: Color(0xffb6b6b6),
                            fontSize: 17,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Image.asset(
                          AppAssets.filterIcon,
                          color: AppTheme.brownishGrey,
                          height: 18,
                          // scale: 1.5,
                        ),
                      ),
                      onTap: () async {
                        await filterBottomSheet(context);
                        if (_selectedFilter != 1 || _selectedSort != 1)
                          setState(() {
                            hideFilterString = false;
                          });
                      },
                    ),
                    // if (filterIndex != 1 || sortIndex != 1)
                    //   Positioned(
                    //     right: 14,
                    //     top: -3,
                    //     child: ClipRRect(
                    //       borderRadius: BorderRadius.circular(25),
                    //       child: Container(
                    //         color: AppTheme.tomato,
                    //         height: 9,
                    //         width: 9,
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  AppBar appBar(BuildContext context) => AppBar(
        elevation: 0,
        title: Text('Settlement History'),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
            // onPressed: () => Navigator.of(context)..pop(),
            onPressed: () async {
              Navigator.pop(context);

              // Navigator.popAndPushNamed(
              //     context, AppRoutes.myProfileScreenRoute);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20, top: 15, bottom: 15),
            child: GestureDetector(
              child: Image.asset(AppAssets.helpIcon, height: 10),
              onTap: () {
                showSettlementHistoryBottomSheet(context,true);
              },
            ),
          ),
        ],

      );




  showSettlementHistoryBottomSheet(BuildContext context,bool disableSkip) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                AppAssets.info_01,
                                height: 35,
                              ),
                              15.0.heightBox,
                              CustomText(
                                'Manage your Settlement',
                                size: 20,
                                color: AppTheme.brownishGrey,
                                bold: FontWeight.bold,
                              ),
                              15.0.heightBox,
                              CustomText(
                                'Settlement is the process through which a merchant receives money paid by their end users for a particular product/service. The amount will get credited to the merchant’s account in 48 hours once settlement is done.',
                                size: 18,
                                centerAlign: true,
                                color: AppTheme.brownishGrey,
                                bold: FontWeight.w400,
                              ),
                              15.0.heightBox,
                              disableSkip?Container():CheckboxListTile(
                                title: Text("Do not show me this message again"),
                                value: checkedValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedValue = newValue!;
                                  });
                                  repository.hiveQueries
                                      .insertIsSettlementSheetShown(checkedValue);
                                },
                                controlAffinity: ListTileControlAffinity
                                    .leading, //  <-- leading Checkbox
                              ),
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: CustomText(
                                      'OK',
                                      color: AppTheme.whiteColor,
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
                            ])),
                  ],
                ),
              );
            });
      },
    );
  }

  Widget payReceiveButtons(bool isCustomerEmpty) => Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(6, 5, 6, 5),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: IntrinsicHeight(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          20) // use instead of BorderRadius.all(Radius.circular(20))
                      ),
                  // width: size.width * 0.425,
                  // height: 95.r,

                  padding: EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: MediaQuery.of(context).size.height * .010),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            // or ClipRRect if you need to clip the content
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200], // inner circle color
                            ),
                          ),
                          Image.asset(
                            AppAssets.settlementTotalIcon,
                            height: 30,
                            width: 30,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(text: '', children: [
                                TextSpan(
                                  text: 'Total Settled Amount',
                                  style: TextStyle(
                                    color: AppTheme.brownishGrey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
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
                                    fontSize: 24,
                                    color: AppTheme.brownishGrey,
                                    fontWeight: FontWeight.w500),
                                children: [
                                  TextSpan(
                                      text: BlocProvider.of<
                                                  SettlementHistoryCubit>(
                                              context,
                                              listen: false)
                                          .totalSettlementAmount
                                          .getFormattedCurrency,
                                      // text: '46151830',
                                      style: TextStyle(
                                          color: AppTheme.electricBlue,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold)),
                                ]),
                          )
                        ],
                      ).flexible,
                    ],
                  ),
                ),

                /*Expanded(
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: AppCount.length > 0
                                  ? () {
                                      isListSortedWithQrCode = false;
                                      isListSortedWithLink = false;
                                      isListSortedWithApp =
                                          !isListSortedWithApp;
                                      if (isListSortedWithApp) {
                                        filteredList.clear();
                                      */ /*  filteredList.addAll(AppCount);
                                        filteredList.addAll(LinkCount);
                                        filteredList.addAll(QrCount);*/ /*

                                        setState(() {});
                                      } else {
                                        setState(() {});
                                      }
                                    }
                                  : null,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: isListSortedWithApp
                                        ? AppTheme.coolGrey
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        20) // use instead of BorderRadius.all(Radius.circular(20))
                                    ),

                                // width: size.width * 0.425,
                                // height: 95.r,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            .015),
                                // decoration: BoxDecoration(
                                //   shape: BoxShape.circle,
                                // ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AppAssets.transactionsLink01,
                                      height: 30,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(text: '', children: [
                                              TextSpan(
                                                text: 'App',
                                                style: TextStyle(
                                                  color: AppTheme.electricBlue,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ])),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                              // text: '$currencyAED ',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  color: AppTheme.brownishGrey,
                                                  fontWeight: FontWeight.w800),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        '${AppCount.length.toString()}',
                                                    // text: '46151830',
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w800)),
                                              ]),
                                        )
                                      ],
                                    ).flexible,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // (screenWidth(context) * 0.01).widthBox,
                          VerticalDivider(
                            color: AppTheme.brownishGrey,
                            indent: 10,
                            endIndent: 10,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: LinkCount.length > 0
                                  ? () {
                                      isListSortedWithApp = false;
                                      isListSortedWithQrCode = false;
                                      isListSortedWithLink =
                                          !isListSortedWithLink;
                                      if (isListSortedWithLink) {
                                        filteredList.clear();
                                        filteredList.addAll(LinkCount);
                                        filteredList.addAll(AppCount);
                                        filteredList.addAll(QrCount);
                                        setState(() {});
                                      } else {
                                        setState(() {});
                                      }
                                    }
                                  : null,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: isListSortedWithLink
                                        ? AppTheme.coolGrey
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        20) // use instead of BorderRadius.all(Radius.circular(20))
                                    ),
                                // width: size.width * 0.425,
                                // height: 95.r,

                                padding: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            .015),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AppAssets.transactionsLink02,
                                      height: 30,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(text: '', children: [
                                              TextSpan(
                                                text: 'Links',
                                                style: TextStyle(
                                                  color: AppTheme.electricBlue,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ])),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                              // text: '$currencyAED ',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  color: AppTheme.brownishGrey,
                                                  fontWeight: FontWeight.w800),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        '${LinkCount.length.toString()}',
                                                    // text: '46151830',
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ]),
                                        )
                                      ],
                                    ).flexible,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: AppTheme.brownishGrey,
                            indent: 10,
                            endIndent: 10,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: QrCount.length > 0
                                  ? () {
                                      isListSortedWithApp = false;
                                      isListSortedWithLink = false;
                                      isListSortedWithQrCode =
                                          !isListSortedWithQrCode;
                                      if (isListSortedWithQrCode) {
                                        filteredList.clear();
                                        filteredList.addAll(QrCount);
                                        filteredList.addAll(AppCount);
                                        filteredList.addAll(LinkCount);
                                        setState(() {});
                                      } else {
                                        setState(() {});
                                      }
                                    }
                                  : null,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: isListSortedWithQrCode
                                        ? AppTheme.coolGrey
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        20) // use instead of BorderRadius.all(Radius.circular(20))
                                    ),
                                // width: size.width * 0.425,
                                // height: 95.r,

                                padding: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            .015),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AppAssets.transactionsLink03,
                                      height: 30,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(text: '', children: [
                                              TextSpan(
                                                text: 'QR code',
                                                style: TextStyle(
                                                  color: AppTheme.electricBlue,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ])),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                              // text: '$currencyAED ',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  color: AppTheme.brownishGrey,
                                                  fontWeight: FontWeight.w800),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        '${QrCount.length.toString()}',
                                                    // text: '46151830',
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ]),
                                        )
                                      ],
                                    ).flexible,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),*/
              ],
            ),
          )),
        ),
      );

  Future<void> filterBottomSheet(BuildContext ctx) async {
    int tempRadioOption = _selectedFilter;
    int tempSortOption = _selectedSort;

    await showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(
                color: AppTheme.justWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            height: 520,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      spacing: 20,
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
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: CustomText(
                              'Highest Amount',
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
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: CustomText(
                              'Lowest Amount',
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
                                  _selectedFilter = tempRadioOption;
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
                            'Last Month',
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
                              final value1 = lastMonth();
                              if (value1.first != null && value1.last != null)
                                setState(() {
                                  startDate = value1.first;
                                  lastDate = value1.last;
                                  _selectedFilter = tempRadioOption;
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
                                  _selectedFilter = tempRadioOption;
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
                                    _selectedFilter = tempRadioOption;
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
                                    _selectedFilter = tempRadioOption;
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
                        _searchController.clear();
                        BlocProvider.of<SettlementHistoryCubit>(ctx)
                            .filterTransactions(
                                _selectedSort, startDate, lastDate);
                        Navigator.of(context).pop();
                      },
                      child: CustomText(
                        'VIEW RESULT',
                        color: Colors.white,
                        size: (18),
                        bold: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    ).whenComplete(() {
      if (_selectedFilter == 2 && _selectedSort == 0) {
        setState(() {
          hideFilterString = true;
        });
      }
    });
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

  List lastMonth() {
    DateTime? _start;
    DateTime? _end;
    // _selectedFilter = tempRadioOption;
    _start = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
    _end = DateTime(DateTime.now().year, DateTime.now().month, 0);
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
    final date = await repository.queries.oldestSettlementHistoryData();
    _start = date;
    _end =
        DateTime.now().date.add(Duration(hours: 23, minutes: 59, seconds: 59));
    // _selectedFilter = tempRadioOption;
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

  // static String getFilterString(int index) {
  //   String filter;
  //   switch (index) {
  //     case 1:
  //       filter = 'This month';
  //       break;
  //     case 2:
  //       filter = 'Last Month';
  //       break;
  //     case 3:
  //       filter = 'Last 3 Months';
  //       break;
  //     case 4:
  //       filter = 'All';
  //       break;
  //     default:
  //       filter = 'Date Range';
  //       break;
  //   }
  //   return filter;
  // }

  static String getSortString(int index) {
    switch (index) {
      case 1:
        return ' as Highest Amount';
      case 2:
        return ' as Lowest Amount';
      default:
    }
    return '';
  }

  static String getDurationString(int index) {
    print(index);
    switch (index) {
      case 0:
        return 'this month';
      case 1:
        return 'last month';
      case 2:
        return 'last 3 months';
      case 3:
        return 'all ';
      case 4:
        return 'date range';

      default:
    }
    return '';
  }

  /*void ledgerBussinessModelBottomSheet(
      BuildContext context, List<SuspenseData>? data2) {
    // bool _value = false;
    int val = -1;
    String? Bid;

    loading == true
        ? CircularProgressIndicator(color: AppTheme.electricBlue,)
        : showModalBottomSheet(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return Container(
                  // height: 360,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  constraints: BoxConstraints(maxHeight: 400),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: Provider.of<BusinessProvider>(context,
                                listen: false)
                            .businesses
                            .length,
                        itemBuilder: (BuildContext context, int index) {
                          return RadioListTile(
                            value: index,
                            groupValue: val,
                            onChanged: (value) {
                              setState(() {
                                val = value as int;
                                Bid = Provider.of<BusinessProvider>(context,
                                        listen: false)
                                    .businesses[index]
                                    .businessId;
                              });
                              debugPrint(
                                  'Check this Business ID: ' + Bid.toString());
                            },
                            title: CustomText(
                              Provider.of<BusinessProvider>(context,
                                      listen: false)
                                  .businesses[index]
                                  .businessName,
                              bold: FontWeight.w600,
                              color: AppTheme.electricBlue,
                              size: 18,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: FutureBuilder<int>(
                              future: repository.queries.getCustomerCount(
                                  Provider.of<BusinessProvider>(context,
                                          listen: false)
                                      .businesses[index]
                                      .businessId),
                              builder: (context, snapshot) {
                                return CustomText(
                                  '${snapshot.data} ${snapshot.data == 1 ? 'Customer' : 'Customers'}',
                                  bold: FontWeight.w400,
                                  color: AppTheme.brownishGrey,
                                  size: 14,
                                );
                              },
                            ),
                            toggleable: true,
                            controlAffinity: ListTileControlAffinity.trailing,
                          );
                        },
                      ).flexible,
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppTheme.electricBlue,
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            List<String>? transactionIDS = [];
                            Repository _repository = Repository();

                            if (data2 != null && data2.isNotEmpty) {
                              debugPrint('data2' + data2.length.toString());
                              for (int i = 0; i < data2.length; i++) {
                                // await _repository.queries.checkCustomerAdded(
                                //     data2[i].fromCustId?.mobileNo, Bid!); //
                                CustomerModel _customerModel = CustomerModel();
                                _customerModel.customerId = Uuid().v1();
                                _customerModel.businessId =
                                    Provider.of<BusinessProvider>(context,
                                            listen: false)
                                        .selectedBusiness
                                        .businessId;
                                // _customerModel.chatId =
                                //     data2[i].fromCustId!.chatId;
                                _customerModel.name = data2[i].from;
                                _customerModel.ulId = data2[i].fromCustId!.id;
                                _customerModel.mobileNo =
                                    data2[i].fromMobileNumber;
                                _customerModel.businessId = Bid!; //BusinessID

                                _customerModel.isChanged = true;
                                _customerModel.isDeleted = false;

                                String? checkCustomer = await _repository
                                    .queries
                                    .checkCustomerAddedForSuspense(
                                        data2[i].fromMobileNumber, Bid!);
                                if (checkCustomer!.isEmpty) {
                                  // _customerModel.customerId = checkCustomer;
                                  if (_customerModel.mobileNo!.isNotEmpty) {
                                    final Messages msg = Messages(
                                        messages: '', messageType: 100);
                                    var jsondata = jsonEncode(msg);

                                    final response =
                                        await _chatRepository.sendMessage(
                                            _customerModel.mobileNo.toString(),
                                            _customerModel.name,
                                            jsondata,
                                            _customerModel.customerId ?? '',
                                            Provider.of<BusinessProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedBusiness
                                                .businessId);

                                    final messageResponse =
                                        Map<String, dynamic>.from(
                                            jsonDecode(response.body));
                                    Message _message = Message.fromJson(
                                        messageResponse['message']);
                                    _customerModel..chatId = _message.chatId;
                                    debugPrint('addddd: ' +
                                        _customerModel.toJson().toString());
                                  }
                                  await _repository.queries
                                      .insertCustomer(_customerModel);
                                } else {
                                  _customerModel.customerId = checkCustomer;
                                }

                                final previousBalance = (await repository
                                    .queries
                                    .getPaidMinusReceived(
                                        _customerModel.customerId!));
                                TransactionModel _transactionModel =
                                    TransactionModel();
                                await BlocProvider.of<LedgerCubit>(context)
                                    .addLedger(
                                        _transactionModel
                                          ..transactionId = Uuid().v1()
                                          ..amount = double.parse(
                                              data2[i].amount.toString())
                                          ..transactionType =
                                              TransactionType.Receive
                                          ..customerId =
                                              _customerModel.customerId
                                          ..date = data2[i].createdAt != null
                                              ? data2[i].createdAt
                                              : DateTime.now()
                                          ..balanceAmount = (previousBalance +
                                              double.parse(
                                                  data2[i].amount.toString()))
                                          ..isChanged = true
                                          ..fromMobileNumber = data2[i]
                                              .fromMobileNumber
                                              .toString()
                                          ..details = ''
                                          ..isDeleted = false
                                          ..business = Bid! //todoadd column
                                          ..createddate = DateTime.now(),
                                        () async {
                                  await Repository()
                                      .queries
                                      .updateIsMovedOffline(data2[i]);
                                }, context);
                                _paymentController.sendMessage(
                                    _customerModel.customerId,
                                    _customerModel.chatId ?? null,
                                    _customerModel.name,
                                    _customerModel.mobileNo,
                                    _transactionModel.amount,
                                    '', //request_id
                                    13,
                                    data2[i].transactionId,
                                    data2[i].urbanledgerId,
                                    data2[i].completed.toString(),
                                    1,
                                    "${data2[i].type}",
                                    "${data2[i].through}",
                                    data2[i].suspense == true ? 1 : 0);
                              }
                            }
                            await SuspenseAccountApi.suspenseAccountApi
                                .removeFromSuspenseEntry(
                                    TransctionIDS: transactionIDS)
                                .then((value) {
                              debugPrint('delete' + value.toString());
                              if (value == true) {
                                setState(() {
                                  loading = false;
                                });
                                'Selected transaction moved\nsuccessfully!'
                                    .showSnackBar(context);
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(
                                    context, AppRoutes.suspenseAccountRoute);
                              }
                            });

                            debugPrint('Ht5');
                          },
                          child: CustomText(
                            'Move ${isChecked.length} Transactions'
                                .toUpperCase(),
                            color: Colors.white,
                            size: (18),
                            bold: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
            });
  }*/

  Widget getList(List<SettlementHistoryData> _settlementHList) {
    return Container(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: _settlementHList.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          var statusObject = getStatusMessage(_settlementHList[index].status!);
          return Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                padding: EdgeInsets.symmetric(
                    horizontal: 0, vertical: 18), //horizonal-4
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: index == 0 ? Radius.circular(10) : Radius.zero,
                        topRight:
                            index == 0 ? Radius.circular(10) : Radius.zero)),
                child: GestureDetector(
                  // onTap: () {
                  //   showTranactionBottomSheet(context, data[index]);
                  // },
                  /*

                   */
                  child: ListTile(
                    onTap: () {
                      print(_settlementHList[index]);
                      /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SuspenseDt(
                                    suspenseData: _customerList[index],
                                  )));*/
                      Navigator.pushNamed(
                          context, AppRoutes.settlementDetailsRoute,
                          arguments: SettlementHistoryArgument(
                              _settlementHList[index], statusObject));
                    },
                    /* leading: Image.asset(
                      _customerList[index].type == 'DIRECT'
                          ? AppAssets.transactionsLink01
                          : _customerList[index].type == 'LINK'
                              ? AppAssets.transactionsLink02
                              : AppAssets.transactionsLink03,
                      height: 40,
                    ),*/
                    title: CustomText(
                      'Ref ID: ' +
                          _settlementHList[index].settlementId.toString(),
                      bold: FontWeight.w600,
                      size: 16,
                      color: AppTheme.brownishGrey,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        6.0.heightBox,
                        CustomText(
                          _settlementHList[index].createdAt != null
                              ? "${DateFormat('dd MMM yyyy | hh:mm aa').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(_settlementHList[index].createdAt.toString()))}"
                              : '',
                          size: 16,
                          color: AppTheme.brownishGrey,
                          bold: FontWeight.w400,
                        ),
                        4.0.heightBox,
                        CustomText(
                          '${statusObject['status']}',
                          size: 16,
                          color: statusObject['color'],
                          bold: FontWeight.w600,
                        ),
                      ],
                    ),
                    trailing: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.min,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: currencyAED,
                                  style: TextStyle(
                                      color: AppTheme.brownishGrey,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14),
                                  children: []),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: _settlementHList[index]
                                      .totalSettlementAmount!
                                      .getFormattedCurrency,
                                  style: TextStyle(
                                      color: AppTheme.electricBlue,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                  children: []),
                            ),
                            // Expanded(
                            //   child: Text(
                            //     'Attachment (5)',
                            //     style: TextStyle(
                            //         color: AppTheme.electricBlue,
                            //         fontWeight: FontWeight.bold,
                            //         fontSize: 14),
                            //   ),
                            // )
                          ],
                        ),
                        /*Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: isChecked.contains(index),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2)),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value!) {
                                isChecked.add(index);
                                data2.add(data[index]);
                              } else {
                                isChecked.remove(index);
                                data2.remove(data[index]);
                              }
                            });
                          },
                        )*/
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Divider(
                  height: 1,
                  color: AppTheme.senderColor,
                  endIndent: 24,
                  indent: 24,
                ),
              )
            ],
          );
        },
      ).flexible,
    );
  }

  getStatusMessage(String message) {
    var sm;

    switch (message) {
      case 'PENDING_FROM_BANK':
        {
          sm = {"status": 'In transit', "color": Colors.green};
        }
        break;
      case 'FAILED':
        {
          sm = {"status": 'Failed', "color": Colors.red};
        }
        break;
      case 'COMPLETED':
        {
          sm = {"status": 'Paid out', "color": Colors.greenAccent};
        }
        break;
      case 'CARRIED_FORWARD':
        {
          sm = {"status": 'Carry Forward', "color": Colors.amber};
        }
        break;

      default:
        {
          sm = {"status": 'Status Unknown', "color": Colors.grey};
        }
        break;
    }
    return sm;
  }
}

showTranactionBottomSheet(BuildContext context, SuspenseData data) {
  showModalBottomSheet<void>(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    context: context,
    builder: (BuildContext context) {
      return Container(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          // height: MediaQuery.of(context).size.height * 0.02,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                'From',
                                size: 20,
                                color: AppTheme.brownishGrey,
                                bold: FontWeight.w500,
                              ),
                              SizedBox(width: 15),
                              CustomText(
                                getName(data.from, data.fromMobileNumber),
                                size: 20,
                                color: AppTheme.brownishGrey,
                                bold: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // height: MediaQuery.of(context).size.height * 0.02,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                'To',
                                size: 20,
                                color: AppTheme.brownishGrey,
                                bold: FontWeight.w500,
                              ),
                              SizedBox(width: 15),
                              CustomText(
                                '${data.to.toString()}',
                                size: 20,
                                color: AppTheme.brownishGrey,
                                bold: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    10.0.heightBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          // height: MediaQuery.of(context).size.height * 0.02,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                'Amount',
                                size: 20,
                                color: AppTheme.brownishGrey,
                                bold: FontWeight.w500,
                              ),
                              SizedBox(width: 15),
                              Text(
                                '${data.amount.toString()}',
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                        Container(
                          // height: MediaQuery.of(context).size.height * 0.02,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                'Date',
                                size: 20,
                                color: AppTheme.brownishGrey,
                                bold: FontWeight.w500,
                              ),
                              SizedBox(width: 15),
                              CustomText(
                                data.createdAt != null
                                    ? "${DateFormat('dd MMM yyyy | hh:mm aa').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(data.createdAt.toString()))}"
                                    : '',
                                size: 20,
                                color: AppTheme.brownishGrey,
                                bold: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    10.0.heightBox,
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            /*repository.hiveQueries
                                  .insertIsCashbookSheetShown(true);*/
                          },
                          child: CustomText(
                            'OK',
                            size: (18),
                            bold: FontWeight.w500,
                          ),
                          style: ElevatedButton.styleFrom(
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

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return AppTheme.electricBlue;
  }
  return AppTheme.electricBlue;
}
