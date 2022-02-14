import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:urbanledger/Services/LocalQueries/mobile_analytics_queries.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/animated_number_counter.dart';

class CustomPieChart extends StatefulWidget {
  final isSelected;
  const CustomPieChart({Key? key, this.isSelected,}) : super(key: key);

  @override
  CustomPieChartState createState() => CustomPieChartState();
}

class CustomPieChartState extends State<CustomPieChart> {
  // String _selectedValue1 = 'Week';
  String selectedFilter = 'Week';
  List<String> filters = ['Week', 'Month', 'Year', 'Custom'];
  List<dynamic> pieData = [];
  double totalAmount = 0;
  Repository _repository = Repository();
  double amount = 0.0;
  List<Color> colorList = [
    Color.fromRGBO(174, 50, 250, 1),
    Color.fromRGBO(0, 83, 146, 1),
    Color.fromRGBO(24, 163, 222, 1),
    Color.fromRGBO(125, 219, 250, 1),
  ];
  DateTime _start = (DateTime.now())
      .subtract(Duration(days: DateTime.now().weekday - 1))
      .date;
  DateTime _end = (DateTime.now())
      // .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday))
      .date
      .add(Duration(hours: 23, minutes: 59, seconds: 59));

  String selectedCustomFilter = 'Day';
  // Map<String, double> dataMap = {};
  Map<String, double> dataMap = {
    "Global/Dynamic Payment Link": 0,
    "Static/Global QR code": 0,
    "UL App payment": 0,
  };

  bool isCountfound = false;

  @override
  void initState() {
    isCountfound = widget.isSelected;
    print("abbaPiechart");
    getpieData();
    super.initState();
  }

  Future<void> getpieData() async {
    if (selectedFilter == 'Week') {
      await thisWeek();
      isCountfound = true;
    } else if (selectedFilter == 'Month') {
      await thisMonth();
      isCountfound = true;
    } else if (selectedFilter == 'Year') {
      await thisYear();
      isCountfound = true;
    } else {
      await custom();
      isCountfound = true;
    }
  }

  Future<void> thisMonth() async {
    _start = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _end =
        DateTime.now().date.add(Duration(hours: 23, minutes: 59, seconds: 59));
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
    pieData = await _repository.queries.getTotalLinkGenerated(_start, _end);
    dataMap = pieData[0];
    amount = await _repository.queries.getPieTotalAmount(_start, _end);
    debugPrint('qwert : ' + pieData.toString());
    if (mounted) setState(() {});
  }

  Future<void> thisWeek() async {
    _start =
        (DateTime.now()).subtract(Duration(days: DateTime.now().weekday +0)).date;
    _end = (DateTime.now())
        // .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday))
        .date
        .add(Duration(hours: 23, minutes: 59, seconds: 59));
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
    pieData = await _repository.queries.getTotalLinkGenerated(_start, _end);
    dataMap = pieData[0];
    debugPrint('zxcvb :' + pieData[1].toString().runtimeType.toString());
    amount = await _repository.queries.getPieTotalAmount(_start, _end);
    debugPrint('qwert : ' + pieData.toString());
    if (mounted) setState(() {});
  }

  Future<void> thisYear() async {
    _start = DateTime(DateTime.now().year);
    _end = (DateTime.now())
        .date
        .add(Duration(hours: 23, minutes: 59, seconds: 59));
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
    pieData = await _repository.queries.getTotalLinkGenerated(_start, _end);
    dataMap = pieData[0];
    amount = await _repository.queries.getPieTotalAmount(_start, _end);
    debugPrint('qwert : ' + pieData.toString());
    if (mounted) setState(() {});
  }

