import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_pay_Receive_buttons.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/sliver_app_bar.dart';

class ChatScreenPage extends StatefulWidget {
  const ChatScreenPage({Key? key}) : super(key: key);

  @override
  _ChatScreenPageState createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage>
    with SingleTickerProviderStateMixin {
  GlobalKey _key = GlobalKey();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        // initialIndex: widget.isFromUlChat ? 1 : 0,
        length: 2,
        vsync: this);

    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // No appbar provided to the Scaffold, only a body with a
        // CustomScrollView.
        body: Stack(
          children: [
                   CustomScrollView(slivers: <Widget>[
      SliverGradientAppBar(
            key: _key,
            pinned: true,
            leading: Container(
              width: 30,
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 22,
                ),
                color: Colors.white,
                onPressed: () {
                  // audioPlayer.stop();
                  Navigator.of(context).pop();
                },
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xff666666),
                  child: Center(
                    child: Text(
                      getInitials('Hemant Bhabal', '').toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 26),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.of(context).pushNamed(
                    //     AppRoutes.customerProfileRoute,
                    //     arguments: widget.customerModel);
                    // CustomLoadingDialog.showLoadingDialog(context, key);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Hemant Bhabal',
                          color: Colors.white,
                          size: 20,
                          bold: FontWeight.w500,
                        ),
                        Text(
                          'Click to view settings',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context).pushNamed(AppRoutes.reportRoute,
                    //     arguments: widget.customerModel);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Image.asset(
                      AppAssets.reportIcon,
                      height: 30,
                    ),
                  ),
                ),
              ],
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.09),
                child: receiveCollection(context),
              ),
            ),
            expandedHeight: 160.0),
            
      
    ]),
      Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        child: tabs,
      ),
      
      Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 5, left: 5),
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        Container(),
                        Container(),
                        // SliverList(
                        //   // Use a delegate to build items as they're scrolled on screen.
                        //   delegate: SliverChildBuilderDelegate(
                        //     // The builder function returns a ListTile with a title that
                        //     // displays the index of the current item.
                        //     (context, index) => ListTile(title: Text('Item #$index')),
                        //     // Builds 1000 ListTiles
                        //     childCount: 1000,
                        //   ),
                        // ),
                        // SliverList(
                        //   // Use a delegate to build items as they're scrolled on screen.
                        //   delegate: SliverChildBuilderDelegate(
                        //     // The builder function returns a ListTile with a title that
                        //     // displays the index of the current item.
                        //     (context, index) => ListTile(title: Text('Item #$index')),
                        //     // Builds 1000 ListTiles
                        //     childCount: 1000,
                        //   ),
                        // ),
                      ]
                    ),
                  )
      ),
    ],
        ));
  }

  Widget receiveCollection(context) {
    // return FutureBuilder<double>(
    //     future: repository.queries
    //         .getPaidMinusReceived(widget.customerModel.customerId.toString()),
    //     builder: (context, snapshot) {
    // if (snapshot.data != null) balanceAmount = snapshot.data ?? 0;
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
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
        child: Column(children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: MediaQuery.of(context).size.height * 0.0001),
              // height: 43,
              /*  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppTheme.electricBlue,
                        width: 0.5,
                      ),
                    ), */
              alignment: Alignment.center,
              child: ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -3),
                //dense: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                )),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      // snapshot.data != null
                      //     ? snapshot.data!.isNegative
                      //         ? 'You will Get'
                      //         : 'You will Give'
                      //     :
                      'You will Get',
                      style: TextStyle(
                          color: AppTheme.electricBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      // snapshot.data != null
                      //     ? snapshot.data!.isNegative
                      //         ? AppAssets.inIcon
                      //         : AppAssets.outIcon
                      //     :
                      AppAssets.inIcon,
                      scale: 1.2,
                      color: AppTheme.electricBlue,
                      height: 20,
                    ),
                  ],
                ),
                trailing: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText2,
                    children: [
                      TextSpan(
                        text: '$currencyAED  ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.electricBlue,
                        ),
                      ),
                      TextSpan(
                        text:
                            // snapshot.data != null
                            //     ? snapshot.data!.isNegative
                            //         ? (snapshot.data)!
                            //             .getFormattedCurrency
                            //             .substring(1)
                            //         : (snapshot.data)!.getFormattedCurrency
                            //     :
                            ' 0',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.electricBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          // if (snapshot.data != null &&
          //     (snapshot.data!.isNegative && snapshot.data != 0.0))
          Divider(
            color: AppTheme.electricBlue,
            height: 1,
          ),
          // if (snapshot.data != null &&
          //     (snapshot.data!.isNegative && snapshot.data != 0.0))
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 0,
                vertical: MediaQuery.of(context).size.height * 0.0001),
            // height: 43,
            // margin: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child:
                //  _selectedDate == null
                // ? ListTile(
                //     visualDensity:
                //         VisualDensity(horizontal: 0, vertical: -3),
                //     dense: true,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(15),
                //       topRight: Radius.circular(15),
                //     )),
                //     title: Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Text(
                //           'Collection',
                //           style: TextStyle(
                //               color: AppTheme.electricBlue,
                //               fontSize: 18,
                //               fontWeight: FontWeight.w500),
                //         ),
                //       ],
                //     ),
                //     trailing: RichText(
                //       text: TextSpan(
                //         style: Theme.of(context).textTheme.bodyText2,
                //         children: [
                //           TextSpan(
                //             text: _selectedDate == null
                //                 ? 'Set Date'.toUpperCase()
                //                 : DateFormat('EEE, dd MMM yyyy')
                //                     .format(_selectedDate!),
                //             recognizer: TapGestureRecognizer()
                //               ..onTap = () async {
                //                 await showDateBottomSheet(
                //                     snapshot.data);
                //                 setState(() {});
                //               },
                //             style: TextStyle(
                //                 fontSize: 16,
                //                 color: AppTheme.electricBlue,
                //                 fontWeight: FontWeight.w500),
                //           ),
                //           WidgetSpan(
                //             child: Padding(
                //               padding: EdgeInsets.only(left: 5),
                //               child: Image.asset(
                //                 'assets/icons/calendar.png',
                //                 height: 18,
                //                 color: AppTheme.electricBlue,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ))
                // :
                ListTile(
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
              title: RichText(
                text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText2,
                    children: [
                      // if (_selectedDate!
                      //     .difference(DateTime.now())
                      //     .isNegative)
                      TextSpan(
                          text:
                              // 'Payment ${DateTime.now().difference(_selectedDate!).inDays == 0 ? 'is' : 'was'} due ',
                              'qwert',
                          style: TextStyle(
                            color: AppTheme.electricBlue,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  // DateTime.now()
                                  //             .difference(
                                  //                 _selectedDate!)
                                  //             .inDays ==
                                  //         0
                                  //     ?
                                  'Today',
                              // : duration(_selectedDate!),
                              style: TextStyle(
                                  color: AppTheme.tomato,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ]),
                      // if (!_selectedDate!
                      //     .difference(DateTime.now())
                      //     .isNegative)
                      TextSpan(
                          text: 'Collect money on ',
                          style: TextStyle(
                            color: AppTheme.electricBlue,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                              text: 'EE',
                              // DateFormat('EEE, dd MMM yyyy')
                              //     .format(_selectedDate!),
                              style: TextStyle(
                                  color: AppTheme.electricBlue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ]),
                    ]),
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.electricBlue,
              ),
              onTap: () async {
                // await showDateBottomSheet(snapshot.data);
                // setState(() {});
              },
            ),
          ),
        ]),
      ),
    );
    // });
  }

  Widget get tabs => Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.045, vertical: 2),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage(AppAssets.tabMiddleLine),
              fit: BoxFit.fitWidth,
            ),
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: TabBar(
            //indicatorColor: AppTheme.electricBlue,
            controller: _tabController,
            indicatorWeight: 5,
            labelColor: AppTheme.brownishGrey,
            unselectedLabelColor: AppTheme.brownishGrey,
            indicator: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppTheme.electricBlue, width: 4)),
            ),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            unselectedLabelStyle:
                TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            tabs: [
              Tab(
                text: 'Ledger',
              ),
              Tab(
                text: 'Chats',
              ),
            ],
          ),
        ),
      );
}
