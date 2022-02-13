import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
import 'package:urbanledger/Cubits/Notifications/notificationlist_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/notification_list_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/chat_module/data/repositories/chat_repository.dart';
import 'package:urbanledger/chat_module/screens/contact/contact_controller.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:uuid/uuid.dart';

class UserNotifications extends StatefulWidget {
  final List<NotificationData>? dataList;
  const UserNotifications({Key? key, this.dataList}) : super(key: key);


  @override
  _UserNotificationsState createState() => _UserNotificationsState();
}

class _UserNotificationsState extends State<UserNotifications> {
  // bool isItemSelected = false;
  //int itemSelectedCount = 0;
  ChatRepository _chatRepository = ChatRepository();
  final GlobalKey<State> key = GlobalKey<State>();
  final repository = Repository();
  List<NotificationData> selectedList = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: key,
      body: Container(
        color: Colors.white,
        child: Column(children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 16),
              color: AppTheme.electricBlue,
              child: BlocConsumer<NotificationListCubit, NotificationListState>(
                  listener: (context, state) {
                    // do stuff here based on BlocA's state
                  },
                  buildWhen: (previous, current) {
                    return current is FetchedNotificationListState;
                    // return true/false to determine whether or not
                    // to rebuild the widget with state
                  },
                  builder: (context, state) {
                    if(state is FetchedNotificationListState){
                      return  state.notificationList.length > 0? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  color:AppTheme.electricBlue,
                                  child:Icon(Icons.arrow_back_ios_rounded,color: Colors.white,)
                                ),
                                
                                onTap: (){
                                Navigator.of(context).pop();
                              },),
                              SizedBox(width: 4,),
                              Text('Notification (${widget.dataList?.length})',style: TextStyle(color: Colors.white,fontSize: 20)),
                            ],
                          ),

