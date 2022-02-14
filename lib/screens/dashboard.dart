import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import '../Utility/app_constants.dart';
import 'Components/custom_text_widget.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

final Color dark = AppTheme.electricBlue;
final Color normal = const Color(0xff89acff);
final Color light = const Color(0xffd6e2ff);
final Color barBackgroundColor = const Color(0xff72d8bf);
final Duration animDuration = const Duration(milliseconds: 250);
int? touchedIndex;

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      extendBodyBehindAppBar: true,
      // bottomNavigationBar: CustomBottomNavBar(),

      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage("assets/images/back2.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              ListTile(
                dense: true,
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 30,
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 22,
                        ),
                        color: Colors.white,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
                title: CustomText(
                  'View Analytics',
                  color: Colors.white,
                  size: 19,
                  bold: FontWeight.w500,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/settings.png',
                      height: 25,
                    ),
                    SizedBox(
                      width: 1,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Collections Pending this week',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            'assets/icons/down.png',
                            scale: 1.5,
                            color: Colors.white,
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: RichText(
                        text: TextSpan(
                            text: '$currencyAED ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(
                                  text: '10,567',
                                  style: TextStyle(
                                      fontSize: 36,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.22,
                child: Card(
                  shadowColor: Colors.grey.withOpacity(0.1),
                  elevation: 78,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.center,
                        barTouchData: BarTouchData(
                          enabled: false,
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) => const TextStyle(
                                color: Color(0xff939393), fontSize: 10),
                            margin: 10,
                            getTitles: (double value) {
                              switch (value.toInt()) {
                                case 0:
                                  return 'Apr';
                                case 1:
                                  return 'May';
                                case 2:
                                  return 'Jun';
                                case 3:
                                  return 'Jul';
                                case 10:
                                  return 'Aug';
                                default:
                                  return '';
                              }
                            },
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) => const TextStyle(
                                color: Color(
                                  0xff939393,
                                ),
                                fontSize: 10),
                            margin: 0,
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          checkToShowHorizontalLine: (value) => value % 0 == 0,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: const Color(0xffe7e8ec),
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        groupsSpace: 8,
                        barGroups: getData(),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Collections Pending this week',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                  'assets/icons/down.png',
                                  scale: 1.5,
                                  color: Colors.grey,
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: RichText(
                              text: TextSpan(
                                  text: '$currencyAED ',
                                  style: TextStyle(
                                      color: AppTheme.electricBlue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                  children: [
                                    TextSpan(
                                        text: '10,567',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: AppTheme.electricBlue,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text('VS',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400)),
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Payment received this week last month',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: RichText(
                              text: TextSpan(
                                  text: '$currencyAED ',
                                  style: TextStyle(
                                      color: Color(0xffd6e2ff),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                  children: [
                                    TextSpan(
                                        text: '10,567',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xffd6e2ff),
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            color: const Color(0xff81e5cd),
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text(
                                        'Mingguan',
                                        style: TextStyle(
                                            color: const Color(0xff0f4a3c),
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        'Grafik konsumsi kalori',
                                        style: TextStyle(
                                            color: const Color(0xff379982),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 38,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

List<BarChartGroupData> getData() {
  return [
    BarChartGroupData(
      x: 0,
      barsSpace: 10,
      barRods: [
        BarChartRodData(
            width: 15,
            y: 17000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 2000000000, dark),
              BarChartRodStackItem(2000000000, 12000000000, normal),
              BarChartRodStackItem(12000000000, 17000000000, light),
            ],
            borderRadius: const BorderRadius.all(Radius.zero)),
        BarChartRodData(
            width: 15,
            y: 24000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 13000000000, dark),
              BarChartRodStackItem(13000000000, 14000000000, normal),
              BarChartRodStackItem(14000000000, 24000000000, light),
            ],
            borderRadius: const BorderRadius.all(Radius.zero)),
        BarChartRodData(
            width: 15,
            y: 23000000000.10,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000.10, dark),
              BarChartRodStackItem(6000000000.10, 18000000000, normal),
              BarChartRodStackItem(18000000000, 23000000000.10, light),
            ],
            borderRadius: const BorderRadius.all(Radius.zero)),
        BarChartRodData(
            width: 15,
            y: 29000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 9000000000, dark),
              BarChartRodStackItem(9000000000, 15000000000, normal),
              BarChartRodStackItem(15000000000, 29000000000, light),
            ],
            borderRadius: const BorderRadius.all(Radius.zero)),
        BarChartRodData(
            width: 15,
            y: 32000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 2000000000.10, dark),
              BarChartRodStackItem(2000000000.10, 17000000000.10, normal),
              BarChartRodStackItem(17000000000.10, 32000000000, light),
            ],
            borderRadius: const BorderRadius.all(Radius.zero)),
      ],
    ),
    BarChartGroupData(
      x: 1,
      barsSpace: 10,
      barRods: [
        BarChartRodData(
            width: 15,
            y: 31000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 11000000000, dark),
              BarChartRodStackItem(11000000000, 18000000000, normal),
              BarChartRodStackItem(18000000000, 31000000000, light),
            ],
            borderRadius: const BorderRadius.all(Radius.zero)),
        BarChartRodData(
            width: 15,
            y: 35000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 14000000000, dark),
              BarChartRodStackItem(14000000000, 27000000000, normal),
              BarChartRodStackItem(27000000000, 35000000000, light),
            ],
            borderRadius: const BorderRadius.all(Radius.zero)),
        BarChartRodData(
            width: 15,
            y: 31000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 8000000000, dark),
              BarChartRodStackItem(8000000000, 24000000000, normal),
              BarChartRodStackItem(24000000000, 31000000000, light),
            ],
            borderRadius: const BorderRadius.all(Radius.zero)),
        BarChartRodData(
            width: 15,
            y: 15000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 6000000000.10, dark),
              BarChartRodStackItem(6000000000.10, 12000000000.10, normal),
              BarChartRodStackItem(12000000000.10, 15000000000, light),
            ],
            borderRadius: const BorderRadius.all(Radius.zero)),
        BarChartRodData(
            width: 15,
            y: 17000000000,
            rodStackItems: [
              BarChartRodStackItem(0, 9000000000, dark),
              BarChartRodStackItem(9000000000, 15000000000, normal),
              BarChartRodStackItem(15000000000, 17000000000, light),
            ],
            borderRadius: const BorderRadius.all(Radius.zero)),
      ],
    ),
  ];
}
