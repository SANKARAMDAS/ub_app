// import 'dart:math';

// import 'package:camera/camera.dart';
// import 'package:card_scanner_example/scan_option_configure_widget/scan_option_configure_widget.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:card_scanner/card_scanner.dart';

// import 'camera.dart';

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   CardDetails? _cardDetails;
//   CardScanOptions scanOptions = CardScanOptions(
//     scanCardHolderName: true,
//     // enableDebugLogs: true,
//     validCardsToScanBeforeFinishingScan: 5,
//     possibleCardHolderNamePositions: [
//       CardHolderNameScanPosition.aboveCardNumber,
//     ],
//   );

//   Future<void> scanCard() async {
//     var cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);
//     if (!mounted) return;
//     setState(() {
//       _cardDetails = cardDetails;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('card_scanner app'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Builder(
//                 builder: (context) {
//                   return RaisedButton(
//                     onPressed: () async {
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (cxt) => CameraExampleHome()));
//                     },
//                     child: Text('Camera'),
//                   );
//                 }
//               ),
//               RaisedButton(
//                 onPressed: () async {
//                   scanCard();
//                 },
//                 child: Text('scan card'),
//               ),
//               Text('$_cardDetails'),
//               Expanded(
//                 child: OptionConfigureWidget(
//                   initialOptions: scanOptions,
//                   onScanOptionChanged: (newOptions) => scanOptions = newOptions,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
