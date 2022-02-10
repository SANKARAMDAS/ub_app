import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Cubits/CustomerRanking/customer_ranking_pay_cubit.dart';
import 'package:urbanledger/Cubits/CustomerRanking/customer_ranking_request_cubit.dart';
import 'package:urbanledger/Cubits/Suspense/suspense_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/customer_ranking_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/APIs/customer_ranking_api.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/chat_module/data/models/message.dart';
import 'package:urbanledger/chat_module/data/repositories/chat_repository.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/AddBankAccount/add_bank_account.dart';
import 'package:urbanledger/screens/AddBankAccount/user_bank_account_provider.dart';
import 'package:urbanledger/screens/Components/custom_popup.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/shimmer_widgets.dart';
import 'package:urbanledger/screens/TransactionScreens/pay_transaction.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import 'package:uuid/uuid.dart';
import 'package:urbanledger/screens/Components/shimmer_widgets.dart';

class PayRequestScreen extends StatefulWidget {
  @override
  _PayRequestScreenState createState() => _PayRequestScreenState();
}

class _PayRequestScreenState extends State<PayRequestScreen>
    with SingleTickerProviderStateMixin /*,AutomaticKeepAliveClientMixin*/ {
  late TabController _tabController;
  // late TabController? _tabController2;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<State> key = GlobalKey<State>();
  Barcode? result;

  QRViewController? controller;
  int _currentIndex = 0;
  bool contactList = false;
  bool qrScreen = false;
  bool byLocation = false;
  bool isLoaded = false;
  int _selectedFilter = 0;
  int _selectedSort = 0;
  bool hideFilterString = true;
  final TextEditingController _searchController = TextEditingController();
  DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime lastDate =
      DateTime.now().date.add(Duration(hours: 23, minutes: 59, seconds: 59));
  bool loading = false;
  bool isLoading = false;
  List<CustomerRankingData> pay_data = [];
  List<CustomerRankingData> recieve_data = [];
  int customerRankingPayPageCount = 0;
  int customerRankingRequestPageCount = 0;

  int currentPayGridPage = 1;
  int currentRequestGridPage = 1;
  int _selectedIndex = 0;

  final List<Color> _colors = [
    Color.fromRGBO(137, 171, 249, 1),
    AppTheme.brownishGrey,
    AppTheme.greyish,
    AppTheme.electricBlue,
  ];

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  /*@override
  bool get wantKeepAlive => true;*/

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    // _tabController2 = TabController(length: 3, vsync: this);
    contactList = true;
    super.initState();
    fetchData();

    // getRecentBankAcc();
  }

  fetchData() async {
    await getCustomerRankingList(RequestType.PAY, 1, context, true);

    await getCustomerRankingList(RequestType.RECIEVE, 1, context, true);

    /* await getCustomerRankingList(
        RequestType.PAY, currentPayGridPage, context, false);
    await getCustomerRankingList(
        RequestType.RECIEVE, currentRequestGridPage, context, false);*/

    _tabController.addListener(() async {
      //currentGridPage = 1;
      /*   _selectedIndex = _tabController.index;
      print("Selected Index: " + _tabController.index.toString());
      if (_selectedIndex == 0) {
        await getCustomerRankingList(
            RequestType.PAY, currentPayGridPage, context, false);

      } else {
        await getCustomerRankingList(
            RequestType.RECIEVE, currentRequestGridPage, context, false);

      }*/
    });
  }

  getRecentBankAcc() async {
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
      await Provider.of<UserBankAccountProvider>(context, listen: false)
          .getUserBankAccount();
      setState(() {
        isLoaded = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    // _tabController2!.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        BlocProvider.of<ContactsCubit>(context).filterContacts(1, 1);
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: AppTheme.paleGrey,
          key: key,

          appBar: AppBar(
            title: Text('Send / Receive'),
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                onPressed: () {
                  BlocProvider.of<ContactsCubit>(context).filterContacts(1, 1);
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 22,
                ),
              ),
            ),
          ),
          // extendBodyBehindAppBar: false,
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  height: deviceHeight * 0.07,
                  width: double.maxFinite,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: Color(0xfff2f1f6),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/back.png'),
                          alignment: Alignment.topCenter)),
                ),
                // AppAssets.backgroundImage.background,
                (deviceHeight * 0.025).heightBox,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    children: [
                      (deviceHeight * 0.010).heightBox,
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Card(
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: TabBar(
                            indicatorColor: AppTheme.electricBlue,
                            indicatorWeight: 4.2,
                            labelColor: AppTheme.brownishGrey,
                            unselectedLabelColor: AppTheme.brownishGrey,
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                            unselectedLabelStyle:
                                TextStyle(fontWeight: FontWeight.w600),
                            controller: _tabController,
                            tabs: [
                              Tab(
                                text: 'Pay',
                              ),
                              Tab(
                                text: 'Request',
                              ),
                              // Tab(
                              //   text: 'Transaction',
                              // ),
                            ],
                          ),
                        ),
                      ),

                      // tab bar view here
                      isLoaded == true
                          // ? shimmerPayLoading()
                          ? Container(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.2),
                              child: CircularProgressIndicator(color: AppTheme.electricBlue,))
                          : Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  // first tab bar view widget
                                  Container(
                                    height: MediaQuery.of(context).size.height,
                                    child: CustomScrollView(
                                      slivers: [
                                        SliverToBoxAdapter(
                                          child: loading == true
                                              ? Center(
                                                  child: shimmerPayLoading(),
                                                )
                                              : Container(
                                                  child: BlocBuilder<
                                                      CustomerRankingPayCubit,
                                                      CustomerRankingPayState>(
                                                    builder: (ctx, state) {
                                                      if (state
                                                          is FetchingCustomerRankingPayTransactions) {
                                                        return shimmerPayLoading();
                                                      }
                                                      // return const Center(
                                                      //   child:
                                                      //       ShimerAvatarWithNameContainer(),
                                                      // );

                                                      if (state
                                                          is FetchedCustomerRankingPayTransactions) {
                                                        pay_data = state
                                                            .customerRankingPayDataList;
                                                        customerRankingPayPageCount =
                                                            state.payPageCount;
                                                        /*data.sort((a, b) {
                                                       var adate =
                                                           a.updatedAt; //before -> var adate = a.expiry;
                                                       var bdate = b.updatedAt; //var bdate = b.expiry;
                                                       return -adate!.compareTo(bdate!);
                                                     });*/

                                                        if (pay_data.isEmpty) {
                                                          return Container(
                                                            height: 0,
                                                          );
                                                        }
                                                        // _selectedFilter = 0;
                                                        //  _selectedSort = 0;

                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: customerListRecentPaymentPaid(
                                                              customerRankingPayPageCount,
                                                              pay_data,
                                                              context
                                                              /*  _selectedFilter,
                                                           _selectedSort*/
                                                              ),
                                                        );
                                                      }
                                                      return Container();
                                                    },
                                                  ),
                                                ),
                                        ),
                                        SliverToBoxAdapter(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15.0,
                                            ),
                                            // height: 80,
                                            decoration: BoxDecoration(
                                              // color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                5.0,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      qrScreen = false;
                                                      byLocation = false;
                                                      contactList = true;
                                                      debugPrint(
                                                          qrScreen.toString());
                                                    });
                                                  },
                                                  child: Container(
                                                    // height: 200,
                                                    child: Column(
                                                      children: [
                                                        contactList == true
                                                            ? Image.asset(
                                                                'assets/icons/Contact-List-Fill.png',
                                                                height: 80,
                                                                // color: Colors.white,
                                                              )
                                                            : Image.asset(
                                                                'assets/icons/Contact-List-01.png',
                                                                height: 80,
                                                                // color: AppTheme.electricBlue,
                                                              ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          'Contact List',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.1),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      byLocation = false;
                                                      contactList = false;
                                                      qrScreen = true;
                                                      debugPrint(
                                                          qrScreen.toString());
                                                    });
                                                  },
                                                  child: Container(
                                                    child: Column(children: [
                                                      qrScreen == true
                                                          ? Image.asset(
                                                              'assets/icons/QR-Code-Button-Fill-01.png',
                                                              height: 80,
                                                              // color: Colors.white,
                                                            )
                                                          : Image.asset(
                                                              'assets/icons/QR-Code-Button-01.png',
                                                              height: 80,
                                                            ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        'QR Code',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                                // GestureDetector(
                                                //   onTap: () {
                                                //     setState(() {
                                                //       contactList = false;
                                                //       qrScreen = false;
                                                //       byLocation = true;
                                                //       debugPrint(qrScreen.toString());
                                                //     });
                                                //   },
                                                //   child: Container(
                                                //     child: Column(
                                                //       children: [
                                                //         byLocation == true
                                                //             ? Image.asset(
                                                //                 'assets/icons/Search-by-location-Fill-01.png',
                                                //                 height: 80,
                                                //                 // color: Colors.white,
                                                //               )
                                                //             : Image.asset(
                                                //                 'assets/icons/Search-by-location-01.png',
                                                //                 height: 80,
                                                //               ),
                                                //         SizedBox(
                                                //           height: 5,
                                                //         ),
                                                //         Text(
                                                //           'Search by\nLocation',
                                                //           textAlign: TextAlign.center,
                                                //         ),
                                                //       ],
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SliverToBoxAdapter(
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                          ),
                                        ),
                                        SliverToBoxAdapter(
                                          child: contactList == true
                                              ? Container(
                                                  // decoration: BoxDecoration(
                                                  //   boxShadow: [
                                                  //     BoxShadow(
                                                  //       color: Colors.grey
                                                  //           .withOpacity(0.3),
                                                  //       offset: Offset(3, 3),
                                                  //       blurRadius: 3.0,
                                                  //     )
                                                  //   ],
                                                  //   borderRadius:
                                                  //       BorderRadius.circular(10),
                                                  //   color: Colors.white,
                                                  // ),
                                                  child: CustomSearchBar(
                                                    CtextFormField:
                                                        TextFormField(
                                                      onChanged: (value) {
                                                        BlocProvider.of<
                                                                    ContactsCubit>(
                                                                context)
                                                            .searchContacts(
                                                                value);
                                                      },
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              'Search by Name',
                                                          hintStyle: TextStyle(
                                                              color: AppTheme
                                                                  .greyish,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none),
                                                    ),
                                                    Suffix: Container(),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                        SliverToBoxAdapter(
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                          ),
                                        ),
                                        SliverToBoxAdapter(
                                          child: contactList == true
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 8),
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                      'Phone Contact List',
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .brownishGrey,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                )
                                              : Container(),
                                        ),
                                        contactList == true
                                            ? BlocBuilder<ContactsCubit,
                                                ContactsState>(
                                                builder: (context, state) {
                                                  if (state
                                                      is SearchedContacts) {
                                                    return contactListWithOtherWidgets(
                                                        context: context,
                                                        contacts: state
                                                            .searchedCustomerList,
                                                        searchQuery: '',
                                                        navigationtoPay: true);
                                                  }
                                                  if (state
                                                      is FetchedContacts) {
                                                    return contactListWithOtherWidgets(
                                                      context: context,
                                                      contacts:
                                                          state.customerList,
                                                      searchQuery: '',
                                                      navigationtoPay: true,
                                                    );
                                                  }
                                                  return SliverToBoxAdapter(
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(color: AppTheme.electricBlue,),
                                                    ),
                                                  );
                                                },
                                              )
                                            : SliverToBoxAdapter(
                                                child: Container()),
                                        SliverToBoxAdapter(
                                          child: qrScreen == true
                                              ? qrScanTabView()
                                              : Container(),
                                        ),
                                        SliverToBoxAdapter(
                                            child: byLocation == true
                                                ? Center(
                                                    child: Text(
                                                      '',
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  )
                                                : Container())
                                      ],
                                    ),
                                  ),
                                  //End of 1st Tab

                                  // second tab bar view widget
                                  Container(
                                    height: MediaQuery.of(context).size.height,
                                    child: CustomScrollView(
                                      slivers: [
                                        SliverToBoxAdapter(
                                          child: loading == true
                                              ? Center(
                                                  child: shimmerPayLoading1(),
                                                )
                                              : Container(
                                                  child: BlocBuilder<
                                                      CustomerRankingRequestCubit,
                                                      CustomerRankingRequestState>(
                                                    builder: (ctx, state) {
                                                      if (state
                                                          is FetchingCustomerRankingRequestTransactions) {
                                                        return shimmerPayLoading1();
                                                      }
                                                      // return const Center(
                                                      //   child:
                                                      //       ShimerAvatarWithNameContainer(),
                                                      // );

                                                      if (state
                                                          is FetchedCustomerRankingRequestTransactions) {
                                                        recieve_data = state
                                                            .customerRankingRequestDataList;
                                                        customerRankingRequestPageCount =
                                                            state
                                                                .requestPageCount;
                                                        /*data.sort((a, b) {
                                                           var adate =
                                                               a.updatedAt; //before -> var adate = a.expiry;
                                                           var bdate = b.updatedAt; //var bdate = b.expiry;
                                                           return -adate!.compareTo(bdate!);
                                                         });*/

                                                        if (recieve_data
                                                            .isEmpty) {
                                                          return Container(
                                                            height: 0,
                                                          );
                                                        }
                                                        // _selectedFilter = 0;
                                                        //  _selectedSort = 0;

                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: customerListRecentPaymentRecieved(
                                                              customerRankingRequestPageCount,
                                                              recieve_data,
                                                              context
                                                              /*  _selectedFilter,
                                                               _selectedSort*/
                                                              ),
                                                        );
                                                      }
                                                      return Container();
                                                    },
                                                  ),
                                                ),
                                        ),
                                        // SliverToBoxAdapter(
                                        //   child: Container(
                                        //     padding: EdgeInsets.symmetric(
                                        //       horizontal: 15.0,
                                        //     ),
                                        //     // height: 80,
                                        //     decoration: BoxDecoration(
                                        //       // color: Colors.white,
                                        //       borderRadius:
                                        //           BorderRadius.circular(
                                        //         5.0,
                                        //       ),
                                        //     ),
                                        //     child: Row(
                                        //       mainAxisAlignment:
                                        //           MainAxisAlignment.center,
                                        //       children: [
                                        //         GestureDetector(
                                        //           onTap: () {
                                        //             setState(() {
                                        //               qrScreen = false;
                                        //               byLocation = false;
                                        //               contactList = true;
                                        //               debugPrint(
                                        //                   qrScreen.toString());
                                        //             });
                                        //           },
                                        //           child: Container(
                                        //             // height: 200,
                                        //             child: Column(
                                        //               children: [
                                        //                 contactList == true
                                        //                     ? Image.asset(
                                        //                         'assets/icons/Contact-List-Fill.png',
                                        //                         height: 80,
                                        //                         // color: Colors.white,
                                        //                       )
                                        //                     : Image.asset(
                                        //                         'assets/icons/Contact-List-01.png',
                                        //                         height: 80,
                                        //                         // color: AppTheme.electricBlue,
                                        //                       ),
                                        //                 SizedBox(
                                        //                   height: 5,
                                        //                 ),
                                        //                 Text(
                                        //                   'Contact List',
                                        //                   textAlign:
                                        //                       TextAlign.center,
                                        //                 ),
                                        //               ],
                                        //             ),
                                        //           ),
                                        //         ),
                                        //         SizedBox(
                                        //             width:
                                        //                 MediaQuery.of(context)
                                        //                         .size
                                        //                         .width *
                                        //                     0.1),
                                        //         GestureDetector(
                                        //           onTap: () {
                                        //             setState(() {
                                        //               byLocation = false;
                                        //               contactList = false;
                                        //               qrScreen = true;
                                        //               debugPrint(
                                        //                   qrScreen.toString());
                                        //             });
                                        //           },
                                        //           child: Container(
                                        //             child: Column(children: [
                                        //               qrScreen == true
                                        //                   ? Image.asset(
                                        //                       'assets/icons/QR-Code-Button-Fill-01.png',
                                        //                       height: 80,
                                        //                       // color: Colors.white,
                                        //                     )
                                        //                   : Image.asset(
                                        //                       'assets/icons/QR-Code-Button-01.png',
                                        //                       height: 80,
                                        //                     ),
                                        //               SizedBox(
                                        //                 height: 5,
                                        //               ),
                                        //               Text(
                                        //                 'QR Code',
                                        //                 textAlign:
                                        //                     TextAlign.center,
                                        //               ),
                                        //             ]),
                                        //           ),
                                        //         ),
                                        //         // GestureDetector(
                                        //         //   onTap: () {
                                        //         //     setState(() {
                                        //         //       contactList = false;
                                        //         //       qrScreen = false;
                                        //         //       byLocation = true;
                                        //         //       debugPrint(qrScreen.toString());
                                        //         //     });
                                        //         //   },
                                        //         //   child: Container(
                                        //         //     child: Column(
                                        //         //       children: [
                                        //         //         byLocation == true
                                        //         //             ? Image.asset(
                                        //         //                 'assets/icons/Search-by-location-Fill-01.png',
                                        //         //                 height: 80,
                                        //         //                 // color: Colors.white,
                                        //         //               )
                                        //         //             : Image.asset(
                                        //         //                 'assets/icons/Search-by-location-01.png',
                                        //         //                 height: 80,
                                        //         //               ),
                                        //         //         SizedBox(
                                        //         //           height: 5,
                                        //         //         ),
                                        //         //         Text(
                                        //         //           'Search by\nLocation',
                                        //         //           textAlign: TextAlign.center,
                                        //         //         ),
                                        //         //       ],
                                        //         //     ),
                                        //         //   ),
                                        //         // ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),

                                        SliverToBoxAdapter(
                                          child: Container(
                                            // decoration: BoxDecoration(
                                            //   boxShadow: [
                                            //     BoxShadow(
                                            //       color: Colors.grey.withOpacity(0.3),
                                            //       offset: Offset(3, 3),
                                            //       blurRadius: 3.0,
                                            //     )
                                            //   ],
                                            //   borderRadius: BorderRadius.circular(10),
                                            //   color: Colors.white,
                                            // ),
                                            child: CustomSearchBar(
                                              CtextFormField: TextFormField(
                                                onChanged: (value) {
                                                  BlocProvider.of<
                                                              ContactsCubit>(
                                                          context)
                                                      .searchContacts(value);
                                                },
                                                decoration: InputDecoration(
                                                    hintText: 'Customer Name',
                                                    hintStyle: TextStyle(
                                                        color: AppTheme.greyish,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none),
                                              ),
                                              Suffix: Container(),
                                            ),
                                          ),
                                        ),
                                        SliverToBoxAdapter(
                                            child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        )),
                                        SliverToBoxAdapter(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                  vertical: 8),
                                              alignment: Alignment.topLeft,
                                              child: Text('Phone Contact List',
                                                  style: TextStyle(
                                                      color:
                                                          AppTheme.brownishGrey,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ),
                                          ),
                                        ),
                                        BlocBuilder<ContactsCubit,
                                            ContactsState>(
                                          builder: (context, state) {
                                            if (state is SearchedContacts) {
                                              return contactListWithOtherWidgets(
                                                navigationtoPay: false,
                                                context: context,
                                                contacts:
                                                    state.searchedCustomerList,
                                                searchQuery: '',
                                              );
                                            }
                                            if (state is FetchedContacts) {
                                              return contactListWithOtherWidgets(
                                                context: context,
                                                navigationtoPay: false,
                                                contacts: state.customerList,
                                                searchQuery: '',
                                              );
                                            }
                                            return SliverToBoxAdapter(
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator(color: AppTheme.electricBlue,)),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Center(
                                  //   child: Text(
                                  //     '',
                                  //     style: TextStyle(
                                  //       fontSize: 25,
                                  //       fontWeight: FontWeight.w600,
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
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

  Widget searchField(int filterIndex, int sortIndex) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          margin: EdgeInsets.only(
            top: 5,
            bottom: 5,
          ),
          child: Container(
            // width: MediaQuery.of(context).size.width * 0.92,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text('Most Recent payment',
                      style: TextStyle(
                          color: AppTheme.brownishGrey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                /*Stack(
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
            ),*/
              ],
            ),
          ),
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
              child: SingleChildScrollView(
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
                                  side:
                                      BorderSide(color: AppTheme.electricBlue),
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
                                  side:
                                      BorderSide(color: AppTheme.electricBlue),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 7),
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
                                  side:
                                      BorderSide(color: AppTheme.electricBlue),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 7),
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
                          BlocProvider.of<SuspenseCubit>(ctx)
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
            ),
          );
        });
      },
    );
  }

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
    final date = await repository.queries.oldestCustomerSuspenseData();
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

  Widget customerListRecentPaymentPaid(
      int pageCount,
      List<CustomerRankingData> customerRankingList,
      BuildContext context /*, filterIndex, sortIndex*/) {
    //customerList = [];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /*searchField(filterIndex ?? 1, sortIndex ?? 1),*/
/*        if (!hideFilterString)
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
              : Container(),*/
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('Most Recent payment',
              style: TextStyle(
                  color: AppTheme.brownishGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 10,
        ),
        customerRankingList.isEmpty
            ? Container()
            : Flexible(
                child: getList(
                    RequestType.PAY, customerRankingList, pageCount, context))
      ],
    );
  }

  Widget customerListRecentPaymentRecieved(
      int pageCount,
      List<CustomerRankingData> customerRankingList,
      BuildContext context /*, filterIndex, sortIndex*/) {
    //customerList = [];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /*searchField(filterIndex ?? 1, sortIndex ?? 1),*/
/*        if (!hideFilterString)
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
              : Container(),*/
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('Recent Requested People',
              style: TextStyle(
                  color: AppTheme.brownishGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 10,
        ),
        customerRankingList.isEmpty
            ? Container()
            : Flexible(
                child: getList(RequestType.RECIEVE, customerRankingList,
                    pageCount, context))
      ],
    );
  }

  qrScanTabView() {
    final GlobalKey<State> key = GlobalKey<State>();
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.16,
                vertical: MediaQuery.of(context).size.height * 0.04),
            child: Image.asset(
              AppAssets.qrCodeGraphic,
              // width: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.17),
            child: NewCustomButton(
              prefixImage: AppAssets.qrCodeIcon,
              imageSize: 25.0,
              imageColor: Colors.white,
              onSubmit: () {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => QRViewExample()));
                CustomLoadingDialog.showLoadingDialog(context, key);
                Navigator.of(context).popAndPushNamed(AppRoutes.scanQRRoute);
              },
              text: 'Open code Scanner',
              textColor: Colors.white,
              backgroundColor: AppTheme.electricBlue,
              textSize: 18.0,
              fontWeight: FontWeight.w500,
              // width: 185,
              height: 45,
            ),
          ),
        ],
      ),
    );
    //return Column();
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  Widget getList(RequestType type, List<CustomerRankingData> _customerList,
      int pageCount, BuildContext context) {
    bool navigation = type == RequestType.PAY ? true : false;
    var cGrid = new PageController();
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 4,
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount:
                pageCount > 1 ? _customerList.length + 1 : _customerList.length,
            itemBuilder: (BuildContext ctx, int index) {
              if (pageCount > 1 && index == _customerList.length) {
                if ((type == RequestType.PAY
                        ? currentPayGridPage
                        : currentRequestGridPage + 1) <=
                    pageCount)
                  return InkWell(
                    onTap: () {
                      //cGrid.jumpToPage(i+1);
                      /*       cGrid.animateTo(MediaQuery
                            .of(context)
                            .size
                            .width, duration: new Duration(milliseconds: 600),
                            curve: Curves.easeIn);*/
                      type == RequestType.PAY
                          ? currentPayGridPage
                          : currentRequestGridPage += 1;
                      getCustomerRankingList(
                          type,
                          type == RequestType.PAY
                              ? currentPayGridPage
                              : currentRequestGridPage,
                          context,
                          false);
                    },
                    child: GridTile(
                      header: CircleAvatar(
                        radius: 28,
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: CustomText(
                              'More',
                              color: AppTheme.electricBlue,
                              bold: FontWeight.w500,
                            )),
                        backgroundColor: AppTheme.receiverColor,
                      ),
                      child: Container(),
                    ),
                  );
                else
                  return InkWell(
                    onTap: () {
                      //cGrid.jumpToPage(i+1);
                      /*       cGrid.animateTo(MediaQuery
                            .of(context)
                            .size
                            .width, duration: new Duration(milliseconds: 600),
                            curve: Curves.easeIn);*/
                      type == RequestType.PAY
                          ? currentPayGridPage
                          : currentRequestGridPage -= 1;
                      getCustomerRankingList(
                          type,
                          type == RequestType.PAY
                              ? currentPayGridPage
                              : currentRequestGridPage,
                          context,
                          false);
                    },
                    child: GridTile(
                      header: CircleAvatar(
                        radius: 28,
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: CustomText(
                              'Back',
                              color: AppTheme.electricBlue,
                              bold: FontWeight.w500,
                            )),
                        backgroundColor: AppTheme.receiverColor,
                      ),
                      child: Container(),
                    ),
                  );
              }

              CustomerRankingData cData = _customerList[index];
              var bg_color = _colors[Random().nextInt(_colors.length)];
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: Repository().hiveQueries.userData.bankStatus == false &&
                        navigation == false
                    ? () {
                        MerchantBankNotAdded.showBankNotAddedDialog(
                            context, 'userBankNotAdded');
                      }
                    // : ((Repository().hiveQueries.userData.kycStatus == 0 ||
                    //                 Repository().hiveQueries.userData.kycStatus ==
                    //                     2) ||
                    //             Repository().hiveQueries.userData.premiumStatus ==
                    //                 0) &&
                    //     widget.navigation == false
                    // ? () async {
                    //     CustomLoadingDialog.showLoadingDialog(context, key);
                    //     var cid = await repository.customerApi.getCustomerID(
                    //         mobileNumber:
                    //             widget.contacts[index].mobileNo.toString());
                    //     bool? merchantSubscriptionPlan =
                    //         cid.customerInfo?.merchantSubscriptionPlan ?? false;
                    //     if (Repository().hiveQueries.userData.kycStatus == 2) {
                    //       //If KYC is Verification is Pending
                    //       await getKyc().then((value) =>
                    //           MerchantBankNotAdded.showBankNotAddedDialog(
                    //               context, 'userKYCVerificationPending'));
                    //     } else if (Repository()
                    //             .hiveQueries
                    //             .userData
                    //             .kycStatus ==
                    //         0) {
                    //       Navigator.of(context).pop(true);
                    //       //KYC WHEN USER STARTS A NEW KYC JOURNEY
                    //       MerchantBankNotAdded.showBankNotAddedDialog(
                    //           context, 'userKYCPending');
                    //     } else if (Repository()
                    //                 .hiveQueries
                    //                 .userData
                    //                 .kycStatus ==
                    //             0 &&
                    //         Repository()
                    //                 .hiveQueries
                    //                 .userData
                    //                 .isEmiratesIdDone ==
                    //             false) {
                    //       Navigator.of(context).pop(true);
                    //       //KYC WHEN USER STARTS EMirates ID Journey but not done TRade License
                    //       MerchantBankNotAdded.showBankNotAddedDialog(
                    //           context, 'EmiratesIdPending');
                    //     } else if (Repository()
                    //                 .hiveQueries
                    //                 .userData
                    //                 .kycStatus ==
                    //             0 &&
                    //         Repository()
                    //                 .hiveQueries
                    //                 .userData
                    //                 .isTradeLicenseDone ==
                    //             false) {
                    //       Navigator.of(context).pop(true);
                    //       //KYC WHEN USER STARTS EMirates ID Journey but not done TRade License
                    //       MerchantBankNotAdded.showBankNotAddedDialog(
                    //           context, 'TradeLicensePending');
                    //     } else if (Repository()
                    //                 .hiveQueries
                    //                 .userData
                    //                 .kycStatus ==
                    //             1 &&
                    //         Repository().hiveQueries.userData.premiumStatus ==
                    //             0) {
                    //       Navigator.of(context).pop(true);
                    //       MerchantBankNotAdded.showBankNotAddedDialog(
                    //           context, 'upgradePremium');
                    //     } else if (cid.customerInfo?.kycStatus == false) {
                    //       Navigator.of(context).pop(true);
                    //       merchantBankNotAddedModalSheet(
                    //           text:
                    //               'Your merchant has not completed the KYC or KYC is expired. We have requested merchant to complete KYC.');
                    //     } else if (merchantSubscriptionPlan == false) {
                    //       Navigator.of(context).pop(true);
                    //       merchantBankNotAddedModalSheet(
                    //           text:
                    //               'We have requested your merchant to Switch to Premium now to enjoy the benefits.');
                    //     } else {
                    //       // CustomLoadingDialog.showLoadingDialog(context, key);
                    //       // var cid = await repository.customerApi.getCustomerID(
                    //       //     mobileNumber:
                    //       //         widget.contacts[index].mobileNo.toString());
                    //       _customerModel
                    //         ..name = getName(widget.contacts[index].name,
                    //             widget.contacts[index].mobileNo)
                    //         ..mobileNo = widget.contacts[index].mobileNo
                    //         ..ulId = cid.customerInfo?.id.toString()
                    //         ..avatar = widget.contacts[index].avatar
                    //         ..chatId = widget.contacts[index].chatId;
                    //       final localCustId = await repository.queries
                    //           .getCustomerId(widget.contacts[index].mobileNo!);
                    //       // Navigator.of(context).pop(true);
                    //       Navigator.of(context).popAndPushNamed(
                    //           AppRoutes.requestTransactionRoute,
                    //           arguments: ReceiveTransactionArgs(
                    //               _customerModel, localCustId));
                    //     }
                    //   }
                    : () async {
                        CustomerModel _customerModel = CustomerModel();
                        if (navigation == true) {
                          CustomLoadingDialog.showLoadingDialog(context, key);
                          var cid = await repository.customerApi
                              .getCustomerID(
                                  mobileNumber: cData.mobileNo.toString())
                              .timeout(Duration(seconds: 30),
                                  onTimeout: () async {
                            Navigator.of(context).pop();
                            return Future.value(null);
                          });
                          bool? merchantSubscriptionPlan =
                              cid.customerInfo?.merchantSubscriptionPlan ??
                                  false;
                          debugPrint(cData.mobileNo.toString());
                          debugPrint(cData.contactData?.name?.split(' ')[0]);
                          debugPrint(cData.chatId);
                          //    debugPrint(cid.customerInfo?.id.toString());
                          var avatar;
                          try{
                            /*avatar = cData.profilePic!.isNotEmpty &&
                                cData.profilePic != null &&
                                cData.profilePic != 'null'
                                ? (await NetworkAssetBundle(
                                Uri.parse(cData.profilePic!))
                                .load(cData.profilePic!))
                                .buffer
                                .asUint8List()
                                : [];*/
                            if(cData.profilePic!=null){
                              avatar=(await NetworkAssetBundle(
                                  Uri.parse(cData.profilePic!))
                                  .load(cData.profilePic!))
                                  .buffer
                                  .asUint8List();
                            }

                          }
                          catch(e){
                            print(e);
                            Navigator.of(context).pop();
                          }
                          _customerModel
                            ..name = getName(
                                cData.contactData?.name?.split(' ')[0],
                                cData.mobileNo)
                            ..mobileNo = cData.mobileNo
                            ..ulId = cid.customerInfo?.id.toString()
                            ..avatar = avatar
                            ..chatId = cData.chatId;
                          final localCustId = await repository.queries
                              .getCustomerId(cData.mobileNo!)
                              .timeout(Duration(seconds: 30),
                                  onTimeout: () async {
                            Navigator.of(context).pop();
                            return Future.value(null);
                          });
                          final uniqueId = Uuid().v1();
                          if (localCustId.isEmpty) {
                           /* var avatar = cData.profilePic!.isNotEmpty &&
                                    cData.profilePic != null &&
                                    cData.profilePic != 'null'
                                ? (await NetworkAssetBundle(
                                            Uri.parse(cData.profilePic!))
                                        .load(cData.profilePic!))
                                    .buffer
                                    .asUint8List()
                                : null;*/
                            final customer = CustomerModel()
                              ..name = getName(
                                  cData.contactData?.name?.split(' ')[0].trim(),
                                  cData.mobileNo!)
                              ..mobileNo = (cData.mobileNo!)
                              ..avatar = avatar
                              ..customerId = uniqueId
                              ..businessId = Provider.of<BusinessProvider>(
                                      context,
                                      listen: false)
                                  .selectedBusiness
                                  .businessId
                              ..chatId = cData.chatId
                              ..isChanged = true;
                            await repository.queries
                                .insertCustomer(customer)
                                .timeout(Duration(seconds: 30),
                                    onTimeout: () async {
                              Navigator.of(context).pop();
                              return Future.value(null);
                            });
                            if (await checkConnectivity) {
                              final apiResponse = await (repository.customerApi
                                  .saveCustomer(customer, context,
                                      AddCustomers.ADD_NEW_CUSTOMER)
                                  .timeout(Duration(seconds: 30),
                                      onTimeout: () async {
                                Navigator.of(context).pop();
                                return Future.value(null);
                              }).catchError((e) {
                                recordError(e, StackTrace.current);
                                return false;
                              }));
                              // if (apiResponse.isNotEmpty) {
                              //   ///update chat id here
                              //   await repository.queries
                              //       .updateCustomerIsChanged(0, customer.customerId, apiResponse);
                              // }
                              if (apiResponse) {
                                ///update chat id here
                                final Messages msg =
                                    Messages(messages: '', messageType: 100);
                                var jsondata = jsonEncode(msg);
                                ChatRepository _chatRepository =
                                    ChatRepository();
                                final response = await _chatRepository
                                    .sendMessage(
                                        _customerModel.mobileNo.toString(),
                                        _customerModel.name,
                                        jsondata,
                                        localCustId.isEmpty
                                            ? uniqueId
                                            : localCustId,
                                        Provider.of<BusinessProvider>(context,
                                                listen: false)
                                            .selectedBusiness
                                            .businessId)
                                    .timeout(Duration(seconds: 30),
                                        onTimeout: () async {
                                  Navigator.of(context).pop();
                                  return Future.value(null);
                                });
                                final messageResponse =
                                    Map<String, dynamic>.from(
                                        jsonDecode(response.body));
                                Message _message = Message.fromJson(
                                    messageResponse['message']);
                                if (_message.chatId.toString().isNotEmpty) {
                                  await repository.queries
                                      .updateCustomerIsChanged(
                                          0,
                                          _customerModel.customerId!,
                                          _message.chatId)
                                      .timeout(Duration(seconds: 30),
                                          onTimeout: () async {
                                    Navigator.of(context).pop();
                                    return Future.value(null);
                                  });
                                }
                              }
                            }
                            BlocProvider.of<ContactsCubit>(context).getContacts(
                                Provider.of<BusinessProvider>(context,
                                        listen: false)
                                    .selectedBusiness
                                    .businessId);
                          }
                          setState(() {
                            debugPrint(
                                'Check' + _customerModel.customerId.toString());
                          });
                          if (cid.customerInfo?.id == null) {
                            Navigator.of(context).pop(true);
                            MerchantBankNotAdded.showBankNotAddedDialog(
                                context, 'userNotRegistered');
                            // userNotRegisteredDialog();
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return NonULDialog();
                            //   },
                            // );

                          }
                          //else if (Repository()
                          //         .hiveQueries
                          //         .userData
                          //         .kycStatus ==
                          //     0) {
                          //   Navigator.of(context).pop();
                          //   MerchantBankNotAdded.showBankNotAddedDialog(
                          //       context, 'userKYCPending');
                          // } else if (Repository()
                          //         .hiveQueries
                          //         .userData
                          //         .kycStatus ==
                          //     2) {
                          //   await getKyc().then((value) {
                          //     Navigator.of(context).pop();
                          //     MerchantBankNotAdded.showBankNotAddedDialog(
                          //         context, 'userKYCVerificationPending');
                          //   });
                          // }
                          else if (cid.customerInfo?.bankAccountStatus ==
                              false) {
                            Navigator.of(context).pop(true);

                            merchantBankNotAddedModalSheet(
                                text:
                                    Constants.merchentKYCBANKPREMNotadd);
                          } else if (cid.customerInfo?.kycStatus == false) {
                            Navigator.of(context).pop(true);
                            merchantBankNotAddedModalSheet(
                                text:
                                    Constants.merchentKYCBANKPREMNotadd);
                          }
                          // else if (Repository()
                          //             .hiveQueries
                          //             .userData
                          //             .kycStatus ==
                          //         1 &&
                          //     Repository()
                          //             .hiveQueries
                          //             .userData
                          //             .premiumStatus ==
                          //         0) {
                          //   Navigator.of(context).pop(true);
                          //   debugPrint('Checket');
                          //   MerchantBankNotAdded.showBankNotAddedDialog(
                          //       context, 'upgradePremium');
                          // }
                          else if (merchantSubscriptionPlan == false) {
                            Navigator.of(context).pop(true);
                            debugPrint('Checket');
                            merchantBankNotAddedModalSheet(
                                text:
                                    Constants.merchentKYCBANKPREMNotadd);
                          } else {
                            Map<String, dynamic> isTransaction =
                                await repository.paymentThroughQRApi
                                    .getTransactionLimit(context);
                            if (!(isTransaction)['isError']) {
                              Navigator.of(context).pop(true);
                              // showBankAccountDialog();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PayTransactionScreen(
                                      model: _customerModel,
                                      customerId: localCustId.isEmpty
                                          ? uniqueId
                                          : localCustId,
                                      type: 'DIRECT',
                                      suspense: true,
                                      through: 'DIRECT'),
                                ),
                              );
                            } else {
                              Navigator.of(context).pop(true);
                              '${(isTransaction)['message']}'
                                  .showSnackBar(context);
                            }
                          }

                          // Navigator.of(context).pop();

                          //Navigation func to make the naviagation dynamic

                          //TODO

                        } else {
                          // CustomLoadingDialog.showLoadingDialog(context, key);
                          // var cid = await repository.customerApi
                          //     .getCustomerID(
                          //         mobileNumber: widget
                          //             .contacts[index].mobileNo
                          //             .toString());
                          // bool? merchantSubscriptionPlan =
                          //     cid.customerInfo?.merchantSubscriptionPlan ??
                          //         false;
                          if (await allChecker(context)) {
                            CustomLoadingDialog.showLoadingDialog(context, key);
                            // var cid = await repository.customerApi.getCustomerID(
                            //     mobileNumber:
                            //         widget.contacts[index].mobileNo.toString());
                            var avatar;
                            try{
                              /*avatar = cData.profilePic!.isNotEmpty &&
                                cData.profilePic != null &&
                                cData.profilePic != 'null'
                                ? (await NetworkAssetBundle(
                                Uri.parse(cData.profilePic!))
                                .load(cData.profilePic!))
                                .buffer
                                .asUint8List()
                                : [];*/
                              if(cData.profilePic!=null){
                                avatar=(await NetworkAssetBundle(
                                    Uri.parse(cData.profilePic!))
                                    .load(cData.profilePic!))
                                    .buffer
                                    .asUint8List();
                              }

                            }
                            catch(e){
                              print(e);
                              Navigator.of(context).pop();
                            }
                            _customerModel
                              ..name = getName(
                                  cData.contactData?.name?.split(' ')[0],
                                  cData.mobileNo)
                              ..mobileNo = cData.mobileNo
                              ..ulId = cData.id
                              ..avatar = avatar
                              ..chatId = cData.chatId;
                            final localCustId = await repository.queries
                                .getCustomerId(cData.mobileNo!);
                            debugPrint('ww: ' + _customerModel.toString());
                            Navigator.of(context).pop(true);
                            await Navigator.of(context).pushNamed(
                                AppRoutes.requestTransactionRoute,
                                arguments: ReceiveTransactionArgs(
                                    _customerModel, localCustId));
                            print('teest');
                          }
                        }
                      },
                child: GridTile(
                  header: CircleAvatar(
                    radius: 28.0,
                    backgroundImage: cData.profilePic != null &&
                            cData.profilePic!.isNotEmpty &&
                            cData.profilePic! != "null"
                        ? NetworkImage('$baseImageUrl' + cData.profilePic!)
                        : null,
                    child: cData.profilePic != null &&
                            cData.profilePic!.isNotEmpty &&
                            cData.profilePic! != "null"
                        ? Container()
                        : CustomText(
                            getInitials(cData.contactData?.name,
                                    cData.mobileNo?.trim() ?? '')
                                .toUpperCase(),
                            color: AppTheme.circularAvatarTextColor,
                            size: 22,
                          ),
                    //  backgroundColor: _colors[Random().nextInt(_colors.length)],
                    backgroundColor: bg_color,
                  ),
                  footer: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        cData.contactData!.name!,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.brownishGrey),
                      )),
                  child: Container(),
                ),
              );
            }),
      ),
    );
  }

  getCustomerRankingList(
      RequestType type, int pageNo, BuildContext context, bool apiFetch) async {
    if (apiFetch) {
      if (type == RequestType.PAY) {
        await BlocProvider.of<CustomerRankingPayCubit>(context, listen: false)
            .getCustomerRankingPayTransactions(type, pageNo, context);
      } else {
        await BlocProvider.of<CustomerRankingRequestCubit>(context,
                listen: false)
            .getCustomerRankingRequestTransactions(type, pageNo, context);
      }
    } else {
      if (type == RequestType.PAY) {
        await BlocProvider.of<CustomerRankingPayCubit>(context, listen: false)
            .getCustomerRankingPayTransactionsOffline(type, pageNo);
      } else {
        await BlocProvider.of<CustomerRankingRequestCubit>(context,
                listen: false)
            .getCustomerRankingRequestTransactionsOffline(type, pageNo);
      }
    }
  }

  merchantBankNotAddedModalSheet({text}) {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          return Container(
            color: Color(0xFF737373), //could change this to Color(0xFF737373),

            height: MediaQuery.of(context).size.height * 0.27,
            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              //height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 40.0,
                        left: 40.0,
                        right: 40.0,
                        bottom: 10,
                      ),
                      child: Text(
                        '$text',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.brownishGrey,
                            fontFamily: 'SFProDisplay',
                            fontSize: 18,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Please try again later.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.tomato,
                            fontFamily: 'SFProDisplay',
                            fontSize: 18,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.w700,
                            height: 1),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: NewCustomButton(
                        onSubmit: () {
                          Navigator.pop(context);
                        },
                        textColor: Colors.white,
                        text: 'OKAY',
                        textSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Future getKyc() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   await KycAPI.kycApiProvider.kycCheker().then((value) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     debugPrint('Check the value : ' + value['status'].toString());

  //     if (value != null && value.toString().isNotEmpty) {
  //       if (mounted) {
  //         setState(() {
  //           Repository().hiveQueries.insertUserData(Repository()
  //               .hiveQueries
  //               .userData
  //               .copyWith(
  //                   kycStatus:
  //                       (value['isVerified'] == true && value['status'] == true)
  //                           ? 1
  //                           : (value['emirates'] &&
  //                                   value['tl'] == true &&
  //                                   value['status'] == false)
  //                               ? 2
  //                               : 0,
  //                   premiumStatus:
  //                       value['planDuration'].toString() == 0.toString()
  //                           ? 0
  //                           : int.tryParse(value['planDuration']),
  //                   isEmiratesIdDone: value['emirates'] ?? false,
  //                   isTradeLicenseDone: value['tl'] ?? false));

  //           //TODO Need to set emirates iD and TradeLicense ID Values
  //           // isEmiratesIdDone = value['emirates'] ?? false;
  //           // isTradeLicenseDone = value['tl'] ?? false;
  //           // status = value['status'] ?? false;
  //           // isPremium = value['premium'] ?? false;

  //           // debugPrint('check1' + status.toString());
  //           // debugPrint('check' + isEmiratesIdDone.toString());
  //         });
  //         return;
  //       }
  //     }
  //   });
  //   calculatePremiumDate();
  //   setState(() {
  //     isLoading = false;
  //   });
  // }
}

Widget contactListWithOtherWidgets(
        {required List<CustomerModel> contacts,
        String? searchQuery,
        bool? navigationtoPay,
        required BuildContext context}) =>
    ImportContactsListWidget(
      contacts: contacts,
      navigation: navigationtoPay,
    );

class ImportContactsListWidget extends StatefulWidget {
  final List<CustomerModel> contacts;
  final bool? navigation;

  ImportContactsListWidget(
      {Key? key, required this.contacts, this.navigation = true})
      : super(key: key);

  @override
  _ImportContactsListWidgetState createState() =>
      _ImportContactsListWidgetState();
}

class _ImportContactsListWidgetState extends State<ImportContactsListWidget> {
  // final List<Color> _colors = [
  //   Color.fromRGBO(137, 171, 249, 1),
  //   AppTheme.brownishGrey,
  //   AppTheme.greyish,
  //   AppTheme.electricBlue,
  // ];
  //
  // Random random = Random();
  final GlobalKey<State> key = GlobalKey<State>();
  CustomerModel _customerModel = CustomerModel();
  ChatRepository _chatRepository = ChatRepository();
  bool isEmiratesIdDone = false;
  bool isTradeLicenseDone = false;
  bool status = false;
  bool isPremium = false;
  bool isNotAccount = false;
  getRecentBankAcc() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });

      await Provider.of<UserBankAccountProvider>(context, listen: false)
          .getUserBankAccount();
      isNotAccount =
          Provider.of<UserBankAccountProvider>(context, listen: false)
              .isAccount;
      debugPrint(isNotAccount.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  // modalSheet() {
  //   return showModalBottomSheet(
  //       context: context,
  //       isDismissible: true,
  //       enableDrag: true,
  //       builder: (context) {
  //         return Container(
  //           color: Color(0xFF737373), //could change this to Color(0xFF737373),
  //           height: (isEmiratesIdDone == false &&
  //                   isTradeLicenseDone == false &&
  //                   isPremium == true)
  //               ? MediaQuery.of(context).size.height * 0.25
  //               : MediaQuery.of(context).size.height * 0.4,
  //           child: Container(
  //             decoration: new BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: new BorderRadius.only(
  //                     topLeft: const Radius.circular(10.0),
  //                     topRight: const Radius.circular(10.0))),
  //             //height: MediaQuery.of(context).size.height * 0.25,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Padding(
  //                   padding: const EdgeInsets.only(
  //                     top: 40.0,
  //                     left: 40.0,
  //                     right: 40.0,
  //                     bottom: 10,
  //                   ),
  //                   child: (isEmiratesIdDone == false &&
  //                           isTradeLicenseDone == false &&
  //                           isPremium == true)
  //                       ? Text(
  //                           'Please upgrade your Urban Ledger account in order to access this feature.',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               color: Color.fromRGBO(233, 66, 53, 1),
  //                               fontFamily: 'SFProDisplay',
  //                               fontSize: 18,
  //                               letterSpacing:
  //                                   0 /*percentages not used in flutter. defaulting to zero*/,
  //                               fontWeight: FontWeight.normal,
  //                               height: 1),
  //                         )
  //                       : Text(
  //                           (isEmiratesIdDone == true &&
  //                                   isTradeLicenseDone == true)
  //                               ? 'KYC verification is pending.\nPlease try after some time.'
  //                               : 'KYC is a mandatory step for\nPremium features.',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               color: Color.fromRGBO(233, 66, 53, 1),
  //                               fontFamily: 'SFProDisplay',
  //                               fontSize: 18,
  //                               letterSpacing:
  //                                   0 /*percentages not used in flutter. defaulting to zero*/,
  //                               fontWeight: FontWeight.normal,
  //                               height: 1),
  //                         ),
  //                 ),
  //                 if (isPremium == false)
  //                   Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Container(
  //                               margin: EdgeInsets.symmetric(horizontal: 10),
  //                               child: Image.asset(
  //                                 'assets/icons/emiratesid.png',
  //                                 height: 35,
  //                               ),
  //                             ),
  //                             Text(
  //                               'Emirates ID',
  //                               style: TextStyle(
  //                                   color: Color(0xff666666),
  //                                   fontFamily: 'SFProDisplay',
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 17),
  //                             ),
  //                           ],
  //                         ),
  //                         isTradeLicenseDone == false
  //                             ? Icon(
  //                                 Icons.chevron_right,
  //                                 size: 32,
  //                                 color: Color(0xff666666),
  //                               )
  //                             : CircleAvatar(
  //                                 backgroundColor: Colors.green,
  //                                 radius: 20,
  //                                 child: Center(
  //                                   child: Icon(
  //                                     Icons.check,
  //                                     color: Colors.white,
  //                                   ),
  //                                 ),
  //                               )
  //                       ],
  //                     ),
  //                   ),
  //                 if (isPremium == false)
  //                   Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Container(
  //                               margin: EdgeInsets.symmetric(horizontal: 10),
  //                               child: Image.asset(
  //                                 'assets/icons/tradelisc.png',
  //                                 height: 35,
  //                               ),
  //                             ),
  //                             Text(
  //                               'UAE Trade License',
  //                               style: TextStyle(
  //                                   color: Color(0xff666666),
  //                                   fontFamily: 'SFProDisplay',
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 17),
  //                             ),
  //                           ],
  //                         ),
  //                         isTradeLicenseDone == false
  //                             ? Icon(
  //                                 Icons.chevron_right,
  //                                 size: 32,
  //                                 color: Color(0xff666666),
  //                               )
  //                             : CircleAvatar(
  //                                 backgroundColor: Colors.green,
  //                                 radius: 20,
  //                                 child: Center(
  //                                   child: Icon(
  //                                     Icons.check,
  //                                     color: Colors.white,
  //                                   ),
  //                                 ),
  //                               )
  //                       ],
  //                     ),
  //                   ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(20.0),
  //                   child: (isEmiratesIdDone == true &&
  //                           isTradeLicenseDone == true)
  //                       ? NewCustomButton(
  //                           onSubmit: () {
  //                             Navigator.pop(context);
  //                           },
  //                           textColor: Colors.white,
  //                           text: 'OKAY',
  //                           textSize: 14,
  //                         )
  //                       : (isEmiratesIdDone == false &&
  //                               isTradeLicenseDone == false &&
  //                               isPremium == true)
  //                           ? Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.pop(context);
  //                                     },
  //                                     text: 'CANCEL',
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   width: 20,
  //                                 ),
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.popAndPushNamed(context,
  //                                           AppRoutes.urbanLedgerPremium);
  //                                     },
  //                                     text: 'Upgrade'.toUpperCase(),
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                               ],
  //                             )
  //                           : Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.pop(context);
  //                                     },
  //                                     text: 'CANCEL',
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   width: 20,
  //                                 ),
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.popAndPushNamed(
  //                                           context, AppRoutes.manageKyc3Route);
  //                                     },
  //                                     text: 'COMPLETE KYC',
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
  // modalSheet() {
  //   return showModalBottomSheet(
  //       context: context,
  //       isDismissible: true,
  //       enableDrag: true,
  //       builder: (context) {
  //         return Container(
  //           color: Color(0xFF737373), //could change this to Color(0xFF737373),
  //           height: (status == true)
  //               ? MediaQuery.of(context).size.height * 0.25
  //               : MediaQuery.of(context).size.height * 0.4,
  //           child: Container(
  //             decoration: new BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: new BorderRadius.only(
  //                     topLeft: const Radius.circular(10.0),
  //                     topRight: const Radius.circular(10.0))),
  //             //height: MediaQuery.of(context).size.height * 0.25,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Padding(
  //                   padding: const EdgeInsets.only(
  //                     top: 40.0,
  //                     left: 40.0,
  //                     right: 40.0,
  //                     bottom: 10,
  //                   ),
  //                   child: (status == true && isPremium == false)
  //                       ? Text(
  //                           'Please upgrade your Urban Ledger account in order to access this feature.',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               color: AppTheme.brownishGrey,
  //                               fontFamily: 'SFProDisplay',
  //                               fontSize: 18,
  //                               letterSpacing:
  //                                   0 /*percentages not used in flutter. defaulting to zero*/,
  //                               fontWeight: FontWeight.bold,
  //                               height: 1),
  //                         )
  //                       : Text(
  //                           (isEmiratesIdDone == true &&
  //                                   isTradeLicenseDone == true)
  //                               ? 'KYC verification is pending.\nPlease try after some time.'
  //                               : 'KYC is a mandatory step for\nPremium features.',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               color: Color.fromRGBO(233, 66, 53, 1),
  //                               fontFamily: 'SFProDisplay',
  //                               fontSize: 18,
  //                               letterSpacing:
  //                                   0 /*percentages not used in flutter. defaulting to zero*/,
  //                               fontWeight: FontWeight.normal,
  //                               height: 1),
  //                         ),
  //                 ),
  //                 if (status == false)
  //                   Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Container(
  //                               margin: EdgeInsets.symmetric(horizontal: 10),
  //                               child: Image.asset(
  //                                 'assets/icons/emiratesid.png',
  //                                 height: 35,
  //                               ),
  //                             ),
  //                             Text(
  //                               'Emirates ID',
  //                               style: TextStyle(
  //                                   color: Color(0xff666666),
  //                                   fontFamily: 'SFProDisplay',
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 17),
  //                             ),
  //                           ],
  //                         ),
  //                         isTradeLicenseDone == false
  //                             ? Icon(
  //                                 Icons.chevron_right,
  //                                 size: 32,
  //                                 color: Color(0xff666666),
  //                               )
  //                             : CircleAvatar(
  //                                 backgroundColor: Colors.green,
  //                                 radius: 20,
  //                                 child: Center(
  //                                   child: Icon(
  //                                     Icons.check,
  //                                     color: Colors.white,
  //                                   ),
  //                                 ),
  //                               )
  //                       ],
  //                     ),
  //                   ),
  //                 if (status == false)
  //                   Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Container(
  //                               margin: EdgeInsets.symmetric(horizontal: 10),
  //                               child: Image.asset(
  //                                 'assets/icons/tradelisc.png',
  //                                 height: 35,
  //                               ),
  //                             ),
  //                             Text(
  //                               'UAE Trade License',
  //                               style: TextStyle(
  //                                   color: Color(0xff666666),
  //                                   fontFamily: 'SFProDisplay',
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 17),
  //                             ),
  //                           ],
  //                         ),
  //                         isTradeLicenseDone == false
  //                             ? Icon(
  //                                 Icons.chevron_right,
  //                                 size: 32,
  //                                 color: Color(0xff666666),
  //                               )
  //                             : CircleAvatar(
  //                                 backgroundColor: Colors.green,
  //                                 radius: 20,
  //                                 child: Center(
  //                                   child: Icon(
  //                                     Icons.check,
  //                                     color: Colors.white,
  //                                   ),
  //                                 ),
  //                               )
  //                       ],
  //                     ),
  //                   ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(20.0),
  //                   child: (isEmiratesIdDone == true &&
  //                           isTradeLicenseDone == true)
  //                       ? NewCustomButton(
  //                           onSubmit: () {
  //                             Navigator.pop(context);
  //                           },
  //                           textColor: Colors.white,
  //                           text: 'OKAY',
  //                           textSize: 14,
  //                         )
  //                       : (isEmiratesIdDone == false &&
  //                               isTradeLicenseDone == false &&
  //                               isPremium == true)
  //                           ? Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.pop(context);
  //                                     },
  //                                     text: 'CANCEL',
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   width: 20,
  //                                 ),
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.popAndPushNamed(context,
  //                                           AppRoutes.urbanLedgerPremium);
  //                                     },
  //                                     text: 'Upgrade'.toUpperCase(),
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                               ],
  //                             )
  //                           : Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.pop(context);
  //                                     },
  //                                     text: 'CANCEL',
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   width: 20,
  //                                 ),
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.popAndPushNamed(
  //                                           context, AppRoutes.manageKyc3Route);
  //                                     },
  //                                     text: 'COMPLETE KYC',
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  // Future getKyc() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await KycAPI.kycApiProvider.kycCheker().catchError((e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     'Please check your internet connection or try again later.'.showSnackBar(context);
  //   }).then((value) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   });
  //   calculatePremiumDate();
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  // getKyc() async {
  //   await KycAPI.kycApiProvider.kycCheker().then((value) {
  //     debugPrint('Check the value : ' + value.toString());
  //     if (value != null && value.toString().isNotEmpty) {
  //       setState(() {
  //         isEmiratesIdDone = value['emirates'] ?? false;
  //         isTradeLicenseDone = value['tl'] ?? false;
  //         status = value['status'] ?? false;
  //         debugPrint('check1' + status.toString());
  //         debugPrint('check' + isEmiratesIdDone.toString());
  //       });
  //     }
  //   });
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    //Future.delayed(Duration(seconds: 1), () => getKyc()).catchError((err) {});
    // getKyc();
    // getRecentBankAcc();
  }

  bool isLoading = false;

  merchantBankNotAddedModalSheet({text}) {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          return Container(
            color: Color(0xFF737373), //could change this to Color(0xFF737373),

            height: MediaQuery.of(context).size.height * 0.27,
            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              //height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                      left: 40.0,
                      right: 40.0,
                      bottom: 10,
                    ),
                    child: Text(
                      '$text',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppTheme.brownishGrey,
                          fontFamily: 'SFProDisplay',
                          fontSize: 18,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Please try again later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppTheme.tomato,
                          fontFamily: 'SFProDisplay',
                          fontSize: 18,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.w700,
                          height: 1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: NewCustomButton(
                      onSubmit: () {
                        Navigator.pop(context);
                      },
                      textColor: Colors.white,
                      text: 'OKAY',
                      textSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // removed loader for performance issue
    return isLoading == true
        ? SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(color: AppTheme.electricBlue,),
            ),
          )
        : /*ListView.builder(
          //padding: EdgeInsets.zero,
          itemCount: widget.contacts.length,
          itemBuilder: (BuildContext context, int index) {

          },
        );*/
        SliverList(
            delegate: SliverChildBuilderDelegate(
            (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: Repository().hiveQueries.userData.bankStatus == false &&
                        widget.navigation == false
                    ? () {
                        MerchantBankNotAdded.showBankNotAddedDialog(
                            context, 'userBankNotAdded');
                      }
                    // : ((Repository().hiveQueries.userData.kycStatus == 0 ||
                    //                 Repository().hiveQueries.userData.kycStatus ==
                    //                     2) ||
                    //             Repository().hiveQueries.userData.premiumStatus ==
                    //                 0) &&
                    //     widget.navigation == false
                    // ? () async {
                    //     CustomLoadingDialog.showLoadingDialog(context, key);
                    //     var cid = await repository.customerApi.getCustomerID(
                    //         mobileNumber:
                    //             widget.contacts[index].mobileNo.toString());
                    //     bool? merchantSubscriptionPlan =
                    //         cid.customerInfo?.merchantSubscriptionPlan ?? false;
                    //     if (Repository().hiveQueries.userData.kycStatus == 2) {
                    //       //If KYC is Verification is Pending
                    //       await getKyc().then((value) =>
                    //           MerchantBankNotAdded.showBankNotAddedDialog(
                    //               context, 'userKYCVerificationPending'));
                    //     } else if (Repository()
                    //             .hiveQueries
                    //             .userData
                    //             .kycStatus ==
                    //         0) {
                    //       Navigator.of(context).pop(true);
                    //       //KYC WHEN USER STARTS A NEW KYC JOURNEY
                    //       MerchantBankNotAdded.showBankNotAddedDialog(
                    //           context, 'userKYCPending');
                    //     } else if (Repository()
                    //                 .hiveQueries
                    //                 .userData
                    //                 .kycStatus ==
                    //             0 &&
                    //         Repository()
                    //                 .hiveQueries
                    //                 .userData
                    //                 .isEmiratesIdDone ==
                    //             false) {
                    //       Navigator.of(context).pop(true);
                    //       //KYC WHEN USER STARTS EMirates ID Journey but not done TRade License
                    //       MerchantBankNotAdded.showBankNotAddedDialog(
                    //           context, 'EmiratesIdPending');
                    //     } else if (Repository()
                    //                 .hiveQueries
                    //                 .userData
                    //                 .kycStatus ==
                    //             0 &&
                    //         Repository()
                    //                 .hiveQueries
                    //                 .userData
                    //                 .isTradeLicenseDone ==
                    //             false) {
                    //       Navigator.of(context).pop(true);
                    //       //KYC WHEN USER STARTS EMirates ID Journey but not done TRade License
                    //       MerchantBankNotAdded.showBankNotAddedDialog(
                    //           context, 'TradeLicensePending');
                    //     } else if (Repository()
                    //                 .hiveQueries
                    //                 .userData
                    //                 .kycStatus ==
                    //             1 &&
                    //         Repository().hiveQueries.userData.premiumStatus ==
                    //             0) {
                    //       Navigator.of(context).pop(true);
                    //       MerchantBankNotAdded.showBankNotAddedDialog(
                    //           context, 'upgradePremium');
                    //     } else if (cid.customerInfo?.kycStatus == false) {
                    //       Navigator.of(context).pop(true);
                    //       merchantBankNotAddedModalSheet(
                    //           text:
                    //               'Your merchant has not completed the KYC or KYC is expired. We have requested merchant to complete KYC.');
                    //     } else if (merchantSubscriptionPlan == false) {
                    //       Navigator.of(context).pop(true);
                    //       merchantBankNotAddedModalSheet(
                    //           text:
                    //               'We have requested your merchant to Switch to Premium now to enjoy the benefits.');
                    //     } else {
                    //       // CustomLoadingDialog.showLoadingDialog(context, key);
                    //       // var cid = await repository.customerApi.getCustomerID(
                    //       //     mobileNumber:
                    //       //         widget.contacts[index].mobileNo.toString());
                    //       _customerModel
                    //         ..name = getName(widget.contacts[index].name,
                    //             widget.contacts[index].mobileNo)
                    //         ..mobileNo = widget.contacts[index].mobileNo
                    //         ..ulId = cid.customerInfo?.id.toString()
                    //         ..avatar = widget.contacts[index].avatar
                    //         ..chatId = widget.contacts[index].chatId;
                    //       final localCustId = await repository.queries
                    //           .getCustomerId(widget.contacts[index].mobileNo!);
                    //       // Navigator.of(context).pop(true);
                    //       Navigator.of(context).popAndPushNamed(
                    //           AppRoutes.requestTransactionRoute,
                    //           arguments: ReceiveTransactionArgs(
                    //               _customerModel, localCustId));
                    //     }
                    //   }
                    : () async {
                        if (widget.navigation == true) {
                          CustomLoadingDialog.showLoadingDialog(context, key);
                          var cid = await repository.customerApi
                              .getCustomerID(
                                  mobileNumber: widget.contacts[index].mobileNo
                                      .toString())
                              .timeout(Duration(seconds: 30),
                                  onTimeout: () async {
                            Navigator.of(context).pop();
                            return Future.value(null);
                          }).catchError((e) {
                            Navigator.of(context).pop();
                            'Please check internet connectivity and try again.'
                                .showSnackBar(context);
                          });
                          bool? merchantSubscriptionPlan =
                              cid.customerInfo?.merchantSubscriptionPlan ??
                                  false;
                          debugPrint(
                              widget.contacts[index].mobileNo.toString());
                          debugPrint(widget.contacts[index].name);
                          debugPrint(widget.contacts[index].chatId);
                          debugPrint(cid.customerInfo?.id.toString());
                          _customerModel
                            ..name = getName(widget.contacts[index].name,
                                widget.contacts[index].mobileNo)
                            ..mobileNo = widget.contacts[index].mobileNo
                            ..ulId = cid.customerInfo?.id.toString()
                            ..avatar = widget.contacts[index].avatar
                            ..chatId = widget.contacts[index].chatId;
                          final localCustId = await repository.queries
                              .getCustomerId(widget.contacts[index].mobileNo!)
                              .timeout(Duration(seconds: 30),
                                  onTimeout: () async {
                            Navigator.of(context).pop();
                            return Future.value(null);
                          });
                          final uniqueId = Uuid().v1();
                          if (localCustId.isEmpty) {
                            final customer = CustomerModel()
                              ..name = getName(
                                  widget.contacts[index].name!.trim(),
                                  widget.contacts[index].mobileNo!)
                              ..mobileNo = (widget.contacts[index].mobileNo!)
                              ..avatar = widget.contacts[index].avatar
                              ..customerId = uniqueId
                              ..businessId = Provider.of<BusinessProvider>(
                                      context,
                                      listen: false)
                                  .selectedBusiness
                                  .businessId
                              ..chatId = widget.contacts[index].chatId
                              ..isChanged = true;
                            await repository.queries
                                .insertCustomer(customer)
                                .timeout(Duration(seconds: 30),
                                    onTimeout: () async {
                              Navigator.of(context).pop();
                              return Future.value(null);
                            });
                            if (await checkConnectivity) {
                              final apiResponse = await (repository.customerApi
                                  .saveCustomer(customer, context,
                                      AddCustomers.ADD_NEW_CUSTOMER)
                                  .timeout(Duration(seconds: 30),
                                      onTimeout: () async {
                                Navigator.of(context).pop();
                                return Future.value(null);
                              }).catchError((e) {
                                Navigator.of(context).pop();
                                'Please check internet connectivity and try again.'
                                    .showSnackBar(context);
                              }));
                              // if (apiResponse.isNotEmpty) {
                              //   ///update chat id here
                              //   await repository.queries
                              //       .updateCustomerIsChanged(0, customer.customerId, apiResponse);
                              // }
                              if (apiResponse) {
                                ///update chat id here
                                final Messages msg =
                                    Messages(messages: '', messageType: 100);
                                var jsondata = jsonEncode(msg);
                                final response = await _chatRepository
                                    .sendMessage(
                                        _customerModel.mobileNo.toString(),
                                        _customerModel.name,
                                        jsondata,
                                        localCustId.isEmpty
                                            ? uniqueId
                                            : localCustId,
                                        Provider.of<BusinessProvider>(context,
                                                listen: false)
                                            .selectedBusiness
                                            .businessId)
                                    .timeout(Duration(seconds: 30),
                                        onTimeout: () async {
                                  Navigator.of(context).pop();
                                  return Future.value(null);
                                });
                                final messageResponse =
                                    Map<String, dynamic>.from(
                                        jsonDecode(response.body));
                                Message _message = Message.fromJson(
                                    messageResponse['message']);
                                if (_message.chatId.toString().isNotEmpty) {
                                  await repository.queries
                                      .updateCustomerIsChanged(
                                          0,
                                          _customerModel.customerId!,
                                          _message.chatId)
                                      .timeout(Duration(seconds: 30),
                                          onTimeout: () async {
                                    Navigator.of(context).pop();
                                    return Future.value(null);
                                  });
                                }
                              }
                            }
                            BlocProvider.of<ContactsCubit>(context).getContacts(
                                Provider.of<BusinessProvider>(context,
                                        listen: false)
                                    .selectedBusiness
                                    .businessId);
                          }
                          setState(() {
                            debugPrint(
                                'Check' + _customerModel.customerId.toString());
                          });
                          if (cid.customerInfo?.id == null) {
                            Navigator.of(context).pop(true);
                            MerchantBankNotAdded.showBankNotAddedDialog(
                                context, 'userNotRegistered');
                            // userNotRegisteredDialog();
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return NonULDialog();
                            //   },
                            // );

                          }
                          //else if (Repository()
                          //         .hiveQueries
                          //         .userData
                          //         .kycStatus ==
                          //     0) {
                          //   Navigator.of(context).pop();
                          //   MerchantBankNotAdded.showBankNotAddedDialog(
                          //       context, 'userKYCPending');
                          // } else if (Repository()
                          //         .hiveQueries
                          //         .userData
                          //         .kycStatus ==
                          //     2) {
                          //   await getKyc().then((value) {
                          //     Navigator.of(context).pop();
                          //     MerchantBankNotAdded.showBankNotAddedDialog(
                          //         context, 'userKYCVerificationPending');
                          //   });
                          // }
                          else if (cid.customerInfo?.bankAccountStatus ==
                              false) {
                            Navigator.of(context).pop(true);

                            merchantBankNotAddedModalSheet(
                                text:
                                    Constants.merchentKYCBANKPREMNotadd);
                          } else if (cid.customerInfo?.kycStatus == false) {
                            Navigator.of(context).pop(true);
                            merchantBankNotAddedModalSheet(
                                text:
                                    Constants.merchentKYCBANKPREMNotadd);
                          }
                          // else if (Repository()
                          //             .hiveQueries
                          //             .userData
                          //             .kycStatus ==
                          //         1 &&
                          //     Repository()
                          //             .hiveQueries
                          //             .userData
                          //             .premiumStatus ==
                          //         0) {
                          //   Navigator.of(context).pop(true);
                          //   debugPrint('Checket');
                          //   MerchantBankNotAdded.showBankNotAddedDialog(
                          //       context, 'upgradePremium');
                          // }
                          else if (merchantSubscriptionPlan == false) {
                            Navigator.of(context).pop(true);
                            debugPrint('Checket');
                            merchantBankNotAddedModalSheet(
                                text: Constants.merchentKYCBANKPREMNotadd);
                          } else {
                            Map<String, dynamic> isTransaction =
                                await repository.paymentThroughQRApi
                                    .getTransactionLimit(context)
                                    .catchError((e) {
                              Navigator.of(context).pop();
                              'Please check internet connectivity and try again.'
                                  .showSnackBar(context);
                            });
                            if (!(isTransaction)['isError']) {
                              Navigator.of(context).pop(true);
                              // showBankAccountDialog();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PayTransactionScreen(
                                      model: _customerModel,
                                      customerId: localCustId.isEmpty
                                          ? uniqueId
                                          : localCustId,
                                      type: 'DIRECT',
                                      suspense: true,
                                      through: 'DIRECT'),
                                ),
                              );
                            } else {
                              Navigator.of(context).pop(true);
                              '${(isTransaction)['message']}'
                                  .showSnackBar(context);
                            }
                          }

                          // Navigator.of(context).pop();

                          //Navigation func to make the naviagation dynamic

                          //TODO

                        } else {
                          // CustomLoadingDialog.showLoadingDialog(context, key);
                          // var cid = await repository.customerApi
                          //     .getCustomerID(
                          //         mobileNumber: widget
                          //             .contacts[index].mobileNo
                          //             .toString());
                          // bool? merchantSubscriptionPlan =
                          //     cid.customerInfo?.merchantSubscriptionPlan ??
                          //         false;
                          CustomLoadingDialog.showLoadingDialog(context, key);
                          var cid = await repository.customerApi
                              .getCustomerID(
                              mobileNumber: widget.contacts[index].mobileNo
                                  .toString())
                              .timeout(Duration(seconds: 30),
                              onTimeout: () async {
                                Navigator.of(context).pop();
                                return Future.value(null);
                              }).catchError((e) {
                            Navigator.of(context).pop();
                            'Please check internet connectivity and try again.'
                                .showSnackBar(context);
                          });
                          if (cid.customerInfo?.id == null) {
                            Navigator.of(context).pop(true);
                            MerchantBankNotAdded.showBankNotAddedDialog(
                                context, 'userNotRegistered');
                            return;
                            // userNotRegisteredDialog();
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return NonULDialog();
                            //   },
                            // );

                          }
                          if (await allChecker(context,showLoader: false)) {
                            // CustomLoadingDialog.showLoadingDialog(context, key);
                            var cid = await repository.customerApi
                                .getCustomerID(
                                    mobileNumber: widget
                                        .contacts[index].mobileNo
                                        .toString())
                                .catchError((e) {
                              Navigator.of(context).pop();
                              'Please check internet connectivity and try again.'
                                  .showSnackBar(context);
                            });
                            _customerModel
                              ..name = getName(widget.contacts[index].name,
                                  widget.contacts[index].mobileNo)
                              ..mobileNo = widget.contacts[index].mobileNo
                              ..ulId = widget.contacts[index].customerId
                              ..customerId = cid.customerInfo?.id ?? cid.id
                              ..avatar = widget.contacts[index].avatar
                              ..chatId = widget.contacts[index].chatId;
                            final localCustId = await repository.queries
                                .getCustomerId(
                                    widget.contacts[index].mobileNo!);
                            debugPrint('ww: ' +
                                widget.contacts[index].customerId.toString());
                            Navigator.of(context).pop(true);
                            Navigator.of(context).pushNamed(
                                AppRoutes.requestTransactionRoute,
                                arguments: ReceiveTransactionArgs(
                                    _customerModel, localCustId));
                            print('teest');
                          }
                        }
                      },
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: CustomProfileImage(
                            avatar: widget.contacts[index].avatar,
                            mobileNo: widget.contacts[index].mobileNo,
                            name: widget.contacts[index].name,
                          ),

                          // child: CircleAvatar(
                          //   radius: 25,
                          //   backgroundColor: _colors[random.nextInt(_colors.length)],
                          //   backgroundImage: widget.contacts[index].avatar!.isEmpty
                          //       ? null
                          //       : MemoryImage(widget.contacts[index].avatar!),
                          //   child: widget.contacts[index].avatar!.isEmpty
                          //       ? CustomText(
                          //           getInitials(widget.contacts[index].name,
                          //               widget.contacts[index].mobileNo),
                          //           color: AppTheme.circularAvatarTextColor,
                          //           size: 27,
                          //         )
                          //       : null,
                          // ),
                        ),
                        Expanded(
                          child: Container(
                            // width: screenWidth(context) * 0.49,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  getName(widget.contacts[index].name,
                                      widget.contacts[index].mobileNo),
                                  bold: FontWeight.bold,
                                  color: AppTheme.blackColor,
                                ),
                                CustomText(
                                  '+' +
                                          widget.contacts[index].mobileNo
                                              .toString() ??
                                      '',
                                  color: AppTheme.greyish,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        FutureBuilder<bool>(
                          future: widget.contacts[index].isAdded,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data != null)
                              return CustomText(
                                snapshot.data ? 'Already Added' : '',
                                color: AppTheme.greyish,
                              );
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            childCount: widget.contacts.length,
          ));
  }

  userNotRegisteredDialog() async => await showDialog(
      builder: (context) => Dialog(
            // backgroundColor: AppTheme.electricBlue,
            insetPadding:
                EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.70),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical:10, horizontal:10),
                //   child: Image.asset(AppAssets.notregistered,width: MediaQuery.of(context).size.width * 0.5,),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 5),
                  child: CustomText(
                    "The user is not registered with",
                    color: AppTheme.tomato,
                    bold: FontWeight.w500,
                    size: 18,
                  ),
                ),
                CustomText(
                  'the Urban Ledger app.',
                  color: AppTheme.brownishGrey,
                  bold: FontWeight.w500,
                  size: 18,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: RaisedButton(
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            // color: Color.fromRGBO(137, 172, 255, 1),
                            color: AppTheme.electricBlue,
                            child: CustomText(
                              'Got it'.toUpperCase(),
                              color: Colors.white,
                              size: (18),
                              bold: FontWeight.w500,
                            ),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: RaisedButton(
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            // color: Color.fromRGBO(137, 172, 255, 1),
                            color: AppTheme.electricBlue,
                            child: CustomText(
                              'invite'.toUpperCase(),
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
      barrierDismissible: false,
      context: context);

  showBankAccountDialog() async => await showDialog(
      builder: (context) => Dialog(
            insetPadding:
                EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.75),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 5),
                  child: CustomText(
                    "No Bank Account Found.",
                    color: AppTheme.tomato,
                    bold: FontWeight.w500,
                    size: 18,
                  ),
                ),
                CustomText(
                  'Please Add Your Bank Account.',
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: RaisedButton(
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: AppTheme.electricBlue,
                            child: CustomText(
                              'Add Account'.toUpperCase(),
                              color: Colors.white,
                              size: (18),
                              bold: FontWeight.w500,
                            ),
                            onPressed: () {
                              Navigator.pop(context, true);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddBankAccount()));
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: RaisedButton(
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: AppTheme.electricBlue,
                            child: CustomText(
                              'Not now'.toUpperCase(),
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
      barrierDismissible: false,
      context: context);

  showBankValidationDialog() async => await showDialog(
      builder: (context) => Dialog(
            insetPadding:
                EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.66),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 5),
                  child: CustomText(
                    "402 Invalid card.",
                    color: AppTheme.tomato,
                    bold: FontWeight.w500,
                    size: 18,
                  ),
                ),
                Image.asset(
                  AppAssets.payIconActive,
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10, top: 5),
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.30),
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: AppTheme.electricBlue,
                          child: CustomText(
                            'ok'.toUpperCase(),
                            color: Colors.white,
                            size: (18),
                            bold: FontWeight.w500,
                          ),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
      barrierDismissible: false,
      context: context);
}

// Widget get shimmerPayLoading => Container(
//       height: MediaQuery.of(context).size.height,
//       child: ListView(
//         physics: NeverScrollableScrollPhysics(),
//         scrollDirection: Axis.vertical,
//         children: [
//           Align(alignment: Alignment.centerLeft, child: ShimmerText()),
//           SizedBox(height: 5),
//           Row(
//             children: [
//               ShimmerAvatarWithName(),
//               ShimmerAvatarWithName(),
//               ShimmerAvatarWithName(),
//               ShimmerAvatarWithName(),
//             ],
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ShimmerSquareTab(),
//               SizedBox(
//                 width: 10,
//               ),
//               ShimmerSquareTab()
//             ],
//           ),
//           SizedBox(height: 15),
//           // Row(
//           //   mainAxisSize: MainAxisSize.min,
//           //   children: [
//           ShimmerButton(),
//           SizedBox(height: 15),
//           ShimmerText(),
//           SizedBox(height: 15),
//           ShimmerListTile(),
//           ShimmerListTile(), ShimmerListTile(),
//           ShimmerListTile(),
//           ShimmerListTile(),
//           ShimmerListTile(), ShimmerListTile(),
//           ShimmerListTile(),
//           //   ],
//           // ),
//         ],
//       ),);

