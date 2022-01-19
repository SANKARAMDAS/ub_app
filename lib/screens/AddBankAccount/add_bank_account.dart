import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:iban/iban.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/AddBankAccount/add_bank_provider.dart';
import 'package:urbanledger/screens/AddBankAccount/band_added_successfully.dart';
import 'package:urbanledger/screens/AddBankAccount/user_bank_account_provider.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';

class AddBankAccount extends StatefulWidget {
  @override
  _AddBankAccountState createState() => _AddBankAccountState();
}

class _AddBankAccountState extends State<AddBankAccount> {
  @override
  void initState() {
    super.initState();
    getSortingList();
  }

  getSortingList() async {
    await Provider.of<AddBankProvider>(context, listen: false).sortedBankName();
    await Provider.of<AddBankProvider>(context, listen: false).getListofBank();
  }

  TextEditingController searchController = TextEditingController();
  TextEditingController accountHolderFullname = TextEditingController();
  TextEditingController selectBank = TextEditingController();

  TextEditingController iBanNumber = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
  }

  late String bankId;

  @override
  void dispose() {
    searchController.dispose();
    accountHolderFullname.dispose();
    iBanNumber.dispose();
    selectBank.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        bottomSheet: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Container(
                      width: double.infinity,
                      color: Color(0xFFF2F1F6),
                      padding: const EdgeInsets.all(20.0),
                      // margin: EdgeInsets.symmetric(
                      //   horizontal: 15,
                      // ),
                      child: NewCustomButton(
                        text: 'Add Bank Account'.toUpperCase(),
                        textColor: Colors.white,
                        onSubmit: () async {
                          //_formKey.currentState?.save();
                          if (_formKey.currentState?.fields['name'] != null &&
                              _formKey.currentState?.fields['bank'] != null &&
                              _formKey.currentState?.fields['iban'] != null &&
                              _formKey.currentState?.saveAndValidate() == true) {
                            CustomLoadingDialog.showLoadingDialog(context);
                            // print(_formKey.currentState!.value);
                            Map bank = {
                              "account_holders_name":
                                  "${accountHolderFullname.text}",
                              "selected_bank_id": "${selectBank.text}",
                              "ibann_number": "AE${iBanNumber.text}",
                              "isdefault": "1"
                            };
                            await Provider.of<UserBankAccountProvider>(context,
                                    listen: false)
                                .addUserBankAccount(bank, context)
                                .then((value) {
                              setState(() {
                                Repository().hiveQueries.insertUserData(
                                    Repository()
                                        .hiveQueries
                                        .userData
                                        .copyWith(bankStatus: true));
                              });
                              Navigator.of(context).pop();
                            }).catchError((e) {
                              'Something went wrong, Please try again later.'.showSnackBar(context);
                              Navigator.of(context).pop();
                            });
    
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BankAddedSuccessfully(
                                          model: bank,
                                        )));
                          } else {
                            print("validation failed");
                          }
                        },
                        backgroundColor: AppTheme.electricBlue,
                        textSize: 14,
                      )
                      // : NewCustomButton(
                      //     text: 'Add Bank Account'.toUpperCase(),
                      //     textColor: Colors.white,
                      //     onSubmit: () async {
                      //       // _formKey.currentState!.save();
                      //       if (_formKey.currentState?.saveAndValidate() ?? false) {
                      //         //print(_formKey.currentState!.value);
                      //         Map bank = {
                      //           "account_holders_name":
                      //               "${accountHolderFullname.text}",
                      //           "selected_bank_id": "${selectBank.text}",
                      //           "ibann_number": "${iBanNumber.text}",
                      //           "isdefault": "1"
                      //         };
                      //         await Provider.of<UserBankAccountProvider>(context,
                      //                 listen: false)
                      //             .addUserBankAccount(bank);
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => BankAddedSuccessfully(
                      //                       model: bank,
                      //                     )));
                      //       } else {
                      //         print("validation failed");
                      //       }
                      //     },
                      //     backgroundColor: AppTheme.greyish,
                      //     textSize: 14,
                      //   ),
                      )),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xFFE5E5E5),
            child: Stack(
              children: [
                // AppAssets.backgroundImage.background,
                // (deviceHeight * 0.025).heightBox,
                Container(
                  //padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    height: deviceHeight,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      color: Color(0xfff2f1f6),
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage('assets/images/back.png'),
                          alignment: Alignment.topCenter),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          // onTap: ,
                          child: Container(
                            margin: EdgeInsets.only(top: 40, bottom: 0),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.chevron_left,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add Bank Account',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                        (deviceHeight * 0.12).heightBox,
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: FormBuilder(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Image.asset(
                                          'assets/images/accountholder.png',
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.only(top: 12, left: 10),
                                          child: FormBuilderTextField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            style: TextStyle(
                                                fontFamily: 'SFProDisplay',
                                                fontSize: 20,
                                                color: Color(0xff666666),
                                                fontWeight: FontWeight.w400),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              // labelText: 'Account Holder Full Name',
                                              // labelStyle: TextStyle(
                                              //     fontWeight: FontWeight.normal,
                                              //     fontSize: 18),
                                              // errorText:
                                              //     'Please enter the full name of the account holder',
                                              errorStyle:
                                                  TextStyle(color: Colors.red),
                                              prefixIcon: Image.asset(
                                                'assets/icons/usericon.png',
                                                scale: 1.1,
                                              ),
                                              hintText:
                                                  'Account Holder Full Name',
                                              hintStyle: TextStyle(
                                                  fontFamily: 'SFProDisplay',
                                                  fontSize: 20,
                                                  color: Color(0xffD3D3D3),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            controller: accountHolderFullname,
                                            validator:
                                                FormBuilderValidators.compose([
                                              FormBuilderValidators.required(
                                                  context),
                                              FormBuilderValidators.min(
                                                  context, 3),
                                              (val) {
                                                if (val!.length > 3) {
                                                  return null;
                                                }
                                                return 'Please enter your name';
                                              }
                                            ]),
                                            name: 'name',
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Stack(
                                      children: [
                                        Image.asset(
                                          'assets/images/selectbank.png',
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.only(top: 13, left: 10),
                                          child: FormBuilderTextField(
                                            style: TextStyle(
                                                fontFamily: 'SFProDisplay',
                                                fontSize: 20,
                                                color: Color(0xff666666),
                                                fontWeight: FontWeight.w400),
                                            name: 'bank',
                                            onTap: () async {
                                              await _showMyDialog();
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                              suffixIcon: Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 37,
                                                color: AppTheme.electricBlue,
                                              ),
                                              hintText: 'Please select your Bank',
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              prefixIcon: Image.asset(
                                                'assets/images/bankk.png',
                                                scale: 2,
                                              ),
                                              // errorText:
                                              //     'Please select your bank name before entering your IBAN number',
                                              errorStyle:
                                                  TextStyle(color: Colors.red),
                                              hintStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xffD3D3D3),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            readOnly: true,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator:
                                                FormBuilderValidators.compose([
                                              FormBuilderValidators.required(
                                                  context),
                                            ]),
                                            controller: selectBank,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Stack(
                                      children: [
                                        Image.asset(
                                          'assets/images/ibannumber.png',
                                          fit: BoxFit.fitWidth,
                                          scale: 0.1,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 12),
                                          child: FormBuilderTextField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            style: TextStyle(
                                                fontFamily: 'SFProDisplay',
                                                fontSize: 20,
                                                color: Color(0xff666666),
                                                fontWeight: FontWeight.w400),
                                            name: 'iban',
                                            decoration: InputDecoration(
                                              prefixIcon: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    20, 10, 10, 10),
                                                child: Image.asset(
                                                  AppAssets.ibanIcon,
                                                  height: 30,
                                                ),
                                              ),
                                              prefixText: 'AE ',
    
                                              prefixStyle: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'SFProDisplay',
                                                  color: AppTheme.brownishGrey),
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              // errorText:
                                              //     'Only the use of numbers from 0 to 9 and upper case\nEnglish characters from A to Z is permitted',
                                              errorStyle:
                                                  TextStyle(color: Colors.red),
                                              hintText: '',
                                              hintStyle: TextStyle(
                                                  fontFamily: 'SFProDisplay',
                                                  fontSize: 20,
                                                  color: Color(0xffD3D3D3),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            keyboardType: TextInputType.phone,
                                            validator:
                                                FormBuilderValidators.compose([
                                              (val) {
                                                if (val!.length < 21) {
                                                  return 'The total length of IBAN number should be 23 characters';
                                                }
                                                return null;
                                              },
                                              (val) {
                                                if (selectBank.text.isEmpty) {
                                                  return 'Please enter a valid IBAN number';
                                                }
                                                if (!isValid('AE' + val!)) {
                                                  return 'Please double check and enter a correct IBAN';
                                                }
    
                                                // if (selectBank.text.isEmpty) {
                                                //   return 'Please select a Bank to proceed';
                                                // }
                                                // ignore: dead_code
                                                return null;
                                              },
                                              FormBuilderValidators.required(
                                                  context),
                                              (val) {
                                                if (isValid('AE' + val!)) {
                                                  print('$val is a valid iban');
                                                } else {
                                                  print(
                                                      '$val is not a valid iban');
                                                  return 'Only the use of numbers from 0 to 9 and upper case English characters \nfrom A to Z is permitted';
                                                }
                                              },
    
                                              // FormBuilderValidators.maxLength(
                                              //     context, 23),
                                            ]),
                                            controller: iBanNumber,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,

      // user must tap button!
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(13),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          'Select Bank',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 20,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          size: 27,
                          color: AppTheme.electricBlue,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Form(
                          child: new Column(
                            //mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: <Widget>[
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                child: Card(
                                  color: Color(0xffE6E5E5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/icons/search.png',
                                          color: Color(0xffB6B6B6),
                                          height: 19,
                                          scale: 1.4,
                                        ),
                                        10.0.widthBox,
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: TextFormField(
                                            controller: searchController,
                                            decoration: InputDecoration(
                                                hintText: 'Search by Bank Name',
                                                hintStyle: TextStyle(
                                                    color: Color(0xffB6B6B6),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18),
                                                focusedBorder: InputBorder.none,
                                                enabledBorder:
                                                    InputBorder.none),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 15),
                                child: Text(
                                  'Popular Bank',
                                  style: TextStyle(
                                      color: Color(0xffB6B6B6),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                ),
                              ),
                              Container(
                                height: 90,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 26,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.3),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Abu Dhabi',
                                              style: TextStyle(
                                                  color: Color(0xff666666),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'SFProDisplay',
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                              Divider(
                                thickness: 1,
                                indent: 10,
                                endIndent: 15,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 7),
                                child: Text(
                                  'All Other Bank',
                                  style: TextStyle(
                                      color: Color(0xffB6B6B6),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'SFProDisplay',
                                      fontSize: 13),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Consumer<AddBankProvider>(
                                  builder: (context, bank, child) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.9,
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      thickness: 1,
                                      indent: 70,
                                      endIndent: 15,
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                    itemCount: 20,
                                    itemBuilder: (context, int index) {
                                      return ListTile(
                                        onTap: () {
                                          selectBank.text =
                                              bank.bank[index].name.toString();
                                          bankId =
                                              bank.bank[index].id.toString();
                                          Navigator.pop(context);
                                        },
                                        contentPadding: EdgeInsets.all(5),
                                        leading: Image.asset(
                                          'assets/icons/bank01.png',
                                          height: 50,
                                        ),
                                        title: Text(
                                          bank.bank[index].name!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xff666666)),
                                        ),
                                        trailing: SizedBox(
                                          width: 10,
                                          height: 10,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// AlertDialog(
//         scrollable: true,
//         title: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(),
//             Text('Select Bank'),
//             IconButton(
//               icon: Icon(
//                 Icons.clear,
//                 color: AppTheme.carolinaBlue,
//               ),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ],
//         ),
//         content: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Form(
//               child: new Column(
//                 mainAxisSize: MainAxisSize.max,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       margin: EdgeInsets.only(
//                         top: 5,
//                         bottom: 5,
//                       ),
//                       elevation: 3,
//                       child: Container(
//                         // width: MediaQuery.of(context).size.width * 0.92,
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(left: 15.0),
//                               child: Image.asset(
//                                 'assets/icons/search.png',
//                                 color: AppTheme.brownishGrey,
//                                 height: 20,
//                                 scale: 1.4,
//                               ),
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width * 0.7,
//                               child: TextFormField(
//                                 // textAlignVertical: TextAlignVertical.center,
//                                 //controller: _searchController,
//                                 onChanged: (value) {},
//                                 style: TextStyle(
//                                   fontSize: 17,
//                                   color: AppTheme.brownishGrey,
//                                 ),
//                                 cursorColor: AppTheme.brownishGrey,
//                                 decoration: InputDecoration(
//                                     // contentPadding: EdgeInsets.only(top: 15),
//                                     border: InputBorder.none,
//                                     hintText: 'Search by Bank Name',
//                                     hintStyle: TextStyle(
//                                         color: Color(0xffb6b6b6),
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.w500)),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         actions: <Widget>[],
//       )
