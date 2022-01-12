import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Models/add_card_model.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Add%20Card/add_card_screen.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/screens/TransactionScreens/add_cards_provider.dart';

import 'card_ui.dart';

class CardList extends StatefulWidget {
  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> with TickerProviderStateMixin {
  ScrollController controller = ScrollController();

  final GlobalKey<AnimatedListState> _animatedkey = GlobalKey<AnimatedListState>();
  List<CardUi> cardListStatic = [];
  String _title = '';
  int? _index;
  bool closeTopContainer = false;
  bool _loading = false;
  double topContainer = 0;

  bool reverse = true;

  void _onLoading() {
    setState(() {
      _loading = true;
      new Future.delayed(new Duration(seconds: 3), _login);
    });
  }

  Future _login() async {
    setState(() {
      _loading = false;
    });
  }

  late Future<void> _fetchCards;
  bool _fetchCompleted = false;
  @override
  void initState() {
    super.initState();
    // var widgetsBinding;
    
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _fetchCards = getCardsForCARDUI();
      _fetchCards.then((value) async {
        _fetchCompleted = true;
        await Future.delayed(Duration(seconds: 12)).then((value) {
          _controller1.stop(canceled: true);
          _controller1.reset();
        });
      });
    });
    controller.addListener(() {
      double value = controller.offset / 65;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });

