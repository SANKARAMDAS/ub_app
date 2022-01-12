import 'package:flutter/material.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/extensions.dart';

class CustomAllCheckers extends StatefulWidget {
  const CustomAllCheckers({ Key? key }) : super(key: key);

  @override
  _CustomAllCheckersState createState() => _CustomAllCheckersState();
}

class _CustomAllCheckersState extends State<CustomAllCheckers> {
  bool isLoading = false;

  Future getKyc() async {
    setState(() {
      isLoading = true;
    });
    await KycAPI.kycApiProvider.kycCheker().catchError((e) {
      // Navigator.of(context).pop();
      setState(() {
        isLoading = false;
      });
      'Please check your internet connection or try again later.'.showSnackBar(context);
    }).then((value) {
      setState(() {
        isLoading = false;
      });
    });
    calculatePremiumDate();
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}