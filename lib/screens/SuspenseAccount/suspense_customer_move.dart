import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Cubits/ImportContacts/import_contacts_cubit.dart';
import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
import 'package:urbanledger/Models/SuspenseAccountModel.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Models/user_model.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/APIs/suspense_account_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/chat_module/data/models/message.dart';
import 'package:urbanledger/chat_module/data/repositories/chat_repository.dart';
import 'package:urbanledger/chat_module/screens/contact/contact_controller.dart';
import 'package:urbanledger/chat_module/screens/contact/payment_controller.dart';
import 'package:urbanledger/chat_module/screens/home/home_controller.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_bottom_nav_bar_new.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/custom_pay_Receive_buttons.dart';
import 'package:urbanledger/screens/Components/custom_popup.dart';
import 'package:urbanledger/screens/Components/custom_profile_image.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/screens/Components/shimmer_widgets.dart';
import 'package:urbanledger/screens/TransactionScreens/ReceiveTransaction/receive_transaction_screen.dart';
import 'package:urbanledger/screens/TransactionScreens/add_cards_provider.dart';
import 'package:urbanledger/screens/TransactionScreens/pay_recieve.dart';
import 'package:urbanledger/screens/TransactionScreens/pay_transaction.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import 'package:uuid/uuid.dart';



class SuspenseAccountCustomerScreen extends StatefulWidget {
  Object data = [];
  SuspenseAccountCustomerScreen({Key? key, required this.data}) : super(key: key);

  @override
  _SuspenseAccountCustomerScreenState createState() =>
      _SuspenseAccountCustomerScreenState();
}

class _SuspenseAccountCustomerScreenState
    extends State<SuspenseAccountCustomerScreen> with TickerProviderStateMixin {
  late HomeController _homeController;
  final Repository repository = Repository();
  late PaymentController _paymentController;
  ChatRepository _chatRepository = ChatRepository();

  int _selectedSortOption = 1;
  int _selectedFilterOption = 1;
  final TextEditingController _searchController = TextEditingController();
  bool hideFilterString = true;
  //ContactController _contactController;
  double animatedHeight = 0.0;
  List isChecked = [];
  late int value;
  bool isTagCustomerClickable = false;
  List<SuspenseData> data2 = [];
  CustomerModel? selectedCustomer;
  final GlobalKey<State> key = GlobalKey<State>();







  @override
  void initState() {
    super.initState();
    if(widget.data!=null){
      data2 = widget.data as List<SuspenseData>;
    }
    _homeController = HomeController(context: context);
    calculatePremiumDate();
    getAllCards();
    _paymentController = PaymentController(
      context: context,
    );

    debugPrint('KYC STATUS : ' +
        Repository().hiveQueries.userData.kycStatus.toString());
    debugPrint('Premium STATUS : ' +
        Repository().hiveQueries.userData.premiumStatus.toString());
    //getKyc();
    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        animatedHeight = 14;
      });
    });
  }

  bool isEmiratesIdDone = false;
  bool isTradeLicenseDone = false;
  bool status = false;
  bool isPremium = false;
  bool loading = false;
  bool isloading = false;

