import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/chat_module/data/models/message.dart';
import 'package:urbanledger/chat_module/data/repositories/chat_repository.dart';
import 'package:urbanledger/screens/Components/custom_bottom_nav_bar_new.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/TransactionScreens/pay_recieve.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import 'package:uuid/uuid.dart';

class AddCustomerForm extends StatefulWidget {
  final String name;

  const AddCustomerForm({Key? key, required this.name}) : super(key: key);

  @override
  _AddCustomerFormState createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State<AddCustomerForm> {
  String? _country = 'AE';
  String? _countryCode = '+971';
  Repository _repository = Repository();
  final TextEditingController _mobileController = TextEditingController();
  late TextEditingController? _nameController;
  final _customerModel = CustomerModel();
  bool? _isNameValid;
  bool? _isMobileNoValid;
  ChatRepository _chatRepository = ChatRepository();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _nameController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isLoading) return false;
        Navigator.of(context)..pop()..pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.paleGrey,
        appBar: AppBar(
          title: Text('Add New Customer'),
          // leadingWidth: 30,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              onPressed: () {
                if (!isLoading) Navigator.of(context)..pop()..pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                size: 22,
              ),
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        floatingActionButton:  ValueListenableBuilder(
            valueListenable: isCustomerAddedNotifier,
            builder: (context, dynamic value, child) {
              if (Provider.of<BusinessProvider>(context, listen: false)
                  .businesses
                  .isNotEmpty)
                return FutureBuilder<List<CustomerModel>>(
                    future: Repository().queries.getCustomers(
                        Provider.of<BusinessProvider>(context, listen: false)
                            .selectedBusiness
                            .businessId),
                    builder: (context, snapshot) {
                      if (snapshot.data != null)
                        return InkWell(
                          onTap: snapshot.data!.length == 0
                              ? () {}
                              : () async {
                            var anaylticsEvents =
                            AnalyticsEvents(context);
                            await anaylticsEvents.initCurrentUser();
                            await anaylticsEvents.sendRecieveButtonEvent();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PayRequestScreen(),
                            ));
                          }
                          ,
                          child: Image.asset(
                            snapshot.data!.length == 0
                                ? AppAssets.switchGrey
                                : AppAssets.switchGreen,
                            scale: 1,
                            height: 75,
                          ),
                        );

                      return Image.asset(
                        AppAssets.switchGreen,
                        scale: 1,
                        height: 75,
                      );
                    });
              return Image.asset(
                AppAssets.switchGreen,
                scale: 1,
                height: 75,
              );
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomSheet: CustomBottomNavBarNew(),
        extendBody: true,
        body: Column(
          children: [
            Container(
              child: Image.asset(AppAssets.backgroundImage),
            ),
            // SizedBox(height: MediaQuery.of(context).padding.top + appBarHeight),
            (deviceHeight * 0.08).heightBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: Offset(3, 3),
                      blurRadius: 3.0,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  onChanged: (data) {
                    if (_isNameValid == false) {
                      setState(() {
                        _isNameValid = null;
                      });
                    }
                    if (data.length == 1) {
                      setState(() {});
                    } else if (data.length == 0) {
                      setState(() {});
                    }
                  },
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15),
                    hintText: 'Customer Name',
                    hintStyle: TextStyle(
                        color: AppTheme.greyish, fontWeight: FontWeight.w500),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            _isNameValid == null
                ? Container()
                : _isNameValid!
                    ? Container()
                    : const Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 4),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: CustomText(
                              'Please enter a valid Customer Name',
                              color: AppTheme.tomato,
                              size: 14,
                            )),
                      ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 4),
                        child: Container(
                          // padding: EdgeInsets.only(
                          //   left: 5,
                          //   right: 5,
                          // ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: Offset(3, 3),
                                blurRadius: 3.0,
                              )
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: CountryCodePicker(
                            alignLeft: false,
                            dialogSize: Size(screenWidth(context) * 0.9,
                                screenHeight(context) * 0.8),
                            // padding: EdgeInsets.symmetric(horizontal:20),
                            // dialogSize: ,
                            initialSelection: 'AE',
                            textStyle: TextStyle(color: AppTheme.greyish),
                            barrierColor: Colors.black45,
                            // backgroundColor: Colors.black38,
                            searchDecoration: InputDecoration(
                                hintText: "Search",
                                hintStyle: TextStyle(color: AppTheme.greyish)),
                            onChanged: (value) {
                              setState(() {
                                _isNameValid = null;
                                _isMobileNoValid = null;
                              });
                              _country = value.code;
                              _countryCode = value.dialCode;
                              debugPrint(_country);
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 25,
                      )
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 15.0, bottom: 5),
                          child: Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  offset: Offset(3, 3),
                                  blurRadius: 3.0,
                                )
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              controller: _mobileController,
                              keyboardType: TextInputType.phone,
                              onChanged: (data) {
                                if (_isNameValid == false) {
                                  setState(() {
                                    _isNameValid = null;
                                  });
                                }
                                if (_isMobileNoValid == false) {
                                  setState(() {
                                    _isMobileNoValid = null;
                                  });
                                }
                                if (data.length == 1) {
                                  setState(() {});
                                } else if (data.length == 0) {
                                  setState(() {});
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                                hintStyle: TextStyle(
                                    color: AppTheme.greyish,
                                    fontWeight: FontWeight.w500),
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 15),
                                enabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        _isMobileNoValid == null
                            ? Container(
                                height: 25,
                              )
                            : _isMobileNoValid!
                                ? Container(
                                    height: 25,
                                  )
                                : Container(
                                    height: 25,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, top: 4),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: CustomText(
                                            'Please enter a valid Mobile Number',
                                            color: AppTheme.tomato,
                                            size: 14,
                                          )),
                                    ),
                                  ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20, bottom: 120, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  primary: !isLoading ? AppTheme.electricBlue : AppTheme.coolGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _nameController!.text.length != 0
                    ? () async {
                        _isNameValid = FieldValidator.validateName(
                                    _nameController!.text) ==
                                null
                            ? true
                            : false;
                        if (_isNameValid!) {
                          if (_mobileController.text.isNotEmpty) {
                            _isMobileNoValid =
                                await PhoneNumberUtil.isValidPhoneNumber(
                                    phoneNumber:
                                        _countryCode! + _mobileController.text,
                                    isoCode: _country!);
                            setState(() {});
                            if (!_isMobileNoValid!) return;
                          }

                          _customerModel.name = _nameController!.text.trim();
                          if (_mobileController.text.trim().length != 0) {
                            _customerModel.mobileNo =
                                (_countryCode! + _mobileController.text.trim())
                                    .replaceAll('+', '');
                            bool isAdded = await _repository.queries
                                .checkCustomerAdded(
                                    _customerModel.mobileNo,
                                    Provider.of<BusinessProvider>(context,
                                            listen: false)
                                        .selectedBusiness
                                        .businessId);
                            if (isAdded) {
                              '+${_customerModel.mobileNo} is Already Added'
                                  .showSnackBar(context);
                              return;
                            }
                          } else {
                            _customerModel.mobileNo = '';
                          }
                          _customerModel.customerId = Uuid().v1();
                          _customerModel.businessId =
                              Provider.of<BusinessProvider>(context,
                                      listen: false)
                                  .selectedBusiness
                                  .businessId;
                          _customerModel.isChanged = true;
                          _customerModel.isDeleted = false;
                          _customerModel.createdDate = DateTime.now();

                          FocusScope.of(context).unfocus();
                          setState(() {
                            isLoading = true;
                          });

                          final response = await _repository.queries
                              .insertCustomer(_customerModel);
                          if (response != null) {
                            if (await checkConnectivity) {
                              if (_customerModel.mobileNo!.isNotEmpty) {
                                final Messages msg =
                                    Messages(messages: '', messageType: 100);
                                var jsondata = jsonEncode(msg);

                                final response =
                                    await _chatRepository.sendMessage(
                                        _customerModel.mobileNo.toString(),
                                        _customerModel.name,
                                        jsondata,
                                        _customerModel.customerId ?? '',
                                        Provider.of<BusinessProvider>(context,
                                                listen: false)
                                            .selectedBusiness
                                            .businessId);

                                final messageResponse =
                                    Map<String, dynamic>.from(
                                        jsonDecode(response.body));
                                Message _message = Message.fromJson(
                                    messageResponse['message']);
                                _customerModel..chatId = _message.chatId;
                              }
                              await saveContacts();
                            } else {
                          'Please check your internet connection or try again later.'
                              .showSnackBar(context);
                        }
                            BlocProvider.of<ContactsCubit>(context).getContacts(
                                Provider.of<BusinessProvider>(context,
                                        listen: false)
                                    .selectedBusiness
                                    .businessId);
                            if (!isCustomerAddedNotifier.value)
                              isCustomerAddedNotifier.value = true;

                            'New customer added successfully'
                                .showSnackBar(context);
                            _mobileController.clear();
                            _nameController!.clear();
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.of(context)..pop()..pop();
                          }
                        } else
                          setState(() {});
                      }
                    : null,
                child: Text(
                        'SAVE',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),),
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveContacts() async {
    final apiResponse = await (_repository.customerApi
        .saveCustomer(_customerModel,context,AddCustomers.ADD_NEW_CUSTOMER)
        .catchError((e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
      recordError(e, StackTrace.current);
      return false;
    }));
    debugPrint('api response : ' + apiResponse.toString());
    if (apiResponse) {
      if (_customerModel.chatId.toString().isNotEmpty) {
        await _repository.queries.updateCustomerIsChanged(
            0, _customerModel.customerId!, _customerModel.chatId);
      }
    } else {
      await _repository.queries.updateCustomerIsChanged(
          1, _customerModel.customerId!, _customerModel.chatId);
    }
  }
}
