import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/screens/AddBankAccount/user_bank_account_provider.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';

import 'add_bank_account.dart';

class ProfileBankAccount extends StatefulWidget {
  @override
  _ProfileBankAccountState createState() => _ProfileBankAccountState();
}

class _ProfileBankAccountState extends State<ProfileBankAccount> {
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
                    "Bank Account Cannot be Deleted. \nPlease Contact Customer Care.",
                    color: AppTheme.tomato,
                    bold: FontWeight.w500,
                    size: 18,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NewCustomButton(
                            onSubmit: () {
                              Navigator.of(context).pop();
                            },
                            text: 'OKAY',
                            textSize: 20,
                            textColor: Colors.white),
                      ]),
                ),
              ],
            ),
          ),
      barrierDismissible: false,
      context: context);

  TextEditingController _accountHolderName = TextEditingController();
  TextEditingController _ibanNumber = TextEditingController();
  final GlobalKey<State> key = GlobalKey<State>();

  bool _switchValue = true;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getBank();
  }

  getBank() async {
    // await CustomSharedPreferences.remove('isKYC');
    await CustomSharedPreferences.setBool('isBankAccount', false);
    await Provider.of<UserBankAccountProvider>(context, listen: false)
        .getUserBankAccount()
        .timeout(Duration(seconds: 30), onTimeout: () {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop(true);
    }).then((value) {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.paleGrey,
        body: SingleChildScrollView(
          child: Column(children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: deviceHeight * 0.15,
                  width: double.maxFinite,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: Color(0xfff2f1f6),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/back.png'),
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
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRoutes.mainRoute);
                            }
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        CustomText(
                          'My Bank Account',
                          color: Colors.white,
                          size: 22,
                          bold: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Consumer<UserBankAccountProvider>(builder: (context, bank, _) {
              return isLoading == true
                  ? Container()
                  : bank.account.isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                            Image.asset(
                              AppAssets.emptyUserBankAccount,
                              height: MediaQuery.of(context).size.height * 0.35,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                            Text(
                              '\t\t\t\t\t\tNo Bank Account Found.\nPlease Add Your Bank Account.',
                              style: TextStyle(
                                  color: AppTheme.warmGrey,
                                  fontFamily: 'SFProDisplay',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: ListView.builder(
                              itemCount: 1,
                              itemBuilder: (context, int index) {
                                print('qwert');
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 18),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5, color: AppTheme.coolGrey),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: AppTheme.coolGrey),
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            child: Image.asset(
                                                'assets/icons/bankicon.png'),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            '${bank.account[index].selectedBankId.toString()}',
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        thickness: 0,
                                        color: Colors.black38,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 6, 0, 0),
                                            child: Theme(
                                                data: new ThemeData(
                                                  primaryColor:
                                                      AppTheme.coolGrey,
                                                  primaryColorDark:
                                                      AppTheme.electricBlue,
                                                ),
                                                child: TextFormField(
                                                  readOnly: true,
                                                  initialValue: bank
                                                      .account[index]
                                                      .accountHoldersName,
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      color:
                                                          AppTheme.brownishGrey,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  // inputFormatters: [
                                                  //     FilteringTextInputFormatter.allow(RegExp("^[\\p{L} .'-]")),
                                                  //   ],
                                                  //controller: _accountHolderName,
                                                  decoration: InputDecoration(
                                                    prefixIcon: Container(
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      child: Image.asset(
                                                          'assets/icons/usericon.png'),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                              color: AppTheme
                                                                  .coolGrey,
                                                              width: 2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                    ),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                              color: AppTheme
                                                                  .coolGrey,
                                                              width: 2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                              color: AppTheme
                                                                  .coolGrey,
                                                              width: 2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 15),
                                                  ),
                                                )),
                                          ),
                                          Container(
                                            margin:
                                                EdgeInsets.fromLTRB(7, 0, 0, 0),
                                            padding:
                                                EdgeInsets.fromLTRB(4, 0, 4, 0),
                                            child: Text(
                                              'Account Holder Name',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppTheme.electricBlue,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Stack(
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 6, 0, 0),
                                              child: TextFormField(
                                                readOnly: true,
                                                initialValue: bank
                                                    .account[index].ibannNumber
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    color:
                                                        AppTheme.brownishGrey,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp("[0-9]")),
                                                ],
                                                //controller: _ibanNumber,
                                                decoration: InputDecoration(
                                                  prefixIcon: Container(
                                                    padding: EdgeInsets.all(15),
                                                    child: Image.asset(
                                                      AppAssets.ibanIcon,
                                                      height: 30,
                                                    ),
                                                  ),
                                                  // prefixText: 'AE',
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color:
                                                            AppTheme.coolGrey,
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                  ),
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color:
                                                            AppTheme.coolGrey,
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color:
                                                            AppTheme.coolGrey,
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 15),
                                                ),
                                              )),
                                          Container(
                                            margin:
                                                EdgeInsets.fromLTRB(7, 0, 0, 0),
                                            padding:
                                                EdgeInsets.fromLTRB(4, 0, 4, 0),
                                            child: Text(
                                              'IBAN Number',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppTheme.electricBlue,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Divider(
                                        thickness: 0,
                                        color: Colors.black38,
                                      ),
                                      SizedBox(
                                        height: 1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              await showBankAccountDialog();
                                            },
                                            // onTap: () async {
                                            //   await bank.deleteUserBankAccount(
                                            //       bank.account[index].id.toString());
                                            // },
                                            child: InkWell(
                                              // onTap: _deleteCardPopUp(_index!),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/Delete-01.png',
                                                    height: 22,
                                                    color: AppTheme.coolGrey,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Delete'.toUpperCase(),
                                                    style: TextStyle(
                                                        color:
                                                            AppTheme.coolGrey,
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Default',
                                                style: TextStyle(
                                                    color: Color(0xff666666),
                                                    fontSize: 17),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Transform.scale(
                                                scale: 0.7,
                                                child: CupertinoSwitch(
                                                  trackColor: AppTheme.coolGrey,
                                                  activeColor:
                                                      AppTheme.electricBlue,
                                                  value: _switchValue,
                                                  onChanged: (bool value) {
                                                    // setState(() {
                                                    //   _switchValue = value;
                                                    // });
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }),
                        );
            }),
          ]),
        ),

        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Consumer<UserBankAccountProvider>(builder: (context, bank, _) {
            return bank.account.isEmpty
                ? NewCustomButton(
                    onSubmit: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddBankAccount()));
                    },
                    text: 'Add Bank Account'.toUpperCase(),
                    textSize: 20,
                    textColor: Colors.white,
                    backgroundColor: AppTheme.electricBlue,
                  )
                : NewCustomButton(
                    onSubmit: () {
                      // if(validate()){

                      // }
                      debugPrint(_ibanNumber.text);
                    },
                    text: 'Add Bank Account'.toUpperCase(),
                    textSize: 17,
                    fontWeight: FontWeight.bold,
                    textColor: AppTheme.coolGrey,
                    backgroundColor: AppTheme.disabledColor,
                  );
          }),
        ),
        // bottomSheet: Container(
        //   margin: EdgeInsets.symmetric(horizontal:20),
        //   child: NewCustomButton(
        //     onSubmit: () => null,
        //     text: 'Add Bank Account'.toUpperCase(),
        //     textSize: 20,
        //     textColor: Colors.white
        //   ),
        // ),
      ),
    );
  }

  bool validate() {
    if (_accountHolderName.text.isEmpty) {
      _showError('Account Holder Name is empty.');
      return false;
    } else if (_ibanNumber.text.length > 20) {
      _showError('IBAN allows up to 20 characters.');
      return false;
    } else {
      return true;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppTheme.tomato,
      content: Text(message, textAlign: TextAlign.center),
    ));
  }
}

class _index {}
