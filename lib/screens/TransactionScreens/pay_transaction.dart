import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
import 'package:urbanledger/Models/add_card_model.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/startOrderSession_model.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/APIs/payment_through_card.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/chat_module/screens/contact/payment_controller.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/screens/Add%20Card/add_card_screen.dart';
import 'package:urbanledger/screens/Components/Custom_Amount_Filler.dart';
import 'package:urbanledger/screens/Components/curved_round_button.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/screens/TransactionScreens/add_cards_provider.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import 'package:urbanledger/screens/payment_done.dart';
import 'package:urbanledger/screens/transaction_failed.dart';
import 'package:uuid/uuid.dart';

class PayTransactionScreen extends StatefulWidget {
  final CustomerModel? model;

  // final QRModel? qrModel;
  final String customerId;
  final String? fName;
  final String? lName;
  final String? amount;
  final String? note;
  final String? mobileNo;
  final String? currency;
  final String type;
  final String through;
  final bool suspense;
  final String? requestId;

  PayTransactionScreen(
      {this.model,
      required this.customerId,
      this.fName,
      this.lName,
      this.mobileNo,
      this.amount,
      this.currency,
      this.note,
      required this.type,
      required this.through,
      required this.suspense,
      this.requestId});

  @override
  _PayTransactionScreenState createState() => _PayTransactionScreenState();
}

class _PayTransactionScreenState extends State<PayTransactionScreen> {
  final TextEditingController _enterDetailsController = TextEditingController();
  bool isTapandpay = false;
  bool isCard = true;
  bool isAmountFilled = false;
  String? _id;
  late PaymentController _paymentController;
  final GlobalKey<State> key = GlobalKey<State>();
  TextEditingController currController = new TextEditingController();
  bool status = false;
  bool loading = true;
  final repository = Repository();
  late String business_id =
      Provider.of<BusinessProvider>(context, listen: false)
          .selectedBusiness
          .businessId
          .toString();

  @override
  void initState() {
    getCar();
    super.initState();
    _paymentController = PaymentController(
      context: context,
    );
    getKyc();
    calculatePremiumDate();
    debugPrint('dd : kycStatus:  ' +
        Repository().hiveQueries.userData.kycStatus.toString());
    debugPrint('dd : isEmiratesIdDone:  ' +
        Repository().hiveQueries.userData.isEmiratesIdDone.toString());
    debugPrint('dd : isTradeLicenseDone:  ' +
        Repository().hiveQueries.userData.isTradeLicenseDone.toString());
    debugPrint('dd : kycExpDate:  ' +
        Repository().hiveQueries.userData.kycExpDate.toString());
    debugPrint('dd : kycStatus:  ' +
        Repository().hiveQueries.userData.kycStatus.toString());
    debugPrint('dd : premiumStatus:  ' +
        Repository().hiveQueries.userData.premiumStatus.toString());
    if (widget.amount != null) {
      currController.text = widget.amount!.replaceAll('-', '').toString();
      debugPrint('Check :' + isAmountFilled.toString());
    }
    startOrderSession();
  }

