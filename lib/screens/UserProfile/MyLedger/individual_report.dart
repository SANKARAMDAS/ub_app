import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Models/business_model.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';

class IndividualReport extends StatefulWidget {
  const IndividualReport({Key? key}) : super(key: key);

  @override
  _IndividualReportState createState() => _IndividualReportState();
}

class _IndividualReportState extends State<IndividualReport> {
  final Repository repository = Repository();

  late Future<List<double>> payReceive;

  @override
  void initState() {
    payReceive = getGlobalGiveGet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      appBar: AppBar(
        title: Text('Individual Report'),
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
            onTap: () {},
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
                      FutureBuilder<List<double>>(
                        future: payReceive,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                  text: snapshot.data != null
                                                      ? ((snapshot.data!.last)
                                                              as double)
                                                          .getFormattedCurrency
                                                          .replaceAll('-', '')
                                                      : '0',
                                                  // text: '46151830',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                  text: snapshot.data != null
                                                      ? ((snapshot.data!.first)
                                                              as double)
                                                          .getFormattedCurrency
                                                          .replaceAll('-', '')
                                                      : '0',
                                                  // text: '46151830',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ]),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      20.0.heightBox,
                    ],
                  ),
                ),
                25.0.heightBox,
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
                ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      Provider.of<BusinessProvider>(context).businesses.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BusinessTile(
                      repository: repository,
                      index: index,
                    );
                  },
                ).flexible,
                15.0.heightBox,
              ],
            ),
          )
        ],
      )),
    );
  }

  Future<List<double>> getGlobalGiveGet() async {
    double totalPay = 0.0;
    double totalReceive = 0.0;
    await Future.forEach<BusinessModel>(
        Provider.of<BusinessProvider>(context, listen: false).businesses,
        (element) async {
      final result = await repository.queries
          .getTotalPayReceiveForCustomer(element.businessId);
      totalPay += result.first;
      totalReceive += result.last;
    });

    return [totalPay, totalReceive];
  }

  Future<void> get filterBottomSheet async {
    int selectedFilter = 1;
    int selectedSort = 1;

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
            height: 570,
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
                          'Filter by',
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
                            primary: selectedFilter == 1
                                ? AppTheme.electricBlue
                                : AppTheme.justWhite,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppTheme.electricBlue),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: CustomText(
                              'All',
                              bold: FontWeight.w500,
                              color: selectedFilter == 1
                                  ? Colors.white
                                  : AppTheme.brownishGrey,
                            ),
                          ),
                          onPressed: () {
                            if (selectedFilter != 1)
                              setState(() {
                                selectedFilter = 1;
                              });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: selectedFilter == 2
                                ? AppTheme.electricBlue
                                : AppTheme.justWhite,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppTheme.electricBlue),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: CustomText(
                              'YOU WILL GET',
                              bold: FontWeight.w500,
                              color: selectedFilter == 2
                                  ? Colors.white
                                  : AppTheme.brownishGrey,
                            ),
                          ),
                          onPressed: () {
                            if (selectedFilter != 2)
                              setState(() {
                                selectedFilter = 2;
                              });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: selectedFilter == 3
                                ? AppTheme.electricBlue
                                : AppTheme.justWhite,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppTheme.electricBlue),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: CustomText(
                              'You will GIVE'.toUpperCase(),
                              bold: FontWeight.w500,
                              color: selectedFilter == 3
                                  ? Colors.white
                                  : AppTheme.brownishGrey,
                            ),
                          ),
                          onPressed: () {
                            if (selectedFilter != 3)
                              setState(() {
                                selectedFilter = 3;
                              });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: selectedFilter == 4
                                ? AppTheme.electricBlue
                                : AppTheme.justWhite,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppTheme.electricBlue),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: CustomText(
                              'NOTHING PENDING',
                              bold: FontWeight.w500,
                              color: selectedFilter == 4
                                  ? Colors.white
                                  : AppTheme.brownishGrey,
                            ),
                          ),
                          onPressed: () {
                            if (selectedFilter != 4)
                              setState(() {
                                selectedFilter = 4;
                              });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: CustomText(
                      'Sort by',
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
                            'Most Recent',
                            size: 16,
                            bold: FontWeight.w500,
                            color: AppTheme.brownishGrey,
                          ),
                          Radio(
                            groupValue: selectedSort,
                            value: 1,
                            onChanged: (dynamic value) {
                              setState(() {
                                selectedSort = value;
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
                            'Highest Amount',
                            size: 16,
                            bold: FontWeight.w500,
                            color: AppTheme.brownishGrey,
                          ),
                          Radio(
                            groupValue: selectedSort,
                            value: 2,
                            onChanged: (dynamic value) {
                              setState(() {
                                selectedSort = value;
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
                            'By Name (A-Z)',
                            size: 16,
                            bold: FontWeight.w500,
                            color: AppTheme.brownishGrey,
                          ),
                          Radio(
                            groupValue: selectedSort,
                            value: 3,
                            onChanged: (dynamic value) {
                              setState(() {
                                selectedSort = value;
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
                            'Oldest',
                            size: 16,
                            bold: FontWeight.w500,
                            color: AppTheme.brownishGrey,
                          ),
                          Radio(
                            groupValue: selectedSort,
                            value: 4,
                            onChanged: (dynamic value) {
                              setState(() {
                                selectedSort = value;
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
                            'Least Amount',
                            size: 16,
                            bold: FontWeight.w500,
                            color: AppTheme.brownishGrey,
                          ),
                          Radio(
                            groupValue: selectedSort,
                            value: 5,
                            onChanged: (dynamic value) {
                              setState(() {
                                selectedSort = value;
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
                        /* _selectedFilterOption = selectedFilter;
                        _selectedSortOption = selectedSort;
                        _searchController.clear();
                        BlocProvider.of<ContactsCubit>(context).filterContacts(
                            _selectedFilterOption, _selectedSortOption); */
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
    );
  }
}

class BusinessTile extends StatefulWidget {
  const BusinessTile({
    Key? key,
    required this.repository,
    required this.index,
  }) : super(key: key);

  final Repository repository;
  final int index;

  @override
  _BusinessTileState createState() => _BusinessTileState();
}

class _BusinessTileState extends State<BusinessTile> {
  bool showChildren = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showChildren = !showChildren;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<List<double>>(
            future: widget.repository.queries.getTotalPayReceiveForCustomer(
                Provider.of<BusinessProvider>(context, listen: false)
                    .businesses[widget.index]
                    .businessId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                Provider.of<BusinessProvider>(context,
                                        listen: false)
                                    .businesses[widget.index]
                                    .businessName,
                                size: 14,
                                color: Colors.black,
                                bold: FontWeight.w700,
                              ),
                              5.0.heightBox,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FutureBuilder<int>(
                                      future: widget.repository.queries
                                          .getCustomerCount(
                                              Provider.of<BusinessProvider>(
                                                      context,
                                                      listen: false)
                                                  .businesses[widget.index]
                                                  .businessId),
                                      builder: (context, snapshot) {
                                        return CustomText(
                                          'Customers ' + '(${snapshot.data})',
                                          bold: FontWeight.w500,
                                          color: AppTheme.brownishGrey,
                                          size: 14,
                                        );
                                      }),
                                  Icon(
                                    !showChildren
                                        ? Icons.chevron_right_rounded
                                        : Icons.expand_more,
                                    color: AppTheme.electricBlue,
                                  )
                                ],
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
                                  text: snapshot.data != null
                                      ? ((snapshot.data!.last) as double)
                                          .getFormattedCurrency
                                          .replaceAll('-', '')
                                      : '0',
                                  // text: '46151830',
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
                                  text: snapshot.data != null
                                      ? ((snapshot.data!.first) as double)
                                          .getFormattedCurrency
                                          .replaceAll('-', '')
                                      : '0',
                                  // text: '46151830',
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
          ),
          if (showChildren)
            CustomersWidget(
                widget: widget,
                businessId:
                    Provider.of<BusinessProvider>(context, listen: false)
                        .businesses[widget.index]
                        .businessId)
        ],
      ),
    );
  }
}

class CustomersWidget extends StatelessWidget {
  const CustomersWidget({
    Key? key,
    required this.widget,
    required this.businessId,
  }) : super(key: key);

  final BusinessTile widget;
  final String businessId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CustomerModel>>(
        future: widget.repository.queries.getCustomers(businessId),
        builder: (context, snapshot) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CustomProfileImage(
                    avatar: snapshot.data![index].avatar,
                    mobileNo: snapshot.data![index].mobileNo,
                    name: snapshot.data![index].name,
                  ),
                  title: CustomText(
                    getName(snapshot.data![index].name,
                        snapshot.data![index].mobileNo),
                    bold: FontWeight.w500,
                    size: 18,
                  ),
                  subtitle: CustomText(
                    snapshot.data![index].updatedDate?.duration ?? "",
                    size: 16,
                    color: AppTheme.greyish,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: snapshot.data![index].transactionType ==
                                        TransactionType.Pay ||
                                    snapshot.data![index].transactionAmount == 0
                                ? '+$currencyAED '
                                : '-$currencyAED ',
                            style: TextStyle(
                                color: snapshot.data![index].transactionType ==
                                            null ||
                                        snapshot.data![index]
                                                .transactionAmount ==
                                            0
                                    ? AppTheme.greyish
                                    : snapshot.data![index].transactionType ==
                                            TransactionType.Pay
                                        ? AppTheme.greenColor
                                        : AppTheme.tomato,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                            children: [
                              TextSpan(
                                  text:
                                      (snapshot.data![index].transactionAmount)!
                                          .getFormattedCurrency
                                          .replaceAll('-', ''),
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ]),
                      ),
                      CustomText(
                        snapshot.data![index].transactionType == null ||
                                snapshot.data![index].transactionAmount == 0
                            ? 'Nothing Pending'
                            : snapshot.data![index].transactionType ==
                                    TransactionType.Pay
                                ? 'You’ll Get'
                                : 'You’ll Give',
                        color: AppTheme.greyish,
                      )
                    ],
                  ),
                  onTap: () {},
                ),
              );
            },
          );
        });
  }
}
