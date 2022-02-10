import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/AddBankAccount/add_bank_account.dart';
import 'package:urbanledger/screens/AddBankAccount/user_bank_account_provider.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/custom_popup.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/screens/Components/transaction_rows.dart';
import 'package:urbanledger/screens/TransactionScreens/pay_transaction.dart';

import '../../Utility/app_constants.dart';

class LedgerView extends StatefulWidget {
  final CustomerModel customerModel;
  final double? balanceAmount;

  final Function(double? amount, String? details, int? paymentType)?
      sendMessage;

  const LedgerView({
    Key? key,
    required this.balanceAmount,
    required this.sendMessage,
    required this.customerModel,
  }) : super(key: key);

  @override
  _LedgerViewState createState() => _LedgerViewState();
}

class _LedgerViewState extends State<LedgerView> {
  bool _buttonIsPressed = false;
  final GlobalKey<State> key = GlobalKey<State>();
  // List<TransactionModel> ledgerList = [];
  merchantBankNotAddedModalSheet({text}) {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          return Container(
            color: Color(0xFF737373), //could change this to Color(0xFF737373),

            height: MediaQuery.of(context).size.height * 0.27,
            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              //height: MediaQuery.of(context).size.height * 0.25,
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
                    child: Text(
                      '$text',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppTheme.brownishGrey,
                          fontFamily: 'SFProDisplay',
                          fontSize: 18,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  ),
                  Padding(
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
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: NewCustomButton(
                      onSubmit: () {
                        Navigator.pop(context);
                      },
                      textColor: Colors.white,
                      text: 'OKAY',
                      textSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    focus();
    // getKyc();
    // getRecentBankAcc();
  }

  focus() {}

  bool isNotAccount = false;
  getRecentBankAcc() async {
    if (mounted) {
      // setState(() {
      //   // isLoading = true;
      // });

      await Provider.of<UserBankAccountProvider>(context, listen: false)
          .getUserBankAccount();
      isNotAccount =
          Provider.of<UserBankAccountProvider>(context, listen: false)
              .isAccount;
      debugPrint(isNotAccount.toString());
      if (mounted) {
        // setState(() {
        //   // isLoading = false;
        // });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: bottomButtons(),
      body: Column(
        children: [
          SizedBox(
            height: 28,
          ),
          BlocBuilder<LedgerCubit, LedgerState>(
            builder: (context, state) {
              if (state is FetchingLedgerTransactions) {
                return Center(
                  child: CircularProgressIndicator(color: AppTheme.electricBlue,),
                );
              }
              if (state is FetchedLedgerTransactions) {
                // ledgerList = state.fullTransactionList;
                if (state.ledgerTransactionList.isEmpty) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Platform.isIOS
                          ? SizedBox(
                              height: 20,
                            )
                          : Container(),
                      Container(
                        padding: Platform.isIOS
                            ? EdgeInsets.symmetric(
                                horizontal: 40,
                              )
                            : EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                        child: Row(
                          children: [
                            Container(
                              width: screenWidth(context) * 0.43,
                              child: Text(
                                'Entries (0)',
                                style: TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              width: screenWidth(context) * 0.17,
                              alignment: Alignment.centerRight,
                              child: Text(
                                'You Gave',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              width: screenWidth(context) * 0.24,
                              alignment: Alignment.centerRight,
                              child: Text(
                                'You Got',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.0.heightBox,
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.08),
                        child: Image.asset(
                          AppAssets.emptyLedgerImage,
                          height: MediaQuery.of(context).size.height * 0.25,
                        ),
                      ),
                      Center(
                        child: CustomText(
                          'Add your first Ledger\n entry here',
                          color: AppTheme.brownishGrey,
                          size: 22,
                          centerAlign: true,
                          bold: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 62,
                        color: AppTheme.electricBlue,
                      )
                    ],
                  ).flexible;
                }
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: screenWidth(context) * 0.43,
                            child: Text(
                              'Entries (${state.ledgerTransactionList.length})',
                              style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: screenWidth(context) * 0.17,
                            alignment: Alignment.centerRight,
                            child: Text(
                              'You Gave',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: screenWidth(context) * 0.24,
                            alignment: Alignment.centerRight,
                            child: Text(
                              'You Got',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.0.heightBox,
                    LedgerList(
                      getBalance: (dateTime) => Future.delayed(
                          Duration(milliseconds: 500),
                          () => BlocProvider.of<LedgerCubit>(context)
                              .getBalanceOnDate(dateTime)),
                      ledgerTransactionList: state.ledgerTransactionList,
                      customerModel: widget.customerModel,
                      sendMessage: widget.sendMessage,
                    ),
                  ],
                ).flexible;
              }
              /*  if (state is SortedLedgerTransactions)
                return LedgerList(
                  ledgerTransactionList: state.ledgerTransactionList,
                  customerModel: widget.customerModel,
                  sendMessage: widget.sendMessage,
                ); */

              return Container();
            },
          ),
        ],
      ),
    );
  }

  bool isEmiratesIdDone = false;
  bool isTradeLicenseDone = false;
  bool status = false;
  bool isPremium = false;

  // modalSheet() {
  //   return showModalBottomSheet(
  //       context: context,
  //       isDismissible: true,
  //       enableDrag: true,
  //       builder: (context) {
  //         return Container(
  //           color: Color(0xFF737373), //could change this to Color(0xFF737373),
  //           height: (status == true)
  //               ? MediaQuery.of(context).size.height * 0.25
  //               : MediaQuery.of(context).size.height * 0.4,
  //           child: Container(
  //             decoration: new BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: new BorderRadius.only(
  //                     topLeft: const Radius.circular(10.0),
  //                     topRight: const Radius.circular(10.0))),
  //             //height: MediaQuery.of(context).size.height * 0.25,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Padding(
  //                   padding: const EdgeInsets.only(
  //                     top: 40.0,
  //                     left: 40.0,
  //                     right: 40.0,
  //                     bottom: 10,
  //                   ),
  //                   child: (status == true && isPremium == false)
  //                       ? Text(
  //                           'Please upgrade your Urban Ledger account in order to access this feature.',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               color: AppTheme.brownishGrey,
  //                               fontFamily: 'SFProDisplay',
  //                               fontSize: 18,
  //                               letterSpacing:
  //                                   0 /*percentages not used in flutter. defaulting to zero*/,
  //                               fontWeight: FontWeight.bold,
  //                               height: 1),
  //                         )
  //                       : Text(
  //                           (isEmiratesIdDone == true &&
  //                                   isTradeLicenseDone == true)
  //                               ? 'KYC verification is pending.\nPlease try after some time.'
  //                               : 'KYC is a mandatory step for\nPremium features.',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               color: Color.fromRGBO(233, 66, 53, 1),
  //                               fontFamily: 'SFProDisplay',
  //                               fontSize: 18,
  //                               letterSpacing:
  //                                   0 /*percentages not used in flutter. defaulting to zero*/,
  //                               fontWeight: FontWeight.normal,
  //                               height: 1),
  //                         ),
  //                 ),
  //                 if (status == false)
  //                   Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Container(
  //                               margin: EdgeInsets.symmetric(horizontal: 10),
  //                               child: Image.asset(
  //                                 'assets/icons/emiratesid.png',
  //                                 height: 35,
  //                               ),
  //                             ),
  //                             Text(
  //                               'Emirates ID',
  //                               style: TextStyle(
  //                                   color: Color(0xff666666),
  //                                   fontFamily: 'SFProDisplay',
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 17),
  //                             ),
  //                           ],
  //                         ),
  //                         isTradeLicenseDone == false
  //                             ? Icon(
  //                                 Icons.chevron_right,
  //                                 size: 32,
  //                                 color: Color(0xff666666),
  //                               )
  //                             : CircleAvatar(
  //                                 backgroundColor: Colors.green,
  //                                 radius: 20,
  //                                 child: Center(
  //                                   child: Icon(
  //                                     Icons.check,
  //                                     color: Colors.white,
  //                                   ),
  //                                 ),
  //                               )
  //                       ],
  //                     ),
  //                   ),
  //                 if (status == false)
  //                   Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Container(
  //                               margin: EdgeInsets.symmetric(horizontal: 10),
  //                               child: Image.asset(
  //                                 'assets/icons/tradelisc.png',
  //                                 height: 35,
  //                               ),
  //                             ),
  //                             Text(
  //                               'UAE Trade License',
  //                               style: TextStyle(
  //                                   color: Color(0xff666666),
  //                                   fontFamily: 'SFProDisplay',
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 17),
  //                             ),
  //                           ],
  //                         ),
  //                         isTradeLicenseDone == false
  //                             ? Icon(
  //                                 Icons.chevron_right,
  //                                 size: 32,
  //                                 color: Color(0xff666666),
  //                               )
  //                             : CircleAvatar(
  //                                 backgroundColor: Colors.green,
  //                                 radius: 20,
  //                                 child: Center(
  //                                   child: Icon(
  //                                     Icons.check,
  //                                     color: Colors.white,
  //                                   ),
  //                                 ),
  //                               )
  //                       ],
  //                     ),
  //                   ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(20.0),
  //                   child: (isEmiratesIdDone == true &&
  //                           isTradeLicenseDone == true)
  //                       ? NewCustomButton(
  //                           onSubmit: () {
  //                             Navigator.pop(context);
  //                           },
  //                           textColor: Colors.white,
  //                           text: 'OKAY',
  //                           textSize: 14,
  //                         )
  //                       : (isEmiratesIdDone == false &&
  //                               isTradeLicenseDone == false &&
  //                               isPremium == true)
  //                           ? Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.pop(context);
  //                                     },
  //                                     text: 'CANCEL',
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   width: 20,
  //                                 ),
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.popAndPushNamed(context,
  //                                           AppRoutes.urbanLedgerPremium);
  //                                     },
  //                                     text: 'Upgrade'.toUpperCase(),
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                               ],
  //                             )
  //                           : Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.pop(context);
  //                                     },
  //                                     text: 'CANCEL',
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   width: 20,
  //                                 ),
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.popAndPushNamed(
  //                                           context, AppRoutes.manageKyc3Route);
  //                                     },
  //                                     text: 'COMPLETE KYC',
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  // Future getKyc() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   await KycAPI.kycApiProvider.kycCheker().catchError((e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     'Please check your internet connection or try again later.'.showSnackBar(context);
  //   }).then((value) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   });
  //   calculatePremiumDate();
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  Widget bottomButtons() => SafeArea(
        child: Container(
          // color: Colors.white,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(
                    5.0,
                    5.0,
                  ),
                  blurRadius: 15.0,
                  spreadRadius: 1.0,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              )),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.06,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NewCustomButton(
                  onSubmit: () {
                    Navigator.of(context).pushNamed(AppRoutes.calculatorRoute,
                        arguments: CalculatorRouteArgs(
                          toTheCustomer: true,
                          paymentType: 1,
                          sendMessage: widget.sendMessage,
                          customerModel: widget.customerModel,
                        ));
                  },
                  text: 'YOU GAVE $currencyAED',
                  textColor: Colors.white,
                  backgroundColor: AppTheme.electricBlue,
                  textSize: 15.0,
                  fontWeight: FontWeight.bold,
                  // width: 185,
                  height: 40,
                ),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     primary: AppTheme.electricBlue,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(15)),
                //   ),
                //   onPressed: () {
                //     // print(widget.chatId);
                //     Navigator.of(context).pushNamed(AppRoutes.calculatorRoute,
                //         arguments: CalculatorRouteArgs(
                //             toTheCustomer: false,
                //             paymentType: 2,
                //             sendMessage: widget.sendMessage,
                //             customerModel: widget.customerModel));
                //   },
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(
                //         horizontal: MediaQuery.of(context).size.width * 0.03,
                //         vertical: MediaQuery.of(context).size.height * 0.013),
                //     child: Text(
                //       'YOU GOT $currencyAED',
                //       style: TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold,
                //           fontSize: 17),
                //     ),
                //   ),
                // ),
                NewCustomButton(
                  onSubmit: () {
                    Navigator.of(context).pushNamed(AppRoutes.calculatorRoute,
                        arguments: CalculatorRouteArgs(
                            toTheCustomer: false,
                            paymentType: 2,
                            sendMessage: widget.sendMessage,
                            customerModel: widget.customerModel));
                  },
                  text: 'YOU GOT $currencyAED',
                  textColor: Colors.white,
                  backgroundColor: AppTheme.electricBlue,
                  textSize: 15.0,
                  fontWeight: FontWeight.bold,
                  // width: 185,
                  height: 40,
                ),

                GestureDetector(
                  onTapDown: (val) {
                    displayModalBottomSheet(
                        context, widget.customerModel, widget.sendMessage);
                  },
                  child: Image.asset(
                    AppAssets.plusIcon,
                    height: 45,
                  ),
                  onTap: () {
                    setState(() {
                      _buttonIsPressed = !_buttonIsPressed;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      );

  void displayModalBottomSheet(
      BuildContext context, CustomerModel customerModel, sendMessage) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.12,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: Offset(0, -15), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8),
                  padding: EdgeInsets.only(bottom: 22.0),
                  child: Image.asset(
                    'assets/icons/handle.png',
                    scale: 1.5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: NewCustomButton(
                        onSubmit: () async {
                          Navigator.of(context).pop(true);
                          CustomLoadingDialog.showLoadingDialog(context, key);
                          var cid = await repository.customerApi
                              .getCustomerID(
                                  mobileNumber:
                                      widget.customerModel.mobileNo.toString())
                              .catchError((e) {
                            Navigator.of(context).pop();
                            'Please check internet connectivity and try again.'
                                .showSnackBar(context);
                          }).timeout(Duration(seconds: 30),
                                  onTimeout: () async {
                            Navigator.of(context).pop();
                            return Future.value(null);
                          });
                          // debugPrint(widget.contacts[index].mobileNo.toString());
                          // debugPrint(widget.contacts[index].name);
                          debugPrint(cid.customerInfo?.id.toString());
                          bool? merchantSubscriptionPlan =
                              cid.customerInfo?.merchantSubscriptionPlan ??
                                  false;
                          customerModel
                            ..ulId = cid.customerInfo?.id
                            ..name = getName(widget.customerModel.name,
                                widget.customerModel.mobileNo)
                            ..mobileNo = widget.customerModel.mobileNo;

                          if (cid.customerInfo?.id == null) {
                            Navigator.of(context).pop(true);

                            // userNotRegisteredDialog();
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return NonULDialog();
                            //   },
                            // );
                            MerchantBankNotAdded.showBankNotAddedDialog(
                                context, 'userNotRegistered');
                          }
                          // else if (Repository()
                          //         .hiveQueries
                          //         .userData
                          //         .kycStatus ==
                          //     0) {
                          //   Navigator.of(context).pop(true);
                          //   MerchantBankNotAdded.showBankNotAddedDialog(
                          //       context, 'userKYCPending');
                          // } else if (Repository()
                          //         .hiveQueries
                          //         .userData
                          //         .kycStatus ==
                          //     2) {
                          //   Navigator.of(context).pop(true);
                          //   await getKyc().then((value) =>
                          //       MerchantBankNotAdded.showBankNotAddedDialog(
                          //           context, 'userKYCVerificationPending'));
                          // }
                          else if (cid.customerInfo?.bankAccountStatus ==
                              false) {
                            Navigator.of(context).pop(true);

                            merchantBankNotAddedModalSheet(
                                text:
                                    Constants.merchentKYCBANKPREMNotadd);
                          } else if (cid.customerInfo?.kycStatus == false) {
                            Navigator.of(context).pop(true);
                            merchantBankNotAddedModalSheet(
                                text:
                                    Constants.merchentKYCBANKPREMNotadd);
                          }
                          //  else if (Repository()
                          //             .hiveQueries
                          //             .userData
                          //             .kycStatus ==
                          //         1 &&
                          //     Repository().hiveQueries.userData.premiumStatus ==
                          //         0) {
                          //   Navigator.of(context).pop(true);
                          //   debugPrint('Checket');
                          //   MerchantBankNotAdded.showBankNotAddedDialog(
                          //       context, 'upgradePremium');
                          // }
                          else if (merchantSubscriptionPlan == false) {
                            Navigator.of(context).pop();
                            merchantBankNotAddedModalSheet(
                                text:
                                    Constants.merchentKYCBANKPREMNotadd);
                          } else {
                            Map<String, dynamic> isTransaction =
                                await repository.paymentThroughQRApi
                                    .getTransactionLimit(context)
                                    .catchError((e) {
                              Navigator.of(context).pop();
                              'Please check internet connectivity and try again.'
                                  .showSnackBar(context);
                            });
                            if (!(isTransaction)['isError']) {
                              Navigator.of(context).pop(true);
                              // showBankAccountDialog();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PayTransactionScreen(
                                      model: customerModel,
                                      customerId: localCustomerId,
                                      type: 'DIRECT',
                                      suspense: false,
                                      through: 'DIRECT'),
                                ),
                              );
                            } else {
                              Navigator.of(context).pop(true);
                              '${(isTransaction)['message']}'
                                  .showSnackBar(context);
                            }
                          }
                        },
                        text: 'Pay'.toUpperCase(),
                        textColor: Colors.white,
                        backgroundColor: AppTheme.electricBlue,
                        textSize: 15.0,
                        fontWeight: FontWeight.bold,
                        // width: 185,
                        height: 40,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: NewCustomButton(
                        onSubmit: () async {
                          Navigator.of(context).pop(true);
                          if (await allChecker(context)) {
                              // Navigator.of(context).pop(true);
                              Navigator.of(context).pushNamed(
                                  AppRoutes.requestTransactionRoute,
                                  arguments: ReceiveTransactionArgs(
                                      customerModel, localCustomerId));
                            
                          }

                          // if (!isNotAccount == false) {
                          //   Navigator.of(context).pop(true);
                          //   showBankAccountDialog();
                          // } else if (status == false) {
                          //   Navigator.of(context).pop(true);
                          //   modalSheet();
                          // } else if (status == true && isPremium == false) {
                          //   Navigator.of(context).pop(true);
                          //   modalSheet();
                          // } else {
                          //   Navigator.of(context).pop(true);
                          //   Navigator.of(context).popAndPushNamed(
                          //       AppRoutes.requestTransactionRoute,
                          //       arguments: ReceiveTransactionArgs(
                          //           customerModel, localCustomerId));
                          //   // Navigator.push(
                          //   //   context,
                          //   //   MaterialPageRoute(
                          //   //     builder: (context) => ReceiveTransactionScreen(
                          //   //       model: customerModel,
                          //   //       customerId: localCustomerId,
                          //   //     ),
                          //   //   ),
                          //);
                          //}
                        },
                        text: 'Request'.toUpperCase(),
                        textColor: Colors.white,
                        backgroundColor: AppTheme.electricBlue,
                        textSize: 15.0,
                        fontWeight: FontWeight.bold,
                        // width: 185,
                        height: 40,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }

  showBankAccountDialog() async => await showDialog(
      builder: (context) => Dialog(
            insetPadding:
                EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.75),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 5),
                  child: CustomText(
                    "No Bank Account Found.",
                    color: AppTheme.tomato,
                    bold: FontWeight.w500,
                    size: 18,
                  ),
                ),
                CustomText(
                  'Please Add Your Bank Account.',
                  size: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                            color: AppTheme.electricBlue,
                            child: CustomText(
                              'Add Account'.toUpperCase(),
                              color: Colors.white,
                              size: (18),
                              bold: FontWeight.w500,
                            ),
                            onPressed: () {
                              Navigator.pop(context, true);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddBankAccount()));
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
                            color: AppTheme.electricBlue,
                            child: CustomText(
                              'Not now'.toUpperCase(),
                              color: Colors.white,
                              size: (18),
                              bold: FontWeight.w500,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
      barrierDismissible: false,
      context: context);

// showBankAccountNew2Dialog() async => await showDialog(
//       builder: (context) => Dialog(
//             backgroundColor: AppTheme.electricBlue,
//             insetPadding:
//                 EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.45),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical:10, horizontal:10),
//                   child: Image.asset(AppAssets.notregistered,width: MediaQuery.of(context).size.width * 0.5,),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 15.0, bottom: 5),
//                   child: CustomText(
//                     "User not registered with",
//                     color: Colors.white,
//                     bold: FontWeight.w500,
//                     size: 18,
//                   ),
//                 ),
//                 CustomText(
//                   'Urban Ledger App',
//                   color: Colors.white,
//                   bold: FontWeight.w500,
//                   size: 18,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical:8, horizontal: 16),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Expanded(
//                         child: Container(
//                           margin: EdgeInsets.symmetric(vertical: 10),
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           child: RaisedButton(
//                             padding: EdgeInsets.all(15),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             color: Color.fromRGBO(137, 172, 255, 1),
//                             child: CustomText(
//                               'Got it'.toUpperCase(),
//                               color: Colors.white,
//                               size: (18),
//                               bold: FontWeight.w500,
//                             ),
//                             onPressed: () {
//                               Navigator.pop(context, true);
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               AddBankAccount()));
//                             },
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(
//                           margin: EdgeInsets.symmetric(vertical: 10),
//                           padding: const EdgeInsets.symmetric(horizontal: 15),
//                           child: RaisedButton(
//                             padding: EdgeInsets.all(15),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             color: Color.fromRGBO(137, 172, 255, 1),
//                             child: CustomText(
//                               'invite'.toUpperCase(),
//                               color: Colors.white,
//                               size: (18),
//                               bold: FontWeight.w500,
//                             ),
//                             onPressed: () {
//                               Navigator.of(context).pop(true);
//                             },
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//       barrierDismissible: false,
//       context: context);

// showBankAccountNewDialog() async => await showDialog(
//       builder: (context) => Dialog(
//             backgroundColor: AppTheme.electricBlue,
//             insetPadding:
//                 EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.45),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical:10, horizontal:10),
//                   child: Image.asset(AppAssets.bankAccount,width: MediaQuery.of(context).size.width * 0.5,),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 15.0, bottom: 5),
//                   child: CustomText(
//                     "We have requested your merchant to",
//                     color: Colors.white,
//                     bold: FontWeight.w500,
//                     size: 18,
//                   ),
//                 ),
//                 CustomText(
//                   'add bank account. Please try again later.',
//                   color: Colors.white,
//                   bold: FontWeight.w500,
//                   size: 18,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical:8, horizontal: 16),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Expanded(
//                         child: Container(
//                           margin: EdgeInsets.symmetric(vertical: 10),
//                           padding: const EdgeInsets.symmetric(horizontal: 15),
//                           child: RaisedButton(
//                             padding: EdgeInsets.all(15),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             color: Color.fromRGBO(137, 172, 255, 1),
//                             child: CustomText(
//                               'invite'.toUpperCase(),
//                               color: Colors.white,
//                               size: (18),
//                               bold: FontWeight.w500,
//                             ),
//                             onPressed: () {
//                               Navigator.of(context).pop(true);
//                             },
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//       barrierDismissible: false,
//       context: context);
}

//   Widget buildBottomSheet() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.5),
//               offset: const Offset(
//                 5.0,
//                 5.0,
//               ),
//               blurRadius: 15.0,
//               spreadRadius: 1.0,
//             ),
//             BoxShadow(
//               color: Colors.white10,
//               offset: const Offset(0.0, 0.0),
//               blurRadius: 0.0,
//               spreadRadius: 0.0,
//             ),
//           ],
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(10),
//             topRight: Radius.circular(10),
//           )),
//       // color: Colors.white,
//       child: Column(
//         children: [
//           Container(
//             margin: EdgeInsets.symmetric(vertical: 10),
//             // padding: EdgeInsets.only(bottom: 8.0),
//             child: Image.asset(
//               'assets/icons/handle.png',
//               scale: 1.5,
//             ),
//           ),
//           Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: RaisedButton(
//                     color: AppTheme.electricBlue,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PayTransactionScreen(
//                             model: widget.customerModel,
//                             sendMessage: widget.sendMessage,
//                             // payMoney: payMoney,
//                           ),
//                         ),
//                       );
//                       // Navigator.pushNamed(context, AppRoutes.payTransactionRoute);
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: MediaQuery.of(context).size.width * 0.03,
//                           vertical: MediaQuery.of(context).size.height * 0.013),
//                       child: Text(
//                         'PAY',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 17),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 13,
//                 ),
//                 Expanded(
//                   child: RaisedButton(
//                     color: AppTheme.electricBlue,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ReceiveTransactionScreen(
//                             model: widget.customerModel,
//                             sendMessage: widget.sendMessage,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: MediaQuery.of(context).size.width * 0.03,
//                           vertical: MediaQuery.of(context).size.height * 0.013),
//                       child: Text(
//                         'REQUEST',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 17),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 55,
//                 ),
//               ]),
//         ],
//       ),
//     );
//   }
// }