  bool isEmiratesIdDone = false;
  bool isTradeLicenseDone = false;
  bool isPremium = false;
  bool isSessionExpire = false;
  StartOrderSessionModel? OSession;
  modalSheet() {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          return Container(
            color: Color(0xFF737373), //could change this to Color(0xFF737373),
            height: (isEmiratesIdDone == false &&
                    isTradeLicenseDone == false &&
                    isPremium == true)
                ? MediaQuery.of(context).size.height * 0.3
                : MediaQuery.of(context).size.height * 0.4,
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
                    child: (isEmiratesIdDone == false &&
                            isTradeLicenseDone == false &&
                            isPremium == true)
                        ? Text(
                            'Please upgrade your Urban Ledger account in order to access this feature.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(233, 66, 53, 1),
                                fontFamily: 'SFProDisplay',
                                fontSize: 18,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          )
                        : Text(
                            (isEmiratesIdDone == true &&
                                    isTradeLicenseDone == true)
                                ? 'KYC verification is pending.\nPlease try after some time.'
                                : 'KYC is a mandatory step for\nPremium features.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(233, 66, 53, 1),
                                fontFamily: 'SFProDisplay',
                                fontSize: 18,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                  ),
                  if (isPremium == false)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
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
                          isTradeLicenseDone == false
                              ? Icon(
                                  Icons.chevron_right,
                                  size: 32,
                                  color: Color(0xff666666),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.green,
                                  radius: 20,
                                  child: Center(
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  if (isPremium == false)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
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
                          isTradeLicenseDone == false
                              ? Icon(
                                  Icons.chevron_right,
                                  size: 32,
                                  color: Color(0xff666666),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.green,
                                  radius: 20,
                                  child: Center(
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: (isEmiratesIdDone == true &&
                            isTradeLicenseDone == true)
                        ? NewCustomButton(
                            onSubmit: () {
                              Navigator.pop(context);
                            },
                            textColor: Colors.white,
                            text: 'OKAY',
                            textSize: 14,
                          )
                        : (isEmiratesIdDone == false &&
                                isTradeLicenseDone == false &&
                                isPremium == true)
                            ? Row(
                                children: [
                                  Expanded(
                                    child: NewCustomButton(
                                      onSubmit: () {
                                        Navigator.pop(context);
                                      },
                                      text: 'CANCEL',
                                      textColor: Colors.white,
                                      textSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: NewCustomButton(
                                      onSubmit: () {
                                        Navigator.popAndPushNamed(context,
                                            AppRoutes.urbanLedgerPremium);
                                      },
                                      text: 'Upgrade'.toUpperCase(),
                                      textColor: Colors.white,
                                      textSize: 14,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: NewCustomButton(
                                      onSubmit: () {
                                        Navigator.pop(context);
                                      },
                                      text: 'CANCEL',
                                      textColor: Colors.white,
                                      textSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: NewCustomButton(
                                      onSubmit: () {
                                        Navigator.popAndPushNamed(
                                            context, AppRoutes.manageKyc3Route);
                                      },
                                      text: 'COMPLETE KYC',
                                      textColor: Colors.white,
                                      textSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getKyc() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    await KycAPI.kycApiProvider.kycCheker().catchError((e) {
      // Navigator.of(context).pop();
      setState(() {
        isLoading = false;
      });
      'Something went wrong. Please try again later.'.showSnackBar(context);
    }).then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      // debugPrint('Check the value : ' + value['status'].toString());

      if (value != null && value.toString().isNotEmpty) {
        if (mounted) {
          setState(() {
            Repository().hiveQueries.insertUserData(Repository()
                .hiveQueries
                .userData
                .copyWith(
                    kycStatus:
                        (value['isVerified'] == true && value['status'] == true)
                            ? 1
                            : (value['emirates'] &&
                                    value['tl'] == true &&
                                    value['status'] == false)
                                ? 2
                                : 0,
                    premiumStatus:
                        value['planDuration'].toString() == 0.toString()
                            ? 0
                            : int.tryParse(value['planDuration']),
                    isEmiratesIdDone: value['emirates'] ?? false,
                    isTradeLicenseDone: value['tl'] ?? false));

            //TODO Need to set emirates iD and TradeLicense ID Values
            // isEmiratesIdDone = value['emirates'] ?? false;
            // isTradeLicenseDone = value['tl'] ?? false;
            // status = value['status'] ?? false;
            // isPremium = value['premium'] ?? false;

            // // debugPrint('check1' + status.toString());
            // // debugPrint('check' + isEmiratesIdDone.toString());
          });
          return;
        }
      }
    });
    calculatePremiumDate();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  getCar() async {
    await CustomSharedPreferences.remove('DynamicQRData');
    await CustomSharedPreferences.remove('MerchantQRData');
    await CustomSharedPreferences.remove('StaticQRData');
    Provider.of<AddCardsProvider>(context, listen: false).getCard();
    //Provider.of<AddCardsProvider>(context, listen: false).selectedCard = null;
  }

  startOrderSession() async {
    if (await checkConnectivity) {
      debugPrint('startes: ${widget.model?.ulId}');
      OSession =
          await PaymentThroughCardAPI.cardPaymentsProvider.startOrderSession(
        through: widget.through,
        suspense: widget.suspense,
        toCustID: widget.model?.ulId ?? widget.customerId,
        type: widget.type,
        requestId: widget.requestId != null ? widget.requestId : '',
      );
      setState(() {
        loading = false;
      });
      debugPrint('qwe:ss  ${OSession?.toJson().toString()}');
      if (mounted) {
        setState(() {
          if (OSession?.statuscode == 410) {
            isSessionExpire = true;
            '${OSession?.message}'.showSnackBar(context);
          }
        });
      }
    } else {
      setState(() {
      loading = false;
      });
      'Please check your internet connection or try again later.'
          .showSnackBar(context);
    }
  }

  @override
  void didChangeDependencies() {
    _paymentController.initProvider();
    precacheImage(AssetImage("assets/icons/tapandpay.png"), context);
    precacheImage(AssetImage("assets/icons/Tap & Pay (White)-01.png"), context);
    precacheImage(AssetImage("assets/icons/cards.png"), context);
    precacheImage(
        AssetImage("assets/icons/Cards fill (white)-01.png"), context);
    super.didChangeDependencies();
  }

  final random = Random();
  late Color selectedColor;

  @override
  void dispose() {
    super.dispose();
    _enterDetailsController.dispose();
    currController.dispose();
    _paymentController.dispose();
  }

  bool isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    // if (flas == true) {
    //   isAmountFilled = false;
    // }

    return WillPopScope(
      onWillPop: () async {
        PaymentThroughCardAPI.cardPaymentsProvider
            .cancelOrderSession(orderID: OSession?.id);
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);
        }
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: Color(0xFFF2F1F6),
          extendBodyBehindAppBar: true,
          bottomNavigationBar: Container(
            margin: EdgeInsets.only(bottom: isPlatformiOS() ? 20 : 0),
            width: double.infinity,
            color: Color(0xFFF2F1F6),
            child: Consumer<AddCardsProvider>(builder: (ctx, cc, _) {
              isAmountFilled = (currController.text.isEmpty ||
                          currController.text.length == 0) ||
                      (int.tryParse(currController.text) == 0)
                  ? false
                  : true;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddCardScreen(),
                                ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 19,
                                height: 19,
                                child: Image.asset(
                                    'assets/icons/Add New Card-01.png'),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  'Add New Card',
                                  style: TextStyle(
                                      fontFamily: 'SFProDisplay',
                                      color: AppTheme.electricBlue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      height: 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  isCard == true
                      ? SizedBox(
                          height: 20,
                        )
                      : Container(),
                  isAmountFilled == true &&
                          ((isCard == true &&
                              (cc.selectedCard?.id != null &&
                                  cc.selectedCard!.id!.isNotEmpty))) &&
                          cc.card!.isNotEmpty
                      ? CurvedRoundButton(
                          color: isCard &&
                                  isSessionExpire == false &&
                                  loading == false
                              ? AppTheme.electricBlue
                              : AppTheme.coolGrey,
                          name: isCard &&
                                  isSessionExpire == false &&
                                  loading == false
                              ? 'Pay'
                              : isSessionExpire == true
                                  ? 'Session Expire'
                                  : loading == true
                                      ? 'Loading...'
                                      : 'Continue',
                          onPress: isCard == true && isSessionExpire == false
                              ? () async {
                                  try {
                                    // if (status == false) {
                                    //   modalSheet();
                                    // } else {
                                    debugPrint('dd : 1');
                                    CustomLoadingDialog.showLoadingDialog(
                                        context, key);
                                    if (await checkConnectivity) {
                                      var cid = await repository.customerApi
                                          .getCustomerID(
                                              mobileNumber: widget
                                                      .model?.mobileNo
                                                      .toString() ??
                                                  widget.mobileNo.toString())
                                          .catchError((e) {
                                        
                                        Navigator.of(context).pop();
                                        'Something went wrong. Please try again later.'
                                            .showSnackBar(context);
                                      });
                                      // .timeout(Duration(seconds: 30),
                                      // onTimeout: () async {
                                      //   Navigator.of(context).pop();
                                      //   return Future.value(null);
                                      // });

                                      // if (Repository()
                                      //         .hiveQueries
                                      //         .userData
                                      //         .bankStatus ==
                                      //     false) {
                                      //   Navigator.of(context).pop(true);
                                      //
                                      //   MerchantBankNotAdded.showBankNotAddedDialog(
                                      //       context, 'userBankNotAdded');
                                      // }

                                      // if ((Repository()
                                      //             .hiveQueries
                                      //             .userData
                                      //             .kycStatus !=
                                      //         1) ||
                                      //     (Repository()
                                      //             .hiveQueries
                                      //             .userData
                                      //             .premiumStatus !=
                                      //         0)) {
                                      debugPrint('dd : 3');
                                      // if (Repository()
                                      //         .hiveQueries
                                      //         .userData
                                      //         .kycStatus ==
                                      //     2) {
                                      //   Navigator.of(context).pop(true);
                                      //
                                      //   //If KYC is Verification is Pending
                                      //   await getKyc().then((value) =>
                                      //       MerchantBankNotAdded
                                      //           .showBankNotAddedDialog(context,
                                      //               'userKYCVerificationPending'));
                                      // }
                                      //
                                      // else if (Repository()
                                      //         .hiveQueries
                                      //         .userData
                                      //         .kycStatus ==
                                      //     0) {
                                      //   Navigator.of(context).pop(true);
                                      //
                                      //   //KYC WHEN USER STARTS A NEW KYC JOURNEY
                                      //   MerchantBankNotAdded.showBankNotAddedDialog(
                                      //       context, 'userKYCPending');
                                      // }
                                      //
                                      // if (Repository()
                                      //             .hiveQueries
                                      //             .userData
                                      //             .kycStatus ==
                                      //         0 &&
                                      //     Repository()
                                      //             .hiveQueries
                                      //             .userData
                                      //             .isEmiratesIdDone ==
                                      //         false) {
                                      //   Navigator.of(context).pop(true);
                                      //
                                      //   //KYC WHEN USER STARTS EMirates ID Journey but not done TRade License
                                      //   MerchantBankNotAdded.showBankNotAddedDialog(
                                      //       context, 'EmiratesIdPending');
                                      // }
                                      // else if (Repository()
                                      //             .hiveQueries
                                      //             .userData
                                      //             .kycStatus ==
                                      //         0 &&
                                      //     Repository()
                                      //             .hiveQueries
                                      //             .userData
                                      //             .isTradeLicenseDone ==
                                      //         false) {
                                      //   Navigator.of(context).pop(true);
                                      //
                                      //   //KYC WHEN USER STARTS EMirates ID Journey but not done TRade License
                                      //   MerchantBankNotAdded.showBankNotAddedDialog(
                                      //       context, 'TradeLicensePending');
                                      // }
                                      // else if (Repository()
                                      //             .hiveQueries
                                      //             .userData
                                      //             .kycStatus ==
                                      //         1 &&
                                      //     Repository()
                                      //             .hiveQueries
                                      //             .userData
                                      //             .premiumStatus ==
                                      //         0) {
                                      //   Navigator.of(context).pop(true);
                                      //
                                      //   MerchantBankNotAdded.showBankNotAddedDialog(
                                      //       context, 'upgradePremium');
                                      // }
                                      if (cid.customerInfo?.bankAccountStatus ==
                                          false) {
                                        debugPrint('dd : 4');
                                        Navigator.of(context).pop(true);

                                        merchantBankNotAddedModalSheet(
                                            text:
                                                'We have requested your merchant to add bank account.');
                                      } else if (cid.customerInfo?.kycStatus ==
                                          false) {
                                        debugPrint('dd : 5');
                                        Navigator.of(context).pop(true);
                                        merchantBankNotAddedModalSheet(
                                            text:
                                                'Your merchant has not completed the KYC or KYC is expired. We have requested merchant to complete KYC.');
                                      } else if (cid.customerInfo
                                              ?.merchantSubscriptionPlan ==
                                          false) {
                                        debugPrint('dd : 6');
                                        Navigator.of(context).pop(true);
                                        merchantBankNotAddedModalSheet(
                                            text:
                                                'We have requested your merchant to Switch to Premium now to enjoy the benefits.');
                                      } else {
                                        debugPrint('dd : 7');
                                        // String primaryBusiness =
                                        // await (CustomSharedPreferences.get('primaryBusiness'));
                                        // debugPrint('qwerty2: ' + primaryBusiness);
                                        //               debugPrint('qwerty3: ' + repository.hiveQueries
                                        //         .userData
                                        //         .premiumStatus);
                                        // debugPrint('qwerty4: ');
                                        // Navigator.of(context).pop(true);
                                        if (OSession?.id == null) {
                                          Navigator.of(context).pop();
                                          'Order session id is null.'
                                              .showSnackBar(context);
                                        }
                                        debugPrint('dd : 8');
                                        _id = widget.model?.ulId ??
                                            widget.customerId;
                                        double amount =
                                            double.parse(currController.text);
                                        // //widget.sendMessage!(amount, null, 1);
                                        // Map payDetails = {
                                        //   "card_id": "${cc.selectedCard?.id}",
                                        //   "amount": amount.toInt().toString(),
                                        //   "currency": "AED",
                                        //   "send_to": "$_id",
                                        //   "type": "${widget.type}",
                                        //   "through": "${widget.through}",
                                        //   "suspense": "${widget.suspense}",
                                        // };
                                        // FOR CAPTURE
                                        Map payDetails = {
                                          "card_id": "${cc.selectedCard?.id}",
                                          "amount": amount.toInt().toString(),
                                          "currency": "AED",
                                          "order_id": "${OSession!.id}"
                                        };

                                        debugPrint('paydetails :' +
                                            payDetails.toString());
                                        Provider.of<AddCardsProvider>(context,
                                                listen: false)
                                            .paymentThroughCard2(payDetails)
                                            .timeout(Duration(seconds: 100),
                                                onTimeout: () async {
                                          Navigator.of(context).pop();
                                          return Future.value(null);
                                        }).catchError((e) {
                                          
                                          Navigator.of(context).pop();
                                          'Something went wrong. Please try again later.'
                                              .showSnackBar(context);
                                        }).then((value) async {
                                          debugPrint(
                                              'Checks111' + value.toString());
                                          cc.selectedCard = null;
                                          if (value['status'] == true) {
                                            // String primaryBusiness =
                                            //     await (CustomSharedPreferences.get(
                                            //         'primaryBusiness'));

                                            // if (Provider.of<BusinessProvider>(
                                            //             context,
                                            //             listen: false)
                                            //         .selectedBusiness
                                            //         .businessId.toString().isEmpty) {
                                            Provider.of<BusinessProvider>(
                                                    context,
                                                    listen: false)
                                                .updateSelectedBusiness();
                                            // }
                                            // debugPrint('qwerty1');
                                            final amt = await repository.queries
                                                .getPaidMinusReceived(
                                                    widget.customerId)
                                                .timeout(Duration(seconds: 30),
                                                    onTimeout: () async {
                                              Navigator.of(context).pop();
                                              return Future.value(null);
                                            });

                                            final _transactionModel =
                                                TransactionModel()
                                                  ..transactionId = Uuid().v1()
                                                  ..amount = amount
                                                  ..details = ''
                                                  ..transactionType =
                                                      TransactionType.Pay
                                                  ..customerId =
                                                      widget.customerId
                                                  ..date = DateTime.now()
                                                  ..attachments = []
                                                  ..balanceAmount = amt - amount
                                                  ..isPayment = true
                                                  ..paymentTransactionId =
                                                      value['transactionId']
                                                  ..isChanged = true
                                                  ..isDeleted = false
                                                  ..business = Provider.of<
                                                              BusinessProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedBusiness
                                                      .businessId //todoadd column
                                                  ..createddate =
                                                      DateTime.now();

                                            final response = await repository
                                                .queries
                                                .insertLedgerTransaction(
                                                    _transactionModel);
                                            // debugPrint('qwerty3');
                                            if (response != null) {
                                              if (await checkConnectivity) {
                                                final apiResponse =
                                                    await (repository.ledgerApi
                                                        .saveTransaction(
                                                            _transactionModel)
                                                        .timeout(
                                                            Duration(
                                                                seconds: 30),
                                                            onTimeout:
                                                                () async {
                                                  Navigator.of(context).pop();
                                                  return Future.value(null);
                                                }).catchError((e) {
                                                  // debugPrint(e);
                                                  recordError(
                                                      e, StackTrace.current);
                                                  return false;
                                                }));
                                                // debugPrint('qwerty4');
                                                if (apiResponse) {
                                                  await repository.queries
                                                      .updateLedgerIsChanged(
                                                          _transactionModel, 0)
                                                      .timeout(
                                                          Duration(seconds: 30),
                                                          onTimeout: () async {
                                                    Navigator.of(context).pop();
                                                    return Future.value(null);
                                                  });
                                                }
                                              } else {
                                                Navigator.of(context).pop();
                                                'Please check your internet connection or try again later.'
                                                    .showSnackBar(context);
                                              }
                                              BlocProvider.of<LedgerCubit>(
                                                      context)
                                                  .getLedgerData(
                                                      widget.customerId);
                                              await repository.queries
                                                  .updateCustomerDetails(
                                                      amt - amount,
                                                      (amt - amount).isNegative
                                                          ? TransactionType.Pay
                                                          : TransactionType
                                                              .Receive,
                                                      widget.customerId)
                                                  .timeout(
                                                      Duration(seconds: 30),
                                                      onTimeout: () async {
                                                Navigator.of(context).pop();
                                                return Future.value(null);
                                              });
                                              BlocProvider.of<ContactsCubit>(
                                                      context)
                                                  .getContacts(Provider.of<
                                                              BusinessProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedBusiness
                                                      .businessId)
                                                  .timeout(
                                                      Duration(seconds: 30),
                                                      onTimeout: () async {
                                                Navigator.of(context).pop();
                                                return Future.value(null);
                                              });
                                            }

                                            var anaylticsEvents =
                                                AnalyticsEvents(context);
                                            await anaylticsEvents
                                                .initCurrentUser();
                                            await anaylticsEvents
                                                .sendPaymentEvent(
                                                    _transactionModel);
                                            // debugPrint('qwerty5');
                                            _paymentController.sendMessage(
                                                _id,
                                                widget.model?.chatId ?? null,
                                                widget.model?.name ??
                                                    '${widget.fName} ${widget.lName.toString()}',
                                                widget.model?.mobileNo ??
                                                    widget.mobileNo,
                                                amount,
                                                widget.requestId ?? '',
                                                1,
                                                value['transactionId'],
                                                value['urbanledgerId'],
                                                value['Date'],
                                                1,
                                                "${widget.type}",
                                                "${widget.through}",
                                                Provider.of<BusinessProvider>(
                                                        context,
                                                        listen: false)
                                                    .selectedBusiness
                                                    .businessId,
                                                widget.suspense == true
                                                    ? 1
                                                    : 0);
                                            // debugPrint('qwerty6');
                                            Navigator.of(context).pop(true);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PaymentDoneScreen(
                                                    model: value,
                                                    customermodel: widget.model,
                                                  ),
                                                ));
                                          } else if (value['statuscode'] ==
                                              404) {
                                            Navigator.of(context).pop(true);
                                            userNotRegisteredDialog(
                                                text:
                                                    'We have requested your merchant to add their\nbank account. Please try again in some time.');
                                          } else if (value['statuscode'] ==
                                              204) {
                                            Navigator.of(context).pop(true);
                                            userNotRegisteredDialog(
                                                text:
                                                    'We have requested your merchant to complete their KYC. Please try again in some time.');
                                          } else if (value['error'] !=
                                                  'Bad Track Data' &&
                                              value['error'] !=
                                                  'Expired Card - Pick Up' &&
                                              value['error'] !=
                                                  'Restricted Card' &&
                                              value['statuscode'] != 410 &&
                                              value['error']
                                                  .containsKey('http_code')) {
                                            Navigator.of(context).pop(true);
                                            userNotRegisteredDialog(
                                                text: 'Invalid Card details.');
                                          } else {
                                            _paymentController
                                                .sendMessage(
                                                    _id,
                                                    widget.model?.chatId ??
                                                        null,
                                                    widget.model?.name ??
                                                        '${widget.fName} ${widget.lName.toString()}',
                                                    widget.model?.mobileNo ??
                                                        widget.mobileNo,
                                                    amount,
                                                    '',
                                                    1,
                                                    value['transactionId'],
                                                    value['urbanledgerId'],
                                                    value['Date'],
                                                    0,
                                                    "",
                                                    "",
                                                    Provider.of<BusinessProvider>(
                                                            context,
                                                            listen: false)
                                                        .selectedBusiness
                                                        .businessId,
                                                    0)
                                                .timeout(Duration(seconds: 30),
                                                    onTimeout: () async {
                                              Navigator.of(context).pop();
                                              return Future.value(null);
                                            });

                                            Navigator.of(context).pop(true);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TransactionFailedScreen(
                                                    model: value,
                                                    customermodel: widget.model,
                                                  ),
                                                ));
                                          }
                                        });
                                        // }
                                      }
                                    } else {
                                      Navigator.of(context).pop();
                                      'Please check your internet connection or try again later.'
                                          .showSnackBar(context);
                                    }
                                  } catch (e) {
                                    print(e.toString());
                                    Navigator.of(context).pop();
                                    'Please check your internet connection or try again later.'
                                        .showSnackBar(context);
                                  }
                                }
                              : () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             BankAddedSuccessfully()));
                                },
                        )
                      : CurvedRoundButton(
                          name: isCard ? 'Pay' : 'Continue',
                          color: AppTheme.greyish,
                          onPress: () {},
                        ),
                ],
              );
            }),
          ),
          body: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: deviceHeight * 0.31,
                    width: double.maxFinite,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      color: Color(0xfff2f1f6),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/back2.png'),
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 22,
                            ),
                            color: Colors.white,
                            onPressed: () {
                              PaymentThroughCardAPI.cardPaymentsProvider
                                  .cancelOrderSession(orderID: OSession?.id);
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop(true);
                              } else {
                                Navigator.of(context)
                                    .pushReplacementNamed(AppRoutes.mainRoute);
                              }
                            },
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppTheme.carolinaBlue,
                            child: CustomText(
                              widget.fName != null
                                  ? getInitials(
                                          '${widget.fName.toString().trim()} ${widget.lName.toString().trim()}',
                                          '${widget.mobileNo.toString()}')
                                      .toUpperCase()
                                  : getInitials(
                                          '${widget.model?.name.toString().trim()}',
                                          '${widget.model?.mobileNo.toString()}')
                                      .toUpperCase(),
                              color: AppTheme.circularAvatarTextColor,
                              size: 24,
                            ),
                          ),
                          // CustomProfileImage(
                          //   avatar: widget.model?.avatar,
                          //   mobileNo: widget.model?.mobileNo,
                          //   name: widget.fName!.trim() + ' ' + widget.lName!.trim(),
                          // ),
                          // widget.model != null
                          //     ? CircleAvatar(
                          //         radius: 22,
                          //         backgroundColor: Colors.white,
                          //         child: CircleAvatar(
                          //           radius: 20,
                          //           backgroundColor:
                          //               _colors[random.nextInt(_colors.length)],
                          //           // backgroundImage:
                          //           //     widget.model?.avatar?.isEmpty ?? true
                          //           //         ? null
                          //           //         : MemoryImage(widget.model!.avatar!),
                          //           child: widget.fName?.isEmpty ?? true
                          //               ? CustomText(
                          //                   widget.fName != null
                          //             ? getInitials(
                          //                     '${widget.fName?.trim()} ${widget.lName?.trim() ?? ''}' ,
                          //                     '${widget.mobileNo?.trim()}')
                          //                 .toUpperCase()
                          //             : getInitials('${widget.model?.name?.trim()}',
                          //                     '${widget.model?.mobileNo?.trim()}')
                          //                 .toUpperCase(),
                          //                   color: AppTheme.circularAvatarTextColor,
                          //                   size: 22,
                          //                 )
                          //               : null,
                          //         ),
                          //       )
                          //     : Container(),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                widget.fName != null
                                    ? '${widget.fName} ${widget.lName ?? ''}'
                                    : '${widget.model?.name.toString() ?? 'User'}',
                                color: Colors.white,
                                size: 18,
                                bold: FontWeight.w600,
                              ),
                              InkWell(
                                onTap: () {
                                  // Navigator.of(context)
                                  //     .pushNamed(AppRoutes.customerProfileRoute);
                                },
                                child: Text(
                                  widget.mobileNo != null
                                      ? '${widget.mobileNo}'
                                      : '${widget.model?.mobileNo.toString()}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      // actions: [
                      //   Icon(
                      //     Icons.more_vert,
                      //     color: Colors.white,
                      //     size: 30,
                      //   ),
                      //   SizedBox(
                      //     width: 5,
                      //   ),
                      // ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 5),
                      //   child: Text(
                      //     'Enter the Amount',
                      //     style: TextStyle(
                      //         color: Colors.white54,
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.w600,
                      //         letterSpacing: 0,
                      //         height: 1),
                      //   ),
                      // ),
                      // IntrinsicHeight(
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Expanded(
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text(
                      //             'AED',
                      //             textAlign: TextAlign.end,
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 18,
                      //                 fontWeight: FontWeight.w500),
                      //           ),
                      //         ),
                      //       ),
                      //       VerticalDivider(
                      //         thickness: 2,
                      //         indent: 2,
                      //         endIndent: 2,
                      //         color: Colors.white54,
                      //       ),
                      //       Expanded(
                      //         child: Container(
                      //           alignment: Alignment.center,
                      //           // width: MediaQuery.of(context).size.width * 0.15,
                      //           child: TextFormField(
                      //             controller: currController,
                      //             onChanged: (value) {
                      //               setState(() {
                      //                 isAmountFilled =
                      //                     (currController.text.isEmpty ||
                      //                             currController.text.length == 0)
                      //                         ? false
                      //                         : true;
                      //               });
                      //             },
                      //             autofocus: false,
                      //             onTap: () {
                      //               setState(() {
                      //                 // debugPrint(isAmountFilled.toString());
                      //                 isCard = false;
                      //                 isTapandpay = false;
                      //               });
                      //             },
                      //             keyboardType: TextInputType.phone,
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 40,
                      //                 fontWeight: FontWeight.bold),
                      //             decoration: InputDecoration(
                      //                 border: InputBorder.none,
                      //                 focusedBorder: InputBorder.none,
                      //                 enabledBorder: InputBorder.none,
                      //                 errorBorder: InputBorder.none,
                      //                 disabledBorder: InputBorder.none,
                      //                 hintStyle: TextStyle(
                      //                     color: Colors.white.withOpacity(0.2),
                      //                     fontSize: 40,
                      //                     fontWeight: FontWeight.bold),
                      //                 hintText: "0"),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      CustomAmountFiller(
                        CtextFilled: TextFormField(
                          controller: currController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"^\d*\.?\d*")),
                          ],
                          onChanged: (value) {
                            debugPrint('check2: ' + isAmountFilled.toString());
                            setState(() {
                              isAmountFilled = (currController.text.isEmpty ||
                                          currController.text.length == 0) ||
                                      (int.tryParse(currController.text) == 0)
                                  ? false
                                  : true;
                            });
                            // debugPrint(isAmountFilled.toString());
                          },
                          autofocus: false,
                          onTap: () {
                            debugPrint('check2: ' + isAmountFilled.toString());

                            setState(() {
                              // debugPrint(isAmountFilled.toString());
                              //isCard = false;
                              isTapandpay = false;
                            });
                          },
                          keyboardType: TextInputType.phone,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          },
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.2),
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                              hintText: "0"),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // _selectedDate = await showDatePickerWidget(context);
                          // if (_selectedDate != null) setState(() {});
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            'Paying to ${widget.model?.name ?? 'User'}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              fontFamily: 'SFProDisplay',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      // SizedBox(
                      //   height: MediaQuery.of(context).padding.top + appBarHeight,
                      // ),
                      (deviceHeight * 0.38).heightBox,
                      //Enter Details -Widget
                      // Flexible(
                      //   child: ListView(
                      //     padding: EdgeInsets.zero,
                      //     children: [
                      //       Padding(
                      //           padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      //           child: Theme(
                      //             data: ThemeData(primaryColor: Colors.white),
                      //             child: ClipRRect(
                      //               borderRadius: BorderRadius.circular(4),
                      //               child: TextField(
                      //                 controller: _enterDetailsController,
                      //                 maxLines: 4,
                      //                 minLines: 4,
                      //                 style: TextStyle(color: AppTheme.brownishGrey),
                      //                 textCapitalization: TextCapitalization.sentences,
                      //                 decoration: InputDecoration(
                      //                     hintText: 'Enter Details',
                      //                     hintStyle:
                      //                         TextStyle(color: Color(0xff666666)),
                      //                     enabledBorder: InputBorder.none,
                      //                     focusedBorder: InputBorder.none,
                      //                     filled: true,
                      //                     fillColor: Colors.white),
                      //               ),
                      //             ),
                      //           )),
                      //     ],
                      //   ),
                      // ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: IntrinsicWidth(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // InkWell(
                              //   onTap: () {
                              //     setState(() {
                              //       isTapandpay = !isTapandpay;
                              //       isCard = false;
                              //       FocusScope.of(context).unfocus();
                              //     });
                              //   },
                              //   child: Column(
                              //     children: [
                              //       Container(
                              //         padding: EdgeInsets.all(15),
                              //         color: isTapandpay
                              //             ? AppTheme.electricBlue
                              //             : Colors.white,
                              //         height: 62,
                              //         width: 62,
                              //         child: isTapandpay
                              //             ? Image.asset(
                              //                 AppAssets.tapPayIcon,
                              //                 fit: BoxFit.contain,
                              //                 height: 14,
                              //                 color: Colors.white,
                              //               )
                              //             : Image.asset(
                              //                 AppAssets.tapPayIcon,
                              //                 height: 14,
                              //                 fit: BoxFit.contain,
                              //               ),
                              //       ),
                              //       SizedBox(
                              //         height: 5,
                              //       ),
                              //       CustomText(
                              //         'Tap & Pay',
                              //         color: Color(0xFF666666),
                              //         centerAlign: true,
                              //         size: 14,
                              //         fontFamily: 'SFProDisplay',
                              //         bold: FontWeight.normal,
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // SizedBox(
                              //   width: MediaQuery.of(context).size.width * 0.15,
                              // ),
                              // InkWell(
                              //   onTap: () {
                              //     setState(() {
                              //       if (isAmountFilled) {
                              //         setState(() {
                              //           isCard = !isCard;
                              //           isTapandpay = false;
                              //           FocusScope.of(context).unfocus();
                              //         });
                              //       } else {
                              //         ScaffoldMessenger.of(context)
                              //             .showSnackBar(SnackBar(
                              //           content: Text('Please enter amount.'),
                              //           behavior: SnackBarBehavior.floating,
                              //           margin: EdgeInsets.only(
                              //               bottom: 50, left: 15, right: 15, top: 15),
                              //         ));
                              //       }
                              //       FocusScope.of(context).unfocus();
                              //     });
                              //   },
                              //   child: Column(
                              //     children: [
                              //       Container(
                              //           decoration: BoxDecoration(
                              //               color: isCard
                              //                   ? AppTheme.electricBlue
                              //                   : AppTheme.electricBlue,
                              //               borderRadius:
                              //                   BorderRadius.all(Radius.circular(5))),
                              //           padding: EdgeInsets.all(15),
                              //           // color: isCard
                              //           //     ? AppTheme.electricBlue
                              //           //     : Colors.white,
                              //           height: 62,
                              //           width: 62,
                              //           child: isCard
                              //               ? Image.asset(
                              //                   AppAssets.cardsIcon,
                              //                   color: Colors.white,
                              //                   width: 14,
                              //                   fit: BoxFit.contain,
                              //                   height: 14,
                              //                 )
                              //               : Image.asset(
                              //                   AppAssets.cardsIcon,
                              //                   color: Colors.white,
                              //                   width: 14,
                              //                   fit: BoxFit.contain,
                              //                   height: 14,
                              //                 )),
                              //       SizedBox(
                              //         height: 5,
                              //       ),
                              //       CustomText(
                              //         'Cards',
                              //         color: Color(0xFF666666),
                              //         centerAlign: true,
                              //         size: 14,
                              //         fontFamily: 'SFProDisplay',
                              //         bold: FontWeight.normal,
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        (deviceHeight * 0.5).heightBox,
                        // isCard == true && isAmountFilled == true

                        Container(
                          child: Consumer<AddCardsProvider>(
                              builder: (context, cart, child) {
                            // debugPrint('Card' + cart.selectedCard!.id);

                            return (cart.card!.isEmpty)
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/images/Add Card Illustration-01.png',
                                          height: deviceHeight * 0.28,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      // // InkWell(
                                      // //   onTap: () {
                                      // //     Navigator.push(
                                      // //         context,
                                      // //         MaterialPageRoute(
                                      // //           builder: (context) =>
                                      // //               AddCardScreen(),
                                      // //         ));
                                      // //     setState(() {});
                                      // //   },
                                      // //   child: Row(
                                      // //     mainAxisAlignment:
                                      // //         MainAxisAlignment.center,
                                      // //     children: [
                                      // //       Container(
                                      // //         width: 19,
                                      // //         height: 19,
                                      // //         child: Image.asset(
                                      // //             'assets/icons/Add New Card-01.png'),
                                      // //       ),
                                      // //       SizedBox(
                                      // //         width: 5,
                                      // //       ),
                                      // //       Text(
                                      // //         'Add New Card',
                                      // //         style: TextStyle(
                                      // //             fontFamily: 'SFProDisplay',
                                      // //             color: AppTheme.electricBlue,
                                      // //             fontSize: 16,
                                      // //             fontWeight: FontWeight.w600,
                                      // //             letterSpacing:
                                      // //                 0 /*percentages not used in flutter. defaulting to zero*/,
                                      // //             height: 1),
                                      // //       ),
                                      // //     ],
                                      // //   ),
                                      // // ),
                                      // // SizedBox(
                                      // //   height: 20,
                                      // // ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        height: deviceHeight * 0.37,
                                        child: ListView.builder(
                                          reverse: false,
                                          itemCount: cart.card!.length,
                                          itemBuilder: (context, int index) {
                                            CardDetailsModel cards =
                                                cart.card![index];

                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 3),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 0,
                                              ),
                                              width: 335,
                                              height: 55,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Color(0xffebebeb),
                                                  width: 1,
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: RadioListTile(
                                                  selected: true,
                                                  contentPadding:
                                                      EdgeInsets.only(left: 5),
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .trailing,
                                                  value: cart.card![index],
                                                  groupValue: cart.selectedCard,
                                                  onChanged: (CardDetailsModel?
                                                      currentUser) {
                                                    setState(() {
                                                      cart.selectedCard =
                                                          currentUser;
                                                      print(cart
                                                          .selectedCard?.id
                                                          .toString());
                                                    });
                                                  },
                                                  title: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      cards.cardImage!
                                                              .isNotEmpty
                                                          ? Image.network(
                                                              cards.cardImage
                                                                  .toString(),
                                                              height: 30,
                                                            )
                                                          : Image.asset(
                                                              'assets/icons/Mastero-01.png',
                                                              height: 35,
                                                            ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "${cards.endNumber.toString().replaceAll('x', '*').replaceAll(' ', ' - ')}",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff666666),
                                                          fontSize: 18,
                                                          fontFamily:
                                                              "SFProDisplay",
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        height: 22,
                                                        width: 28,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            InkWell(
                                                              onTap: () =>
                                                                  showDialog(
                                                                      builder:
                                                                          (context) =>
                                                                              Dialog(
                                                                                insetPadding: EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.77),
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                                                                                      child: CustomText(
                                                                                        'Are you sure you want to delete this card?',
                                                                                        color: AppTheme.tomato,
                                                                                        bold: FontWeight.w500,
                                                                                        size: 18,
                                                                                      ),
                                                                                    ),
                                                                                    // CustomText(
                                                                                    //   'Delete entry will change your balance ',
                                                                                    //   size: 16,
                                                                                    // ),
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
                                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                                color: AppTheme.electricBlue,
                                                                                                child: CustomText(
                                                                                                  'CANCEL',
                                                                                                  color: Colors.white,
                                                                                                  size: (18),
                                                                                                  bold: FontWeight.w500,
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  Navigator.of(context).pop(false);
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
                                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                                color: AppTheme.electricBlue,
                                                                                                child: CustomText(
                                                                                                  'CONFIRM',
                                                                                                  color: Colors.white,
                                                                                                  size: (18),
                                                                                                  bold: FontWeight.w500,
                                                                                                ),
                                                                                                onPressed: () async {
                                                                                                  Navigator.of(context).pop(true);
                                                                                                  if (cards.isdefault == 1) {
                                                                                                    'Default card cannot be deleted'.showSnackBar(context);
                                                                                                  } else {
                                                                                                    await cart.deleleCard(cards.id);
                                                                                                  }
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
                                                                      barrierDismissible:
                                                                          false,
                                                                      context:
                                                                          context),

                                                              // onTap: () async {
                                                              //   await cart
                                                              //       .deleleCard(
                                                              //           cards.id);
                                                              // },
                                                              child: Container(
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/Delete-01.png',
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap:
                                                            cart.selectedCard
                                                                        ?.id !=
                                                                    null
                                                                ? () async {
                                                                    if (cart
                                                                            .card?[
                                                                                index]
                                                                            .id ==
                                                                        cart.selectedCard!
                                                                            .id) {
                                                                      'Default card cannot be marked as non-default'
                                                                          .showSnackBar(
                                                                              context);
                                                                    } else {
                                                                      /* setState(() {
                                                                  cart.selectedCard = cart
                                                                          .card![
                                                                      cart.card!.indexWhere((element) =>
                                                                          element
                                                                              .isdefault
                                                                              .toString() ==
                                                                          '1')];
                                                                });*/

                                                                      Map card =
                                                                          {
                                                                        "isdefault":
                                                                            "${cards.isdefault == 0 ? 1 : 0}",
                                                                        "id":
                                                                            "${cards.id.toString()}",
                                                                      };

                                                                      CustomLoadingDialog.showLoadingDialog(
                                                                          context,
                                                                          key);
                                                                      await cart
                                                                          .editCard(
                                                                        id: cards
                                                                            .id
                                                                            .toString(),
                                                                        value: cards.isdefault ==
                                                                                0
                                                                            ? 1
                                                                            : 0,
                                                                      );
                                                                      /* await cart
                                                                    .getCardForPremium()
                                                                    .whenComplete(
                                                                        () {
                                                                  cart.selectedCard = cart
                                                                          .card![
                                                                      cart.card!.indexWhere((element) =>
                                                                          element
                                                                              .isdefault
                                                                              .toString() ==
                                                                          '1')];
                                                                });*/
                                                                      /*  cart.selectedCard =
                                                                    cart.card![cart
                                                                        .card!
                                                                        .indexWhere((element) =>
                                                                            element
                                                                                .isdefault
                                                                                .toString() ==
                                                                            '1')];*/

                                                                      await cart
                                                                          .getCard();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    }
                                                                  }
                                                                : () {},
                                                        // cart.card?[index]
                                                        //             .id ==
                                                        //         cart.selectedCard!
                                                        //             .id
                                                        //     ? () async {
                                                        //         'Default card cannot be marked as non-default'
                                                        //             .showSnackBar(
                                                        //                 context);
                                                        //       }
                                                        //     : () async {
                                                        //         setState(() {
                                                        //           cart.selectedCard = cart
                                                        //                   .card![
                                                        //               cart.card!.indexWhere((element) =>
                                                        //                   element
                                                        //                       .isdefault
                                                        //                       .toString() ==
                                                        //                   '1')];
                                                        //         });

                                                        //         Map card = {
                                                        //           "isdefault":
                                                        //               "${cards.isdefault == 0 ? 1 : 0}",
                                                        //           "id":
                                                        //               "${cards.id.toString()}",
                                                        //         };

                                                        //         CustomLoadingDialog
                                                        //             .showLoadingDialog(
                                                        //                 context,
                                                        //                 key);
                                                        //         await cart
                                                        //             .editCard(
                                                        //           id: cards.id
                                                        //               .toString(),
                                                        //           value:
                                                        //               cards.isdefault ==
                                                        //                       0
                                                        //                   ? 1
                                                        //                   : 0,
                                                        //         );
                                                        //         /* await cart
                                                        //             .getCardForPremium()
                                                        //             .whenComplete(
                                                        //                 () {
                                                        //           cart.selectedCard = cart
                                                        //                   .card![
                                                        //               cart.card!.indexWhere((element) =>
                                                        //                   element
                                                        //                       .isdefault
                                                        //                       .toString() ==
                                                        //                   '1')];
                                                        //         });*/
                                                        //         cart.selectedCard =
                                                        //             cart.card![cart
                                                        //                 .card!
                                                        //                 .indexWhere((element) =>
                                                        //                     element
                                                        //                         .isdefault
                                                        //                         .toString() ==
                                                        //                     '1')];
                                                        //         Navigator.of(
                                                        //                 context)
                                                        //             .pop();
                                                        //       },
                                                        child: Container(
                                                          height: 20,
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              cards.isdefault
                                                                          .toString() ==
                                                                      '1'
                                                                  ? Container(
                                                                      // height: 15,
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/images/on.png',
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      // height: 15,
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/images/WO_Default-01.png',
                                                                      ),
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      // Container(
                                                      //   width: 14,
                                                      //   child: Radio(
                                                      //     value: cart.card![index]
                                                      //                 .isdefault ==
                                                      //             1
                                                      //         ? cart.card![index]
                                                      //         : cart.card![index],

                                                      //     groupValue:
                                                      //         cart.selectedCard,

                                                      //     onChanged:
                                                      //         (Cards? currentUser) {
                                                      //       setState(() {
                                                      //         cart.selectedCard =
                                                      //             currentUser;
                                                      //         print(cart
                                                      //             .selectedCard?.id
                                                      //             .toString());
                                                      //       });
                                                      //     },
                                                      //     // selected:
                                                      //     //     cart.selectedCard ==
                                                      //     //         cart.card![index],
                                                      //     activeColor:
                                                      //         AppTheme.electricBlue,
                                                      //   ),
                                                      // ),
                                                    ],
                                                  )),
                                            );

                                            //
                                            // Container(
                                            //   margin: EdgeInsets.symmetric(
                                            //       vertical: 5),
                                            //   padding: EdgeInsets.symmetric(
                                            //       horizontal: 5, vertical: 5),
                                            //   width: 335,
                                            //   height: 55,
                                            //   decoration: BoxDecoration(
                                            //     borderRadius:
                                            //         BorderRadius.circular(12),
                                            //     border: Border.all(
                                            //       color: Color(0xffebebeb),
                                            //       width: 1,
                                            //     ),
                                            //     color: Colors.white,
                                            //   ),
                                            //   child: Row(
                                            //     mainAxisAlignment:
                                            //         MainAxisAlignment
                                            //             .spaceAround,
                                            //     children: [
                                            //       Image.asset(
                                            //         'assets/icons/Mastero-01.png',
                                            //         height: 35,
                                            //       ),
                                            //       Text(
                                            //         "${cards.endNumber.toString().replaceAll('x', '*').replaceAll(' ', '-')}",
                                            //         style: TextStyle(
                                            //           color: Color(0xff666666),
                                            //           fontSize: 18,
                                            //           fontFamily:
                                            //               "SFProDisplay",
                                            //           fontWeight:
                                            //               FontWeight.w700,
                                            //         ),
                                            //       ),
                                            //       Container(
                                            //         height: 22,
                                            //         width: 28,
                                            //         child: Row(
                                            //           mainAxisSize:
                                            //               MainAxisSize.min,
                                            //           mainAxisAlignment:
                                            //               MainAxisAlignment
                                            //                   .center,
                                            //           crossAxisAlignment:
                                            //               CrossAxisAlignment
                                            //                   .center,
                                            //           children: [
                                            //             InkWell(
                                            //               onTap: () =>
                                            //                   showDialog(
                                            //                       builder:
                                            //                           (context) =>
                                            //                               Dialog(
                                            //                                 insetPadding: EdgeInsets.only(
                                            //                                     left: 20,
                                            //                                     right: 20,
                                            //                                     top: deviceHeight * 0.77),
                                            //                                 shape:
                                            //                                     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            //                                 child:
                                            //                                     Column(
                                            //                                   mainAxisSize: MainAxisSize.min,
                                            //                                   children: [
                                            //                                     Padding(
                                            //                                       padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                                            //                                       child: CustomText(
                                            //                                         'Are you sure you want to delete this card?',
                                            //                                         color: AppTheme.tomato,
                                            //                                         bold: FontWeight.w500,
                                            //                                         size: 18,
                                            //                                       ),
                                            //                                     ),
                                            //                                     // CustomText(
                                            //                                     //   'Delete entry will change your balance ',
                                            //                                     //   size: 16,
                                            //                                     // ),
                                            //                                     Padding(
                                            //                                       padding: const EdgeInsets.all(8.0),
                                            //                                       child: Row(
                                            //                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            //                                         children: [
                                            //                                           Expanded(
                                            //                                             child: Container(
                                            //                                               margin: EdgeInsets.symmetric(vertical: 10),
                                            //                                               padding: const EdgeInsets.symmetric(horizontal: 10),
                                            //                                               child: RaisedButton(
                                            //                                                 padding: EdgeInsets.all(15),
                                            //                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            //                                                 color: AppTheme.electricBlue,
                                            //                                                 child: CustomText(
                                            //                                                   'CANCEL',
                                            //                                                   color: Colors.white,
                                            //                                                   size: (18),
                                            //                                                   bold: FontWeight.w500,
                                            //                                                 ),
                                            //                                                 onPressed: () {
                                            //                                                   Navigator.of(context).pop(false);
                                            //                                                 },
                                            //                                               ),
                                            //                                             ),
                                            //                                           ),
                                            //                                           Expanded(
                                            //                                             child: Container(
                                            //                                               margin: EdgeInsets.symmetric(vertical: 10),
                                            //                                               padding: const EdgeInsets.symmetric(horizontal: 15),
                                            //                                               child: RaisedButton(
                                            //                                                 padding: EdgeInsets.all(15),
                                            //                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            //                                                 color: AppTheme.electricBlue,
                                            //                                                 child: CustomText(
                                            //                                                   'CONFIRM',
                                            //                                                   color: Colors.white,
                                            //                                                   size: (18),
                                            //                                                   bold: FontWeight.w500,
                                            //                                                 ),
                                            //                                                 onPressed: () async {
                                            //                                                   Navigator.of(context).pop(true);
                                            //                                                   await cart.deleleCard(cards.id);
                                            //                                                 },
                                            //                                               ),
                                            //                                             ),
                                            //                                           )
                                            //                                         ],
                                            //                                       ),
                                            //                                     )
                                            //                                   ],
                                            //                                 ),
                                            //                               ),
                                            //                       barrierDismissible:
                                            //                           false,
                                            //                       context:
                                            //                           context),

                                            //               // onTap: () async {
                                            //               //   await cart
                                            //               //       .deleleCard(
                                            //               //           cards.id);
                                            //               // },
                                            //               child: Container(
                                            //                 child: Image.asset(
                                            //                   'assets/images/Delete-01.png',
                                            //                 ),
                                            //               ),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ),
                                            //       InkWell(
                                            //         onTap: () {
                                            //           Map card = {
                                            //             "isdefault":
                                            //                 "${cards.isdefault == 0 ? 1 : 0}",
                                            //             "id":
                                            //                 "${cards.id.toString()}",
                                            //           };
                                            //           cart.editCard(
                                            //             id: cards.id.toString(),
                                            //             value:
                                            //                 cards.isdefault == 0
                                            //                     ? 1
                                            //                     : 0,
                                            //           );
                                            //           cart.getCard();
                                            //         },
                                            //         child: Container(
                                            //           height: 20,
                                            //           child: Row(
                                            //             mainAxisSize:
                                            //                 MainAxisSize.min,
                                            //             mainAxisAlignment:
                                            //                 MainAxisAlignment
                                            //                     .center,
                                            //             crossAxisAlignment:
                                            //                 CrossAxisAlignment
                                            //                     .center,
                                            //             children: [
                                            //               cards.isdefault == 1
                                            //                   ? Container(
                                            //                       // height: 15,
                                            //                       child: Image
                                            //                           .asset(
                                            //                         'assets/images/on.png',
                                            //                       ),
                                            //                     )
                                            //                   : Container(
                                            //                       // height: 15,
                                            //                       child: Image
                                            //                           .asset(
                                            //                         'assets/images/WO_Default-01.png',
                                            //                       ),
                                            //                     ),
                                            //             ],
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       Container(
                                            //         width: 14,
                                            //         child: Radio(
                                            //           value: cart.card![index]
                                            //                       .isdefault ==
                                            //                   1
                                            //               ? cart.card![index]
                                            //               : cart.card![index],

                                            //           groupValue:
                                            //               cart.selectedCard,

                                            //           onChanged:
                                            //               (Cards? currentUser) {
                                            //             setState(() {
                                            //               cart.selectedCard =
                                            //                   currentUser;
                                            //               print(cart
                                            //                   .selectedCard?.id
                                            //                   .toString());
                                            //             });
                                            //           },
                                            //           // selected:
                                            //           //     cart.selectedCard ==
                                            //           //         cart.card![index],
                                            //           activeColor:
                                            //               AppTheme.electricBlue,
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // );

                                            //
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                          }),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  userNotRegisteredDialog({text, text2}) async => await showDialog(
      builder: (context) => Dialog(
            // backgroundColor: AppTheme.electricBlue,
            insetPadding:
                EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.70),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical:10, horizontal:10),
                //   child: Image.asset(AppAssets.notregistered,width: MediaQuery.of(context).size.width * 0.5,),
                // ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 5, left: 15, right: 15),
                  child: CustomText(
                    text,
                    centerAlign: true,
                    color: AppTheme.tomato,
                    bold: FontWeight.w500,
                    size: 18,
                  ),
                ),
                // CustomText(
                //   'Link your Bank Account?',
                //   color: AppTheme.brownishGrey,
                //   bold: FontWeight.w500,
                //   size: 18,
                // ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                      // Expanded(
                      //   child: Container(
                      //     margin: EdgeInsets.symmetric(vertical: 10),
                      //     padding: const EdgeInsets.symmetric(horizontal: 15),
                      //     child: RaisedButton(
                      //       padding: EdgeInsets.all(15),
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(10)),
                      //       // color: Color.fromRGBO(137, 172, 255, 1),
                      //       color: AppTheme.electricBlue,
                      //       child: CustomText(
                      //         'invite'.toUpperCase(),
                      //         color: Colors.white,
                      //         size: (18),
                      //         bold: FontWeight.w500,
                      //       ),
                      //       onPressed: () async {
                      //         Navigator.of(context).pop(true);
                      //         final RenderBox box =
                      //             context.findRenderObject() as RenderBox;

                      //         await Share.share(
                      //             'Hey! I’m inviting you to use Urban Ledger (an amazing app to manage small businesses). It helps keep track of payables/receivables from our customers/suppliers. It also helps us collect payments digitally through unique payment links. https://bit.ly/app-store-link',
                      //             subject: 'https://bit.ly/app-store-link',
                      //             sharePositionOrigin:
                      //                 box.localToGlobal(Offset.zero) &
                      //                     box.size);
                      //       },
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                )
              ],
            ),
          ),
      barrierDismissible: false,
      context: context);

// final List<Color> _colors = [
//   Color.fromRGBO(137, 171, 249, 1),
//   AppTheme.brownishGrey,
//   AppTheme.greyish,
//   AppTheme.electricBlue,
// ];
// Random random = Random();
}
