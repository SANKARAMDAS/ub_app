import 'package:flutter/material.dart';
import 'package:urbanledger/Card_module/constants/constanst.dart';

Size textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

final master = Image.asset(
  'assets/images/mastercard.png',
  width: 50,
);
final visa = Image.asset(
  'assets/images/visacard.png',
  width: 50,
);
final discover = Image.asset(
  'assets/images/discover.png',
  width: 50,
);

final amex = Image.asset(
  'assets/images/amex.png',
  width: 50,
);
final wifi = Image.asset(
  'assets/images/WifI-01.png',
  width: 30,
);
final sim = Image.asset(
  'assets/images/SIM Gold-01.png',
  width: 40,
);

final others = Container();

final Map<CardCompany, Set<List<String>>> cardNumPatterns =
    <CardCompany, Set<List<String>>>{
  CardCompany.VISA: <List<String>>{
    <String>['4'],
  },
  CardCompany.AMERICAN_EXPRESS: <List<String>>{
    <String>['34'],
    <String>['37'],
  },
  CardCompany.DISCOVER: <List<String>>{
    <String>['6011'],
    <String>['622126', '622925'],
    <String>['644', '649'],
    <String>['65']
  },
  CardCompany.MASTER: <List<String>>{
    <String>['51', '55'],
    <String>['2221', '2229'],
    <String>['223', '229'],
    <String>['23', '26'],
    <String>['270', '271'],
    <String>['2720'],
  },
};

CardCompany detectCardCompany(String cardNumber) {
  //Default card type is other
  CardCompany cardType = CardCompany.OTHER;

  if (cardNumber.isEmpty) {
    return cardType;
  }

  cardNumPatterns.forEach(
    (CardCompany type, Set<List<String>> patterns) {
      for (List<String> patternRange in patterns) {
        String ccPatternStr = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '').replaceAll('-', '');
        final int rangeLen = patternRange[0].length;
        if (rangeLen < cardNumber.length) {
          ccPatternStr = ccPatternStr.substring(0, rangeLen);
        }

        if (patternRange.length > 1) {
          // debugPrint('xxx: '+ccPatternStr);
          final int ccPrefixAsInt = int.parse(ccPatternStr);
          final int startPatternPrefixAsInt = int.parse(patternRange[0]);
          final int endPatternPrefixAsInt = int.parse(patternRange[1]);
          if (ccPrefixAsInt >= startPatternPrefixAsInt &&
              ccPrefixAsInt <= endPatternPrefixAsInt) {
            cardType = type;
            break;
          }
        } else {
          if (ccPatternStr == patternRange[0]) {
            cardType = type;
            break;
          }
        }
      }
    },
  );

  return cardType;
}