  Future<void> custom() async {
    if (_end.difference(_start).inDays <= 7) {
      selectedCustomFilter = 'Day';
      // thisWeek();
      await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
      pieData = await _repository.queries.getTotalLinkGenerated(_start, _end);
      amount = await _repository.queries.getPieTotalAmount(_start, _end);
      dataMap = pieData[0];

      if (mounted) setState(() {});
      return;
    } else if (_end.difference(_start).inDays <= 30) {
      selectedCustomFilter = 'Date';
      await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
      pieData = await _repository.queries.getTotalLinkGenerated(_start, _end);
      amount = await _repository.queries.getPieTotalAmount(_start, _end);
      // initDate = lData[0]['DAY'];
      dataMap = pieData[0];

      if (mounted) setState(() {});
      return;
    } else if (_end.difference(_start).inDays <= 365) {
      selectedCustomFilter = 'Month';
      await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
      pieData = await _repository.queries.getTotalLinkGenerated(_start, _end);
      amount = await _repository.queries.getPieTotalAmount(_start, _end);
      // initDate = lData[0]['DAY'];
      dataMap = pieData[0];

      if (mounted) setState(() {});
      return;
    } else {
      selectedCustomFilter = 'Year';
      await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
      pieData = await _repository.queries.getTotalLinkGenerated(_start, _end);
      amount = await _repository.queries.getPieTotalAmount(_start, _end);
      // initDate = lData[0]['DAY'];
      dataMap = pieData[0];

      if (mounted) setState(() {});
      return;
    }
  }