// Future getKyc() async {
//     setState(() {
//       loading = true;
//     });
//     await KycAPI.kycApiProvider.kycCheker().catchError((e) {
//       setState(() {
//         loading = false;
//       });
//       'Something went wrong. Please try again later.'.showSnackBar(context);
//     }).then((value) {
//       setState(() {
//         loading = false;
//       });
//     });
//     calculatePremiumDate();
//     setState(() {
//       loading = false;
//     });
//   }

  getAllCards() async {
    Provider.of<AddCardsProvider>(context, listen: false).getCard();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _homeController.dispose();
    // _contactController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _homeController.initProvider();
    _paymentController.initProvider();
    // _contactController.initProvider();
    super.didChangeDependencies();
  }




  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: key,
        backgroundColor: AppTheme.paleGrey,
        extendBody: true,
        bottomNavigationBar: Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(left: 17, right: 17),
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.0, left: 12.0, right: 12.0),
            child: NewCustomButton(
                onSubmit: () {
                  if (BlocProvider.of<ImportContactsCubit>(context)
                          .state
                          .runtimeType ==
                      SearchedImportedContacts)
                    BlocProvider.of<ImportContactsCubit>(context)
                        .searchImportedContacts('');
                  Navigator.of(context).pushNamed(AppRoutes.addCustomerRoute);
                },
                text: 'create new customer'.toUpperCase(),
                textSize: 17,
                textColor: Colors.white),
          ),
        ),
        body: Container(
          height: deviceHeight,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
              color: Color(0xfff2f1f6),
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage('assets/images/back.png'),
                  alignment: Alignment.topCenter)),
          child: loading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    (MediaQuery.of(context).padding.top).heightBox,
                    BlocBuilder<ContactsCubit, ContactsState>(
                      buildWhen: (state1, state2) {
                        return true;
                      },
                      builder: (ctx, state) {
                        if (state is FetchedContacts) {
                          if (state.customerList.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  appBar(context),
                                  tagButton(true,context),
                                  searchField(1, 1),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Customers List (0)',
                                          style: TextStyle(
                                              color: Color(0xff666666),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Container(
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Color(0xff1058ff)),
                                                shape: MaterialStateProperty
                                                    .all<OutlinedBorder>(
                                                        RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                )),
                                                elevation: MaterialStateProperty
                                                    .all<double>(0)),
                                            child: SvgPicture.asset(
                                              AppAssets.addCustomerIcon,
                                              height: 24,
                                              width: 24,
                                            ),
                                            onPressed: () async {
                                              if (BlocProvider.of<
                                                              ImportContactsCubit>(
                                                          context)
                                                      .state
                                                      .runtimeType ==
                                                  SearchedImportedContacts)
                                                BlocProvider.of<
                                                            ImportContactsCubit>(
                                                        context)
                                                    .searchImportedContacts('');
                                              Navigator.of(context).pushNamed(
                                                  AppRoutes.addCustomerRoute);
                                            },
                                          ),
                                        ),

                                        // Image.asset(
                                        //   'assets/icons/link.png',
                                        //   scale: 1.2,
                                        // ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                        ).flexible,
                                        Image.asset(
                                          'assets/images/addYourFirstCustomer.png',
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3,
                                        ),
                                        Center(
                                          child: CustomText(
                                            'Start adding your\n first customer',
                                            color: AppTheme.brownishGrey,
                                            size: 22,
                                            centerAlign: true,
                                            bold: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).flexible,
                                ],
                              ),
                            );
                          }
                          _selectedSortOption = 1;
                          _selectedFilterOption = 1;
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: customerListWithOtherWidgets(
                                state.customerList,
                                _selectedFilterOption,
                                _selectedSortOption,context),
                          );
                        }
                        if (state is SearchedContacts) {
                          // hideFilterString = false;
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: customerListWithOtherWidgets(
                                state.searchedCustomerList,
                                state.selectedFilter,
                                state.selectedSort,context),
                          );
                        }
                        if (state is ContactsInitial) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                              ),
                              ShimmerButton(),
                              ShimmerButton(),
                              ShimmerButton(),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ShimmerText(),
                                    ShimmerText(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ShimmerListTile(),
                              ShimmerListTile(),
                              ShimmerListTile(),
                            ],
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ).flexible,
                  ],
                ),
        ),
      ),
    );
  }

  Widget customerListWithOtherWidgets(
      List<CustomerModel> customerList, filterIndex, sortIndex,BuildContext context) {
    print(filterIndex);
    return Column(
      children: [
        appBar(context),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        tagButton(false,context),
        searchField(filterIndex ?? 1, sortIndex ?? 1),
        if (!hideFilterString)
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 15),
            child: Container(
              decoration: BoxDecoration(
                  color: AppTheme.carolinaBlue.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      'Showing list of ${getFilterString(filterIndex)} as ${getSortString(sortIndex)}',
                      color: AppTheme.brownishGrey,
                      size: 16,
                    ),
                    GestureDetector(
                      child:
                          Icon(Icons.close_sharp, color: AppTheme.brownishGrey),
                      onTap: () {
                        _selectedFilterOption = 1;
                        _selectedSortOption = 1;
                        BlocProvider.of<ContactsCubit>(context)
                            .filterContacts(1, 1);
                        setState(() {
                          hideFilterString = true;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        SizedBox(
          height: 10,
        ),
        customerListing(customerList)
      ],
    );
  }


  Widget customerListing(List<CustomerModel> customerList){
    return ListView.builder(
      // physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.06),
      itemCount: customerList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: ListTile(
              leading: CustomProfileImage(
                avatar: customerList[index].avatar,
                mobileNo: customerList[index].mobileNo,
                name: customerList[index].name,
              ),

              // leading: CircleAvatar(
              //   radius: 25,
              //   backgroundColor: _colors[random.nextInt(_colors.length)],
              //   backgroundImage:
              //       widget._customerList[index].avatar?.isEmpty ?? true
              //           ? null
              //           : MemoryImage(widget._customerList[index].avatar!),
              //   child: widget._customerList[index].avatar?.isEmpty ?? true
              //       ? CustomText(
              //           getInitials(
              //               widget._customerList[index].name!.toUpperCase(),
              //               widget._customerList[index].mobileNo),
              //           color: Colors.white,
              //           size: 27,
              //         )
              //       : null,
              // ),
              title: CustomText(
                getName(customerList[index].name,
                  customerList[index].mobileNo),
                bold: FontWeight.w500,
                size: 18,
              ),
              subtitle: CustomText(
                customerList[index].updatedDate?.duration ?? "",
                size: 16,
                color: AppTheme.greyish,
              ),
              trailing: Container(
                height: 22,
                width: 22,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Radio<CustomerModel>(
                    value: customerList[index],
                    groupValue: selectedCustomer,
                    onChanged: (CustomerModel? value) {
                      setState(() {
                        selectedCustomer = value;
                        isTagCustomerClickable= true;
                      });
                    },
                  ),
                ),
              ),
              // trailing: RadioB(
              //     value: index,
              //     groupValue: val,
              //     onChanged: (value) {
              //       print("Radio $value");
              //       setSelectedRadio(index);
              //     }),
              onTap: () {
                //ancb
              },
            ),
          ),
        );
      },
    ).flexible;
  }

  Widget searchField(int filterIndex, int sortIndex) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.only(
            top: 5,
            bottom: 5,
          ),
          elevation: 3,
          child: Container(
            // width: MediaQuery.of(context).size.width * 0.92,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Image.asset(
                    AppAssets.searchIcon,
                    color: AppTheme.brownishGrey,
                    height: 20,
                    scale: 1.4,
                  ),
                ),
                SizedBox(width: 10.0),
                Container(
                  width: screenWidth(context) * 0.7,
                  child: TextFormField(
                    // textAlignVertical: TextAlignVertical.center,
                    controller: _searchController,
                    onChanged: (value) {
                      BlocProvider.of<ContactsCubit>(context)
                          .searchContacts(value);
                    },
                    style: TextStyle(
                      fontSize: 17,
                      color: AppTheme.brownishGrey,
                    ),
                    cursorColor: AppTheme.brownishGrey,
                    decoration: InputDecoration(
                        // contentPadding: EdgeInsets.only(top: 15),
                        border: InputBorder.none,
                        hintText: 'Search Customers, Name, phone',
                        hintStyle: TextStyle(
                            color: Color(0xffb6b6b6),
                            fontSize: 17,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget appBar(context) => ValueListenableBuilder<Box?>(
        valueListenable: repository.hiveQueries.userBox.listenable(),
        builder: (ctx, box, _) => box == null
            ? Container()
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Row(
                  children: [
                    Container(
                        // padding: EdgeInsets.all(2),
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(99),
                        //   color: Colors.white,
                        // ),
                        child: ((box.get('UserData') as SignUpModel?)
                                    ?.profilePic
                                    .isEmpty ??
                                true)
                            ? CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white.withOpacity(0.5),
                                backgroundImage:
                                    AssetImage('assets/icons/my-account.png'))
                            : CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white.withOpacity(0.5),
                                backgroundImage: FileImage(File(
                                    (box.get('UserData') as SignUpModel)
                                        .profilePic)))),
                    15.0.widthBox,
                    InkWell(
                      onTap: () async {
                              if (await allChecker(context)) {
                                debugPrint('abc');
                                switchBusinessSheet;
                              }
                            },
                      child: Container(
                        // width: screenWidth(context) * 0.5,
                        // color: Colors.amber,
                        constraints: BoxConstraints(
                            maxWidth: screenWidth(context) * 0.5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Consumer<BusinessProvider>(
                                  builder: (context, value, child) {
                                    return Flexible(
                                      child: CustomText(
                                        '${value.selectedBusinessForUnrecognized.businessName}',
                                        color: Colors.white,
                                        size: 19,
                                        bold: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  },
                                ),
                                AnimatedSize(
                                  vsync: this,
                                  duration: Duration(seconds: 2),
                                  curve: Curves.easeInBack,
                                  // height: animatedHeight,
                                  child: animatedHeight == 0.0
                                      ? Container()
                                      : CustomText(
                                          'Switch Ledger',
                                          size: 14,
                                          color: Colors.white,
                                          bold: FontWeight.w400,
                                          overflow: TextOverflow.fade,
                                        ),
                                )
                              ],
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 28,
                            )
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              showSuspenseAccountBottomSheet(context);
                            },
                            child: Image.asset(AppAssets.helpIcon, height: 30),
                          )
                        ],
                      ),
                    ),
                  ],
                  /* trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/icons/currency.png',
                          height: 28,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/icons/settings.png',
                          height: 28,
                        ),
                      )
                    ],
                  ), */
                ),
              ),
      );

  Widget tagButton(bool isCustomerEmpty,BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: double.infinity, height: 45,

        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(20),
        //   color: Colors.white,
        // ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              primary: isTagCustomerClickable?AppTheme.electricBlue:AppTheme.buttonSplashGrey,
            ),
            onPressed: isTagCustomerClickable? () async {

           showTagCustomerBottomSheet(context);
            }:null,
            child: CustomText(
              'Tag existing customer'.toUpperCase(),
              bold: FontWeight.bold,
              color: Colors.white70,
              size: 16,
            )),
      );

  showTagCustomerBottomSheet(BuildContext context) {
    bool agree = true;
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (ctx, state) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 6,
                        width: 42,
                        decoration: BoxDecoration(
                            color: AppTheme.greyish,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  SizedBox(height: 0),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            AppAssets.warning,
                            height: 40,
                            width: 40,
                          ),
                          /*  15.0.heightBox,
                          CustomText(
                            'Manage your Settlement',
                            size: 20,
                            color: AppTheme.brownishGrey,
                            bold: FontWeight.w500,
                          ),*/
                          15.0.heightBox,
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomText(
                              'You are about to tag selected transaction(s) to another customer. Once entry is tagged the payment information will be reflected on selected customer and can not be changed. Do you want to proceed?',
                              size: 18,
                              centerAlign:true,
                              color: AppTheme.brownishGrey,
                              bold: FontWeight.w600,
                            ),
                          ),
                          20.0.heightBox,
                          /*Container(
                            // height: MediaQuery.of(context).size.height * 0.02,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: agree,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      agree = value!;
                                    });
                                  },

                                ),
                                Text(
                                  'Do not show me this message again',
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          10.0.heightBox,*/
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(ctx).pop();
                                        CustomLoadingDialog.showLoadingDialog(context, key);
                                        List<String>? transactionIDS = [];
                                        Repository _repository = Repository();


                                        if (data2 != null && data2.isNotEmpty) {
                                          debugPrint('data2' + data2.length.toString());
                                          for (int i = 0; i < data2.length; i++) {
                                            // await _repository.queries.checkCustomerAdded(
                                            //     data2[i].fromCustId?.mobileNo, Bid!); //
                                            /*CustomerModel _customerModel = CustomerModel();
                                            _customerModel.customerId = selectedCustomer!.customerId;
                                            _customerModel.businessId =
                                                selectedCustomer!.businessId;
                                            // _customerModel.chatId =
                                            //     data2[i].fromCustId!.chatId;
                                            _customerModel.name = data2[i].from;
                                            _customerModel.ulId = data2[i].fromCustId!.id;
                                            _customerModel.mobileNo =
                                                data2[i].fromMobileNumber;
                                            _customerModel.businessId = selectedCustomer!.businessId; //BusinessID

                                            _customerModel.isChanged = true;
                                            _customerModel.isDeleted = false;*/

                                            List<CustomerModel> customerModel =
                                            await repository.queries
                                                .getCustomerDetails(
                                                selectedCustomer!.mobileNo!.trim(),
                                                Provider.of<BusinessProvider>(
                                                    context,
                                                    listen: false)
                                                    .selectedBusinessForUnrecognized
                                                    .businessId);
                                            debugPrint('ss ::' +
                                                customerModel.first
                                                    .toJson()
                                                    .toString());
                                            CustomerModel _customerModel =
                                                customerModel.first;

                                          /*  String? checkCustomer = await _repository
                                                .queries
                                                .checkCustomerAddedForSuspense(
                                                data2[i].fromMobileNumber, selectedCustomer!.businessId!);
                                            if (checkCustomer!.isEmpty) {
                                              // _customerModel.customerId = checkCustomer;
                                              if (_customerModel.mobileNo!.isNotEmpty) {
                                                final Messages msg = Messages(
                                                    messages: '', messageType: 100);
                                                var jsondata = jsonEncode(msg);

                                                final response =
                                                    await _chatRepository.sendMessage(
                                                    _customerModel.mobileNo.toString(),
                                                    _customerModel.name,
                                                    jsondata,
                                                    _customerModel.customerId ?? '',
                                                    Provider.of<BusinessProvider>(
                                                        context,
                                                        listen: false)
                                                        .selectedBusiness
                                                        .businessId);

                                                final messageResponse =
                                                Map<String, dynamic>.from(
                                                    jsonDecode(response.body));
                                                Message _message = Message.fromJson(
                                                    messageResponse['message']);
                                                _customerModel..chatId = _message.chatId;
                                                debugPrint('addddd: ' +
                                                    _customerModel.toJson().toString());
                                              }
                                              await _repository.queries
                                                  .insertCustomer(_customerModel);
                                            } else {
                                              _customerModel.customerId = checkCustomer;
                                            }*/

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
                                        ..date = data2[i].completed != null
                                        ? data2[i].completed
                                            : DateTime.now()
                                        ..balanceAmount = (previousBalance +
                                        double.parse(
                                        data2[i].amount.toString()))
                                        ..isChanged = true
                                        ..fromMobileNumber = data2[i]
                                            .fromMobileNumber
                                            .toString()
                                        ..details = ''
                                        ..isDeleted = false
                                        ..business =selectedCustomer!.businessId //todoadd column
                                        ..createddate = DateTime.now(),
                                        () async {
                                        await Repository()
                                            .queries
                                            .updateIsMovedOffline(data2[i]);
                                        }, context);
                                        debugPrint('customer :' +
                                        _customerModel.toJson().toString());
                                        debugPrint(
                                        'data :' + data2[i].toJson().toString());
                                        _paymentController.sendMessage(
                                        _customerModel.customerId,
                                        _customerModel.chatId ?? null,
                                        _customerModel.name,
                                        _customerModel.mobileNo,
                                        _transactionModel.amount,
                                        '', //request_id
                                        13,
                                        data2[i].transactionId,
                                        data2[i].urbanledgerId,
                                        data2[i].completed.toString(),
                                        1,
                                        "${data2[i].type}",
                                        "${data2[i].through}",
                                        selectedCustomer!.businessId!,
                                        data2[i].suspense == true ? 1 : 0);
                                        }
                                        }
                                        await SuspenseAccountApi.suspenseAccountApi
                                            .removeFromSuspenseEntry(
                                        TransctionIDS: transactionIDS)
                                            .then((value) {
                                        debugPrint('delete' + value.toString());
                                        if (value == true) {
                                          Navigator.pop(context);
                                        'Selected transaction moved\nsuccessfully!'
                                            .showSnackBar(context);

                                        Navigator.pushReplacementNamed(
                                        context, AppRoutes.suspenseAccountRoute);
                                        }
                                        });
                                       /* Provider.of<BusinessProvider>(context,
                                        listen: false)
                                            .updateSelectedBusiness();*/
                                        debugPrint('Ht5');

                                      },
                                      child: CustomText(
                                        'YES',
                                        size: (18),
                                        bold: FontWeight.w500,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(15),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                      )),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedCustomer = null;
                                          isTagCustomerClickable= false;
                                        });

                                        Navigator.of(context).pop();
                                        /*repository.hiveQueries
                                          .insertIsCashbookSheetShown(true);*/
                                      },
                                      child: CustomText(
                                        'NO',
                                        size: (18),
                                        bold: FontWeight.w500,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(15),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                      )),
                                ),
                              ),
                            ],
                          )
                        ]),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value){



    });
  }


  /*showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
*/
  static String getFilterString(int index) {
    String filter;
    switch (index) {
      case 1:
        filter = 'All';
        break;
      case 2:
        filter = 'You will get';
        break;
      case 3:
        filter = 'You will give';
        break;
      case 4:
        filter = 'Nothing pending';
        break;
      default:
        filter = 'All';
        break;
    }
    return filter;
  }

  static String getSortString(int index) {
    String sort;
    switch (index) {
      case 1:
        sort = 'Most Recent';
        break;
      case 2:
        sort = 'Highest Amount';
        break;
      case 3:
        sort = 'By Name (A-Z)';
        break;
      case 4:
        sort = 'Oldest';
        break;
      case 5:
        sort = 'Least Amount';
        break;
      default:
        sort = 'Most Recent';
        break;
    }
    return sort;
  }

  Future<void> get switchBusinessSheet async {
    await showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            constraints: BoxConstraints(maxHeight: 400),
            decoration: BoxDecoration(
                color: AppTheme.justWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            // height: 400,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        /*  Image.asset(
                          AppAssets.appIcon,
                          width: 40,
                          height: 40,
                        ), */
                        10.0.widthBox,

                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // width: screenWidth(context) * 0.35,
                                child: CustomText(
                                  Provider.of<BusinessProvider>(context,
                                          listen: false)
                                      .selectedBusinessForUnrecognized
                                      .businessName,
                                  bold: FontWeight.w600,
                                  color: Theme.of(context).primaryColor,
                                  size: 18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              FutureBuilder<int>(
                                  future: repository.queries.getCustomerCount(
                                      Provider.of<BusinessProvider>(context,
                                              listen: false)
                                          .selectedBusinessForUnrecognized
                                          .businessId),
                                  builder: (context, snapshot) {
                                    return Container(
                                      // width: screenWidth(context) * 0.35,
                                      child: CustomText(
                                        '${snapshot.data} ${snapshot.data == 1 ? 'Customer' : 'Customers'}',
                                        bold: FontWeight.w400,
                                        color: AppTheme.brownishGrey,
                                        size: 14,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                        // Expanded(
                        //   flex: 9,
                        //   child: FutureBuilder<List<double>>(
                        //       future: repository.queries
                        //           .getTotalPayReceiveForCustomer(
                        //               Provider.of<BusinessProvider>(context,
                        //                       listen: false)
                        //                   .selectedBusiness
                        //                   .businessId),
                        //       builder: (context, snapshot) {
                        //         return Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             SizedBox(
                        //               // width: screenWidth(context) * 0.24,
                        //               child: Column(
                        //                 children: [
                        //                   Row(
                        //                     children: [
                        //                       Transform.rotate(
                        //                         angle: 0,
                        //                         child: Image.asset(
                        //                           AppAssets.giveIcon,
                        //                           height: 18,
                        //                         ),
                        //                       ),
                        //                       CustomText(
                        //                         'You will Give',
                        //                         size: 14,
                        //                         bold: FontWeight.w500,
                        //                       ),
                        //                     ],
                        //                   ),
                        //                   CustomText(
                        //                     '$currencyAED',
                        //                     size: 14,
                        //                     bold: FontWeight.w700,
                        //                     color: AppTheme.tomato,
                        //                   ),
                        //                   CustomText(
                        //                     snapshot.data != null
                        //                         ? (snapshot.data!.last)
                        //                             .getFormattedCurrency
                        //                             .replaceAll('-', '')
                        //                         : '0',
                        //                     bold: FontWeight.w700,
                        //                     color: AppTheme.tomato,
                        //                   )
                        //                 ],
                        //               ),
                        //             ),
                        //             SizedBox(
                        //               width: 40,
                        //             ),
                        //             SizedBox(
                        //               // width: screenWidth(context) * 0.24,
                        //               child: Column(
                        //                 children: [
                        //                   Row(
                        //                     children: [
                        //                       Transform.rotate(
                        //                         angle: 0,
                        //                         child: Image.asset(
                        //                           AppAssets.getIcon,
                        //                           height: 18,
                        //                         ),
                        //                       ),
                        //                       CustomText(
                        //                         'You will Get',
                        //                         size: 14,
                        //                         bold: FontWeight.w500,
                        //                       ),
                        //                     ],
                        //                   ),
                        //                   CustomText(
                        //                     '$currencyAED',
                        //                     size: 14,
                        //                     color: AppTheme.greenColor,
                        //                     bold: FontWeight.w700,
                        //                   ),
                        //                   CustomText(
                        //                     snapshot.data != null
                        //                         ? (snapshot.data!.first)
                        //                             .getFormattedCurrency
                        //                             .replaceAll('-', '')
                        //                         : '0',
                        //                     color: AppTheme.greenColor,
                        //                     bold: FontWeight.w700,
                        //                   )
                        //                 ],
                        //               ),
                        //             ),
                        //           ],
                        //         );
                        //       }),
                        // )

                        // Spacer(),
                        // Radio(value: true, groupValue: true, onChanged: (_) {}),
                      ],
                    )),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      Provider.of<BusinessProvider>(context, listen: false)
                          .businesses
                          .length,
                  itemBuilder: (BuildContext context, int index) {
                    if (Provider.of<BusinessProvider>(context, listen: false)
                            .businesses[index] ==
                        Provider.of<BusinessProvider>(context, listen: false)
                            .selectedBusinessForUnrecognized) return Container();
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _selectedSortOption = 1;
                        _selectedFilterOption = 1;
                        isTagCustomerClickable= false;
                        Navigator.of(context).pop();
                        Provider.of<BusinessProvider>(context, listen: false)
                            .getSelectedBusinessForUnrecognized(index: index);
                        print('business Id' +
                            Provider.of<BusinessProvider>(context,
                                    listen: false)
                                .selectedBusinessForUnrecognized
                                .businessId);
                        BlocProvider.of<ContactsCubit>(context).getContacts(
                            Provider.of<BusinessProvider>(context,
                                    listen: false)
                                .selectedBusinessForUnrecognized
                                .businessId);
                        (Provider.of<BusinessProvider>(context, listen: false)
                                    .selectedBusinessForUnrecognized
                                    .businessName +
                                ' is now selected as your active ledger')
                            .showSnackBar(context);
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            children: [
                              /* Image.asset(
                                AppAssets.appIcon,
                                width: 40,
                                height: 40,
                              ), */
                              10.0.widthBox,
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: screenWidth(context) * 0.5,
                                      child: CustomText(
                                        Provider.of<BusinessProvider>(context,
                                                listen: false)
                                            .businesses[index]
                                            .businessName,
                                        bold: FontWeight.w600,
                                        color: Theme.of(context).primaryColor,
                                        size: 18,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    FutureBuilder<int>(
                                        future: repository.queries
                                            .getCustomerCount(
                                                Provider.of<BusinessProvider>(
                                                        context,
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
                                        }),
                                  ],
                                ),
                              ),
                              // Expanded(
                              //   flex: 9,
                              //   child: FutureBuilder<List<double>>(
                              //       future: repository.queries
                              //           .getTotalPayReceiveForCustomer(
                              //               Provider.of<BusinessProvider>(
                              //                       context,
                              //                       listen: false)
                              //                   .businesses[index]
                              //                   .businessId),
                              //       builder: (context, snapshot) {
                              //         return Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.center,
                              //           children: [
                              //             SizedBox(
                              //               // width: screenWidth(context) * 0.24,
                              //               child: Column(
                              //                 children: [
                              //                   Row(
                              //                     children: [
                              //                       Transform.rotate(
                              //                         angle: 0,
                              //                         child: Image.asset(
                              //                           AppAssets.giveIcon,
                              //                           height: 18,
                              //                         ),
                              //                       ),
                              //                       CustomText(
                              //                         'You will Give',
                              //                         size: 14,
                              //                         bold: FontWeight.w500,
                              //                       ),
                              //                     ],
                              //                   ),
                              //                   CustomText(
                              //                     '$currencyAED',
                              //                     size: 14,
                              //                     bold: FontWeight.w700,
                              //                     color: AppTheme.tomato,
                              //                   ),
                              //                   CustomText(
                              //                     snapshot.data != null
                              //                         ? (snapshot.data!.last)
                              //                             .getFormattedCurrency
                              //                             .replaceAll('-', '')
                              //                         : '0',
                              //                     bold: FontWeight.w700,
                              //                     color: AppTheme.tomato,
                              //                   )
                              //                 ],
                              //               ),
                              //             ),
                              //             SizedBox(
                              //               width: 40,
                              //             ),
                              //             SizedBox(
                              //               // width: screenWidth(context) * 0.24,
                              //               child: Column(
                              //                 children: [
                              //                   Row(
                              //                     children: [
                              //                       Transform.rotate(
                              //                         angle: 0,
                              //                         child: Image.asset(
                              //                           AppAssets.getIcon,
                              //                           height: 18,
                              //                         ),
                              //                       ),
                              //                       CustomText(
                              //                         'You will Get',
                              //                         size: 14,
                              //                         bold: FontWeight.w500,
                              //                       ),
                              //                     ],
                              //                   ),
                              //                   CustomText(
                              //                     '$currencyAED',
                              //                     size: 14,
                              //                     color: AppTheme.greenColor,
                              //                     bold: FontWeight.w700,
                              //                   ),
                              //                   CustomText(
                              //                     snapshot.data != null
                              //                         ? (snapshot.data!.first)
                              //                             .getFormattedCurrency
                              //                             .replaceAll('-', '')
                              //                         : '0',
                              //                     color: AppTheme.greenColor,
                              //                     bold: FontWeight.w700,
                              //                   )
                              //                 ],
                              //               ),
                              //             ),
                              //           ],
                              //         );
                              //       }),
                              // )

                              // Spacer(),
                              // Icon(
                              //   Icons.arrow_forward_ios_rounded,
                              //   size: 20,
                              //   color: AppTheme.brownishGrey,
                              // ),
                              // 8.0.widthBox
                            ],
                          )),
                    );
                  },
                ).flexible,
                // Spacer(),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 20),
                //   width: double.infinity,
                //   child: ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         padding: EdgeInsets.all(15),
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10)),
                //       ),
                //       child: CustomText('Create a new Ledger'.toUpperCase(),
                //           color: Colors.white, size: 18, bold: FontWeight.w500),
                //       onPressed: () {
                //         Navigator.of(context).pop();
                //         Navigator.of(context)
                //             .pushNamed(AppRoutes.addLedgerRoute);
                //       }),
                // ),
                15.0.heightBox
              ],
            ),
          );
        });
      },
    );
  }
}

showSuspenseAccountBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    context: context,
    builder: (BuildContext context) {
      bool checkedValue = false;
      return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 6,
                    width: 42,
                    decoration: BoxDecoration(
                        color: AppTheme.greyish,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
              SizedBox(height: 0),
              Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          AppAssets.info_01,
                          height: 35,
                        ),
                        15.0.heightBox,
                        CustomText(
                          'Manage your Unrecognized Transactions',
                          size: 20,
                          color: AppTheme.brownishGrey,
                          bold: FontWeight.bold,
                        ),
                        15.0.heightBox,
                        CustomText(
                          'An Unrecognized transaction is a list of unknown payment transactions received from your customers through global payment link or QR code or direct payment. You can filter your transactions as well as sort them according to the payment type. Move single as well as multiple transactions to a particular ledger or business account to monitor and control a business\'s financial operations.',
                          size: 18,
                          centerAlign: true,
                          color: AppTheme.brownishGrey,
                          bold: FontWeight.w400,
                        ),
                        15.0.heightBox,
                        CheckboxListTile(
                          title: Text("Do not show me this message again"),
                          value: checkedValue,
                          onChanged: (newValue) {
                            setState(() {
                              checkedValue = newValue!;
                            });
                            repository.hiveQueries
                                .insertIsSuspenseSheetShown(checkedValue);
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: CustomText(
                                'OK',
                                size: (18),
                                bold: FontWeight.w500,
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              )),
                        )
                      ])),
            ],
          ),
        );
      });

    },
  );
}

