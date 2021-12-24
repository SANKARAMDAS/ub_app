// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:urbanledger/Utility/app_methods.dart';
// import 'package:urbanledger/Utility/app_routes.dart';
// import 'package:urbanledger/Utility/app_theme.dart';
// import 'package:urbanledger/screens/Components/custom_text_widget.dart';
// import 'package:urbanledger/screens/Components/extensions.dart';
// import '../../../Utility/app_constants.dart';
// import '../../data/models/message.dart';
// import '../../screens/contact/contact_controller.dart';
// import '../../utils/dates.dart';
// import '../../widgets/text_field_with_button.dart';

// enum MessagePosition { BEFORE, AFTER }

// class ContactScreen extends StatefulWidget {
//   static final String routeName = "/contact";

//   ContactScreen();

//   @override
//   _ContactScreenState createState() => _ContactScreenState();
// }

// class _ContactScreenState extends State<ContactScreen>
//     with SingleTickerProviderStateMixin {
//   TabController? _tabController;
//   late ContactController _contactController;
//   final format = new DateFormat("HH:mm");

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _contactController = ContactController(
//       context: context,
//     );
//   }

//   @override
//   void dispose() {
//     _tabController!.dispose();
//     _contactController.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeDependencies() {
//     _contactController.initProvider();
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<Object>(
//         stream: _contactController.streamController.stream as Stream<Object>?,
//         builder: (context, snapshot) {
//           return Scaffold(
//             body: NestedScrollView(
//               reverse: false,
//               headerSliverBuilder:
//                   (BuildContext context, bool innerBoxIsScrolled) {
//                 return <Widget>[
//                   SliverOverlapAbsorber(
//                     handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
//                         context),
//                     sliver: SliverAppBar(
//                       automaticallyImplyLeading: false,
//                       expandedHeight: 290.0,
//                       floating: true,
//                       pinned: true,
//                       snap: true,
//                       elevation: 50,
//                       backgroundColor: Colors.transparent,
//                       flexibleSpace: FlexibleSpaceBar(
//                         background: Stack(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   alignment: Alignment.topCenter,
//                                   image: AssetImage("assets/images/back3.png"),
//                                   fit: BoxFit.fitWidth,
//                                 ),
//                               ),
//                             ),
//                             Column(children: [
//                               (MediaQuery.of(context).padding.top).heightBox,
//                               ListTile(
//                                 dense: true,
//                                 leading: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Container(
//                                       width: 30,
//                                       alignment: Alignment.center,
//                                       child: IconButton(
//                                         icon: Icon(
//                                           Icons.arrow_back_ios,
//                                           size: 22,
//                                         ),
//                                         color: Colors.white,
//                                         onPressed: () =>
//                                             Navigator.of(context).pop(),
//                                       ),
//                                     ),
//                                     CircleAvatar(
//                                       radius: 20,
//                                       backgroundColor: Color(0xff666666),
//                                       child: Center(
//                                         child: Text(
//                                           getInitials(
//                                               _contactController
//                                                   .selectedChat!.user!.name,
//                                               ''),
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 title: CustomText(
//                                   _contactController.selectedChat!.user!.name,
//                                   color: Colors.white,
//                                   size: 19,
//                                   bold: FontWeight.w500,
//                                 ),
//                                 subtitle: Text(
//                                   'Click to view setting',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 trailing: Image.asset(
//                                   'assets/icons/settings.png',
//                                   height: 20,
//                                 ),
//                               ),

//                               receiveCollection(context),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               reportButton(false),

//                               // chatHistory(context),

//                               Container(
//                                 height: 45,
//                                 margin: EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 30),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(
//                                     15.0,
//                                   ),
//                                 ),
//                                 clipBehavior: Clip.hardEdge,
//                                 child: TabBar(
//                                     indicatorColor: AppTheme.electricBlue,
//                                     controller: _tabController,
//                                     indicatorWeight: 5,
//                                     labelColor: AppTheme.brownishGrey,
//                                     unselectedLabelColor: AppTheme.brownishGrey,
//                                     labelStyle: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 18),
//                                     unselectedLabelStyle: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 18),
//                                     indicator: BoxDecoration(
//                                       border: Border(
//                                           left: _tabController!.index == 1
//                                               ? BorderSide(
//                                                   color: AppTheme.electricBlue,
//                                                 )
//                                               : BorderSide(
//                                                   color: Colors.white,
//                                                 ),
//                                           right: _tabController!.index == 0
//                                               ? BorderSide(
//                                                   color: AppTheme.electricBlue,
//                                                 )
//                                               : BorderSide(
//                                                   color: Colors.white,
//                                                 ),
//                                           bottom: BorderSide(
//                                               color: AppTheme.electricBlue,
//                                               width: 4)),
//                                     ),
//                                     tabs: [
//                                       Tab(
//                                         text: 'Ledger',
//                                       ),
//                                       Tab(
//                                         text: 'Chats',
//                                       ),
//                                     ]),
//                               ),
//                             ]),
//                             // Expanded(
//                             //   child: TabBarView(
//                             //     controller: _tabController,
//                             //     children: [Container(child: Text('Ledger'),), Container(child: Text('chats'),)],
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Container(
//                   //   height: 45,
//                   //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//                   //   decoration: BoxDecoration(
//                   //     color: Colors.white,
//                   //     borderRadius: BorderRadius.circular(
//                   //       15.0,
//                   //     ),
//                   //   ),
//                   //   clipBehavior: Clip.hardEdge,
//                   //   child: TabBar(
//                   //     indicatorColor: AppTheme.electricBlue,
//                   //     controller: _tabController,
//                   //     indicatorWeight: 5,
//                   //     labelColor: AppTheme.brownishGrey,
//                   //     unselectedLabelColor: AppTheme.brownishGrey,
//                   //     labelStyle:
//                   //         TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//                   //     unselectedLabelStyle:
//                   //         TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//                   //     tabs: [
//                   //       Tab(
//                   //         text: 'Ledger',
//                   //       ),
//                   //       Tab(
//                   //         text: 'Chats',
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   // Expanded(
//                   //   child: TabBarView(
//                   //     controller: _tabController,
//                   //     children: [Container(child: Text('Ledger')), Container(child: Text('chat'))],
//                   //   ),
//                   // ),
//                 ];
//               },
//               body: TabBarView(
//                 children: <Widget>[
//                   LedgerView(),
//                   chatScreen(),
//                 ],
//                 controller: _tabController,
//               ),
//             ),
//           );
//         });
//   }

//   Widget chatScreen() {
//     return SafeArea(
//       child: Container(
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: Scrollbar(
//                 child: ListView.builder(
//                   controller: _contactController.scrollController,
//                   padding: EdgeInsets.only(bottom: 5),
//                   reverse: true,
//                   itemCount: _contactController.selectedChat!.messages!.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Padding(
//                       padding: EdgeInsets.only(
//                         left: 10,
//                         right: 10,
//                         top: 5,
//                         bottom: 0,
//                       ),
//                       child: renderMessage(
//                           context,
//                           _contactController.selectedChat!.messages![index],
//                           index),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Scrollbar(
//                 child: ListView.builder(
//                   // controller: _contactController.scrollController,
//                   padding: EdgeInsets.only(bottom: 5),
//                   reverse: true,
//                   itemCount: 15,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Padding(
//                       padding: EdgeInsets.only(
//                         left: 10,
//                         right: 10,
//                         top: 5,
//                         bottom: 0,
//                       ),
//                       // child: renderMessage(
//                       //     context,
//                       //     _contactController
//                       //         .selectedChat.messages[index],
//                       //     index),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             // Container(
//             //   height: 115,
//             //   color: Colors.transparent,
//             //   child: DraggableScrollableSheet(
//             //     initialChildSize: 0.3,
//             //     minChildSize: 0.2,
//             //     maxChildSize: 1.0,
//             //     builder: (BuildContext context, myscrollController) {
//             //       return Container(
//             //         color: Colors.white,
//             //         child: ListView.builder(
//             //           controller: myscrollController,
//             //           itemCount: 1,
//             //           itemBuilder: (BuildContext context, int index) {
//             //             return Container(
//             //                 decoration: BoxDecoration(
//             //                     boxShadow: [
//             //                       BoxShadow(
//             //                         color: Colors.grey.withOpacity(0.1),
//             //                         spreadRadius: 5,
//             //                         blurRadius: 15,
//             //                         offset: Offset(
//             //                             0, -15), // changes position of shadow
//             //                       ),
//             //                     ],
//             //                     color: Colors.white,
//             //                     borderRadius: BorderRadius.only(
//             //                         topLeft: Radius.circular(15),
//             //                         topRight: Radius.circular(15))),
//             //                 child: Column(
//             //                   mainAxisAlignment: MainAxisAlignment.center,
//             //                   children: [
//             //                     Container(
//             //                       margin: EdgeInsets.all(8.0),
//             //                       padding: EdgeInsets.only(bottom: 8.0),
//             //                       child: Image.asset(
//             //                         'assets/icons/handle.png',
//             //                         scale: 1.5,
//             //                       ),
//             //                     ),
//             //                     Row(
//             //                       mainAxisAlignment:
//             //                           MainAxisAlignment.spaceAround,
//             //                       children: [
//             //                         Column(
//             //                           mainAxisAlignment:
//             //                               MainAxisAlignment.center,
//             //                           children: [
//             //                             Image.asset(
//             //                               'assets/icons/Document-01.png',
//             //                               height: 45,
//             //                             ),
//             //                             Text(
//             //                               'Document',
//             //                               style: TextStyle(
//             //                                   color: Color(0xff666666),
//             //                                   fontSize: 15),
//             //                             )
//             //                           ],
//             //                         ),
//             //                         Column(
//             //                           mainAxisAlignment:
//             //                               MainAxisAlignment.center,
//             //                           children: [
//             //                             Image.asset(
//             //                               'assets/icons/Gallery-01.png',
//             //                               height: 45,
//             //                             ),
//             //                             Text(
//             //                               'Gallery',
//             //                               style: TextStyle(
//             //                                   color: Color(0xff666666),
//             //                                   fontSize: 15),
//             //                             )
//             //                           ],
//             //                         ),
//             //                         Column(
//             //                           mainAxisAlignment:
//             //                               MainAxisAlignment.center,
//             //                           children: [
//             //                             Image.asset(
//             //                               'assets/icons/Camera-01.png',
//             //                               height: 45,
//             //                             ),
//             //                             Text(
//             //                               'Camera',
//             //                               style: TextStyle(
//             //                                   color: Color(0xff666666),
//             //                                   fontSize: 15),
//             //                             )
//             //                           ],
//             //                         ),
//             //                         Column(
//             //                           mainAxisAlignment:
//             //                               MainAxisAlignment.center,
//             //                           children: [
//             //                             Image.asset(
//             //                               'assets/icons/Contact-01.png',
//             //                               height: 45,
//             //                             ),
//             //                             Text(
//             //                               'Contact',
//             //                               style: TextStyle(
//             //                                   color: Color(0xff666666),
//             //                                   fontSize: 15),
//             //                             )
//             //                           ],
//             //                         ),
//             //                       ],
//             //                     ),
//             //                   ],
//             //                 ));
//             //           },
//             //         ),
//             //       );
//             //     },
//             //   ),
//             // ),
//             TextFieldWithButton(
//               customerName: null,
//               onSubmit: _contactController.sendMessage,
//               textEditingController: _contactController.textController,
//               onEmojiTap: (bool showEmojiKeyboard) {
//                 _contactController.showEmojiKeyboard = !showEmojiKeyboard;
//               },
//               showEmojiKeyboard: _contactController.showEmojiKeyboard,
//               context: context,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget reportButton(bool isCustomerEmpty) => Container(
//         width: double.infinity,
//         padding: EdgeInsets.only(left: 20, right: 20),
//         // decoration: BoxDecoration(
//         //   borderRadius: BorderRadius.circular(5),
//         //   color: Colors.white,
//         // ),
//         child: RaisedButton(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(5),
//             ),
//             color: Colors.white,
//             onPressed: () {
//               Navigator.of(context).pushNamed(AppRoutes.reportRoute);
//             },
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/icons/Document-01.png',
//                   height: 20,
//                 ),
//                 SizedBox(width: 5),
//                 CustomText(
//                   'View Report',
//                   bold: FontWeight.w500,
//                   color: isCustomerEmpty
//                       ? AppTheme.greyish
//                       : AppTheme.brownishGrey,
//                 ),
//               ],
//             )),
//       );

//   Widget ledgerView() {
//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.only(left: 30, right: 30, top: 50),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 width: screenWidth(context) * 0.43,
//                 child: Text(
//                   'Entries',
//                   style: TextStyle(
//                       color: Color(0xff666666),
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Container(
//                 width: screenWidth(context) * 0.15,
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   'Paid',
//                   style: TextStyle(
//                       color: Color(0xff666666),
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Container(
//                 width: screenWidth(context) * 0.25,
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   'Received',
//                   style: TextStyle(
//                       color: Color(0xff666666),
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         10.0.heightBox,
//         Flexible(
//           child: ListView.builder(
//               padding: EdgeInsets.zero,
//               itemCount: 6,
//               itemBuilder: (BuildContext ctxt, int index) {
//                 return InkWell(
//                   onTap: () {
//                     Navigator.pushNamed(context, AppRoutes.attachBillRoute);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     child: Row(
//                       children: [
//                         Card(
//                           margin: EdgeInsets.only(
//                             bottom: 1,
//                             top: 1,
//                           ),
//                           child: Container(
//                             width: screenWidth(context) * 0.39,
//                             height: screenHeight(context) * 0.12,
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 15.0, left: 15, right: 15),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Payment',
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w800),
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.only(
//                                       bottom: 4,
//                                       top: 4,
//                                       right: 2,
//                                     ),
//                                     child: RichText(
//                                       text: TextSpan(
//                                           text: 'Bal. ',
//                                           style: TextStyle(
//                                               color: Color(0xff666666),
//                                               fontSize: 11,
//                                               fontWeight: FontWeight.w500),
//                                           children: [
//                                             TextSpan(
//                                                 text: '$currencyAED ',
//                                                 style: TextStyle(
//                                                     fontSize: 12,
//                                                     color: index % 2 != 0
//                                                         ? AppTheme.tomato
//                                                         : AppTheme.greenColor,
//                                                     fontWeight:
//                                                         FontWeight.bold)),
//                                             TextSpan(
//                                                 text: '4,567',
//                                                 style: TextStyle(
//                                                     fontSize: 12,
//                                                     color: index % 2 != 0
//                                                         ? AppTheme.tomato
//                                                         : Color(0xff2ed06d),
//                                                     fontWeight:
//                                                         FontWeight.bold)),
//                                           ]),
//                                     ),
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.only(top: 0),
//                                     child: RichText(
//                                       text: TextSpan(
//                                         text: '27 May 2021 | 5:28PM',
//                                         style: TextStyle(
//                                           color: Color(0xff666666),
//                                           fontSize: 10,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Card(
//                           margin: EdgeInsets.only(bottom: 2, top: 2, right: 1),
//                           child: Container(
//                             alignment: Alignment.topRight,
//                             height: screenHeight(context) * 0.12,
//                             width: screenWidth(context) * 0.26,
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 15.0, right: 15, bottom: 15, left: 15),
//                               child: Text(
//                                 index % 2 != 0 ? '-$currencyAED 365' : "",
//                                 style: TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Card(
//                           margin: EdgeInsets.only(
//                             bottom: 2,
//                             top: 2,
//                           ),
//                           child: Container(
//                             width: screenWidth(context) * 0.26,
//                             height: screenHeight(context) * 0.12,
//                             alignment: Alignment.topRight,
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 15.0, right: 15, bottom: 15, left: 15),
//                               child: Text(
//                                 index % 2 == 0 ? '+$currencyAED 365' : "",
//                                 style: TextStyle(
//                                     color: AppTheme.greenColor,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//         )
//       ],
//     );
//   }

//   Widget receiveCollection(context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20),
//       child: Column(children: <Widget>[
//         Container(
//           decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(
//                 color: Theme.of(context).primaryColor,
//                 width: 0.5,
//               ),
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               )),
//           child: ListTile(
//               dense: true,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(10),
//                 topRight: Radius.circular(10),
//               )),
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Receive',
//                     style: TextStyle(
//                         color: Theme.of(context).primaryColor,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Image.asset(
//                     'assets/icons/in.png',
//                     scale: 1.2,
//                     color: Theme.of(context).primaryColor,
//                     height: 19,
//                   ),
//                 ],
//               ),
//               trailing: RichText(
//                   text: TextSpan(
//                       style: Theme.of(context).textTheme.bodyText2,
//                       children: [
//                     TextSpan(
//                       text: '$currencyAED ',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                     ),
//                     TextSpan(
//                       text: ' 9,400',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                     ),
//                   ]))),
//         ),
//         // Divider(height:5),
//         Container(
//           // margin: EdgeInsets.symmetric(horizontal: 20),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(
//                 color: Theme.of(context).primaryColor,
//                 width: 0.5,
//               ),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               )),
//           child: ListTile(
//               visualDensity: VisualDensity(horizontal: 0, vertical: -3),
//               dense: true,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(10),
//                 topRight: Radius.circular(10),
//               )),
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Collection',
//                     style: TextStyle(
//                         color: Theme.of(context).primaryColor,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ],
//               ),
//               trailing: RichText(
//                 text: TextSpan(
//                   style: Theme.of(context).textTheme.bodyText2,
//                   children: [
//                     TextSpan(
//                       text: 'SET DATE',
//                       style: TextStyle(
//                           fontSize: 14,
//                           color: Theme.of(context).primaryColor,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     WidgetSpan(
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 5),
//                         child: Icon(
//                           Icons.calendar_today_outlined,
//                           size: 14,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//         ),
//       ]),
//     );
//   }

//   Widget renderMessage(BuildContext context, Message message, int index) {
//     // if (_contactController.myUser == null) return Container();
//     return Column(
//       children: <Widget>[
//         renderMessageSendAtDay(message, index),
//         Material(
//           color: Colors.transparent,
//           // child: Row(mainAxisAlignment: message.from == _contactController.myUser.id ? MainAxisAlignment.end : MainAxisAlignment.start,
//           child: Row(
//             mainAxisAlignment: message.from == '604a01d4d30e50174aef69a0'
//                 ? MainAxisAlignment.start
//                 : MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               renderMessageSendAt(message, MessagePosition.BEFORE),
//               Container(
//                 constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.75),
//                 decoration: message.from == '604a01d4d30e50174aef69a0'
//                     ? BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(20),
//                           bottomLeft: Radius.circular(20),
//                           topRight: Radius.circular(20),
//                         ),
//                         color: (AppTheme.receiverColor),
//                       )
//                     : BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                           topRight: Radius.circular(20),
//                           bottomLeft: Radius.circular(20),
//                           bottomRight: Radius.circular(20),
//                         ),
//                         color: (AppTheme.senderColor),
//                       ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   child: Text(
//                     message.message!.messages!,
//                     style: TextStyle(
//                       color: message.from == '604a01d4d30e50174aef69a0'
//                           ? Colors.black
//                           : Colors.black,
//                       fontSize: 14.5,
//                     ),
//                   ),
//                 ),
//               ),
//               renderMessageSendAt(message, MessagePosition.AFTER),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget renderMessageSendAt(Message message, MessagePosition position) {
//     // if (message.from == _contactController.myUser.id && position == MessagePosition.AFTER) {
//     if (message.from == '604a01d4d30e50174aef69a0' &&
//         position == MessagePosition.AFTER) {
//       return Row(
//         children: <Widget>[
//           SizedBox(width: 6),
//           Text(
//             messageDate(message.sendAt!),
//             style: TextStyle(color: Colors.grey, fontSize: 10),
//           ),
//         ],
//       );
//     }
//     // if (message.from != _contactController.myUser.id && position == MessagePosition.BEFORE) {
//     if (message.from != '604a01d4d30e50174aef69a0' &&
//         position == MessagePosition.BEFORE) {
//       return Row(
//         children: <Widget>[
//           Text(
//             messageDate(message.sendAt!),
//             style: TextStyle(color: Colors.grey, fontSize: 10),
//           ),
//           SizedBox(width: 6),
//         ],
//       );
//     }
//     return Container(height: 0, width: 0);
//   }

//   String messageDate(int milliseconds) {
//     DateTime date = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
//     return format.format(date);
//   }

//   Widget renderMessageSendAtDay(Message message, int index) {
//     if (index == _contactController.selectedChat!.messages!.length - 1) {
//       return getLabelDay(message.sendAt);
//     }
//     final lastMessageSendAt = new DateTime.fromMillisecondsSinceEpoch(
//         _contactController.selectedChat!.messages![index + 1].sendAt!);
//     final messageSendAt =
//         new DateTime.fromMillisecondsSinceEpoch(message.sendAt!);
//     final formatter = UtilDates.formatDay;
//     String formattedLastMessageSendAt = formatter.format(lastMessageSendAt);
//     String formattedMessageSendAt = formatter.format(messageSendAt);
//     if (formattedLastMessageSendAt != formattedMessageSendAt) {
//       return getLabelDay(message.sendAt);
//     }
//     return Container();
//   }

//   Widget getLabelDay(int? milliseconds) {
//     String day = UtilDates.getSendAtDay(milliseconds);
//     return Column(
//       children: <Widget>[
//         SizedBox(
//           height: 4,
//         ),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30),
//             color: Color(0xFFC0CBFF),
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
//             child: Text(
//               day,
//               style: TextStyle(color: Colors.black, fontSize: 12),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 7,
//         ),
//       ],
//     );
//   }
// }

// class LedgerView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.only(left: 30, right: 30, top: 50),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 width: screenWidth(context) * 0.43,
//                 child: Text(
//                   'Entries',
//                   style: TextStyle(
//                       color: Color(0xff666666),
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Container(
//                 width: screenWidth(context) * 0.15,
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   'Paid',
//                   style: TextStyle(
//                       color: Color(0xff666666),
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Container(
//                 width: screenWidth(context) * 0.25,
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   'Received',
//                   style: TextStyle(
//                       color: Color(0xff666666),
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         10.0.heightBox,
//         Flexible(
//           child: ListView.builder(
//               padding: EdgeInsets.zero,
//               itemCount: 6,
//               itemBuilder: (BuildContext ctxt, int index) {
//                 return InkWell(
//                   onTap: () {
//                     Navigator.pushNamed(context, AppRoutes.attachBillRoute);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     child: Row(
//                       children: [
//                         Card(
//                           margin: EdgeInsets.only(
//                             bottom: 1,
//                             top: 1,
//                           ),
//                           child: Container(
//                             width: screenWidth(context) * 0.39,
//                             height: screenHeight(context) * 0.12,
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 15.0, left: 15, right: 15),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Payment',
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w800),
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.only(
//                                       bottom: 4,
//                                       top: 4,
//                                       right: 2,
//                                     ),
//                                     child: RichText(
//                                       text: TextSpan(
//                                           text: 'Bal. ',
//                                           style: TextStyle(
//                                               color: Color(0xff666666),
//                                               fontSize: 11,
//                                               fontWeight: FontWeight.w500),
//                                           children: [
//                                             TextSpan(
//                                                 text: '$currencyAED ',
//                                                 style: TextStyle(
//                                                     fontSize: 12,
//                                                     color: AppTheme.greyish,
//                                                     fontWeight:
//                                                         FontWeight.bold)),
//                                             TextSpan(
//                                                 text: '4,567',
//                                                 style: TextStyle(
//                                                     fontSize: 12,
//                                                     color: AppTheme.greyish,
//                                                     fontWeight:
//                                                         FontWeight.bold)),
//                                           ]),
//                                     ),
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.only(top: 0),
//                                     child: RichText(
//                                       text: TextSpan(
//                                         text: '27 May 2021 | 5:28PM',
//                                         style: TextStyle(
//                                           color: Color(0xff666666),
//                                           fontSize: 10,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Card(
//                           margin: EdgeInsets.only(bottom: 2, top: 2, right: 1),
//                           child: Container(
//                             alignment: Alignment.topRight,
//                             height: screenHeight(context) * 0.12,
//                             width: screenWidth(context) * 0.26,
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 15.0, right: 15, bottom: 15, left: 15),
//                               child: Text(
//                                 index % 2 != 0 ? '-$currencyAED 365' : "",
//                                 style: TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Card(
//                           margin: EdgeInsets.only(
//                             bottom: 2,
//                             top: 2,
//                           ),
//                           child: Container(
//                             width: screenWidth(context) * 0.26,
//                             height: screenHeight(context) * 0.12,
//                             alignment: Alignment.topRight,
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 15.0, right: 15, bottom: 15, left: 15),
//                               child: Text(
//                                 index % 2 == 0 ? '+$currencyAED 365' : "",
//                                 style: TextStyle(
//                                     color: AppTheme.greenColor,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//         )
//       ],
//     );
//   }
// }
