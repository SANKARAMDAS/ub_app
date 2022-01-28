import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_services.dart';

class CButton extends StatelessWidget {
  final Function? onPress;
  final String name;
  const CButton({Key? key, required this.onPress, required this.name})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.060,
          left: MediaQuery.of(context).size.width * 0.040,
          right: MediaQuery.of(context).size.width * 0.040),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(15),
          primary: AppTheme.electricBlue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () => onPress!(),
        child: Text(
          '$name'.toUpperCase(),
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