    // getCardsForCARDUI().then((value) async {
    //   await Future.delayed(Duration(seconds: 12)).then((value) {
    //     _controller1.stop(canceled: true);
    //     _controller1.reset();
    //   });
    // });
  }

  late AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
  );

  // ..repeat(reverse: true);
  late Animation<Offset> _offsetAnimation =
      Tween<Offset>(begin: const Offset(0, 0.0), end: Offset(0, 0))
          .animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  ));

  late final AnimationController _controller1 = AnimationController(
    duration: const Duration(seconds: 5),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation1 = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller1,
    curve: Curves.elasticIn,
  ));

  final List<Color> circleColors = [
    // Color.fromRGBO(218, 0, 6, 1),// red
    Color.fromRGBO(15, 149, 149, 1),
    Color.fromRGBO(0, 0, 0, 1), // black
    Color.fromRGBO(69, 156, 74, 1), //green
    Color.fromRGBO(219, 175, 3, 1), //yellow
    Color.fromRGBO(15, 149, 149, 1), //teal
    Color.fromRGBO(190, 84, 255, 1), //purple
  ];
  Random random = new Random();
  Color randomGenerator() {
    return circleColors[random.nextInt(1)];
  }

  Future getCardsForCARDUI() async {
    cardListStatic.clear();
    await Provider.of<AddCardsProvider>(context, listen: false)
        .getCard()
        .then((value) {
      debugPrint('qwerty :' + value.toString());
      _index = 0;
      Navigator.of(context).pop();
    }).catchError((e) {
      Navigator.of(context).pop();
      'Please check your internet connection or try again later.'.showSnackBar(context);
    });

    // Future ft = Future(() {});
    // Provider.of<AddCardsProvider>(context, listen: false)
    //     .card!
    //     .forEach((element) {
    //   Random random = new Random();
    //   Color randomGenerator() {
    //     return circleColors[random.nextInt(2)];
    //   }

    // ft = ft.then((_) {
    //   return Future.delayed(const Duration(milliseconds: 100), () {
    //   cardListStatic.add(CardUi(
    //       cardNumber: element.endNumber.toString(),
    //       bankName: element.bankName.toString(),
    //       isDefualt: element.isdefault,
    //       id: element.id.toString(),
    //       cardHolderName: element.hashedName.toString(),
    //       validCard: element.expdate.toString(),
    //       cardImage: element.cardImage,
    //       cardHeight: 260,
    //       backgroundColor: randomGenerator()));
    //   key.currentState!.insertItem(cardListStatic.length - 1);
    // });
    //   });
    // });
    // setState(() {});
    return true;
  }

  bool isSwitched = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _controller1.dispose();
  }

  Tween<Offset> _offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));

  // Provider.of<AddCardsProvider>(context).addListener(() {
  //   getCardsForCARDUI();
  // });
  @override
  Widget build(BuildContext context) {
    Provider.of<AddCardsProvider>(context).addListener(() {
      // if (_fetchCompleted) {
        final _list = List.of(
           Provider.of<AddCardsProvider>(context, listen: false)
            .card ?? <CardDetailsModel> []
        );
        cardListStatic.clear();
        debugPrint("abc");
       
           _list.forEach((element) {
          debugPrint("XYZ");
      
          Random random = new Random();
          Color randomGenerator() {
            return circleColors[random.nextInt(2)];
          }

          cardListStatic.add(CardUi(
              key: ValueKey(element.id),
              cardNumber: element.endNumber.toString(),
              bankName: element.bankName.toString(),
              isDefualt: element.isdefault,
              id: element.id.toString(),
              cardHolderName: element.hashedName.toString(),
              validCard: element.expdate.toString(),
              cardImage: element.cardImage,
              cardHeight: 260,
            
              backgroundColor:randomGenerator()));
          _animatedkey.currentState?.insertItem(cardListStatic.length - 1);
          debugPrint("key is not null: ${_animatedkey.currentState!= null}");
        });
      // }
    });
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight =
        MediaQuery.of(context).size.height * 0.32; // size.height / 3.1;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.chevron_left,
                color: Color.fromRGBO(16, 88, 255, 1), size: 35)),
        title: Text('My Saved Cards',
            style: TextStyle(color: Color.fromRGBO(16, 88, 255, 1))),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          child: NewCustomButton(
            text: 'ADD NEW CARD',
            textColor: Colors.white,
            textSize: 18.0,
            onSubmit: () {
              /*Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddCardScreen()));*/
              Navigator.of(context).pushNamed(AppRoutes.addCardRoute);
              // showDialog(
              //     context: context,
              //     builder: (_) => BankAccountPopUps(
              //           image: 'assets/images/400.png',
              //           title: '400 Authentication failed',
              //         ));
            },
          ),
        ),
      ),
      body: cardListStatic.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Payment Method',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 22,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Text('Currently, you haven\'t set up\na default card',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 18)),
                  SizedBox(height: 65),
                  Image.asset(
                    'assets/images/noCardFound.png',
                  )
                ],
              ),
            )
          : Container(
              child: Column(
                children: <Widget>[
                  if (_index != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Slidable(
                        enabled: true,
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: cardListStatic[_index!],
                        secondaryActions: <Widget>[
                          Column(children: [
                            // Expanded(
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       cardListStatic[_index!]
                            //                   .isDefualt
                            //                   .toString() ==
                            //               '0'
                            //           ? showModalBottomSheet(
                            //               backgroundColor: Colors.transparent,
                            //               context: context,
                            //               builder: (_) =>
                            //                   _deleteCardPopUp(_index))
                            //           : () {};
                            //     },
                            //     child: ClipRRect(
                            //       borderRadius: BorderRadius.horizontal(
                            //           left: Radius.circular(10)),
                            //       child: Container(
                            //           color: cardListStatic[_index!]
                            //                       .isDefualt
                            //                       .toString() ==
                            //                   '0'
                            //               ? Color.fromRGBO(255, 41, 87, 1)
                            //               : AppTheme.coolGrey,
                            //           child: Center(
                            //               child: Icon(
                            //                   Icons.delete_outline_outlined,
                            //                   color: Colors.white))),
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                                child: ClipRRect(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10)),
                              child: Container(
                                width: double.infinity,
                                child: GestureDetector(
                                  onTap: () {
                                    if (cardListStatic[_index!]
                                            .isDefualt
                                            .toString() ==
                                        '0') {
                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (_) =>
                                              _deleteCardPopUp(_index!));
                                    } else {
                                      'Default Card Cannot Be Deleted'
                                          .showSnackBar(context);
                                    }
                                  },
                                  child: Container(
                                      color: AppTheme.coolGrey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'DELETE',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Image.asset(
                                            AppAssets.deleteIcon,
                                            width: 25,
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            )),
                            Expanded(
                                child: ClipRRect(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10)),
                              child: Container(
                                  width: double.infinity,
                                  color: Color.fromRGBO(46, 208, 109, 1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'DEFAULT',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      // SizedBox(height: 5,),
                                      Transform.scale(
                                        scale: 0.8,
                                        child: Container(
                                          child: Switch(
                                            value: cardListStatic[_index!]
                                                        .isDefualt
                                                        .toString() ==
                                                    '0'
                                                ? false
                                                : true,
                                            onChanged: (value) async {
                                              /* setState(() {
                                                          print('value' +
                                                              value.toString());
                                                        });*/
                                              CustomLoadingDialog
                                                  .showLoadingDialog(
                                                      context);
                                              await Provider.of<
                                                          AddCardsProvider>(
                                                      context,
                                                      listen: false)
                                                  .editCard(
                                                      id: cardListStatic[
                                                              _index!]
                                                          .id
                                                          .toString(),
                                                      value: 1)
                                                  .timeout(
                                                      Duration(seconds: 30),
                                                      onTimeout: () {
                                                //  setState(() {});
                                              });
                                              _index = 0;

                                              await getCardsForCARDUI();

                                              /*Navigator.of(context)
                                                            .pop();*/

                                              /*Navigator.of(context)
                                                            .pop(true);*/
                                            },
                                            activeTrackColor:
                                                AppTheme.electricBlue,
                                            activeColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            )),
                          ]),
                        ],
                      ),
                    ),
                  Expanded(
                      // Container(
                      // height: screenHeight(context),
                      
                    child: AnimatedList(
                        key: _animatedkey,
                        controller: controller,
                        initialItemCount: cardListStatic.length,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index, animation) {
                          double scale = 1.0;
                          if (topContainer > 0.5) {
                            scale = index + 0.5 - topContainer;
                            if (scale < 0) {
                              scale = 0;
                            } else if (scale > 1) {
                              scale = 1;
                            }
                          }
                          return SlideTransition(
                            position: animation.drive(_offset),
                            child: Transform(
                              // ScaleTransition(
                              transform: Matrix4.identity()
                                ..scale(scale, scale),
                              // scale: _animation,
                              alignment: Alignment.bottomCenter,
                              child: Align(
                                  heightFactor: 0.25,
                                  alignment: Alignment.topCenter,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _index = index;
                                      });
                                      // _controller.forward();
                                      controller.animateTo(
                                        controller.position.minScrollExtent,
                                        duration: Duration(seconds: 1),
                                        curve: Curves.fastOutSlowIn,
                                      );
                                      print(_index.toString());
                                    },
                                    child: cardListStatic[index],

                                    // _customCard(context, index.toString())
                                    // CardUi(title: index.toString())
                                  )),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
    );
  }

  _deleteCardPopUp(int index) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          // height: screenHeight(context) / 5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 15),
                child: Text('Are you sure you want to\n delete this card?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      NewCustomButton(
                          onSubmit: () {
                            Navigator.of(context).pop();
                          },
                          text: 'CANCEL',
                          textSize: 20,
                          textColor: Colors.white),
                      Consumer<AddCardsProvider>(
                          builder: (context, cart, child) {
                        return NewCustomButton(
                            onSubmit: () async {
                              debugPrint(cardListStatic[index].id);
                              bool isDelete = await cart
                                  .deleleCard(cardListStatic[index].id);
                              if (isDelete) {
                                cardListStatic.removeAt(index);
                                _index = null;
                                setState(() {});
                              }
                              Navigator.of(context).pop();
                            },
                            text: 'CONFIRM',
                            textSize: 20,
                            textColor: Colors.white);
                      }),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _customButton(String title, Function ontap) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ontap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.electricBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
                child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 18),
            )),
          ),
        ),
      ),
    );
  }

  Widget _customCard(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(20),
          color: AppTheme.electricBlue,
        ),
        height: 200,
        // width: screenWidth(context) / 1.1,
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(title),
        ),
      ),
    );
  }

  List itemData = [];
}

