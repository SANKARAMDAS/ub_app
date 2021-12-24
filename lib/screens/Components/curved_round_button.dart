import 'package:flutter/material.dart';

class CurvedRoundButton extends StatelessWidget {
  String? name;
  Color? color;
  Function? onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.020,
          left: MediaQuery.of(context).size.width * 0.040,
          right: MediaQuery.of(context).size.width * 0.040),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 19),
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: onPress as void Function()?,
        child: Text(
          '$name'.toUpperCase(),
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  CurvedRoundButton({this.name, this.color, this.onPress});
}

//
// Widget CurvedRoundButton({
//   BuildContext context,
//   String name,
//   Color color,
//   Function onPress,
// }) {
//   return Padding(
//     padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).size.height * 0.010,
//         left: MediaQuery.of(context).size.width * 0.040,
//         right: MediaQuery.of(context).size.width * 0.040),
//     child: RaisedButton(
//       padding: EdgeInsets.all(20),
//       color: color,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       onPressed: onPress,
//       child: Text(
//         '$name'.toUpperCase(),
//         style: TextStyle(
//             color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
//       ),
//     ),
//   );
// }