  Future<List> dateRangeFilter() async {
    DateTime? start;
    DateTime? end;
    final selectedDate = await showCustomDatePicker(context,
        firstDate: DateTime(DateTime.now().year - 5),
        initialDate: _start,
        lastDate: _end);
    if (selectedDate != null) {
      final selectedDate1 = await showCustomDatePicker(context,
          firstDate: selectedDate, initialDate: _end, lastDate: DateTime.now());
      if (selectedDate1 != null) {
        start = selectedDate;
        // _selectedFilter = tempRadioOption;
        end = selectedDate1.date
            .add(Duration(hours: 23, minutes: 59, seconds: 59));
        // getBusinessData();
      }
    }
    return [start, end];
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.45,
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02),
          width: MediaQuery.of(context).size.width * 0.90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.00,
                  vertical: MediaQuery.of(context).size.height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total amount collected',
                          style: TextStyle(
                              color: AppTheme.electricBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 25,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppTheme.paleGrey,
                              ),
                              child: DropdownButton<String>(
                                value: selectedFilter,
                                // icon: Icon(Icons.arrow),

                                isDense: true,
                                // iconSize: 24,
                                // elevation: 8,
                                style: TextStyle(color: AppTheme.brownishGrey),
                                onChanged: (String? newValue) {
                                  if (newValue != 'Custom') {
                                    selectedFilter = newValue!;
                                    getpieData();
                                  } else {
                                    dateRangeFilter().then((value) {
                                      if (value.first != null &&
                                          value.last != null)
                                        // setState(() {
                                        selectedFilter = newValue!;
                                      if (value.first != null)
                                        _start = value.first;
                                      if (value.last != null) _end = value.last;
                                      // });
                                      getpieData();
                                    });
                                  }
                                },
                                items: filters.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            10.0.heightBox,
                            CustomText(
                              DateFormat('dd MMM yy').format(_start) +
                                  " - " +
                                  DateFormat('dd MMM yy').format(_end),
                              bold: FontWeight.w500,
                              color: AppTheme.brownishGrey,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  dataMap['Global/Dynamic Payment Link']! > 0 ||
                          dataMap['Static/Global QR code']! > 0 ||
                          dataMap['UL App payment']! > 0
                      ? Flexible(
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.045),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: AppTheme.paleGrey,
                                    ),
                                    padding: EdgeInsets.all(40),
                                    child: Image.asset(
                                      AppAssets.logoIcon,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width *
                                          0.17,
                                    ),
                                  )),
                              Container(
                                // height: 100,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: PieChart(
                                  dataMap: dataMap,
                                  animationDuration: Duration(seconds: 1),
                                  chartRadius:
                                      MediaQuery.of(context).size.width / 3,
                                  colorList: colorList,
                                  initialAngleInDegree: 0,
                                  chartType: ChartType.ring,
                                  ringStrokeWidth: 50,
                                  legendOptions: LegendOptions(
                                    showLegendsInRow: true,
                                    legendPosition: LegendPosition.bottom,
                                    showLegends: true,
                                    legendShape: BoxShape.circle,
                                    legendTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  chartValuesOptions: ChartValuesOptions(
                                      chartValueStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      showChartValueBackground: true,
                                      showChartValues: true,
                                      showChartValuesInPercentage: true,
                                      showChartValuesOutside: true,
                                      decimalPlaces: 0,
                                      chartValueBackgroundColor:
                                          AppTheme.brownishGrey),
                                ),
                              )
                            ],
                          ),
                        )
                      : isCountfound == true ? Image.asset(AppAssets.barChartIcon) : SizedBox(height: 0, width:0),
                  // Text('Customers')
                ],
              )),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        dataMap['Global/Dynamic Payment Link']! > 0 ||
                dataMap['Static/Global QR code']! > 0 ||
                dataMap['UL App payment']! > 0
            ? Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.03,
                            top: MediaQuery.of(context).size.height * 0.01,
                            bottom: MediaQuery.of(context).size.height * 0.01),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppAssets.amountIcon,
                              // color: AppTheme.electricBlue,
                              height: 50,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Total Amount\nCollected',
                              style: TextStyle(
                                  color: AppTheme.brownishGrey,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(
                    //       right: MediaQuery.of(context).size.width * 0.03),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.end,
                    //     children: [
                    //       Text(
                    //         '$currencyAED\n',
                    //         style: TextStyle(
                    //             color: AppTheme.brownishGrey,
                    //             fontSize: 24,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //       AnimatedCount(
                    //         count: amount.toInt(),
                    //         duration: Duration(seconds: 1),
                    //         style: TextStyle(
                    //             color: AppTheme.electricBlue,
                    //             fontSize: 36,
                    //             fontWeight: FontWeight.w900),
                    //       ),
                    //     ],
                    //   ),
                    // )
                    Flexible(
                      child: Container(
                          // margin: EdgeInsets.all(
                          //     MediaQuery.of(context).size.width * 0.02),
                          width: MediaQuery.of(context).size.width * 0.4,
                          alignment: Alignment.bottomLeft,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  AppAssets.amountIcon,
                                  color: Colors.white,
                                  height: 70,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        '$currencyAED ',
                                        style: TextStyle(
                                            color: AppTheme.brownishGrey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24),
                                      ),
                                    ),
                                    AnimatedCount(
                                      count: amount.toInt(),
                                      duration: Duration(seconds: 1),
                                      style: TextStyle(
                                          color: AppTheme.electricBlue,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                    // Expanded(
                    //   child: Container(
                    //     margin: EdgeInsets.only(
                    //         right: MediaQuery.of(context).size.width * 0.03),
                    //     child: RichText(
                    //       textAlign: TextAlign.right,
                    //       text: TextSpan(children: [
                    //         TextSpan(
                    //           text: '$currencyAED\n',
                    //           style: TextStyle(
                    //               color: AppTheme.brownishGrey,
                    //               fontSize: 24,
                    //               fontWeight: FontWeight.w500),
                    //         ),
                    //         // TextSpan(
                    //         //   text: '$amount',
                    //         //   style: TextStyle(
                    //         //       color: AppTheme.electricBlue,
                    //         //       fontSize: 36,
                    //         //       fontWeight: FontWeight.w900),
                    //         // ),
                    //       ]),
                    //     ),
                    //   ),
                    // ),
                    // AnimatedCount(
                    //   count: amount,
                    //   duration: Duration(seconds: 1),
                    //   style: TextStyle(
                    //       color: AppTheme.electricBlue,
                    //       fontSize: 46,
                    //       fontWeight: FontWeight.w900),
                    // ),
                  ],
                ),
              )
            : Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  'No transaction entries found.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brownishGrey),
                ),
              ),
      ],
    );
  }
}
