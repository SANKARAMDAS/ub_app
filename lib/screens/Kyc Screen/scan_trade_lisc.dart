import 'package:flutter/material.dart';

import 'manage_kyc4_screen.dart';

class ScanTradeLisc extends StatefulWidget {
  @override
  _ScanTradeLiscState createState() => _ScanTradeLiscState();
}

class _ScanTradeLiscState extends State<ScanTradeLisc> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManageKycScreen4()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/scantradelisc.png',
                  ),
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
