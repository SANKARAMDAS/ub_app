import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Cubits/ImportContacts/import_contacts_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/import_contact_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/chat_module/data/models/message.dart';
import 'package:urbanledger/chat_module/data/repositories/chat_repository.dart';
import 'package:urbanledger/screens/Components/custom_bottom_nav_bar_new.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/shimmer_widgets.dart';
import 'package:urbanledger/screens/TransactionScreens/pay_recieve.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import 'package:uuid/uuid.dart';

class AddCustomerScreen extends StatefulWidget {
  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final searchController = TextEditingController();
  bool _isLoading = false;
  late ImportContactsCubit importContactsCubit;
  bool permission = false;

  @override
  void initState() {
    // checkContactPermUpdateData(false);
    fetchData();
    /*importContactsCubit = BlocProvider.of<ImportContactsCubit>(context);
    importContactsCubit.updateContacts();*/
    super.initState();
  }

  fetchData() async {
    final count = await checkContactPermUpdateData(false);
    if (count > 0) {
      {}
    } else {
      await checkContactPermUpdateData(true);
    }
  }

  Future<int> checkContactPermUpdateData(bool fromPhoneBook) async {
    int count;

    //bool permanentlyDeniedStatus = await permissionStatus.isPermanentlyDenied;
    importContactsCubit = BlocProvider.of<ImportContactsCubit>(context);
    await importContactsCubit.checkContactsPermission();
    count = await importContactsCubit.updateContacts(fromPhoneBook);
    return count;
  }

  @override
  void dispose() {
    searchController.dispose();
    importContactsCubit.searchImportedContacts('');
    super.dispose();
  }

  void setLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void removeLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isLoading) return false;
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.paleGrey,
        appBar: AppBar(
          title: Text(
            'Add customers from your contacts ',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
          ),
          leadingWidth: 30,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: IconButton(
              onPressed: () {
                if (!_isLoading) Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                size: 22,
              ),
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        floatingActionButton: Container(
          child: ValueListenableBuilder(
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
                                    await anaylticsEvents
                                        .sendRecieveButtonEvent();
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => PayRequestScreen(),
                                    ));
                                  },
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomSheet: CustomBottomNavBarNew(),
        body: Stack(
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
                      alignment: Alignment.topCenter)),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
              child: Column(
                children: [
                  SizedBox(
                      height:
                          MediaQuery.of(context).padding.top + appBarHeight),
                  (deviceHeight * 0.02).heightBox,
                  CustomSearchBar(
                    CtextFormField: TextFormField(
                      controller: searchController,
                      onChanged: (value) {
                        importContactsCubit.searchImportedContacts(value);
                      },
                      decoration: InputDecoration(
                          hintText: 'Search Customer',
                          hintStyle: TextStyle(
                              color: AppTheme.greyish,
                              fontWeight: FontWeight.w500),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none),
                    ),
                    Suffix: Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        //   child: Image.asset(
                        //     AppAssets.filterIcon,
                        //     color: AppTheme.brownishGrey,
                        //     height: 18,
                        //     // scale: 1.5,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        BlocBuilder<ImportContactsCubit, ImportContactsState>(
                      builder: (context, state) {
                        if (state is ImportContactsInitial) {
                          return Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),
                                // ShimmerListTile5(),
                                ShimmerListTile(),
                                ShimmerListTile(),
                                ShimmerListTile(),
                                ShimmerListTile(),
                                // ShimmerListTile(),
                                // ShimmerListTile(),
                                // ShimmerListTile(),
                              ],
                            ),
                            // Center(child:  ShimmerListTile())
                          );
                        }
                        if (state is ContactPermissionStatus) {
                          if (state.status == false) {
                            return contactListWithOtherWidgets([], '', context);
                          } else {
                            return Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                  ),
                                  ShimmerListTile5(),
                                  ShimmerListTile(),
                                  ShimmerListTile(),
                                  ShimmerListTile(),
                                  ShimmerListTile(),
                                  // ShimmerListTile(),
                                  // ShimmerListTile(),
                                  // ShimmerListTile(),
                                ],
                              ),
                              // Center(child:  ShimmerListTile())
                            );
                          }
                        }

                        if (state is SearchedImportedContacts) {
                          return contactListWithOtherWidgets(
                              state.searchedContacts,
                              state.searchQuery,
                              context);
                        }
                        if (state is FetchedImportedContacts) {
                          return contactListWithOtherWidgets(
                              state.fetchedContacts, '', context);
                        }
                        if (state is LoadingImportContacts)
                          return Center(child: CircularProgressIndicator());

                        return Center(child: CircularProgressIndicator());
                      },
                    ) /*.flexible*/,
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        // height: 100,
                        child: CircularProgressIndicator(
                            // color: Colors.amberAccent,
                            ),
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget contactListWithOtherWidgets(List<ImportContactModel> contacts,
          String searchQuery, BuildContext context) =>
      Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xff2ed06d),
              child: SvgPicture.asset(AppAssets.addCustomerIcon),
            ),
            title: CustomText(
              searchQuery.length > 0
                  ? 'Add \'$searchQuery\''
                  : 'Add New Customer',
              bold: FontWeight.w500,
              size: 17,
              color: AppTheme.electricBlue,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.addCustomerFormRoute,
                  arguments: searchQuery);
            },
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.electricBlue,
              size: 35,
            ),
          ),
        ),
        Divider(
          color: AppTheme.electricBlue,
          endIndent: 15,
          indent: 15,
          thickness: 2,
        ),
        contacts.isEmpty
            ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                      child: CustomText(
                    'Sorry! We could not find the customer you are looking for.',
                    size: 18,
                    color: AppTheme.brownishGrey,
                  )),
                ),
              )
            : RefreshIndicator(
                    color: AppTheme.electricBlue,
                    onRefresh: () async {
                      final count = await checkContactPermUpdateData(true);
                      if (count > 0) {
                        {
                          searchController.clear();
                          "Contact list has been updated".showSnackBar(context);
                        }
                      } else {
                        "Contacts are already up to date".showSnackBar(context);
                      }
                      return;
                    },
                    child: ImportContactsListWidget(
                        contacts: contacts,
                        setLoading: setLoading,
                        removeLoading: removeLoading))
                .flexible,
      ]);
}

