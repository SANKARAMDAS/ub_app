import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';

import '../../main.dart';
import 'custom_text_widget.dart';

class PayReceiveButtons extends StatelessWidget {
  final bool isCustomerEmpty;

  const PayReceiveButtons({required this.isCustomerEmpty});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<double>>(
        future: repository.queries.getTotalPayReceiveForCustomer(
            Provider.of<BusinessProvider>(context, listen: false)
                .selectedBusiness
                .businessId),
        builder: (context, snapshot) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(6, 5, 6, 0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: IntrinsicHeight(
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                    Expanded(
                      child: Container(
                        // width: size.width * 0.425,
                        // height: 95.r,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical:
                                MediaQuery.of(context).size.height * .015),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image.asset(
                            //   isCustomerEmpty
                            //       ? AppAssets.payIconDeactivated
                            //       : AppAssets.payIconActive,
                            //   height: 35,
                            // ),
                            // SizedBox(
                            //   width: 5,
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(text: '', children: [
                                      WidgetSpan(
                                        child: Image.asset(
                                          AppAssets.giveIcon,
                                          height: 18,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' You will Give',
                                        style: TextStyle(
                                          color: isCustomerEmpty
                                              ? AppTheme.greyish
                                              : AppTheme.brownishGrey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ])),
                                SizedBox(
                                  height: 5,
                                ),
                                RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      text: '$currencyAED ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: isCustomerEmpty
                                              ? AppTheme.greyish
                                              : AppTheme.tomato,
                                          fontWeight: FontWeight.w600),
                                      children: [
                                        TextSpan(
                                            text: isCustomerEmpty
                                                ? '0'
                                                : snapshot.data != null
                                                    ? (snapshot.data!.last)
                                                        .getFormattedCurrency
                                                        .replaceAll('-', '')
                                                    : '0',
                                            // text: '46151830',
                                            style: TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // (screenWidth(context) * 0.01).widthBox,
                    VerticalDivider(
                      color: AppTheme.brownishGrey,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Expanded(
                      child: Container(
                        // width: size.width * 0.425,
                        // height: 95.r,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical:
                                MediaQuery.of(context).size.height * .015),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image.asset(
                            //   isCustomerEmpty
                            //       ? AppAssets.receiveIconDeactivated
                            //       : AppAssets.receiveIconActive,
                            //   height: 55,
                            // ),
                            // SizedBox(
                            //   width: 5,
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // CustomText(
                                //   'You will Get',
                                //   color: isCustomerEmpty
                                //       ? AppTheme.greyish
                                //       : AppTheme.brownishGrey,
                                //   bold: FontWeight.w500,
                                //   size: 16,
                                // ),
                                RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(text: '', children: [
                                      WidgetSpan(
                                        child: Image.asset(
                                          AppAssets.getIcon,
                                          height: 18,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' You will Get',
                                        style: TextStyle(
                                          color: isCustomerEmpty
                                              ? AppTheme.greyish
                                              : AppTheme.brownishGrey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      )
                                    ])),
                                SizedBox(
                                  height: 5,
                                ),
                                RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      text: '$currencyAED ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: isCustomerEmpty
                                              ? AppTheme.greyish
                                              : AppTheme.greenColor,
                                          fontWeight: FontWeight.w600),
                                      children: [
                                        TextSpan(
                                            text: isCustomerEmpty
                                                ? '0'
                                                : snapshot.data != null
                                                    ? (snapshot.data!.first)
                                                        .getFormattedCurrency
                                                        .replaceAll('-', '')
                                                    : '0',
                                            // text: '46151830',
                                            style: TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ])),
            ),
          );
        });
  }
}
