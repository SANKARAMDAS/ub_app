import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/customer_profile_model.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';

class CustomerProfile extends StatefulWidget {
  final CustomerModel customerModel;

  const CustomerProfile({Key? key, required this.customerModel})
      : super(key: key);

  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile>
    with SingleTickerProviderStateMixin {
  bool _switchValue = true;
  // TabController? _tabController;
  bool isSwitched = true;
  String? _country = 'AE';
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _creditLimitController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _emiController = TextEditingController();
  String? flat;
  String? landmark;
  String? pincode;
  String? city;
  String? state;
  String? _countryCode = '+971';
  bool? _isMobileNoValid;
  late BusinessProvider businessProvider;

  @override
  void initState() {
    // _tabController = TabController(length: 2, vsync: this);
    businessProvider = Provider.of<BusinessProvider>(context, listen: false);
    getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // _tabController!.dispose();
    _mobileController.dispose();
    _nameController.dispose();
    _creditLimitController.dispose();
    _interestController.dispose();
    _emiController.dispose();
  }

  getData() async {
    //   debugPrint('uuuid ' + widget.customerModel.customerId.toString());
    //   String data = await repository.customerApi
    //       .getCustomerDetails(widget.customerModel.customerId);
    //   var data1 = jsonDecode(data);
    //   debugPrint('qwerty');
    //   debugPrint((data1)['message']);
    //   debugPrint((data1)['status'].toString());
    // if ((data1)['status'] == true) {
    //   Navigator.of(context).pop();
    //   _nameController.text = (data1)['customerProfile']['name'];
    //   _mobileController.text = (data1)['customerProfile']['mobileNo'];
    //   _creditLimitController.text =
    //       (data1)['customerProfile']['credit']['creditLimit'].toString();
    //   _interestController.text =
    //       (data1)['customerProfile']['credit']['interest'].toString();
    //   _emiController.text =
    //       (data1)['customerProfile']['credit']['emi'].toString();
    //   setState(() {
    //     flat = (data1)['customerProfile']['address']['flatBuildingHouse']??'';
    //     landmark = (data1)['customerProfile']['address']['landmark']??'';
    //     pincode = (data1)['customerProfile']['address']['pincode']??'';
    //     city = (data1)['customerProfile']['address']['city']??'';
    //     state = (data1)['customerProfile']['address']['state']??'';
    //     isSwitched = (data1)['customerProfile']['sendFreeSms']??'';
    //   });
    // } else {
    Navigator.of(context).pop();
    debugPrint('else');
    _nameController.text = widget.customerModel.name!;
    _mobileController.text = widget.customerModel.mobileNo!;
    flat = '';
    landmark = '';
    pincode = '';
    city = '';
    state = '';
    isSwitched = true;
    // }
  }

  Future<void> deleteCustomer() async {
    final apiResponse = await (repository.customerApi
        .deletedCustomer(widget.customerModel.customerId!,
            businessProvider.selectedBusiness.businessId)
        .catchError((e) {
      debugPrint(e);
      return false;
    }));
    if (apiResponse) {
      await repository.queries.deleteCustomer(widget.customerModel.customerId!,
          businessProvider.selectedBusiness.businessId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.paleGrey,
        appBar: AppBar(
          title: Text('Customer Information'),
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
        bottomSheet: Container(
            color: AppTheme.paleGrey,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: NewCustomButton(
                    onSubmit: () async {
                      final status = await showDeleteConfirmationDialog();
                      if (status ?? false) {
                        final response = await repository.queries
                            .updateCustomerIsDeleted(
                                widget.customerModel.customerId!,
                                1,
                                Provider.of<BusinessProvider>(context,
                                        listen: false)
                                    .selectedBusiness
                                    .businessId);
                        if (response != null) {
                          if (await checkConnectivity) {
                            deleteCustomer();
                          } else {
                          'Please check your internet connection or try again later.'
                              .showSnackBar(context);
                        }

                          BlocProvider.of<ContactsCubit>(context)
                              .deleteContact(widget.customerModel.customerId!);
                          Navigator.of(context)..pop()..pop();
                        }
                      }
                    },
                    prefixImage: AppAssets.deleteIcon,
                    prefixImageColor: Colors.white,
                    imageSize: 20,
                    text: 'DELETE',
                    textColor: Colors.white,
                    textSize: 18,
                    backgroundColor: AppTheme.tomato,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                Expanded(
                  flex: 1,
                  child: NewCustomButton(
                    onSubmit: () async {
                      debugPrint(widget.customerModel.customerId);
                      if (_nameController.text.isNotEmpty) {
                        final Address address = Address(
                            flatBuildingHouse: '$flat',
                            landmark: '$landmark',
                            pincode: '$pincode',
                            city: '$city',
                            state: '$state');
                        final Credit credit = Credit(
                            creditLimit:
                                int.tryParse(_creditLimitController.text),
                            interest: int.tryParse(_interestController.text),
                            emi: int.tryParse(_emiController.text));
                        final CustomerProfileModel data = CustomerProfileModel(
                          uid: widget.customerModel.customerId,
                          name: '${_nameController.text}',
                          mobileNo: '${_mobileController.text}',
                          credit: credit,
                          address: address,
                          sendFreeSms: _switchValue,
                        );
                        await repository.customerApi.saveUpdateCustomer(data);
                        final customer = CustomerModel()
                          ..businessId = Provider.of<BusinessProvider>(context,
                                  listen: false)
                              .selectedBusiness
                              .businessId
                          ..customerId = widget.customerModel.customerId
                          ..name = '${_nameController.text.trim()}'
                          ..mobileNo = widget.customerModel.mobileNo;
                        await repository.queries
                            .updatePartialCustomerDetails(customer);
                        BlocProvider.of<ContactsCubit>(context).getContacts(
                            Provider.of<BusinessProvider>(context,
                                    listen: false)
                                .selectedBusiness
                                .businessId);
                        Navigator.of(context)..pop()..pop();
                      } else {
                        'Customer Name cannot be empty.'.showSnackBar(context);
                      }
                      // updateCustomer(CustomerModel customerModel)
                    },
                    text: 'SAVE',
                    textColor: Colors.white,
                    textSize: 18,
                  ),
                ),
              ],
            )),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: deviceHeight * 0.3,
                decoration: BoxDecoration(
                    color: Color(0xfff2f1f6),
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage(AppAssets.backgroundImage3),
                        alignment: Alignment.topCenter)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.of(context)..pop();
                    //   },
                    //   child: Container(
                    //     alignment: Alignment.topLeft,
                    //     padding: const EdgeInsets.all(12.0),
                    //     child: Icon(
                    //       Icons.chevron_left,
                    //       color: Colors.white,
                    //       size: 35,
                    //     ),
                    //   ),
                    // ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        widget.customerModel.avatar == null
                            ? Image.asset(
                                'assets/icons/camera.png',
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(95),
                                child: Image.memory(
                                  widget.customerModel.avatar!,
                                  height:
                                      MediaQuery.of(context).size.height * 0.16,
                                  fit: BoxFit.cover,
                                )),
                        Container(
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.04,
                          ),
                          child: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.5),
                              radius:
                                  MediaQuery.of(context).size.height * 0.08),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // SizedBox(height: MediaQuery.of(context).size.height / 25),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 15),
                    //   child: Container(
                    //     // height: 100,
                    //     padding: EdgeInsets.symmetric(vertical: 15),
                    //     width: screenWidth(context),
                    //     decoration: BoxDecoration(
                    //         color: AppTheme.electricBlue,
                    //         borderRadius: BorderRadius.circular(12)),
                    //     child: Center(
                    //       child: Text('CUSTOMER INFORMATION',
                    //           style: TextStyle(
                    //               letterSpacing: 0.5,
                    //               color: Colors.white,
                    //               fontSize: 18,
                    //               fontWeight: FontWeight.w500)),
                    //     ),
                    //   ),
                    // ),
                    // give the tab bar a height [can change hheight to preferred height]
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 15),
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //     color: Colors.grey[300],
                    //     borderRadius: BorderRadius.circular(
                    //       15.0,
                    //     ),
                    //   ),
                    //   child: TabBar(
                    //     controller: _tabController,
                    //     // give the indicator a decoration (color and border radius)
                    //     indicator: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(
                    //         15.0,
                    //       ),
                    //       color: Color(0xff1058ff),
                    //     ),
                    //     labelColor: Colors.white,
                    //     labelStyle: TextStyle(fontSize: 18),
                    //     unselectedLabelColor: Colors.black,
                    //     tabs: [
                    //       // first tab [you can add an icon using the icon property]
                    //       Tab(
                    //         text: 'Customers Profile',
                    //       ),

                    //       // second tab [you can add an icon using the icon property]
                    //       Tab(
                    //         text: 'Credit Settings',
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // tab bar view here
                    Flexible(
                      // child: TabBarView(
                      //   controller: _tabController,
                      //   children: [
                      // first tab bar view widget
                      child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                            buildTextFeild(
                              'assets/icons/business_name.png',
                              'Customer Name',
                              'Customer Name',
                              _nameController,
                            ),
                            buildTextFeild2(
                                'assets/icons/phone_profile.png',
                                'Mobile Number',
                                'Mobile Number',
                                _mobileController),
                            // Padding(
                            //   padding: EdgeInsets.symmetric(horizontal: 15),
                            //   child: Container(
                            //     // height: 100,
                            //     margin: EdgeInsets.only(top: 10),
                            //     padding: EdgeInsets.symmetric(
                            //         horizontal: 5, vertical: 5),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       borderRadius: BorderRadius.circular(12),
                            //       // border: Border.all(
                            //       //     color: AppTheme.coolGrey, width: 0.5)
                            //     ),
                            //     child: ListTile(
                            //       onTap: () {
                            //         Navigator.pushNamed(
                            //             context, AppRoutes.addAddressRoute,
                            //             arguments: AddAddressArgs(
                            //                 customerModel: widget.customerModel,
                            //                 name: _nameController.text,
                            //                 mobile: _mobileController.text,
                            //                 flat: flat,
                            //                 landmark: landmark,
                            //                 pincode: pincode,
                            //                 city: city,
                            //                 state: state,
                            //                 creditLimit: int.tryParse(
                            //                     _creditLimitController.text),
                            //                 emi:
                            //                     int.tryParse(_emiController.text),
                            //                 interest: int.tryParse(
                            //                     _interestController.text),
                            //                 isSwitched: isSwitched));
                            //       },
                            //       dense: true,
                            //       leading: Image.asset(
                            //         'assets/icons/loc.png',
                            //         height: 30,
                            //       ),
                            //       subtitle: Column(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceAround,
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Text(
                            //             'Address',
                            //             style: TextStyle(
                            //                 color: AppTheme.brownishGrey,
                            //                 fontSize: 18,
                            //                 fontWeight: FontWeight.w500),
                            //           ),
                            //           SizedBox(height: 5),
                            //           Text(
                            //             // '${flat ?? ''} ${landmark ?? ''} ${pincode ?? ''} ${city ?? ''} ${state ?? ''}',
                            //             style: TextStyle(
                            //                 color: AppTheme.coolGrey,
                            //                 fontSize: 16,
                            //                 fontWeight: FontWeight.w500),
                            //           ),
                            //         ],
                            //       ),
                            //       trailing: IconButton(
                            //           icon: Icon(
                            //             Icons.arrow_forward_ios,
                            //             color: AppTheme.electricBlue,
                            //           ),
                            //           onPressed: () {}),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(height: 15),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Transaction Sharing',
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500))),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                // height: 100,
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  // border: Border.all(
                                  //     color: AppTheme.coolGrey, width: 0.5)
                                ),
                                child: ListTile(
                                  dense: true,
                                  leading: Image.asset(
                                    'assets/icons/phone_profile.png',
                                    height: 30,
                                  ),
                                  subtitle: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Mobile Number',
                                        style: TextStyle(
                                            color: AppTheme.brownishGrey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Send Free SMS',
                                        style: TextStyle(
                                            color: AppTheme.coolGrey,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  trailing: Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                      trackColor: AppTheme.coolGrey,
                                      activeColor: AppTheme.electricBlue,
                                      value: _switchValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _switchValue = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                // height: 100,
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  // border: Border.all(
                                  //     color: AppTheme.coolGrey, width: 0.5)
                                ),
                                child: ListTile(
                                  dense: true,
                                  leading: Image.asset(
                                    'assets/icons/SMS-01.png',
                                    height: 30,
                                    color: Color(0xff666666),
                                  ),
                                  isThreeLine: false,
                                  title: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'SMS Settings',
                                        style: TextStyle(
                                            color: AppTheme.brownishGrey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Language, Notes, Format and etc ...',
                                        style: TextStyle(
                                            color: AppTheme.coolGrey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppTheme.electricBlue,
                                      ),
                                      onPressed: null),
                                ),
                              ),
                            ),
                          ])),

                      // second tab bar view widget
                      // Column(
                      //   children: [
                      //     // SingleChildScrollView(
                      //     //   child: Column(
                      //     //                  children: [
                      //     //       buildTextFeild(
                      //     //           'assets/icons/Credit-Limit-01.png',
                      //     //           'Credit Limit',
                      //     //           'Credit Limit',
                      //     //           _creditLimitController),
                      //     //       buildTextFeild('assets/icons/Interest-01.png',
                      //     //           'Interest', 'Interest', _interestController),
                      //     //       buildTextFeild('assets/icons/EMI-01.png', 'EMI',
                      //     //           'EMI', _emiController),
                      //     //       Spacer(),
                      //     //       Padding(
                      //     //         padding: EdgeInsets.symmetric(
                      //     //             horizontal: 15, vertical: 15),
                      //     //         child: Row(
                      //     //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     //           mainAxisSize: MainAxisSize.max,
                      //     //           children: [
                      //     //             Expanded(
                      //     //               flex: 1,
                      //     //               child: NewCustomButton(
                      //     //                 onSubmit: () async {
                      //     //                   // final Credit credit = Credit(
                      //     //                   //     creditLimit: int.tryParse(
                      //     //                   //         _creditLimitController.text),
                      //     //                   //     interest: int.tryParse(
                      //     //                   //         _interestController.text),
                      //     //                   //     emi: int.tryParse(
                      //     //                   //         _emiController.text));
                      //     //                   // final CustomerProfileModel data =
                      //     //                   //     CustomerProfileModel(credit: credit);
                      //     //                   await repository.customerApi
                      //     //                       .getCustomerDetails();
                      //     //                 },
                      //     //                 prefixImage: AppAssets.deleteIcon,
                      //     //                 prefixImageColor: Colors.white,
                      //     //                 imageSize: 20,
                      //     //                 text: 'DELETE',
                      //     //                 textColor: Colors.white,
                      //     //                 textSize: 18,
                      //     //                 backgroundColor: AppTheme.tomato,
                      //     //               ),
                      //     //             ),
                      //     //             SizedBox(
                      //     //                 width: MediaQuery.of(context).size.width *
                      //     //                     0.06),
                      //     //             Expanded(
                      //     //               flex: 1,
                      //     //               child: NewCustomButton(
                      //     //                 onSubmit: () async {
                      //     //                   // debugPrint(_nameController.text.toString());
                      //     //                   // debugPrint(widget.customerModel.name);
                      //     //                   debugPrint('${_mobileController.text}');
                      //     //                   debugPrint('${_nameController.text}');
                      //     //                   final Credit credit = Credit(
                      //     //                       creditLimit: int.tryParse(
                      //     //                           _creditLimitController.text),
                      //     //                       interest: int.tryParse(
                      //     //                           _interestController.text),
                      //     //                       emi: int.tryParse(
                      //     //                           _emiController.text));
                      //     //                   final Address address = Address(
                      //     //                     // flatBuildingHouse:
                      //     //                   );
                      //     //                   final CustomerProfileModel data =
                      //     //                       CustomerProfileModel(
                      //     //                         name: '${_nameController.text}',
                      //     //                         mobileNo: '${_mobileController.text}',
                      //     //                         credit: credit,
                      //     //                         address: address,
                      //     //                         sendFreeSms: isSwitched
                      //     //                       );
                      //     //                   await repository.customerApi
                      //     //                       .saveUpdateCustomer(data);
                      //     //                 },
                      //     //                 text: 'SAVE',
                      //     //                 textColor: Colors.white,
                      //     //                 textSize: 18,
                      //     //               ),
                      //     //             ),
                      //     //           ],
                      //     //         ),
                      //     //       ),
                      //     //     ],
                      //     //   ),
                      //     // )
                      //   ],
                      // )
                      //   ],
                      // ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> showDeleteConfirmationDialog() async => await showDialog(
      builder: (context) => Dialog(
            insetPadding:
                EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.77),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15.0,
                    bottom: 5,
                  ),
                  child: Text(
                    'Are you sure you want to delete this customer?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.tomato,
                      fontFamily: 'SFProDisplay',
                      fontSize: 18,
                      // letterSpacing:
                      //     0 /*percentages not used in flutter. defaulting to zero*/,
                      // fontWeight: FontWeight.bold,
                      // height: 1
                    ),
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              primary: AppTheme.electricBlue,
                            ),
                            child: CustomText(
                              'CONFIRM',
                              color: Colors.white,
                              size: (18),
                              bold: FontWeight.w500,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              'Customer deleted successfully'
                                  .showSnackBar(context);
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

  // bool validate() {
  //   if(){
  //     return false;
  //   }else{
  //     return true;
  //   }
  // }

  Widget buildTextFeild(String imageUrl, String title, String subTitle,
      TextEditingController ctrl) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        // height: 100,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: AppTheme.coolGrey, width: 0.5)
        ),
        child: ListTile(
          dense: true,
          leading: Image.asset(
            // 'assets/icons/user.png',
            imageUrl,
            height: 30,
          ),
          title: Text(
            // 'User name',
            title,
            style: TextStyle(
                color: AppTheme.brownishGrey,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          subtitle: Container(
            height: 35,
            width: double.infinity,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: TextField(
              controller: ctrl,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                hintText: subTitle,
                alignLabelWithHint: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 11, top: 11, right: 15),
              ),
            ),
          ),
          // trailing: IconButton(
          //   icon: Icon(
          //     Icons.arrow_forward_ios,
          //     color: AppTheme.electricBlue,
          //   ),
          //   onPressed: null),
        ),
      ),
    );
  }

  Widget buildTextFeild2(String imageUrl, String title, String subTitle,
      TextEditingController ctrl) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        // height: 100,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: AppTheme.coolGrey, width: 0.5)
        ),
        child: ListTile(
          dense: true,
          leading: Image.asset(
            // 'assets/icons/user.png',
            imageUrl,
            height: 30,
          ),
          title: Text(
            // 'User name',
            title,
            style: TextStyle(
                color: AppTheme.brownishGrey,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          subtitle: Container(
            height: 35,
            width: double.infinity,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            child: TextField(
              readOnly: true,
              controller: ctrl,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                hintText: subTitle,
                alignLabelWithHint: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 11, top: 11, right: 15),
              ),
            ),
          ),
          // trailing: IconButton(
          //   icon: Icon(
          //     Icons.arrow_forward_ios,
          //     color: AppTheme.electricBlue,
          //   ),
          //   onPressed: null),
        ),
      ),
    );
  }
}
