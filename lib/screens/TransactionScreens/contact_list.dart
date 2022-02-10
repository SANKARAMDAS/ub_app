import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urbanledger/Cubits/ImportContacts/import_contacts_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/import_contact_model.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
// import 'package:urbanledger/chat_module/screens/contact/contact_controller.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';

class ContactListScreen extends StatefulWidget {
  final String? customerName;
  final String? chatId;
  final String? customerId;
  final String? phoneNo;
  final Function(String? contactName, String? contactNo, int messageType)?
      sendContact;

  const ContactListScreen(
      {Key? key,
      required this.customerName,
      this.chatId,
      required this.customerId,
      required this.phoneNo,
      this.sendContact})
      : super(key: key);
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  @override
  void initState() {
    BlocProvider.of<ImportContactsCubit>(context).searchImportedContacts('');
    super.initState();
  }

  @override
  void dispose() {
    // BlocProvider.of<ImportContactsCubit>(context).searchImportedContacts('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      appBar: AppBar(
        title: Text(
          'Contact List',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
        ),
        leadingWidth: 30,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
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
      // bottomNavigationBar: CustomBottomNavBar(),
      body: Stack(
        children: [
          AppAssets.backgroundImage.background,
          Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).padding.top + appBarHeight),
              (deviceHeight * 0.030).heightBox,
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        offset: Offset(3, 3),
                        blurRadius: 3.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 2),
                    child: Row(
                      children: [
                        Image.asset(
                          AppAssets.searchIcon,
                          color: Color(0xff666666),
                          height: 19,
                          scale: 1.4,
                        ),
                        10.0.widthBox,
                        Expanded(
                            child: TextField(
                          onChanged: (value) {
                            BlocProvider.of<ImportContactsCubit>(context)
                                .searchImportedContacts(value);
                          },
                          decoration: InputDecoration(
                              hintText: 'Customer Name',
                              hintStyle: TextStyle(
                                  color: AppTheme.greyish,
                                  fontWeight: FontWeight.w500),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              BlocBuilder<ImportContactsCubit, ImportContactsState>(
                builder: (context, state) {
                  if (state is SearchedImportedContacts) {
                    return contactListWithOtherWidgets(
                        state.searchedContacts, state.searchQuery, context);
                  }
                  if (state is FetchedImportedContacts) {
                    return contactListWithOtherWidgets(
                        state.fetchedContacts, '', context);
                  }
                  return Expanded(
                      child: Center(child: CircularProgressIndicator(color: AppTheme.electricBlue,)));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget contactListWithOtherWidgets(List<ImportContactModel> contacts,
          String searchQuery, BuildContext context) =>
      Flexible(
        child: Column(children: [
          // Padding(
          //   padding: const EdgeInsets.only(top: 8.0),
          //   child: ListTile(
          //     leading: CircleAvatar(
          //       radius: 25,
          //       backgroundColor: Color(0xff2ed06d),
          //       child: SvgPicture.asset(AppAssets.addCustomerIcon),
          //     ),
          //     title: CustomText(
          //       searchQuery.length > 0
          //           ? 'Add \'$searchQuery\''
          //           : 'Add New Customer',
          //       bold: FontWeight.w500,
          //       size: 17,
          //       color: AppTheme.electricBlue,
          //     ),
          //     onTap: () {
          //       Navigator.of(context).pushNamed(AppRoutes.addCustomerFormRoute,
          //           arguments: searchQuery);
          //     },
          //     trailing: Icon(
          //       Icons.chevron_right_rounded,
          //       color: AppTheme.electricBlue,
          //       size: 35,
          //     ),
          //   ),
          // ),
          // Divider(
          //   color: AppTheme.electricBlue,
          //   endIndent: 15,
          //   indent: 15,
          //   thickness: 2,
          // ),
          ImportContactsListWidget(
              contacts: contacts,
              customerId: widget.customerId,
              customerName: widget.customerName,
              chatId: widget.chatId,
              phoneNo: widget.phoneNo,
              sendContact: widget.sendContact),
        ]),
      );
}

class ImportContactsListWidget extends StatefulWidget {
  final List<ImportContactModel> contacts;
  final String? customerName;
  final String? chatId;
  final String? customerId;
  final String? phoneNo;
  final Function(String? contactName, String? contactNo, int messageType)?
      sendContact;

  const ImportContactsListWidget(
      {Key? key,
      required this.contacts,
      required this.customerId,
      required this.customerName,
      this.chatId,
      required this.phoneNo,
      this.sendContact})
      : super(key: key);

  @override
  _ImportContactsListWidgetState createState() =>
      _ImportContactsListWidgetState();
}

class _ImportContactsListWidgetState extends State<ImportContactsListWidget> {
  // Repository _repository = Repository();
  // CustomerModel _customerModel = CustomerModel();
  // late ContactController _contactController;

  @override
  void initState() {
    super.initState();
    // _contactController = ContactController(
    //   context: context,
    // );
  }

  @override
  void dispose() {
    // _contactController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // _contactController.initProvider();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: widget.contacts.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              debugPrint(widget.customerId);
              // _contactController.sendMessage(
              //     widget.customerId,
              //     widget.chatId,
              //     widget.customerName,
              //     widget.phoneNo!,
              //     null,
              //     null,
              //     null,
              //     widget.contacts[index].name!.trim(),
              //     widget.contacts[index].mobileNo!.trim(),
              //     widget.contacts[index].avatar,
              //     4);
              widget.sendContact!(widget.contacts[index].name.trim(),
                  widget.contacts[index].mobileNo.trim(), 4);
              Navigator.pop(context);
              // _customerModel
              //   ..name = getName(widget.contacts[index].name.trim(),
              //       widget.contacts[index].mobileNo.trim())
              //   ..mobileNo = widget.contacts[index].mobileNo.trim()
              //   ..avatar = widget.contacts[index].avatar
              //   ..isChanged = true;
              // /*  if (await checkConnectivity) {
              //   final apiResponse = await _repository.contactApi
              //       .saveContact(_customerModel);
              // } */
              // if (!(await widget.contacts[index].isAdded)) {
              //   final response =
              //       await _repository.queries.insertCustomer(_customerModel);
              //   if (response != null) {
              //     BlocProvider.of<ContactsCubit>(context).getContacts();
              //     BlocProvider.of<ImportContactsCubit>(context)
              //         .updateContacts(_customerModel.mobileNo);
              //     if (!isCustomerAddedNotifier.value)
              //       isCustomerAddedNotifier.value = true;
              //   }
              //   Navigator.of(context).pop();
              // } else {
              //   Scaffold.of(context).showSnackBar(SnackBar(
              //     content: Text(getName(widget.contacts[index].name.trim(),
              //             widget.contacts[index].mobileNo.trim()) +
              //         ' is Already Added'),
              //     behavior: SnackBarBehavior.floating,
              //     margin:
              //         EdgeInsets.only(bottom: 50, left: 15, right: 15, top: 15),
              //   ));
              // }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
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
                    child: CustomProfileImage(
                      avatar: widget.contacts[index].avatar,
                      mobileNo: widget.contacts[index].mobileNo,
                      name: widget.contacts[index].name,
                    ),
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
                  // FutureBuilder<bool>(
                  //   future: widget.contacts[index].isAdded,
                  //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //     if (snapshot.data != null)
                  //       return CustomText(
                  //         snapshot.data ? 'Already Added' : '',
                  //         color: AppTheme.greyish,
                  //       );
                  //     return Container();
                  //   },
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