                          selectedList.length >0?Text(selectedList.length>1?'${selectedList.length} items selected':'${selectedList.length} item selected',style: TextStyle(color: Colors.white,fontSize: 16),):InkWell(child: Text('Mark all as Read',style: TextStyle(color: Colors.white,fontSize: 16),),onTap: (){
                            BlocProvider.of<NotificationListCubit>(context,listen:false).markAllAsRead();

                          },),

                        ],):Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                child: Icon(Icons.arrow_back_ios_rounded,color: Colors.white,),onTap: (){
                                Navigator.of(context).pop();
                              },),
                              SizedBox(width: 8,),
                              Text('Notification (0)',style: TextStyle(color: Colors.white,fontSize: 20)),
                            ],
                          ),

                         Container()

                        ],);

                    }
                    return Container(child:Center(child: CircularProgressIndicator(color: AppTheme.electricBlue,)));
                    // return widget here based on BlocA's state
                  }
              )),
          Expanded(child:BlocConsumer<NotificationListCubit, NotificationListState>(
              listener: (context, state) {
                // do stuff here based on BlocA's state
              },
              buildWhen: (previous, current) {
                return current is FetchedNotificationListState;
                // return true/false to determine whether or not
                // to rebuild the widget with state
              },
              builder: (context, state) {
                if(state is FetchedNotificationListState){
                  return  state.notificationList.length > 0?Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemBuilder:(ctx,i)=>listItem(widget.dataList![i],i),itemCount: widget.dataList?.length),
                      ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20),
                          child:selectedList.length>0?InkWell(
                            child: Image.asset(
                              AppAssets.delete_notification_icon,
                              height: 45,
                              width: 45,
                            ),onTap: () async {
                            await BlocProvider.of<NotificationListCubit>(context,listen:false).deleteNotifications(selectedList);
                            setState(() {
                              selectedList = [];
                            });
                          },):InkWell(
                            child: Container(
                                child: CustomText(
                                  'Clear all',
                                  bold: FontWeight.w600,
                                  size: 20,
                                  color: AppTheme.brownishGrey,
                                  centerAlign: true,
                                )),onTap: () async {
                            await BlocProvider.of<NotificationListCubit>(context,listen:false).clearAllNotification();
                            setState(() {
                              selectedList = [];
                            });
                          },))
                    ],
                  ):Container(child:Column(children: [
                    Expanded(
                      child: Stack(

                        children: [
                          Image.asset(
                            AppAssets.notification_empty,
                          ),
                          Positioned(
                            bottom:0,
                            left:0,
                            right:0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: Text('Currently you have no notifications',textAlign: TextAlign.center,style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500,color:AppTheme.brownishGrey,),),
                            ),
                          ),
                        ],
                        clipBehavior: Clip.none,
                      ),
                      flex: 7,
                    ),

                    Expanded(
                      flex:3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(


                            child: ElevatedButton(

                                onPressed: () {
                                  Navigator.of(context).pop();
                               },
                                child: CustomText(
                                  'BACK',
                                  size: (18),
                                  bold: FontWeight.w500,
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 48,vertical:12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),

                            ),
                          ),
                        ],
                      ),
                    )
                  ],));

                }
                return Container(child:Center(child: CircularProgressIndicator(color: AppTheme.electricBlue,)));
              // return widget here based on BlocA's state
              }
          ))
          // AppBar(title: Text('Notifications(03)'),backgroundColor: AppTheme.electricBlue,)
        ],),),
    );
  }

  Future<void> onNotificationTap(NotificationData message) async {
    CustomerModel _customerModel = CustomerModel();
    switch (message.data?.type) {
    // code commented Waiting for client confimation
    // case 'ledger_gave':
    //   _customerModel
    //     ..customerId = message.data['customerId']
    //     ..mobileNo = message.data['mobile_no']
    //     ..name = message.data['name']
    //     ..chatId = message.data['chatId']
    //     ..businessId = message.data['businessId'];
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => PayTransactionScreen(
    //         model: _customerModel,
    //         customerId: message.data['customerId'],
    //         amount: message.data['amount'],
    //       ),
    //     ),
    //   );
    //   break;
    // case 'update_ledger_gave':
    //   _customerModel
    //     ..customerId = message.data['customerId']
    //     ..mobileNo = message.data['mobile_no']
    //     ..name = message.data['name']
    //     ..chatId = message.data['chatId']
    //     ..businessId = message.data['businessId'];
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => PayTransactionScreen(
    //         model: _customerModel,
    //         customerId: message.data['customerId'],
    //         amount: message.data['amount'],
    //       ),
    //     ),
    //   );
    //   break;
    // case 'delete_ledger_gave':
    //   Navigator.of(context).pushNamed(AppRoutes.mainRoute);
    //   break;
      case 'payment':
        debugPrint('payment .... ... ');
        paymentNotification(message.data?.transactionId??'');
        Navigator.of(context).pushNamed(AppRoutes.paymentDetailsRoute,
            arguments: TransactionDetailsArgs(
              urbanledgerId: message.data?.urbanledgerId,
              transactionId: message.data?.transactionId,
              to: message.data?.toId,
              toEmail: message.data?.toEmail,
              from: message.data?.fromId,
              fromEmail: message.data?.fromEmail,
              completed: message.data?.completed?.toIso8601String(),
              paymentMethod: message.data?.paymentMethod,
              amount: message.data?.amount.toString(),
              cardImage:
              message.data?.cardImage?.toString().replaceAll(' ', ''),
              endingWith: message.data?.endingWith,
              customerName: message.data?.customerName,
              mobileNo: message.data?.fromMobileNumber,
              paymentStatus: message.data?.paymentStatus?.toString(),
            ));
        break;
      case 'bank_account': //in progress from back end
        await CustomSharedPreferences.setBool('isBankAccount', true);
        debugPrint('ffffffffffffK');
        Navigator.of(context)
            .pushReplacementNamed(AppRoutes.profileBankAccountRoute);
        CustomLoadingDialog.showLoadingDialog(context);
        break;
      case 'payment_request':
        CustomLoadingDialog.showLoadingDialog(context);
        debugPrint('payment_request : ');
        double amount = double.parse(message.data?.amount.toString()??'0.0');
        var cid = await repository.customerApi
            .getCustomerID(mobileNumber: message.data?.fromMobileNumber.toString())
            .timeout(Duration(seconds: 30), onTimeout: () async {
          Navigator.of(context).pop();
          return Future.value(null);
        });
        /*_customerModel
          ..ulId = cid.customerInfo?.id != null ? cid.customerInfo?.id : cid.id
          ..mobileNo = message.data['mobileNo']
          ..name = message.data['name']
          ..chatId = message.data['chatId']
          ..businessId = message.data['businessId'];*/
        final localCustId =
        await repository.queries.getCustomerId(_customerModel.mobileNo!);
        // final localCustId = '76aeff10-f8f8-11eb-bd60-0d0a52481fd7';
        final uniqueId = Uuid().v1();
        if (localCustId.isEmpty) {
          final customer = CustomerModel()
            ..name =
            getName(_customerModel.name!.trim(), _customerModel.mobileNo!)
            ..mobileNo = (_customerModel.mobileNo!)
            ..avatar = _customerModel.avatar
            ..customerId = uniqueId
            ..businessId = Provider.of<BusinessProvider>(context, listen: false)
                .selectedBusiness
                .businessId
            ..chatId = _customerModel.chatId
            ..isChanged = true;
          await repository.queries.insertCustomer(customer);
        }

        // Navigator.of(context).pushNamed(
        //   AppRoutes.payTransactionRoute,
        //   arguments: QRDataArgs(
        //       customerModel: _customerModel,
        //       customerId: localCustId.isEmpty ? uniqueId : localCustId,
        //       amount: amount.toInt().toString(),
        //       requestId: message.data['request_id'],
        //       type: 'DIRECT',
        //       suspense: false,
        //       through: 'DIRECT'),
        // );

        Map<String, dynamic> isTransaction =
        await repository.paymentThroughQRApi.getTransactionLimit(context);
        if (!(isTransaction)['isError']) {
          // Navigator.of(context).pop(true);
          // showBankAccountDialog();
          debugPrint('Customer iiid: ' + message.customerId!);
          Navigator.of(context).popAndPushNamed(
            AppRoutes.payTransactionRoute,
            arguments: QRDataArgs(
                customerModel: _customerModel,
                customerId: localCustId.isEmpty ? uniqueId : localCustId,
                amount: amount.toInt().toString(),
                requestId: message.data?.requestId,
                type: 'DIRECT',
                suspense: false,
                through: 'DIRECT'),
          );
        } else {
          Navigator.of(context).pop(true);
          '${(isTransaction)['message']}'.showSnackBar(context);
        }
        break;
      case 'add_customer':
        Navigator.of(context).pushNamed(AppRoutes.mainRoute);
        break;
      case 'add_kyc':
        await CustomSharedPreferences.setBool('isKYC', true);
        Navigator.of(context).pushNamed(AppRoutes.manageKyc1Route);
        break;
      case 'complete_kyc_reminder':
        await CustomSharedPreferences.setBool('isKYC', true);
        Navigator.of(context).pushNamed(AppRoutes.manageKyc1Route);
        break;
      case 'premium':
        await CustomSharedPreferences.setBool('isKYC', true);
        Navigator.of(context).pushNamed(AppRoutes.manageKyc1Route);
        break;
      case 'ledger_addentry':
        Navigator.of(context).pushNamed(AppRoutes.mainRoute);
        break;
      case 'premium_reminder':
        redirectToPremiumPurchase();
        break;
      case 'buy_premium_reminder_kcy':
        redirectToPremiumPurchase();
        break;
      case 'buy_premium_reminder_all':
        redirectToPremiumPurchase();
        break;
      case 'complete_email_verification_reminder':
        Navigator.of(context).pushNamed(AppRoutes.edituserProfileRoute);
        break;
      case 'chat':
        _customerModel
          ..customerId = message.customerId
          ..mobileNo = message.data?.fromMobileNumber
          ..name = message.data?.customerName
          ..chatId = message.data?.chatId
          ..businessId = message.data?.businessId;
        debugPrint('dddaattta' + _customerModel.toJson().toString());
        ContactController.initChat(context, _customerModel.chatId);
        localCustomerId = _customerModel.customerId!;
        BlocProvider.of<LedgerCubit>(context)
            .getLedgerData(_customerModel.customerId!);
        Navigator.of(context).pushNamed(AppRoutes.transactionListRoute,
            arguments: TransactionListArgs(true, _customerModel));
        break;
      default:
        Navigator.of(context).pushNamed(AppRoutes.mainRoute);
    }
  }

  redirectToPremiumPurchase()async{
    if (await kycChecker(context)) {
    await calculatePremiumDate();

    if (Repository().hiveQueries.userData.premiumStatus ==
    0) {
    Navigator.of(context)
        .pushNamed(AppRoutes.urbanLedgerPremiumRoute);

    // CustomLoadingDialog.showLoadingDialog(context, key);
    } else {
    Navigator.of(context)
        .pushNamed(AppRoutes.upgrdUnsubsRoute);

    // CustomLoadingDialog.showLoadingDialog(context, key);
    }
    }
  }

  paymentNotification(String transactionId) async {

    Map<String?, dynamic>? response =
    await _chatRepository.getTransactionDetails(transactionId);
    debugPrint(response.toString());
    // Navigator.of(context).popAndPushNamed(
    //                 AppRoutes.paymentDetailsRoute,
    //                 arguments: TransactionDetailsArgs(
    //                     urbanledgerId: (response)?['urbanledgerId'],
    //                     transactionId: (response)?['transactionId'],
    //                     to: (response)?['to'],
    //                     toEmail: (response)?['toEmail'],
    //                     from: (response)?['from'],
    //                     fromEmail: (response)?['fromEmail'],
    //                     completed: (response)?['completed'],
    //                     paymentMethod: (response)?['paymentMethod'],
    //                     amount: (response)?['amount'].toString(),
    //                     cardImage: (response)?['cardImage']
    //                         .toString()
    //                         .replaceAll(' ', ''),
    //                     endingWith: (response)?['endingWith'],
    //                     customerName: widget.customerModel.name,
    //                     mobileNo: widget.customerModel.mobileNo,
    //                     paymentStatus: message.paymentStatus));
  }
  Widget listItem(NotificationData data,int index){
    return Dismissible(

      key: Key(data.id.toString()),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      onDismissed: (direction) async {
        // Remove the item from the data source.
        setState(() {
          selectedList.removeWhere((element) =>element ==data);
        });
        await BlocProvider.of<NotificationListCubit>(context,listen:false).clearNotification(index);




        // Then show a snackbar.
      /*  ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Item cleared.')));*/
      },
      child: GestureDetector(
        onLongPress: selectedList.length<=1?(){
          /*setState(() {
            data.isSelected = !data.isSelected;
            data.isSelected?++itemSelectedCount:--itemSelectedCount;
          });*/

          setState(() {
            if(selectedList.contains(data)){
              selectedList.remove(data);
            }
            else{
              selectedList.add(data);
            }

          });


        }:(){

        },
        onTap: selectedList.length>0?(){
          setState(() {
            if(selectedList.contains(data)){
              selectedList.remove(data);
            }
            else{
              selectedList.add(data);
            }

          });

        }:(){
          BlocProvider.of<NotificationListCubit>(context,listen:false).markAsRead(index);
          onNotificationTap(data);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 0),
              padding: EdgeInsets.symmetric(
                  horizontal: 0, vertical: 18), //horizonal-4
              decoration: BoxDecoration(
                color:  selectedList.contains(data) ?Colors.grey[200]:Colors.white,
              ),
              child: GestureDetector(
                // onTap: () {
                //   showTranactionBottomSheet(context, data[index]);
                // },
                /*

                       */
                child: customListItem(data)
              ),
            ),
            Container(
              color: Colors.white,
              child: Divider(
                height: 1,
                color: AppTheme.senderColor,
                /* endIndent: 24,
                indent: 24,*/
              ),
            )
          ],
        ),
      ),
    );
  }




  Widget appbar(BuildContext context){
    return AppBar(
      title: Text('Notification(03)'),
    );

  }

  Widget customListItem(NotificationData data){
  DateTime currentDateTime =  new DateTime.now();
 // DateTime time=  currentDateTime.subtract(new Duration(days:currentDateTime.difference(data.createdAt!).inDays,hours: currentDateTime.difference(data.createdAt!).inHours,minutes:currentDateTime.difference(data.createdAt!).inMinutes,seconds: currentDateTime.difference(data.createdAt!).inSeconds));
    DateTime time = data.createdAt!;

  return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            width: 80,
            height: 80,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 10,
                    left:10,
                    child: Image.asset(
                      data.read??false?AppAssets.notification_unselected:AppAssets.notification_selected,
                      height: 60,
                      width: 60,
                    ),
                  ),
                  if(selectedList.length>0)
                    Positioned(
                      top:30,
                      left:30,
                      child: Container(
                        child: Image.asset(
                         selectedList.contains(data)?AppAssets.check_selected:AppAssets.check_unselected,
                          height: 60,
                          width: 60,
                        ),
                      ),
                    ),

                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: _NotificationDescription(
            data: data,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
          child: CustomText(
            // "${DateFormat('dd MMM yyyy | hh:mm aa').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse('${data.createdAt}'))}"
            //timeago.format(DateFormat("yyyy-MM-dd hh:mm:ss").parse('${data.createdAt}'))
            timeago.format(time)
            ,
            size: 12,
            color: data.read??false?Colors.grey[500]:AppTheme.brownishGrey,
            bold: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}






class _NotificationDescription extends StatelessWidget {
  const _NotificationDescription({
    Key? key,
    required this.data,
  }) : super(key: key);

  final NotificationData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomText(
            '${data.title}',
            bold: FontWeight.w600,
            size: 20,
            color: data.read??false?Colors.grey[500]:AppTheme.brownishGrey,
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          CustomText(
            '${data.body}',
            size: 16,
            color: data.read??false?Colors.grey[500]:AppTheme.brownishGrey,
            bold: FontWeight.w400,
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
      
        ],
      ),
    );
  }
}




