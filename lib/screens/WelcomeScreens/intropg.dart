import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:pausable_timer/pausable_timer.dart';


class IntroductionScreen extends StatefulWidget {
  final bool isRegister;

  const IntroductionScreen({Key? key, required this.isRegister})
      : super(key: key);
  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final int _numPages = 5;
  late PausableTimer timer;
  final PageController _pageController = PageController(initialPage: 0);

  int _currentPage = 0;
  @override
  void initState() {
    _pageController.addListener(() {
      // timer.start();
      setState(() {
        // _currentPage = _pageController.page;
      });
    });
    super.initState();
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }

    // for (int i = 0; i < _numPages; i++) {

    if (_currentPage >= 4) {
      if (widget.isRegister) {
        Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed(AppRoutes.welcomescreenRoute);});
      } else {
        Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed(AppRoutes.pinLoginRoute);});
      }
    } else {
      timer = PausableTimer(Duration(seconds: 3), () async {
        debugPrint('call $_currentPage');
        _pageController.jumpToPage(_currentPage + 1);
      });
      timer.start();
    }

    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      margin: EdgeInsets.fromLTRB(2, 0, 2, 30),
      height: 4.0,
      width: isActive ? 22.0 : 5.0,
      decoration: BoxDecoration(
        color: isActive ? Color(0xff1058FF) : Colors.grey[350],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onLongPress: (){
          timer.pause();
        },
        onLongPressUp: (){
          timer.start();
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: new BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/icons/appicon.png"),
                              // fit: BoxFit.cover,
                            ),
                            // shape: BoxShape.circle,
                          )),
                      GestureDetector(
                        onTap: () {
                          if (widget.isRegister) {
                            Navigator.of(context).pushReplacementNamed(
                                AppRoutes.welcomescreenRoute);
                          } else {
                            Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.pinLoginRoute);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppTheme.paleGrey),
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.028,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.004),
                          margin: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.05),
                          child: Text(
                            'Skip',
                            style: TextStyle(
                                color: AppTheme.coolGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      // reverse: true,
                      onPageChanged: (int page) {
                        _currentPage = page;
                        timer.cancel();
                        debugPrint(page.toString());
                        setState(() {});
                      },
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 40.0, left: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                height: MediaQuery.of(context).size.height * 0.45,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new AssetImage(
                                        'assets/images/Home Screen 1-1.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.050,
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.1),
                                  child: CustomText(
                                    'Keep track of\nyour transactions',
                                    color: AppTheme.electricBlue,
                                    size: 38,
                                    bold: FontWeight.w800,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width * 0.1),
                                child: CustomText(
                                  "Now you can add a ledger \nenter for each transaction from\nyour customer and suppliers",
                                  color: AppTheme.coolGrey,
                                  size: 22,
                                  bold: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 40.0, left: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                height: MediaQuery.of(context).size.height * 0.45,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new AssetImage(
                                        'assets/images/Home Screen 2-2.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.050,
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.1),
                                  child: CustomText(
                                    'Set\nreminders',
                                    color: AppTheme.electricBlue,
                                    size: 38,
                                    bold: FontWeight.w800,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width * 0.1),
                                child: CustomText(
                                  "Keep track of your\nreceivables by setting up a\nreminder to collect money",
                                  color: AppTheme.coolGrey,
                                  size: 22,
                                  bold: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 40.0, left: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                height: MediaQuery.of(context).size.height * 0.45,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new AssetImage(
                                        'assets/images/Home Screen 3-3.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.050,
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.1),
                                  child: CustomText(
                                    'Collect\npayments',
                                    color: AppTheme.electricBlue,
                                    size: 38,
                                    bold: FontWeight.w800,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width * 0.1),
                                child: CustomText(
                                  "Use your permanent QR code or\npayment links to collect payments or\ncreate a customized one on the go",
                                  color: AppTheme.coolGrey,
                                  size: 22,
                                  bold: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 40.0, left: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                height: MediaQuery.of(context).size.height * 0.45,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new AssetImage(
                                        'assets/images/Home Screen 4-4.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.050,
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.1),
                                  child: CustomText(
                                    'Built-in\nchat',
                                    color: AppTheme.electricBlue,
                                    size: 38,
                                    bold: FontWeight.w800,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width * 0.1),
                                child: CustomText(
                                  "Now collect orders and\npayments on the chat and\nkeep track of your interactions",
                                  color: AppTheme.coolGrey,
                                  size: 22,
                                  bold: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 40.0, left: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                height: MediaQuery.of(context).size.height * 0.45,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new AssetImage(
                                        'assets/images/Home Screen 5-5.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.050,
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.1),
                                  child: CustomText(
                                    'Business\nInsights',
                                    color: AppTheme.electricBlue,
                                    size: 38,
                                    bold: FontWeight.w800,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width * 0.1),
                                child: CustomText(
                                  "Get insights on your\nbusiness right from the app",
                                  color: AppTheme.coolGrey,
                                  size: 22,
                                  bold: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.099,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
