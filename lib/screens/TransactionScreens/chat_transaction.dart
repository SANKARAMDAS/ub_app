// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../../Utility/app_constants.dart';
// import 'package:urbanledger/Utility/app_theme.dart';
// import 'package:urbanledger/screens/Components/custom_text_widget.dart';
// import 'package:urbanledger/screens/Components/extensions.dart';

// class ChatTransactionScreen extends StatefulWidget {
//   String messageContent;
//   String messageType;
//   String request;
//   String money;
//   String msg;
//   String date;
//   String rewards;
//   String reminder;
//   String audio;
//   String name;
//   String mob_no;
//   String contact;
//   ChatTransactionScreen({
//     required this.messageContent,
//     required this.messageType,
//     required this.money,
//     required this.msg,
//     required this.date,
//     required this.request,
//     required this.rewards,
//     required this.reminder,
//     required this.audio,
//     required this.name,
//     required this.mob_no,
//     required this.contact,
//   });
//   @override
//   _ChatTransactionScreenState createState() => _ChatTransactionScreenState();
// }

// List<ChatTransactionScreen> messages = [
//   ChatTransactionScreen(
//     messageContent: "Hii",
//     messageType: "receiver",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "Yes",
//     messageType: "receiver",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "",
//     messageType: "sender",
//     money: '$currencyAED 70,000',
//     msg: 'Work payment',
//     date: 'Feb-21',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "",
//     messageType: "receiver",
//     money: '$currencyAED 70,000',
//     msg: 'Work payment',
//     date: 'Feb-21',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "Yes",
//     messageType: "sender",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "Please send back",
//     messageType: "receiver",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "Ok",
//     messageType: "sender",
//     money: '',
//     msg: '',
//     date: '',
//     request: '',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "",
//     messageType: "sender",
//     money: '$currencyAED 70,000',
//     msg: 'for advanced trip',
//     date: '4:44 PM',
//     request: '1',
//     rewards: '1',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "Yes",
//     messageType: "receiver",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "Please send back",
//     messageType: "sender",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "Hi",
//     messageType: "receiver",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "Yes",
//     messageType: "sender",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "Please send back",
//     messageType: "receiver",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "Ok",
//     messageType: "sender",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "Hii",
//     messageType: "receiver",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "Yes",
//     messageType: "receiver",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "Please send back",
//     messageType: "sender",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "",
//     messageType: "receiver",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: 'Venugopal Iyer',
//     mob_no: '+91 77XXXXXX13',
//     contact: '1',
//   ),
//   ChatTransactionScreen(
//     messageContent: "Yes",
//     messageType: "sender",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "Please send back",
//     messageType: "receiver",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "do",
//     messageType: "sender",
//     money: '',
//     msg: '',
//     date: '',
//     request: '0',
//     rewards: '0',
//     reminder: '0',
//     audio: '1',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
//   ChatTransactionScreen(
//     messageContent: "",
//     messageType: "sender",
//     money: '$currencyAED 70,000',
//     msg: 'for advanced trip',
//     date: '4:44 PM',
//     request: '0',
//     rewards: '0',
//     reminder: '1',
//     audio: '0',
//     name: '',
//     mob_no: '',
//     contact: '0',
//   ),
// ];

// class _ChatTransactionScreenState extends State<ChatTransactionScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.paleGrey,
//       extendBodyBehindAppBar: true,
//       bottomNavigationBar: bottomBar2(context),
//       body: CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             // leading: IconButton(
//             //   icon: Icon(Icons.filter_1),
//             //   onPressed: () {
//             //     // Do something
//             //   }
//             // ),
//             automaticallyImplyLeading: false,
//             // shape: RoundedRectangleBorder(
//             //   borderRadius: BorderRadius.only(
//             //     bottomLeft: Radius.circular(150),
//             //     bottomRight: Radius.circular(150),
//             //   )
//             // ),
//             expandedHeight: 250.0,
//             floating: true,
//             pinned: true,
//             snap: true,
//             elevation: 50,
//             backgroundColor: Colors.transparent,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Stack(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         alignment: Alignment.topCenter,
//                         image: AssetImage("assets/images/back3.png"),
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       (MediaQuery.of(context).padding.top).heightBox,
//                       ListTile(
//                         dense: true,
//                         leading: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Container(
//                               width: 30,
//                               alignment: Alignment.center,
//                               child: IconButton(
//                                 icon: Icon(
//                                   Icons.arrow_back_ios,
//                                   size: 22,
//                                 ),
//                                 color: Colors.white,
//                                 onPressed: () => Navigator.of(context).pop(),
//                               ),
//                             ),
//                             CircleAvatar(
//                               radius: 20,
//                               backgroundColor: Color(0xff666666),
//                               backgroundImage: NetworkImage(
//                                   'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
//                             ),
//                           ],
//                         ),
//                         title: CustomText(
//                           'User',
//                           color: Colors.white,
//                           size: 19,
//                           bold: FontWeight.w500,
//                         ),
//                         subtitle: Text(
//                           '+91 95394 56879',
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       receiveCollection(context),
//                       // SizedBox(height: 45,),
//                       // chatHistory(context),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (BuildContext context, index) {
//                 return Column(
//                   children: [
//                     //normal chat

