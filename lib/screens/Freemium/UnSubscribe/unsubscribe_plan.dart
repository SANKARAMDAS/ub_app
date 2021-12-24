import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Models/plan_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/screens/Freemium/confirmation_screen_1.dart';
import 'package:urbanledger/screens/Freemium/confirmation_screen_1.dart';
import 'package:urbanledger/screens/Kyc%20Screen/kyc_provider.dart';
import 'package:urbanledger/screens/home.dart';

class UnSubscribePlan extends StatefulWidget {
  List<PlanModel> planModel = [];
  UnSubscribePlan({required this.planModel});
  @override
  _UrbanLedgerPremiumWelcomeState createState() =>
      _UrbanLedgerPremiumWelcomeState();
}

class _UrbanLedgerPremiumWelcomeState extends State<UnSubscribePlan> {
  bool isLoading = false;
//   _onTap(){
// Navigator.of(context).popUntil((route) => route.isFirst);
//         Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);
//         return true;
//   }
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
          title: Text('Unsubscribe Plan'),
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
                          'assets/images/cardWhite3.png', //shadowed img
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
                  height: MediaQuery.of(context).size.height / 1.3,
                  // height: deviceHeight * 0.9,
                  // color: Colors.amber,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: deviceHeight * 0.009),
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
                            SizedBox(height: 15),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  // alignment: Alignment.center,
                                  // padding: EdgeInsets.symmetric(horizontal: 1),
                                  child: Text(
                                    'We are sorry to',
                                    style: TextStyle(
                                      color: Colors.black54,
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
                                    'see you go! ',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontFamily: 'SFProDisplay',
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  // alignment: Alignment.center,
                                  // padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Image.asset(
                                    'assets/images/Subscription.png',
                                    height: 150,
                                    width: 300,
                                  ),
                                ),
                                SizedBox(height: 25),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      // alignment: Alignment.center,
                                      // padding: EdgeInsets.symmetric(horizontal: 1),
                                      child: Text(
                                        'You can\'t access to all the premium features',
                                        style: TextStyle(
                                          color: AppTheme.tomato,
                                          fontFamily: 'SFProDisplay',
                                          fontSize: 16,
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
                                          color: AppTheme.tomato,
                                          fontFamily: 'SFProDisplay',
                                          fontSize: 16,
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
                                          color: AppTheme.tomato,
                                          fontFamily: 'SFProDisplay',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   // alignment: Alignment.center,
                                    //   // padding: EdgeInsets.symmetric(horizontal: 5),
                                    //   child: Text(
                                    //     'Global Report',
                                    //     style: TextStyle(
                                    //       color: Colors.black54,
                                    //       fontFamily: 'SFProDisplay',
                                    //       fontSize: 18,
                                    //       fontWeight: FontWeight.bold,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  // width:
                                  //     MediaQuery.of(context).size.width * 0.515,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 10),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: NewCustomButton(
                                          onSubmit: () {
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    AppRoutes.mainRoute);
                                          },

                                          text: 'okay'.toUpperCase(),
                                          textColor: Colors.white,
                                          backgroundColor:
                                              AppTheme.electricBlue,
                                          textSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          // width: 185,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: NewCustomButton(
                                          onSubmit: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         ConfirmationScreen1(
                                            //       planModel: widget.planModel,
                                            //       // index: index,
                                            //     ),
                                            //   ),
                                            // );
                                            Navigator.of(context).popAndPushNamed(
                                                AppRoutes
                                                    .confirmationscreen1Route,
                                                arguments:
                                                    FreemiumConfirmationArgs(
                                                        planModel:
                                                            widget.planModel));
                                          },

                                          text: 'upgrade now'.toUpperCase(),
                                          textColor: Colors.white,
                                          backgroundColor:
                                              AppTheme.electricBlue,
                                          textSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          // width: 185,
                                        ),
                                      ),
                                    ],
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
