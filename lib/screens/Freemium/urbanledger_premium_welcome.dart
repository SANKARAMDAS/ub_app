import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Kyc%20Screen/kyc_provider.dart';

class UrbanLedgerPremiumWelcome extends StatefulWidget {
  @override
  _UrbanLedgerPremiumWelcomeState createState() =>
      _UrbanLedgerPremiumWelcomeState();
}

class _UrbanLedgerPremiumWelcomeState extends State<UrbanLedgerPremiumWelcome> {
  bool isLoading = false;
  _onTap() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.paleGrey,
        appBar: AppBar(
          title: Text('UrbanLedger Premium'),
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                size: 22,
              ),
            ),
          ),
        ),
        extendBody: true,
        body: SafeArea(
          child: Stack(
            // alignment: Alignment.topCenter,
            children: [
              Container(
                clipBehavior: Clip.none,
                height: deviceHeight * 0.05,
                width: double.infinity,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  // color: Color(0xfff2f1f6),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(AppAssets.backgroundImage),
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                  image: DecorationImage(
                      fit: BoxFit.cover, //cover
                      image: AssetImage('assets/images/BG.png'),
                      alignment: Alignment.bottomCenter),
                ),
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                        ),
                        child: Image.asset(
                          'assets/images/cardWhite5.png',
                          // width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height * 1,
                          // alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.4,
                  // height: deviceHeight * 0.9,
                  // color: Colors.amber,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: deviceHeight * 0.0009),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: Image.asset(
                                'assets/images/crown.png',
                                height: 55,
                                width: 55,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  // alignment: Alignment.center,
                                  // padding: EdgeInsets.symmetric(horizontal: 1),
                                  child: Text(
                                    'UrbanLedger ',
                                    style: TextStyle(
                                      color: AppTheme.electricBlue,
                                      fontFamily: 'SFProDisplay',
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // SizedBox(width: 1),
                                Container(
                                  // alignment: Alignment.center,
                                  // padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    'Premium ',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'SFProDisplay',
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  // alignment: Alignment.center,
                                  // padding: EdgeInsets.symmetric(horizontal: 1),
                                  child: Text(
                                    'You discovered',
                                    style: TextStyle(
                                      color: AppTheme.electricBlue,
                                      fontFamily: 'SFProDisplay',
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  // alignment: Alignment.center,
                                  // padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    'Premium features! ',
                                    style: TextStyle(
                                      color: AppTheme.electricBlue,
                                      fontFamily: 'SFProDisplay',
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      // alignment: Alignment.center,
                                      // padding: EdgeInsets.symmetric(horizontal: 1),
                                      child: Text(
                                        'Get access to all the premium features',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'SFProDisplay',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // alignment: Alignment.center,
                                      // padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(
                                        'Like Multiple Ledgers,Multiple Cashbooks,',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'SFProDisplay',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // alignment: Alignment.center,
                                      // padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(
                                        'Global Reports',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontFamily: 'SFProDisplay',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 22),
                                Container(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.515,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 45, vertical: 20),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      Provider.of<KycProvider>(context,
                                              listen: false)
                                          .updateKyc();

                                      /*if (DateTime.now()
                                          .difference(Repository()
                                              .hiveQueries
                                              .userData
                                              .premiumExpDate!)
                                          .inDays
                                          .isNegative) {
                                        Repository().hiveQueries.insertUserData(
                                            Repository()
                                                .hiveQueries
                                                .userData
                                                .copyWith(premiumStatus: 0));
                                        setState(() {});
                                      }*/
                                      // Navigator.of(context)..pop()..pop();

                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              AppRoutes.mainRoute);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(18),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: CustomText('Let\'s go'.toUpperCase(),
                                        color: Colors.white,
                                        size: 18,
                                        bold: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
children: [
            Container(
              height: deviceHeight * 0.21,
              width: double.maxFinite,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                color: Color(0xfff2f1f6),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/back2.png'),
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 55),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.chevron_left),
                        color: Colors.white,
                        iconSize: 32,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'UrbanLedger Premium',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w500,
                            fontSize: 21),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Image.asset(
                'assets/images/Card-white-01.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                alignment: Alignment.topCenter,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                // height: deviceHeight * 0.9,
                // color: Colors.amber,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          // SizedBox(height: deviceHeight / 15),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            child: Image.asset(
                              'assets/images/crown.png',
                              height: 55,
                              width: 55,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                // alignment: Alignment.center,
                                // padding: EdgeInsets.symmetric(horizontal: 1),
                                child: Text(
                                  'UrbanLedger ',
                                  style: TextStyle(
                                    color: AppTheme.electricBlue,
                                    fontFamily: 'SFProDisplay',
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // SizedBox(width: 1),
                              Container(
                                // alignment: Alignment.center,
                                // padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  'Premium ',
                                  style: TextStyle(
                                    color: AppTheme.greyish,
                                    fontFamily: 'SFProDisplay',
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                // alignment: Alignment.center,
                                // padding: EdgeInsets.symmetric(horizontal: 1),
                                child: Text(
                                  'You discovered',
                                  style: TextStyle(
                                    color: AppTheme.electricBlue,
                                    fontFamily: 'SFProDisplay',
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                // alignment: Alignment.center,
                                // padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  'a Premium feature! ',
                                  style: TextStyle(
                                    color: AppTheme.electricBlue,
                                    fontFamily: 'SFProDisplay',
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 40),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // alignment: Alignment.center,
                                    // padding: EdgeInsets.symmetric(horizontal: 1),
                                    child: Text(
                                      'Get access to all th epremium features',
                                      style: TextStyle(
                                        color: AppTheme.greyish,
                                        fontFamily: 'SFProDisplay',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // alignment: Alignment.center,
                                    // padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      'Like Ledger,Cashbook,Payments,Reports ',
                                      style: TextStyle(
                                        color: AppTheme.greyish,
                                        fontFamily: 'SFProDisplay',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Container(
                                padding: const EdgeInsets.only(top: 5.0),
                                width:
                                    MediaQuery.of(context).size.width * 0.515,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 45, vertical: 20),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => ),
                                    // );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(18),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: CustomText('Lets go'.toUpperCase(),
                                      color: Colors.white,
                                      size: 18,
                                      bold: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
 */