//                     messages[index].messageContent != "" ||
//                             messages[index].money == "" ||
//                             messages[index].money == null ||
//                             messages[index].request == ""
//                         ? Container(
//                             padding: EdgeInsets.only(
//                                 left: 14, right: 14, top: 5, bottom: 5),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               mainAxisAlignment:
//                                   messages[index].messageType == "sender"
//                                       ? MainAxisAlignment.end
//                                       : MainAxisAlignment.start,
//                               children: [
//                                 messages[index].messageType == "sender"
//                                     ? Padding(
//                                         padding: EdgeInsets.only(right: 5),
//                                         child: Icon(
//                                           Icons.done_all_outlined,
//                                           size: 18,
//                                           color: Theme.of(context).primaryColor,
//                                         ),
//                                       )
//                                     : Container(),
//                                 Align(
//                                   alignment:
//                                       (messages[index].messageType == "receiver"
//                                           ? Alignment.topLeft
//                                           : Alignment.topRight),
//                                   child: Container(
//                                     decoration: messages[index].messageType ==
//                                             "receiver"
//                                         ? BoxDecoration(
//                                             borderRadius: BorderRadius.only(
//                                               topLeft: Radius.circular(20),
//                                               bottomLeft: Radius.circular(20),
//                                               topRight: Radius.circular(20),
//                                             ),
//                                             color: (AppTheme.receiverColor),
//                                           )
//                                         : BoxDecoration(
//                                             borderRadius: BorderRadius.only(
//                                               topRight: Radius.circular(20),
//                                               bottomLeft: Radius.circular(20),
//                                               bottomRight: Radius.circular(20),
//                                             ),
//                                             color: (AppTheme.senderColor),
//                                           ),
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 7, horizontal: 14),
//                                     child: Text(
//                                       messages[index].messageContent,
//                                       style: TextStyle(fontSize: 15),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         :
//                         // transaction money
//                         messages[index].request == "0" &&
//                                 messages[index].money != ""
//                             ? Container(
//                                 padding: EdgeInsets.only(
//                                     left: 14, right: 14, top: 5, bottom: 0),
//                                 child: Row(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     mainAxisAlignment:
//                                         messages[index].messageType == "sender"
//                                             ? MainAxisAlignment.end
//                                             : MainAxisAlignment.start,
//                                     children: [
//                                       messages[index].messageType == "sender"
//                                           ? Padding(
//                                               padding:
//                                                   EdgeInsets.only(right: 5),
//                                               child: Icon(
//                                                 Icons.done_all_outlined,
//                                                 size: 18,
//                                                 color: Theme.of(context)
//                                                     .primaryColor,
//                                               ),
//                                             )
//                                           : Container(),
//                                       Align(
//                                         alignment:
//                                             (messages[index].messageType ==
//                                                     "receiver"
//                                                 ? Alignment.topLeft
//                                                 : Alignment.topRight),
//                                         child: Card(
//                                           shape: messages[index].messageType ==
//                                                   "receiver"
//                                               ? RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.only(
//                                                     topLeft:
//                                                         Radius.circular(20),
//                                                     bottomLeft:
//                                                         Radius.circular(20),
//                                                     topRight:
//                                                         Radius.circular(20),
//                                                   ),
//                                                 )
//                                               : RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.only(
//                                                     topRight:
//                                                         Radius.circular(20),
//                                                     bottomLeft:
//                                                         Radius.circular(20),
//                                                     bottomRight:
//                                                         Radius.circular(20),
//                                                   ),
//                                                 ),
//                                           child: Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: 14,
//                                                 right: 14,
//                                                 top: 10,
//                                                 bottom: 10),
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceAround,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   "${messages[index].money}",
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 18,
//                                                     color: messages[index]
//                                                                 .messageType ==
//                                                             "sender"
//                                                         ? AppTheme.tomato
//                                                         : AppTheme.greenColor,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   '${messages[index].msg}',
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 14,
//                                                     color: Colors.black,
//                                                   ),
//                                                 ),
//                                                 RichText(
//                                                   text: TextSpan(
//                                                     style: Theme.of(context)
//                                                         .textTheme
//                                                         .bodyText2,
//                                                     children: [
//                                                       TextSpan(
//                                                         text: messages[index].messageType ==
//                                                                 "sender"
//                                                             ? 'You paid - ' +
//                                                                 messages[index]
//                                                                     .date
//                                                             : 'You were paid - ' +
//                                                                 messages[index]
//                                                                     .date,
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                           color: AppTheme
//                                                               .brownishGrey,
//                                                         ),
//                                                       ),
//                                                       WidgetSpan(
//                                                         child: Padding(
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                                   horizontal:
//                                                                       2.0),
//                                                           child: Icon(
//                                                             Icons
//                                                                 .check_circle_outline_outlined,
//                                                             size: 14,
//                                                             color: AppTheme
//                                                                 .greenColor,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       WidgetSpan(
//                                                         child: Padding(
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                                   horizontal:
//                                                                       2.0),
//                                                           child: Icon(
//                                                             Icons
//                                                                 .arrow_forward_ios,
//                                                             size: 14,
//                                                             color: AppTheme
//                                                                 .brownishGrey,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ]),
//                               )
//                             : Container(),
//                     // contact send
//                     messages[index].contact == "1"
//                         ? Container(
//                             padding: EdgeInsets.only(
//                                 left: 14, right: 14, top: 5, bottom: 5),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               mainAxisAlignment:
//                                   messages[index].messageType == "sender"
//                                       ? MainAxisAlignment.end
//                                       : MainAxisAlignment.start,
//                               children: [
//                                 Column(
//                                   children: [
//                                     ClipPath(
//                                         clipper: ShapeBorderClipper(
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.only(
//                                             topLeft: Radius.circular(10),
//                                             topRight: Radius.circular(10),
//                                           )),
//                                         ),
//                                         child: Container(
//                                           height: 70.0,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.60,
//                                           // decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           //     border: Border(
//                                           //         bottom: BorderSide(
//                                           //             color: Color.fromRGBO(0, 0, 0, 1),
//                                           //             width: 0.5
//                                           //         )
//                                           //     ),
//                                           // ),
//                                           child: Column(
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 10,
//                                                         top: 10,
//                                                         right: 5),
//                                                     child: CircleAvatar(
//                                                       radius: 20,
//                                                       backgroundColor:
//                                                           Color(0xff666666),
//                                                       backgroundImage: NetworkImage(
//                                                           'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 5,
//                                                         top: 10,
//                                                         right: 10),
//                                                     child: Text(
//                                                       'Venugopal Iyer',
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       style: TextStyle(
//                                                           fontSize: 18,
//                                                           color:
//                                                               Theme.of(context)
//                                                                   .primaryColor,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Align(
//                                                 alignment:
//                                                     Alignment.bottomRight,
//                                                 child: Padding(
//                                                   padding: EdgeInsets.only(
//                                                       right: 10),
//                                                   child: Text(
//                                                     '4:44PM',
//                                                     style: TextStyle(
//                                                         fontSize: 10,
//                                                         color:
//                                                             AppTheme.greyish),
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         )),
//                                     ClipPath(
//                                         clipper: ShapeBorderClipper(
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.only(
//                                             bottomLeft: Radius.circular(10),
//                                             bottomRight: Radius.circular(10),
//                                           )),
//                                         ),
//                                         child: Container(
//                                           height: 35.0,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.60,
//                                           // color: Colors.white,
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             border: Border(
//                                                 top: BorderSide(
//                                                     color: AppTheme.greyish,
//                                                     width: 0.5)),
//                                           ),
//                                           child: Row(
//                                             children: [
//                                               Expanded(
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.white,
//                                                     // border: Border(
//                                                     //     right: BorderSide(
//                                                     //         color: Color.fromRGBO(0, 0, 0, 1),
//                                                     //         width: 0.5
//                                                     //     )
//                                                     //   )
//                                                   ),
//                                                   child: Text(
//                                                     'Message',
//                                                     style: TextStyle(
//                                                         fontSize: 18,
//                                                         color: Theme.of(context)
//                                                             .primaryColor,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                     textAlign: TextAlign.center,
//                                                   ),
//                                                 ),
//                                               ),
//                                               VerticalDivider(
//                                                   color: AppTheme.greyish),
//                                               Expanded(
//                                                 child: Container(
//                                                   color: Colors.white,
//                                                   child: Text(
//                                                     'Add Contact',
//                                                     style: TextStyle(
//                                                         fontSize: 18,
//                                                         color: Theme.of(context)
//                                                             .primaryColor,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                     textAlign: TextAlign.center,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ))
//                                   ],
//                                 )
//                               ],
//                             ),
//                           )
//                         : Container(),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     // contact send
//                     messages[index].contact == "1"
//                         ? Container(
//                             padding: EdgeInsets.only(
//                                 left: 14, right: 14, top: 5, bottom: 5),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               mainAxisAlignment:
//                                   messages[index].messageType == "sender"
//                                       ? MainAxisAlignment.start
//                                       : MainAxisAlignment.end,
//                               children: [
//                                 Column(
//                                   children: [
//                                     ClipPath(
//                                         clipper: ShapeBorderClipper(
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.only(
//                                             topLeft: Radius.circular(10),
//                                             topRight: Radius.circular(10),
//                                           )),
//                                         ),
//                                         child: Container(
//                                           height: 70.0,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.60,
//                                           // decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           //     border: Border(
//                                           //         bottom: BorderSide(
//                                           //             color: Color.fromRGBO(0, 0, 0, 1),
//                                           //             width: 0.5
//                                           //         )
//                                           //     ),
//                                           // ),
//                                           child: Column(
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 10,
//                                                         top: 10,
//                                                         right: 5),
//                                                     child: CircleAvatar(
//                                                       radius: 20,
//                                                       backgroundColor:
//                                                           Color(0xff666666),
//                                                       backgroundImage: NetworkImage(
//                                                           'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 5,
//                                                         top: 10,
//                                                         right: 10),
//                                                     child: Text(
//                                                       'Venugopal Iyer',
//                                                       style: TextStyle(
//                                                           fontSize: 18,
//                                                           color:
//                                                               Theme.of(context)
//                                                                   .primaryColor,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Align(
//                                                 alignment:
//                                                     Alignment.bottomRight,
//                                                 child: Padding(
//                                                   padding: EdgeInsets.only(
//                                                       right: 10),
//                                                   child: Text(
//                                                     '4:44PM',
//                                                     style: TextStyle(
//                                                         fontSize: 10,
//                                                         color:
//                                                             AppTheme.greyish),
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         )),
//                                     ClipPath(
//                                         clipper: ShapeBorderClipper(
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.only(
//                                             bottomLeft: Radius.circular(10),
//                                             bottomRight: Radius.circular(10),
//                                           )),
//                                         ),
//                                         child: Container(
//                                           height: 35.0,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.60,
//                                           // color: Colors.white,
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             border: Border(
//                                                 top: BorderSide(
//                                                     color: AppTheme.greyish,
//                                                     width: 0.5)),
//                                           ),
//                                           child: Row(
//                                             children: [
//                                               Expanded(
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.white,
//                                                     // border: Border(
//                                                     //     right: BorderSide(
//                                                     //         color: Color.fromRGBO(0, 0, 0, 1),
//                                                     //         width: 0.5
//                                                     //     )
//                                                     //   )
//                                                   ),
//                                                   child: Text(
//                                                     'Message',
//                                                     style: TextStyle(
//                                                         fontSize: 18,
//                                                         color: Theme.of(context)
//                                                             .primaryColor,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                     textAlign: TextAlign.center,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ))
//                                   ],
//                                 )
//                               ],
//                             ),
//                           )
//                         : Container(),
//                     //requested money
//                     messages[index].request == '1'
//                         ? Container(
//                             padding: EdgeInsets.only(
//                                 left: 14, right: 14, top: 5, bottom: 5),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               mainAxisAlignment:
//                                   messages[index].messageType == "sender"
//                                       ? MainAxisAlignment.end
//                                       : MainAxisAlignment.start,
//                               children: [
//                                 messages[index].messageType == "sender"
//                                     ? Padding(
//                                         padding: EdgeInsets.only(right: 5),
//                                         child: Icon(
//                                           Icons.done_all_outlined,
//                                           size: 18,
//                                           color: Theme.of(context).primaryColor,
//                                         ),
//                                       )
//                                     : Container(),
//                                 Align(
//                                   alignment:
//                                       (messages[index].messageType == "receiver"
//                                           ? Alignment.topLeft
//                                           : Alignment.topRight),
//                                   child: Card(
//                                     shape: messages[index].messageType ==
//                                             "receiver"
//                                         ? RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.only(
//                                               topLeft: Radius.circular(20),
//                                               bottomLeft: Radius.circular(20),
//                                               topRight: Radius.circular(20),
//                                             ),
//                                           )
//                                         : RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.only(
//                                               topRight: Radius.circular(20),
//                                               bottomLeft: Radius.circular(20),
//                                               bottomRight: Radius.circular(20),
//                                             ),
//                                           ),
//                                     child: Padding(
//                                       padding: EdgeInsets.only(
//                                           left: 14,
//                                           right: 14,
//                                           top: 10,
//                                           bottom: 10),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceAround,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "${messages[index].money}",
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 18,
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                           Text(
//                                             '${messages[index].msg}',
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 14,
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                           RichText(
//                                             text: TextSpan(
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .bodyText2,
//                                               children: [
//                                                 TextSpan(
//                                                   text: 'Request sent - ' +
//                                                       messages[index].date,
//                                                   style: TextStyle(
//                                                     fontSize: 12,
//                                                     color:
//                                                         AppTheme.brownishGrey,
//                                                   ),
//                                                 ),
//                                                 WidgetSpan(
//                                                   child: Padding(
//                                                     padding: const EdgeInsets
//                                                             .symmetric(
//                                                         horizontal: 2.0),
//                                                     child: Icon(
//                                                       Icons
//                                                           .check_circle_outline_outlined,
//                                                       size: 14,
//                                                       color:
//                                                           AppTheme.greenColor,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 WidgetSpan(
//                                                   child: Padding(
//                                                     padding: const EdgeInsets
//                                                             .symmetric(
//                                                         horizontal: 2.0),
//                                                     child: Icon(
//                                                       Icons.arrow_forward_ios,
//                                                       size: 14,
//                                                       color:
//                                                           AppTheme.brownishGrey,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           Container(
//                                             margin: EdgeInsets.only(top: 5),
//                                             padding: EdgeInsets.symmetric(
//                                                 vertical: 2, horizontal: 5),
//                                             decoration: BoxDecoration(
//                                               border: Border.all(
//                                                   color: Colors.blueAccent),
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(5)),
//                                             ),
//                                             child: Text("CANCEL",
//                                                 style: TextStyle(
//                                                   color: Colors.blueAccent,
//                                                   fontSize: 8,
//                                                 )),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : Container(),
//                     //audio
//                     messages[index].audio == '1'
//                         ? Container(
//                             padding: EdgeInsets.only(
//                                 left: 14, right: 14, top: 5, bottom: 5),
//                             child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 mainAxisAlignment:
//                                     messages[index].messageType == "sender"
//                                         ? MainAxisAlignment.start
//                                         : MainAxisAlignment.end,
//                                 children: [
//                                   Align(
//                                     alignment: (messages[index].messageType ==
//                                             "receiver"
//                                         ? Alignment.topLeft
//                                         : Alignment.topRight),
//                                     child: Card(
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(30.0))),
//                                       child: Row(
//                                         children: [
//                                           Padding(
//                                             padding: EdgeInsets.all(4),
//                                             child: CircleAvatar(
//                                               radius: 20,
//                                               backgroundColor:
//                                                   Color(0xff666666),
//                                               backgroundImage: NetworkImage(
//                                                   'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               // Icon(
//                                               //   Icons.play_circle_fill_rounded,
//                                               //   color: Colors.grey,
//                                               //   size: 26,
//                                               // ),
//                                               Image.asset(
//                                                 'assets/icons/Download-02.png',
//                                                 width: 30,
//                                               ),
//                                               // visualization-01
//                                               Text(
//                                                 '1:04',
//                                                 style: TextStyle(
//                                                     color: AppTheme.greyish,
//                                                     fontSize: 8),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Image.asset(
//                                             'assets/icons/visualization-01.png',
//                                             height: 22,
//                                           ),
//                                           SizedBox(
//                                             width: 10,
//                                           ),
//                                           Text(
//                                             '4:44 PM',
//                                             style: TextStyle(
//                                               fontSize: 8,
//                                               color: AppTheme.greyish,
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 10,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ]),
//                           )
//                         : Container(),
//                     //audio
//                     messages[index].audio == '1'
//                         ? Container(
//                             padding: EdgeInsets.only(
//                                 left: 14, right: 14, top: 5, bottom: 5),
//                             child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 mainAxisAlignment:
//                                     messages[index].messageType == "sender"
//                                         ? MainAxisAlignment.end
//                                         : MainAxisAlignment.start,
//                                 children: [
//                                   messages[index].messageType == "sender"
//                                       ? Padding(
//                                           padding: EdgeInsets.only(right: 5),
//                                           child: Icon(
//                                             Icons.done_all_outlined,
//                                             size: 18,
//                                             color:
//                                                 Theme.of(context).primaryColor,
//                                           ),
//                                         )
//                                       : Container(),
//                                   Align(
//                                     alignment: (messages[index].messageType ==
//                                             "receiver"
//                                         ? Alignment.topLeft
//                                         : Alignment.topRight),
//                                     child: Card(
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(30.0))),
//                                       child: Row(
//                                         children: [
//                                           Padding(
//                                             padding: EdgeInsets.all(4),
//                                             child: CircleAvatar(
//                                               radius: 20,
//                                               backgroundColor:
//                                                   Color(0xff666666),
//                                               backgroundImage: NetworkImage(
//                                                   'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Icon(
//                                                 Icons.play_circle_fill_rounded,
//                                                 color: Colors.grey,
//                                                 size: 26,
//                                               ),
//                                               //     Image.asset('assets/icons/Download-02.png',
//                                               //   width: 30,
//                                               // ),
//                                               // visualization-01
//                                               Text(
//                                                 '1:04',
//                                                 style: TextStyle(
//                                                     color: AppTheme.greyish,
//                                                     fontSize: 8),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Image.asset(
//                                             'assets/icons/visualization-01.png',
//                                             height: 22,
//                                           ),
//                                           SizedBox(
//                                             width: 10,
//                                           ),
//                                           Text(
//                                             '4:44 PM',
//                                             style: TextStyle(
//                                               fontSize: 8,
//                                               color: AppTheme.greyish,
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 10,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ]),
//                           )
//                         : Container(),
//                     //reminder money
//                     messages[index].reminder == '1'
//                         ? Container(
//                             // width: 200,
//                             padding: EdgeInsets.only(
//                                 left: 14, right: 14, top: 5, bottom: 5),
//                             child: Row(
//                               mainAxisAlignment:
//                                   messages[index].messageType == "sender"
//                                       ? MainAxisAlignment.end
//                                       : MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 messages[index].messageType == "sender"
//                                     ? Padding(
//                                         padding:
//                                             EdgeInsets.only(right: 5, top: 55),
//                                         child: Icon(
//                                           Icons.done_all_outlined,
//                                           size: 18,
//                                           color: Theme.of(context).primaryColor,
//                                         ),
//                                       )
//                                     : Container(),
//                                 Align(
//                                   alignment:
//                                       (messages[index].messageType == "receiver"
//                                           ? Alignment.topLeft
//                                           : Alignment.topRight),
//                                   child: Card(
//                                     shape: messages[index].messageType ==
//                                             "receiver"
//                                         ? RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.only(
//                                               topLeft: Radius.circular(20),
//                                               topRight: Radius.circular(20),
//                                             ),
//                                           )
//                                         : RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.only(
//                                               topRight: Radius.circular(20),
//                                               bottomLeft: Radius.circular(10),
//                                               bottomRight: Radius.circular(10),
//                                             ),
//                                           ),
//                                     child: Column(
//                                       // crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Card(
//                                           shape: messages[index].messageType ==
//                                                   "receiver"
//                                               ? RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.only(
//                                                     topLeft:
//                                                         Radius.circular(20),
//                                                     bottomLeft:
//                                                         Radius.circular(20),
//                                                     topRight:
//                                                         Radius.circular(20),
//                                                   ),
//                                                 )
//                                               : RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.only(
//                                                     topRight:
//                                                         Radius.circular(20),
//                                                     bottomLeft:
//                                                         Radius.circular(20),
//                                                     bottomRight:
//                                                         Radius.circular(20),
//                                                   ),
//                                                 ),
//                                           child: Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: 14,
//                                                 right: 14,
//                                                 top: 10,
//                                                 bottom: 10),
//                                             child: Column(
//                                               // mainAxisAlignment: MainAxisAlignment.center,
//                                               // crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 // Center(
//                                                 //   child:
//                                                 Text(
//                                                   'Payment reminder of',
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 14,
//                                                     color: Colors.black,
//                                                   ),
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                                 // ),
//                                                 // Center(child:
//                                                 Text(
//                                                   "${messages[index].money}",
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 18,
//                                                     color: Colors.black,
//                                                   ),
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                                 // ),
//                                                 // Center(
//                                                 //   child:
//                                                 Text(
//                                                   'on 16 Mar 21',
//                                                   style: TextStyle(
//                                                       // fontWeight: FontWeight.bold,
//                                                       fontSize: 8,
//                                                       color: AppTheme
//                                                           .brownishGrey),
//                                                 ),
//                                                 // ),
//                                                 // Center(child:
//                                                 Text(
//                                                   'Sent by Nova Scot',
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 12,
//                                                       color: AppTheme
//                                                           .brownishGrey),
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                                 // ),
//                                                 // Center(
//                                                 //   child:
//                                                 Text(
//                                                   '9664774391',
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 10,
//                                                       color: AppTheme
//                                                           .brownishGrey),
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                                 // ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: 5, horizontal: 5),
//                                           child: Text(
//                                             'Dear Sir/Madam,\nYour payment of $currencyAED 540 is pending at Nova Scot \n(9664774391),\nClick here UrbanLedgerhgfdew23456789oiugf=0 \n to view the details and make the payment.\n\nIf the link is not clickable, please save the content and try \nagain.',
//                                             style: TextStyle(
//                                                 fontSize: 6,
//                                                 color: AppTheme.brownishGrey),
//                                           ),
//                                         ),
//                                         // Align(
//                                         //   alignment: Alignment.bottomRight,
//                                         //   child:
//                                         Align(
//                                           alignment: Alignment.bottomRight,
//                                           child: Padding(
//                                             padding: EdgeInsets.only(right: 10),
//                                             child: Text(
//                                               '4:44PM',
//                                               style: TextStyle(
//                                                   fontSize: 8,
//                                                   color: AppTheme.greyish),
//                                             ),
//                                           ),
//                                         )
//                                         // ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : Container(),

