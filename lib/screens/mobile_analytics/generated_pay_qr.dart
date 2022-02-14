import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';

class GeneratedPayQR extends StatefulWidget {
  final isSelected;
  const GeneratedPayQR({Key? key, this.isSelected,}) : super(key: key);

  @override
  _GeneratedPayQRState createState() => _GeneratedPayQRState();
}

class _GeneratedPayQRState extends State<GeneratedPayQR> {
  Repository _repository = Repository();
  String selectedFilter = 'Week';
  List<String> filters = ['Week', 'Month', 'Year', 'Custom'];
  List<dynamic> linkAndAmountData = [];
  int totalLinks = 0;
  int totalAmount = 0;
  List<dynamic> lData = [];
  Map<String, dynamic> countAmount = {};
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
  bool _selectedQR = true;
  bool _selectedRevenue = false;
   bool isCountfound = false;


  @override
  void initState() {
     isCountfound = widget.isSelected;
    print("abbQRGenerate");
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
    linkAndAmountData = await _repository.queries.getQRData(_start, _end);
    countAmount =
        await _repository.queries.getCountAndAmount('QRCODE', _start, _end);
    totalLinks = countAmount['COUNT'] ?? 0;
    totalAmount = countAmount['TOTAL'] ?? 0;
    lData = linkAndAmountData.first;
    initDate = lData[0]['DAY'];
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
    linkAndAmountData = await _repository.queries.getQRData(_start, _end);
    debugPrint('link 2 amount : ' + linkAndAmountData.toString());
    countAmount =
        await _repository.queries.getCountAndAmount('QRCODE', _start, _end);
    totalLinks = countAmount['COUNT'] ?? 0;
    totalAmount = countAmount['TOTAL'] ?? 0;
    lData = linkAndAmountData.first;
    initDate = lData[0]['DAY'];
    // debugPrint(lData[0]['DAY'].runtimeType.toString());
    // debugPrint('runnn :' + linkAndAmountData.first.runtimeType.toString());
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
        await _repository.queries.getQRCountForYears(_start, _end);
    countAmount =
        await _repository.queries.getCountAndAmount('QRCODE', _start, _end);
    totalLinks = countAmount['COUNT'] ?? 0;
    totalAmount = countAmount['TOTAL'] ?? 0;
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
            await _repository.queries.getQRCountForMoreYears(_start, _end);
        countAmount =
            await _repository.queries.getCountAndAmount('QRCODE', _start, _end);
        totalLinks = countAmount['COUNT'] ?? 0;
        totalAmount = countAmount['TOTAL'] ?? 0;
        lData = linkAndAmountData.first;
        // initDate = lData[0]['DAY'];
        if (mounted) setState(() {});
        return;
      } else {
        selectedCustomFilter = 'Day';
        linkAndAmountData = await _repository.queries.getQRData(_start, _end);
        countAmount =
            await _repository.queries.getCountAndAmount('QRCODE', _start, _end);
            await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
        totalLinks = countAmount['COUNT'] ?? 0;
        totalAmount = countAmount['TOTAL'] ?? 0;
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
            await _repository.queries.getQRCountForMoreYears(_start, _end);
        countAmount =
            await _repository.queries.getCountAndAmount('QRCODE', _start, _end);
        totalLinks = countAmount['COUNT'] ?? 0;
        totalAmount = countAmount['TOTAL'] ?? 0;
        lData = linkAndAmountData.first;
        // initDate = lData[0]['DAY'];
        if (mounted) setState(() {});
        return;
      } else {
        selectedCustomFilter = 'Date';
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
        linkAndAmountData = await _repository.queries.getQRData(_start, _end);
        countAmount =
            await _repository.queries.getCountAndAmount('QRCODE', _start, _end);
        totalLinks = countAmount['COUNT'] ?? 0;
        totalAmount = countAmount['TOTAL'] ?? 0;
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
            await _repository.queries.getQRCountForMoreYears(_start, _end);
        
        countAmount =
            await _repository.queries.getCountAndAmount('QRCODE', _start, _end);
        totalLinks = countAmount['COUNT'] ?? 0;
        totalAmount = countAmount['TOTAL'] ?? 0;
        lData = linkAndAmountData.first;
        // initDate = lData[0]['DAY'];
        if (mounted) setState(() {});
        return;
      } else {
        selectedCustomFilter = 'Month';
        await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
        linkAndAmountData = await _repository.queries.getQRDataMonthly(_start, _end);
        countAmount =
            await _repository.queries.getCountAndAmount('QRCODE', _start, _end);
            debugPrint('cc : '+linkAndAmountData.toString());
        totalLinks = countAmount['COUNT'] ?? 0;
        totalAmount = countAmount['TOTAL'] ?? 0;
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
          await _repository.queries.getQRCountForMoreYears(_start, _end);
      countAmount =
          await _repository.queries.getCountAndAmount('QRCODE', _start, _end);
      totalLinks = countAmount['COUNT'] ?? 0;
      totalAmount = countAmount['TOTAL'] ?? 0;
      lData = linkAndAmountData.first;
      // initDate = lData[0]['DAY'];
      if (mounted) setState(() {});
      return;
    } else {
      selectedCustomFilter = 'Year';
      await CustomSharedPreferences.setString('_startDate', _start.toIso8601String());
        await CustomSharedPreferences.setString('_endDate', _end.toIso8601String());
      linkAndAmountData = await _repository.queries.getQRDataMonthly(_start, _end);
      countAmount =
          await _repository.queries.getCountAndAmount('QRCODE', _start, _end);
      totalLinks = countAmount['COUNT'] ?? 0;
      totalAmount = countAmount['TOTAL'] ?? 0;
      lData = linkAndAmountData.first;
      // initDate = lData[0]['DAY'];
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
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.paleGrey,
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: NewCustomButton(
                              onSubmit: _selectedQR == false
                                  ? () {
                                      setState(() {
                                        _selectedQR = !_selectedQR;
                                      });
                                    }
                                  : () {},
                              prefixImage: _selectedQR == true
                                  ? AppAssets.activeLinkIcon
                                  : AppAssets.inactiveLinkIcon,
                              imageSize: 16,
                              text: ' QR Code',
                              textSize: 13,
                              textColor: AppTheme.brownishGrey,
                              backgroundColor: _selectedQR == true
                                  ? Colors.white
                                  : AppTheme.paleGrey,
                              height: 40,
                            )),
                            Expanded(
                                child: NewCustomButton(
                              onSubmit: _selectedQR == true
                                  ? () {
                                      setState(() {
                                        _selectedQR = !_selectedQR;
                                      });
                                    }
                                  : () {},
                              text: 'Revenue',
                              prefixImage: _selectedQR == false
                                  ? AppAssets.activeRevenueIcon
                                  : AppAssets.inactiveRevenueIcon,
                              imageSize: 25,
                              textSize: 13,
                              textColor: AppTheme.brownishGrey,
                              backgroundColor: _selectedQR == false
                                  ? Colors.white
                                  : AppTheme.paleGrey,
                              height: 40,
                            )),
                          ],
                        )),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'QR code generated Vs Revenue',
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
                        height: MediaQuery.of(context).size.height*0.3,
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: totalLinks > 0
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
                                  //         outsideLabelStyleSpec: charts.TextStyleSpec(
                                  //             color: charts.Color.fromHex(
                                  //                 code: '#7C4DFF'))),
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
                            : isCountfound == true ? Image.asset(AppAssets.barChartIcon) : SizedBox(height: 0, width:0),
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
                        Text(_selectedQR == true
                            ? 'QR code generated'
                            : 'Revenue'),
                      ],
                    )
                  ],
                )),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          totalLinks > 0
              ? Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Number of\nQR code\ngenerated',
                                      style: TextStyle(
                                          color: AppTheme.brownishGrey,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Image.asset(
                                      AppAssets.roundedQRIcon,
                                      // color: AppTheme.electricBlue,
                                      height: 40,
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Container(
                                    margin: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.02),
                                    // alignment: Alignment
                                    //     .centerLeft,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    alignment: Alignment.bottomLeft,
                                    // width:
                                    //     screenWidth(context) *
                                    //         0.480,
                                    // color: Colors.black,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: AnimatedCount(
                                        count: totalLinks,
                                        duration: Duration(seconds: 1),
                                        style: TextStyle(
                                            color: AppTheme.electricBlue,
                                            fontSize: 46,
                                            fontWeight: FontWeight.w900),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Revenue',
                                      style: TextStyle(
                                          color: AppTheme.brownishGrey,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Image.asset(
                                      AppAssets.revenueIcon,
                                      // color: AppTheme.electricBlue,
                                      height: 40,
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Container(
                                    margin: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.02),
                                    // alignment: Alignment
                                    //     .centerLeft,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    alignment: Alignment.bottomLeft,
                                    // width:
                                    //     screenWidth(context) *
                                    //         0.480,
                                    // color: Colors.black,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
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
                                            count: totalAmount,
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
    if (selectedFilter == 'Month') {
      if (linkAndAmountData.length > 0) {
        if ((linkAndAmountData.first as List<dynamic>).length > 0) {
          final List<Map> _data = linkAndAmountData.first;
          data = _data
              .map((e) => LinkGenModel(
                  xDomain: DateFormat('dd').format(
                      DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
                  linkCount:
                      _selectedQR == true ? e['COUNT'] : e['TOTALAMOUNT']))
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
                  linkCount:
                      _selectedQR == true ? e['COUNT'] : e['TOTALAMOUNT']))
              .toList();
        }
      }
    } else if (selectedFilter == 'Year') {
      if (linkAndAmountData.length > 0) {
        if ((linkAndAmountData.first as List<dynamic>).length > 0) {
          final List<Map> _data = linkAndAmountData.first;
          data = _data
              // .map((e) => LinkGenModel(
              //     xDomain: DateFormat('MMM').format(
              //         DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
              //     linkCount:
              //         _selectedLink == true ? e['COUNT'] : e['TOTALAMOUNT']))
              // .toList();
              .map((e) => LinkGenModel(
                  xDomain: DateFormat('MMM')
                      .format(DateFormat('MM-yyyy').parse(e['DAY'].toString())),
                  linkCount:
                      _selectedQR == true ? e['COUNT'] : e['TOTALAMOUNT']))
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
                    xDomain: DateFormat('EE').format(
                        DateFormat('dd-MM-yyyy').parse(e['DAY'].toString())),
                    linkCount:
                        _selectedQR == true ? e['COUNT'] : e['TOTALAMOUNT']))
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
                    linkCount:
                        _selectedQR == true ? e['COUNT'] : e['TOTALAMOUNT']))
                .toList();
          }
        }
      } else if (selectedCustomFilter == 'Month') {
        if (linkAndAmountData.length > 0) {
          if ((linkAndAmountData.first as List<dynamic>).length > 0) {
            final List<Map> _data = linkAndAmountData.first;
            // data = _data
            //     .map((e) => LinkGenModel(
            //         xDomain: DateFormat('MMM').format(DateTime(
            //             DateTime.now().year,
            //             DateTime.now().month,
            //             int.tryParse(e['MONTH'] ?? 1.toString()) ?? 1)),
            //         linkCount:
            //             _selectedLink == true ? e['COUNT'] : e['TOTALAMOUNT']))
            //     .toList();
            data = _data
                .map((e) => LinkGenModel(
                    xDomain: DateFormat('MMM').format(
                        DateFormat('MM-yyyy').parse(e['DAY'].toString())),
                    linkCount:
                        _selectedQR == true ? e['COUNT'] : e['TOTALAMOUNT']))
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
                    linkCount:
                        _selectedQR == true ? e['COUNT'] : e['TOTALAMOUNT']))
                .toList();
          }
        }
      } else {
        if (linkAndAmountData.length > 0) {
          if ((linkAndAmountData.first as List<dynamic>).length > 0) {
            final List<Map> _data = linkAndAmountData.first;
            data = _data
                .map((e) => LinkGenModel(
                    xDomain: DateFormat('MMM').format(
                        DateFormat('MM-yyyy').parse(e['DAY'].toString())),
                    linkCount:
                        _selectedQR == true ? e['COUNT'] : e['TOTALAMOUNT']))
                .toList();
          }
        }
      }
    }

    return [
      new charts.Series<LinkGenModel, String>(
          id: 'QR generated',
          colorFn: (_, __) => charts.Color.fromHex(code: '#7C4DFF'),
          domainFn: (LinkGenModel c, _) => c.xDomain,
          measureFn: (LinkGenModel c, _) => c.linkCount,
          data: data,
          labelAccessorFn: (LinkGenModel c, _) => '${c.linkCount.toString()}')
    ];
  }
}

class LinkGenModel {
  final String xDomain;
  final int? linkCount;
  final int? totalAmount;

  LinkGenModel({required this.xDomain, this.linkCount, this.totalAmount});
}
