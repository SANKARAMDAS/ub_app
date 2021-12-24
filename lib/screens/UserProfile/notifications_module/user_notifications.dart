import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/extensions.dart';

class UserNotifications extends StatefulWidget {
  const UserNotifications({Key? key}) : super(key: key);

  @override
  _UserNotificationsState createState() => _UserNotificationsState();
}

class _UserNotificationsState extends State<UserNotifications> {
  bool isItemSelected = false;
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
              Text('Notification(03)',style: TextStyle(color: Colors.white,fontSize: 20)),
            ],
          ),
            Text('Mark all as Read',style: TextStyle(color: Colors.white,fontSize: 16),),

        ],)),
        Expanded(child: ListView.builder(itemBuilder:(ctx,i)=>listItem(i),itemCount: 5, ))
       // AppBar(title: Text('Notifications(03)'),backgroundColor: AppTheme.electricBlue,)
      ],),),
      bottomNavigationBar: Container(
         color: Colors.white,
        padding: EdgeInsets.all(20),
          child:isItemSelected?InkWell(
            child: Container(
                child: Text('Clear',textAlign: TextAlign.center,)),onTap: (){
            Navigator.of(context).pop();
          },):InkWell(
        child: Icon(Icons.delete,color: Colors.red,size: 30,),onTap: (){
        Navigator.of(context).pop();
      },)),
    );
  }
  Widget listItem(int index){
    return GestureDetector(
      onLongPress: (){
        setState(() {
          isItemSelected = true;
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
                color: isItemSelected?Colors.grey:Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: index == 0 ? Radius.circular(10) : Radius.zero,
                    topRight:
                    index == 0 ? Radius.circular(10) : Radius.zero)),
            child: GestureDetector(
              // onTap: () {
              //   showTranactionBottomSheet(context, data[index]);
              // },
              /*

                     */
              child: ListTile(
                onTap: () {


                },
                leading: Image.asset(
                  AppAssets.transactionsLink01,
                  height: 40,
                ),

                title: CustomText(
                  'Urban Ledger',
                  bold: FontWeight.w600,
                  size: 16,
                  color: AppTheme.brownishGrey,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    6.0.heightBox,
                    CustomText(
                     'Our firm is involed in rendering Housekeeping Manpower Services',
                      size: 16,
                      color: AppTheme.brownishGrey,
                      bold: FontWeight.w400,
                    ),
                  ],
                ),
                trailing: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.min,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      "${DateFormat('dd MMM yyyy | hh:mm aa').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse('2007-03-06 13:44:25'))}"
                         ,
                      size: 12,
                      color: AppTheme.brownishGrey,
                      bold: FontWeight.w400,
                    )
                    /*Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: isChecked.contains(index),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value!) {
                                  isChecked.add(index);
                                  data2.add(data[index]);
                                } else {
                                  isChecked.remove(index);
                                  data2.remove(data[index]);
                                }
                              });
                            },
                          )*/
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
    );
  }

  Widget appbar(BuildContext context){
    return AppBar(
       title: Text('Notification(03)'),
    );

  }
}
