import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Models/business_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';

class BusinessSummary extends StatefulWidget {
  const BusinessSummary({Key? key}) : super(key: key);

  @override
  _BusinessSummaryState createState() => _BusinessSummaryState();
}

class _BusinessSummaryState extends State<BusinessSummary> {
  Repository _repository = Repository();
  String selectedFilter = 'Week';
  List<String> filters = ['Week', 'Month', 'Year', 'Custom'];
  List<Map> paybleData = [];
  List<Map> receivableData = [];
  String businessName = '';
  List<double> total = [];
  List<dynamic> lData = [];
  int giveAmount = 0;
  int receiveAmount = 0;
  Map<String, dynamic> countAmount = {};
  // String initDate = '01-09-2021';
  DateTime _start = (DateTime.now())
      .subtract(Duration(days: DateTime.now().weekday - 1))
      .date;
  DateTime _end = (DateTime.now())
      // .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday))
      .date
      .add(Duration(hours: 23, minutes: 59, seconds: 59));

  ///Custom Filters Are ['Day','Date','Month','Year']
  String selectedCustomFilter = 'Day';
  bool _selectedQR = true;
  bool _selectedRevenue = false;
  double totalPay = 0.0;
  double totalReceive = 0.0;
  int _selectedSort = 0;
  // late Future<List<double>> payReceive;
  List<BusinessSummaryModel> businesses = [];
  bool isLoading = true;
  // final List<charts.Series> seriesList;

  @override
  void initState() {
    getlinkAndAmountData();
    super.initState();
  }

