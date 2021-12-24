import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
import 'package:urbanledger/Models/SuspenseAccountModel.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Services/APIs/suspense_account_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';

class SuspenseDt extends StatefulWidget {
/*  final bool? suspense;
  final String? id;
  final bool? status;
  final String? message;
  final int amount;
  final String? currency;
  final String? urbanledgerId;
  final String? transactionId;
  final String? paymentMethod;
  final String? completed;
  final String from;
  final String? fromEmail;
  final String? to;
  final String? toEmail;
  final String? endingWith;
  final String? cardType;
  final String? through;
  final String? type;
  final CustId? toCustId;
  final CustId? fromCustId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? fromMobileNumber;
  final int? isMoved = 0;*/

  SuspenseData suspenseData;

  SuspenseDt({required this.suspenseData
      /*this.suspense,
    this.id,
    this.status,
    this.message,
    this.amount = 0,
    this.currency,
    this.urbanledgerId,
    this.transactionId,
    this.paymentMethod,
    this.completed,
    this.from = '',
    this.fromEmail,
    this.to,
    this.toEmail,
    this.endingWith,
    this.cardType,
    this.through,
    this.type,
    this.toCustId,
    this.fromCustId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.fromMobileNumber,*/
      // this.isMoved,
      });

  @override
  _SuspenseDtState createState() => _SuspenseDtState();
}

