import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/AddBankAccount/add_bank_account.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';

// class UserBankNotAdded {
//   static Future<void> showBankNotAddedDialog(
//       BuildContext context) async {
//     return showDialog(
//         builder: (context) => Dialog(
//               insetPadding: EdgeInsets.only(
//                   left: 20, right: 20, top: deviceHeight * 0.75),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 15.0, bottom: 5),
//                     child: CustomText(
//                       "No Bank Account Found.",
//                       color: AppTheme.tomato,
//                       bold: FontWeight.w500,
//                       size: 18,
//                     ),
//                   ),
//                   CustomText(
//                     'Please Add Your Bank Account.',
//                     size: 16,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Expanded(
//                           child: Container(
//                             margin: EdgeInsets.symmetric(vertical: 10),
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             child: RaisedButton(
//                               padding: EdgeInsets.all(15),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10)),
//                               color: AppTheme.electricBlue,
//                               child: CustomText(
//                                 'Add Account'.toUpperCase(),
//                                 color: Colors.white,
//                                 size: (18),
//                                 bold: FontWeight.w500,
//                               ),
//                               onPressed: () {
//                                 Navigator.pop(context, true);
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             AddBankAccount()));
//                               },
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(
//                             margin: EdgeInsets.symmetric(vertical: 10),
//                             padding: const EdgeInsets.symmetric(horizontal: 15),
//                             child: RaisedButton(
//                               padding: EdgeInsets.all(15),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10)),
//                               color: AppTheme.electricBlue,
//                               child: CustomText(
//                                 'Not now'.toUpperCase(),
//                                 color: Colors.white,
//                                 size: (18),
//                                 bold: FontWeight.w500,
//                               ),
//                               onPressed: () {
//                                 Navigator.of(context).pop(true);
//                               },
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//         barrierDismissible: false,
//         context: context);
//   }
// }

class MerchantBankNotAdded {
  bool merchantBankNotAdded = false;

  static Future<void> showBankNotAddedDialog(
      BuildContext context, String type) async {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          return Container(
            color: Color(0xFF737373), //could change this to Color(0xFF737373),
            // height: type == 'userNotRegistered' || type == 'userBankNotAdded'
            // ? MediaQuery.of(context).size.height * 0.20:
            // MediaQuery.of(context).size.height * 0.27,
            constraints: BoxConstraints(maxHeight: 500),
            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              // height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                      left: 40.0,
                      right: 40.0,
                      bottom: 10,
                    ),
                    child: Column(
                      children: [
                        (type == 'merchantBankNotAdded')
                            ? Text(
                                'This user hasn’t activated their Urban Ledger\naccount. Please contact the user for\nfurther clarification. ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppTheme.brownishGrey,
                                    fontFamily: 'SFProDisplay',
                                    fontSize: 18,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.bold,
                                    height: 1),
                              )
                            : (type == 'upgradePremium')
                                ? Text(
                                    'Please upgrade your Urban Ledger account\nin order to access this feature.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.brownishGrey,
                                        fontFamily: 'SFProDisplay',
                                        fontSize: 18,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.bold,
                                        height: 1),
                                  )
                                : type == 'userNotRegistered'
                                    ? Text(
                                        'The user is not registered with the Urban Ledger app.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppTheme.brownishGrey,
                                            fontFamily: 'SFProDisplay',
                                            fontSize: 18,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                      )
                                    : type == 'merchantKYCPending'
                                        ? Text(
                                            'This user hasn’t activated their Urban Ledger account. Please contact the user for further clarification. ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppTheme.brownishGrey,
                                                fontFamily: 'SFProDisplay',
                                                fontSize: 18,
                                                letterSpacing:
                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.bold,
                                                height: 1),
                                          )
                                        : type == 'userKYCPending' ||
                                                type == 'TradeLicensePending' ||
                                                type == 'EmiratesIdPending'
                                            ? Text(
                                                'KYC is a mandatory step for accessing premium features.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: AppTheme.tomato,
                                                    fontFamily: 'SFProDisplay',
                                                    fontSize: 18,
                                                    letterSpacing:
                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.2),
                                              )
                                            : type ==
                                                    'userKYCVerificationPending'
                                                ? Text(
                                                    'KYC verification is pending.',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: AppTheme
                                                            .brownishGrey,
                                                        fontFamily:
                                                            'SFProDisplay',
                                                        fontSize: 18,
                                                        letterSpacing:
                                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        height: 1.2),
                                                  )
                                                : type == 'userKYCTradePending'
                                                    ? Text(
                                                        'KYC verification is pending.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .brownishGrey,
                                                            fontFamily:
                                                                'SFProDisplay',
                                                            fontSize: 18,
                                                            letterSpacing:
                                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            height: 1.2),
                                                      )
                                                    : type == 'userKYCExpired'
                                                        ? Text(
                                                            'Your KYC has expired or rejected. Please submit your document again. ',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: AppTheme
                                                                    .brownishGrey,
                                                                fontFamily:
                                                                    'SFProDisplay',
                                                                fontSize: 18,
                                                                letterSpacing:
                                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                height: 1.2),
                                                          )
                                                        : type ==
                                                                'userBankNotAdded'
                                                            ? Text(
                                                                'No Bank Account Found.',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: AppTheme
                                                                        .tomato,
                                                                    fontFamily:
                                                                        'SFProDisplay',
                                                                    fontSize:
                                                                        18,
                                                                    letterSpacing:
                                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    height:
                                                                        1.2),
                                                              )
                                                            : Container(),
                      ],
                    ),
                  ),
                  type == 'userNotRegistered' ||
                          type == 'userKYCPending' ||
                          type == 'TradeLicensePending' ||
                          type == 'EmiratesIdPending' ||
                          type == 'userKYCExpired'
                      ? Container()
                      : type == 'userBankNotAdded'
                          ? CustomText(
                              'Please Add Your Bank Account.',
                              size: 16,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'Please try again later.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppTheme.tomato,
                                    fontFamily: 'SFProDisplay',
                                    fontSize: 18,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.w700,
                                    height: 1),
                              ),
                            ),
                  type == 'userKYCVerificationPending' ||
                          type == 'userKYCPending' ||
                          type == 'TradeLicensePending' ||
                          type == 'EmiratesIdPending'
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Image.asset(
                                      'assets/icons/emiratesid.png',
                                      height: 35,
                                    ),
                                  ),
                                  Text(
                                    'Emirates ID',
                                    style: TextStyle(
                                        color: Color(0xff666666),
                                        fontFamily: 'SFProDisplay',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                              type == 'userKYCPending' ||
                                      type == 'EmiratesIdPending'
                                  ? Container()
                                  : CircleAvatar(
                                      backgroundColor: Colors.green,
                                      radius: 20,
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        )
                      : Container(),
                  type == 'userKYCVerificationPending' ||
                          type == 'userKYCPending' ||
                          type == 'TradeLicensePending' ||
                          type == 'EmiratesIdPending'
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Image.asset(
                                      'assets/icons/tradelisc.png',
                                      height: 35,
                                    ),
                                  ),
                                  Text(
                                    'UAE Trade License',
                                    style: TextStyle(
                                        color: Color(0xff666666),
                                        fontFamily: 'SFProDisplay',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                              type == 'userKYCPending' ||
                                      type == 'TradeLicensePending' ||
                                      type == 'EmiratesIdPending'
                                  ? Container()
                                  : CircleAvatar(
                                      backgroundColor: Colors.green,
                                      radius: 20,
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 1,
                        child: NewCustomButton(
                          onSubmit: type == 'userBankNotAdded'
                              ? () {
                                  Navigator.pop(context, true);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddBankAccount()));
                                }
                              : type == 'userKYCPending' ||
                                      type == 'EmiratesIdPending' ||
                                      type == 'TradeLicensePending'
                                  ? () {
                                      Navigator.pop(context, true);
                                    }
                                  : type == 'upgradePremium'
                                      ? () {
                                          final GlobalKey<State> key =
                                              GlobalKey<State>();
                                          Navigator.of(context).pushNamed(
                                              AppRoutes
                                                  .urbanLedgerPremiumRoute);
                                          // CustomLoadingDialog.showLoadingDialog(
                                          //     context, key);
                                        }
                                      : type == 'userKYCExpired'
                                          ? () {
                                              Navigator.pushReplacementNamed(
                                                  context,
                                                  AppRoutes.manageKyc3Route);
                                            }
                                          : () {
                                              Navigator.pop(context, true);
                                            },
                          text: type == 'userBankNotAdded'
                              ? 'Add Account'.toUpperCase()
                              : type == 'userKYCPending' ||
                                      type == 'EmiratesIdPending' ||
                                      type == 'TradeLicensePending'
                                  ? 'Cancel'.toUpperCase()
                                  : type == 'upgradePremium'
                                      ? 'Upgrade Now'.toUpperCase()
                                      : type == 'userKYCExpired'
                                          ? 'Complete your KYC now'
                                          : 'Got it'.toUpperCase(),
                          textColor: Colors.white,
                          backgroundColor: AppTheme.electricBlue,
                          textSize: 15.0,
                          fontWeight: FontWeight.bold,
                          // width: 185,
                          // height: 40,
                        ),
                      ),
                      type == 'userNotRegistered' ||
                              type == 'userBankNotAdded' ||
                              type == 'userKYCPending' ||
                              type == 'EmiratesIdPending' ||
                              type == 'TradeLicensePending'
                          ? SizedBox(
                              width: 20,
                            )
                          : Container(),
                      type == 'userNotRegistered' ||
                              type == 'userBankNotAdded' ||
                              type == 'userKYCPending' ||
                              type == 'EmiratesIdPending' ||
                              type == 'TradeLicensePending'
                          ? Expanded(
                              flex: 1,
                              child: NewCustomButton(
                                onSubmit: type == 'userBankNotAdded'
                                    ? () {
                                        Navigator.of(context).pop();
                                      }
                                    : type == 'userKYCPending' ||
                                            type == 'EmiratesIdPending' ||
                                            type == 'TradeLicensePending'
                                        ? () {
                                            Navigator.popAndPushNamed(context,
                                                AppRoutes.manageKyc1Route);
                                          }
                                        : () async {
                                            Navigator.of(context).pop(true);
                                            final RenderBox box =
                                                context.findRenderObject()
                                                    as RenderBox;

                                            await Share.share(
                                                'Hey! I’m inviting you to use Urban Ledger (an amazing app to manage small businesses). It helps keep track of payables/receivables from our customers/suppliers. It also helps us collect payments digitally through unique payment links. https://bit.ly/app-store-link',
                                                subject:
                                                    'https://bit.ly/app-store-link',
                                                sharePositionOrigin:
                                                    box.localToGlobal(
                                                            Offset.zero) &
                                                        box.size);
                                          },
                                text: type == 'userBankNotAdded'
                                    ? 'Not now'.toUpperCase()
                                    : type == 'userKYCPending' ||
                                            type == 'EmiratesIdPending' ||
                                            type == 'TradeLicensePending'
                                        ? 'Complete KYC'.toUpperCase()
                                        : 'Invite'.toUpperCase(),
                                textColor: Colors.white,
                                backgroundColor: AppTheme.electricBlue,
                                textSize: 15.0,
                                fontWeight: FontWeight.bold,
                                // width: 185,
                                // height: 40,
                              ),
                            )
                          : Container(),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