//                     //reminder money
//                     messages[index].reminder == '1'
//                         ? Container(
//                             // width: 200,
//                             padding: EdgeInsets.only(
//                                 left: 14, right: 14, top: 5, bottom: 5),
//                             child: Row(
//                               mainAxisAlignment:
//                                   messages[index].messageType == "sender"
//                                       ? MainAxisAlignment.end
//                                       : MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 messages[index].messageType == "sender"
//                                     ? Padding(
//                                         padding:
//                                             EdgeInsets.only(right: 5, top: 55),
//                                         child: Icon(
//                                           Icons.done_all_outlined,
//                                           size: 18,
//                                           color: Theme.of(context).primaryColor,
//                                         ),
//                                       )
//                                     : Container(),
//                                 Align(
//                                   alignment:
//                                       (messages[index].messageType == "receiver"
//                                           ? Alignment.topLeft
//                                           : Alignment.topRight),
//                                   child: Card(
//                                     shape: messages[index].messageType ==
//                                             "receiver"
//                                         ? RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.only(
//                                               topLeft: Radius.circular(20),
//                                               topRight: Radius.circular(20),
//                                             ),
//                                           )
//                                         : RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.only(
//                                               topRight: Radius.circular(20),
//                                               bottomLeft: Radius.circular(10),
//                                               bottomRight: Radius.circular(10),
//                                             ),
//                                           ),
//                                     child: Column(
//                                       // crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Stack(
//                                           children: <Widget>[
//                                             //top grey shadow

