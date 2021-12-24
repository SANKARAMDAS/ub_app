import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_theme.dart';

final kCardNumberTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Iceberg',
  fontWeight: FontWeight.normal,
  letterSpacing: 1.5,
  fontSize: 25,
);

final kCardDefaultTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Iceberg',
  fontSize: 25,
  letterSpacing: 1,
);

final kCVCTextStyle = TextStyle(
  color: AppTheme.greyish,
  fontFamily: 'Iceberg',
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

final kTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w700,
  color: Colors.white,
  fontFamily: 'Iceberg',
);

const kNametextStyle = TextStyle(
  fontSize: 15,
  color: Colors.white,
  fontFamily: 'Iceberg',
);

const kDefaultNameTextStyle = TextStyle(
  fontSize: 18,
  // fontWeight: FontWeight.w700,
  color: Colors.white,
  fontFamily: 'Iceberg',
);
const kHDefaultNameTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.grey,
  fontFamily: 'Iceberg',
);

const kValidtextStyle = TextStyle(
  fontSize: 18,
  letterSpacing: 2,
  color: Colors.white,
  fontFamily: 'Iceberg',
);

const kDefaultValidTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
  fontFamily: 'Iceberg',
);

const kSignTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.white,
  fontFamily: 'Iceberg',
);

const kDefaultButtonTextStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15);

const defaultNextPrevButtonDecoration = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(color: Colors.black54, blurRadius: 5.0, offset: Offset(0, 5))
  ],
  borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30),
      bottomLeft: Radius.circular(30),
      bottomRight: Radius.circular(30)),
  gradient: LinearGradient(
      colors: [
        const Color(0xff6c16c7),
        const Color(0xFFB16B92),
      ],
      begin: const FractionalOffset(0.0, 0.0),
      end: const FractionalOffset(1.0, 0.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp),
);

const defaultResetButtonDecoration = BoxDecoration(
  boxShadow: <BoxShadow>[
    BoxShadow(color: Colors.black54, blurRadius: 5.0, offset: Offset(0, 5))
  ],
  borderRadius: BorderRadius.all(Radius.circular(30)),
  gradient: LinearGradient(
      colors: [
        const Color(0xff6c16c7),
        const Color(0xFFB16B92),
      ],
      begin: const FractionalOffset(0.0, 0.0),
      end: const FractionalOffset(1.0, 0.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp),
);

const defaultCardDecoration = BoxDecoration(
    // boxShadow: <BoxShadow>[
    //   BoxShadow(color: Colors.black54, blurRadius: 15.0, offset: Offset(0, 8))
    // ],
    gradient: LinearGradient(
        colors: [
          Color(0xFF5335D6),
          Color(0xFFBE54FF),
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp),
    borderRadius: BorderRadius.all(Radius.circular(15)));

enum InputState { NUMBER, VALIDATE, CVV, NAME, DONE }

enum CardCompany { VISA, MASTER, AMERICAN_EXPRESS, DISCOVER, OTHER }
