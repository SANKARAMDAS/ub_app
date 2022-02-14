import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';

class CashbookAnalytics extends StatefulWidget {
  final isSelected;
  const CashbookAnalytics({Key? key, this.isSelected}) : super(key: key);

  @override
  _CashbookAnalyticsState createState() => _CashbookAnalyticsState();
}

class _CashbookAnalyticsState extends State<CashbookAnalytics> {
  Repository _repository = Repository();
  String selectedFilter = 'Week';
  List<String> filters = ['Week', 'Month', 'Year', 'Custom'];
  List<dynamic> linkAndAmountData = [];
  int totalLinks = 0;
  int totalAmount = 0;
  List<dynamic> lData = [];
  double countAmount = 0;
  String initDate = '01-09-2021';
  DateTime _start = (DateTime.now())
      .subtract(Duration(days: DateTime.now().weekday - 1))
      .date;
  DateTime _end = (DateTime.now())
      // .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday))
      .date
      .add(Duration(hours: 23, minutes: 59, seconds: 59));

  ///Custom Filters Are ['Day','Date','Month','Year']
  String selectedCustomFilter = 'Day';
  bool isCountfound = false;
  bool _selectedQR = true;
  bool _selectedRevenue = false;
  // final List<charts.Series> seriesList;

  @override
  void initState() {
    isCountfound = widget.isSelected;
    print("abbafdfa");
    getlinkAndAmountData();
    super.initState();
  }

  Future<void> getlinkAndAmountData() async {
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
    linkAndAmountData = await _repository.queries.getCashbookData(_start, _end);
    debugPrint('link 2 amount : ' + linkAndAmountData.toString());
    countAmount = await _repository.queries.getTotalCashInHandFilterDate(
        _start,
        _end,
        Provider.of<BusinessProvider>(context, listen: false)
            .selectedBusiness
            .businessId);
    lData = linkAndAmountData.first;
    initDate = lData[0]['DAY'];
    if (mounted) setState(() {});
  }

  Future<void> thisWeek() async {
    _start = (DateTime.now())
        .subtract(Duration(days: DateTime.now().weekday + 0))
        .date;
    _end = (DateTime.now())
        // .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday))
        .date
        .add(Duration(hours: 23, minutes: 59, seconds: 59));
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
    linkAndAmountData = await _repository.queries.getCashbookData(_start, _end);
    debugPrint('link 2 amount : ' + linkAndAmountData.toString());
    countAmount = await _repository.queries.getTotalCashInHandFilterDate(
        _start,
        _end,
        Provider.of<BusinessProvider>(context, listen: false)
            .selectedBusiness
            .businessId);
    debugPrint('gg'+countAmount.toString());
    lData = linkAndAmountData.first;
    initDate = lData[0]['DAY'];
    if (mounted) setState(() {});
  }

  Future<void> thisYear() async {
    _start = DateTime(DateTime.now().year);
    _end = (DateTime.now())
        .date
        .add(Duration(hours: 23, minutes: 59, seconds: 59));
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
    linkAndAmountData =
        await _repository.queries.getCashbookDataForYears(_start, _end);
    countAmount = await _repository.queries.getTotalCashInHandFilterDate(
        _start,
        _end,
        Provider.of<BusinessProvider>(context, listen: false)
            .selectedBusiness
            .businessId);
    lData = linkAndAmountData.first;
    // initDate = lData[0]['DAY'];
    if (mounted) setState(() {});
  }

