import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/chat_module/data/models/message.dart';
import 'package:urbanledger/chat_module/data/providers/chats_provider.dart';
import 'package:urbanledger/chat_module/data/repositories/chat_repository.dart';
import 'package:urbanledger/chat_module/screens/contact/contact_controller.dart';
import 'package:urbanledger/chat_module/utils/dates.dart';
import 'package:urbanledger/chat_module/widgets/text_field_with_button.dart';
import 'package:urbanledger/screens/AddBankAccount/add_bank_account.dart';
import 'package:urbanledger/screens/AddBankAccount/user_bank_account_provider.dart';
import 'package:urbanledger/screens/Components/custom_popup.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/TransactionScreens/ledger_view.dart';
import 'package:urbanledger/screens/TransactionScreens/photo_view.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import 'package:uuid/uuid.dart';
import 'package:urbanledger/Models/routeArgs.dart';

enum MessagePosition { BEFORE, AFTER }

class TransactionListScreen extends StatefulWidget {
  final CustomerModel customerModel;
  final bool isFromUlChat;

  const TransactionListScreen(
      {Key? key, required this.customerModel, required this.isFromUlChat})
      : super(key: key);

  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen>
    with SingleTickerProviderStateMixin {
  // AudioCache audioCache = AudioCache();
  late TabController _tabController;
  double? balanceAmount;
  DateTime? _selectedDate;
  int? _selectedRadioOption;
  late ContactController _contactController;
  final format = new DateFormat("hh:mm a");
  final Repository repository = Repository();
  CustomerModel _customerData = CustomerModel();
  ChatRepository _chatRepository = ChatRepository();
  final GlobalKey<State> key = GlobalKey<State>();
  Map<String, String>? files;
  String? filePath;
  bool _audio = false;
  bool _camera = false;
  bool _document = false;
  bool _gallery = false;
  bool collapaseHeight = false;
  bool isLoad = false;
  File? _url;
  String? _isPlaying;
  String? uid;
  Map<String, bool> _isDownload = {};
  Map<String, Duration> dur = {};
  Map<String, Duration> pos = {};
  late AudioPlayer audioPlayer;
  // late AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  late Stream<Map<String, DurationState>> _durationState;
  Map<String, DurationState> _durationStr = {};
  late String localCustomerId;
  // AudioCache audioCache = AudioCache();
  String? path;
  String? path2;
  GlobalKey _key = GlobalKey();
  bool isLoading = false;
  bool isEmiratesIdDone = false;
  bool isTradeLicenseDone = false;
  bool status = false;
  bool isPremium = false;
  bool isNotAccount = false;
  getRecentBankAcc() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });

      await Provider.of<UserBankAccountProvider>(context, listen: false)
          .getUserBankAccount();
      isNotAccount =
          Provider.of<UserBankAccountProvider>(context, listen: false)
              .isAccount;
      debugPrint(isNotAccount.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  showBankAccountDialog() async => await showDialog(
      builder: (context) => Dialog(
            insetPadding:
                EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.75),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 5),
                  child: CustomText(
                    "No Bank Account Found.",
                    color: AppTheme.tomato,
                    bold: FontWeight.w500,
                    size: 18,
                  ),
                ),
                CustomText(
                  'Please Add Your Bank Account.',
                  size: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: RaisedButton(
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: AppTheme.electricBlue,
                            child: CustomText(
                              'Add Account'.toUpperCase(),
                              color: Colors.white,
                              size: (18),
                              bold: FontWeight.w500,
                            ),
                            onPressed: () {
                              Navigator.pop(context, true);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddBankAccount()));
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: RaisedButton(
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: AppTheme.electricBlue,
                            child: CustomText(
                              'Not now'.toUpperCase(),
                              color: Colors.white,
                              size: (18),
                              bold: FontWeight.w500,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
      barrierDismissible: false,
      context: context);

  // modalSheet() {
  //   return showModalBottomSheet(
  //       context: context,
  //       isDismissible: true,
  //       enableDrag: true,
  //       builder: (context) {
  //         return Container(
  //           color: Color(0xFF737373), //could change this to Color(0xFF737373),
  //           height: (isEmiratesIdDone == false &&
  //                   isTradeLicenseDone == false &&
  //                   isPremium == true)
  //               ? MediaQuery.of(context).size.height * 0.3
  //               : MediaQuery.of(context).size.height * 0.4,
  //           child: Container(
  //             decoration: new BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: new BorderRadius.only(
  //                     topLeft: const Radius.circular(10.0),
  //                     topRight: const Radius.circular(10.0))),
  //             //height: MediaQuery.of(context).size.height * 0.25,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Padding(
  //                   padding: const EdgeInsets.only(
  //                     top: 40.0,
  //                     left: 40.0,
  //                     right: 40.0,
  //                     bottom: 10,
  //                   ),
  //                   child: (isEmiratesIdDone == false &&
  //                           isTradeLicenseDone == false &&
  //                           isPremium == true)
  //                       ? Text(
  //                           'You have already purchased the Premium Subscription.',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               color: AppTheme.brownishGrey,
  //                               fontFamily: 'SFProDisplay',
  //                               fontSize: 18,
  //                               letterSpacing:
  //                                   0 /*percentages not used in flutter. defaulting to zero*/,
  //                               fontWeight: FontWeight.normal,
  //                               height: 1),
  //                         )
  //                       : Text(
  //                           (isEmiratesIdDone == true &&
  //                                   isTradeLicenseDone == true)
  //                               ? 'KYC verification is pending.\nPlease try after some time.'
  //                               : 'KYC is a mandatory step for\nPremium features.',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               color: Color.fromRGBO(233, 66, 53, 1),
  //                               fontFamily: 'SFProDisplay',
  //                               fontSize: 18,
  //                               letterSpacing:
  //                                   0 /*percentages not used in flutter. defaulting to zero*/,
  //                               fontWeight: FontWeight.normal,
  //                               height: 1),
  //                         ),
  //                 ),
  //                 if (isPremium == false)
  //                   Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Container(
  //                               margin: EdgeInsets.symmetric(horizontal: 10),
  //                               child: Image.asset(
  //                                 'assets/icons/emiratesid.png',
  //                                 height: 35,
  //                               ),
  //                             ),
  //                             Text(
  //                               'Emirates ID',
  //                               style: TextStyle(
  //                                   color: Color(0xff666666),
  //                                   fontFamily: 'SFProDisplay',
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 17),
  //                             ),
  //                           ],
  //                         ),
  //                         isTradeLicenseDone == false
  //                             ? Icon(
  //                                 Icons.chevron_right,
  //                                 size: 32,
  //                                 color: Color(0xff666666),
  //                               )
  //                             : CircleAvatar(
  //                                 backgroundColor: Colors.green,
  //                                 radius: 20,
  //                                 child: Center(
  //                                   child: Icon(
  //                                     Icons.check,
  //                                     color: Colors.white,
  //                                   ),
  //                                 ),
  //                               )
  //                       ],
  //                     ),
  //                   ),
  //                 if (isPremium == false)
  //                   Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Container(
  //                               margin: EdgeInsets.symmetric(horizontal: 10),
  //                               child: Image.asset(
  //                                 'assets/icons/tradelisc.png',
  //                                 height: 35,
  //                               ),
  //                             ),
  //                             Text(
  //                               'UAE Trade License',
  //                               style: TextStyle(
  //                                   color: Color(0xff666666),
  //                                   fontFamily: 'SFProDisplay',
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 17),
  //                             ),
  //                           ],
  //                         ),
  //                         isTradeLicenseDone == false
  //                             ? Icon(
  //                                 Icons.chevron_right,
  //                                 size: 32,
  //                                 color: Color(0xff666666),
  //                               )
  //                             : CircleAvatar(
  //                                 backgroundColor: Colors.green,
  //                                 radius: 20,
  //                                 child: Center(
  //                                   child: Icon(
  //                                     Icons.check,
  //                                     color: Colors.white,
  //                                   ),
  //                                 ),
  //                               )
  //                       ],
  //                     ),
  //                   ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(20.0),
  //                   child: (isEmiratesIdDone == true &&
  //                           isTradeLicenseDone == true)
  //                       ? NewCustomButton(
  //                           onSubmit: () {
  //                             Navigator.pop(context);
  //                           },
  //                           textColor: Colors.white,
  //                           text: 'OKAY',
  //                           textSize: 14,
  //                         )
  //                       : (isEmiratesIdDone == false &&
  //                               isTradeLicenseDone == false &&
  //                               isPremium == true)
  //                           ? Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.pop(context);
  //                                     },
  //                                     text: 'CANCEL',
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   width: 20,
  //                                 ),
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.popAndPushNamed(context,
  //                                           AppRoutes.urbanLedgerPremium);
  //                                     },
  //                                     text: 'Upgrade'.toUpperCase(),
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                               ],
  //                             )
  //                           : Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.pop(context);
  //                                     },
  //                                     text: 'CANCEL',
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   width: 20,
  //                                 ),
  //                                 Expanded(
  //                                   child: NewCustomButton(
  //                                     onSubmit: () {
  //                                       Navigator.popAndPushNamed(
  //                                           context, AppRoutes.manageKyc3Route);
  //                                     },
  //                                     text: 'COMPLETE KYC',
  //                                     textColor: Colors.white,
  //                                     textSize: 14,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  modalSheet() {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          return Container(
            color: Color(0xFF737373), //could change this to Color(0xFF737373),
            height: (status == true)
                ? MediaQuery.of(context).size.height * 0.25
                : MediaQuery.of(context).size.height * 0.4,
            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              //height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                      left: 40.0,
                      right: 40.0,
                      bottom: 10,
                    ),
                    child: (status == true && isPremium == false)
                        ? Text(
                            'Please upgrade your Urban Ledger account in order to access this feature.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppTheme.brownishGrey,
                                fontFamily: 'SFProDisplay',
                                fontSize: 18,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.bold,
                                height: 1),
                          )
                        : Text(
                            (isEmiratesIdDone == true &&
                                    isTradeLicenseDone == true)
                                ? 'KYC verification is pending.\nPlease try after some time.'
                                : 'KYC is a mandatory step for\nPremium features.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(233, 66, 53, 1),
                                fontFamily: 'SFProDisplay',
                                fontSize: 18,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                  ),
                  if (status == false)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Image.asset(
                                  'assets/icons/emiratesid.png',
                                  height: 35,
                                ),
                              ),
                              Text(
                                'Emirates ID',
                                style: TextStyle(
                                    color: Color(0xff666666),
                                    fontFamily: 'SFProDisplay',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17),
                              ),
                            ],
                          ),
                          isTradeLicenseDone == false
                              ? Icon(
                                  Icons.chevron_right,
                                  size: 32,
                                  color: Color(0xff666666),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.green,
                                  radius: 20,
                                  child: Center(
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  if (status == false)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Image.asset(
                                  'assets/icons/tradelisc.png',
                                  height: 35,
                                ),
                              ),
                              Text(
                                'UAE Trade License',
                                style: TextStyle(
                                    color: Color(0xff666666),
                                    fontFamily: 'SFProDisplay',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17),
                              ),
                            ],
                          ),
                          isTradeLicenseDone == false
                              ? Icon(
                                  Icons.chevron_right,
                                  size: 32,
                                  color: Color(0xff666666),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.green,
                                  radius: 20,
                                  child: Center(
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: (isEmiratesIdDone == true &&
                            isTradeLicenseDone == true)
                        ? NewCustomButton(
                            onSubmit: () {
                              Navigator.pop(context);
                            },
                            textColor: Colors.white,
                            text: 'OKAY',
                            textSize: 14,
                          )
                        : (isEmiratesIdDone == false &&
                                isTradeLicenseDone == false &&
                                isPremium == true)
                            ? Row(
                                children: [
                                  Expanded(
                                    child: NewCustomButton(
                                      onSubmit: () {
                                        Navigator.pop(context);
                                      },
                                      text: 'CANCEL',
                                      textColor: Colors.white,
                                      textSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: NewCustomButton(
                                      onSubmit: () {
                                        Navigator.popAndPushNamed(context,
                                            AppRoutes.urbanLedgerPremium);
                                      },
                                      text: 'Upgrade'.toUpperCase(),
                                      textColor: Colors.white,
                                      textSize: 14,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: NewCustomButton(
                                      onSubmit: () {
                                        Navigator.pop(context);
                                      },
                                      text: 'CANCEL',
                                      textColor: Colors.white,
                                      textSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: NewCustomButton(
                                      onSubmit: () {
                                        Navigator.popAndPushNamed(
                                            context, AppRoutes.manageKyc3Route);
                                      },
                                      text: 'COMPLETE KYC',
                                      textColor: Colors.white,
                                      textSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                  ),
                ],
              ),
            ),
          );
        });
  }

// Future getKyc() async {
//     setState(() {
//       isLoading = true;
//     });
//     await KycAPI.kycApiProvider.kycCheker().catchError((e) {
//       setState(() {
//         isLoading = false;
//       });
//       'Please check your internet connection or try again later.'.showSnackBar(context);
//     }).then((value) {
//       setState(() {
//         isLoading = false;
//       });
//     });
//     calculatePremiumDate();
//     setState(() {
//       isLoading = false;
//     });
//   }

  merchantBankNotAddedModalSheet({text}) {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          return Container(
            color: Color(0xFF737373), //could change this to Color(0xFF737373),

            height: MediaQuery.of(context).size.height * 0.27,
            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              //height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                      left: 40.0,
                      right: 40.0,
                      bottom: 10,
                    ),
                    child: Text(
                      '$text',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppTheme.brownishGrey,
                          fontFamily: 'SFProDisplay',
                          fontSize: 18,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Please try again later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppTheme.tomato,
                          fontFamily: 'SFProDisplay',
                          fontSize: 18,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.w700,
                          height: 1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: NewCustomButton(
                      onSubmit: () {
                        Navigator.pop(context);
                      },
                      textColor: Colors.white,
                      text: 'OKAY',
                      textSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _customerData = widget.customerModel;
    data();
    // getKyc();
    // getRecentBankAcc();

    audioPlayer = AudioPlayer();
    _durationState =
        Rx.combineLatest2<Duration, PlaybackEvent, Map<String, DurationState>>(
            audioPlayer.positionStream, audioPlayer.playbackEventStream,
            (position, playbackEvent) {
      var play = _isPlaying;
      if (play != null)
        _durationStr[play] = DurationState(
          progress: position,
          buffered: playbackEvent.bufferedPosition,
          total: playbackEvent.duration,
        );
      return _durationStr;
    }).asBroadcastStream();

    localCustomerId = _customerData.customerId!;
    _selectedDate = _customerData.collectionDate;
    _tabController = TabController(
        initialIndex: widget.isFromUlChat ? 1 : 0, length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {});
    });
    // _durationState =
    //     Rx.combineLatest2<Duration, PlaybackEvent, Map<String, DurationState>>(
    //         audioPlayer.positionStream, audioPlayer.playbackEventStream,
    //         (position, playbackEvent) {
    //   var play = _isPlaying;
    //   if (play != null)
    //     _durationStr[play] = DurationState(
    //       progress: position,
    //       buffered: playbackEvent.bufferedPosition,
    //       total: playbackEvent.duration,
    //     );
    //   return _durationStr;
    // }).asBroadcastStream();

    // audioPlayer.playerStateStream
    //     .listen((state) {
    //   if (state.playing) {
    //     switch (state.processingState) {
    //       case ProcessingState.idle:
    //         debugPrint('idle');
    //         break;
    //       case ProcessingState.loading:
    //         debugPrint('loading');
    //         break;
    //       case ProcessingState.buffering:
    //         debugPrint('buffering');
    //         break;
    //       case ProcessingState.ready:
    //         debugPrint('ready');
    //         break;
    //       case ProcessingState.completed:
    //         debugPrint('completed');
    //         setState(() {
    //           _isPlaying = null;
    //           audioPlayer.seek(Duration.zero);
    //         });
    //         break;
    //     }
    //   }
    // });
    // _animationController =
    //   AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    _contactController = ContactController(
      context: context,
    );
    // ContactController.initChat(context, _customerData.chatId);
  }

  data() {
    debugPrint('chattttt id');
    debugPrint(_customerData.chatId);
    debugPrint(_customerData.customerId);
    uid = _customerData.customerId;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _contactController.dispose();
    // _assetsAudioPlayer.dispose();
    audioPlayer.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _contactController.initProvider();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.none,
              height: (_tabController.index != 1)
                  ? deviceHeight * 0.2
                  : deviceHeight * 0.12,
              width: double.infinity,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(AppAssets.backgroundImage2),
                      alignment: Alignment.topCenter)),
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: 5, bottom: 10, left: 10, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          // width: 30,
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 22,
                            ),
                            color: Colors.white,
                            onPressed: () {
                              // audioPlayer.stop();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xff666666),
                          child: Center(
                            child: Text(
                              _customerData.name != null ||
                                      _customerData.name != ''
                                  ? getInitials(
                                          _customerData.name ??
                                              _customerData.mobileNo,
                                          _customerData.mobileNo)
                                      .toUpperCase()
                                  : getInitials(
                                          _customerData.mobileNo ??
                                              _customerData.mobileNo,
                                          _customerData.mobileNo)
                                      .toUpperCase(),
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 26),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                AppRoutes.customerProfileRoute,
                                arguments: _customerData);
                            CustomLoadingDialog.showLoadingDialog(context, key);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              top: 3,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  _customerData.name.toString() != ''
                                      ? _customerData.name.toString()
                                      : _customerData.mobileNo.toString(),
                                  color: Colors.white,
                                  size: 20,
                                  bold: FontWeight.w500,
                                ),
                                Text(
                                  'Click to view settings',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                AppRoutes.reportRoute,
                                arguments: _customerData);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Image.asset(
                              AppAssets.reportIcon,
                              height: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_tabController.index != 1) receiveCollection(context),
                  Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.transparent,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.045,
                          vertical: 2),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage(AppAssets.tabMiddleLine),
                            fit: BoxFit.fitWidth,
                          ),
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: TabBar(
                          //indicatorColor: AppTheme.electricBlue,
                          controller: _tabController,
                          indicatorWeight: 5,
                          labelColor: AppTheme.brownishGrey,
                          unselectedLabelColor: AppTheme.brownishGrey,
                          indicator: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppTheme.electricBlue, width: 4)),
                          ),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          unselectedLabelStyle: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                          tabs: [
                            Tab(
                              text: 'Ledger',
                            ),
                            Tab(
                              text: 'Chats',
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 5, left: 5),
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          LedgerView(
                            // customerId: uid,
                            balanceAmount: balanceAmount,
                            customerModel: _customerData,
                            sendMessage: (amount, details, paymentType) {
                              _contactController.sendMessage(
                                  _customerData.customerId,
                                  _customerData.chatId,
                                  _customerData.name,
                                  _customerData.mobileNo!,
                                  amount,
                                  details,
                                  null,
                                  null,
                                  null,
                                  null,
                                  null,
                                  paymentType!,
                                  null);
                            },
                          ),
                          // Container(),
                          chatScreen(),
                          // ChatScreenPage(
                          //   customerModel: _customerData,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget receiveCollection(context) {
    return FutureBuilder<double>(
        future: repository.queries
            .getPaidMinusReceived(_customerData.customerId.toString()),
        builder: (context, snapshot) {
          // setState(() {
          //   if (!(snapshot.data!.isNegative)) {
          //     collapaseHeight = !collapaseHeight;
          //   }
          // });
          if (snapshot.data != null) balanceAmount = snapshot.data ?? 0;
          return Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: AppTheme.electricBlue,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
              child: Column(children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: MediaQuery.of(context).size.height * 0.0001),
                    // height: 43,
                    /*  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppTheme.electricBlue,
                        width: 0.5,
                      ),
                    ), */
                    alignment: Alignment.center,
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -3),
                      //dense: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            snapshot.data != null
                                ? snapshot.data!.isNegative
                                    ? 'You will Get'
                                    : 'You will Give'
                                : 'You will Get',
                            style: TextStyle(
                                color: AppTheme.electricBlue,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          // Image.asset(
                          //   snapshot.data != null
                          //       ? snapshot.data!.isNegative
                          //           ? AppAssets.inIcon
                          //           : AppAssets.outIcon
                          //       : AppAssets.inIcon,
                          //   scale: 1.2,
                          //   color: AppTheme.electricBlue,
                          //   height: 20,
                          // ),
                        ],
                      ),
                      trailing: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyText2,
                          children: [
                            TextSpan(
                              text: '$currencyAED  ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.electricBlue,
                              ),
                            ),
                            TextSpan(
                              text: snapshot.data != null
                                  ? snapshot.data!.isNegative
                                      ? (snapshot.data)!
                                          .getFormattedCurrency
                                          .substring(1)
                                      : (snapshot.data)!.getFormattedCurrency
                                  : ' 0',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.electricBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                if (snapshot.data != null &&
                    (snapshot.data!.isNegative && snapshot.data != 0.0))
                  Divider(
                    color: AppTheme.electricBlue,
                    height: 1,
                  ),
                if (snapshot.data != null &&
                    (snapshot.data!.isNegative && snapshot.data != 0.0))
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: MediaQuery.of(context).size.height * 0.0001),
                    // height: 43,
                    // margin: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    child: _selectedDate == null
                        ? ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -3),
                            dense: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            )),
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Collection',
                                  style: TextStyle(
                                      color: AppTheme.electricBlue,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            trailing: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyText2,
                                children: [
                                  TextSpan(
                                    text: _selectedDate == null
                                        ? 'Set Date'.toUpperCase()
                                        : DateFormat('EEE, dd MMM yyyy')
                                            .format(_selectedDate!),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        if (await allChecker(context)) {
                                          await showDateBottomSheet(
                                              snapshot.data);
                                          setState(() {});
                                        }
                                      },
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: isLoad == true
                                            ? AppTheme.coolGrey
                                            : AppTheme.electricBlue,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  WidgetSpan(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Image.asset(
                                        'assets/icons/calendar.png',
                                        height: 18,
                                        color: isLoad == true
                                            ? AppTheme.coolGrey
                                            : AppTheme.electricBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        : ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            title: RichText(
                              text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyText2,
                                  children: [
                                    if (_selectedDate!
                                        .difference(DateTime.now())
                                        .isNegative)
                                      TextSpan(
                                          text:
                                              'Payment ${DateTime.now().difference(_selectedDate!).inDays == 0 ? 'is' : 'was'} due ',
                                          style: TextStyle(
                                            color: AppTheme.electricBlue,
                                            fontSize: 18,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: DateTime.now()
                                                          .difference(
                                                              _selectedDate!)
                                                          .inDays ==
                                                      0
                                                  ? 'Today'
                                                  : duration(_selectedDate!),
                                              style: TextStyle(
                                                  color: AppTheme.tomato,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ]),
                                    if (!_selectedDate!
                                        .difference(DateTime.now())
                                        .isNegative)
                                      TextSpan(
                                          text: 'Collect money on ',
                                          style: TextStyle(
                                            color: AppTheme.electricBlue,
                                            fontSize: 18,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  DateFormat('EEE, dd MMM yyyy')
                                                      .format(_selectedDate!),
                                              style: TextStyle(
                                                  color: isLoad == true
                                                      ? AppTheme.coolGrey
                                                      : AppTheme.electricBlue,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ]),
                                  ]),
                            ),
                            trailing: Icon(
                              Icons.chevron_right_rounded,
                              color: isLoad == true
                                  ? AppTheme.coolGrey
                                  : AppTheme.electricBlue,
                            ),
                            onTap: () async {
                              if (await allChecker(context)) {
                                await showDateBottomSheet(snapshot.data);
                                setState(() {});
                              }
                            },
                          ),
                  ),
              ]),
            ),
          );
        });
  }

  Future<void> showDateBottomSheet(double? amount) async {
    DateTime? tempDate = _selectedDate;
    int? tempRadioOption =
        _selectedRadioOption ?? getRadioOptionSelectedOnDate(tempDate);

    await showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 6,
                      width: 42,
                      decoration: BoxDecoration(
                          color: AppTheme.greyish,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Set Date for ${_customerData.name}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          '$currencyAED ' +
                              (amount!.isNegative
                                  ? removeDecimalif0(amount).substring(1)
                                  : removeDecimalif0(amount)),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppTheme.tomato),
                        ),
                      ],
                    ),
                  ),
                  RadioListTile(
                    dense: true,
                    activeColor: AppTheme.electricBlue,
                    value: 0,
                    groupValue: tempRadioOption,
                    onChanged: (value) {
                      tempRadioOption = value as int?;
                      tempDate = (DateTime.now()).add(Duration(days: 7));
                      setState(() {});
                    },
                    title: Text(
                      'Next Week',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: tempRadioOption == 0
                              ? Colors.black
                              : AppTheme.brownishGrey),
                    ),
                    secondary: tempRadioOption == 0
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                tempDate == null
                                    ? DateFormat('EEE, dd MMM yyyy')
                                        .format(DateTime.now())
                                    : DateFormat('EEE, dd MMM yyyy')
                                        .format(tempDate!),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.electricBlue),
                              ),
                              SizedBox(width: 5),
                              Image.asset(
                                'assets/icons/calendar.png',
                                color: AppTheme.brownishGrey,
                              ),
                              SizedBox(width: 15),
                            ],
                          )
                        : Container(
                            width: 5,
                          ),
                  ),
                  RadioListTile(
                    dense: true,
                    value: 1,
                    groupValue: tempRadioOption,
                    onChanged: (value) {
                      tempRadioOption = value as int?;
                      tempDate = Jiffy(DateTime.now()).add(months: 1).dateTime;
                      setState(() {});
                    },
                    title: Text(
                      'Next Month',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: tempRadioOption == 1
                              ? Colors.black
                              : AppTheme.brownishGrey),
                    ),
                    secondary: tempRadioOption == 1
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                tempDate == null
                                    ? DateFormat('EEE, dd MMM yyyy')
                                        .format(DateTime.now())
                                    : DateFormat('EEE, dd MMM yyyy')
                                        .format(tempDate!),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.electricBlue),
                              ),
                              SizedBox(width: 5),
                              Image.asset(
                                'assets/icons/calendar.png',
                                color: AppTheme.brownishGrey,
                              ),
                              SizedBox(width: 15),
                            ],
                          )
                        : Container(
                            width: 5,
                          ),
                  ),
                  RadioListTile(
                    dense: true,
                    activeColor: AppTheme.electricBlue,
                    value: 2,
                    groupValue: tempRadioOption,
                    toggleable: true,
                    onChanged: (value) async {
                      final selectedDate = await showCustomDatePicker(
                        context,
                        firstDate: DateTime.now(),
                        initialDate: tempDate ?? DateTime.now(),
                        // lastDate: Jiffy(DateTime.now()).add(years: 1)
                      );
                      if (selectedDate != null) {
                        tempDate = selectedDate;
                        tempRadioOption = 2;
                        setState(() {});
                      }
                    },
                    title: Text(
                      'Calendar',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: tempRadioOption == 2
                              ? Colors.black
                              : AppTheme.brownishGrey),
                    ),
                    secondary: tempRadioOption == 2
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                tempDate == null
                                    ? DateFormat('EEE, dd MMM yyyy')
                                        .format(DateTime.now())
                                    : DateFormat('EEE, dd MMM yyyy')
                                        .format(tempDate!),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.electricBlue),
                              ),
                              SizedBox(width: 5),
                              Image.asset(
                                'assets/icons/calendar.png',
                                color: AppTheme.brownishGrey,
                              ),
                              SizedBox(width: 15),
                            ],
                          )
                        : Container(
                            width: 5,
                          ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: isLoad == true
                              ? AppTheme.brownishGrey
                              : AppTheme.electricBlue,
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          _selectedDate == null || _selectedDate != tempDate
                              ? 'SET DATE'
                              : 'REMOVE'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: tempRadioOption == null
                            ? null
                            : isLoad == true
                                ? () {}
                                : _selectedDate == null ||
                                        _selectedDate != tempDate
                                    ? () async {
                                        setState(() {
                                          isLoad = true;
                                        });
                                        // CustomLoadingDialog.showLoadingDialog(
                                        // context, key);
                                        _selectedDate = tempDate;
                                        _selectedRadioOption = tempRadioOption;
                                        repository.queries.updateCollectionDate(
                                            _selectedDate,
                                            _customerData.customerId);
                                        Map<String, dynamic> data = {
                                          "amount": '$amount',
                                          "currency": 'AED',
                                          "note": "",
                                          "bills": ''
                                        };
                                        final String requestId =
                                            await repository.paymentThroughQRApi
                                                .getRequestId(data);
                                        if (requestId.isNotEmpty) {
                                          _contactController.sendMessage(
                                              _customerData.customerId,
                                              _customerData.chatId,
                                              _customerData.name,
                                              _customerData.mobileNo!,
                                              amount,
                                              null,
                                              _selectedDate.toString(),
                                              null,
                                              null,
                                              null,
                                              requestId,
                                              3,
                                              null);
                                          setState(() {
                                            isLoad = false;
                                          });
                                        }
                                        BlocProvider.of<ContactsCubit>(context)
                                            .getContacts(
                                                Provider.of<BusinessProvider>(
                                                        context,
                                                        listen: false)
                                                    .selectedBusiness
                                                    .businessId);
                                        Navigator.of(context).pop();
                                      }
                                    : () {
                                        _selectedDate = null;
                                        _selectedRadioOption = null;
                                        repository.queries.updateCollectionDate(
                                            _selectedDate,
                                            _customerData.customerId);
                                        BlocProvider.of<ContactsCubit>(context)
                                            .getContacts(
                                                Provider.of<BusinessProvider>(
                                                        context,
                                                        listen: false)
                                                    .selectedBusiness
                                                    .businessId);
                                        Navigator.of(context).pop();
                                      },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static String duration(DateTime updatedTime) {
    return DateTime.now().difference(updatedTime).inDays.toString() +
        ' Days Ago';
  }

  int? getRadioOptionSelectedOnDate(DateTime? date) {
    if (date == null && _selectedDate == null) {
      return null;
    }
    if (date.toString().substring(0, 10) ==
        (DateTime.now()).add(Duration(days: 7)).toString().substring(0, 10)) {
      return 0;
    } else if (date.toString().substring(0, 10) ==
        Jiffy(DateTime.now()).add(months: 1).toString().substring(0, 10)) {
      return 1;
    }
    return 2;
  }

  Widget chatScreen() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      controller: _contactController.scrollController,
                      padding: EdgeInsets.only(bottom: 5),
                      reverse: true,
                      itemCount:
                          _contactController.selectedChat?.messages.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        // print(
                        //     'message count ${_contactController.selectedChat?.messages.length.toString()}');
                        return _contactController.selectedChat?.messages[index]
                                    .messageType ==
                                0
                            ? Padding(
                                padding: EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                  top: 5,
                                  bottom: 0,
                                ),
                                child: renderMessage(
                                    context,
                                    _contactController
                                        .selectedChat!.messages[index],
                                    index),
                              )
                            : _contactController.selectedChat?.messages[index]
                                        .messageType ==
                                    1
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                      top: 5,
                                      bottom: 0,
                                    ),
                                    child: renderPayTransaction(
                                        context,
                                        _contactController
                                            .selectedChat!.messages[index],
                                        index),
                                  )
                                : _contactController.selectedChat
                                            ?.messages[index].messageType ==
                                        2
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 5,
                                          bottom: 0,
                                        ),
                                        child: renderRequestTransaction(
                                            context,
                                            _contactController
                                                .selectedChat!.messages[index],
                                            index),
                                      )
                                    : _contactController.selectedChat
                                                ?.messages[index].messageType ==
                                            3
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 5,
                                              bottom: 0,
                                            ),
                                            child: renderReminderTransaction(
                                                context,
                                                _contactController.selectedChat!
                                                    .messages[index],
                                                index),
                                          )
                                        : _contactController
                                                    .selectedChat
                                                    ?.messages[index]
                                                    .messageType ==
                                                4
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                  top: 5,
                                                  bottom: 0,
                                                ),
                                                child: renderContact(
                                                    context,
                                                    _contactController
                                                        .selectedChat!
                                                        .messages[index],
                                                    index),
                                              )
                                            : _contactController
                                                        .selectedChat
                                                        ?.messages[index]
                                                        .messageType ==
                                                    5
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      top: 5,
                                                      bottom: 0,
                                                    ),
                                                    child: renderRequest(
                                                        context,
                                                        _contactController
                                                            .selectedChat!
                                                            .messages[index],
                                                        index),
                                                  )
                                                : _contactController
                                                            .selectedChat
                                                            ?.messages[index]
                                                            .messageType ==
                                                        6
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 15,
                                                          right: 15,
                                                          top: 5,
                                                          bottom: 0,
                                                        ),
                                                        child: renderAttachment(
                                                            context,
                                                            _contactController
                                                                .selectedChat!
                                                                .messages[index],
                                                            index),
                                                      )
                                                    : _contactController
                                                                .selectedChat
                                                                ?.messages[
                                                                    index]
                                                                .messageType ==
                                                            7
                                                        ? Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              left: 15,
                                                              right: 15,
                                                              top: 5,
                                                              bottom: 0,
                                                            ),
                                                            child: renderDocument(
                                                                context,
                                                                _contactController
                                                                    .selectedChat!
                                                                    .messages[index],
                                                                index),
                                                          )
                                                        : _contactController
                                                                    .selectedChat
                                                                    ?.messages[index]
                                                                    .messageType ==
                                                                8
                                                            ? Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  left: 15,
                                                                  right: 15,
                                                                  top: 5,
                                                                  bottom: 0,
                                                                ),
                                                                child: renderDocFile(
                                                                    context,
                                                                    _contactController
                                                                        .selectedChat!
                                                                        .messages[index],
                                                                    index),
                                                              )
                                                            : _contactController.selectedChat?.messages[index].messageType == 10
                                                                ? Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      left: 15,
                                                                      right: 15,
                                                                      top: 5,
                                                                      bottom: 0,
                                                                    ),
                                                                    child: renderAudio(
                                                                        context,
                                                                        _contactController
                                                                            .selectedChat!
                                                                            .messages[index],
                                                                        index),
                                                                    // child: Audio(controllerData: _contactController
                                                                    //         .selectedChat!
                                                                    //         .messages![index],
                                                                    //         index: index,
                                                                    //     customerModel: _customerData,
                                                                    //     myUser: _contactController.myUser,
                                                                    // ),
                                                                  )
                                                                : _contactController.selectedChat?.messages[index].messageType == 11
                                                                    ? Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          left:
                                                                              15,
                                                                          right:
                                                                              15,
                                                                          top:
                                                                              5,
                                                                          bottom:
                                                                              0,
                                                                        ),
                                                                        child: renderEditTransaction(
                                                                            context,
                                                                            _contactController.selectedChat!.messages[index],
                                                                            index),
                                                                      )
                                                                    : _contactController.selectedChat?.messages[index].messageType == 12
                                                                        ? Padding(
                                                                            padding:
                                                                                EdgeInsets.only(
                                                                              left: 15,
                                                                              right: 15,
                                                                              top: 5,
                                                                              bottom: 0,
                                                                            ),
                                                                            child: renderEditRequestTransaction(
                                                                                context,
                                                                                _contactController.selectedChat!.messages[index],
                                                                                index),
                                                                          )
                                                                        : _contactController.selectedChat?.messages[index].messageType == 13
                                                                            ? Padding(
                                                                                padding: EdgeInsets.only(
                                                                                  left: 15,
                                                                                  right: 15,
                                                                                  top: 5,
                                                                                  bottom: 0,
                                                                                ),
                                                                                child: renderSuspensePay(context, _contactController.selectedChat!.messages[index], index),
                                                                              )
                                                                            : Container();
                      },
                    ),
                  ),
                ),
                _audio == true ? renderAudioadd() : Container(),
                _document == true ? renderDocumentAdd() : Container(),
                _gallery == true
                    ? renderAttachmentAdd()
                    : _camera == true
                        ? renderAttachmentAdd()
                        : Container(),
                TextFieldWithButton(
                  customerId: _customerData.customerId,
                  chatId: _customerData.chatId,
                  customerName: _customerData.name,
                  phoneNo: _customerData.mobileNo,
                  onSubmit: () => _contactController.sendMessage(
                      _customerData.customerId,
                      _customerData.chatId,
                      _customerData.name,
                      _customerData.mobileNo!,
                      null,
                      null,
                      null,
                      null,
                      null,
                      null,
                      null,
                      0,
                      null),
                  textEditingController: _contactController.textController,
                  onEmojiTap: (bool showEmojiKeyboard) {
                    _contactController.showEmojiKeyboard = !showEmojiKeyboard;
                  },
                  showEmojiKeyboard: _contactController.showEmojiKeyboard,
                  context: context,
                  sendMessage: (amount, details, paymentType) {
                    _contactController.sendMessage(
                        _customerData.customerId,
                        _customerData.chatId,
                        _customerData.name,
                        _customerData.mobileNo!,
                        amount,
                        details,
                        null,
                        null,
                        null,
                        null,
                        null,
                        paymentType,
                        null);
                  },
                  audioImm: () {
                    setState(() {
                      _audio = !_audio;
                    });
                    debugPrint('yes $_audio');
                  },
                  galleryAttachment: (data, url) {
                    setState(() {
                      _gallery = data;
                      _url = url;
                    });
                    debugPrint('yes $data');
                  },
                  documentAttachment: (data) {
                    setState(() {
                      _document = data;
                    });
                    debugPrint('yes $data');
                  },
                  cameraAttachmentFn: (data, url) {
                    debugPrint('yes $data');
                    debugPrint('yes $url');
                    setState(() {
                      _camera = data;
                      _url = url;
                    });
                  },
                  sendContact: (contactName, contactNo, messageType) {
                    _contactController.sendMessage(
                        _customerData.customerId,
                        _customerData.chatId,
                        _customerData.name,
                        _customerData.mobileNo!,
                        null,
                        null,
                        null,
                        contactName,
                        contactNo,
                        null,
                        null,
                        messageType,
                        null);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // });
  }

  Widget renderMessage(BuildContext context, Message message, int index) {
    // debugPrint('message : ' + message.message!.messages.toString());
    if (_contactController.myUser == null) return Container();
    return Column(
      children: <Widget>[
        renderMessageSendAtDay(message, index),
        Material(
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: message.from == _contactController.myUser!.id
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // renderMessageSendAt(message, MessagePosition.BEFORE),
              if (message.from == _contactController.myUser!.id)
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    message.unreadByMe == true
                        ? Icons.done_all_outlined
                        : Icons.done,
                    size: 18,
                    // color: AppTheme.electricBlue,
                    color: message.unreadByMe == true
                        ? AppTheme.electricBlue
                        : AppTheme.brownishGrey,
                  ),
                ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75),
                decoration: message.from == _contactController.myUser!.id
                    ? BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        color: (AppTheme.senderColor),
                      )
                    : BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                        color: (AppTheme.receiverColor),
                      ),
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    // child: Text(
                    //   // message.message?.messages ?? '',
                    //   // message.msg ?? '',
                    //   message.msg ?? message.message?.messages ?? '',

                    //   style: TextStyle(
                    //     color: message.from == _contactController.myUser.id
                    //         ? Colors.black
                    //         : Colors.white,
                    //     fontSize: 14.5,
                    //   ),
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 40, top: 5),
                          child: Text(
                            message.msg ?? message.message?.messages ?? '',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.5,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Text(
                            '${messageDate(message.sendAt!)}',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: AppTheme.brownishGrey, fontSize: 8),
                          ),
                        ),
                      ],
                    )

                    // RichText(
                    //   text: TextSpan(
                    //     text: message.msg ?? message.message?.messages ?? '',
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 14.5,
                    //     ),
                    //     children: [
                    //       TextSpan(
                    //         text: '      ${messageDate(message.sendAt!)}',
                    //         style: TextStyle(
                    //             color: AppTheme.brownishGrey, fontSize: 8),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    ),
              ),
              // Container(
              //   constraints: BoxConstraints(
              //       maxWidth: MediaQuery.of(context).size.width * 0.12),
              //   decoration: BoxDecoration(
              //           borderRadius: BorderRadius.only(
              //             topLeft: Radius.circular(0),
              //             bottomLeft: Radius.circular(0),
              //           ),
              //           color: (AppTheme.senderColor),
              //         ),

              //   child: Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.5),
              //     child: renderMessageSendAt(message, MessagePosition.AFTER),
              //   ),
              // ),

              // renderMessageSendAt(message, MessagePosition.AFTER),
            ],
          ),
        ),
      ],
    );
  }

  Widget renderPayTransaction(
      BuildContext context, Message message, int index) {
    if (_contactController.myUser == null) return Container();
    return Column(
      children: <Widget>[
        renderMessageSendAtDay(message, index),
        Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: message.from == _contactController.myUser!.id
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (message.from == _contactController.myUser!.id)
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    message.unreadByMe == true
                        ? Icons.done_all_outlined
                        : Icons.done,
                    size: 18,
                    // color: AppTheme.electricBlue,
                    color: message.unreadByMe == true
                        ? AppTheme.electricBlue
                        : AppTheme.brownishGrey,
                  ),
                ),
              GestureDetector(
                onTap: () async {
                  if (message.paymentStatus == 0 ||
                      message.paymentStatus == 1) {
                    CustomLoadingDialog.showLoadingDialog(context, key);
                    Map<String?, dynamic>? response = await _chatRepository
                        .getTransactionDetails(message.transactionId)
                        .timeout(Duration(seconds: 30), onTimeout: () async {
                      Navigator.of(context).pop();
                      return Future.value(null);
                    });
                    debugPrint(message.paymentStatus.toString());
                    debugPrint(response.toString());
                    // double amount = double.parse((response)['amount']);
                    if ((response)?['urbanledgerId'] != null &&
                        (response)?['transactionId'] != null &&
                        (response)?['to'] != null &&
                        (response)?['toEmail'] != null &&
                        (response)?['from'] != null &&
                        (response)?['fromEmail'] != null &&
                        (response)?['completed'] != null &&
                        (response)?['paymentMethod'] != null &&
                        (response)?['amount'] != null)
                      Navigator.of(context).popAndPushNamed(
                          AppRoutes.paymentDetailsRoute,
                          arguments: TransactionDetailsArgs(
                              urbanledgerId: (response)?['urbanledgerId'],
                              transactionId: (response)?['transactionId'],
                              to: (response)?['to'],
                              toEmail: (response)?['toEmail'],
                              from: (response)?['from'],
                              fromEmail: (response)?['fromEmail'],
                              completed: (response)?['completed'],
                              paymentMethod: (response)?['paymentMethod'],
                              amount: (response)?['amount'].toString(),
                              cardImage: (response)?['cardImage']
                                  .toString()
                                  .replaceAll(' ', ''),
                              endingWith: (response)?['endingWith'],
                              customerName: _customerData.name,
                              mobileNo: _customerData.mobileNo,
                              paymentStatus: message.paymentStatus.toString()));
                  }
                },
                child: Container(
                  // constraints: BoxConstraints(
                  //   maxWidth: MediaQuery.of(context).size.width * 0.45,
                  //   minWidth: MediaQuery.of(context).size.width * 0.35,
                  // ),
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: message.from == _contactController.myUser!.id
                      ? BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: Color.fromRGBO(162, 164, 176, 0.3)),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Colors.white,
                        )
                      : BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: Color.fromRGBO(162, 164, 176, 0.3)),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 15, 7, 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          overflow: TextOverflow.fade,
                          text: TextSpan(
                              text: '$currencyAED  ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: message.from ==
                                        _contactController.myUser!.id
                                    ? AppTheme.tomato
                                    : AppTheme.greenColor,
                              ),
                              children: [
                                TextSpan(
                                    text:
                                        (message.amount)!.getFormattedCurrency,
                                    style: TextStyle(
                                        fontSize: 26,
                                        color: message.from ==
                                                _contactController.myUser!.id
                                            ? AppTheme.tomato
                                            : AppTheme.greenColor,
                                        fontWeight: FontWeight.bold)),
                              ]),
                        ),
                        // Text(
                        //   // message.message?.messages ?? '',
                        //   'AED ${removeDecimalif0(message.amount)}',
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w600,
                        //     fontSize: 26,
                        //     color: message.from == _contactController.myUser!.id
                        //         ? AppTheme.tomato
                        //         : AppTheme.greenColor,
                        //   ),
                        // ),
                        SizedBox(
                          height: 5,
                        ),
                        if (message.details.toString().isNotEmpty &&
                            (message.transactionId == null ||
                                message.transactionId!.isEmpty))
                          Text(
                            // message.message?.messages ?? '',
                            '${message.details ?? ''}',
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        if (message.details.toString().isNotEmpty)
                          SizedBox(
                            height: 5,
                          ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              message.paymentStatus == null
                                  ? Text(
                                      message.from ==
                                              _contactController.myUser?.id
                                          ? 'You Paid - '
                                          : 'You Received - ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.brownishGrey,
                                      ),
                                    )
                                  : Text(
                                      message.paymentStatus == 1 &&
                                              message.from ==
                                                  _contactController.myUser?.id
                                          ? 'You Paid - '
                                          : message.paymentStatus == 1 &&
                                                  message.from !=
                                                      _contactController
                                                          .myUser?.id
                                              ? 'You Received - '
                                              : 'Failed - ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.brownishGrey,
                                      ),
                                    ),
                              Text(
                                paymentDate(message.sendAt!),
                                style: TextStyle(
                                    color: AppTheme.brownishGrey, fontSize: 10),
                              ),
                              Expanded(
                                  child: Image.asset(
                                message.paymentStatus == 0
                                    ? AppAssets.transactionFailed
                                    : AppAssets.transactionSuccess,
                                height: 15,
                              )),
                              if (message.transactionId != null)
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: AppTheme.electricBlue,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              messageDate(message.sendAt!),
                              style: TextStyle(
                                  color: AppTheme.brownishGrey, fontSize: 8),
                            ),
                            SizedBox(width: 7),
                          ],
                        ),
                        SizedBox(height: 7),
                      ],
                    ),
                  ),
                ),
              ),
              // renderMessageSendAt(message, MessagePosition.AFTER),
            ],
          ),
        ),
        // if (message.from == _contactController.myUser!.id)
        // Padding(
        //   padding: EdgeInsets.only(bottom: 5, top: 5),
        //   child: Align(
        //       alignment: Alignment.bottomRight,
        //       child: RichText(
        //         text: TextSpan(
        //           style: Theme.of(context).textTheme.bodyText2,
        //           children: [
        //             TextSpan(
        //               text: 'You earned a reward',
        //               style: TextStyle(
        //                 fontSize: 12,
        //                 color: AppTheme.brownishGrey,
        //               ),
        //             ),
        //             WidgetSpan(
        //               child: Padding(
        //                 padding: EdgeInsets.symmetric(horizontal: 10.0),
        //                 // child: Icon(
        //                 //   Icons.card_giftcard_outlined,
        //                 //   size: 12,
        //                 //   color: AppTheme.electricBlue,
        //                 // ),
        //                 child: Image.asset(
        //                   'assets/icons/Gift-01.png',
        //                   height: 12,
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       )),
        // ),
      ],
    );
  }

  Widget renderSuspensePay(BuildContext context, Message message, int index) {
    if (_contactController.myUser == null) return Container();
    return Column(
      children: <Widget>[
        renderMessageSendAtDay(message, index),
        Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: message.from != _contactController.myUser!.id
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (message.from != _contactController.myUser!.id)
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    message.unreadByMe == true
                        ? Icons.done_all_outlined
                        : Icons.done,
                    size: 18,
                    // color: AppTheme.electricBlue,
                    color: message.unreadByMe == true
                        ? AppTheme.electricBlue
                        : AppTheme.brownishGrey,
                  ),
                ),
              GestureDetector(
                onTap: () async {
                  if (message.paymentStatus == 0 ||
                      message.paymentStatus == 1) {
                    CustomLoadingDialog.showLoadingDialog(context, key);
                    Map<String?, dynamic>? response = await _chatRepository
                        .getTransactionDetails(message.transactionId)
                        .timeout(Duration(seconds: 30), onTimeout: () async {
                      Navigator.of(context).pop();
                      return Future.value(null);
                    });
                    debugPrint(message.paymentStatus.toString());
                    debugPrint(response.toString());
                    // double amount = double.parse((response)['amount']);
                    if ((response)?['urbanledgerId'] != null &&
                        (response)?['transactionId'] != null &&
                        (response)?['to'] != null &&
                        (response)?['toEmail'] != null &&
                        (response)?['from'] != null &&
                        (response)?['fromEmail'] != null &&
                        (response)?['completed'] != null &&
                        (response)?['paymentMethod'] != null &&
                        (response)?['amount'] != null)
                      Navigator.of(context).popAndPushNamed(
                          AppRoutes.paymentDetailsRoute,
                          arguments: TransactionDetailsArgs(
                              urbanledgerId: (response)?['urbanledgerId'],
                              transactionId: (response)?['transactionId'],
                              to: (response)?['to'],
                              toEmail: (response)?['toEmail'],
                              from: (response)?['from'],
                              fromEmail: (response)?['fromEmail'],
                              completed: (response)?['completed'],
                              paymentMethod: (response)?['paymentMethod'],
                              amount: (response)?['amount'].toString(),
                              cardImage: (response)?['cardImage']
                                  .toString()
                                  .replaceAll(' ', ''),
                              endingWith: (response)?['endingWith'],
                              customerName: _customerData.name,
                              mobileNo: _customerData.mobileNo,
                              paymentStatus: message.paymentStatus.toString()));
                  }
                },
                child: Container(
                  // constraints: BoxConstraints(
                  //   maxWidth: MediaQuery.of(context).size.width * 0.45,
                  //   minWidth: MediaQuery.of(context).size.width * 0.35,
                  // ),
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: message.from != _contactController.myUser!.id
                      ? BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: Color.fromRGBO(162, 164, 176, 0.3)),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Colors.white,
                        )
                      : BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: Color.fromRGBO(162, 164, 176, 0.3)),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 15, 7, 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          overflow: TextOverflow.fade,
                          text: TextSpan(
                              text: '$currencyAED  ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: message.from !=
                                        _contactController.myUser!.id
                                    ? AppTheme.tomato
                                    : AppTheme.greenColor,
                              ),
                              children: [
                                TextSpan(
                                    text:
                                        (message.amount)!.getFormattedCurrency,
                                    style: TextStyle(
                                        fontSize: 26,
                                        color: message.from !=
                                                _contactController.myUser!.id
                                            ? AppTheme.tomato
                                            : AppTheme.greenColor,
                                        fontWeight: FontWeight.bold)),
                              ]),
                        ),
                        // Text(
                        //   // message.message?.messages ?? '',
                        //   'AED ${removeDecimalif0(message.amount)}',
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w600,
                        //     fontSize: 26,
                        //     color: message.from == _contactController.myUser!.id
                        //         ? AppTheme.tomato
                        //         : AppTheme.greenColor,
                        //   ),
                        // ),
                        SizedBox(
                          height: 5,
                        ),
                        if (message.details.toString().isNotEmpty &&
                            (message.transactionId == null ||
                                message.transactionId!.isEmpty))
                          Text(
                            // message.message?.messages ?? '',
                            '${message.details ?? ''}',
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        if (message.details.toString().isNotEmpty)
                          SizedBox(
                            height: 5,
                          ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              message.paymentStatus == null
                                  ? Text(
                                      message.from ==
                                              _contactController.myUser?.id
                                          ? 'You Paid - '
                                          : 'You Received - ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.brownishGrey,
                                      ),
                                    )
                                  : Text(
                                      message.from !=
                                              _contactController.myUser?.id
                                          ? 'You Paid - '
                                          : 'You Received - ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.brownishGrey,
                                      ),
                                    ),
                              Text(
                                paymentDate(message.sendAt!),
                                style: TextStyle(
                                    color: AppTheme.brownishGrey, fontSize: 10),
                              ),
                              Expanded(
                                  child: Image.asset(
                                message.paymentStatus == 0
                                    ? AppAssets.transactionFailed
                                    : AppAssets.transactionSuccess,
                                height: 15,
                              )),
                              if (message.transactionId != null)
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: AppTheme.electricBlue,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              messageDate(message.sendAt!),
                              style: TextStyle(
                                  color: AppTheme.brownishGrey, fontSize: 8),
                            ),
                            SizedBox(width: 7),
                          ],
                        ),
                        SizedBox(height: 7),
                      ],
                    ),
                  ),
                ),
              ),
              // renderMessageSendAt(message, MessagePosition.AFTER),
            ],
          ),
        ),
      ],
    );
  }

  Widget renderEditTransaction(
      BuildContext context, Message message, int index) {
    if (_contactController.myUser == null) return Container();
    return Column(
      children: <Widget>[
        renderMessageSendAtDay(message, index),
        Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: message.from == _contactController.myUser!.id
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (message.from == _contactController.myUser!.id)
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    message.unreadByMe == true
                        ? Icons.done_all_outlined
                        : Icons.done,
                    size: 18,
                    // color: AppTheme.electricBlue,
                    color: message.unreadByMe == true
                        ? AppTheme.electricBlue
                        : AppTheme.brownishGrey,
                  ),
                ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: message.from == _contactController.myUser!.id
                    ? BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: Color.fromRGBO(162, 164, 176, 0.3)),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Colors.white,
                      )
                    : BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: Color.fromRGBO(162, 164, 176, 0.3)),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Colors.white,
                      ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 7, 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   // message.message?.messages ?? '',
                      //   'AED ${removeDecimalif0(message.amount)}',
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 20,
                      //       color: AppTheme.coolGrey),
                      // ),
                      RichText(
                        overflow: TextOverflow.fade,
                        text: TextSpan(
                            text: '$currencyAED  ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.coolGrey,
                            ),
                            children: [
                              TextSpan(
                                  text: (message.amount)!.getFormattedCurrency,
                                  style: TextStyle(
                                      fontSize: 26,
                                      color: AppTheme.coolGrey,
                                      fontWeight: FontWeight.bold)),
                            ]),
                      ),
                      if (message.details.toString().isNotEmpty)
                        SizedBox(
                          height: 5,
                        ),
                      if (message.details.toString().isNotEmpty)
                        Text(
                          // message.message?.messages ?? '',
                          '${message.details}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      if (message.details.toString().isNotEmpty)
                        SizedBox(
                          height: 5,
                        ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              message.from == _contactController.myUser!.id
                                  ? 'You paid - '
                                  : 'You received - ',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.coolGrey,
                              ),
                            ),
                            Text(
                              paymentDate(message.sendAt!),
                              style: TextStyle(
                                  color: AppTheme.coolGrey, fontSize: 10),
                            ),
                            Expanded(
                              child: Icon(Icons.check_circle_outline_outlined,
                                  size: 14, color: AppTheme.coolGrey),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            messageDate(message.sendAt!),
                            style: TextStyle(
                                color: AppTheme.brownishGrey, fontSize: 8),
                          ),
                          SizedBox(width: 7),
                        ],
                      ),
                      SizedBox(height: 7),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (message.from == _contactController.myUser!.id)
          Padding(
            padding: EdgeInsets.only(bottom: 5, top: 5, right: 5),
            child: Align(
                alignment: Alignment.bottomRight,
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText2,
                    children: [
                      TextSpan(
                        text: 'Edited',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.brownishGrey,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
      ],
    );
  }

  Widget renderRequestTransaction(
      BuildContext context, Message message, int index) {
    if (_contactController.myUser == null) return Container();
    return Column(
      children: <Widget>[
        renderMessageSendAtDay(message, index),
        Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: message.from == _contactController.myUser!.id
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // renderMessageSendAt(message, MessagePosition.BEFORE),
              Container(
                // constraints: BoxConstraints(
                //   maxWidth: MediaQuery.of(context).size.width * 0.45,
                //   minWidth: MediaQuery.of(context).size.width * 0.35,
                // ),
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Color.fromRGBO(162, 164, 176, 0.3)),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 7, 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   // message.message?.messages ?? '',
                      //   'AED ${removeDecimalif0(message.amount)}',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 20,
                      //     color: AppTheme.greenColor,
                      //   ),
                      // ),
                      RichText(
                        overflow: TextOverflow.fade,
                        text: TextSpan(
                            text: '$currencyAED  ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  message.from == _contactController.myUser!.id
                                      ? AppTheme.greenColor
                                      : AppTheme.tomato,
                            ),
                            children: [
                              TextSpan(
                                  text: (message.amount)!.getFormattedCurrency,
                                  style: TextStyle(
                                      fontSize: 26,
                                      color: message.from ==
                                              _contactController.myUser!.id
                                          ? AppTheme.greenColor
                                          : AppTheme.tomato,
                                      fontWeight: FontWeight.bold)),
                            ]),
                      ),
                      if (message.details.toString().isNotEmpty)
                        SizedBox(
                          height: 5,
                        ),
                      if (message.details.toString().isNotEmpty)
                        Text(
                          // message.message?.messages ?? '',
                          '${message.details}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              message.from == _contactController.myUser!.id
                                  ? 'You Received - '
                                  : 'You Paid - ',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.brownishGrey,
                              ),
                            ),
                            Text(
                              paymentDate(message.sendAt!),
                              style: TextStyle(
                                  color: AppTheme.brownishGrey, fontSize: 10),
                            ),
                            Expanded(
                                child: Image.asset(
                              AppAssets.transactionSuccess,
                              height: 15,
                            )),
                            // Align(
                            //   alignment: Alignment.bottomRight,
                            //   child: Icon(Icons.arrow_forward_ios,
                            //       size: 12,
                            //       color: AppTheme.electricBlue),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            messageDate(message.sendAt!),
                            style: TextStyle(
                                color: AppTheme.brownishGrey, fontSize: 8),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              // renderMessageSendAt(message, MessagePosition.AFTER),
            ],
          ),
        ),
      ],
    );
  }

  Widget renderEditRequestTransaction(
      BuildContext context, Message message, int index) {
    if (_contactController.myUser == null) return Container();
    return Column(
      children: <Widget>[
        renderMessageSendAtDay(message, index),
        Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // renderMessageSendAt(message, MessagePosition.BEFORE),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: message.from == _contactController.myUser!.id
                    ? BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: Color.fromRGBO(162, 164, 176, 0.3)),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Colors.white,
                      )
                    : BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: Color.fromRGBO(162, 164, 176, 0.3)),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Colors.white,
                      ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 7, 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        overflow: TextOverflow.fade,
                        text: TextSpan(
                            text: '$currencyAED  ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.coolGrey,
                            ),
                            children: [
                              TextSpan(
                                  text: (message.amount)!.getFormattedCurrency,
                                  style: TextStyle(
                                      fontSize: 26,
                                      color: AppTheme.coolGrey,
                                      fontWeight: FontWeight.bold)),
                            ]),
                      ),
                      if (message.details.toString().isNotEmpty)
                        SizedBox(
                          height: 5,
                        ),
                      if (message.details.toString().isNotEmpty)
                        Text(
                          // message.message?.messages ?? '',
                          '${message.details}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'You received - ',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.coolGrey,
                              ),
                            ),
                            Text(
                              paymentDate(message.sendAt!),
                              style: TextStyle(
                                  color: AppTheme.coolGrey, fontSize: 10),
                            ),
                            Expanded(
                              child: Icon(Icons.check_circle_outline_outlined,
                                  size: 14, color: AppTheme.coolGrey),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            messageDate(message.sendAt!),
                            style: TextStyle(
                                color: AppTheme.brownishGrey, fontSize: 8),
                          ),
                          SizedBox(width: 7),
                        ],
                      ),
                      SizedBox(height: 7),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (message.from == _contactController.myUser!.id)
          Padding(
            padding: EdgeInsets.only(bottom: 5, top: 5, left: 5),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText2,
                    children: [
                      TextSpan(
                        text: 'Edited',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.brownishGrey,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
      ],
    );
  }

  Widget renderReminderTransaction(
      BuildContext context, Message message, int index) {
    if (_contactController.myUser == null) return Container();
    return Column(
      children: <Widget>[
        renderMessageSendAtDay(message, index),
        Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: message.from == _contactController.myUser!.id
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // renderMessageSendAt(message, MessagePosition.BEFORE),
              if (message.from == _contactController.myUser!.id)
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    message.unreadByMe == true
                        ? Icons.done_all_outlined
                        : Icons.done,
                    size: 18,
                    // color: AppTheme.electricBlue,
                    color: message.unreadByMe == true
                        ? AppTheme.electricBlue
                        : AppTheme.brownishGrey,
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.2, color: AppTheme.coolGrey),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width * 0.60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.20,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AppAssets.bg12Image),
                            fit: BoxFit.cover),
                        border:
                            Border.all(width: 0.2, color: AppTheme.coolGrey),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          // bottomLeft: Radius.circular(10),
                          // bottomRight: Radius.circular(10),
                        ),
                        // color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: '\nPayment Request of\n',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white60,
                                  fontSize: (12),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'AED ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: (18),
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' ${removeDecimalif0(message.amount).replaceAll('-', '')}\n',
                                    style: TextStyle(
                                      // fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: (25),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'On ' +
                                        DateFormat('dd MMM yyyy').format(
                                            DateTime.parse(message.dateTime!)),
                                    style: TextStyle(
                                      // fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: (12),
                                    ),
                                  ),
                                  // TextSpan(
                                  //   text:'\n\nRequested by ${repository.hiveQueries.userData.firstName} ${repository.hiveQueries.userData.lastName}\n${repository.hiveQueries.userData.firstName} | ${repository.hiveQueries.userData.mobileNo}',
                                  //   style: TextStyle(
                                  //     // fontWeight: FontWeight.w500,
                                  //     color: AppTheme.brownishGrey,
                                  //     fontSize: (12),
                                  //   ),
                                  // ),
                                ]),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          message.from == _contactController.myUser!.id
                              ? Text(
                                  'Reminder by ${repository.hiveQueries.userData.firstName} ${repository.hiveQueries.userData.lastName}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )
                              : Text(
                                  'Reminder by ${_customerData.name}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                          SizedBox(
                            height: 5,
                          ),
                          message.from == _contactController.myUser!.id
                              ? Text(
                                  '${repository.hiveQueries.userData.firstName} | ${repository.hiveQueries.userData.mobileNo}',
                                  style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )
                              : Text(
                                  '${_customerData.name} | ${_customerData.mobileNo}',
                                  style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          // Text('Click on the link below to make payment',style: TextStyle(
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 13),),
                          Icon(
                            Icons.arrow_drop_down,
                            color: AppTheme.brownishGrey,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 20, right: 20),
                      color: Colors.white,
                      child: RichText(
                        text: TextSpan(
                            text:
                                'Dear Sir/Madam, Your payment of $currencyAED ${removeDecimalif0(message.amount).replaceAll('-', '')} is pending at ',
                            style: TextStyle(
                                color: AppTheme.brownishGrey, fontSize: 10),
                            children: [
                              TextSpan(
                                text: message.from ==
                                        _contactController.myUser!.id
                                    ? '${repository.hiveQueries.userData.firstName} ${repository.hiveQueries.userData.lastName} (${repository.hiveQueries.userData.mobileNo})'
                                    : '${_customerData.name} (${_customerData.mobileNo})',
                                style: TextStyle(
                                    color: AppTheme.brownishGrey, fontSize: 10),
                              )
                            ]),
                      ),
                      // child:Text('Dear Sir/Madam, Your payment of $currencyAED ${removeDecimalif0(message.amount).replaceAll('-', '')} is pending at')
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, bottom: 10, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // renderMessageSendAt(message, MessagePosition.AFTER),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (message.from !=
                                      _contactController.myUser!.id &&
                                  message.paymentCancel == true)
                                GestureDetector(
                                  // onTap: (status == false)
                                  //     ? () {
                                  //         modalSheet();
                                  //       }
                                  //     : () async {
                                  //         Navigator.of(context).popAndPushNamed(
                                  //           AppRoutes.payTransactionRoute,
                                  //           arguments: QRDataArgs(
                                  //               customerModel:
                                  //                   _customerData,
                                  //               customerId: localCustomerId,
                                  //               amount: message.amount
                                  //                   .toString()
                                  //                   .replaceAll(
                                  //                       RegExp(
                                  //                           r"([.]*0)(?!.*\d)"),
                                  //                       ""),
                                  //               requestId: message.requestId),
                                  //         );
                                  //       },
                                  onTap: () async {
                                    CustomLoadingDialog.showLoadingDialog(
                                        context, key);
                                    var cid = await repository.customerApi
                                        .getCustomerID(
                                            mobileNumber: widget
                                                .customerModel.mobileNo
                                                .toString())
                                        .timeout(Duration(seconds: 30),
                                            onTimeout: () async {
                                      Navigator.of(context).pop();
                                      return Future.value(null);
                                    });
                                    bool? merchantSubscriptionPlan = cid
                                            .customerInfo
                                            ?.merchantSubscriptionPlan ??
                                        false;
                                    debugPrint(
                                        _customerData.mobileNo.toString());
                                    debugPrint(_customerData.name);
                                    debugPrint(_customerData.chatId);
                                    debugPrint(cid.customerInfo?.id.toString());
                                    CustomerModel _customerModel =
                                        CustomerModel();
                                    _customerModel
                                      ..name = getName(_customerData.name,
                                          _customerData.mobileNo)
                                      ..mobileNo = _customerData.mobileNo
                                      ..ulId = cid.customerInfo?.id.toString()
                                      ..avatar = _customerData.avatar
                                      ..chatId = _customerData.chatId;
                                    final localCustId = await repository.queries
                                        .getCustomerId(_customerData.mobileNo!)
                                        .timeout(Duration(seconds: 30),
                                            onTimeout: () async {
                                      Navigator.of(context).pop();
                                      return Future.value(null);
                                    });
                                    final uniqueId = Uuid().v1();
                                    if (localCustId.isEmpty) {
                                      final customer = CustomerModel()
                                        ..name = getName(
                                            _customerData.name!.trim(),
                                            _customerData.mobileNo!)
                                        ..mobileNo = (_customerData.mobileNo!)
                                        ..avatar = _customerData.avatar
                                        ..customerId = uniqueId
                                        ..businessId =
                                            Provider.of<BusinessProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedBusiness
                                                .businessId
                                        ..chatId = _customerData.chatId
                                        ..isChanged = true;
                                      await repository.queries
                                          .insertCustomer(customer)
                                          .timeout(Duration(seconds: 30),
                                              onTimeout: () async {
                                        Navigator.of(context).pop();
                                        return Future.value(null);
                                      });
                                      if (await checkConnectivity) {
                                        final apiResponse = await (repository
                                            .customerApi
                                            .saveCustomer(customer, context,
                                                AddCustomers.ADD_NEW_CUSTOMER)
                                            .timeout(Duration(seconds: 30),
                                                onTimeout: () async {
                                          Navigator.of(context).pop();
                                          return Future.value(null);
                                        }).catchError((e) {
                                          recordError(e, StackTrace.current);
                                          return false;
                                        }));
                                        // if (apiResponse.isNotEmpty) {
                                        //   ///update chat id here
                                        //   await repository.queries
                                        //       .updateCustomerIsChanged(0, customer.customerId, apiResponse);
                                        // }
                                        if (apiResponse) {
                                          ///update chat id here
                                          final Messages msg = Messages(
                                              messages: '', messageType: 100);
                                          var jsondata = jsonEncode(msg);
                                          final response = await _chatRepository
                                              .sendMessage(
                                                  _customerModel.mobileNo
                                                      .toString(),
                                                  _customerModel.name,
                                                  jsondata,
                                                  localCustId.isEmpty
                                                      ? uniqueId
                                                      : localCustId,
                                                  Provider.of<BusinessProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedBusiness
                                                      .businessId)
                                              .timeout(Duration(seconds: 30),
                                                  onTimeout: () async {
                                            Navigator.of(context).pop();
                                            return Future.value(null);
                                          });
                                          final messageResponse =
                                              Map<String, dynamic>.from(
                                                  jsonDecode(response.body));
                                          Message _message = Message.fromJson(
                                              messageResponse['message']);
                                          if (_message.chatId
                                              .toString()
                                              .isNotEmpty) {
                                            await repository.queries
                                                .updateCustomerIsChanged(
                                                    0,
                                                    _customerModel.customerId!,
                                                    _message.chatId)
                                                .timeout(Duration(seconds: 30),
                                                    onTimeout: () async {
                                              Navigator.of(context).pop();
                                              return Future.value(null);
                                            });
                                          }
                                        }
                                      } else {
                                        Navigator.of(context).pop();
                                        'Please check your internet connection or try again later.'
                                            .showSnackBar(context);
                                      }
                                      BlocProvider.of<ContactsCubit>(context)
                                          .getContacts(
                                              Provider.of<BusinessProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedBusiness
                                                  .businessId);
                                    }
                                    setState(() {
                                      debugPrint('Check' +
                                          _customerModel.customerId.toString());
                                    });
                                    if (cid.customerInfo?.id == null) {
                                      Navigator.of(context).pop(true);
                                      MerchantBankNotAdded
                                          .showBankNotAddedDialog(
                                              context, 'userNotRegistered');
                                    } else if (cid
                                            .customerInfo?.bankAccountStatus ==
                                        false) {
                                      Navigator.of(context).pop(true);

                                      merchantBankNotAddedModalSheet(
                                          text:
                                              'We have requested your merchant to add bank account.');
                                    } else if (cid.customerInfo?.kycStatus ==
                                        false) {
                                      Navigator.of(context).pop(true);
                                      merchantBankNotAddedModalSheet(
                                          text:
                                              'Your merchant has not completed the KYC or KYC is expired. We have requested merchant to complete KYC.');
                                    } else if (merchantSubscriptionPlan ==
                                        false) {
                                      Navigator.of(context).pop(true);
                                      debugPrint('Checket');
                                      merchantBankNotAddedModalSheet(
                                          text:
                                              'We have requested your merchant to Switch to Premium now to enjoy the benefits.');
                                    } else {
                                      // showBankAccountDialog();
                                      var cid = await repository.customerApi
                                          .getCustomerID(
                                              mobileNumber: widget
                                                  .customerModel.mobileNo
                                                  .toString())
                                          .timeout(Duration(seconds: 30),
                                              onTimeout: () async {
                                        Navigator.of(context).pop();
                                        return Future.value(null);
                                      });
                                      debugPrint(localCustomerId);
                                      debugPrint(cid.toJson().toString());
                                      _customerData.ulId = cid.customerInfo?.id;
                                      Map<String, dynamic> isTransaction =
                                          await repository.paymentThroughQRApi
                                              .getTransactionLimit(context);
                                      if (!(isTransaction)['isError']) {
                                        debugPrint('cccc : ' +
                                            _customerData.ulId.toString());
                                        debugPrint('cccc : ' + localCustomerId);
                                        Navigator.of(context).popAndPushNamed(
                                          AppRoutes.payTransactionRoute,
                                          arguments: QRDataArgs(
                                              customerModel: _customerData,
                                              customerId: localCustomerId,
                                              amount: message.amount
                                                  .toString()
                                                  .replaceAll(
                                                      RegExp(
                                                          r"([.]*0)(?!.*\d)"),
                                                      ""),
                                              requestId: message.requestId,
                                              type: 'DIRECT',
                                              suspense: false,
                                              through: 'CHAT'),
                                        );
                                      } else {
                                        Navigator.of(context).pop(true);
                                        '${(isTransaction)['message']}'
                                            .showSnackBar(context);
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 15),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: AppTheme.coolGrey),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Text("Pay",
                                        style: TextStyle(
                                            color: AppTheme.brownishGrey,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              if (message.from !=
                                      _contactController.myUser!.id &&
                                  message.paymentCancel == true)
                                SizedBox(
                                  width: 10,
                                ),
                              GestureDetector(
                                onTap: message.paymentCancel == true &&
                                        message.from ==
                                            _contactController.myUser!.id
                                    ?
                                    // "Cancel"
                                    () async {
                                        final status =
                                            await showDeleteConfirmationDialog();
                                        if (status ?? false) {
                                          // debugPrint(message.amount.toString());
                                          if (message.paymentCancel! == true) {
                                            double amount = double.parse(message
                                                .amount
                                                .toString()
                                                .replaceAll('-', ''));
                                            Map<String, dynamic> data = {
                                              "name": _customerData.name,
                                              "mobileNo":
                                                  _customerData.mobileNo,
                                              "requestid":
                                                  "${message.requestId}",
                                              "amount": amount,
                                              "business":
                                                  Provider.of<BusinessProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedBusiness
                                                      .businessId,
                                              "uid": widget
                                                  .customerModel.customerId
                                            };
                                            debugPrint(data.toString());
                                            _contactController
                                                .declinePayment(data);
                                          }
                                        }
                                      }
                                    : message.paymentCancel == true &&
                                            message.from !=
                                                _contactController.myUser!.id
                                        ?
                                        // "Decline"
                                        () async {
                                            final status =
                                                await showDeleteConfirmationDialog();
                                            if (status ?? false) {
                                              // debugPrint(message.amount.toString());
                                              if (message.paymentCancel! ==
                                                  true) {
                                                double amount = double.parse(
                                                    message.amount
                                                        .toString()
                                                        .replaceAll('-', ''));
                                                Map<String, dynamic> data = {
                                                  "name": _customerData.name,
                                                  "mobileNo": widget
                                                      .customerModel.mobileNo,
                                                  "requestid":
                                                      "${message.requestId}",
                                                  "amount": amount,
                                                  "business": Provider.of<
                                                              BusinessProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedBusiness
                                                      .businessId,
                                                  "uid": widget
                                                      .customerModel.customerId
                                                };
                                                debugPrint(data.toString());
                                                _contactController
                                                    .declinePayment(data);
                                              }
                                            }
                                          }
                                        : message.paymentCancel == false &&
                                                message.from ==
                                                    _contactController
                                                        .myUser!.id
                                            ?
                                            // "Cancelled"
                                            () {}
                                            :
                                            // "Declined"
                                            () {},
                                // onTap: () {
                                //   // debugPrint(message.amount.toString());
                                //   if (message.paymentCancel! == true) {
                                //     double amount = double.parse(message.amount
                                //         .toString()
                                //         .replaceAll('-', ''));
                                //     Map<String, dynamic> data = {
                                //       "name": _customerData.name,
                                //       "mobileNo": _customerData.mobileNo,
                                //       "requestid": "${message.requestId}",
                                //       "amount": amount,
                                //       "business": Provider.of<BusinessProvider>(
                                //               context,
                                //               listen: false)
                                //           .selectedBusiness
                                //           .businessId,
                                //       "uid": _customerData.customerId
                                //     };
                                //     debugPrint(data.toString());
                                //     _contactController.declinePayment(data);
                                //   }
                                // },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 15),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppTheme.coolGrey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: message.paymentCancel == true
                                        ? Colors.white
                                        : Colors.black12,
                                  ),
                                  child: Text(
                                      message.paymentCancel == true &&
                                              message.from ==
                                                  _contactController.myUser!.id
                                          ? "Cancel"
                                          : message.paymentCancel == true &&
                                                  message.from !=
                                                      _contactController
                                                          .myUser!.id
                                              ? "Decline"
                                              : message.paymentCancel ==
                                                          false &&
                                                      message.from ==
                                                          _contactController
                                                              .myUser!.id
                                                  ? "Cancelled"
                                                  : "Declined",
                                      style: TextStyle(
                                          color: AppTheme.brownishGrey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            messageDate(message.sendAt!),
                            style: TextStyle(
                                color: AppTheme.brownishGrey, fontSize: 8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget renderReminderTransaction(
  //     BuildContext context, Message message, int index) {
  //   if (_contactController.myUser == null) return Container();
  //   return Column(
  //     children: <Widget>[
  //       renderMessageSendAtDay(message, index),
  //       Material(
  //         color: Colors.transparent,
  //         child: Row(
  //           mainAxisAlignment: message.from == _contactController.myUser!.id
  //               ? MainAxisAlignment.end
  //               : MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: <Widget>[
  //             // renderMessageSendAt(message, MessagePosition.BEFORE),
  //             if (message.from == _contactController.myUser!.id)
  //               Padding(
  //                 padding: EdgeInsets.only(right: 5),
  //                 child: Icon(
  //                   message.unreadByMe == true
  //                       ? Icons.done_all_outlined
  //                       : Icons.done,
  //                   size: 18,
  //                   // color: AppTheme.electricBlue,
  //                   color: message.unreadByMe == true
  //                       ? AppTheme.electricBlue
  //                       : AppTheme.brownishGrey,
  //                 ),
  //               ),
  //             Container(
  //               constraints: BoxConstraints(
  //                 maxWidth: MediaQuery.of(context).size.width * 0.45,
  //                 minWidth: MediaQuery.of(context).size.width * 0.35,
  //               ),
  //               decoration: BoxDecoration(
  //                 border: Border.all(width: 0.2, color: AppTheme.coolGrey),
  //                 borderRadius: message.from == _contactController.myUser!.id
  //                     ? BorderRadius.only(
  //                         topRight: Radius.circular(20),
  //                         bottomLeft: Radius.circular(10),
  //                         bottomRight: Radius.circular(10),
  //                       )
  //                     : BorderRadius.only(
  //                         topLeft: Radius.circular(20),
  //                         bottomLeft: Radius.circular(10),
  //                         bottomRight: Radius.circular(10),
  //                       ),
  //                 color: Colors.white,
  //               ),
  //               padding: EdgeInsets.only(top: 1, left: 1, right: 1),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.max,
  //                 children: [
  //                   Container(
  //                     width: double.infinity,
  //                     decoration: message.from == _contactController.myUser!.id
  //                         ? BoxDecoration(
  //                             border: Border.all(
  //                                 width: 0.2, color: AppTheme.coolGrey),
  //                             borderRadius: BorderRadius.only(
  //                               topRight: Radius.circular(20),
  //                               bottomLeft: Radius.circular(20),
  //                               bottomRight: Radius.circular(20),
  //                             ),
  //                           )
  //                         : BoxDecoration(
  //                             border: Border.all(
  //                                 width: 0.2, color: AppTheme.coolGrey),
  //                             borderRadius: BorderRadius.only(
  //                               topLeft: Radius.circular(20),
  //                               bottomLeft: Radius.circular(20),
  //                               topRight: Radius.circular(20),
  //                             ),
  //                           ),
  //                     child: Padding(
  //                       padding:
  //                           EdgeInsets.symmetric(horizontal: 25, vertical: 10),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Text(
  //                             'Payment request of',
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 15,
  //                               color: Colors.black,
  //                             ),
  //                             textAlign: TextAlign.center,
  //                           ),
  //                           SizedBox(
  //                             height: 5,
  //                           ),
  //                           Text(
  //                             'AED ${removeDecimalif0(message.amount)}',
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.w600,
  //                               fontSize: 22,
  //                               color: AppTheme.tomato,
  //                             ),
  //                             textAlign: TextAlign.center,
  //                           ),
  //                           SizedBox(
  //                             height: 5,
  //                           ),
  //                           if (message.dateTime != null)
  //                             RichText(
  //                               text: TextSpan(
  //                                 text: DateFormat('dd MMM yyyy').format(
  //                                     DateTime.parse(message.dateTime!)),
  //                                 style: TextStyle(
  //                                     // fontWeight: FontWeight.bold,
  //                                     fontSize: 12,
  //                                     color: AppTheme.brownishGrey),
  //                               ),
  //                             ),
  //                           SizedBox(
  //                             height: 5,
  //                           ),
  //                           Text(
  //                             'Sent by ${repository.hiveQueries.userData.firstName} ${repository.hiveQueries.userData.lastName}',
  //                             style: TextStyle(
  //                                 fontWeight: FontWeight.w600,
  //                                 fontSize: 14,
  //                                 color: AppTheme.brownishGrey),
  //                             textAlign: TextAlign.center,
  //                           ),
  //                           SizedBox(
  //                             height: 5,
  //                           ),
  //                           Text(
  //                             repository.hiveQueries.userData.mobileNo,
  //                             style: TextStyle(
  //                                 fontWeight: FontWeight.w500,
  //                                 fontSize: 12,
  //                                 color: AppTheme.brownishGrey),
  //                             textAlign: TextAlign.center,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //                     // child: Text(
  //                     //   'Dear Sir/Madam,\nYour payment of $currencyAED ${removeDecimalif0(message?.amount)} is pending at ${repository.hiveQueries.userData.firstName} ${repository.hiveQueries.userData.lastName} \n(${repository.hiveQueries.userData.mobileNo}),\nClick here UrbanLedgerhgfdew23456789oiugf=0 \n to view the details and make the payment.\n\nIf the link is not clickable, please save the content and try \nagain.',
  //                     //   style: TextStyle(
  //                     //       fontSize: 8, color: AppTheme.brownishGrey),
  //                     // ),
  //                     child: RichText(
  //                       text: TextSpan(
  //                         text:
  //                             'Dear Sir/Madam, Your payment of $currencyAED ${removeDecimalif0(message.amount)} is pending at ${repository.hiveQueries.userData.firstName} ${repository.hiveQueries.userData.lastName} (',
  //                         style: TextStyle(
  //                             fontSize: 7, color: AppTheme.brownishGrey),
  //                         children: [
  //                           TextSpan(
  //                             text:
  //                                 '${repository.hiveQueries.userData.mobileNo}',
  //                             style: TextStyle(
  //                                 fontSize: 7.8, color: AppTheme.electricBlue),
  //                           ),
  //                           TextSpan(
  //                             text: '),\nClick here: ',
  //                             style: TextStyle(
  //                                 fontSize: 7.8, color: AppTheme.brownishGrey),
  //                           ),
  //                           TextSpan(
  //                             text: 'UrbanLedgerhgfdew23456789oiugf=0 \n',
  //                             style: TextStyle(
  //                                 fontSize: 7.8, color: AppTheme.electricBlue),
  //                           ),
  //                           TextSpan(
  //                             text:
  //                                 'to view the details and make the payment.\n\nIf the link is not clickable, please save the content and try again.',
  //                             style: TextStyle(
  //                                 fontSize: 7.8, color: AppTheme.brownishGrey),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                       padding: EdgeInsets.only(right: 7, bottom: 5),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.end,
  //                         crossAxisAlignment: CrossAxisAlignment.end,
  //                         children: [
  //                           Text(
  //                             messageDate(message.sendAt!),
  //                             style: TextStyle(
  //                                 color: AppTheme.coolGrey, fontSize: 6),
  //                           ),
  //                         ],
  //                       )),
  //                 ],
  //               ),
  //             ),
  //             // renderMessageSendAt(message, MessagePosition.AFTER),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget renderRequest(BuildContext context, Message message, int index) {
    debugPrint('message.id' + message.requestId.toString());
    debugPrint('yes' + message.details.toString());
    if (_contactController.myUser == null) return Container();
    return Column(
      children: <Widget>[
        renderMessageSendAtDay(message, index),
        Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: message.from == _contactController.myUser!.id
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // renderMessageSendAt(message, MessagePosition.BEFORE),
              if (message.from == _contactController.myUser!.id)
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    message.unreadByMe == true
                        ? Icons.done_all_outlined
                        : Icons.done,
                    size: 18,
                    // color: AppTheme.electricBlue,
                    color: message.unreadByMe == true
                        ? AppTheme.electricBlue
                        : AppTheme.brownishGrey,
                  ),
                ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.45,
                  minWidth: MediaQuery.of(context).size.width * 0.35,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Color.fromRGBO(162, 164, 176, 0.3)),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          CustomLoadingDialog.showLoadingDialog(context, key);
                          String request = message.requestId!;
                          Map<String, dynamic> requestDetails = await repository
                              .paymentThroughQRApi
                              .getQRData(request).catchError((e){
                                Navigator.of(context).pop();
                                'w $e'.showSnackBar(context);
                              })
                              .timeout(Duration(seconds: 30),
                                  onTimeout: () async {
                            Navigator.of(context).pop();
                            // return Future.value(null);
                          });
                          String attachment = requestDetails['bills']
                              .toString()
                              .replaceAll('[', '')
                              .replaceAll(']', '');
                          List<String> stringList = attachment.split(",");
                          if (requestDetails['status'] == true) {
                            Navigator.of(context).popAndPushNamed(
                                AppRoutes.requestDetailsRoute,
                                arguments: RequestDetailsArgs(
                                    amount: requestDetails['amount'],
                                    customerId: requestDetails['customer_id'],
                                    firstName: requestDetails['firstName'],
                                    lastName: requestDetails['lastName'],
                                    mobileNo: requestDetails['mobileNo'],
                                    currency: requestDetails['currency'],
                                    note: requestDetails['note'],
                                    bills: stringList,
                                    message: message,
                                    user: _contactController.myUser,
                                    requestId: message.requestId,
                                    declinePayment: () {
                                      if (message.paymentCancel! == true &&
                                          message.from !=
                                              _contactController.myUser?.id) {
                                        Map<String, dynamic> data = {
                                          "requestid": "${message.requestId}",
                                          "business":
                                              Provider.of<BusinessProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedBusiness
                                                  .businessId,
                                          "uid": _customerData.customerId
                                        };
                                        // debugPrint(data.toString());
                                        _contactController.declinePayment(data);
                                      }
                                    }));
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   // message.message?.messages ?? '',
                            //   'AED ${message.amount?.getFormattedCurrency}',
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 20,
                            //     color: Colors.black,
                            //   ),
                            // ),
                            RichText(
                              overflow: TextOverflow.fade,
                              text: TextSpan(
                                  text: '$currencyAED  ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: message.from ==
                                            _contactController.myUser!.id
                                        ? AppTheme.greenColor
                                        : AppTheme.tomato,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: (message.amount)!
                                            .getFormattedCurrency,
                                        style: TextStyle(
                                            fontSize: 26,
                                            color: message.from ==
                                                    _contactController
                                                        .myUser!.id
                                                ? AppTheme.greenColor
                                                : AppTheme.tomato,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                            // if (message.details.toString().isNotEmpty)
                            SizedBox(
                              height: 5,
                            ),
                            // if (message.details.toString().isNotEmpty)
                            //   Text(
                            //     // message.message?.messages ?? '',
                            //     '${message.details}',
                            //     style: TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 16,
                            //       color: Colors.black,
                            //     ),
                            //   ),
                            // if (message.details.toString().isNotEmpty)
                            // SizedBox(
                            //   height: 5,
                            // ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  message.from == _contactController.myUser!.id
                                      ? 'Request Sent - '
                                      : 'Request Received - ',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.brownishGrey,
                                  ),
                                ),
                                // renderMessageSendAt(message, MessagePosition.BEFORE),
                                // renderMessageSendAt(message, MessagePosition.AFTER),
                                Padding(
                                    padding:
                                        EdgeInsets.only(right: 0, bottom: 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          ' ' + paymentDate(message.sendAt!),
                                          // messageDate(message.sendAt!),
                                          style: TextStyle(
                                              color: AppTheme.brownishGrey,
                                              fontSize: 10),
                                        ),
                                      ],
                                    )),
                                Expanded(
                                  child: Icon(
                                    Icons.check_circle_outline_outlined,
                                    size: 14,
                                    color: AppTheme.coolGrey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.of(context)
                                    //     .pushNamed(AppRoutes.paymentDetailsRoute);
                                  },
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: AppTheme.electricBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (message.attachmentCount != 0)
                              Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      AppAssets.attachIcon,
                                      height: 10,
                                      color: AppTheme.electricBlue,
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      'Attachment (${message.attachmentCount ?? 0})',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.electricBlue,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // renderMessageSendAt(message, MessagePosition.AFTER),

                          if (message.from != _contactController.myUser!.id &&
                              message.paymentCancel == true)
                            GestureDetector(
                              onTap: () async {
                                CustomLoadingDialog.showLoadingDialog(
                                    context, key);
                                var cid = await repository.customerApi
                                    .getCustomerID(
                                        mobileNumber: _customerData.mobileNo)
                                    .timeout(Duration(seconds: 30),
                                        onTimeout: () async {
                                  Navigator.of(context).pop();
                                  return Future.value(null);
                                });
                                _customerData..ulId = cid.customerInfo?.id;
                                if (cid.customerInfo?.id == null) {
                                  Navigator.of(context).pop(true);
                                  MerchantBankNotAdded.showBankNotAddedDialog(
                                      context, 'userNotRegistered');
                                } else if (cid
                                        .customerInfo?.bankAccountStatus ==
                                    false) {
                                  Navigator.of(context).pop(true);

                                  merchantBankNotAddedModalSheet(
                                      text:
                                          'We have requested your merchant to add bank account.');
                                } else if (cid.customerInfo?.kycStatus ==
                                    false) {
                                  Navigator.of(context).pop(true);
                                  merchantBankNotAddedModalSheet(
                                      text:
                                          'Your merchant has not completed the KYC or KYC is expired. We have requested merchant to complete KYC.');
                                } else {
                                  var cid = await repository.customerApi
                                      .getCustomerID(
                                          mobileNumber: widget
                                              .customerModel.mobileNo
                                              .toString())
                                      .timeout(Duration(seconds: 30),
                                          onTimeout: () async {
                                    Navigator.of(context).pop();
                                    return Future.value(null);
                                  });
                                  debugPrint(localCustomerId);
                                  debugPrint(cid.toJson().toString());
                                  _customerData.ulId = cid.customerInfo!.id;
                                  Map<String, dynamic> isTransaction =
                                      await repository.paymentThroughQRApi
                                          .getTransactionLimit(context);
                                  if (!(isTransaction)['isError']) {
                                    debugPrint('cccc : ' +
                                        _customerData.ulId.toString());
                                    debugPrint('cccc : ' + localCustomerId);
                                    Navigator.of(context).popAndPushNamed(
                                      AppRoutes.payTransactionRoute,
                                      arguments: QRDataArgs(
                                          customerModel: _customerData,
                                          customerId: localCustomerId,
                                          amount: message.amount
                                              .toString()
                                              .replaceAll(
                                                  RegExp(r"([.]*0)(?!.*\d)"),
                                                  ""),
                                          requestId: message.requestId,
                                          type: 'DIRECT',
                                          suspense: false,
                                          through: 'CHAT'),
                                    );
                                  } else {
                                    Navigator.of(context).pop(true);
                                    '${(isTransaction)['message']}'
                                        .showSnackBar(context);
                                  }
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 15),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppTheme.coolGrey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Text("Pay",
                                    style: TextStyle(
                                        color: AppTheme.brownishGrey,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          if (message.from != _contactController.myUser!.id &&
                              message.paymentCancel == true)
                            SizedBox(
                              width: 9,
                            ),
                          GestureDetector(
                            onTap: message.paymentCancel == true &&
                                    message.from ==
                                        _contactController.myUser!.id
                                ?
                                // "Cancel"
                                () async {
                                    final status =
                                        await showDeleteConfirmationDialog();
                                    if (status ?? false) {
                                      // debugPrint(message.amount.toString());
                                      if (message.paymentCancel! == true) {
                                        double amount = double.parse(message
                                            .amount
                                            .toString()
                                            .replaceAll('-', ''));
                                        Map<String, dynamic> data = {
                                          "name": _customerData.name,
                                          "mobileNo": _customerData.mobileNo,
                                          "requestid": "${message.requestId}",
                                          "amount": amount,
                                          "business":
                                              Provider.of<BusinessProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedBusiness
                                                  .businessId,
                                          "uid": _customerData.customerId
                                        };
                                        debugPrint(data.toString());
                                        _contactController.declinePayment(data);
                                      }
                                    }
                                  }
                                : message.paymentCancel == true &&
                                        message.from !=
                                            _contactController.myUser!.id
                                    ?
                                    // "Decline"
                                    () async {
                                        final status =
                                            await showDeleteConfirmationDialog();
                                        if (status ?? false) {
                                          // debugPrint(message.amount.toString());
                                          if (message.paymentCancel! == true) {
                                            double amount = double.parse(message
                                                .amount
                                                .toString()
                                                .replaceAll('-', ''));
                                            Map<String, dynamic> data = {
                                              "name": _customerData.name,
                                              "mobileNo":
                                                  _customerData.mobileNo,
                                              "requestid":
                                                  "${message.requestId}",
                                              "amount": amount,
                                              "business":
                                                  Provider.of<BusinessProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedBusiness
                                                      .businessId,
                                              "uid": widget
                                                  .customerModel.customerId
                                            };
                                            debugPrint(data.toString());
                                            _contactController
                                                .declinePayment(data);
                                          }
                                        }
                                      }
                                    : message.paymentCancel == false &&
                                            message.from ==
                                                _contactController.myUser!.id
                                        ?
                                        // "Cancelled"
                                        () {}
                                        :
                                        // "Declined"
                                        () {},
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.coolGrey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: message.paymentCancel == true
                                    ? Colors.white
                                    : Colors.black12,
                              ),
                              child: Text(
                                  message.paymentCancel == true &&
                                          message.from ==
                                              _contactController.myUser!.id
                                      ? "Cancel"
                                      : message.paymentCancel == true &&
                                              message.from !=
                                                  _contactController.myUser!.id
                                          ? "Decline"
                                          : message.paymentCancel == false &&
                                                  message.from ==
                                                      _contactController
                                                          .myUser!.id
                                              ? "Cancelled"
                                              : "Declined",
                                  style: TextStyle(
                                      color: AppTheme.brownishGrey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            messageDate(message.sendAt!),
                            style: TextStyle(
                                color: AppTheme.brownishGrey, fontSize: 8),
                          ),
                        ],
                      ),
                      // SizedBox(height: 4),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     Text(
                      //       messageDate(message.sendAt!),
                      //       style: TextStyle(
                      //           color: AppTheme.brownishGrey, fontSize: 8),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
              // renderMessageSendAt(message, MessagePosition.AFTER),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> checkDownload(String fileName) async {
    if (Platform.isAndroid) {
      var documentDirectory = await getExternalStorageDirectory();
      if (await File('${documentDirectory?.path}/$fileName').exists()) {
        // _isDownload[fileName] = true;
        return true;
      } else {
        return false;
      }
    } else {
      var documentDirectory = await getApplicationDocumentsDirectory();
      if (await File('${documentDirectory.path}/$fileName').exists()) {
        // _isDownload[fileName] = true;
        return true;
      } else {
        return false;
      }
    }
  }

  Future<String> checkDuration(String message) async {
    debugPrint('ss: ' + message.substring(36, 49));
    final _player = AudioPlayer();
    final documentDirectory = await Directory(Platform.isIOS
            ? (await getApplicationDocumentsDirectory()).path
            : (await getExternalStorageDirectories())!.first.path)
        .create();
    final documentPath = documentDirectory.path;
    if (await File('$documentPath/$message').exists()) {
      var _duration = await _player.setFilePath('$documentPath/$message');
      _player.dispose();
      print(_duration!.inSeconds.toString());
      // final s = _duration.inSeconds.toString();
      // final m = _duration.inMinutes.toString();
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(_duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(_duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
      // return '$m:$s';
    } else if (await File('$documentPath/' + message.substring(36, 49) + '.aac')
        .exists()) {
      debugPrint('ex :' + message);
      var _duration = await _player
          .setFilePath('$documentPath/' + message.substring(36, 49) + '.aac');
      _player.dispose();
      print(_duration!.inSeconds.toString());
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(_duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(_duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
    } else {
      debugPrint('nmex :' +
          File('$documentPath/' + message.substring(36, 49) + '.aac')
              .toString());
      debugPrint('message' + message);
      var _duration = await _player.setFilePath(baseImageUrl + message);
      _player.dispose();
      print(_duration!.inSeconds.toString());
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(_duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(_duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  Future<Duration> checkDuration2(String message) async {
    final _player = AudioPlayer();
    final documentDirectory = await Directory(Platform.isIOS
            ? (await getApplicationDocumentsDirectory()).path
            : (await getExternalStorageDirectories())!.first.path)
        .create();
    final documentPath = documentDirectory.path;
    if (await File('$documentPath/$message').exists()) {
      var _duration = await _player.setFilePath('$documentPath/$message');
      _player.dispose();
      print(_duration!.inSeconds.toString());
      // final s = _duration.inSeconds.toString();
      // final m = _duration.inMinutes.toString();
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(_duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(_duration.inSeconds.remainder(60));
      return _duration;
      // return '$m:$s';
    } else if (await File('$documentPath' + message.substring(36, 49) + '.aac')
        .exists()) {
      debugPrint('message' + message);
      var _duration = await _player
          .setFilePath('$documentPath' + message.substring(36, 49) + '.aac');
      _player.dispose();
      return _duration!;
    } else {
      debugPrint('message' + message);
      var _duration = await _player.setUrl(baseImageUrl + message);
      _player.dispose();
      return _duration!;
    }
  }

  // Future<int> _getDuration(String path) async {
  //   if (Platform.isAndroid) {
  //     var documentDirectory = await getExternalStorageDirectory();

  //     if (await File('${documentDirectory?.path}/$path').exists()) {
  //       final uri = await audioCache.load('${documentDirectory?.path}/$path');
  //       debugPrint(
  //           'audioPlayer.getDuration().toString()2 ${documentDirectory?.path}/$path');
  //       debugPrint('loading,,1 .. ${uri.toString()}');
  //       await audioPlayer.setUrl(uri.toString());

  //       return Future.delayed(
  //         const Duration(seconds: 2),
  //         () => audioPlayer.getDuration(),
  //       );
  //       // return 0;
  //     } else if (await File(
  //             '${documentDirectory?.path}/${path.substring(36, 49)}.aac')
  //         .exists()) {
  //       final uri = await audioCache
  //           .load('${documentDirectory?.path}/${path.substring(36, 49)}.aac');
  //       debugPrint('loading,,2 .. ${uri.toString()}');
  //       await audioPlayer.setUrl(uri.toString());

  //       debugPrint(audioPlayer.getDuration().toString());
  //       // return 0;
  //       return Future.delayed(
  //         const Duration(seconds: 2),
  //         () => audioPlayer.getDuration(),
  //       );
  //     } else {
  //       debugPrint('audioPlayer.getDuration().toString()3');
  //       // return 0;
  //       return Future.delayed(
  //         const Duration(seconds: 2),
  //         () => audioPlayer.getDuration(),
  //       );
  //     }
  //   } else {
  //     var documentDirectory = await getApplicationDocumentsDirectory();
  //     if (await File('${documentDirectory?.path}/$path').exists()) {
  //       await audioPlayer.setUrl('${documentDirectory?.path}/$path');
  //       return Future.delayed(
  //         const Duration(seconds: 0),
  //         () => audioPlayer.getDuration(),
  //       );
  //     } else if (await File(
  //             '${documentDirectory?.path}/${path.substring(36, 49)}.aac')
  //         .exists()) {
  //       await audioPlayer
  //           .setUrl('${documentDirectory?.path}/${path.substring(36, 49)}.aac');
  //       return Future.delayed(
  //         const Duration(seconds: 0),
  //         () => audioPlayer.getDuration(),
  //       );
  //     } else {
  //       return Future.delayed(
  //         const Duration(seconds: 0),
  //         () => audioPlayer.getDuration(),
  //       );
  //     }
  //   }
  // }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

// 2015566031619167248099
  Widget renderAudio(BuildContext context, Message message, int index) {
    _audio = false;
    double? testValue = 00;
    String audio = message.details.toString().substring(36, 49);
    // if(message.from == _contactController.myUser!.id)
    // final documentDirectory = await Directory(Platform.isIOS
    //         ? (await getApplicationDocumentsDirectory()).path
    //         : (await getExternalStorageDirectories(
    //                     type: StorageDirectory.documents))!
    //                 .first
    //                 .path
    //             )
    //     .create();
    //     final documentPath = documentDirectory.path;
    // path = '/storage/emulated/0/Android/data/com.urbanledger.app/files';
    // if(message.from != _contactController.myUser!.id)
    // path2 =
    //     '/storage/emulated/0/Android/data/com.urbanledger.app/files/filereader/files/$audio.aac';
    // debugPrint(path);
    if (_contactController.myUser == null) return Container();
    return _audio == false
        ? Column(
            children: <Widget>[
              renderMessageSendAtDay(message, index),
              Material(
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment:
                      message.from == _contactController.myUser!.id
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // renderMessageSendAt(message, MessagePosition.BEFORE),
                    if (message.from == _contactController.myUser!.id)
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          message.unreadByMe == true
                              ? Icons.done_all_outlined
                              : Icons.done,
                          size: 18,
                          // color: AppTheme.electricBlue,
                          color: message.unreadByMe == true
                              ? AppTheme.electricBlue
                              : AppTheme.brownishGrey,
                        ),
                      ),
                    Card(
                      elevation: 0.5,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(4),
                            child: CircleAvatar(
                                radius: 20,
                                backgroundColor: message.from ==
                                        _contactController.myUser!.id
                                    ? AppTheme.coolGrey
                                    : AppTheme.carolinaBlue,
                                child: CustomText(
                                  message.from == _contactController.myUser!.id
                                      ? getInitials(
                                              '${repository.hiveQueries.userData.firstName} ${repository.hiveQueries.userData.lastName.trim()}',
                                              '${repository.hiveQueries.userData.mobileNo}')
                                          .toUpperCase()
                                      : getInitials('${_customerData.name}',
                                              '${_customerData.mobileNo}')
                                          .toUpperCase(),
                                  color: AppTheme.circularAvatarTextColor,
                                  size: 24,
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          FutureBuilder<bool>(
                            future: checkDownload(message.details!),
                            builder: (context, snapshot) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Icon(
                                  //   Icons.play_circle_fill_rounded,
                                  //   color: Colors.grey,
                                  //   size: 26,
                                  // ),
                                  // if(_isDownload[message.details] ?? false)
                                  message.from !=
                                              _contactController.myUser!.id &&
                                          snapshot.data == false
                                      ? GestureDetector(
                                          onTap: () async {
                                            // debugPrint('yes'+message.details!);
                                            // debugPrint(path2);
                                            final documentDirectory =
                                                await Directory(Platform.isIOS
                                                        ? (await getApplicationDocumentsDirectory())
                                                            .path
                                                        : (await getExternalStorageDirectories())!
                                                            .first
                                                            .path)
                                                    .create();
                                            final documentPath =
                                                documentDirectory.path;
                                            debugPrint('$documentPath/' +
                                                message.details!);
                                            if (await File(
                                                    '$documentPath/${message.details}')
                                                .exists()) {
                                              // if(_isPlaying != message.details){
                                              //   setState(() {
                                              //     _isPlaying = message.details;
                                              //   });
                                              //   await audioPlayer.play('/storage/emulated/0/Android/data/com.urbanledger.app/files/filereader/files/'+message.details!,
                                              //     isLocal: true);
                                              //   debugPrint(_isPlaying.toString()+ 'playing');
                                              // } else{
                                              //   await audioPlayer.stop();
                                              //   setState(() {
                                              //     _isPlaying = null;
                                              //   });
                                              //   debugPrint(_isPlaying.toString()+ 'stop');
                                              // }
                                              // debugPrint(audioPlayer.getDuration().toString());
                                            } else {
                                              setState(() {
                                                _isDownload[message.details!] =
                                                    true;
                                              });

                                              repository.ledgerApi
                                                  .networkAudio(
                                                      message.details!)
                                                  .whenComplete(
                                                      () => setState(() {
                                                            _isDownload[message
                                                                    .details!] =
                                                                false;
                                                          }));
                                            }
                                            // await audioPlayer.play(path2,
                                            //     isLocal: false);
                                            // await repository.ledgerApi.networkAudio(message.details!);
                                          },
                                          child: (_isDownload[
                                                      message.details] ??
                                                  false)
                                              ? CircularProgressIndicator(
                                                  backgroundColor: Colors.white)
                                              : Image.asset(
                                                  AppAssets.downloadAudioIcon,
                                                  width: 24,
                                                ),
                                        )
                                      : GestureDetector(
                                          onTap: () async {
                                            // setState(() {
                                            //   _isPlaying = !_isPlaying;
                                            //   _isPlaying
                                            //       ? _animationController.forward()
                                            //       : _animationController.reverse();
                                            // });
                                            final documentDirectory =
                                                await Directory(Platform.isIOS
                                                        ? (await getApplicationDocumentsDirectory())
                                                            .path
                                                        : (await getExternalStorageDirectories())!
                                                            .first
                                                            .path)
                                                    .create();
                                            final documentPath =
                                                documentDirectory.path;
                                            if (_isPlaying != message.details) {
                                              audioPlayer.pause();
                                              setState(() {
                                                _isPlaying = message.details;
                                              });
                                              if (message.from ==
                                                  _contactController
                                                      .myUser!.id) {
                                                // audioPlayer.play('$path/'+message.details!.substring(36, 49)+'.aac',
                                                // isLocal: true);
                                                audioPlayer.setFilePath(
                                                    '$documentPath/' +
                                                        message.details!
                                                            .substring(36, 49) +
                                                        '.aac');
                                                audioPlayer.play();
                                                audioPlayer.playerStateStream
                                                    .listen((state) {
                                                  if (state.playing) {
                                                    switch (
                                                        state.processingState) {
                                                      case ProcessingState.idle:
                                                        debugPrint('idle');
                                                        break;
                                                      case ProcessingState
                                                          .loading:
                                                        debugPrint('loading');
                                                        break;
                                                      case ProcessingState
                                                          .buffering:
                                                        debugPrint('buffering');
                                                        break;
                                                      case ProcessingState
                                                          .ready:
                                                        debugPrint('ready');
                                                        break;
                                                      case ProcessingState
                                                          .completed:
                                                        debugPrint('completed');
                                                        setState(() {
                                                          audioPlayer.seek(
                                                              Duration.zero);
                                                          _isPlaying = null;
                                                          audioPlayer.stop();
                                                        });
                                                        break;
                                                    }
                                                  }
                                                });
                                                // .whenComplete(() {
                                                //   audioPlayer.stop();
                                                //   setState((){
                                                //     _isPlaying = null;
                                                //   });
                                                // });
                                              } else {
                                                // audioPlayer.play('$path/'+message.details!,
                                                // isLocal: true);
                                                audioPlayer.setFilePath(
                                                    '$documentPath/' +
                                                        message.details!);
                                                audioPlayer.play();
                                                audioPlayer.playerStateStream
                                                    .listen((state) {
                                                  if (state.playing) {
                                                    switch (
                                                        state.processingState) {
                                                      case ProcessingState.idle:
                                                        debugPrint('idle');
                                                        break;
                                                      case ProcessingState
                                                          .loading:
                                                        debugPrint('loading');
                                                        break;
                                                      case ProcessingState
                                                          .buffering:
                                                        debugPrint('buffering');
                                                        break;
                                                      case ProcessingState
                                                          .ready:
                                                        debugPrint('ready');
                                                        break;
                                                      case ProcessingState
                                                          .completed:
                                                        debugPrint('completed');
                                                        setState(() {
                                                          audioPlayer.seek(
                                                              Duration.zero);
                                                          _isPlaying = null;
                                                          audioPlayer.stop();
                                                        });
                                                        break;
                                                    }
                                                  }
                                                });
                                                // .whenComplete(() {
                                                //   audioPlayer.stop();
                                                //   setState((){
                                                //     _isPlaying = null;
                                                //   });
                                                // });
                                              }
                                              // debugPrint(_isPlaying.toString()+ 'playing'+message.details!);
                                            } else {
                                              await audioPlayer.stop();
                                              setState(() {
                                                _isPlaying = null;
                                              });
                                              // debugPrint(_isPlaying.toString()+ 'stop'+message.details!);
                                            }
                                            // int response = await audioPlayer.play(path!,
                                            //     isLocal: true);

                                            debugPrint('zxcv' +
                                                '$documentPath/' +
                                                message.details!
                                                    .substring(36, 49) +
                                                '.aac');
                                          },
                                          child: Image.asset(
                                            _isPlaying == message.details
                                                ? AppAssets.stopAudioIcon
                                                : AppAssets.playAudioIcon,
                                            width: 24,
                                          )
                                          // child: AnimatedIcon(
                                          //   icon: AnimatedIcons.play_pause,
                                          //   progress: _animationController,
                                          //   size: 5,
                                          // ),
                                          ),
                                  // if(_isDownload[message.details] ?? false)
                                  //   CircularProgressIndicator(
                                  //     backgroundColor: Colors.white),

                                  // visualization-01
                                  // message.from != _contactController.myUser!.id
                                  // ?
                                  FutureBuilder<String>(
                                    future: checkDuration(message.details!),
                                    initialData: '00:00',
                                    builder: (context, snapshot1) {
                                      return Visibility(
                                        child: Text(
                                          '${snapshot1.data}',
                                          style: TextStyle(
                                              color: AppTheme.greyish,
                                              fontSize: 8),
                                        ),
                                      );
                                    },
                                  )
                                  // :FutureBuilder<String?>(
                                  //   future: checkDuration2(message.details!),
                                  //   builder: (context, snapshot1) {
                                  //     return Visibility(
                                  //       visible : snapshot1.data != null,
                                  //       child: Text(
                                  //         '${snapshot1.data}',
                                  //         // '',
                                  //         style: TextStyle(color: AppTheme.greyish, fontSize: 8),
                                  //       ),
                                  //     );
                                  //   },
                                  // ),
                                ],
                              );
                            },
                          ),
                          // SizedBox(
                          //   width: 5,
                          // ),
                          // Image.asset(
                          //   'assets/icons/visualization-01.png',
                          //   height: 22,
                          //   // width: 110,
                          // ),

                          StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            setState(() {});
                            return FutureBuilder<Duration>(
                                future: checkDuration2(message.details!),
                                builder: (context, snapshot) {
                                  // double max=100.0;
                                  // if(snapshot.hasData){
                                  //   // max=snapshot.data!.inSeconds.toDouble();
                                  // }
                                  return Container(
                                    height: 22,
                                    width: 110,
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        activeTrackColor: Colors.white,
                                        thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 3.0),
                                        overlayShape: RoundSliderOverlayShape(
                                            overlayRadius: 10.0),
                                      ),
                                      child: StreamBuilder<
                                              Map<String, DurationState>>(
                                          stream: _durationState,
                                          builder: (context, snapshot) {
                                            return Slider(
                                              min: 0,
                                              max: 1,
                                              value: snapshot
                                                      .data?[message.details]
                                                      ?.percentage ??
                                                  testValue!,
                                              onChanged: (value) {
                                                setState(() {
                                                  testValue = value;
                                                  debugPrint('sdf ' +
                                                      testValue.toString());
                                                  //debugPrint('sdf'+va.toString());
                                                  audioPlayer.seek(Duration(
                                                      seconds:
                                                          testValue!.toInt()));
                                                });
                                              },
                                              onChangeStart: (value) {
                                                setState(() {
                                                  testValue = value;
                                                  audioPlayer.seek(Duration(
                                                      seconds: value.toInt()));
                                                });
                                              },
                                              activeColor:
                                                  AppTheme.electricBlue,
                                              inactiveColor: Color(0xFFCEE3EE),
                                            );
                                          }),
                                    ),
                                  );
                                });
                          }),

//                   FutureBuilder<Duration>(
//                     future: checkDuration2(message.details!),
//                     builder: (context, snapshot1) {
//                       double value1=0.01;
//                       double max=snapshot1?.data?.inMilliseconds?.toDouble()??100.0;
// //                     return Container(
// //                       width: 110,
// //                       height: 22,
// //                       // color: AppTheme.brownishGrey,
// //                       child: SliderTheme(
// //                         data: SliderThemeData(
// //                                 thumbColor: AppTheme.electricBlue,
// //                                 thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5)),
// //                         child: Slider(
// //                         min: 0.0,
// //                         max: max,
// //                         value:value1,
// //                         onChanged: (double value) {
// //  debugPrint('on change '+value.toString());

// //                           setState((){
// //                             //audioPlayer.seek(Duration(milliseconds: value.toInt()));
// //                             value1 = value;
// //                             debugPrint('qwertasd '+value1.toString());
// //                           });

//                         },
// //                         onChangeEnd: (double value) {
// //                           setState(() {
// //                             value1=value;
// //                           });
// //                         },
// //                         activeColor: Colors.blue,
// //                         inactiveColor: Color(0xFFCEE3EE),
// //                         ),
// //                       ),
// //                     );
// //                     },
// //                   ),
//                     // SizedBox(
//                     //   width: 10,
//                     // ),
//                   ),
                          Text(
                            messageDate(message.sendAt!),
                            style:
                                TextStyle(color: AppTheme.greyish, fontSize: 8),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   constraints: BoxConstraints(
                    //       maxWidth: MediaQuery.of(context).size.width * 0.12),
                    //   decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.only(
                    //             topLeft: Radius.circular(0),
                    //             bottomLeft: Radius.circular(0),
                    //           ),
                    //           color: (AppTheme.senderColor),
                    //         ),

                    //   child: Padding(
                    //     padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.5),
                    //     child: renderMessageSendAt(message, MessagePosition.AFTER),
                    //   ),
                    // ),

                    // renderMessageSendAt(message, MessagePosition.AFTER),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  // Widget slider() {
  //   return Slider.adaptive(
  //       min: 0.0,
  //       value: pos.inSeconds.toDouble(),
  //       max: dur.inSeconds.toDouble(),
  //       onChanged: (double value) {
  //         audioPlayer.seek(new Duration(seconds: value.toInt()));
  //       });
  // }

  Future<bool> checkContact(String contact) async {
    bool isAdded = await repository.queries.checkCustomerAdded(
        contact,
        Provider.of<BusinessProvider>(context, listen: false)
            .selectedBusiness
            .businessId);
    if (isAdded) {
      return true;
    } else {
      return false;
    }
  }

  Widget renderContact(BuildContext context, Message message, int index) {
    if (_contactController.myUser == null) return Container();
    return Column(
      children: <Widget>[
        renderMessageSendAtDay(message, index),
        Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: message.from == _contactController.myUser!.id
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // renderMessageSendAt(message, MessagePosition.BEFORE),
              Container(
                padding: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment:
                      message.from == _contactController.myUser!.id
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        ClipPath(
                            clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              )),
                            ),
                            child: Container(
                              height: 70.0,
                              width: MediaQuery.of(context).size.width * 0.60,
                              // decoration: BoxDecoration(
                              color: Colors.white,
                              //     border: Border(
                              //         bottom: BorderSide(
                              //             color: Color.fromRGBO(0, 0, 0, 1),
                              //             width: 0.5
                              //         )
                              //     ),
                              // ),
                              child: Column(
                                children: [
                                  // Flexible(
                                  //   flex: 2,
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 12, top: 12, right: 5),
                                        child: CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                AppTheme.carolinaBlue,
                                            child: CustomText(
                                              getInitials(
                                                      message.contactName!
                                                          .trim(),
                                                      message.contactNo!.trim())
                                                  .toUpperCase(),
                                              color: AppTheme
                                                  .circularAvatarTextColor,
                                              size: 27,
                                            )),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 5, top: 10, right: 10),
                                          child: Text(
                                            message.contactName!,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: AppTheme.brownishGrey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  // ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Text(
                                            messageDate(message.sendAt!),
                                            style: TextStyle(
                                                color: AppTheme.brownishGrey,
                                                fontSize: 8),
                                          ),
                                        ),
                                      ]),
                                  // Align(
                                  //   alignment: Alignment.bottomRight,
                                  //   child: Padding(
                                  //     padding: EdgeInsets.only(
                                  //         left: MediaQuery.of(context)
                                  //                 .size
                                  //                 .width *
                                  //             0.48),
                                  //     child: Text(
                                  //       messageDate(message.sendAt),
                                  //       style: TextStyle(
                                  //           color: AppTheme.brownishGrey,
                                  //           fontSize: 8),
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                            )),
                        ClipPath(
                            clipper: ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                            ),
                            child: Container(
                              height: 35.0,
                              width: MediaQuery.of(context).size.width * 0.60,
                              // color: Colors.white,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    top: BorderSide(
                                        color: AppTheme.greyish, width: 0.5)),
                              ),
                              child: FutureBuilder<bool>(
                                future: checkContact(message.contactNo!),
                                builder: (context, snapshot1) {
                                  debugPrint(snapshot1.data.toString());
                                  return GestureDetector(
                                    onTap: () async {
                                      debugPrint('dddd :' +
                                          message.toJson().toString());
                                      bool isAdded = await repository.queries
                                          .checkCustomerAdded(
                                              message.contactNo!.trim(),
                                              Provider.of<BusinessProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedBusiness
                                                  .businessId);
                                      if (isAdded) {
                                        List<CustomerModel> customerModel =
                                            await repository.queries
                                                .getCustomerDetails(
                                                    message.contactNo!.trim(),
                                                    Provider.of<BusinessProvider>(
                                                            context,
                                                            listen: false)
                                                        .selectedBusiness
                                                        .businessId);
                                        debugPrint('ss ::' +
                                            customerModel.first
                                                .toJson()
                                                .toString());
                                        CustomerModel _customerModel =
                                            customerModel.first;
                                        // CustomerModel();
                                        // _customerModel.customerId =
                                        //     customerModel.first.customerId;
                                        // _customerModel.name =
                                        //     customerModel.first.name;
                                        // _customerModel.mobileNo =
                                        //     customerModel.first.mobileNo;
                                        // _customerModel.businessId =
                                        //     customerModel.first.businessId;
                                        // _customerModel.isChanged =
                                        //     customerModel.first.isChanged;
                                        // _customerModel.isDeleted =
                                        //     customerModel.first.isDeleted;
                                        // _customerModel.createdDate =
                                        //     customerModel.first.createdDate;

                                        // setState(() {
                                        // });
                                        final _ledger =
                                            BlocProvider.of<LedgerCubit>(
                                                context);
                                        _ledger.getLedgerData(
                                            _customerModel.customerId!);
                                        ContactController.initChat(
                                            context, _customerModel.chatId);
                                        setState(() {
                                          _customerData = _customerModel;
                                        });
                                      } else {
                                        CustomerModel _customerModel =
                                            CustomerModel();
                                        _customerModel.customerId = Uuid().v1();
                                        _customerModel.name =
                                            message.contactName;
                                        _customerModel.mobileNo =
                                            message.contactNo;
                                        _customerModel.businessId =
                                            Provider.of<BusinessProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedBusiness
                                                .businessId;
                                        _customerModel.isChanged = true;
                                        _customerModel.isDeleted = false;
                                        _customerModel.createdDate =
                                            DateTime.now();

                                        FocusScope.of(context).unfocus();
                                        setState(() {
                                          isLoading = true;
                                        });
                                        debugPrint('dddd :' +
                                            _customerModel.toJson().toString());
                                        final response = await repository
                                            .queries
                                            .insertCustomer(_customerModel);
                                        if (response != null) {
                                          if (await checkConnectivity) {
                                            if (_customerModel
                                                .mobileNo!.isNotEmpty) {
                                              final Messages msg = Messages(
                                                  messages: '',
                                                  messageType: 100);
                                              var jsondata = jsonEncode(msg);

                                              final response =
                                                  await _chatRepository.sendMessage(
                                                      _customerModel.mobileNo
                                                          .toString(),
                                                      _customerModel.name,
                                                      jsondata,
                                                      _customerModel
                                                              .customerId ??
                                                          '',
                                                      Provider.of<BusinessProvider>(
                                                              context,
                                                              listen: false)
                                                          .selectedBusiness
                                                          .businessId);

                                              final messageResponse =
                                                  Map<String, dynamic>.from(
                                                      jsonDecode(
                                                          response.body));
                                              Message _message =
                                                  Message.fromJson(
                                                      messageResponse[
                                                          'message']);
                                              _customerModel
                                                ..chatId = _message.chatId;
                                            }
                                            // await saveContacts();
                                          } else {
                                            Navigator.of(context).pop();
                                            'Please check your internet connection or try again later.'
                                                .showSnackBar(context);
                                          }
                                          BlocProvider.of<ContactsCubit>(
                                                  context)
                                              .getContacts(
                                                  Provider.of<BusinessProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedBusiness
                                                      .businessId);

                                          BlocProvider.of<LedgerCubit>(context)
                                              .getLedgerData(
                                                  _customerModel.customerId!);
                                          ContactController.initChat(
                                              context, _customerModel.chatId);
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  AppRoutes
                                                      .transactionListRoute,
                                                  arguments:
                                                      TransactionListArgs(true,
                                                          _customerModel));
                                        }
                                        // _customerModel
                                        //   ..name = getName(
                                        //       message.contactName!.trim(),
                                        //       message.contactNo!.trim())
                                        //   ..mobileNo = message.contactNo!.trim()
                                        //   // ..avatar = widget.contacts[index].avatar
                                        //   ..isChanged = true;
                                        // // /*  if (await checkConnectivity) {
                                        // //   final apiResponse = await _repository.contactProvider
                                        // //       .saveContact(_customerModel);
                                        // // } */
                                        // // if (!(await widget.contacts[index].isAdded)) {
                                        // final response = await repository
                                        //     .queries
                                        //     .insertCustomer(_customerModel);
                                        // if (response != null) {
                                        //   BlocProvider.of<ContactsCubit>(
                                        //           context)
                                        //       .getContacts(
                                        //           Provider.of<BusinessProvider>(
                                        //                   context,
                                        //                   listen: false)
                                        //               .selectedBusiness
                                        //               .businessId);

                                        //   if (!isCustomerAddedNotifier.value)
                                        //     isCustomerAddedNotifier.value =
                                        //         true;
                                        // }
                                        // Navigator.of(context).pushNamed(AppRoutes.transactionListRoute,
                                        //   arguments: TransactionListRouteArgs(
                                        //     getName(message.contactName,
                                        //         message.contactNo),
                                        //     null,
                                        //     response,
                                        //     message.contactNo,
                                        //     null,
                                        //   ));
                                        // } else {

                                        // }
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: snapshot1.data == true
                                                ? Text(
                                                    'Message',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textAlign: TextAlign.center,
                                                  )
                                                : Text(
                                                    'Add to Urban Ledger',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textAlign: TextAlign.center,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
              // renderMessageSendAt(message, MessagePosition.AFTER),
            ],
          ),
        ),
      ],
    );
  }

  Widget renderAudioadd() {
    // String audio = message.details.toString().substring(36, 49);
    // String path =
    //     '/storage/emulated/0/Android/data/com.urbanledger.app/files/$audio.aac';
    if (_contactController.myUser == null) return Container();
    return Column(
      children: <Widget>[
        // renderMessageSendAtDay(message, index),
        Material(
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.done,
                  size: 18,
                  // color: AppTheme.electricBlue,
                  color: AppTheme.brownishGrey,
                ),
              ),
              Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: CircularProgressIndicator(),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.all(4),
                    //   child: CircleAvatar(
                    //     radius: 20,
                    //     backgroundColor: Color(0xff666666),
                    //     backgroundImage: NetworkImage(
                    //         'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                    //   ),
                    // ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon(
                        //   Icons.play_circle_fill_rounded,
                        //   color: Colors.grey,
                        //   size: 26,
                        // ),
                        GestureDetector(
                          onTap: () async {
                            // int response = await audioPlayer.play(path,
                            //     isLocal: true);
                            // debugPrint('zxcv' + response.toString());
                          },
                          child: Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.grey,
                            size: 26,
                          ),
                        ),

                        // visualization-01
                        Text(
                          '00:00',
                          style:
                              TextStyle(color: AppTheme.greyish, fontSize: 8),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      'assets/icons/visualization-01.png',
                      height: 22,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      messageDate(DateTime.now().millisecondsSinceEpoch),
                      style: TextStyle(color: AppTheme.greyish, fontSize: 8),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }

  Future<String> storeImages(String assetPath) async {
    debugPrint('qwerty');
    return await repository.ledgerApi.networkImageToFile2(assetPath);
  }

  Widget renderAttachment(BuildContext context, Message message, int index) {
    _gallery = false;
    _camera = false;
    // setState(() {
    // });
    debugPrint('atttaa ' + _camera.toString());
    precacheImage(NetworkImage('$baseImageUrl${message.details}'), context);
    if (_contactController.myUser == null) return Container();
    return _gallery == false || _camera == false
        ? Column(
            children: <Widget>[
              renderMessageSendAtDay(message, index),
              Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment:
                      message.from == _contactController.myUser!.id
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    // renderMessageSendAt(message, MessagePosition.BEFORE),
                    if (message.from == _contactController.myUser!.id)
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          message.unreadByMe == true
                              ? Icons.done_all_outlined
                              : Icons.done,
                          size: 18,
                          // color: AppTheme.electricBlue,
                          color: message.unreadByMe == true
                              ? AppTheme.electricBlue
                              : AppTheme.brownishGrey,
                        ),
                      ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.41,
                      // height: 200,
                      constraints: BoxConstraints(
                        // maxWidth: MediaQuery.of(context).size.width * 0.50,
                        minWidth: MediaQuery.of(context).size.width * 0.41,
                        maxHeight: 175,
                        // minHeight: 175,
                      ),
                      padding:
                          EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment:
                            message.from == _contactController.myUser!.id
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              debugPrint('atttaa ' + _camera.toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PhotoViewer(
                                      url: '$baseImageUrl${message.details}'),
                                ),
                              );
                            },
                            child: Stack(
                              children: <Widget>[
                                //top grey shadow

                                //image code
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  // child: FutureBuilder<String>(
                                  //   future: storeImages(message.details!),
                                  //   builder: (context, snapshot) {
                                  //     debugPrint('snapshot.data');
                                  //     debugPrint(snapshot.data);
                                  //     return snapshot.data == null
                                  //         ? Image.file(File(snapshot.data!),
                                  //             width: 180,
                                  //             // height: 100,
                                  //           ):
                                  //           Container(
                                  //             child: Text(
                                  //               'Loading..',
                                  //               textAlign: TextAlign.center,
                                  //             ),
                                  //           );
                                  //   }
                                  // ),
                                  child: Image.network(
                                      baseImageUrl + message.details.toString(),
                                      width: 180,
                                      fit: BoxFit.cover),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                      gradient: new LinearGradient(
                                        end: const Alignment(0.0, 0.3),
                                        begin: const Alignment(0.0, -1),
                                        colors: <Color>[
                                          const Color(0x8A000000),
                                          Colors.black12.withOpacity(0.0)
                                        ],
                                      ),
                                    ),
                                    child: Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 15, top: 10),
                                          child: Image.asset(
                                            'assets/icons/down.png',
                                            width: 14,
                                          ),
                                        )),
                                  ),
                                ),
                                // bottom grey shadow
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    // margin: EdgeInsets.only(top:MediaQuery.of(context).size.height* 1.12),
                                    height: 30,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        // topRight: Radius.circular(0),
                                        bottomRight: Radius.circular(20),
                                      ),
                                      gradient: new LinearGradient(
                                        end: const Alignment(0.0, -1),
                                        begin: const Alignment(0.0, 0.9),
                                        colors: <Color>[
                                          const Color(0x8A000000),
                                          Colors.black12.withOpacity(0.0)
                                        ],
                                      ),
                                    ),
                                    child: Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 20, top: 10),
                                          child: Text(
                                            messageDate(message.sendAt!),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    // renderMessageSendAt(message, MessagePosition.AFTER),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  Future<PdfPageImage> onTap(String assetPath) async {
    debugPrint('qwerty ' + assetPath);
    final apiResponse =
        await repository.ledgerApi.networkImageToFile2(assetPath);
    final doc = await PdfDocument.openFile(apiResponse);
    final page = await doc.getPage(1);
    final PdfPageImage pageImage = await page.render(
        height: 100, width: 220, fullHeight: 200, fullWidth: 200);
    await pageImage.createImageIfNotAvailable();
    return pageImage;
  }

  Future<String?> getSize(String message) async {
    
    final apiResponse = await repository.ledgerApi.networkImageToFile2(message);
    int fileSize = File(apiResponse).lengthSync();
    debugPrint('SSS : ' + fileSize.toString());
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(fileSize) / log(1024)).floor();
    String fileSizewith =
        (((fileSize / pow(1024, i)).toStringAsFixed(0)) + ' ' + suffixes[i]);
    debugPrint(fileSizewith);
    return fileSizewith;
  }

  Widget renderDocument(BuildContext context, Message message, int index) {
    _document = false;
    String type = message.message!.details!.split('.').last;
    if (_contactController.myUser == null) return Container();
    return _document == false
        ? Column(
            children: <Widget>[
              renderMessageSendAtDay(message, index),
              Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment:
                      message.from == _contactController.myUser!.id
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    // renderMessageSendAt(message, MessagePosition.BEFORE),
                    if (message.from == _contactController.myUser!.id)
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          message.unreadByMe == true
                              ? Icons.done_all_outlined
                              : Icons.done,
                          size: 18,
                          // color: AppTheme.electricBlue,
                          color: message.unreadByMe == true
                              ? AppTheme.electricBlue
                              : AppTheme.brownishGrey,
                        ),
                      ),
                    GestureDetector(
                        onTap: () async {
                          debugPrint(filePath);
                          if (isPlatformiOS()) {
                            var documentDirectory =
                                await (getApplicationDocumentsDirectory());
                            String path = documentDirectory!.absolute.path+'/';
                            if (await File(path + message.details!).exists()) {
                              debugPrint('yesss');
                              // await PdfDocument.openFile(path+message.details!);
                              File(path + message.details!)
                                  .open(mode: FileMode.read);
                              final _result =
                                  await OpenFile.open(path + message.details!);
                              print(_result.message);
                            } else {
                              debugPrint('noooo');
                            }
                          } else {
                            var documentDirectory =
                                await (getExternalStorageDirectory());
                            String path = documentDirectory!.absolute.path+'/';
                            debugPrint('yesss'+path+message.details.toString());
                            if (await File(path + message.details!).exists()) {
                              
                              // await PdfDocument.openFile(path+message.details!);
                              File(path + message.details!)
                                  .open(mode: FileMode.read);
                              final _result =
                                  await OpenFile.open(path + message.details!);
                              print(_result.message);
                            } else {
                              debugPrint('noooo');
                            }
                          }
                          // var documentDirectory =
                          //     await (getExternalStorageDirectory());
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.50,
                            minWidth: MediaQuery.of(context).size.width * 0.41,
                          ),
                          padding: EdgeInsets.only(
                              left: 2, right: 2, top: 2, bottom: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          // child:Text('${message.message.details}'),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: <Widget>[
                                  ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                      child: FutureBuilder<PdfPageImage>(
                                          future: onTap(message.details!),
                                          builder: (context, snapshot) {
                                            return snapshot.data == null
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 15),
                                                    child: Center(
                                                      child: Image.asset(
                                                        AppAssets.documentIcon,
                                                        // width: 1,
                                                        height: 80,
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                                    ),
                                                  )
                                                : RawImage(
                                                    image: snapshot
                                                        .data!.imageIfAvailable,
                                                    fit: BoxFit.fill,
                                                    // scale: 1,
                                                  );
                                          })),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      height: 40,
                                      width: 240,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        gradient: new LinearGradient(
                                          end: const Alignment(0.0, 0.3),
                                          begin: const Alignment(0.0, -1),
                                          colors: <Color>[
                                            const Color(0x8A000000),
                                            Colors.black12.withOpacity(0.0)
                                          ],
                                        ),
                                      ),
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 20, top: 10),
                                            child: Image.asset(
                                              'assets/icons/down.png',
                                              width: 14,
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    // topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                    // topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 14, right: 14, top: 10, bottom: 10),
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            AppAssets.documentIcon,
                                            height: 22,
                                          ),
                                          SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              '${message.details}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: AppTheme.brownishGrey),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          if (message.from !=
                                              _contactController.myUser!.id)
                                            GestureDetector(
                                              onTap: () async {},
                                              child: Image.asset(
                                                'assets/icons/Download-01.png',
                                                height: 22,
                                              ),
                                            ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 5, top: 5, right: 55, bottom: 5),
                                    child: FutureBuilder<String?>(
                                      future: getSize(message.details!),
                                      builder: (context, snapshot1) {
                                        return Text(
                                          '$type - ${snapshot1.data}'
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: AppTheme.greyish),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 45, top: 5, right: 10, bottom: 5),
                                    child: Text(
                                      messageDate(message.sendAt!),
                                      style: TextStyle(
                                          color: AppTheme.brownishGrey,
                                          fontSize: 8),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
                    // renderMessageSendAt(message, MessagePosition.AFTER),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  Widget renderDocumentAdd() {
    if (_contactController.myUser == null) return Container();
    return Column(
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // renderMessageSendAt(message, MessagePosition.BEFORE),
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.done,
                  size: 18,
                  // color: AppTheme.electricBlue,
                  color: AppTheme.brownishGrey,
                ),
              ),
              GestureDetector(
                  onTap: () {},
                  child: Container(
                    // width: MediaQuery.of(context).size.width * 0.41,
                    // height: 200,
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.50,
                      minWidth: MediaQuery.of(context).size.width * 0.41,
                      // maxHeight: 150,
                      // minHeight: 175,
                    ),
                    padding:
                        EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Colors.white,
                    ),
                    // child:Text('${message.message.details}'),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: <Widget>[
                            //top grey shadow

                            //image code
                            ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                // child: Image.asset(
                                //   'assets/icons/pdf-cover-img.png',
                                //   width: 220,
                                // ),

                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 30),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 40,
                                width: 240,
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  gradient: new LinearGradient(
                                    end: const Alignment(0.0, 0.3),
                                    begin: const Alignment(0.0, -1),
                                    colors: <Color>[
                                      const Color(0x8A000000),
                                      Colors.black12.withOpacity(0.0)
                                    ],
                                  ),
                                ),
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(right: 20, top: 10),
                                      child: Image.asset(
                                        'assets/icons/down.png',
                                        width: 14,
                                      ),
                                    )),
                              ),
                            ),
                            //bottom grey shadow
                            // Align(
                            //   alignment: Alignment.bottomCenter,
                            //   child: Container(
                            //     height: 50,
                            //     width: 220,
                            //     decoration: new BoxDecoration(
                            //       gradient: new LinearGradient(
                            //         end: const Alignment(0.0, -1),
                            //         begin: const Alignment(0.0, 0.4),
                            //         colors: <Color>[
                            //           const Color(0x8A000000),
                            //           Colors.black12.withOpacity(0.0)
                            //         ],
                            //       ),

                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              // topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              // topRight: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 14, right: 14, top: 10, bottom: 10),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      AppAssets.documentIcon,
                                      height: 22,
                                    ),
                                    SizedBox(width: 5),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 5, top: 5, right: 55, bottom: 5),
                                child: Text(
                                  'File 0KB'.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 10, color: AppTheme.greyish),
                                )),
                            SizedBox(width: 10),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 55, top: 5, right: 5, bottom: 5),
                              child: Text(
                                messageDate(
                                    DateTime.now().millisecondsSinceEpoch),
                                style: TextStyle(
                                    color: AppTheme.brownishGrey, fontSize: 8),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget renderDocFile(BuildContext context, Message message, int index) {
    _document = false;
    String type = message.message!.details!.split('.').last;
    if (_contactController.myUser == null) return Container();
    return _document == false
        ? Column(
            children: <Widget>[
              renderMessageSendAtDay(message, index),
              Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment:
                      message.from == _contactController.myUser!.id
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    // renderMessageSendAt(message, MessagePosition.BEFORE),
                    if (message.from == _contactController.myUser!.id)
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          message.unreadByMe == true
                              ? Icons.done_all_outlined
                              : Icons.done,
                          size: 18,
                          // color: AppTheme.electricBlue,
                          color: message.unreadByMe == true
                              ? AppTheme.electricBlue
                              : AppTheme.brownishGrey,
                        ),
                      ),
                    GestureDetector(
                        onTap: () {
                          // debugPrint(filePath);
                          // OpenFile.open(filePath);
                        },
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 0.41,
                          // height: 200,
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.50,
                            minWidth: MediaQuery.of(context).size.width * 0.41,
                            // maxHeight: 150,
                            // minHeight: 175,
                          ),
                          padding: EdgeInsets.only(
                              left: 2, right: 2, top: 2, bottom: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          // child:Text('${message.message.details}'),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: <Widget>[
                                  //top grey shadow

                                  //image code
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    // child: Container(
                                    //   child: Image.asset(AppAssets.docFileIcon,
                                    //       height: 100, alignment: Alignment.center),
                                    // ),
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: Center(
                                        child: Image.asset(
                                          AppAssets.docFileIcon,
                                          // width: 1,
                                          height: 80,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                    ),

                                    // child: FutureBuilder<PdfPageImage>(
                                    //     future: onTap(message.details!),
                                    //     builder: (context, snapshot) {
                                    //       return snapshot.data == null
                                    //           ? Image.asset(
                                    //               'assets/icons/pdf-cover-img.png',
                                    //               width: 220,
                                    //               // height: 100,
                                    //             )
                                    //           : RawImage(
                                    //               image: snapshot
                                    //                   .data!.imageIfAvailable,
                                    //               fit: BoxFit.fill,
                                    //               // scale: 1,
                                    //             );
                                    //     })
                                  ),

                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      height: 40,
                                      width: 240,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        gradient: new LinearGradient(
                                          end: const Alignment(0.0, 0.3),
                                          begin: const Alignment(0.0, -1),
                                          colors: <Color>[
                                            const Color(0x8A000000),
                                            Colors.black12.withOpacity(0.0)
                                          ],
                                        ),
                                      ),
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 20, top: 10),
                                            child: Image.asset(
                                              'assets/icons/down.png',
                                              width: 14,
                                            ),
                                          )),
                                    ),
                                  ),
                                  //bottom grey shadow
                                  // Align(
                                  //   alignment: Alignment.bottomCenter,
                                  //   child: Container(
                                  //     height: 50,
                                  //     width: 220,
                                  //     decoration: new BoxDecoration(
                                  //       gradient: new LinearGradient(
                                  //         end: const Alignment(0.0, -1),
                                  //         begin: const Alignment(0.0, 0.4),
                                  //         colors: <Color>[
                                  //           const Color(0x8A000000),
                                  //           Colors.black12.withOpacity(0.0)
                                  //         ],
                                  //       ),

                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    // topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                    // topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 14, right: 14, top: 10, bottom: 10),
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            AppAssets.docFileIcon,
                                            height: 22,
                                          ),
                                          SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              '${message.details}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: AppTheme.brownishGrey),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          if (message.from !=
                                              _contactController.myUser!.id)
                                            GestureDetector(
                                              onTap: () async {},
                                              child: Image.asset(
                                                'assets/icons/Download-01.png',
                                                height: 22,
                                              ),
                                            ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 5,
                                          top: 5,
                                          right: 55,
                                          bottom: 5),
                                      child: Text(
                                        '$type - 14 MB'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: AppTheme.greyish),
                                      )),
                                  SizedBox(width: 10),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 55, top: 5, right: 5, bottom: 5),
                                    child: Text(
                                      messageDate(message.sendAt!),
                                      style: TextStyle(
                                          color: AppTheme.brownishGrey,
                                          fontSize: 8),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
                    // renderMessageSendAt(message, MessagePosition.AFTER),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  Widget renderAttachmentAdd() {
    if (_contactController.myUser == null) return Container();
    return Column(
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.done,
                  size: 18,
                  // color: AppTheme.electricBlue,
                  color: AppTheme.brownishGrey,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.41,
                // height: 200,
                constraints: BoxConstraints(
                  // maxWidth: MediaQuery.of(context).size.width * 0.50,
                  minWidth: MediaQuery.of(context).size.width * 0.41,
                  maxHeight: 175,
                  // minHeight: 175,
                ),
                padding: EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: <Widget>[
                        //top grey shadow

                        //image code
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            child: _url != null
                                ? Image.file(_url!,
                                    width: 180, fit: BoxFit.cover)
                                : Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 50, horizontal: 70),
                                    child: Center(
                                        child: CircularProgressIndicator()))),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              gradient: new LinearGradient(
                                end: const Alignment(0.0, 0.3),
                                begin: const Alignment(0.0, -1),
                                colors: <Color>[
                                  const Color(0x8A000000),
                                  Colors.black12.withOpacity(0.0)
                                ],
                              ),
                            ),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 15, top: 10),
                                  child: Image.asset(
                                    'assets/icons/down.png',
                                    width: 14,
                                  ),
                                )),
                          ),
                        ),
                        // bottom grey shadow
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            // margin: EdgeInsets.only(top:MediaQuery.of(context).size.height* 1.12),
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                // topRight: Radius.circular(0),
                                bottomRight: Radius.circular(20),
                              ),
                              gradient: new LinearGradient(
                                end: const Alignment(0.0, -1),
                                begin: const Alignment(0.0, 0.9),
                                colors: <Color>[
                                  const Color(0x8A000000),
                                  Colors.black12.withOpacity(0.0)
                                ],
                              ),
                            ),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 20, top: 10),
                                  child: Text(
                                    messageDate(
                                        DateTime.now().millisecondsSinceEpoch),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget renderMessageSendAtDay(Message message, int index) {
    if (index == _contactController.selectedChat!.messages.length - 1) {
      return getLabelDay(message.sendAt);
    }
    final lastMessageSendAt = new DateTime.fromMillisecondsSinceEpoch(
        _contactController.selectedChat!.messages[index + 1].sendAt!);
    final messageSendAt =
        new DateTime.fromMillisecondsSinceEpoch(message.sendAt!);
    final formatter = UtilDates.formatDay;
    String formattedLastMessageSendAt = formatter.format(lastMessageSendAt);
    String formattedMessageSendAt = formatter.format(messageSendAt);
    if (formattedLastMessageSendAt != formattedMessageSendAt) {
      return getLabelDay(message.sendAt);
    }
    return Container();
  }

  Widget getLabelDay(int? milliseconds) {
    String day = UtilDates.getSendAtDay(milliseconds);
    return Column(
      children: <Widget>[
        SizedBox(
          height: 4,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(0xFFC0CBFF),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            child: Text(
              day,
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          height: 7,
        ),
      ],
    );
  }

  String messageDate(int milliseconds) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return format.format(date);
  }

  String messageTime(int milliseconds) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateFormat("m:s").format(date);
  }

  String paymentDate(int milliseconds) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateFormat("MMM yy").format(date);
  }

  Future<bool?> showDeleteConfirmationDialog() async => await showDialog(
      builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Dialog(
                insetPadding: EdgeInsets.only(left: 20, right: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 5),
                      child: CustomText(
                          'Are you sure you want to decline the request?',
                          color: AppTheme.tomato,
                          bold: FontWeight.w500,
                          size: 18,
                          centerAlign: true),
                    ),
                    /* CustomText(
                      'Delete entry will change your balance.',
                      size: 16,
                    ),*/
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: AppTheme.electricBlue,
                                ),
                                child: CustomText(
                                  'CANCEL',
                                  color: Colors.white,
                                  size: (18),
                                  bold: FontWeight.w500,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: AppTheme.electricBlue,
                                ),
                                child: CustomText(
                                  'CONFIRM',
                                  color: Colors.white,
                                  size: (18),
                                  bold: FontWeight.w500,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              20.0.heightBox,
            ],
          ),
      barrierDismissible: false,
      context: context);
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 5),
      color: AppTheme.paleGrey,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.045, vertical: 2),
        child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(AppAssets.tabMiddleLine),
                fit: BoxFit.fitWidth,
              ),
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: _tabBar),
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class DurationState {
  DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  }) : percentage = progress.inSeconds / (total?.inSeconds ?? 1);
  final Duration progress;
  final Duration buffered;
  final Duration? total;
  final double percentage;
}
