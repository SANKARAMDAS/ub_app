import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';

class ManageKycScreen extends StatefulWidget {
  @override
  _ManageKycScreenState createState() => _ManageKycScreenState();
}

class _ManageKycScreenState extends State<ManageKycScreen> {
  final GlobalKey<State> key = GlobalKey<State>();
  final int _numPages = 2;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // await CustomSharedPreferences.remove('isKYC');
    data();  
  }

  data() async {
    await CustomSharedPreferences.setBool('isKYC', false);
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      height: 12.0,
      width: isActive ? 12.0 : 12.0,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.electricBlue : Colors.grey[350],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.of(context)
              .pushReplacementNamed(AppRoutes.myProfileScreenRoute);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 1),
                      // alignment: Alignment.centerLeft,
                      child: Container(
                        child: FlatButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pushReplacementNamed(
                                  AppRoutes.myProfileScreenRoute);
                            } else {
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRoutes.mainRoute);
                            }
                          },
                          child: Icon(
                            Icons.chevron_left,
                            color: AppTheme.brownishGrey,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 1),
                      child: Container(
                        // alignment: Alignment.centerRight,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.manageKyc3Route);
                          },
                          child: Text(
                            'Skip',
                            style: TextStyle(
                                color: AppTheme.electricBlue,
                                fontFamily: 'SFProDisplay',
                                fontWeight: FontWeight.w500,
                                fontSize: 21),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                        debugPrint(page.toString());
                      });
                    },
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/kyc1.png',
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  // width: 400.0,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.080,
                              ),
                              Text(
                                'Get ID document ready',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: AppTheme.electricBlue,
                                    fontFamily: 'SFProDisplay',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(15),
                                //     border:
                                //         Border.all(color: AppTheme.electricBlue)),
                                child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppTheme.electricBlue,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 5,
                                            width: 5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: AppTheme.brownishGrey,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Before you start, make sure your Emirates ID ',
                                            style: TextStyle(
                                                decoration: TextDecoration.none,
                                                color: Color.fromRGBO(
                                                    102, 102, 102, 1),
                                                fontFamily: 'SFProDisplay',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 14),
                                          Text(
                                            'and UAE Trade License are with you.\nYou will need to scan it during the process.',
                                            style: TextStyle(
                                                decoration: TextDecoration.none,
                                                color: Color.fromRGBO(
                                                    102, 102, 102, 1),
                                                fontFamily: 'SFProDisplay',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 30.0, bottom: 30.0, left: 15.0, right: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/kyc2.png',
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                              ),
                              // SizedBox(height: 70.0),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.080,
                              ),
                              Text(
                                'Now Scan Your Documents',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: AppTheme.electricBlue,
                                    fontFamily: 'SFProDisplay',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24),
                              ),
                              SizedBox(height: 8.0),
                              // Text( //jagdish asked to remove this line
                              //   ' Make sure that all information is\nwithin the borders of the scanner.',
                              //   style: TextStyle(
                              //       decoration: TextDecoration.none,
                              //       color: Color.fromRGBO(102, 102, 102, 1),
                              //       fontFamily: 'SFProDisplay',
                              //       fontWeight: FontWeight.w500,
                              //       fontSize: 16),
                              // ),
                              // SizedBox(height: 2.0),
                              Container(
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(15),
                                //     border:
                                //
                                //         Border.all(color: AppTheme.electricBlue)),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppTheme.electricBlue,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                padding: const EdgeInsets.only(
                                    top: 20.0,
                                    bottom: 20.0,
                                    left: 6.0,
                                    right: 2.0),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          // Text(
                                          //   '•',
                                          //   style: TextStyle(
                                          //       decoration: TextDecoration.none,
                                          //       color: Color.fromRGBO(
                                          //           102, 102, 102, 1),
                                          //       fontFamily: 'SFProDisplay',
                                          //       fontWeight: FontWeight.w500,
                                          //       fontSize: 12),
                                          // ),
                                          // Container(
                                          //   height: 4,
                                          //   width: 4,
                                          //   decoration: BoxDecoration(
                                          //     borderRadius:
                                          //         BorderRadius.circular(50),
                                          //     color: AppTheme.brownishGrey,
                                          //   ),
                                          // ),
                                          // SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              '• Do not edit or add any effect to the photo.',
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: Color.fromRGBO(
                                                      102, 102, 102, 1),
                                                  fontFamily: 'SFProDisplay',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          // Text(
                                          //   '•',
                                          //   style: TextStyle(
                                          //       decoration: TextDecoration.none,
                                          //       color: Color.fromRGBO(
                                          //           102, 102, 102, 1),
                                          //       fontFamily: 'SFProDisplay',
                                          //       fontWeight: FontWeight.w500,
                                          //       fontSize: 12),
                                          // ),
                                          // SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              '• Do not hide, fold or crop any part of the document.',
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: Color.fromRGBO(
                                                      102, 102, 102, 1),
                                                  fontFamily: 'SFProDisplay',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          // Text(
                                          //   '•',
                                          //   style: TextStyle(
                                          //       decoration: TextDecoration.none,
                                          //       color: Color.fromRGBO(
                                          //           102, 102, 102, 1),
                                          //       fontFamily: 'SFProDisplay',
                                          //       fontWeight: FontWeight.w500,
                                          //       fontSize: 12),
                                          // ),
                                          // SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              '• Ensure the edges of the document are within the frame.',
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: Color.fromRGBO(
                                                      102, 102, 102, 1),
                                                  fontFamily: 'SFProDisplay',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          // Text(
                                          //   '•',
                                          //   style: TextStyle(
                                          //       decoration: TextDecoration.none,
                                          //       color: Color.fromRGBO(
                                          //           102, 102, 102, 1),
                                          //       fontFamily: 'SFProDisplay',
                                          //       fontWeight: FontWeight.w500,
                                          //       fontSize: 12),
                                          // ),
                                          // //
                                          // SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              '• Ensure sufficient brightness while clicking the photo.',
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: Color.fromRGBO(
                                                      102, 102, 102, 1),
                                                  fontFamily: 'SFProDisplay',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          // Text(
                                          //   '•',
                                          //   style: TextStyle(
                                          //       decoration: TextDecoration.none,
                                          //       color: Color.fromRGBO(
                                          //           102, 102, 102, 1),
                                          //       fontFamily: 'SFProDisplay',
                                          //       fontWeight: FontWeight.w500,
                                          //       fontSize: 12),
                                          // ),
                                          // SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              '• Ensure the information in the document is clearly visible.',
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: Color.fromRGBO(
                                                      102, 102, 102, 1),
                                                  fontFamily: 'SFProDisplay',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: FlatButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeOutCirc,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              //mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Next',
                                  style: TextStyle(
                                      color: AppTheme.electricBlue,
                                      fontFamily: 'SFProDisplay',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 21),
                                ),
                                SizedBox(height: 150.0),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                            top: 50.0, right: 8.0, left: 8.0),
                        child: NewCustomButton(
                          backgroundColor: AppTheme.electricBlue,
                          text: 'CONTINUE',
                          textSize: 14,
                          textColor: Colors.white,
                          onSubmit: () {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.manageKyc3Route);
                            //CustomLoadingDialog.showLoadingDialog(context, key);
                          },
                        ),
                      ),
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}