//                                             //image code
//                                             ClipRRect(
//                                               borderRadius: BorderRadius.only(
//                                                 bottomLeft: Radius.circular(20),
//                                                 topRight: Radius.circular(20),
//                                                 bottomRight:
//                                                     Radius.circular(20),
//                                               ),
//                                               child: Image.asset(
//                                                 'assets/icons/pdf-cover-img.png',
//                                                 width: 220,
//                                               ),
//                                             ),

//                                             Align(
//                                               alignment: Alignment.topCenter,
//                                               child: Container(
//                                                 height: 40,
//                                                 width: 240,
//                                                 decoration: new BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.only(
//                                                     bottomLeft:
//                                                         Radius.circular(20),
//                                                     topRight:
//                                                         Radius.circular(20),
//                                                     bottomRight:
//                                                         Radius.circular(20),
//                                                   ),
//                                                   gradient: new LinearGradient(
//                                                     end: const Alignment(
//                                                         0.0, 0.3),
//                                                     begin: const Alignment(
//                                                         0.0, -1),
//                                                     colors: <Color>[
//                                                       const Color(0x8A000000),
//                                                       Colors.black12
//                                                           .withOpacity(0.0)
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 child: Align(
//                                                     alignment:
//                                                         Alignment.topRight,
//                                                     child: Padding(
//                                                       padding: EdgeInsets.only(
//                                                           right: 20, top: 10),
//                                                       child: Image.asset(
//                                                         'assets/icons/down.png',
//                                                         width: 14,
//                                                       ),
//                                                     )),
//                                               ),
//                                             ),
//                                             //bottom grey shadow
//                                             // Align(
//                                             //   alignment: Alignment.bottomCenter,
//                                             //   child: Container(
//                                             //     height: 50,
//                                             //     width: 220,
//                                             //     decoration: new BoxDecoration(
//                                             //       gradient: new LinearGradient(
//                                             //         end: const Alignment(0.0, -1),
//                                             //         begin: const Alignment(0.0, 0.4),
//                                             //         colors: <Color>[
//                                             //           const Color(0x8A000000),
//                                             //           Colors.black12.withOpacity(0.0)
//                                             //         ],
//                                             //       ),

//                                             //     ),
//                                             //   ),
//                                             // ),
//                                           ],
//                                         ),
//                                         Card(
//                                           shape: messages[index].messageType ==
//                                                   "receiver"
//                                               ? RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.only(
//                                                     // topLeft: Radius.circular(20),
//                                                     bottomLeft:
//                                                         Radius.circular(20),
//                                                     bottomRight:
//                                                         Radius.circular(20),
//                                                     // topRight: Radius.circular(20),
//                                                   ),
//                                                 )
//                                               : RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.only(
//                                                     // topRight: Radius.circular(20),
//                                                     bottomLeft:
//                                                         Radius.circular(20),
//                                                     bottomRight:
//                                                         Radius.circular(20),
//                                                   ),
//                                                 ),
//                                           child: Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: 14,
//                                                 right: 14,
//                                                 top: 10,
//                                                 bottom: 10),
//                                             child: Column(
//                                               // mainAxisAlignment: MainAxisAlignment.center,
//                                               // crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Image.asset(
//                                                       'assets/icons/Document-01.png',
//                                                       height: 22,
//                                                     ),
//                                                     SizedBox(width: 5),
//                                                     Text(
//                                                       'Royal Packaging Invoice',
//                                                       style: TextStyle(
//                                                           color: AppTheme
//                                                               .brownishGrey),
//                                                     ),
//                                                     SizedBox(width: 10),
//                                                     Image.asset(
//                                                       'assets/icons/Download-01.png',
//                                                       height: 22,
//                                                     ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceEvenly,
//                                           children: [
//                                             Padding(
//                                                 padding: EdgeInsets.only(
//                                                     left: 5,
//                                                     top: 5,
//                                                     right: 55,
//                                                     bottom: 5),
//                                                 child: Text(
//                                                   'PDF - 14 MB',
//                                                   style: TextStyle(
//                                                       fontSize: 10,
//                                                       color: AppTheme.greyish),
//                                                 )),
//                                             SizedBox(width: 10),
//                                             Padding(
//                                               padding: EdgeInsets.only(
//                                                   left: 55,
//                                                   top: 5,
//                                                   right: 5,
//                                                   bottom: 5),
//                                               child: Text(
//                                                 '4:44 PM',
//                                                 style: TextStyle(
//                                                     fontSize: 10,
//                                                     color: AppTheme.greyish),
//                                               ),
//                                             ),
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : Container(),

//                     messages[index].reminder == '1'
//                         ? Container(
//                             // width: 200,
//                             padding: EdgeInsets.only(
//                                 left: 2, right: 2, top: 2, bottom: 2),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                 bottomLeft: Radius.circular(20),
//                                 topRight: Radius.circular(20),
//                                 bottomRight: Radius.circular(20),
//                               ),
//                               color: Colors.white,
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment:
//                                   messages[index].messageType == "sender"
//                                       ? MainAxisAlignment.end
//                                       : MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Stack(
//                                   children: <Widget>[
//                                     //top grey shadow

//                                     //image code
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.only(
//                                         bottomLeft: Radius.circular(20),
//                                         topRight: Radius.circular(20),
//                                         bottomRight: Radius.circular(20),
//                                       ),
//                                       child: Image.asset(
//                                         'assets/icons/gallery-img.png',
//                                         width: 220,
//                                       ),
//                                     ),

//                                     Align(
//                                       alignment: Alignment.topCenter,
//                                       child: Container(
//                                         height: 40,
//                                         width: 220,
//                                         decoration: new BoxDecoration(
//                                           borderRadius: BorderRadius.only(
//                                             bottomLeft: Radius.circular(20),
//                                             topRight: Radius.circular(20),
//                                             bottomRight: Radius.circular(20),
//                                           ),
//                                           gradient: new LinearGradient(
//                                             end: const Alignment(0.0, 0.3),
//                                             begin: const Alignment(0.0, -1),
//                                             colors: <Color>[
//                                               const Color(0x8A000000),
//                                               Colors.black12.withOpacity(0.0)
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     //bottom grey shadow
//                                     // Align(
//                                     //   alignment: Alignment.bottomCenter,
//                                     //   child: Container(
//                                     //     height: 50,
//                                     //     width: 220,
//                                     //     decoration: new BoxDecoration(
//                                     //       gradient: new LinearGradient(
//                                     //         end: const Alignment(0.0, -1),
//                                     //         begin: const Alignment(0.0, 0.4),
//                                     //         colors: <Color>[
//                                     //           const Color(0x8A000000),
//                                     //           Colors.black12.withOpacity(0.0)
//                                     //         ],
//                                     //       ),

//                                     //     ),
//                                     //   ),
//                                     // ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           )
//                         : Container(),
//                     //timeline history
//                     index % 2 != 0
//                         ? Container(
//                             margin: EdgeInsets.symmetric(horizontal: 20),
//                             child: Row(children: <Widget>[
//                               Text(
//                                 "Tue, 24 Feb 2021 7:42 AM",
//                                 style: TextStyle(
//                                     color: AppTheme.brownishGrey, fontSize: 8),
//                               ),
//                               Expanded(child: Divider()),
//                             ]))
//                         : Container(),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   List _buildList(int count) {
//     List<Widget> listItems = List();

//     for (int i = 0; i < count; i++) {
//       listItems.add(new Padding(
//           padding: new EdgeInsets.all(20.0),
//           child: new Text('Item ${i.toString()}',
//               style: new TextStyle(fontSize: 25.0))));
//     }
//     return listItems;
//   }
// }

// Widget receiveCollection(context) {
//   return Container(
//     margin: EdgeInsets.symmetric(horizontal: 20),
//     child: Column(children: <Widget>[
//       Container(
//         decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(
//               color: Theme.of(context).primaryColor,
//               width: 0.5,
//             ),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             )),
//         child: ListTile(
//           dense: true,
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(10),
//             topRight: Radius.circular(10),
//           )),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 'Receive',
//                 style: TextStyle(
//                     color: Theme.of(context).primaryColor,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Image.asset(
//                 'assets/icons/in.png',
//                 scale: 1.2,
//                 color: Theme.of(context).primaryColor,
//                 height: 19,
//               ),
//             ],
//           ),
//           trailing: RichText(
//             text: TextSpan(
//               style: Theme.of(context).textTheme.bodyText2,
//               children: [
//                 TextSpan(
//                   text: '$currencyAED ',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//                 TextSpan(
//                   text: ' 9,400',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       // Divider(height:5),
//       Container(
//         // margin: EdgeInsets.symmetric(horizontal: 20),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(
//               color: Theme.of(context).primaryColor,
//               width: 0.5,
//             ),
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(20),
//               bottomRight: Radius.circular(20),
//             )),
//         child: ListTile(
//             dense: true,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(10),
//               topRight: Radius.circular(10),
//             )),
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   'Collection',
//                   style: TextStyle(
//                       color: Theme.of(context).primaryColor,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500),
//                 ),
//               ],
//             ),
//             trailing: RichText(
//               text: TextSpan(
//                 style: Theme.of(context).textTheme.bodyText2,
//                 children: [
//                   TextSpan(
//                     text: 'SET DATE',
//                     style: TextStyle(
//                         fontSize: 14,
//                         color: Theme.of(context).primaryColor,
//                         fontWeight: FontWeight.w500),
//                   ),
//                   WidgetSpan(
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 5),
//                       child: Icon(
//                         Icons.calendar_today_outlined,
//                         size: 14,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )),
//       ),
//     ]),
//   );
// }

// Widget chatHistory(BuildContext context) {
//   return Flexible(
//     child: ListView.builder(
//       itemCount: messages.length,
//       shrinkWrap: true,
//       padding: EdgeInsets.only(top: 10, bottom: 10),
//       physics: NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         return Column(
//           children: [
//             //normal chat

//             messages[index].messageContent.isNotEmpty &&
//                     messages[index].money.isEmpty &&
//                     messages[index].audio.isEmpty &&
//                     messages[index].request.isEmpty
//                 ? Container(
//                     padding:
//                         EdgeInsets.only(left: 14, right: 14, top: 5, bottom: 5),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisAlignment: messages[index].messageType == "sender"
//                           ? MainAxisAlignment.end
//                           : MainAxisAlignment.start,
//                       children: [
//                         messages[index].messageType == "sender"
//                             ? Padding(
//                                 padding: EdgeInsets.only(right: 5),
//                                 child: Icon(
//                                   Icons.done_all_outlined,
//                                   size: 18,
//                                   color: Theme.of(context).primaryColor,
//                                 ),
//                               )
//                             : Container(),
//                         Align(
//                           alignment: (messages[index].messageType == "receiver"
//                               ? Alignment.topLeft
//                               : Alignment.topRight),
//                           child: Container(
//                             decoration:
//                                 messages[index].messageType == "receiver"
//                                     ? BoxDecoration(
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(20),
//                                           bottomLeft: Radius.circular(20),
//                                           topRight: Radius.circular(20),
//                                         ),
//                                         color: (AppTheme.receiverColor),
//                                       )
//                                     : BoxDecoration(
//                                         borderRadius: BorderRadius.only(
//                                           topRight: Radius.circular(20),
//                                           bottomLeft: Radius.circular(20),
//                                           bottomRight: Radius.circular(20),
//                                         ),
//                                         color: (AppTheme.senderColor),
//                                       ),
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 7, horizontal: 14),
//                             child: Text(
//                               messages[index].messageContent,
//                               style: TextStyle(fontSize: 15),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 :
//                 // transaction money
//                 messages[index].request == "0" && messages[index].money != ""
//                     ? Container(
//                         padding: EdgeInsets.only(
//                             left: 14, right: 14, top: 5, bottom: 0),
//                         child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             mainAxisAlignment:
//                                 messages[index].messageType == "sender"
//                                     ? MainAxisAlignment.end
//                                     : MainAxisAlignment.start,
//                             children: [
//                               messages[index].messageType == "sender"
//                                   ? Padding(
//                                       padding: EdgeInsets.only(right: 5),
//                                       child: Icon(
//                                         Icons.done_all_outlined,
//                                         size: 18,
//                                         color: Theme.of(context).primaryColor,
//                                       ),
//                                     )
//                                   : Container(),
//                               Align(
//                                 alignment:
//                                     (messages[index].messageType == "receiver"
//                                         ? Alignment.topLeft
//                                         : Alignment.topRight),
//                                 child: Card(
//                                   shape: messages[index].messageType ==
//                                           "receiver"
//                                       ? RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.only(
//                                             topLeft: Radius.circular(20),
//                                             bottomLeft: Radius.circular(20),
//                                             topRight: Radius.circular(20),
//                                           ),
//                                         )
//                                       : RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.only(
//                                             topRight: Radius.circular(20),
//                                             bottomLeft: Radius.circular(20),
//                                             bottomRight: Radius.circular(20),
//                                           ),
//                                         ),
//                                   child: Padding(
//                                     padding: EdgeInsets.only(
//                                         left: 14,
//                                         right: 14,
//                                         top: 10,
//                                         bottom: 10),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "${messages[index].money}",
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 18,
//                                             color:
//                                                 messages[index].messageType ==
//                                                         "sender"
//                                                     ? AppTheme.tomato
//                                                     : AppTheme.greenColor,
//                                           ),
//                                         ),
//                                         Text(
//                                           '${messages[index].msg}',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 14,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                         RichText(
//                                           text: TextSpan(
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodyText2,
//                                             children: [
//                                               TextSpan(
//                                                 text: messages[index]
//                                                             .messageType ==
//                                                         "sender"
//                                                     ? 'You paid - ' +
//                                                         messages[index].date
//                                                     : 'You were paid - ' +
//                                                         messages[index].date,
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                   color: AppTheme.brownishGrey,
//                                                 ),
//                                               ),
//                                               WidgetSpan(
//                                                 child: Padding(
//                                                   padding: EdgeInsets.symmetric(
//                                                       horizontal: 2.0),
//                                                   child: Icon(
//                                                     Icons
//                                                         .check_circle_outline_outlined,
//                                                     size: 14,
//                                                     color: AppTheme.greenColor,
//                                                   ),
//                                                 ),
//                                               ),
//                                               WidgetSpan(
//                                                 child: Padding(
//                                                   padding: EdgeInsets.symmetric(
//                                                       horizontal: 2.0),
//                                                   child: Icon(
//                                                     Icons.arrow_forward_ios,
//                                                     size: 14,
//                                                     color:
//                                                         AppTheme.brownishGrey,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ]),
//                       )
//                     : Container(),
//             // reward
//             messages[index].request == "0" &&
//                     messages[index].money != "" &&
//                     messages[index].messageType == "sender"
//                 ? Padding(
//                     padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
//                     child: Align(
//                         alignment: Alignment.topRight,
//                         child: RichText(
//                           text: TextSpan(
//                             style: Theme.of(context).textTheme.bodyText2,
//                             children: [
//                               TextSpan(
//                                 text: 'You earned a reward',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   color: AppTheme.brownishGrey,
//                                 ),
//                               ),
//                               WidgetSpan(
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 2.0),
//                                   child: Icon(
//                                     Icons.card_giftcard_outlined,
//                                     size: 10,
//                                     color: Theme.of(context).primaryColor,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )),
//                   )
//                 : Container(),
//             //requested money
//             messages[index].request == '1'
//                 ? Container(
//                     padding:
//                         EdgeInsets.only(left: 14, right: 14, top: 5, bottom: 5),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisAlignment: messages[index].messageType == "sender"
//                           ? MainAxisAlignment.end
//                           : MainAxisAlignment.start,
//                       children: [
//                         messages[index].messageType == "sender"
//                             ? Padding(
//                                 padding: EdgeInsets.only(right: 5),
//                                 child: Icon(
//                                   Icons.done_all_outlined,
//                                   size: 18,
//                                   color: Theme.of(context).primaryColor,
//                                 ),
//                               )
//                             : Container(),
//                         Align(
//                           alignment: (messages[index].messageType == "receiver"
//                               ? Alignment.topLeft
//                               : Alignment.topRight),
//                           child: Card(
//                             shape: messages[index].messageType == "receiver"
//                                 ? RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(20),
//                                       bottomLeft: Radius.circular(20),
//                                       topRight: Radius.circular(20),
//                                     ),
//                                   )
//                                 : RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.only(
//                                       topRight: Radius.circular(20),
//                                       bottomLeft: Radius.circular(20),
//                                       bottomRight: Radius.circular(20),
//                                     ),
//                                   ),
//                             child: Padding(
//                               padding: EdgeInsets.only(
//                                   left: 14, right: 14, top: 10, bottom: 10),
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "${messages[index].money}",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   Text(
//                                     '${messages[index].msg}',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 14,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   RichText(
//                                     text: TextSpan(
//                                       style:
//                                           Theme.of(context).textTheme.bodyText2,
//                                       children: [
//                                         TextSpan(
//                                           text: 'Request sent - ' +
//                                               messages[index].date,
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             color: AppTheme.brownishGrey,
//                                           ),
//                                         ),
//                                         WidgetSpan(
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 2.0),
//                                             child: Icon(
//                                               Icons
//                                                   .check_circle_outline_outlined,
//                                               size: 14,
//                                               color: AppTheme.greenColor,
//                                             ),
//                                           ),
//                                         ),
//                                         WidgetSpan(
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 2.0),
//                                             child: Icon(
//                                               Icons.arrow_forward_ios,
//                                               size: 14,
//                                               color: AppTheme.brownishGrey,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.only(top: 5),
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 2, horizontal: 5),
//                                     decoration: BoxDecoration(
//                                       border:
//                                           Border.all(color: Colors.blueAccent),
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(5)),
//                                     ),
//                                     child: Text("CANCEL",
//                                         style: TextStyle(
//                                           color: Colors.blueAccent,
//                                           fontSize: 8,
//                                         )),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : Container(),
//             //reminder money
//             messages[index].reminder == '1'
//                 ? Container(
//                     // width: 200,
//                     padding:
//                         EdgeInsets.only(left: 14, right: 14, top: 5, bottom: 5),
//                     child: Row(
//                       mainAxisAlignment: messages[index].messageType == "sender"
//                           ? MainAxisAlignment.end
//                           : MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         messages[index].messageType == "sender"
//                             ? Padding(
//                                 padding: EdgeInsets.only(right: 5, top: 55),
//                                 child: Icon(
//                                   Icons.done_all_outlined,
//                                   size: 18,
//                                   color: Theme.of(context).primaryColor,
//                                 ),
//                               )
//                             : Container(),
//                         Align(
//                           alignment: (messages[index].messageType == "receiver"
//                               ? Alignment.topLeft
//                               : Alignment.topRight),
//                           child: Card(
//                             shape: messages[index].messageType == "receiver"
//                                 ? RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(20),
//                                       topRight: Radius.circular(20),
//                                     ),
//                                   )
//                                 : RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.only(
//                                       topRight: Radius.circular(20),
//                                       bottomLeft: Radius.circular(10),
//                                       bottomRight: Radius.circular(10),
//                                     ),
//                                   ),
//                             child: Column(
//                               // crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Card(
//                                   shape: messages[index].messageType ==
//                                           "receiver"
//                                       ? RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.only(
//                                             topLeft: Radius.circular(20),
//                                             bottomLeft: Radius.circular(20),
//                                             topRight: Radius.circular(20),
//                                           ),
//                                         )
//                                       : RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.only(
//                                             topRight: Radius.circular(20),
//                                             bottomLeft: Radius.circular(20),
//                                             bottomRight: Radius.circular(20),
//                                           ),
//                                         ),
//                                   child: Padding(
//                                     padding: EdgeInsets.only(
//                                         left: 14,
//                                         right: 14,
//                                         top: 10,
//                                         bottom: 10),
//                                     child: Column(
//                                       // mainAxisAlignment: MainAxisAlignment.center,
//                                       // crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         // Center(
//                                         //   child:
//                                         Text(
//                                           'Payment reminder of',
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 14,
//                                             color: Colors.black,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                         // ),
//                                         // Center(child:
//                                         Text(
//                                           "${messages[index].money}",
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 18,
//                                             color: Colors.black,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                         // ),
//                                         // Center(
//                                         //   child:
//                                         Text(
//                                           'on 16 Mar 21',
//                                           style: TextStyle(
//                                               // fontWeight: FontWeight.bold,
//                                               fontSize: 8,
//                                               color: AppTheme.brownishGrey),
//                                         ),
//                                         // ),
//                                         // Center(child:
//                                         Text(
//                                           'Sent by Nova Scot',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 12,
//                                               color: AppTheme.brownishGrey),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                         // ),
//                                         // Center(
//                                         //   child:
//                                         Text(
//                                           '9664774391',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 10,
//                                               color: AppTheme.brownishGrey),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                         // ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 5, horizontal: 5),
//                                   child: Text(
//                                     'Dear Sir/Madam,\nYour payment of $currencyAED 540 is pending at Nova Scot \n(9664774391),\nClick here UrbanLedgerhgfdew23456789oiugf=0 \n to view the details and make the payment.\n\nIf the link is not clickable, please save the content and try \nagain.',
//                                     style: TextStyle(
//                                         fontSize: 6,
//                                         color: AppTheme.brownishGrey),
//                                   ),
//                                 ),
//                                 // Align(
//                                 //   alignment: Alignment.bottomRight,
//                                 //   child:
//                                 Text(
//                                   '4:44 PM',
//                                   style: TextStyle(
//                                       color: AppTheme.brownishGrey,
//                                       fontSize: 6),
//                                   textAlign: TextAlign.right,
//                                 ),
//                                 // ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : Container(),
//             //timeline history
//             index % 2 != 0
//                 ? Container(
//                     margin: EdgeInsets.symmetric(horizontal: 20),
//                     child: Row(children: <Widget>[
//                       Text(
//                         "Tue, 24 Feb 2021 7:42 AM",
//                         style: TextStyle(
//                             color: AppTheme.brownishGrey, fontSize: 8),
//                       ),
//                       Expanded(child: Divider()),
//                     ]))
//                 : Container(),
//           ],
//         );
//       },
//     ),
//   );
// }

