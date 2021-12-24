import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';

import 'package:urbanledger/screens/Components/custom_widgets.dart';

class PaymentDetails extends StatelessWidget {
  final String? urbanledgerId;
  final String? transactionId;
  final String? to;
  final String? toEmail;
  final String? from;
  final String? fromEmail;
  final String? completed;
  final String? paymentMethod;
  final String? amount;
  final String? customerName;
  final String? mobileNo;
  final String? cardImage;
  final String? endingWith;
  final int? paymentStatus;

  PaymentDetails(
      {this.urbanledgerId,
      this.transactionId,
      this.to,
      this.toEmail,
      this.from,
      this.fromEmail,
      this.completed,
      this.paymentMethod,
      this.amount,
      this.customerName,
      this.mobileNo,
      this.cardImage,
      this.endingWith,
      this.paymentStatus});

  final double height = deviceHeight - appBarHeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: deviceHeight * 0.31,
                  width: double.maxFinite,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: Color(0xfff2f1f6),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/back2.png'),
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
                SafeArea(
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 22,
                          ),
                          color: Colors.white,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        CircleAvatar(
                            radius: 20,
                            backgroundColor: AppTheme.carolinaBlue,
                            child: CustomText(
                              getInitials('$customerName', '$mobileNo')
                                  .toUpperCase(),
                              color: AppTheme.circularAvatarTextColor,
                              size: 24,
                            )),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              '$customerName',
                              color: Colors.white,
                              size: 18,
                              bold: FontWeight.w600,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                '+$mobileNo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    // actions: [
                    //   // Icon(
                    //   //   Icons.share,
                    //   //   color: Colors.white,
                    //   //   size: 30,
                    //   // ),
                    //   Image.asset(
                    //     AppAssets.shareIcon,
                    //     width: 26,
                    //   ),
                    //   SizedBox(
                    //     width: 20,
                    //   ),
                    // ],
                  ),
                ),
                //
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.12),
                      // Text(
                      //   'trip',
                      //   style: TextStyle(
                      //     color: Colors.white60,
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      Container(
                        height: height * 0.12,
                        width: screenWidth(context),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  // width:
                                  //     screenWidth(context) *
                                  //         0.475,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '$currencyAED',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                VerticalDivider(
                                  color: Colors.white,
                                  thickness: 2,
                                  indent: 1,
                                ),
                                Flexible(
                                  child: Container(
                                      // alignment: Alignment
                                      //     .centerLeft,
                                      height: height * 0.12,
                                      // width:
                                      //     screenWidth(context) *
                                      //         0.480,
                                      // color: Colors.black,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: CustomText(
                                          '$amount',
                                          bold: FontWeight.w700,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      )),
                                ),
                              ]),
                        ),
                      ),
                      Text(
                        'To $to',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ]),
                (height * 0.019).heightBox,
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 25, left: 20, right: 20),
              // padding: ,
              decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.coolGrey, width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 10),
                    child: ListTile(
                      dense: true,
                      leading: Image.network(
                        '$cardImage',
                      ),
                      title: Text('$endingWith'.toUpperCase()),
                    ),
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.only(left: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('UL Transaction ID'),
                        Text('$urbanledgerId'.toLowerCase()),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.only(left: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payment Transaction ID'),
                        Text('$transactionId'.toLowerCase()),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.only(left: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('To: $to'),
                        Text('$toEmail'),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.only(left: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('From: $from'),
                        Text('$fromEmail'),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.only(left: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              paymentStatus == 0 ? 'Transaction Failed': 'Transaction Successful',
                            ),
                            SizedBox(width: 5),
                            Image.asset(
                                paymentStatus == 0
                                    ? AppAssets.transactionFailed
                                    : AppAssets.transactionSuccess,
                                height: 15,
                              )
                          ],
                        ),
                        Text(DateFormat("E, d MMM y hh:mm a")
                            .format(DateTime.parse(completed!))
                            .toString()),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    margin: EdgeInsets.only(left: 25, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payment Method'),
                        Text('$paymentMethod'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