  Future<void> getlinkAndAmountData() async {
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

  void getBusinessData(DateTime startDate, DateTime lastDate) {
    businesses.clear();
    totalPay = 0;
    totalReceive = 0;
    Future.forEach<BusinessModel>(
        Provider.of<BusinessProvider>(context, listen: false).businesses,
        (element) async {
      final data = await repository.queries.getCustomerTransactionDataOnDate(
          startDate, lastDate, element.businessId);
      totalReceive += data[1];
      totalPay += data[2];
      businesses.add(
        BusinessSummaryModel(
            customerCount: data.first,
            businessname: element.businessName,
            pay: data[2],
            receive: data[1]),
      );
      businessName = 'PERSONAL';
      businessName = businesses[0].businessname;
      // debugPrint('Businrss : ' + businesses[0].businessname);
      // debugPrint('Businrss : '+businesses[1].businessname);
      debugPrint('Pay : ' + data[1].toString() + ' ' + data[2].toString());
      debugPrint('totalPay : ' +
          businesses[0].pay.toString() +
          ' ' +
          businesses[0].receive.toString());
    }).then((value) {
      applySort();
      setState(() {
        if (isLoading) isLoading = false;
      });
    });
  }

  void applySort() {
    switch (_selectedSort) {
      case 1:
        businesses.sort((a, b) => a.businessname.compareTo(b.businessname));
        // setState(() {});
        break;
      case 2:
        businesses.sort((a, b) => a.receive!.compareTo(b.receive ?? 0));
        businesses = businesses.reversed.toList();
        // setState(() {});
        break;
      case 3:
        businesses.sort((a, b) => a.pay!.compareTo(b.pay ?? 0));
        break;
      default:
    }
  }

  Future<void> thisMonth() async {
    _start = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _end =
        DateTime.now().date.add(Duration(hours: 23, minutes: 59, seconds: 59));
    // paybleData = await _repository.queries.getPayableAmount(_start, _end);
    // receivableData =
    //     await _repository.queries.getReceivableAmount(_start, _end);
    // total =
    //     await _repository.queries.getTotalPayReceiveForBusiness(_start, _end);
    // giveAmount = total.first.toInt();
    // receiveAmount = total.last.toInt();
    // businessName = paybleData.first['NAME'];
    await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
    getBusinessData(_start, _end);
    // debugPrint('awert : ' + businesses.length.toString());
    if (mounted) setState(() {});
  }

  Future<void> thisWeek() async {
    _start =
        (DateTime.now()).subtract(Duration(days: DateTime.now().weekday +0)).date;
    _end = (DateTime.now())
        // .add(Duration(days: DateTime.daysPerWeek - DateTNAMEime.now().weekday))
        .date
        .add(Duration(hours: 23, minutes: 59, seconds: 59));
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
    // receivableData =
    //     await _repository.queries.getReceivableAmount(_start, _end);
    // paybleData = await _repository.queries.getPayableAmount(_start, _end);
    // total =
    //     await _repository.queries.getTotalPayReceiveForBusiness(_start, _end);
    // giveAmount = total.first.toInt();
    // receiveAmount = total.last.toInt();
    getBusinessData(_start, _end);
    // debugPrint('qwe : '+paybleData[0].toString());
    // businessName = paybleData[0]['NAME'];
    if (mounted) setState(() {});
  }

  Future<void> thisYear() async {
    _start = DateTime(DateTime.now().year);
    _end = (DateTime.now())
        .date
        .add(Duration(hours: 23, minutes: 59, seconds: 59));
    // paybleData = await _repository.queries.getPayableAmount(_start, _end);
    // receivableData =
    //     await _repository.queries.getReceivableAmount(_start, _end);
    // total =
    //     await _repository.queries.getTotalPayReceiveForBusiness(_start, _end);
    // giveAmount = total.first.toInt();
    // receiveAmount = total.last.toInt();
    await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
    getBusinessData(_start, _end);
    // businessName = paybleData.first['NAME'];
    if (mounted) setState(() {});
  }

  Future<void> custom() async {
    if (_end.difference(_start).inDays <= 7) {
      selectedCustomFilter = 'Day';
      // paybleData = await _repository.queries.getPayableAmount(_start, _end);
      // receivableData =
      //     await _repository.queries.getReceivableAmount(_start, _end);
      // total =
      //     await _repository.queries.getTotalPayReceiveForBusiness(_start, _end);
      // giveAmount = total.first.toInt();
      // receiveAmount = total.last.toInt();
      // businessName = paybleData.first['NAME'];
      await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
      getBusinessData(_start, _end);
      if (mounted) setState(() {});
      return;
    } else if (_end.difference(_start).inDays <= 30) {
      selectedCustomFilter = 'Date';
      // paybleData = await _repository.queries.getPayableAmount(_start, _end);
      // receivableData =
      //     await _repository.queries.getReceivableAmount(_start, _end);
      // total =
      //     await _repository.queries.getTotalPayReceiveForBusiness(_start, _end);
      // giveAmount = total.first.toInt();
      // receiveAmount = total.last.toInt();
      // // businessName = paybleData.first['NAME'];
      await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
      getBusinessData(_start, _end);
      if (mounted) setState(() {});
      return;
    } else if (_end.difference(_start).inDays <= 365) {
      selectedCustomFilter = 'Month';
      // paybleData = await _repository.queries.getPayableAmount(_start, _end);
      // receivableData =
      //     await _repository.queries.getReceivableAmount(_start, _end);
      // total =
      //     await _repository.queries.getTotalPayReceiveForBusiness(_start, _end);
      // giveAmount = total.first.toInt();
      // receiveAmount = total.last.toInt();
      // businessName = paybleData.first['NAME'];
      await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
      getBusinessData(_start, _end);
      if (mounted) setState(() {});
      return;
    } else {
      selectedCustomFilter = 'Year';
      // paybleData = await _repository.queries.getPayableAmount(_start, _end);
      // receivableData =
      //     await _repository.queries.getReceivableAmount(_start, _end);
      // total =
      //     await _repository.queries.getTotalPayReceiveForBusiness(_start, _end);
      // giveAmount = total.first.toInt();
      // receiveAmount = total.last.toInt();
      await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
      getBusinessData(_start, _end);
      // businessName = paybleData.first['NAME'];
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
            height: MediaQuery.of(context).size.height * 0.41,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Receivable and Payable',
                            style: TextStyle(
                                color: AppTheme.electricBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
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
                                      getlinkAndAmountData();
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
                                        getlinkAndAmountData();
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
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Scrollbar(
                            child: charts.BarChart(
                              _createChartData(),
                              // _createSampleData(),
                              animationDuration: Duration(milliseconds: 500),
                              animate: true,
                              defaultInteractions:
                                  !MediaQuery.of(context).accessibleNavigation,
                              primaryMeasureAxis: charts.NumericAxisSpec(
                                showAxisLine: true,
                                tickProviderSpec:
                                    charts.BasicNumericTickProviderSpec(
                                        desiredTickCount: 5),
                                // viewport: charts.NumericExtents(0, 100)
                              ),
                              vertical: false,
                              behaviors: [
                                new charts.SlidingViewport(),
                                // A pan and zoom behavior helps demonstrate the sliding viewport
                                // behavior by allowing the data visible in the viewport to be adjusted
                                // dynamically.
                                new charts.PanAndZoomBehavior(),
                                new charts.DomainA11yExploreBehavior(
                                  // Callback for generating the message that is vocalized.
                                  // An example of how to use is in [vocalizeDomainAndMeasures].
                                  // If none is set, the default only vocalizes the domain value.
                                  // vocalizationCallback: vocalizeDomainAndMeasures,
                                  // The following settings are optional, but shown here for
                                  // demonstration purchases.
                                  // [exploreModeTrigger] Default is press and hold, can be
                                  // changed to tap.
                                  exploreModeTrigger:
                                      charts.ExploreModeTrigger.pressHold,
                                  // [exploreModeEnabledAnnouncement] Optionally notify the OS
                                  // when explore mode is enabled.
                                  exploreModeEnabledAnnouncement:
                                      'Explore mode enabled',
                                  // [exploreModeDisabledAnnouncement] Optionally notify the OS
                                  // when explore mode is disabled.
                                  exploreModeDisabledAnnouncement:
                                      'Explore mode disabled',
                                  // [minimumWidth] Default and minimum is 1.0. This is the
                                  // minimum width of the screen reader bounding box. The bounding
                                  // box width is calculated based on the domain axis step size.
                                  // Minimum width will be used if the step size is smaller.
                                  minimumWidth: 1.0,
                                ),

                                // Optionally include domain highlighter as a behavior.
                                // This behavior is included in this example to show that when an
                                // a11y node has focus, the chart's internal selection model is
                                // also updated.
                                new charts.DomainHighlighter(
                                    charts.SelectionModelType.info),
                              ],
                              domainAxis: new charts.OrdinalAxisSpec(
                                  viewport: new charts.OrdinalViewport(
                                      businessName, 3),
                                  showAxisLine: true),
                            ),
                          )),
                    ),
                    Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 5),
                        Wrap(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppTheme.greenColor),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text('Receivable'),
                          ],
                        ),
                        // SizedBox(width: 10,),
                        Wrap(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppTheme.tomato),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text('Payable'),
                          ],
                        ),
                        SizedBox(width: 5),
                      ],
                    )
                  ],
                )),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'You will\ngive',
                                style: TextStyle(
                                    color: AppTheme.brownishGrey,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Image.asset(
                                AppAssets.giveIcon,
                                // color: AppTheme.electricBlue,
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Container(
                              margin: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.02),
                              // alignment: Alignment
                              //     .centerLeft,
                              width: MediaQuery.of(context).size.width * 0.4,
                              alignment: Alignment.bottomLeft,
                              // width:
                              //     screenWidth(context) *
                              //         0.480,
                              // color: Colors.black,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
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
                                      count: totalPay.toInt(),
                                      duration: Duration(seconds: 1),
                                      style: TextStyle(
                                          color: AppTheme.electricBlue,
                                          fontSize: 46,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'You will\nreceive',
                                style: TextStyle(
                                    color: AppTheme.brownishGrey,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Image.asset(
                                AppAssets.getIcon,
                                // color: AppTheme.electricBlue,
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Container(
                              margin: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.02),
                              // alignment: Alignment
                              //     .centerLeft,
                              width: MediaQuery.of(context).size.width * 0.4,
                              alignment: Alignment.bottomLeft,
                              // width:
                              //     screenWidth(context) *
                              //         0.480,
                              // color: Colors.black,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
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
                                      count: totalReceive.toInt().abs(),
                                      duration: Duration(seconds: 1),
                                      style: TextStyle(
                                          color: AppTheme.electricBlue,
                                          fontSize: 46,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Future<int> getTotalCustomers() async {
  //   int count = 0;
  //   await Future.forEach<Map>(linkAndAmountData, (element) {
  //     count += int.tryParse(element['COUNT'].toString()) ?? 0;
  //   });
  //   return count;
  // }

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

  List<charts.Series<BusinessSummaryModel, String>> _createChartData() {
    List<BusinessSummaryModel> data = [];
    List<BusinessSummaryModel> data2 = [];
    if (selectedFilter == 'Month') {
      if (businesses.length > 0) {
        // if ((paybleData.first as List<dynamic>).length > 0) {
        // final List<Map> _data = paybleData.first;
        data = businesses
            .map((e) => BusinessSummaryModel(
                businessname: e.businessname, receive: e.receive))
            .toList();
        data2 = businesses
            .map((e) =>
                BusinessSummaryModel(businessname: e.businessname, pay: e.pay))
            .toList();
        // }
      }
    } else if (selectedFilter == 'Week') {
      if (businesses.length > 0) {
        // if ((paybleData.first as List<dynamic>).length > 0) {
        // final List<Map> _data = paybleData.first;
        data = businesses
            .map((e) => BusinessSummaryModel(
                businessname: e.businessname, receive: e.receive))
            .toList();
        data2 = businesses
            .map((e) =>
                BusinessSummaryModel(businessname: e.businessname, pay: e.pay))
            .toList();
        // }
      }
    } else if (selectedFilter == 'Year') {
      if (businesses.length > 0) {
        // if ((paybleData.first as List<dynamic>).length > 0) {
        // final List<Map> _data = paybleData.first;
        data = businesses
            .map((e) => BusinessSummaryModel(
                businessname: e.businessname, receive: e.receive))
            .toList();
        data2 = businesses
            .map((e) =>
                BusinessSummaryModel(businessname: e.businessname, pay: e.pay))
            .toList();
        // }
      }
    } else {
      if (selectedCustomFilter == 'Day') {
        if (businesses.length > 0) {
          // if ((paybleData.first as List<dynamic>).length > 0) {
          // final List<Map> _data = paybleData.first;
          data = businesses
              .map((e) => BusinessSummaryModel(
                  businessname: e.businessname, receive: e.receive))
              .toList();
          data2 = businesses
              .map((e) => BusinessSummaryModel(
                  businessname: e.businessname, pay: e.pay))
              .toList();
          // }
        }
      } else if (selectedCustomFilter == 'Date') {
        if (businesses.length > 0) {
          // if ((paybleData.first as List<dynamic>).length > 0) {
          // final List<Map> _data = paybleData.first;
          data = businesses
              .map((e) => BusinessSummaryModel(
                  businessname: e.businessname, receive: e.receive))
              .toList();
          data2 = businesses
              .map((e) => BusinessSummaryModel(
                  businessname: e.businessname, pay: e.pay))
              .toList();
          // }
        }
      } else if (selectedCustomFilter == 'Month') {
        if (businesses.length > 0) {
          // if ((paybleData.first as List<dynamic>).length > 0) {
          // final List<Map> _data = paybleData.first;
          data = businesses
              .map((e) => BusinessSummaryModel(
                  businessname: e.businessname, receive: e.receive))
              .toList();
          data2 = businesses
              .map((e) => BusinessSummaryModel(
                  businessname: e.businessname, pay: e.pay))
              .toList();
          // }
        }
      } else {
        if (businesses.length > 0) {
          // if ((paybleData.first as List<dynamic>).length > 0) {
          // final List<Map> _data = paybleData.first;
          data = businesses
              .map((e) => BusinessSummaryModel(
                  businessname: e.businessname, receive: e.receive))
              .toList();
          data2 = businesses
              .map((e) => BusinessSummaryModel(
                  businessname: e.businessname, pay: e.pay))
              .toList();
          // }
        }
      }
    }

    // return [
    //   new charts.Series<LinkGenModel, String>(
    //       id: 'QR generated',
    //       colorFn: (_, __) => charts.Color.fromHex(code: '#7C4DFF'),
    //       domainFn: (LinkGenModel c, _) => c.xDomain,
    //       measureFn: (LinkGenModel c, _) => c.linkCount,
    //       data: data,
    //       labelAccessorFn: (LinkGenModel c, _) => '${c.linkCount.toString()}')
    // ];
    return [
      new charts.Series<BusinessSummaryModel, String>(
        id: 'Mobile Sales',
        colorFn: (_, __) => charts.Color.fromHex(code: '#2ED06D'),
        domainFn: (BusinessSummaryModel sales, _) => sales.businessname,
        measureFn: (BusinessSummaryModel sales, _) =>
            sales.receive!.toInt().abs(),
        data: data,
      ),
      new charts.Series<BusinessSummaryModel, String>(
        id: 'Tablet Sales',
        colorFn: (_, __) => charts.Color.fromHex(code: '#E94235'),
        domainFn: (BusinessSummaryModel sales, _) => sales.businessname,
        measureFn: (BusinessSummaryModel sales, _) => sales.pay!.toInt().abs(),
        data: data2,
      )
    ];
  }
}

/// Sample ordinal data type.
// class OrdinalSales {
//   final String year;
//   final int sales;

//   OrdinalSales(this.year, this.sales);
// }

// class LinkGenModel {
//   final String xDomain;
//   final int? payable;
//   final int? receivable;

//   LinkGenModel({required this.xDomain, this.payable, this.receivable});
// }

class BusinessSummaryModel extends Equatable {
  final int? customerCount;
  final double? pay;
  final double? receive;
  final String businessname;

  BusinessSummaryModel(
      {this.customerCount, this.pay, this.receive, required this.businessname});

  @override
  List<Object?> get props => [customerCount, pay, receive, businessname];
}