/*class CustomerListWidget extends StatefulWidget {
  final List<CustomerModel> _customerList;
  bool isLoading = false;

  CustomerListWidget(
    this._customerList, {
    Key? key,
  }) : super(key: key);

  @override
  _CustomerListWidgetState createState() => _CustomerListWidgetState();
}

class _CustomerListWidgetState extends State<CustomerListWidget> {
  late int selectRadio;
  int val = -1;



  @override
  void initState() {
    super.initState();
    selectRadio = 0;
  }

  setSelectedRadio(int value) {
    setState(() {
      selectRadio = value;
    });
  }

  // static const List<Color> _colors = [
  //   Color.fromRGBO(137, 171, 249, 1),
  //   AppTheme.brownishGrey,
  //   AppTheme.greyish,
  //   AppTheme.electricBlue,
  //   AppTheme.carolinaBlue,
  // ];
  //
  // final Random random = Random();
  CustomerModel _customerModel = CustomerModel();
  ChatRepository _chatRepository = ChatRepository();
  final GlobalKey<State> key = GlobalKey<State>();

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
                              0 *//*percentages not used in flutter. defaulting to zero*//*,
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
                              0 *//*percentages not used in flutter. defaulting to zero*//*,
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

  Future getKyc() async {
    setState(() {
      isLoading = true;
    });

    await KycAPI.kycApiProvider.kycCheker().then((value) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Check the value : ' + value['status'].toString());

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
                    isTradeLicenseDone: value['tl'] ?? false,
                    paymentLink: value['link'] ?? ''));

            //TODO Need to set emirates iD and TradeLicense ID Values
            // isEmiratesIdDone = value['emirates'] ?? false;
            // isTradeLicenseDone = value['tl'] ?? false;
            // status = value['status'] ?? false;
            // isPremium = value['premium'] ?? false;

            // debugPrint('check1' + status.toString());
            // debugPrint('check' + isEmiratesIdDone.toString());
          });
          return;
        }
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

  }
}*/