class ImportContactsListWidget extends StatefulWidget {
  final List<ImportContactModel> contacts;
  final Function() setLoading;
  final Function() removeLoading;

  const ImportContactsListWidget(
      {Key? key,
      required this.contacts,
      required this.setLoading,
      required this.removeLoading})
      : super(key: key);

  @override
  _ImportContactsListWidgetState createState() =>
      _ImportContactsListWidgetState();
}

class _ImportContactsListWidgetState extends State<ImportContactsListWidget> {
  final _repository = Repository();
  CustomerModel _customerModel = CustomerModel();
  ChatRepository _chatRepository = ChatRepository();
  final GlobalKey<State> key = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: widget.contacts.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              String phone = widget.contacts[index].mobileNo;
              final isAdded = BlocProvider.of<ContactsCubit>(context)
                  .checkCustomerIsAdded(phone);
              _customerModel
                ..name = getName(widget.contacts[index].name.trim(), phone)
                ..mobileNo = phone
                ..avatar = widget.contacts[index].avatar
                ..customerId = Uuid().v1()
                ..businessId =
                    Provider.of<BusinessProvider>(context, listen: false)
                        .selectedBusiness
                        .businessId
                ..createdDate = DateTime.now()
                ..isChanged = true
                ..isDeleted = false;

              if (!isAdded) {
                widget.setLoading();
                await _repository.queries.insertCustomer(_customerModel);
                if (await checkConnectivity) {
                  final apiResponse = await (_repository.customerApi
                      .saveCustomer(_customerModel, context,
                          AddCustomers.ADD_CUSTOMER_FROM_LIST)
                      .catchError((e) {
                    recordError(e, StackTrace.current);
                    return false;
                  }));
                  if (apiResponse) {
                    final Messages msg =
                        Messages(messages: '', messageType: 100);
                    var jsondata = jsonEncode(msg);
                    debugPrint('_customerModel.customerId ' +
                        _customerModel.customerId.toString());
                    debugPrint('_customerModel.business id  ' +
                        Provider.of<BusinessProvider>(context, listen: false)
                            .selectedBusiness
                            .businessId);
                    final response = await _chatRepository.sendMessage(
                        _customerModel.mobileNo.toString(),
                        _customerModel.name,
                        jsondata,
                        _customerModel.customerId ?? '',
                        Provider.of<BusinessProvider>(context, listen: false)
                            .selectedBusiness
                            .businessId);

                    final messageResponse =
                        Map<String, dynamic>.from(jsonDecode(response.body));
                    Message _message =
                        Message.fromJson(messageResponse['message']);
                    if (_customerModel.chatId.toString().isNotEmpty) {
                      debugPrint('chatiiiiid ' + _message.chatId.toString());
                      await _repository.queries.updateCustomerIsChanged(
                          0, _customerModel.customerId!, _message.chatId);
                    }
                  }
                } else {
                  'Please check your internet connection or try again later.'
                      .showSnackBar(context);
                }
                BlocProvider.of<ContactsCubit>(context).getContacts(
                    Provider.of<BusinessProvider>(context, listen: false)
                        .selectedBusiness
                        .businessId);
                if (!isCustomerAddedNotifier.value)
                  isCustomerAddedNotifier.value = true;
                widget.removeLoading();
                Navigator.of(context).pop();
                'New customer added successfully'.showSnackBar(context);
              } else {
                (getName(widget.contacts[index].name.trim(), phone) +
                        ' is Already Added')
                    .showSnackBar(context);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Stack(
                      children: [
                        CustomProfileImage(
                          avatar: widget.contacts[index].avatar,
                          mobileNo: widget.contacts[index].mobileNo,
                          name: widget.contacts[index].name,
                        ),
                        if (widget.contacts[index].customerId != null)
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: AppTheme.brownishGrey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Image.asset(AppAssets.appIcon),
                                ),
                              ))
                      ],
                    ),
                    // child: CircleAvatar(
                    //   radius: 25,
                    //   backgroundColor: _colors[random.nextInt(_colors.length)],
                    //   backgroundImage: widget.contacts[index].avatar!.isEmpty
                    //       ? null
                    //       : MemoryImage(widget.contacts[index].avatar!),
                    //   child: widget.contacts[index].avatar!.isEmpty
                    //       ? CustomText(
                    //           getInitials(widget.contacts[index].name!.trim(),
                    //               widget.contacts[index].mobileNo!.trim()),
                    //           color: AppTheme.circularAvatarTextColor,
                    //           size: 27,
                    //         )
                    //       : null,
                    // ),
                  ),
                  Container(
                    width: screenWidth(context) * 0.49,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          getName(widget.contacts[index].name.trim(),
                              widget.contacts[index].mobileNo.trim()),
                        ),
                        CustomText(
                          widget.contacts[index].mobileNo,
                          color: AppTheme.greyish,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  CustomText(
                    BlocProvider.of<ContactsCubit>(context)
                            .checkCustomerIsAdded(
                                widget.contacts[index].mobileNo)
                        ? 'Already Added'
                        : widget.contacts[index].customerId != null
                            ? 'UrbanLedger User'
                            : '',
                    color: AppTheme.greyish,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
