import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';

class NonULDialog extends StatefulWidget {
  const NonULDialog({Key? key}) : super(key: key);

  @override
  NonULDialogState createState() => NonULDialogState();
}

class NonULDialogState extends State<NonULDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // backgroundColor: AppTheme.electricBlue,
      insetPadding:
          EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.70),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical:10, horizontal:10),
          //   child: Image.asset(AppAssets.notregistered,width: MediaQuery.of(context).size.width * 0.5,),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 5),
            child: CustomText(
              "The user is not registered with",
              color: AppTheme.tomato,
              bold: FontWeight.w500,
              size: 18,
            ),
          ),
          CustomText(
            'the Urban Ledger app.',
            color: AppTheme.brownishGrey,
            bold: FontWeight.w500,
            size: 18,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: RaisedButton(
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      // color: Color.fromRGBO(137, 172, 255, 1),
                      color: AppTheme.electricBlue,
                      child: CustomText(
                        'Got it'.toUpperCase(),
                        color: Colors.white,
                        size: (18),
                        bold: FontWeight.w500,
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: RaisedButton(
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      // color: Color.fromRGBO(137, 172, 255, 1),
                      color: AppTheme.electricBlue,
                      child: CustomText(
                        'invite'.toUpperCase(),
                        color: Colors.white,
                        size: (18),
                        bold: FontWeight.w500,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                        final RenderBox box =
                            context.findRenderObject() as RenderBox;

                        await Share.share(
                            'Hey! I’m inviting you to use Urban Ledger (an amazing app to manage small businesses). It helps keep track of payables/receivables from our customers/suppliers. It also helps us collect payments digitally through unique payment links. https://bit.ly/app-store-link',
                            subject: 'https://bit.ly/app-store-link',
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size);
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
