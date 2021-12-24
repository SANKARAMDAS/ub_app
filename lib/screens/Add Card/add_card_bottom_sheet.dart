import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Add%20Card/add_card_screen.dart';
import 'package:urbanledger/screens/Add Card/Scan Card/scan_details.dart';

class AddCardBottomSheet extends StatefulWidget {
  @override
  _AddCardBottomSheetState createState() => _AddCardBottomSheetState();
}

class _AddCardBottomSheetState extends State<AddCardBottomSheet> {
  bool scanCard = false;
  bool nfc = false;
  bool fillEntry = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        // height: screenHeight(context) / 2,
        width: screenWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 25),
            Image.asset('assets/images/card.png'),
            SizedBox(height: 15),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              width: screenWidth(context),
              child: Text(
                'Choose your options for\nadd a new card.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Row(children: [
                Expanded(
                  child: Material(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          // focusColor: Colors.amber,
                          // hoverColor: Colors.amber,
                          splashColor: AppTheme.electricBlue,
                          // highlightColor: Colors.amber,
                          onTap: () {
                            print('onTap');
                            setState(() {
                              scanCard = !scanCard;
                              nfc = false;
                              fillEntry = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScanCardDetails(
                                    cardNumber: '4564567890123456',
                                    cardName: 'John Mathew',
                                    cardValid: '06/24',
                                  ),
                                ));
                          },
                          child: buildCustomButton('Scan Card', scanCard)),
                    ),
                  ),
                ),
                Expanded(
                  child: Material(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          // focusColor: Colors.amber,
                          // hoverColor: Colors.amber,
                          splashColor: AppTheme.electricBlue,
                          // highlightColor: Colors.amber,
                          onTap: () {
                            print('onTap');
                            setState(() {
                              nfc = !nfc;
                              fillEntry = false;
                              scanCard = false;
                            });
                          },
                          child: buildCustomButton('NFC', nfc)),
                    ),
                  ),
                ),
                Expanded(
                  child: Material(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          // focusColor: Colors.amber,
                          // hoverColor: Colors.amber,
                          splashColor: AppTheme.electricBlue,
                          // highlightColor: Colors.amber,
                          onTap: () {
                            print('onTap');
                            setState(() {
                              fillEntry = !fillEntry;
                              scanCard = false;
                              nfc = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddCardScreen(),
                                ));
                          },
                          child: buildCustomButton('Fill Entry', fillEntry)),
                    ),
                  ),
                ),
                // buildCustomButton('NFC', nfc),
                // buildCustomButton('Fill Entry', fillEntry),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCustomButton(String text, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.electricBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black54, width: 0.5),
      ),
      child: Center(
          child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black54),
      )),
    );
  }
}
