import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/curved_round_button.dart';
import 'package:urbanledger/screens/Components/custom_button.dart';
import 'package:urbanledger/screens/main_screen.dart';

class RequestSentPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          // height: screenHeight(context) / 2,
          width: screenWidth(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppTheme.electricBlue,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                Image.asset('assets/images/pinclipart.png',
                    width: screenWidth(context) / 1.7),
                SizedBox(height: 10),
                Text(
                  'This user hasn’t activated their Urban Ledger\naccount. Please contact the user for\nfurther clarification. ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  child: MaterialButton(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    onPressed: () {
                      Navigator.of(context)
                          .popUntil((predicate) => predicate.isFirst);
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (context) => MainScreen()));
                    },
                    color: Color.fromRGBO(153, 204, 255, 1),
                    child: Center(
                      child: Text(
                        'OK, GOT IT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
