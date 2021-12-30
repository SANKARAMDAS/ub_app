import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:urbanledger/Cubits/Notifications/notificationlist_cubit.dart';
import 'package:urbanledger/Models/notification_list_model.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:timeago/timeago.dart' as timeago;

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
                      Text('Notification (${widget.dataList?.length})',style: TextStyle(color: Colors.white,fontSize: 20)),
                    ],
                  ),
                  itemSelectedCount>0?Text('${itemSelectedCount} items selected',style: TextStyle(color: Colors.white,fontSize: 16),):InkWell(child: Text('Mark all as Read',style: TextStyle(color: Colors.white,fontSize: 16),),onTap: (){
                    BlocProvider.of<NotificationListCubit>(context,listen:false).markAllAsRead();

                  },),

                ],)),
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
                return  ListView.builder(
                    padding: EdgeInsets.zero,
                    itemBuilder:(ctx,i)=>listItem(widget.dataList![i],i),itemCount: widget.dataList?.length);
                // return widget here based on BlocA's state
              }
          ))
          // AppBar(title: Text('Notifications(03)'),backgroundColor: AppTheme.electricBlue,)
        ],),),
      bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child:itemSelectedCount>0?InkWell(
            child: Image.asset(
             AppAssets.delete_notification_icon,
              height: 45,
              width: 45,
            ),onTap: () async {
           await BlocProvider.of<NotificationListCubit>(context,listen:false).deleteNotifications();
           setState(() {
             itemSelectedCount = 0;
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
              itemSelectedCount = 0;
            });
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
        await BlocProvider.of<NotificationListCubit>(context,listen:false).clearNotification(index);

           setState(() {
             --itemSelectedCount;
           });

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
              margin: EdgeInsets.symmetric(vertical: 0),
              padding: EdgeInsets.symmetric(
                  horizontal: 0, vertical: 18), //horizonal-4
              decoration: BoxDecoration(
                color:  data.isSelected ?Colors.grey[200]:Colors.white,
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
                  leading: Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
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
                      Positioned(
                        top:30,
                        left:30,
                        child: Container(
                          child: Image.asset(
                            data.isSelected?AppAssets.check_selected:AppAssets.check_unselected,
                            height: 60,
                            width: 60,
                          ),
                        ),
                      ),

                        ],
                      ),
                    ),
                  ),

                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        '${data.title}',
                        bold: FontWeight.w600,
                        size: 20,
                        color: data.read??false?Colors.grey[500]:AppTheme.brownishGrey,
                      ),
                      Container(
                        child: CustomText(
                          // "${DateFormat('dd MMM yyyy | hh:mm aa').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse('${data.createdAt}'))}"
                          timeago.format(DateFormat("yyyy-MM-dd hh:mm:ss").parse('${data.createdAt}'))
                          ,
                          size: 12,
                          color: data.read??false?Colors.grey[500]:AppTheme.brownishGrey,
                          bold: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      6.0.heightBox,
                      CustomText(
                        '${data.body}',
                        size: 16,
                        color: data.read??false?Colors.grey[500]:AppTheme.brownishGrey,
                        bold: FontWeight.w400,
                      ),
                    ],
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
