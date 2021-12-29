import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:urbanledger/Cubits/Notifications/notificationlist_cubit.dart';
import 'package:urbanledger/Models/notification_list_model.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/extensions.dart';

class UserNotifications extends StatefulWidget {
  final List<NotificationData>? dataList;
  const UserNotifications({Key? key, this.dataList}) : super(key: key);


  @override
  _UserNotificationsState createState() => _UserNotificationsState();
}

class _UserNotificationsState extends State<UserNotifications> {
  // bool isItemSelected = false;
  int itemSelectedCount = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 16),
              color: AppTheme.electricBlue,
              child:  Row(
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
                      Text('Notification(${widget.dataList?.length})',style: TextStyle(color: Colors.white,fontSize: 20)),
                    ],
                  ),
                  itemSelectedCount>0?Text('${itemSelectedCount} items selected',style: TextStyle(color: Colors.white,fontSize: 16),):InkWell(child: Text('Mark all as Read',style: TextStyle(color: Colors.white,fontSize: 16),),onTap: (){
                    BlocProvider.of<NotificationListCubit>(context,listen:false).markAllAsRead();

                  },),

                ],)),
          Expanded(child: ListView.builder(itemBuilder:(ctx,i)=>listItem(widget.dataList![i],i),itemCount: widget.dataList?.length))
          // AppBar(title: Text('Notifications(03)'),backgroundColor: AppTheme.electricBlue,)
        ],),),
      bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child:itemSelectedCount>0?InkWell(
            child: Icon(Icons.delete,color: Colors.red,size: 30,),onTap: (){
            BlocProvider.of<NotificationListCubit>(context,listen:false).deleteNotifications();
          },):InkWell(
            child: Container(
                child: Text('Clear',textAlign: TextAlign.center,)),onTap: (){
            BlocProvider.of<NotificationListCubit>(context,listen:false).clearAllNotification();
          },)),
    );
  }
  Widget listItem(NotificationData data,int index){
    return Dismissible(
      key: Key(data.id.toString()),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      onDismissed: (direction) async {
        // Remove the item from the data source.
         BlocProvider.of<NotificationListCubit>(context,listen:false).clearNotification(index);

        // Then show a snackbar.
      /*  ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Item cleared.')));*/
      },
      child: GestureDetector(
        onLongPress: (){
          setState(() {
            data.isSelected = !data.isSelected;
            data.isSelected?++itemSelectedCount:--itemSelectedCount;
          });


        },
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              padding: EdgeInsets.symmetric(
                  horizontal: 0, vertical: 18), //horizonal-4
              decoration: BoxDecoration(
                color:  data.isSelected ?Colors.grey:Colors.white,
              ),
              child: GestureDetector(
                // onTap: () {
                //   showTranactionBottomSheet(context, data[index]);
                // },
                /*

                       */
                child: ListTile(
                  onTap: () {


                  },
                  leading: Stack(
                    children: [
                      Image.asset(
                        AppAssets.transactionsLink01,
                        height: 40,
                      ),
                  Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: data.read??false
                          ? Icon(
                        Icons.check,
                        size: 30.0,
                        color: Colors.white,
                      )
                          : Icon(
                        Icons.check_box_outline_blank,
                        size: 30.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                    ],
                  ),

                  title: Row(
                    children: [
                      CustomText(
                        'Urban Ledger',
                        bold: FontWeight.w600,
                        size: 16,
                        color: AppTheme.brownishGrey,
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      6.0.heightBox,
                      CustomText(
                        '${data.body}',
                        size: 16,
                        color: AppTheme.brownishGrey,
                        bold: FontWeight.w400,
                      ),
                    ],
                  ),
                  trailing: Container(
                    child: CustomText(
                      "${DateFormat('dd MMM yyyy | hh:mm aa').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse('${data.createdAt}'))}"
                      ,
                      size: 12,
                      color: AppTheme.brownishGrey,
                      bold: FontWeight.w400,
                    ),
                  ),
                ),
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
}
