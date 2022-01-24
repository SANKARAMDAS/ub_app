import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urbanledger/Models/settlement_history_model.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/arguments/settlement_history_argument.dart';
import 'package:url_launcher/url_launcher.dart';

class SettlementDetails extends StatefulWidget {
  const SettlementDetails({Key? key}) : super(key: key);

  @override
  _SettlementDetailsState createState() => _SettlementDetailsState();
}

class _SettlementDetailsState extends State<SettlementDetails> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as SettlementHistoryArgument;
    SettlementHistoryData settlementHistoryData = args.settlementHistoryData;
    var statusDetails = args.statusDetails;
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
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                top: -60,
                left: 0,
                child: Container(
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        color: Color(0xfff2f1f6),
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage(AppAssets.backgroundImage),
                            alignment: Alignment.topCenter))),
              ),
              Positioned.fill(
                  top: 0,
                  left: 0,
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: headerSection(settlementHistoryData),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                            child: Column(children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      onTap: () {

                                     },
                                       leading: Image.asset(
                                         AppAssets.sd_id_icon,
                            height: 40,
                      ),
                                      title: CustomText(
                                        'Settlement ID',
                                        bold: FontWeight.w600,
                                        size: 20,
                                        color: AppTheme.brownishGrey,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          6.0.heightBox,
                                          CustomText(
                                          settlementHistoryData.settlementId!,
                                            size: 20,
                                            color: AppTheme.electricBlue,
                                            bold: FontWeight.w500,
                                          ),


                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    child: Divider(
                                      height: 1,
                                      color: AppTheme.senderColor,
                                      endIndent: 20,
                                      indent: 20,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      onTap: () {

                                      },
                                      leading: Image.asset(
                                        AppAssets.sd_amount_icon,
                                        height: 40,
                                      ),
                                      title: CustomText(
                                        'Amount',
                                        bold: FontWeight.w600,
                                        size: 20,
                                        color: AppTheme.brownishGrey,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          6.0.heightBox,
                                          CustomText(
                                            '${settlementHistoryData.currency} ${settlementHistoryData.totalSettlementAmount!.getFormattedCurrency}' ,
                                            size: 20,
                                            color: AppTheme.coolGrey,
                                            bold: FontWeight.w500,
                                          ),


                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    child: Divider(
                                      height: 1,
                                      color: AppTheme.senderColor,
                                      endIndent: 20,
                                      indent: 20,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      onTap: () {

                                      },
                                      leading: Image.asset(
                                        AppAssets.sd_bank_icon,
                                        height: 40,
                                      ),
                                      title: CustomText(
                                        'Bank Name',
                                        bold: FontWeight.w600,
                                        size: 20,
                                        color: AppTheme.brownishGrey,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          6.0.heightBox,
                                          CustomText(
                                            '${settlementHistoryData.bankName}' ,
                                            size: 20,
                                            color: AppTheme.coolGrey,
                                            bold: FontWeight.w500,
                                          ),


                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    child: Divider(
                                      height: 1,
                                      color: AppTheme.senderColor,
                                      endIndent: 20,
                                      indent: 20,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      onTap: () {

                                      },
                                      leading: Image.asset(
                                        AppAssets.sd_settlement_period_icon,
                                        height: 40,
                                      ),
                                      title: CustomText(
                                        'Settlement Period',
                                        bold: FontWeight.w600,
                                        size: 20,
                                        color: AppTheme.brownishGrey,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          6.0.heightBox,
                                          CustomText(
                                            '${settlementHistoryData.fromDate != null
                                                ? "${DateFormat('yyyy-MM-dd').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(settlementHistoryData.fromDate.toString()))}"
                                                : ''} to ${settlementHistoryData.toDate != null
                                                ? "${DateFormat('yyyy-MM-dd').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(settlementHistoryData.toDate.toString()))}"
                                                : ''}' ,
                                            size: 20,
                                            color: AppTheme.coolGrey,
                                            bold: FontWeight.w500,
                                          ),


                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    child: Divider(
                                      height: 1,
                                      color: AppTheme.senderColor,
                                      endIndent: 20,
                                      indent: 20,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      onTap: () {

                                      },
                                      leading: Image.asset(
                                        AppAssets.sd_settlement_date_icon,
                                        height: 40,
                                      ),
                                      title: CustomText(
                                        'Settlement Date',
                                        bold: FontWeight.w600,
                                        size: 20,
                                        color: AppTheme.brownishGrey,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          6.0.heightBox,
                                          CustomText(
                                            '${settlementHistoryData.fromDate != null
                                                ? "${DateFormat('yyyy-MM-dd').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(settlementHistoryData.createdAt.toString()))}"
                                                : ''}' ,
                                            size: 20,
                                            color: AppTheme.coolGrey,
                                            bold: FontWeight.w500,
                                          ),


                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    child: Divider(
                                      height: 1,
                                      color: AppTheme.senderColor,
                                      endIndent: 20,
                                      indent: 20,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      onTap: () {

                                      },
                                      leading: Image.asset(
                                        AppAssets.sd_status_icon,
                                        height: 40,
                                        width:40
                                      ),
                                      title: CustomText(
                                        'Status',
                                        bold: FontWeight.w600,
                                        size: 20,
                                        color: AppTheme.brownishGrey,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          6.0.heightBox,
                                          Row(
                                            children: [
                                              CustomText(
                                                statusDetails['status'] ,
                                                size: 20,
                                                color: statusDetails['color'],
                                                bold: FontWeight.w500,
                                              ),
                                             if(statusDetails['status'] == 'Failed')
                                              InkWell(
                                                onTap: (){
                                                  showPaymentFailedBottomSheet(context);
                                                },
                                                  child: Icon(Icons.info_rounded,color: Colors.red,))
                                            ],

                                          ),


                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    child: Divider(
                                      height: 1,
                                      color: AppTheme.senderColor,
                                      endIndent: 20,
                                      indent: 20,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      onTap: () {

                                      },
                                      leading: Image.asset(
                                        AppAssets.sd_deductions_icon,
                                        height: 40,
                                      ),
                                      title: CustomText(
                                        'Deductions',
                                        bold: FontWeight.w600,
                                        size: 20,
                                        color: AppTheme.brownishGrey,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          6.0.heightBox,
                                          CustomText(
                                            '${settlementHistoryData.currency} ${settlementHistoryData.totalSettlementCommissionAmount!.getFormattedCurrency}' ,
                                            size: 20,
                                            color: AppTheme.coolGrey,
                                            bold: FontWeight.w500,
                                          ),


                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    child: Divider(
                                      height: 1,
                                      color: AppTheme.senderColor,
                                      endIndent: 20,
                                      indent: 20,
                                    ),
                                  )
                                ],
                              ),



                            ],),
                          ),
                        )],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget headerSection(SettlementHistoryData data) => Container(
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
                            AppAssets.sd_settlement_amount_icon,
                            height: 60,
                            width: 60,
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
                                  text: 'Settlement Amount',
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
                                text: '${data.currency} ',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: AppTheme.brownishGrey,
                                    fontWeight: FontWeight.w500),
                                children: [
                                  TextSpan(
                                      text:
                                      data.totalSettlementAmount!.getFormattedCurrency,
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

  AppBar get appBar => AppBar(
        elevation: 0,
        title: Text('Settlement Details'),
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
                showSettlementDetailsBottomSheet(context);
              },
            ),
          ),
        ],
      );

  showSettlementDetailsBottomSheet(BuildContext context) {
    bool agree = true;
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, state) {
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
                            'Manage your Settlement LL',
                            size: 20,
                            color: AppTheme.brownishGrey,
                            bold: FontWeight.w500,
                          ),
                          15.0.heightBox,
                          CustomText(
                            'Settlement is the process through which a merchant receives money paid by their end users for a particular product/service. The amount will get credited to the merchant’s account in 48 hours once settlement is done.',
                            size: 18,
                            color: AppTheme.brownishGrey,
                            bold: FontWeight.w400,
                          ),
                          10.0.heightBox,
                          /*Container(
                            // height: MediaQuery.of(context).size.height * 0.02,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: agree,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      agree = value!;
                                    });
                                  },

                                ),
                                Text(
                                  'Do not show me this message again',
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          10.0.heightBox,*/
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
                                  color: AppTheme.whiteColor,
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
      },
    );
  }

  showPaymentFailedBottomSheet(BuildContext context) {
    bool agree = true;
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, state) {
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
                            AppAssets.sd_message_icon,
                            height: 40,
                            width: 40,
                          ),
                        /*  15.0.heightBox,
                          CustomText(
                            'Manage your Settlement',
                            size: 20,
                            color: AppTheme.brownishGrey,
                            bold: FontWeight.w500,
                          ),*/
                          15.0.heightBox,
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomText(
                              'Payment was failed due to invalid account information. Please check your register email ID or Contact us.',
                              size: 18,
                              color: AppTheme.brownishGrey,
                              bold: FontWeight.w600,
                            ),
                          ),
                          20.0.heightBox,
                          /*Container(
                            // height: MediaQuery.of(context).size.height * 0.02,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: agree,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      agree = value!;
                                    });
                                  },

                                ),
                                Text(
                                  'Do not show me this message again',
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          10.0.heightBox,*/
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        _launchURL('https://urbanledger.app/contact');
                                      },
                                      child: CustomText(
                                        'Contact Us',
                                        size: (18),
                                        bold: FontWeight.w500,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(15),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                      )),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        /*repository.hiveQueries
                                          .insertIsCashbookSheetShown(true);*/
                                      },
                                      child: CustomText(
                                        'Cancel',
                                        size: (18),
                                        bold: FontWeight.w500,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(15),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                      )),
                                ),
                              ),
                            ],
                          )
                        ]),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}
