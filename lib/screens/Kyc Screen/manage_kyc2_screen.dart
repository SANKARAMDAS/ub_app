// import 'package:flutter/material.dart';
// import 'package:urbanledger/screens/Components/custom_text_widget.dart';

// import 'manage_kyc3_screen.dart';

// class ManageKycScreen2 extends StatefulWidget {
//   @override
//   _ManageKycScreen2State createState() => _ManageKycScreen2State();
// }

// class _ManageKycScreen2State extends State<ManageKycScreen2> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Material(
//         child: Container(
//           margin: EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Icon(
//                     Icons.chevron_left,
//                     color: Color(0xff666666),
//                     size: 28,
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     // child: Text(
//                     //   'Skip',
//                     //   style: TextStyle(
//                     //       color: Color(0xff1058FF),
//                     //       fontFamily: 'SFProDisplay',
//                     //       fontWeight: FontWeight.w500,
//                     //       fontSize: 21),
//                     // ),
//                   ),
//                 ],
//               ),
//               Container(
//                   height: MediaQuery.of(context).size.height * 0.82,
//                   child: Image.asset("assets/images/kyc2.png")),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ManageKycScreen3()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.all(15),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                   ),
//                   child: CustomText('COMPLETE KYC'.toUpperCase(),
//                       color: Colors.white, size: 18, bold: FontWeight.w500),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