  Future<void> custom() async {
    if (_end.difference(_start).inDays <= 7) {
      if (_end.toIso8601String().substring(0, 4) !=
          _start.toIso8601String().substring(0, 4)) {
        selectedCustomFilter = 'Years';
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
        linkAndAmountData =
            await _repository.queries.getCashbookDataForMoreYears(_start, _end);
        countAmount = await _repository.queries.getTotalCashInHandFilterDate(
            _start,
            _end,
            Provider.of<BusinessProvider>(context, listen: false)
                .selectedBusiness
                .businessId);
        lData = linkAndAmountData.first;
        // initDate = lData[0]['DAY'];
        if (mounted) setState(() {});
        return;
      } else {
        selectedCustomFilter = 'Day';
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
        linkAndAmountData =
            await _repository.queries.getCashbookData(_start, _end);
        countAmount = await _repository.queries.getTotalCashInHandFilterDate(
            _start,
            _end,
            Provider.of<BusinessProvider>(context, listen: false)
                .selectedBusiness
                .businessId);
        lData = linkAndAmountData.first;
        initDate = lData[0]['DAY'];
        if (mounted) setState(() {});
        return;
      }
    } else if (_end.difference(_start).inDays <= 30) {
      if (_end.toIso8601String().substring(0, 4) !=
          _start.toIso8601String().substring(0, 4)) {
        selectedCustomFilter = 'Years';
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
        linkAndAmountData =
            await _repository.queries.getCashbookDataForMoreYears(_start, _end);
        countAmount = await _repository.queries.getTotalCashInHandFilterDate(
            _start,
            _end,
            Provider.of<BusinessProvider>(context, listen: false)
                .selectedBusiness
                .businessId);
        lData = linkAndAmountData.first;
        // initDate = lData[0]['DAY'];
        if (mounted) setState(() {});
        return;
      } else {
        selectedCustomFilter = 'Date';
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
        linkAndAmountData =
            await _repository.queries.getCashbookData(_start, _end);
        countAmount = await _repository.queries.getTotalCashInHandFilterDate(
            _start,
            _end,
            Provider.of<BusinessProvider>(context, listen: false)
                .selectedBusiness
                .businessId);
        lData = linkAndAmountData.first;
        initDate = lData[0]['DAY'];
        if (mounted) setState(() {});
        return;
      }
    } else if (_end.difference(_start).inDays <= 365) {
      if (_end.toIso8601String().substring(0, 4) !=
          _start.toIso8601String().substring(0, 4)) {
        selectedCustomFilter = 'Years';
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
        linkAndAmountData =
            await _repository.queries.getCashbookDataForMoreYears(_start, _end);
        countAmount = await _repository.queries.getTotalCashInHandFilterDate(
            _start,
            _end,
            Provider.of<BusinessProvider>(context, listen: false)
                .selectedBusiness
                .businessId);
        lData = linkAndAmountData.first;
        // initDate = lData[0]['DAY'];
        if (mounted) setState(() {});
        return;
      } else {
        selectedCustomFilter = 'Month';
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
        linkAndAmountData =
            await _repository.queries.getCashbookDataForYears(_start, _end);
        countAmount = await _repository.queries.getTotalCashInHandFilterDate(
            _start,
            _end,
            Provider.of<BusinessProvider>(context, listen: false)
                .selectedBusiness
                .businessId);
        lData = linkAndAmountData.first;
        // initDate = lData[0]['DAY'];
        if (mounted) setState(() {});
        return;
      }
    } else if (_end.difference(_start).inDays > 365) {
      selectedCustomFilter = 'Years';
      await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
      linkAndAmountData =
          await _repository.queries.getCashbookDataForMoreYears(_start, _end);
      countAmount = await _repository.queries.getTotalCashInHandFilterDate(
          _start,
          _end,
          Provider.of<BusinessProvider>(context, listen: false)
              .selectedBusiness
              .businessId);
      lData = linkAndAmountData.first;
      // initDate = lData[0]['DAY'];
      if (mounted) setState(() {});
      return;
    } else {
      selectedCustomFilter = 'Year';
      await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
      linkAndAmountData =
          await _repository.queries.getCashbookDataForYears(_start, _end);
      countAmount = await _repository.queries.getTotalCashInHandFilterDate(
          _start,
          _end,
          Provider.of<BusinessProvider>(context, listen: false)
              .selectedBusiness
              .businessId);
      lData = linkAndAmountData.first;
      // initDate = lData[0]['DAY'];
      if (mounted) setState(() {});
      return;
    }
  }

  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final mobileData = [
      new OrdinalSales('Jan', 5),
      new OrdinalSales('Feb', 25),
      new OrdinalSales('March', 100),
      new OrdinalSales('April', 75),
      new OrdinalSales('May', 75),
      new OrdinalSales('June', 75),
      new OrdinalSales('July', 75),
      new OrdinalSales('Aug', 75),
      new OrdinalSales('Sept', 75),
    ];

