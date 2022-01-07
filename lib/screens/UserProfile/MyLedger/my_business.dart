import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_popup.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';

class MyBusinessScreen extends StatefulWidget {
  const MyBusinessScreen({Key? key}) : super(key: key);

  @override
  _MyBusinessScreenState createState() => _MyBusinessScreenState();
}

class _MyBusinessScreenState extends State<MyBusinessScreen> {
  final repository = Repository();
  bool isEmiratesIdDone = false;
  bool isTradeLicenseDone = false;
  bool status = false;
  bool isPremium = false;
  bool isLoading = false;
  bool loading = false;
  final GlobalKey<State> key = GlobalKey<State>();

  modalSheet() {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          return Container(
            color: Color(0xFF737373), //could change this to Color(0xFF737373),
            height: (isPremium == false)
                ? MediaQuery.of(context).size.height * 0.25
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
                    child: (isPremium == false)
                        ? Text(
                            'Please upgrade to UrbanLedger Premium to add more Ledgers.',
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
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: (status == true || isPremium == false)
                        ? NewCustomButton(
                            onSubmit: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.urbanLedgerPremiumRoute);
                              CustomLoadingDialog.showLoadingDialog(
                                  context, key);
                            },
                            textColor: Colors.white,
                            text: 'Upgrade Now',
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

  // Future getKyc() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await KycAPI.kycApiProvider.kycCheker().catchError((e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     'Something went wrong. Please try again later.'.showSnackBar(context);
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

  @override
  void initState() {
    // getKyc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
        child: ElevatedButton(
          child: CustomText(
            'ADD NEW LEDGER',
            color: Colors.white,
            size: (18),
            bold: FontWeight.w500,
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          // onPressed: isPremium == false
          //     ? () {
          //         modalSheet();
          //       }
          //     : () async {
          //         Navigator.of(context)
          //             .pushNamed(AppRoutes.addLedgerRoute);
          //       }
          onPressed: () async {
                  if (await kycAndPremium(context)) {
                    CustomLoadingDialog.showLoadingDialog(context, key);
                    Navigator.of(context)
                        .popAndPushNamed(AppRoutes.addLedgerRoute);
                  }
                },
        ),
      ),
      appBar: AppBar(
        title: Text('My Ledger'),
        // backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 22,
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(children: [
                Container(
                  clipBehavior: Clip.none,
                  height: deviceHeight * 0.06,
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(AppAssets.backgroundImage),
                          alignment: Alignment.topCenter)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      (deviceHeight * 0.1).heightBox,
                      Consumer<BusinessProvider>(
                        builder: (context, value, _) {
                          return ListView.builder(
                            itemCount: value.businesses.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  if (value.businesses[index].businessId !=
                                      Provider.of<BusinessProvider>(context,
                                              listen: false)
                                          .selectedBusiness
                                          .businessId) {
                                    Provider.of<BusinessProvider>(context,
                                            listen: false)
                                        .updateSelectedBusiness(index: index);
                                    BlocProvider.of<ContactsCubit>(context)
                                        .getContacts(
                                            Provider.of<BusinessProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedBusiness
                                                .businessId);
                                    (Provider.of<BusinessProvider>(context,
                                                    listen: false)
                                                .selectedBusiness
                                                .businessName +
                                            ' is now selected as your active ledger')
                                        .showSnackBar(context);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        // color: Colors.white,
                                        border: Border.all(
                                            color: value.businesses[index]
                                                        .businessId ==
                                                    value.selectedBusiness
                                                        .businessId
                                                ? Theme.of(context).primaryColor
                                                : AppTheme.coolGrey),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 4, bottom: 4),
                                      child: Row(
                                        children: [
                                          4.0.widthBox,
                                          Image.asset(
                                            AppAssets.businessNameIcon,
                                            height: 25,
                                            width: 25,
                                          ),
                                          12.0.widthBox,
                                          Container(
                                            width: screenWidth(context) * 0.5,
                                            child: CustomText(
                                              value.businesses[index]
                                                  .businessName,
                                              size: 18,
                                              bold: FontWeight.w500,
                                              color: AppTheme.brownishGrey,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Spacer(),
                                          IconButton(
                                            onPressed: () async {
                                              if (value.businesses[index]
                                                  .deleteAction) {
                                                /* Navigator.of(context).pushNamed(
                                              AppRoutes.deleteLedgerRoute,
                                              arguments:
                                                  value.businesses[index]); */
                                                final status =
                                                    await showDeleteConfirmationDialog(
                                                        value.businesses[index]
                                                            .businessName);
                                                if (status != null) {
                                                  if (status) {
                                                    final bid = value
                                                        .businesses[index]
                                                        .businessId;
                                                    repository.queries
                                                        .updateBusinessIsDeleted(
                                                            value
                                                                .businesses[
                                                                    index]
                                                                .businessId,
                                                            1)
                                                        .then((value1) async {
                                                      Provider.of<
                                                                  BusinessProvider>(
                                                              context,
                                                              listen: false)
                                                          .deleteBusiness(Provider
                                                                  .of<BusinessProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .businesses
                                                              .indexWhere((element) =>
                                                                  element
                                                                      .businessId ==
                                                                  value
                                                                      .businesses[
                                                                          index]
                                                                      .businessId));
                                                      repository.hiveQueries
                                                          .insertSelectedBusiness(
                                                              Provider.of<BusinessProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .businesses
                                                                  .where((element) =>
                                                                      element
                                                                          .deleteAction ==
                                                                      false)
                                                                  .first);
                                                      final selectedBusiness = Provider
                                                              .of<BusinessProvider>(
                                                                  context,
                                                                  listen: false)
                                                          .updateSelectedBusiness();
                                                      BlocProvider.of<
                                                                  ContactsCubit>(
                                                              context)
                                                          .getContacts(
                                                              selectedBusiness
                                                                  .businessId);
                                                      if (await checkConnectivity) {
                                                        final apiResponse =
                                                            await (repository
                                                                .businessApi
                                                                .deleteBusiness(
                                                                    bid,
                                                                    context)
                                                                .catchError(
                                                                    (e) {
                                                          debugPrint(e);
                                                          recordError(
                                                              e,
                                                              StackTrace
                                                                  .current);
                                                          return false;
                                                        }));
                                                        if (apiResponse) {
                                                          await repository
                                                              .queries
                                                              .updateBusinessIsDeleted(
                                                                  bid, 1);
                                                        }
                                                      } else {
                                                        // Navigator.of(context).pop();
                                                        'Please check your internet connection or try again later.'
                                                            .showSnackBar(
                                                                context);
                                                      }
                                                    });
                                                    'Ledger Deleted Successfully'
                                                        .showSnackBar(context);
                                                  }
                                                }
                                              } else {
                                                'Default ledger cannot be deleted'
                                                    .showSnackBar(context);
                                              }
                                            },
                                            icon: Icon(
                                              CupertinoIcons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                          15.0.widthBox,
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  AppRoutes.renameLedgerRoute,
                                                  arguments:
                                                      value.businesses[index]);
                                            },
                                            child: Image.asset(
                                              AppAssets.editIcon,
                                              height: 20,
                                              // width: 25,
                                            ),
                                          ),
                                          15.0.widthBox,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ).flexible,
                    ],
                  ),
                )
              ]),
      ),
    );
  }

  Future<bool?> showDeleteConfirmationDialog(String businessName) async =>
      await showDialog(
          builder: (context) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Dialog(
                    insetPadding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25.0, bottom: 5, left: 20, right: 20),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: 'You are going to delete\n',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.brownishGrey,
                                    height: 1.4,
                                    fontSize: 20),
                                children: [
                                  TextSpan(
                                    text: '‘$businessName’.\n',
                                    style: TextStyle(
                                      color: AppTheme.tomato,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                      text:
                                          'By doing so, you will lose\nall the entries in this ledger.\nAre you ABSOLUTELY sure?')
                                ]),
                          ),
                        ),
                        30.0.heightBox,
                        SizedBox(
                          height: 150,
                          child: Image.asset(AppAssets.deleteLedgerImage),
                        ),
                        30.0.heightBox,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      primary: AppTheme.electricBlue,
                                    ),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(15),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        primary: AppTheme.tomato),
                                    child: CustomText(
                                      'DELETE',
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
                        ),
                        10.0.heightBox
                      ],
                    ),
                  ),
                  25.0.heightBox,
                ],
              ),
          barrierDismissible: false,
          context: context);
}
