import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';

import 'Components/extensions.dart';

class RequestMoneyOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 22,
            ),
          ),
        ),
        title: Text('Request Money'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Icon(Icons.add_box_outlined),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 7.5),
                child: OutlineButton.icon(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    onPressed: () {},
                    icon: Icon(Icons.backpack_outlined),
                    label: Text(
                      'SMS',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 7.5),
                child: OutlineButton.icon(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    onPressed: () {},
                    icon: Icon(Icons.backpack_outlined),
                    label: Text(
                      'Whatsapp',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            )
          ],
        ),
      ),
      body: Stack(children: [
        AppAssets.backgroundImage.background,
        0.45.backdrop,
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + appBarHeight,
          ),
          (deviceHeight * 0.03).heightBox,
          Row(
            children: [
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(45),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: Colors.green,
                      )),
                ),
              ),
              Flexible(
                flex: 5,
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Santosh Computer',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      '+91 9876543210',
                      style: TextStyle(color: Colors.white38),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: '$currencyAED ',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          children: [
                            TextSpan(
                                text: '9,400',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ]),
                    ),
                    Text(
                      'Receive',
                      style: TextStyle(color: Colors.white38),
                    )
                  ],
                ),
              )
            ],
          ),
          (deviceHeight * 0.05).heightBox,
          Center(
            child: Text(
              'Enter the Amount to send',
              style: TextStyle(color: Colors.white38),
            ),
          ),
          (deviceHeight * 0.04).heightBox,
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$currencyAED',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                VerticalDivider(
                  color: Colors.white,
                ),
                Text(
                  '0',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white38,
                  ),
                )
              ],
            ),
          ),
          (deviceHeight * 0.04).heightBox,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
            child: Text(
              'Request money through',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(
                unselectedWidgetColor: Theme.of(context).primaryColor),
            child: Flexible(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: Radio(
                            value: false,
                            groupValue: true,
                            onChanged: (dynamic value) {},
                            activeColor: Theme.of(context).primaryColor,
                            focusColor: Theme.of(context).primaryColor,
                          ),
                          title: Text('UPI Payments'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: Radio(
                            value: false,
                            groupValue: true,
                            onChanged: (dynamic value) {},
                            activeColor: Theme.of(context).primaryColor,
                            focusColor: Theme.of(context).primaryColor,
                          ),
                          title: Text('Credit/ Debit Card'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: Radio(
                            value: false,
                            groupValue: true,
                            onChanged: (dynamic value) {},
                            activeColor: Theme.of(context).primaryColor,
                            focusColor: Theme.of(context).primaryColor,
                          ),
                          title: Text('Wallet'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ])
      ]),
    );
  }
}
