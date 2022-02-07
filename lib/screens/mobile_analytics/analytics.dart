import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Models/graph_model.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:urbanledger/screens/mobile_analytics/business_summary.dart';
import 'package:urbanledger/screens/mobile_analytics/cashbook.dart';
import 'package:urbanledger/screens/mobile_analytics/generated_pay_link.dart';
import 'package:urbanledger/screens/mobile_analytics/generated_pay_qr.dart';
import 'package:urbanledger/screens/mobile_analytics/pie_chart.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:urbanledger/screens/mobile_analytics/customer_visualization.dart';

class MobileAnalytics extends StatefulWidget {
  @override
  _MobileAnalyticsState createState() => _MobileAnalyticsState();
}

class _MobileAnalyticsState extends State<MobileAnalytics> {
  CarouselController carouselController = new CarouselController();
  final GlobalKey<State> key = GlobalKey<State>();
  late TabController _tabController;
  bool _selected1 = true;
  bool _selected2 = false;
  bool _selected3 = false;
  bool _selected4 = false;
  bool _selected5 = false;
  bool _selected6 = false;
  int _current = 0;

  bool _selectedLink = false;
  bool _selectedAmtCollected = false;
  bool _selectedQR = false;
  bool _selectedRevenue = false;

  String _selectedValue1 = 'Week';

