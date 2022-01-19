import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Cubits/Suspense/suspense_cubit.dart';
import 'package:urbanledger/Cubits/TransactionHistory/trans_history_cubit.dart';
import 'package:urbanledger/Models/analytics_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/Freemium/freemium_provider.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';

class premiumtranactionlist extends StatelessWidget {
  const premiumtranactionlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Premiumtranactionlist();
  }
}

class _Premiumtranactionlist extends StatefulWidget {
  @override
  __PremiumtranactionlistState createState() => __PremiumtranactionlistState();
}

class __PremiumtranactionlistState extends State<_Premiumtranactionlist> {
  final Repository repository = Repository();
  int _selectedFilter = 0;
  int _selectedSort = 0;
  DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime lastDate =
      DateTime.now().date.add(Duration(hours: 23, minutes: 59, seconds: 59));
  final TextEditingController _searchController = TextEditingController();
  bool hideFilterString = true;
  bool isDataFiltered = false;
  bool isListSortedWithApp = false;
  bool isListSortedWithLink = false;
  bool isListSortedWithQrCode = false;
  /* bool isTap = false;
  bool isLinkTap = false;
  bool isQrCodeTap = false;*/

  // Color? color;

  @override
  void initState() {
    super.initState();
    getTransactionHistoryData();
  }

  bool agree = true;
  bool isSelectedAll = false; // Selected All

