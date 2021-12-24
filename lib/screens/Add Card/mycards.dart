import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Card_module/card_selector.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Add Card/add_card_screen.dart';
import 'package:urbanledger/screens/Components/custom_profile_image.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/TransactionScreens/add_cards_provider.dart';

class MyCards extends StatefulWidget {
  final CustomerModel? model;

  @override
  _MyCardsState createState() => _MyCardsState();

  MyCards({this.model});
}

class _MyCardsState extends State<MyCards> {
  @override
  void initState() {
    getCar();
    super.initState();
  }

  getCar() async {
    Provider.of<AddCardsProvider>(context, listen: false).getCard();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 22,
              ),
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
            ),
            CustomProfileImage(
              avatar: widget.model!.avatar,
              mobileNo: widget.model!.mobileNo,
              name: widget.model!.name,
            ),
            // CircleAvatar(
            //   radius: 22,
            //   backgroundColor: Colors.white,
            //   child: CircleAvatar(
            //     radius: 20,
            //     backgroundColor: _colors[random.nextInt(_colors.length)],
            //     backgroundImage:
            //         widget.model!.avatar == null || widget.model!.avatar!.isEmpty
            //             ? null
            //             : MemoryImage(widget.model!.avatar!),
            //     child:
            //         widget.model!.avatar == null || widget.model!.avatar!.isEmpty
            //             ? CustomText(
            //                 getInitials(widget.model!.name!.trim(),
            //                     widget.model!.mobileNo!.trim()),
            //                 color: AppTheme.circularAvatarTextColor,
            //                 size: 22,
            //               )
            //             : null,
            //   ),
            // ),
            SizedBox(
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  '${widget.model?.name.toString() ?? 'User'}',
                  color: Colors.white,
                  size: 18,
                  bold: FontWeight.w600,
                ),
                InkWell(
                  onTap: () {
                    // Navigator.of(context)
                    //     .pushNamed(AppRoutes.customerProfileRoute);
                  },
                  child: Text(
                    '${widget.model!.mobileNo.toString()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        actions: [
          Icon(
            Icons.more_vert,
            color: Colors.white,
            size: 30,
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<AddCardsProvider>(
              builder: (context, card, child) {
                return card.card!.isEmpty
                    ? Container(
                      
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                'assets/images/Add Card Illustration-01.png',
                                height: deviceHeight * 0.28,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddCardScreen(),
                                  ),
                                );
                                setState(() {});
                                // showDialog(
                                //   useSafeArea: true,
                                //   builder: (context) =>
                                //       _buildAddCardPopupDialog(
                                //           context: context),
                                //   context: context,
                                // );
                              }, // 
                            
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddCardScreen(),
                                          ));
                                      setState(() {});
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 19,
                                          height: 19,
                                          child: Image.asset(
                                              'assets/icons/Add New Card-01.png'),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Add New Card',
                                          style: TextStyle(
                                              fontFamily: 'SFProDisplay',
                                              color: AppTheme.electricBlue,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              letterSpacing:
                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                              height: 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // // InkWell(
                            // //   onTap: () {
                            // //     Navigator.push(
                            // //         context,
                            // //         MaterialPageRoute(
                            // //           builder: (context) =>
                            // //               AddCardScreen(),
                            // //         ));
                            // //     setState(() {});
                            // //   },
                            // //   child: Row(
                            // //     mainAxisAlignment:
                            // //         MainAxisAlignment.center,
                            // //     children: [
                            // //       Container(
                            // //         width: 19,
                            // //         height: 19,
                            // //         child: Image.asset(
                            // //             'assets/icons/Add New Card-01.png'),
                            // //       ),
                            // //       SizedBox(
                            // //         width: 5,
                            // //       ),
                            // //       Text(
                            // //         'Add New Card',
                            // //         style: TextStyle(
                            // //             fontFamily: 'SFProDisplay',
                            // //             color: AppTheme.electricBlue,
                            // //             fontSize: 16,
                            // //             fontWeight: FontWeight.w600,
                            // //             letterSpacing:
                            // //                 0 /*percentages not used in flutter. defaulting to zero*/,
                            // //             height: 1),
                            // //       ),
                            // //     ],
                            // //   ),
                            // // ),
                            // // SizedBox(
                            // //   height: 20,
                            // // ),
                          ],
                        ),
                      )
                    : CardSelector(
                        mainCardWidth: 240,
                        mainCardHeight: 150,
                        mainCardPadding: -32,
                        cardAnimationDurationMs: 200,
                        cardsGap: 24.0,
                        dropTargetWidth: 8.0,
                        cards: card.card!
                            .map(
                              
                              (e) => Text('${e.hashedName}'),
                            )
                            .toList(),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

// final List<Color> _colors = [
//   Color.fromRGBO(137, 171, 249, 1),
//   AppTheme.brownishGrey,
//   AppTheme.greyish,
//   AppTheme.electricBlue,
// ];
// Random random = Random();
}