  String _selectedValue3 = 'Week';
  String _selectedValue4 = 'Week';
  List<String> listData1 = ['Week', 'Month', 'Year', 'Custom'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage('assets/images/back.png'),
              alignment: Alignment.topCenter),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios)),
            title: Text('Account Insights'),
            actions: [
              GestureDetector(
                onTap: () async {
                  CustomLoadingDialog.showLoadingDialog(context, key);
                  String _startDate =
                      await (CustomSharedPreferences.get('_startDate'));
                  String _endDate =
                      await (CustomSharedPreferences.get('_endDate'));
                  Map<String, dynamic> data = {
                    "startDate": "$_startDate",
                    "endDate": "$_endDate"
                  };
                  debugPrint('RRRR: ' + data.toString());
                  Map response = await repository.analyticsAPI.exportPDF(data);
                  debugPrint('RRRR: ' + response.toString());
                  if (response['status']) {
                    String fileName = await repository.ledgerApi
                        .networkImageToFile2(
                            response['file_name'].split('/').last);
                    Navigator.of(context).pop();
                    await showNotification(1, 'Pdf Downloaded',
                        fileName.split('/').last, {'pdfPath': fileName});
                  } else {
                    Navigator.of(context).pop();
                    '${response["message"]}'.showSnackBar(context);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(right: 15),
                  child: Image.asset(
                    AppAssets.reportIcon,
                    width: 30,
                  ),
                ),
              ),
            ],
          ),
          body: Container(
            margin: EdgeInsets.only(top: deviceHeight * 0.08),
            child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01),
                        padding: EdgeInsets.only(left: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            _current = 0;
                            setState(() {
                              _selected2 = false;
                              _selected3 = false;
                              _selected4 = false;
                              _selected5 = false;
                              _selected6 = false;
                              _selected1 = true;
                            });
                            // carouselController.jumpToPage(0);
                          },
                          child: Card(
                            color: _selected1 == true
                                ? Color.fromRGBO(240, 245, 255, 1)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              side: _selected1 == true
                                  ? BorderSide(
                                      width: 0.5,
                                      style: BorderStyle.solid,
                                      color: AppTheme.electricBlue)
                                  : BorderSide(
                                      style: BorderStyle.none,
                                    ),
                            ),
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.02),
                                child: Text(
                                  'Total Amount\nreceived',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: _selected1 == true
                                          ? AppTheme.electricBlue
                                          : AppTheme.brownishGrey,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01),
                        padding: EdgeInsets.only(right: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            _current = 1;
                            setState(() {
                              _selected3 = false;
                              _selected4 = false;
                              _selected1 = false;
                              _selected5 = false;
                              _selected6 = false;
                              _selected2 = true;
                            });
                            // carouselController.jumpToPage(1);
                          },
                          child: Card(
                            color: _selected2 == true
                                ? Color.fromRGBO(240, 245, 255, 1)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              side: _selected2 == true
                                  ? BorderSide(
                                      width: 0.5,
                                      style: BorderStyle.solid,
                                      color: AppTheme.electricBlue)
                                  : BorderSide(
                                      style: BorderStyle.none,
                                    ),
                            ),
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.02),
                                child: Text(
                                  'Customer data\nvisualization',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: _selected2 == true
                                          ? AppTheme.electricBlue
                                          : AppTheme.brownishGrey,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01),
                        padding: EdgeInsets.only(left: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            _current = 2;
                            setState(() {
                              _selected2 = false;
                              _selected4 = false;
                              _selected1 = false;
                              _selected5 = false;
                              _selected6 = false;
                              _selected3 = true;
                            });
                            // carouselController.jumpToPage(2);
                          },
                          child: Card(
                            color: _selected3 == true
                                ? Color.fromRGBO(240, 245, 255, 1)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              side: _selected3 == true
                                  ? BorderSide(
                                      width: 0.5,
                                      style: BorderStyle.solid,
                                      color: AppTheme.electricBlue)
                                  : BorderSide(
                                      style: BorderStyle.none,
                                    ),
                            ),
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.02),
                                child: Text(
                                  'Link generated Vs\nRevenue',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: _selected3 == true
                                          ? AppTheme.electricBlue
                                          : AppTheme.brownishGrey,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01),
                        padding: EdgeInsets.only(right: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            _current = 3;
                            setState(() {
                              _selected2 = false;
                              _selected3 = false;
                              _selected1 = false;
                              _selected5 = false;
                              _selected6 = false;
                              _selected4 = true;
                            });
                            // carouselController.jumpToPage(3);
                          },
                          child: Card(
                            color: _selected4 == true
                                ? Color.fromRGBO(240, 245, 255, 1)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              side: _selected4 == true
                                  ? BorderSide(
                                      width: 0.5,
                                      style: BorderStyle.solid,
                                      color: AppTheme.electricBlue)
                                  : BorderSide(
                                      style: BorderStyle.none,
                                    ),
                            ),
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.02),
                                child: Text(
                                  'QR code generated\nVs Revenue',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: _selected4 == true
                                          ? AppTheme.electricBlue
                                          : AppTheme.brownishGrey,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01),
                        padding: EdgeInsets.only(left: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            _current = 2;
                            setState(() {
                              _selected2 = false;
                              _selected4 = false;
                              _selected1 = false;
                              _selected3 = false;
                              _selected6 = false;
                              _selected5 = true;
                            });
                            // carouselController.jumpToPage(2);
                          },
                          child: Card(
                            color: _selected5 == true
                                ? Color.fromRGBO(240, 245, 255, 1)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              side: _selected5 == true
                                  ? BorderSide(
                                      width: 0.5,
                                      style: BorderStyle.solid,
                                      color: AppTheme.electricBlue)
                                  : BorderSide(
                                      style: BorderStyle.none,
                                    ),
                            ),
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.03),
                                child: Text(
                                  'Business Summary',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: _selected5 == true
                                          ? AppTheme.electricBlue
                                          : AppTheme.brownishGrey,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01),
                        padding: EdgeInsets.only(right: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            _current = 3;
                            setState(() {
                              _selected2 = false;
                              _selected3 = false;
                              _selected1 = false;
                              _selected4 = false;
                              _selected5 = false;
                              _selected6 = true;
                            });
                            // carouselController.jumpToPage(3);
                          },
                          child: Card(
                            color: _selected6 == true
                                ? Color.fromRGBO(240, 245, 255, 1)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              side: _selected6 == true
                                  ? BorderSide(
                                      width: 0.5,
                                      style: BorderStyle.solid,
                                      color: AppTheme.electricBlue)
                                  : BorderSide(
                                      style: BorderStyle.none,
                                    ),
                            ),
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.03),
                                child: Text(
                                  'Cashbook',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: _selected6 == true
                                          ? AppTheme.electricBlue
                                          : AppTheme.brownishGrey,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                if (_selected1 == true &&
                    _selected2 == false &&
                    _selected3 == false &&
                    _selected4 == false &&
                    _selected6 == false &&
                    _selected5 == false)
                  CustomPieChart(
                    isSelected: false,
                  ),
                if (_selected1 == false &&
                    _selected2 == true &&
                    _selected3 == false &&
                    _selected4 == false &&
                    _selected6 == false &&
                    _selected5 == false)
                  CustomerVisualization(
                    isSelected: false,
                  ),
                if (_selected1 == false &&
                    _selected2 == false &&
                    _selected3 == true &&
                    _selected4 == false &&
                    _selected6 == false &&
                    _selected5 == false)
                  GeneratedPayLink(
                    isSelected: false,
                  ),
                if (_selected1 == false &&
                    _selected2 == false &&
                    _selected3 == false &&
                    _selected6 == false &&
                    _selected5 == false &&
                    _selected4 == true)
                  GeneratedPayQR(
                    isSelected: false,
                  ),
                if (_selected1 == false &&
                    _selected2 == false &&
                    _selected3 == false &&
                    _selected4 == false &&
                    _selected6 == false &&
                    _selected5 == true)
                  BusinessSummary(),
                if (_selected1 == false &&
                    _selected2 == false &&
                    _selected3 == false &&
                    _selected4 == false &&
                    _selected6 == true &&
                    _selected5 == false)
                  CashbookAnalytics(),
                SizedBox(
                  height: deviceHeight * 0.05,
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