  bool isEmiratesIdDone = false;
  bool isTradeLicenseDone = false;
  bool status = false;
  bool isPremium = false;
  bool loading = false;
  List isChecked = [];
  List<Datum> data = [];
  List<Map> data2 = [];
  List<Datum> filteredList = [];
  /* int? QrCount = 0;
  int? LinkCount = 0;
  int? AppCount = 0;*/
  List<Datum> QrCount = [];
  List<Datum> LinkCount = [];
  List<Datum> AppCount = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  getTransactionHistoryData() async {
    await BlocProvider.of<TransHistoryCubit>(context, listen: false).getTransactionsHistory(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);

        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: AppTheme.paleGrey,
          appBar: appBar,
          body: Stack(
            children: [
              Container(
                height: deviceHeight * 0.06,
                width: double.maxFinite,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: Color(0xfff2f1f6),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(AppAssets.backgroundImage),
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              loading == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        // (MediaQuery.of(context).padding.top).heightBox,
                        /*Consumer<FreemiumProvider>(
                            builder: (context, Trans, state) {
                          if (Trans.TransactionHistory != null &&
                              Trans.TransactionHistory.isEmpty) {
                            Trans.getTransactionHistory();
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (Trans.TransactionHistory != null &&
                              Trans.TransactionHistory!.isNotEmpty) {
                            data = Trans.TransactionHistory;
                            // data.sort((a, b) {
                            //   var adate = a[
                            //       'created_at']; //before -> var adate = a.expiry;
                            //   var bdate =
                            //       b['created_at']; //var bdate = b.expiry;
                            //   return -adate!.compareTo(bdate!);
                            // });

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
                                              height: MediaQuery.of(context)
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

                            LinkCount = data.where((element) {
                              return element['type'] == 'LINK';
                            }).toList();

                            AppCount = data.where((element) {
                              return element['type'] == 'DIRECT';
                            }).toList();

                            QrCount = data.where((element) {
                              return element['type'] == 'QRCODE';
                            }).toList();

                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: customerListWithOtherWidgets(
                                  isListSortedWithApp ||
                                          isListSortedWithLink ||
                                          isListSortedWithQrCode
                                      ? filteredList
                                      : data,
                                  _selectedFilter,
                                  _selectedSort),
                            );
                          } else {
                            return Container();
                          }
                          // if (state is SearchedSuspenseTransaction) {
                          //   // hideFilterString = false;
                          //   data = state.searchedCustomerList;
                          //   LinkCount = data.where((element) {
                          //     return element['type'] == 'LINK';
                          //   }).toList();
                          //
                          //   AppCount = data.where((element) {
                          //     return element['type']== 'DIRECT';
                          //   }).toList();
                          //
                          //   QrCount = data.where((element) {
                          //     return element['type'] == 'QRCODE';
                          //   }).toList();
                          //
                          //   return Padding(
                          //     padding: const EdgeInsets.all(10.0),
                          //     child: customerListWithOtherWidgets(
                          //         isListSortedWithApp ||
                          //                 isListSortedWithLink ||
                          //                 isListSortedWithQrCode
                          //             ? filteredList
                          //             : data,
                          //         _selectedFilter,
                          //         state.selectedSort),
                          //   );
                          // }
                          // return Container();
                        }).flexible,*/
                        BlocBuilder<TransHistoryCubit, TransHistoryState>(
                          builder: (context, state) {
                            if (state is FetchingSuspenseTranasctions)
                              return const Center(
                                child: CircularProgressIndicator(),
                              );

                            if (state is FetchedTranasctionHistory) {
                              data = state.transactionHistoryDataList;
                             /* data.sort((a, b) {
                                var adate = a
                                    .createdAt; //before -> var adate = a.expiry;
                                var bdate = b.createdAt; //var bdate = b.expiry;
                                return -adate!.compareTo(bdate!);
                              });*/

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
                                                height: MediaQuery.of(context)
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

                              LinkCount = data.where((element) {
                                return element.type == 'LINK';
                              }).toList();

                              AppCount = data.where((element) {
                                return element.type == 'DIRECT';
                              }).toList();

                              QrCount = data.where((element) {
                                return element.type == 'QRCODE';
                              }).toList();

                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: customerListWithOtherWidgets(
                                    isListSortedWithApp ||
                                        isListSortedWithLink ||
                                        isListSortedWithQrCode
                                        ? filteredList
                                        : data,
                                    _selectedFilter,
                                    _selectedSort),
                              );
                            }
                            if (state is SearchedTransactionHistory) {
                              // hideFilterString = false;
                              data = state.searchedCustomerList;
                              LinkCount = data.where((element) {
                                return element.type == 'LINK';
                              }).toList();

                              AppCount = data.where((element) {
                                return element.type == 'DIRECT';
                              }).toList();

                              QrCount = data.where((element) {
                                return element.type == 'QRCODE';
                              }).toList();

                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: customerListWithOtherWidgets(
                                    isListSortedWithApp ||
                                        isListSortedWithLink ||
                                        isListSortedWithQrCode
                                        ? filteredList
                                        : data,
                                    _selectedFilter,
                                    state.selectedSort),
                              );
                            }
                            return Container();
                          },
                        ).flexible,
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget customerListWithOtherWidgets(
      List<Datum> transactionHistoryList, filterIndex, sortIndex) {
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
                                        'Showing list of ${getDurationString(filterIndex)} as ${getSortString(sortIndex)}',
                                        color: AppTheme.brownishGrey,
                                        size: 16,
                                      )
                                    : Container(),
                                GestureDetector(
                                  child: Icon(Icons.close_sharp,
                                      color: AppTheme.brownishGrey),
                                  onTap: () {
                                    _selectedFilter = 0;
                                    _selectedSort = 0;
                                    BlocProvider.of<SuspenseCubit>(context)
                                        .getSuspenseTransactions(false);
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Container(
              //       padding: EdgeInsets.only(left: 30, right: 15, top: 15),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             '${isChecked.length} Transactions Selected',
              //             style: TextStyle(
              //                 color: Color(0xff666666),
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.w500),
              //           ),
              //         ],
              //       ),
              //     ),
              //     GestureDetector(
              //       onTap: isChecked.isEmpty
              //           ? () {
              //               setState(() {
              //                 suspenseList.forEach((element) {
              //                   isChecked.add(isListSortedWithApp ||
              //                           isListSortedWithLink ||
              //                           isListSortedWithQrCode
              //                       ? filteredList.indexOf(element)
              //                       : data.indexOf(element));
              //                   data2.add(isListSortedWithApp ||
              //                           isListSortedWithLink ||
              //                           isListSortedWithQrCode
              //                       ? filteredList[
              //                           filteredList.indexOf(element)]
              //                       : data[data.indexOf(element)]);
              //                 });
              //                 isSelectedAll = true;
              //               });
              //             }
              //           : () {
              //               setState(() {
              //                 isChecked.clear();
              //                 data2.clear();
              //               });
              //             },
              //       child: Container(
              //         padding: EdgeInsets.only(left: 15, right: 40, top: 15),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               isChecked.isEmpty ? 'Select All' : 'Deselect All',
              //               style: TextStyle(
              //                   color: Color(0xff666666),
              //                   fontSize: 18,
              //                   fontWeight: FontWeight.w500),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 10,
              ),
              transactionHistoryList.isEmpty
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
                  : getList(transactionHistoryList)
            ],
          ),
        )
      ],
    );
  }

  Widget searchField(int filterIndex, int sortIndex) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
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
                SizedBox(width: 10.0),
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
              ],
            ),
          ),
        ),
      );

  AppBar get appBar => AppBar(
        elevation: 0,
        title: Text('Transaction History'),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
            // onPressed: () => Navigator.of(context)..pop(),
            onPressed: () async {
              Provider.of<BusinessProvider>(context, listen: false)
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
      );

  Widget payReceiveButtons(bool isCustomerEmpty) => FutureBuilder(
      future: repository.queries.unAuthorizedTranaction(),
      builder: (context, snapshot) {
        debugPrint('AppLink' + snapshot.data.toString());
        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(6, 5, 6, 0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: IntrinsicHeight(
                child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
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
                                        filteredList.addAll(AppCount);
                                        filteredList.addAll(LinkCount);
                                        filteredList.addAll(QrCount);

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
                                            // overflow: TextOverflow.ellipsis,
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
                  ),
                ],
              ),
            )),
          ),
        );
      });

  static String getSortString(int index) {
    switch (index) {
      case 0:
        return 'Business';
      case 1:
        return 'A-Z';
      case 2:
        return 'Highest Amount';
      case 3:
        return 'Lowest Amount';
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

  Widget getList(List<Datum> _customerList) {
    return Container(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: _customerList.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          var str = _customerList[index].createdAt.toString();
          var newStr = str.substring(0, 10) + ' ' + str.substring(11, 23);

          return Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                padding: EdgeInsets.symmetric(
                    horizontal: 0, vertical: 10), //horizonal-4
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: index == 0 ? Radius.circular(10) : Radius.zero,
                        topRight:
                            index == 0 ? Radius.circular(10) : Radius.zero)),
                child: GestureDetector(
                  child: ListTile(
                    leading: Image.asset(
                      _customerList[index].type == 'DIRECT'
                          ? AppAssets.transactionsLink01
                          : _customerList[index].type == 'LINK'
                              ? AppAssets.transactionsLink02
                              : AppAssets.transactionsLink03,
                      height: 40,
                    ),
                    title: CustomText(
                      getName(_customerList[index].from,
                          _customerList[index].fromMobileNumber),
                      bold: FontWeight.w600,
                      size: 16,
                      color: AppTheme.brownishGrey,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        6.0.heightBox,
                        CustomText(
                          '+${_customerList[index].fromMobileNumber?? ""}',
                          size: 13,
                          color: AppTheme.brownishGrey,
                          bold: FontWeight.w400,
                        ),
                        4.0.heightBox,
                        CustomText(
                          _customerList[index].createdAt != null
                              ? "${DateFormat('dd MMM yyyy | hh:mm aa').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse((newStr)))}"
                              : '',
                          size: 12,
                          color: AppTheme.brownishGrey,
                          bold: FontWeight.w400,
                        )
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                  children: []),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: (double.tryParse(_customerList[index]
                                              .amount
                                          .toString()))!
                                      .getFormattedCurrency
                                      .replaceAll('-', ''),
                                  style: TextStyle(
                                      color: AppTheme.brownishGrey,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 22),
                                  children: []),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  height: 1,
                  color: AppTheme.senderColor,
                  endIndent: 30,
                  indent: 30,
                ),
              )
            ],
          );
        },
      ).flexible,
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
}
