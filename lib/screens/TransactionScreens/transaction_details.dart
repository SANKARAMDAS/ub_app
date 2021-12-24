import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_bottom_nav_bar.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/extensions.dart';

import '../../Utility/app_constants.dart';

class TransactionDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: CustomBottomNavBar(),
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
              (MediaQuery.of(context).padding.top).heightBox,
              ListTile(
                dense: true,
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.customerProfileRoute);
                },
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
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xff666666),
                      backgroundImage: NetworkImage(
                          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                    ),
                  ],
                ),
                title: CustomText(
                  'User',
                  color: Colors.white,
                  size: 19,
                  bold: FontWeight.w500,
                ),
                subtitle: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.customerProfileRoute);
                  },
                  child: Text(
                    'Click to view setting',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
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
                            'Receive',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            'assets/icons/in.png',
                            scale: 1.2,
                            color: Colors.white,
                            height: 19,
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
                                  text: '4,567',
                                  style: TextStyle(
                                      fontSize: 36,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ]),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                                text: 'Collect money on ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                      text: 'Tue, 22 Jan 2021',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 2,
                margin: EdgeInsets.only(top: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AppRoutes.reportRoute);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/pdf.png',
                              scale: 1.5,
                              height: 45,
                            ),
                            Text(
                              'Report',
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/Payment.png',
                            scale: 1.5,
                            height: 45,
                          ),
                          Text(
                            'Payment',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/whatsapp.png',
                            scale: 1.5,
                            height: 45,
                          ),
                          Text(
                            'Reminder',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/chat.png',
                            scale: 1.5,
                            height: 45,
                          ),
                          Text(
                            'SMS',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: screenWidth(context) * 0.43,
                      child: Text(
                        'Entries',
                        style: TextStyle(
                            color: Color(0xff666666),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: screenWidth(context) * 0.15,
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Paid',
                        style: TextStyle(
                            color: Color(0xff666666),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: screenWidth(context) * 0.25,
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Received',
                        style: TextStyle(
                            color: Color(0xff666666),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              10.0.heightBox,
              Flexible(
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 6,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, AppRoutes.attachBillRoute);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Card(
                                margin: EdgeInsets.only(
                                  bottom: 1,
                                  top: 1,
                                ),
                                child: Container(
                                  width: screenWidth(context) * 0.39,
                                  height: screenHeight(context) * 0.12,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, left: 15, right: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Payment',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            bottom: 4,
                                            top: 4,
                                            right: 2,
                                          ),
                                          child: RichText(
                                            text: TextSpan(
                                                text: 'Bal. ',
                                                style: TextStyle(
                                                    color: Color(0xff666666),
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                children: [
                                                  TextSpan(
                                                      text: '$currencyAED ',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: index % 2 != 0
                                                              ? AppTheme.tomato
                                                              : Color(
                                                                  0xff2ed06d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  TextSpan(
                                                      text: '4,567',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: index % 2 != 0
                                                              ? AppTheme.tomato
                                                              : Color(
                                                                  0xff2ed06d),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ]),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 0),
                                          child: RichText(
                                            text: TextSpan(
                                              text: '27 May 2021 | 5:28PM',
                                              style: TextStyle(
                                                color: Color(0xff666666),
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                margin: EdgeInsets.only(
                                    bottom: 2, top: 2, right: 1),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  height: screenHeight(context) * 0.12,
                                  width: screenWidth(context) * 0.26,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0,
                                        right: 15,
                                        bottom: 15,
                                        left: 15),
                                    child: Text(
                                      index % 2 != 0 ? '-$currencyAED 365' : "",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                margin: EdgeInsets.only(
                                  bottom: 2,
                                  top: 2,
                                ),
                                child: Container(
                                  width: screenWidth(context) * 0.26,
                                  height: screenHeight(context) * 0.12,
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0,
                                        right: 15,
                                        bottom: 15,
                                        left: 15),
                                    child: Text(
                                      index % 2 == 0 ? '+$currencyAED 365' : "",
                                      style: TextStyle(
                                          color: Color(0xff2ed06d),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ],
      ),
    );
  }
}
