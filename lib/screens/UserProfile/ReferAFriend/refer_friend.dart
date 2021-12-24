import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/main.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/UserProfile/inappbrowser.dart';
// import 'package:im_stepper/stepper.dart';
// // import 'stepper.dart';

class ReferFriends extends StatefulWidget {
  ReferFriends({Key? key}) : super(key: key);

  @override
  _ReferFriendsState createState() => _ReferFriendsState();
}

// @override
// bool shouldRepaint(CustomPainter oldDelegate) => false;
// void paint(Canvas canvas, Size size) {
//   double dashHeight = 5, dashSpace = 3, startY = 0;
//   final paint = Paint()
//     ..color = Colors.red
//     ..strokeWidth = 1;
//   while (startY < size.height) {
//     canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
//     startY += dashHeight + dashSpace;
//   }
// }

class _ReferFriendsState extends State<ReferFriends> {
  final GlobalKey<State> key = GlobalKey<State>();
  // int activeStep = 3; // Initial step set to 5.

  // int upperBound = 2; // upperBound MUST BE total number of icons minus 1.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      appBar: AppBar(
        title: Text('Refer a Friend'),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
            // onPressed: () => Navigator.of(context)..pop(),
            onPressed: () {
              Navigator.pop(context);
              // Navigator.popAndPushNamed(
              //     context, AppRoutes.myProfileScreenRoute);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.rewardsRoute);
            },
            child: Container(
              // height: 50,
              padding: EdgeInsets.only(right: 20),
              child: Image.asset(
                'assets/icons/your reward-09.png',
                // height: 85,
                width: 150,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        // width: double.maxFinite,
        // height: double.infinity,
        child: Container(
          color: AppTheme.paleGrey,
          child: Column(
            children: [
              Image.asset(
                'assets/images/back4.png',
                fit: BoxFit.fitWidth,
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.04,
              // ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: 40,
                          right: 40,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppTheme.coolGrey, width: 0.5),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Container(
                          margin:
                              EdgeInsets.only(left: 10, top: 12, bottom: 12),
                          padding: EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Get your reward in 3 easy steps',
                                    style: TextStyle(
                                      color: AppTheme.brownishGrey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: AppTheme.coolGrey, width: 0.5),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.09),
                        child: Stack(
                          children: [
                            Container(
                              child: Image.asset(
                                AppAssets.ref01Icon,
                                width: double.infinity,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.32,
                                top: MediaQuery.of(context).size.height * 0.02,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01,
                                right: MediaQuery.of(context).size.width * 0.05,
                              ),
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "Share the below ",
                                      style: TextStyle(
                                          color: AppTheme.brownishGrey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17)),
                                  TextSpan(
                                      text: "link ",
                                      style: TextStyle(
                                          color: AppTheme.brownishGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17)),
                                  TextSpan(
                                      text:
                                          "with your friends and their friends",
                                      style: TextStyle(
                                          color: AppTheme.brownishGrey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17)),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: AppTheme.coolGrey, width: 0.5),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.09),
                        child: Stack(
                          children: [
                            Container(
                              child: Image.asset(
                                AppAssets.ref02Icon,
                                width: double.infinity,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.32,
                                top: MediaQuery.of(context).size.height * 0.02,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01,
                                right: MediaQuery.of(context).size.width * 0.05,
                              ),
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "Friends download the ",
                                      style: TextStyle(
                                          color: AppTheme.brownishGrey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17)),
                                  TextSpan(
                                      text: "Urban Ledger ",
                                      style: TextStyle(
                                          color: AppTheme.brownishGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17)),
                                  TextSpan(
                                      text: "app for their company",
                                      style: TextStyle(
                                          color: AppTheme.brownishGrey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17)),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: AppTheme.coolGrey, width: 0.5),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.09),
                        child: Stack(
                          children: [
                            Container(
                              child: Image.asset(
                                AppAssets.ref03Icon,
                                width: double.infinity,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.32,
                                top: MediaQuery.of(context).size.height * 0.02,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01,
                                right: MediaQuery.of(context).size.width * 0.05,
                              ),
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "You\'ll receive ",
                                      style: TextStyle(
                                          color: AppTheme.brownishGrey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17)),
                                  TextSpan(
                                      text: "AED 50 ",
                                      style: TextStyle(
                                          color: AppTheme.brownishGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17)),
                                  TextSpan(
                                      text: "for successful referral",
                                      style: TextStyle(
                                          color: AppTheme.brownishGrey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17)),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.09),
                        width: double.infinity,
                        // height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                // margin: EdgeInsets.only(left: 20),
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  '\t\t\t' +
                                      Repository()
                                          .hiveQueries
                                          .userData
                                          .referral_link
                                          .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppTheme.brownishGrey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                          text: Repository()
                                              .hiveQueries
                                              .userData
                                              .referral_link
                                              .toString()))
                                      .then((result) {
                                    'Link Copied Successfully!'
                                        .showSnackBar(context);
                                  });
                                  debugPrint('Payment Link' +
                                      Repository()
                                          .hiveQueries
                                          .userData
                                          .referral_link
                                          .toString());
                                },
                                child: Container(
                                  padding: EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    color: (AppTheme.electricBlue),
                                  ),
                                  child: Text(
                                    'COPY LINK',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Stack(
                          children: [
                            Image.asset(
                              AppAssets.ref9Icon,
                              fit: BoxFit.cover,
                            ),
                            inviteBanner,
                            // inviteText
                          ],
                        ),
                      ),
                      // Container(
                      //   // width: double.maxFinite,
                      //   // alignment: Alignment.bottomCenter,
                      //   /*
                      //   width: MediaQuery.of(context).size.width * 1,
                      //         height: MediaQuery.of(context).size.height * 0.08,
                      //    */
                      //   height: 260,
                      //   margin: EdgeInsets.only(top: 30),
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //       // fit: BoxFit.fitWidth,
                      //       fit: BoxFit.fill,
                      //       image: AssetImage(
                      //         AppAssets.ref9Icon,
                      //       ),

                      //       // alignment: Alignment.bottomcenter
                      //     ),
                      //   ),
                      //   child: Column(
                      //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Padding(
                      //         padding: EdgeInsets.only(top: 10),
                      //         child: GestureDetector(
                      //           onTap: () async {
                      //             debugPrint(repository
                      //                 .hiveQueries.userData.referral_link);
                      //             debugPrint(repository
                      //                 .hiveQueries.userData.referral_code);
                      //             // showInviteShareBottomSheet(context);

                      //             // final RenderBox box =
                      //             //     context.findRenderObject() as RenderBox;
                      //             // //   AppAssets.ref8Icon
                      //             // // final apiResponse = await repository.ledgerApi
                      //             // //     .networkImageToFile3(
                      //             // //         'https://blog.hubspot.com/hs-fs/hub/53/file-377570249-png/jpg.png?width=225&name=jpg.png')
                      //             // //     .timeout(Duration(seconds: 30),
                      //             // //         onTimeout: () async {
                      //             // //   Navigator.of(context).pop();
                      //             // //   return Future.value(null);
                      //             // // });
                      //             // // await Share.shareFiles([apiResponse],
                      //             // //     text:
                      //             // //         "Hi, I just invited you to use the Urban Ledger app!\nTrack your pending transactions.\nSend and collect payments through secured links.\nReceive instant payments through a dedicated QR code.\nGet detailed reports of your transactions right from your app.\nDownload the app now. - bitly.link.will.appear.",
                      //             // //     sharePositionOrigin:
                      //             // //         box.localToGlobal(Offset.zero) & box.size,
                      //             // //     subject: "Check out UrbanLedger with me");

                      //             // // final RenderBox box =
                      //             // //     context.findRenderObject() as RenderBox;

                      //             // Share.share(
                      //             //     'Hi, I just invited you to use the Urban Ledger app!\nTrack your pending transactions.\nSend and collect payments through secured links.\nReceive instant payments through a dedicated QR code.\nGet detailed reports of your transactions right from your app.\nDownload the app now. - ${Repository().hiveQueries.userData.referral_link}',
                      //             //     sharePositionOrigin:
                      //             //         box.localToGlobal(Offset.zero) &
                      //             //             box.size);
                      //           },
                      //           child: Container(
                      //             width: 105,
                      //             margin: EdgeInsets.symmetric(
                      //                 vertical: 20, horizontal: 34),
                      //             padding: EdgeInsets.symmetric(
                      //               horizontal: 15,
                      //               vertical: 4,
                      //             ),
                      //             // width: 126,
                      //             // height: 30,
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(20),
                      //               border: Border.all(
                      //                 color: AppTheme.coolGrey,
                      //                 width: 0.5,
                      //               ),
                      //             ),
                      //             child: Row(
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.start,
                      //                 mainAxisAlignment: MainAxisAlignment.start,
                      //                 children: [
                      //                   FittedBox(
                      //                     child: Text(
                      //                       'Invite',
                      //                       style: TextStyle(
                      //                           color: AppTheme.electricBlue,
                      //                           fontFamily: 'SFProDisplay',
                      //                           fontWeight: FontWeight
                      //                               .w500, //FontWeight.w500
                      //                           fontSize: 22),
                      //                     ),
                      //                   ),
                      //                   SizedBox(width: 3),
                      //                   Image.asset(
                      //                     'assets/icons/Invite-01.png',
                      //                     height: 22,
                      //                     width: 22,
                      //                   ),
                      //                 ]),
                      //           ),
                      //         ),
                      //       ),
                      //       Container(
                      //         padding: EdgeInsets.only(left: 34),
                      //         child: Text(
                      //           'Invite your frinds to\nUrbanLedger and get reward',
                      //           style: TextStyle(
                      //             color: AppTheme.electricBlue,
                      //             fontFamily: 'SFProDisplay',
                      //             fontWeight: FontWeight.w500, //FontWeight.w500
                      //             fontSize: 18,
                      //           ),
                      //         ),
                      //         alignment: Alignment.centerLeft,
                      //       ),
                      //       SizedBox(height: 10),
                      //       Container(
                      //         padding: EdgeInsets.only(left: 34),
                      //         child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             RichText(
                      //               textAlign: TextAlign.start,
                      //               text: TextSpan(children: <TextSpan>[
                      //                 TextSpan(
                      //                     text: "Get upto ",
                      //                     style: TextStyle(
                      //                         color: AppTheme.brownishGrey,
                      //                         fontWeight: FontWeight.w400,
                      //                         fontSize: 16)),
                      //                 TextSpan(
                      //                     text: "AED 1000 ",
                      //                     style: TextStyle(
                      //                         color: AppTheme.brownishGrey,
                      //                         fontWeight: FontWeight.bold,
                      //                         fontSize: 22)),
                      //                 TextSpan(
                      //                     text:
                      //                         "when they\ndownload and install the app",
                      //                     style: TextStyle(
                      //                         color: AppTheme.brownishGrey,
                      //                         fontWeight: FontWeight.w400,
                      //                         fontSize: 16)),
                      //               ]),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(height: 10),
                      //       GestureDetector(
                      //         onTap: () {
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => UlAppBrowser(
                      //                 url: 'https://urbanledger.app/help',
                      //                 title: 'FAQ',
                      //               ),
                      //             ),
                      //           );
                      //         },
                      //         child: Container(
                      //           padding: EdgeInsets.only(left: 34),
                      //           child: Text(
                      //             'Know more',
                      //             style: TextStyle(
                      //               color: AppTheme.electricBlue,
                      //               fontFamily: 'SFProDisplay',
                      //               fontWeight: FontWeight.w500, //FontWeight.w500
                      //               fontSize: 16,
                      //             ),
                      //           ),
                      //           alignment: Alignment.centerLeft,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get inviteBanner => Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.035,
            left: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                CustomLoadingDialog.showLoadingDialog(context, key);
                String message =
                    await repository.rewardsApi.getReferalMessage();
                if (message.isNotEmpty) {
                  Navigator.of(context).pop();
                  await Share.share(
                    '$message \n${Repository().hiveQueries.userData.referral_link}',
                  );
                }
              },
              child: Container(
                // alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: AppTheme.coolGrey, width: 0.5),
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black54.withOpacity(0.1),
                        blurRadius: 20.0,
                        spreadRadius: 2,
                        offset: Offset(0, 8))
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Invite\t',
                      style: TextStyle(
                          color: AppTheme.electricBlue,
                          fontFamily: 'SFProDisplay',
                          fontWeight: FontWeight.bold, //FontWeight.w500
                          fontSize: 24),
                    ),
                    Image.asset(
                      'assets/icons/Invite-01.png',
                      // height: 22,
                      width: 28,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            inviteText
          ],
        ),
      );

  Widget get inviteText => Container(
        // margin: EdgeInsets.only(
        // top: MediaQuery.of(context).size.height * 0.1,
        // left: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invite your friends to\nUrbanLedger and get reward',
              style: TextStyle(
                color: AppTheme.electricBlue,
                fontFamily: 'SFProDisplay',
                fontWeight: FontWeight.bold, //FontWeight.w500
                fontSize: 22,
              ),
            ),
            SizedBox(height: 10),
            Container(
              // padding: EdgeInsets.only(left: 34),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: "Get upto ",
                          style: TextStyle(
                              color: AppTheme.brownishGrey,
                              fontWeight: FontWeight.w400,
                              fontSize: 16)),
                      TextSpan(
                          text: "AED 1000 ",
                          style: TextStyle(
                              color: AppTheme.brownishGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      TextSpan(
                          text: "when they\ndownload and install the app",
                          style: TextStyle(
                              color: AppTheme.brownishGrey,
                              fontWeight: FontWeight.w400,
                              fontSize: 16)),
                    ]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UlAppBrowser(
                      url: 'https://urbanledger.app/help/referral-program',
                      title: 'FAQ',
                    ),
                  ),
                );
              },
              child: Container(
                child: Text(
                  'Know more',
                  style: TextStyle(
                    color: AppTheme.electricBlue,
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w500, //FontWeight.w500
                    fontSize: 16,
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      );
}

/*
 
                                    
 */

/*

                                    
 */
