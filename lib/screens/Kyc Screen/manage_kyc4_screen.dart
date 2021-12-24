import 'package:flutter/material.dart';
import 'package:urbanledger/screens/Kyc%20Screen/scan_trade_lisc.dart';

class ManageKycScreen4 extends StatefulWidget {
  @override
  _ManageKycScreen4State createState() => _ManageKycScreen4State();
}

class _ManageKycScreen4State extends State<ManageKycScreen4> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      child: Icon(
                        Icons.chevron_left,
                        size: 30,
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                      height: 30,
                      child: Image.asset('assets/icons/progress.png'))
                ],
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Image.asset('assets/images/cardfront.png')),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Image.asset('assets/icons/loader.png')),
            SizedBox(
              height: 35,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Image.asset('assets/images/cardback.png')),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Image.asset('assets/icons/loader.png')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                    child: Image.asset(
                      'assets/icons/bin.png',
                      height: 55,
                    )),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScanTradeLisc()),
                    );
                  },
                  child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      child: Image.asset(
                        'assets/icons/tick.png',
                        height: 63,
                      )),
                ),
              ],
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                child: Image.asset(
                  'assets/icons/shield.png',
                  height: 18,
                )),
          ],
        ),
      ),
    );
  }
}