// List<CardUi> cardListStatic = [
//   CardUi(
//     backgroundColor: Colors.purple,
//     cardHeight: 250,
//     bankName: 'SBI',
//     cardNumber: '4123456789012345',
//     cardHolderName: 'Mohit Joshi',
//     validCard: '22/1',
//   ),
//   CardUi(
//     backgroundColor: Colors.red,
//     cardHeight: 250,
//     bankName: 'ICICI',
//     cardNumber: '4123456789012345',
//     cardHolderName: 'Mohit Joshi',
//     validCard: '22/1',
//   ),
//   CardUi(
//     backgroundColor: Colors.black,
//     cardHeight: 250,
//     bankName: 'AXIS',
//     cardNumber: '4123456789012345',
//     cardHolderName: 'Mohit Joshi',
//     validCard: '22/1',
//   ),
//   CardUi(
//     backgroundColor: Colors.yellow,
//     cardHeight: 250,
//     bankName: 'IDBI',
//     cardNumber: '4123456789012345',
//     cardHolderName: 'Mohit Joshi',
//     validCard: '22/1',
//   ),
//   CardUi(
//     backgroundColor: Colors.green,
//     cardHeight: 250,
//     bankName: 'HDFC',
//     cardNumber: '4123456789012345',
//     cardHolderName: 'Mohit Joshi',
//     validCard: '22/1',
//   ),
//   CardUi(
//     backgroundColor: Colors.cyan,
//     cardHeight: 250,
//     bankName: 'KOTAK',
//     cardNumber: '4123456789012345',
//     cardHolderName: 'Mohit Joshi',
//     validCard: '22/1',
//   ),
//   CardUi(
//     backgroundColor: Colors.orange,
//     cardHeight: 250,
//     bankName: 'BOI',
//     cardNumber: '4123456789012345',
//     cardHolderName: 'Mohit Joshi',
//     validCard: '22/1',
//   ),
//   CardUi(
//     backgroundColor: Colors.pink,
//     cardHeight: 250,
//     bankName: 'PNB',
//     cardNumber: '4123456789012345',
//     cardHolderName: 'Mohit Joshi',
//     validCard: '22/1',
//   ),
// ];
