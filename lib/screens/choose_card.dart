import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_routes.dart';

class ChooseCard extends StatefulWidget {
  @override
  _ChooseCardState createState() => _ChooseCardState();
}

bool isSwitched = false;
var textValue = 'Switch is OFF';

class _ChooseCardState extends State<ChooseCard> {
  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      debugPrint('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      debugPrint('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                color: Color(0xfff2f1f6),
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('assets/images/back.png'),
                    alignment: Alignment.topCenter)),
          ),
          Container(
            margin: EdgeInsets.only(top: 120),
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, i) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Card ending in 1598',
                                  style: TextStyle(
                                      color: Color(0xff666666), fontSize: 15),
                                ),
                              ],
                            ),
                            Image.asset(
                              'assets/icons/mastercard.png',
                              height: 55,
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Name',
                                  style: TextStyle(
                                      color: Color(0xff666666), fontSize: 15),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Santosh Verma',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Expiry',
                                  style: TextStyle(
                                      color: Color(0xff666666), fontSize: 15),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Aug, 2021',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        indent: 25,
                        endIndent: 25,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delete',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff1058FF)),
                            ),
                            CupertinoSwitch(
                              onChanged: toggleSwitch,
                              value: isSwitched,
                              activeColor: Color(0xff1058ff),

                              // activeTrackColor: Color(0xff1058ff),
                              // inactiveThumbColor: Color(0xff1058ff),
                              // inactiveTrackColor: Colors.white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