// Widget bottomBar2(BuildContext context) {
//   return Stack(
//     alignment: Alignment.bottomCenter,
//     clipBehavior: Clip.none,
//     children: [
//       Container(
//         height: 40,
//         padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
//         decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.3),
//                 offset: const Offset(
//                   5.0,
//                   5.0,
//                 ),
//                 blurRadius: 15.0,
//                 spreadRadius: 1.0,
//               ),
//               BoxShadow(
//                 color: Colors.white,
//                 offset: const Offset(0.0, 0.0),
//                 blurRadius: 0.0,
//                 spreadRadius: 0.0,
//               ),
//             ],
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(10), topRight: Radius.circular(10))),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Container(
//               child: Icon(
//                 Icons.sentiment_satisfied_alt_rounded,
//                 size: 22,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//             Container(
//               height: 35,
//               width: 180,
//               child: TextField(
//                 autocorrect: true,
//                 textAlign: TextAlign.left,
//                 decoration: InputDecoration(
//                   suffixIcon: IconButton(
//                     onPressed: () {
//                       showModalBottomSheet<void>(
//                         backgroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.vertical(top: Radius.circular(20.0)),
//                         ),
//                         context: context,
//                         builder: (BuildContext context) {
//                           return Container(
//                             height: 250,
//                             child: Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: <Widget>[
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   // Icon(
//                                   //       Icons.drag_handle_rounded,
//                                   //       color: Colors.grey,
//                                   //     ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Container(
//                                       height: 6,
//                                       width: 42,
//                                       decoration: BoxDecoration(
//                                           color: AppTheme.greyish,
//                                           borderRadius:
//                                               BorderRadius.circular(15)),
//                                     ),
//                                   ),
//                                   SizedBox(height: 20),
//                                   Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: <Widget>[
//                                         Expanded(
//                                           child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: <Widget>[
//                                                 IconButton(
//                                                   onPressed: () {},
//                                                   icon: Icon(
//                                                     Icons
//                                                         .picture_as_pdf_outlined,
//                                                     size: 38,
//                                                   ),
//                                                 ),
//                                                 SizedBox(height: 5),
//                                                 Text(
//                                                   'Document',
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     color:
//                                                         AppTheme.brownishGrey,
//                                                   ),
//                                                 )
//                                               ]),
//                                         ),
//                                         Expanded(
//                                           child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceEvenly,
//                                               children: <Widget>[
//                                                 IconButton(
//                                                   onPressed: () {},
//                                                   icon: Icon(
//                                                     Icons
//                                                         .picture_as_pdf_outlined,
//                                                     size: 38,
//                                                   ),
//                                                 ),
//                                                 SizedBox(height: 5),
//                                                 Text(
//                                                   'Gallery',
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     color:
//                                                         AppTheme.brownishGrey,
//                                                   ),
//                                                 )
//                                               ]),
//                                         ),
//                                         Expanded(
//                                           child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: <Widget>[
//                                                 IconButton(
//                                                   onPressed: () {},
//                                                   icon: Icon(
//                                                     Icons
//                                                         .picture_as_pdf_outlined,
//                                                     size: 38,
//                                                   ),
//                                                 ),
//                                                 SizedBox(height: 5),
//                                                 Text(
//                                                   'Camera',
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     color:
//                                                         AppTheme.brownishGrey,
//                                                   ),
//                                                 )
//                                               ]),
//                                         ),
//                                       ]),
//                                   SizedBox(height: 20),
//                                   Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: <Widget>[
//                                         SizedBox(width: 50),
//                                         Expanded(
//                                           child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: <Widget>[
//                                                 IconButton(
//                                                   onPressed: () {},
//                                                   icon: Icon(
//                                                     Icons
//                                                         .picture_as_pdf_outlined,
//                                                     size: 38,
//                                                   ),
//                                                 ),
//                                                 SizedBox(height: 5),
//                                                 Text(
//                                                   'Audio',
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     color:
//                                                         AppTheme.brownishGrey,
//                                                   ),
//                                                 )
//                                               ]),
//                                         ),
//                                         Expanded(
//                                           child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: <Widget>[
//                                                 IconButton(
//                                                   onPressed: () {},
//                                                   icon: Icon(
//                                                     Icons
//                                                         .picture_as_pdf_outlined,
//                                                     size: 38,
//                                                   ),
//                                                 ),
//                                                 SizedBox(height: 5),
//                                                 Text(
//                                                   'Camera',
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                     color:
//                                                         AppTheme.brownishGrey,
//                                                   ),
//                                                 )
//                                               ]),
//                                         ),
//                                         SizedBox(width: 50),
//                                       ])
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                     padding: EdgeInsets.only(left: 15),
//                     icon: Icon(
//                       Icons.attach_file_rounded,
//                       size: 12,
//                     ),
//                   ),
//                   contentPadding: EdgeInsets.fromLTRB(7, 5, -15, 5),
//                   hintText: 'Type here...',
//                   hintStyle: TextStyle(color: Colors.grey, fontSize: 8),
//                   filled: true,
//                   fillColor: Colors.blue[50],
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(5)),
//                     borderSide: BorderSide(color: Colors.grey, width: 0.5),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(5)),
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               child: Icon(
//                 Icons.mic_none_outlined,
//                 size: 18,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//             Container(
//               child: Icon(
//                 Icons.camera_alt_outlined,
//                 size: 18,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//             CircleAvatar(
//               radius: 20,
//               backgroundColor: Color(0xff666666),
//               child: Align(
//                   alignment: Alignment.center,
//                   child: Icon(
//                     Icons.add,
//                     color: Colors.white,
//                   )),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }
