import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';

class CustomerVisualization extends StatefulWidget {
  const CustomerVisualization({Key? key}) : super(key: key);

  @override
  _CustomerVisualizationState createState() => _CustomerVisualizationState();
}

class _CustomerVisualizationState extends State<CustomerVisualization> {
  Repository _repository = Repository();
  String selectedFilter = 'Week';
  List<String> filters = ['Week', 'Month', 'Year', 'Custom'];
  List<Map> customerData = [];
  Map<String, dynamic> countAmount = {};
  int count = 0;
  String initDate = '01-09-2021';
  DateTime _start = (DateTime.now())
      .subtract(Duration(days: DateTime.now().weekday - 1))
      .date;
  DateTime _end = (DateTime.now())
      // .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday))
      .date
      .add(const Duration(hours: 23, minutes: 59, seconds: 59));

  ///Custom Filters Are ['Day','Date','Month','Year']
  String selectedCustomFilter = 'Day';

  @override
  void initState() {
    getCustomerData();
    super.initState();
  }

  Future<void> getCustomerData() async {
    if (selectedFilter == 'Week') {
      await thisWeek();
    } else if (selectedFilter == 'Month') {
      await thisMonth();
    } else if (selectedFilter == 'Year') {
      await thisYear();
    } else {
      await custom();
    }
  }

  Future<void> thisMonth() async {
    _start = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _end = DateTime.now()
        .date
        .add(const Duration(hours: 23, minutes: 59, seconds: 59));
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
    customerData =
        await _repository.queries.getCustomerCountForThisMonth(_start, _end);
    countAmount = await _repository.queries.getCustomerCounts(_start, _end);
    count = countAmount['COUNT'];
    initDate = customerData[0]['DAY'];
    // debugPrint(customerData.first['DAY'].toString());
    if (mounted) setState(() {});
  }

  Future<void> thisWeek() async {
    _start = (DateTime.now())
        .subtract(Duration(days: DateTime.now().weekday + 0))
        .date;
    _end = (DateTime.now())
        // .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday))
        .date
        .add(const Duration(hours: 23, minutes: 59, seconds: 59));
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
    customerData =
        await _repository.queries.getCustomerCountForThisMonth(_start, _end);
    debugPrint('qqqqqqqq:'+customerData.toString());
    countAmount = await _repository.queries.getCustomerCounts(_start, _end);
    count = countAmount['COUNT'];
    debugPrint('qwerty : ' + customerData.toString());
    initDate = customerData[0]['DAY'];
    if (mounted) setState(() {});
  }

  Future<void> thisYear() async {
    _start = DateTime(DateTime.now().year);
    _end = (DateTime.now())
        .date
        .add(const Duration(hours: 23, minutes: 59, seconds: 59));
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
    customerData =
        await _repository.queries.getCustomerCountForThisYear(_start, _end);
    countAmount = await _repository.queries.getCustomerCounts(_start, _end);
    count = countAmount['COUNT'];
    debugPrint('qwerty : ' + customerData.toString());
    // initDate = customerData.first['DAY'];
    if (mounted) setState(() {});
  }

  Future<void> custom() async {
    if (_end.difference(_start).inDays <= 7) {
      selectedCustomFilter = 'Day';
      await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
      customerData =
          await _repository.queries.getCustomerCountForThisMonth(_start, _end);
      initDate = customerData.first['DAY'];
      countAmount = await _repository.queries.getCustomerCounts(_start, _end);
      count = countAmount['COUNT'];
      initDate = customerData[0]['DAY'];
      if (mounted) setState(() {});
      return;
    } else if (_end.difference(_start).inDays <= 30) {
      if (_end.toIso8601String().substring(0, 4) !=
          _start.toIso8601String().substring(0, 4)) {
        selectedCustomFilter = 'Years';
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
        customerData = await _repository.queries
            .getCustomerCountForMoreYears(_start, _end);
        countAmount = await _repository.queries.getCustomerCounts(_start, _end);
        count = countAmount['COUNT'];
        // initDate = customerData.first['DAY'];
        if (mounted) setState(() {});
        return;
      } else {
        selectedCustomFilter = 'Date';
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
        customerData = await _repository.queries
            .getCustomerCountForThisMonth(_start, _end);
        countAmount = await _repository.queries.getCustomerCounts(_start, _end);
        count = countAmount['COUNT'];
        initDate = customerData[0]['DAY'];
        if (mounted) setState(() {});
        return;
      }
    } else if (_end.difference(_start).inDays <= 365) {
      if (_end.toIso8601String().substring(0, 4) !=
          _start.toIso8601String().substring(0, 4)) {
        selectedCustomFilter = 'Years';
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
        customerData = await _repository.queries
            .getCustomerCountForMoreYears(_start, _end);
        countAmount = await _repository.queries.getCustomerCounts(_start, _end);
        count = countAmount['COUNT'];
        // initDate = customerData.first['DAY'];
        if (mounted) setState(() {});
        return;
      } else {
        selectedCustomFilter = 'Month';
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
        customerData =
            await _repository.queries.getCustomerCountForThisYear(_start, _end);
        countAmount = await _repository.queries.getCustomerCounts(_start, _end);
        count = countAmount['COUNT'];
        // initDate = customerData.first['DAY'];
        if (mounted) setState(() {});
        return;
      }
    } else if (_end.difference(_start).inDays >= 365) {
      selectedCustomFilter = 'Years';
      await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
      customerData =
          await _repository.queries.getCustomerCountForMoreYears(_start, _end);
      countAmount = await _repository.queries.getCustomerCounts(_start, _end);
      count = countAmount['COUNT'];
      // initDate = customerData.first['DAY'];
      if (mounted) setState(() {});
      return;
    } else {
      selectedCustomFilter = 'Year';
      await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
      customerData =
          await _repository.queries.getCustomerCountForYears(_start, _end);
      countAmount = await _repository.queries.getCustomerCounts(_start, _end);
      count = countAmount['COUNT'];
      // initDate = customerData.first['DAY'];
      if (mounted) setState(() {});
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                    vertical: MediaQuery.of(context).size.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      // color: AppTheme.paleGrey,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppTheme.paleGrey,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppAssets.customersIcon,
                            // color: AppTheme.electricBlue,
                            height: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Customers',
                            style: TextStyle(
                                color: AppTheme.brownishGrey,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Customers Added',
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
                                  style:
                                      TextStyle(color: AppTheme.brownishGrey),
                                  onChanged: (String? newValue) {
                                    if (newValue != 'Custom') {
                                      selectedFilter = newValue!;
                                      getCustomerData();
                                    } else {
                                      dateRangeFilter().then((value) {
                                        if (value.first != null &&
                                            value.last != null)
                                          // setState(() {
                                          selectedFilter = newValue!;
                                        if (value.first != null)
                                          _start = value.first;
                                        if (value.last != null)
                                          _end = value.last;
                                        // });
                                        getCustomerData();
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
                    Flexible(
                      child: Container(
                        // height: 100,
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: count > 0
                            ? Scrollbar(
                                child: charts.BarChart(
                                  _createChartData(),
                                  animationDuration:
                                      Duration(milliseconds: 500),
                                  animate: true,
                                  // barRendererDecorator:
                                  //     new charts.BarLabelDecorator<String>(
                                  //         labelPosition:
                                  //             charts.BarLabelPosition.outside,
                                  //         outsideLabelStyleSpec:
                                  //             charts.TextStyleSpec(
                                  //                 color: charts.Color.fromHex(
                                  //                     code: '#1058FF'))),
                                  // domainAxis: new charts.OrdinalAxisSpec(),
                                  behaviors: [
                                    new charts.SlidingViewport(),
                                    // A pan and zoom behavior helps demonstrate the sliding viewport
                                    // behavior by allowing the data visible in the viewport to be adjusted
                                    // dynamically.
                                    new charts.PanAndZoomBehavior(),
                                  ],
                                  primaryMeasureAxis: charts.NumericAxisSpec(
                                    showAxisLine: true,
                                    tickProviderSpec:
                                        charts.BasicNumericTickProviderSpec(
                                            desiredTickCount: 11),
                                    // viewport: charts.NumericExtents(0, 100)
                                  ),

                                  // Set an initial viewport to demonstrate the sliding viewport behavior on
                                  // initial chart load.
                                  domainAxis: new charts.OrdinalAxisSpec(
                                      viewport: new charts.OrdinalViewport(
                                          DateFormat('dd').format(
                                              DateFormat('dd-MM-yyyy')
                                                  .parse('$initDate')),
                                          7),
                                      showAxisLine: true),
                                ),
                              )
                            : Image.asset(AppAssets.barChartIcon),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppTheme.electricBlue),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text('Customers'),
                      ],
                    )
                  ],
                )),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          count > 0
              ? Container(
                  // height: MediaQuery.of(context).size.height * 0.15,
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.02),
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.015,
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  width: MediaQuery.of(context).size.width * 0.90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    dense: true,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppAssets.roundedCustomerIcon,
                          // color: AppTheme.electricBlue,
                          height: 50,
                        ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Customers',
                              style: TextStyle(
                                  color: AppTheme.brownishGrey,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            AnimatedCount(
                              count: count,
                              duration: Duration(seconds: 1),
                              style: TextStyle(
                                  color: AppTheme.electricBlue,
                                  fontSize: 46,
                                  fontWeight: FontWeight.w900),
                            )
                          ],
                        ),
                      ],
                    ),
                    // trailing: Container(
                    //     // margin: EdgeInsets.all(
                    //     //     MediaQuery.of(context).size.width * 0.02),
                    //     width: MediaQuery.of(context).size.width * 0.4,
                    //     alignment: Alignment.bottomRight,
                    //     child: FittedBox(
                    //       fit: BoxFit.scaleDown,
                    //       child: Row(
                    //         crossAxisAlignment: CrossAxisAlignment.end,
                    //         children: [
                    //           FutureBuilder<int>(
                    //               future: getTotalCustomers(),
                    //               builder: (context, snapshot) {
                    //                 return AnimatedCount(
                    //                   count: snapshot.data ?? 0,
                    //                   duration: Duration(seconds: 1),
                    //                   style: TextStyle(
                    //                       color: AppTheme.electricBlue,
                    //                       fontSize: 70,
                    //                       fontWeight: FontWeight.w900),
                    //                 );
                    //               }),
                    //         ],
                    //       ),
                    //     )),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    'No customers found.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brownishGrey),
                  ),
                ),
        ],
      ),
    );
  }

  Future<int> getTotalCustomers() async {
    int count = 0;
    await Future.forEach<Map>(customerData, (element) {
      count += int.tryParse(element['COUNT'].toString()) ?? 0;
    });
    return count;
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

  List<charts.Series<CustomerVisualModel, String>> _createChartData() {
    List<CustomerVisualModel> data = [];
    if (selectedFilter == 'Month') {
      if (customerData.length > 0)
        data = customerData
            .map((e) => CustomerVisualModel(
                DateFormat('dd').format(
                    DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
                e['COUNT']))
            .toList();
    } else if (selectedFilter == 'Week') {
      if (customerData.length > 0)
        data = customerData
            .map((e) => CustomerVisualModel(
                DateFormat('EE').format(
                    DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
                e['COUNT']))
            .toList();
    } else if (selectedFilter == 'Year') {
      if (customerData.length > 0)
        data = customerData
            .map((e) => CustomerVisualModel(
                DateFormat('MMM')
                    .format(DateFormat('MM-yyyy').parse(e['MONTH'].toString())),
                e['COUNT']))
            .toList();
    } else {
      if (selectedCustomFilter == 'Day') {
        if (customerData.length > 0)
          data = customerData
              .map((e) => CustomerVisualModel(
                  DateFormat('EE').format(
                      DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
                  e['COUNT']))
              .toList();
      } else if (selectedCustomFilter == 'Date') {
        if (customerData.length > 0)
          data = customerData
              .map((e) => CustomerVisualModel(
                  DateFormat('dd').format(
                      DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
                  e['COUNT']))
              .toList();
      } else if (selectedCustomFilter == 'Month') {
        if (customerData.length > 0)
          // data = customerData
          // .map((e) => CustomerVisualModel(
          //     DateFormat('MMM').format(DateTime(
          //         DateTime.now().year,
          //         DateTime.now().month,
          //         int.tryParse(e['MONTH'] ?? 1.toString()) ?? 1)),
          //     e['COUNT']))
          // .toList();
          data = customerData
              .map((e) => CustomerVisualModel(
                  DateFormat('MMM').format(
                      DateFormat('MM-yyyy').parse(e['MONTH'].toString())),
                  e['COUNT']))
              .toList();
      } else if (selectedCustomFilter == 'Years') {
        if (customerData.length > 0)
          data = customerData
              .map((e) => CustomerVisualModel(
                  DateFormat('yyyy')
                      .format(DateFormat('yyyy').parse(e['DAY'].toString())),
                  e['COUNT']))
              .toList();
      } else {
        if (customerData.length > 0)
          data = customerData
              .map((e) =>
                  CustomerVisualModel(e['YEAR'] ?? 2021.toString(), e['COUNT']))
              .toList();
      }
    }

    return [
      new charts.Series<CustomerVisualModel, String>(
          id: 'Customer Visualization Data',
          colorFn: (_, __) => charts.Color.fromHex(code: '#1058FF'),
          domainFn: (CustomerVisualModel c, _) => c.xDomain,
          measureFn: (CustomerVisualModel c, _) => c.customerCount,
          data: data,
          labelAccessorFn: (CustomerVisualModel c, _) =>
              '${c.customerCount.toString()}')
    ];
  }
}

class CustomerVisualModel {
  final String xDomain;
  final int customerCount;

  CustomerVisualModel(this.xDomain, this.customerCount);
}