class _SuspenseDtState extends State<SuspenseDt> {
  final double height = deviceHeight - appBarHeight;
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 17, right: 17),
        child: Padding(
          padding: EdgeInsets.only(bottom: 10.0, left: 12.0, right: 12.0),
          child: NewCustomButton(
              onSubmit: () {
                List<SuspenseData> suspenseData = [];
                suspenseData.add(widget.suspenseData);
                ledgerBussinessModelSelectionBottomSheet(context, suspenseData);
              },
              text: 'Move'.toUpperCase(),
              textSize: 17,
              textColor: Colors.white),
        ),
      ),
      appBar: AppBar(
        title: Text('Transaction Details'),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<BusinessProvider>(context, listen: false)
                  .updateSelectedBusiness();
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 22,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: deviceHeight * 0.2,
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
                Container(
                  margin: EdgeInsets.only(
                    top: 80,
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.coolGrey, width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                        padding: EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    CustomProfileImage(
                                      mobileNo:
                                          widget.suspenseData.fromMobileNumber,
                                      name: widget.suspenseData.from,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.suspenseData.to}',
                                      style: TextStyle(
                                        color: AppTheme.electricBlue,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                      ),
                                    ),
                                    widget.suspenseData.createdAt != null
                                        ? Text(
                                            "${DateFormat('dd MMM yyyy | hh:mm aa').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.suspenseData.createdAt.toString()))}")
                                        : Text(''),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'You Got',
                                  style: TextStyle(
                                    color: AppTheme.brownishGrey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  currencyAED +
                                      '  ${widget.suspenseData.amount}',
                                  style: TextStyle(
                                    color: AppTheme.greenColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                // Text(DateFormat("E, d MMM y hh:mm a")
                                //     .parse(widget.suspenseData.createdAt
                                //         .toString())
                                //     .toString()),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Divider(),
                      // Container(
                      //   margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      //   padding: EdgeInsets.only(left: 12.0, right: 12.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Row(
                      //         children: [
                      //           Row(),
                      //           Column(
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               Text(
                      //                 'Attachments',
                      //                 style: TextStyle(
                      //                   color: AppTheme.brownishGrey,
                      //                   fontWeight: FontWeight.w400,
                      //                   fontSize: 15,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //       // Column(
                      //       //   mainAxisAlignment: MainAxisAlignment.start,
                      //       //   crossAxisAlignment: CrossAxisAlignment.start,
                      //       //   children: [
                      //       //     Text(
                      //       //       'You Got',
                      //       //       style: TextStyle(
                      //       //         color: Colors.black,
                      //       //         fontWeight: FontWeight.w500,
                      //       //         fontSize: 18,
                      //       //       ),
                      //       //     ),
                      //       //   ],
                      //       // ),
                      //     ],
                      //   ),
                      // ),
                      // Divider(),
                      // Container(
                      //   margin: EdgeInsets.only(left: 10, top: 10, bottom: 20),
                      //   padding: EdgeInsets.only(left: 12.0, right: 12.0),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         'Details',
                      //         style: TextStyle(
                      //           color: AppTheme.brownishGrey,
                      //           fontWeight: FontWeight.w400,
                      //           fontSize: 15,
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: 5,
                      //       ),
                      //       Text(
                      //         '${widget.suspenseData.message}',
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //           fontWeight: FontWeight.w400,
                      //           fontSize: 13,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    // padding: ,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: AppTheme.coolGrey, width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: ListTile(
                            dense: true,
                            leading: widget.suspenseData.cardImage != null &&
                                    widget.suspenseData.cardImage!.isNotEmpty
                                ? Image.network(
                                    '${widget.suspenseData.cardImage.toString()}',
                                  )
                                : Container(
                                    width: 10,
                                  ),
                            title: Text(
                                '${widget.suspenseData.paymentMethod}'), // endingWith
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('UL Transaction ID'),
                              Text('${widget.suspenseData.urbanledgerId}'
                                  .toLowerCase()),
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Payment Transaction ID'),
                              Text('${widget.suspenseData.transactionId}'
                                  .toLowerCase()),
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('From: ${widget.suspenseData.from}'),
                              Text('${widget.suspenseData.fromEmail}'),
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.suspenseData.status == 0
                                        ? 'Transaction Failed'
                                        : 'Transaction Successful',
                                  ),
                                  SizedBox(width: 5),
                                  Image.asset(
                                    widget.suspenseData.status == 0
                                        ? AppAssets.transactionFailed
                                        : AppAssets.transactionSuccess,
                                    height: 15,
                                  )
                                ],
                              ),
                              widget.suspenseData.createdAt != null
                                  ? Text(
                                      "${DateFormat('dd MMM yyyy | hh:mm aa').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.suspenseData.createdAt.toString()))}")
                                  : Text(''),
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 25, bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Payment Method'),
                              Text('${widget.suspenseData.paymentMethod}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void ledgerBussinessModelBottomSheet(
      BuildContext context, List<SuspenseData>? data2) {
    // bool _value = false;
    int val = -1;
    String? Bid;

    loading == true
        ? CircularProgressIndicator()
        : showModalBottomSheet(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return Container(
                  // height: 360,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  constraints: BoxConstraints(maxHeight: 400),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: Provider.of<BusinessProvider>(context,
                                listen: false)
                            .businesses
                            .length,
                        itemBuilder: (BuildContext context, int index) {
                          return RadioListTile(
                            value: index,
                            groupValue: val,
                            onChanged: (value) {
                              setState(() {
                                val = value as int;
                                Bid = Provider.of<BusinessProvider>(context,
                                        listen: false)
                                    .businesses[index]
                                    .businessId;
                              });
                              debugPrint(
                                  'Check this Business ID: ' + Bid.toString());
                            },
                            title: CustomText(
                              Provider.of<BusinessProvider>(context,
                                      listen: false)
                                  .businesses[index]
                                  .businessName,
                              bold: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                              size: 18,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: FutureBuilder<int>(
                              future: repository.queries.getCustomerCount(
                                  Provider.of<BusinessProvider>(context,
                                          listen: false)
                                      .businesses[index]
                                      .businessId),
                              builder: (context, snapshot) {
                                return CustomText(
                                  '${snapshot.data} ${snapshot.data == 1 ? 'Customer' : 'Customers'}',
                                  bold: FontWeight.w400,
                                  color: AppTheme.brownishGrey,
                                  size: 14,
                                );
                              },
                            ),
                            toggleable: true,
                            controlAffinity: ListTileControlAffinity.trailing,
                          );
                        },
                      ).flexible,
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppTheme.electricBlue,
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            List<String>? transactionIDS = [];
                            Repository _repository = Repository();

                            if (data2 != null && data2.isNotEmpty) {
                              debugPrint('data2' + data2.length.toString());
                              for (int i = 0; i < data2.length; i++) {
                                // await _repository.queries.checkCustomerAdded(
                                //     data2[i].fromCustId?.mobileNo, Bid!); //
                                CustomerModel _customerModel = CustomerModel();
                                _customerModel.customerId = Uuid().v1();
                                _customerModel.businessId =
                                    Provider.of<BusinessProvider>(context,
                                            listen: false)
                                        .selectedBusiness
                                        .businessId;
                                _customerModel.chatId =
                                    data2[i].fromCustId!.chatId;
                                _customerModel.name = data2[i].from;
                                _customerModel.ulId = data2[i].fromCustId!.id;
                                _customerModel.mobileNo =
                                    data2[i].fromMobileNumber;
                                _customerModel.businessId = Bid!; //BusinessID

                                _customerModel.isChanged = true;
                                _customerModel.isDeleted = false;

                                String? checkCustomer = await _repository
                                    .queries
                                    .checkCustomerAddedForSuspense(
                                        data2[i].fromMobileNumber, Bid!);
                                if (checkCustomer!.isEmpty) {
                                  // _customerModel.customerId = checkCustomer;
                                  await _repository.queries
                                      .insertCustomer(_customerModel);
                                } else {
                                  _customerModel.customerId = checkCustomer;
                                }

                                final previousBalance = (await repository
                                    .queries
                                    .getPaidMinusReceived(
                                        _customerModel.customerId!));
                                TransactionModel _transactionModel =
                                    TransactionModel();
                                await BlocProvider.of<LedgerCubit>(context)
                                    .addLedger(
                                        _transactionModel
                                          ..transactionId = Uuid().v1()
                                          ..amount = double.parse(
                                              data2[i].amount.toString())
                                          ..transactionType =
                                              TransactionType.Receive
                                          ..customerId =
                                              _customerModel.customerId
                                          ..date = data2[i].createdAt != null
                                              ? data2[i].createdAt
                                              : DateTime.now()
                                          ..balanceAmount = (previousBalance +
                                              double.parse(
                                                  data2[i].amount.toString()))
                                          ..isChanged = true
                                          ..details = ''
                                          ..isDeleted = false
                                          ..business = Bid! //todoadd column
                                          ..createddate = DateTime.now(),
                                        () async {
                                  await Repository()
                                      .queries
                                      .updateIsMovedOffline(data2[i]);
                                }, context);
                              }
                            }
                            await SuspenseAccountApi.suspenseAccountApi
                                .removeFromSuspenseEntry(
                                    TransctionIDS: transactionIDS)
                                .then((value) {
                              debugPrint('delete' + value.toString());
                              if (value == true) {
                                setState(() {
                                  loading = false;
                                });
                                'Selected transaction moved\nsuccessfully!'
                                    .showSnackBar(context);
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(
                                    context, AppRoutes.suspenseAccountRoute);
                              }
                            });
                            Provider.of<BusinessProvider>(context,
                                    listen: false)
                                .updateSelectedBusiness();
                            debugPrint('Ht5');
                          },
                          child: CustomText(
                            'Move'.toUpperCase(),
                            color: Colors.white,
                            size: (18),
                            bold: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
            });
  }
  ledgerBussinessModelSelectionBottomSheet(BuildContext context, List<SuspenseData> suspenseData) {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          return Container(
            color: Color(0xFF737373), //could change this to Color(0xFF737373),

            height: MediaQuery.of(context).size.height * 0.17,
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
                  GestureDetector(
                    onTap: () {
                      ledgerBussinessModelBottomSheet(context, suspenseData);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 40.0,
                        left: 40.0,
                        right: 40.0,
                        bottom: 10,
                      ),
                      child: Text(
                        'Business',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.electricBlue,
                            fontFamily: 'SFProDisplay',
                            fontSize: 22,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.w700,
                            height: 1),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.suspenseCustomerAccountRoute,
                          arguments: suspenseData);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text(
                        'Customer',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.electricBlue,
                            fontFamily: 'SFProDisplay',
                            fontSize: 22,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.w700,
                            height: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

}
