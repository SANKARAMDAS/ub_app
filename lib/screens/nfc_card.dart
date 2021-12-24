import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_theme.dart';

class NFCCard extends StatefulWidget {
  @override
  _NFCCardState createState() => _NFCCardState();
}

class _NFCCardState extends State<NFCCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      extendBody: true,
      body: Container(
        height: deviceHeight,
        alignment: Alignment.topCenter,
        // decoration: BoxDecoration(
        //   color: Color(0xfff2f1f6),
        //   image: DecorationImage(
        //     fit: BoxFit.scaleDown,
        //     image: AssetImage('assets/images/Card-01.png',),
        //    alignment: Alignment.topCenter
        //   )
        // ),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/Card-01.png',
                      width: MediaQuery.of(context).size.width * 0.6,
                      // fit: BoxFit,
                    ),
                  ),
                  appBar,
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Tap your Card at the back of this Phone',
                  style: TextStyle(color: AppTheme.brownishGrey),
                ),
              ),

              // appBar,
              SizedBox(height: 20),
              Image.asset('assets/images/NFC-03-01.png'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'AED ',
                    style: TextStyle(
                        fontSize: 36, color: Theme.of(context).primaryColor),
                  ),
                  Text(
                    '500',
                    style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Processing...',
                style: TextStyle(color: AppTheme.brownishGrey),
              ),
              // SizedBox(height: 30),
              Spacer(),
              Text(
                'All major Card Accepted',
                style: TextStyle(color: AppTheme.brownishGrey),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/mastercard.png',
                    width: 40,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    'assets/icons/Visa-01.png',
                    width: 40,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    'assets/icons/American_expresss-01.png',
                    width: 40,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    'assets/icons/Pay_Pal-01.png',
                    width: 40,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    'assets/icons/Mastero-01.png',
                    width: 40,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            ]),
      ),
    );
  }

  Widget get appBar => Container(
      margin: EdgeInsets.only(top: 40, left: 10),
      child: Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: Icon(Icons.close, color: Theme.of(context).primaryColor),
            onPressed: null,
          )));
}