    final tabletData = [
      // Purposely missing data to show that only measures that are available
      // are vocalized.
      new OrdinalSales('Jan', 75),
      new OrdinalSales('March', 50),
      new OrdinalSales('April', 50),
      new OrdinalSales('May', 50),
      new OrdinalSales('June', 50),
      new OrdinalSales('July', 50),
      new OrdinalSales('Aug', 50),
      new OrdinalSales('Sept', 55),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Mobile Sales',
        colorFn: (_, __) => charts.Color.fromHex(code: '#2ED06D'),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileData,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet Sales',
        colorFn: (_, __) => charts.Color.fromHex(code: '#E94235'),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tabletData,
      )
    ];
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
                            'Cash IN and Cash OUT',
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
                                          setState(() {
                                            selectedFilter = newValue!;
                                            if (value.first != null)
                                              _start = value.first;
                                            if (value.last != null)
                                              _end = value.last;
                                          });
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
                          child: countAmount.toInt() > 0 ? Scrollbar(
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
                                        desiredTickCount: 11),
                                // viewport: charts.NumericExtents(0, 100)
                              ),
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
                                      DateFormat('dd').format(
                                          DateFormat('dd-MM-yyyy')
                                              .parse('$initDate')),
                                      7),
                                  showAxisLine: true),
                            ),
                          ):  isCountfound == true ? Image.asset(AppAssets.barChartIcon) : SizedBox(height: 0, width:0),),
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
                            Text('Cash IN'),
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
                            Text('Cash OUT'),
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
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05,
                              top: MediaQuery.of(context).size.width * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cash IN hand',
                                style: TextStyle(
                                    color: AppTheme.brownishGrey,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Image.asset(
                                AppAssets.amountIcon,
                                // color: AppTheme.electricBlue,
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Container(
                              margin: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.05,
                                  right:
                                      MediaQuery.of(context).size.width * 0.05,
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.05),
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
                                      count: countAmount.toInt(),
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
                SizedBox(
                  height: 5,
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

  List<charts.Series<LinkGenModel, String>> _createChartData() {
    List<LinkGenModel> data = [];
    List<LinkGenModel> data2 = [];
    if (selectedFilter == 'Month') {
      if (linkAndAmountData.length > 0) {
        if ((linkAndAmountData.first as List<dynamic>).length > 0) {
          final List<Map> _data = linkAndAmountData.first;
          data = _data
              .map((e) => LinkGenModel(
                  xDomain: DateFormat('dd').format(
                      DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
                  inAmount: e['INAMOUNT']))
              .toList();
          data2 = _data
              .map((e) => LinkGenModel(
                  xDomain: DateFormat('dd').format(
                      DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
                  outAmount: e['OUTAMOUNT']))
              .toList();
        }
      }
    } else if (selectedFilter == 'Week') {
      if (linkAndAmountData.length > 0) {
        if ((linkAndAmountData.first as List<dynamic>).length > 0) {
          final List<Map> _data = linkAndAmountData.first;
          data = _data
              .map((e) => LinkGenModel(
                  xDomain: DateFormat('EE').format(
                      DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
                  inAmount: e['INAMOUNT']))
              .toList();
          data2 = _data
              .map((e) => LinkGenModel(
                  xDomain: DateFormat('EE').format(
                      DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
                  outAmount: e['OUTAMOUNT']))
              .toList();
        }
      }
    } else if (selectedFilter == 'Year') {
      if (linkAndAmountData.length > 0) {
        if ((linkAndAmountData.first as List<dynamic>).length > 0) {
          final List<Map> _data = linkAndAmountData.first;
          data = _data
              .map((e) => LinkGenModel(
                  xDomain: DateFormat('MMM')
                      .format(DateFormat('MM-yyyy').parse(e['DAY'].toString())),
                  inAmount: e['INAMOUNT']))
              .toList();
          data2 = _data
              .map((e) => LinkGenModel(
                  xDomain: DateFormat('MMM')
                      .format(DateFormat('MM-yyyy').parse(e['DAY'].toString())),
                  outAmount: e['OUTAMOUNT']))
              .toList();
        }
      }
    } else {
      if (selectedCustomFilter == 'Day') {
        if (linkAndAmountData.length > 0) {
          if ((linkAndAmountData.first as List<dynamic>).length > 0) {
            final List<Map> _data = linkAndAmountData.first;
            data = _data
                .map((e) => LinkGenModel(
                    xDomain: DateFormat('dd').format(
                        DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
                    inAmount: e['INAMOUNT']))
                .toList();
            data2 = _data
                .map((e) => LinkGenModel(
                    xDomain: DateFormat('dd').format(
                        DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
                    outAmount: e['OUTAMOUNT']))
                .toList();
          }
        }
      } else if (selectedCustomFilter == 'Date') {
        if (linkAndAmountData.length > 0) {
          if ((linkAndAmountData.first as List<dynamic>).length > 0) {
            final List<Map> _data = linkAndAmountData.first;
            data = _data
                .map((e) => LinkGenModel(
                    xDomain: DateFormat('dd').format(
                        DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
                    inAmount: e['INAMOUNT']))
                .toList();
            data2 = _data
                .map((e) => LinkGenModel(
                    xDomain: DateFormat('dd').format(
                        DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
                    outAmount: e['OUTAMOUNT']))
                .toList();
          }
        }
      } else if (selectedCustomFilter == 'Month') {
        if (linkAndAmountData.length > 0) {
          if ((linkAndAmountData.first as List<dynamic>).length > 0) {
            final List<Map> _data = linkAndAmountData.first;
            data = _data
                .map((e) => LinkGenModel(
                    xDomain: DateFormat('MMM').format(
                        DateFormat('MM-yyyy').parse(e['DAY'].toString())),
                    inAmount: e['INAMOUNT']))
                .toList();
            data2 = _data
                .map((e) => LinkGenModel(
                    xDomain: DateFormat('MMM').format(
                        DateFormat('MM-yyyy').parse(e['DAY'].toString())),
                    outAmount: e['OUTAMOUNT']))
                .toList();
          }
        }
      } else if (selectedCustomFilter == 'Years') {
        if (linkAndAmountData.length > 0) {
          if ((linkAndAmountData.first as List<dynamic>).length > 0) {
            final List<Map> _data = linkAndAmountData.first;
            data = _data
                .map((e) => LinkGenModel(
                    xDomain: DateFormat('yyyy')
                        .format(DateFormat('yyyy').parse(e['DAY'].toString())),
                    inAmount: e['INAMOUNT']))
                .toList();
            data2 = _data
                .map((e) => LinkGenModel(
                    xDomain: DateFormat('yyyy')
                        .format(DateFormat('yyyy').parse(e['DAY'].toString())),
                    outAmount: e['OUTAMOUNT']))
                .toList();
          }
        }
      } else {
        if (linkAndAmountData.length > 0) {
          if ((linkAndAmountData.first as List<dynamic>).length > 0) {
            final List<Map> _data = linkAndAmountData.first;
            data = _data
                .map((e) => LinkGenModel(
                    xDomain: DateFormat('dd').format(
                        DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
                    inAmount: e['INAMOUNT']))
                .toList();
            data2 = _data
                .map((e) => LinkGenModel(
                    xDomain: DateFormat('dd').format(
                        DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
                    outAmount: e['OUTAMOUNT']))
                .toList();
          }
        }
      }
    }

    return [
      new charts.Series<LinkGenModel, String>(
        id: 'Mobile Sales',
        colorFn: (_, __) => charts.Color.fromHex(code: '#2ED06D'),
        domainFn: (LinkGenModel sales, _) => sales.xDomain,
        measureFn: (LinkGenModel sales, _) => sales.inAmount,
        data: data,
      ),
      new charts.Series<LinkGenModel, String>(
        id: 'Tablet Sales',
        colorFn: (_, __) => charts.Color.fromHex(code: '#E94235'),
        domainFn: (LinkGenModel sales, _) => sales.xDomain,
        measureFn: (LinkGenModel sales, _) => sales.outAmount,
        data: data2,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class LinkGenModel {
  final String xDomain;
  final int? inAmount;
  final int? outAmount;

  LinkGenModel({required this.xDomain, this.inAmount, this.outAmount});
}
