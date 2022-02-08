import 'dart:async';
import 'dart:io';
import 'dart:math';

// import 'package:emoji_picker/emoji_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:expandable/expandable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/AddBankAccount/add_bank_account.dart';
import 'package:urbanledger/screens/AddBankAccount/user_bank_account_provider.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/custom_popup.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/screens/TransactionScreens/pay_transaction.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';
import 'package:vibration/vibration.dart';

class TextFieldWithButton extends StatefulWidget {
  final String? customerId;
  final String? chatId;
  final String? customerName;
  final String? phoneNo;
  final Function onSubmit;
  final TextEditingController textEditingController;
  final Function? onEmojiTap;
  final bool showEmojiKeyboard;
  final BuildContext context;
  final Function(
      double amount,
      String? details,
      String? fileName,
      String? fileSize,
      String? duration,
      int paymentType)? sendMessage;
  final Function(String? contactName, String? contactNo, int messageType)?
      sendContact;
  final Function audioImm;
  final Function(bool status, File? url) galleryAttachment;
  final Function documentAttachment;
  final Function(bool status, File? url) cameraAttachmentFn;
  TextFieldWithButton({
    required this.customerId,
    this.chatId,
    required this.customerName,
    required this.phoneNo,
    required this.context,
    required this.textEditingController,
    required this.onSubmit,
    this.onEmojiTap,
    this.showEmojiKeyboard = false,
    this.sendMessage,
    this.sendContact,
    required this.audioImm,
    required this.galleryAttachment,
    required this.documentAttachment,
    required this.cameraAttachmentFn,
  });
  @override
  _TextFieldWithButtonState createState() => _TextFieldWithButtonState();
}

class _TextFieldWithButtonState extends State<TextFieldWithButton>
    with SingleTickerProviderStateMixin {
  bool show = false;
  bool showEmoji = false;
  CustomerModel _customerModel = CustomerModel();
  final Repository repository = Repository();
  late File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isRecording = false;
  int _recordDuration = 0;
  int _minuteDuration = 00;
  int _secondDuration = 00;
  Timer? _timer;
  String? path;
  String? uid;
  bool onRecord = false;
  late AnimationController _animationController;
  final GlobalKey<State> key = GlobalKey<State>();

  //mic
  late Animation<double> _micTranslateTop;
  late Animation<double> _micRotationFirst;
  late Animation<double> _micTranslateRight;
  late Animation<double> _micTranslateLeft;
  late Animation<double> _micRotationSecond;
  late Animation<double> _micTranslateDown;
  late Animation<double> _micInsideTrashTranslateDown;

  //trash
  late Animation<double> _trashContainerWithCoverTranlateTop;
  late Animation<double> _trashCoverRotationFirst;
  late Animation<double> _trashCoverTranslateLeft;
  late Animation<double> _trashCoverRotationSecond;
  late Animation<double> _trashCoverTranslateRight;
  late Animation<double> _trashContainerWithCoverTranlateDown;
  bool isLoading = false;
  bool isEmiratesIdDone = false;
  bool isTradeLicenseDone = false;
  bool kycStatus = false;
  bool isPremium = false;
  bool isNotAccount = false;

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

  modalSheet() {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          return Container(
            color: Color(0xFF737373), //could change this to Color(0xFF737373),
            height: (kycStatus == true)
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
                    child: (kycStatus == true && isPremium == false)
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
                  if (kycStatus == false)
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
                  if (kycStatus == false)
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

  @override
  void initState() {
    _image = null;
    _isRecording = false;
    imageCache!.clear();
    widget.textEditingController.clear();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4500),
    );
    _micTranslateTop = Tween(begin: 0.0, end: -150.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.25, curve: Curves.easeOut)));
    _micRotationFirst = Tween(begin: 0.0, end: pi).animate(CurvedAnimation(
        parent: _animationController, curve: Interval(0.0, 0.15)));
    _micTranslateRight = Tween(begin: 0.0, end: 13.0).animate(CurvedAnimation(
        parent: _animationController, curve: Interval(0.0, 0.05)));
    _micTranslateLeft = Tween(begin: 0.0, end: -13.0).animate(CurvedAnimation(
        parent: _animationController, curve: Interval(0.1, 0.15)));
    _micRotationSecond = Tween(begin: 0.0, end: pi).animate(CurvedAnimation(
        parent: _animationController, curve: Interval(0.2, 0.35)));
    _micTranslateDown = Tween(begin: 0.0, end: 150.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.35, 0.48, curve: Curves.easeInOut)));
    _micInsideTrashTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.80, 0.8, curve: Curves.easeInOut)));
    _trashContainerWithCoverTranlateTop = Tween(begin: 45.0, end: -3.0).animate(
        CurvedAnimation(
            parent: _animationController, curve: Interval(0.30, 0.35)));
    _trashCoverRotationFirst = Tween(begin: 0.0, end: -pi / 3).animate(
        CurvedAnimation(
            parent: _animationController, curve: Interval(0.35, 0.40)));
    _trashCoverTranslateLeft = Tween(begin: 0.0, end: -18.0).animate(
        CurvedAnimation(
            parent: _animationController, curve: Interval(0.40, 0.45)));
    _trashCoverRotationSecond = Tween(begin: 0.0, end: pi / 3).animate(
        CurvedAnimation(
            parent: _animationController, curve: Interval(0.50, 0.60)));
    _trashCoverTranslateRight = Tween(begin: 0.0, end: 18.0).animate(
        CurvedAnimation(
            parent: _animationController, curve: Interval(0.6, 0.7)));
    _trashContainerWithCoverTranlateDown = Tween(begin: 0.0, end: 55.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.8, 0.85, curve: Curves.easeInOut)));
    super.initState();
    dat();
    //getKyc();
    //getRecentBankAcc();
  }

  dat() {
    uid = widget.customerId.toString();
    debugPrint('cust id ' + widget.customerId.toString());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    // widget.textEditingController.clear();
    super.dispose();
  }

  // void onEmojiSelected(Emoji emoji) {
  //
  //   widget.textEditingController.text += emoji.text;
  //   if(widget.textEditingController.text.length > 0){
  //     setState(() {
  //       show = true;
  //     });
  //
  //   }
  // }

  void clearText() => widget.textEditingController.text = '';

  Future<void> _start() async {
    try {
      if (await Record.hasPermission()) {
        final documentDirectory = Platform.isIOS
            ? await getApplicationDocumentsDirectory()
            : await getExternalStorageDirectory();
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        path = documentDirectory!.path + '/$fileName.aac';
        await Record.start(path: path.toString(), encoder: AudioEncoder.AAC);
        bool isRecording = await Record.isRecording();
        if (isRecording) {
          Vibration.vibrate(amplitude: 128, duration: 250);
        }
        setState(() {
          // _isRecording = isRecording;
          debugPrint(_isRecording.toString());
          _minuteDuration = 0;
          _recordDuration = 0;
          _secondDuration = 0;
        });
        _startTimer();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    await Record.stop();
    await Record.stop();
    setState(() {
      _isRecording = false;
      // onRecord = false;
    });
    // _sendAudio();
  }

  Future<void> _sendAudio() async {
    final fileSize = await getFileSize(path.toString());
    final fileName = path!.lastSplit('/').toString();
    debugPrint('CCCC' + path!.lastSplit('/').toString());
    debugPrint('0${_minuteDuration.toString()}:${_secondDuration.toString()}');
    String _second = _secondDuration.toString().length == 1 ? '0$_secondDuration':'$_secondDuration';
    final uploadApiResponse =
        await repository.ledgerApi.uploadAttachment(path.toString());
    widget.sendMessage!(
         0.0,
         uploadApiResponse,
         fileName,
         fileSize,
         '0${_minuteDuration.toString()}' +':' + '${_second.toString()}',
         10);
  }

  void _startTimer() {
    const tick = const Duration(seconds: 1);
    _timer?.cancel();
    _timer = Timer.periodic(tick, (Timer t) {
      setState(() {
        _recordDuration++;
        _secondDuration++;
        if (_recordDuration == 119) {
          _minuteDuration = 0;
          _secondDuration = 0;
          _stop();
        }
        if (_recordDuration == 59) {
          _minuteDuration = 1;
          _secondDuration = 1;
        }
        debugPrint(_recordDuration.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    buildBottomSheetAttachment() {
      return Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: Offset(0, -15), // changes position of shadow
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.only(bottom: 8.0),
                child: Image.asset(
                  'assets/icons/handle.png',
                  scale: 1.5,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (!(await Permission.storage.isGranted)) {
                        final status = await Permission.storage.request();
                        if (status != PermissionStatus.granted) return;
                      }
                      final result = await (FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        withData: true,
                        withReadStream: true,
                        allowCompression: true,
                        allowMultiple: true,
                        allowedExtensions: ['pdf', 'doc', 'docx'],
                      ));
                      String path = result!.paths
                          .toString()
                          .replaceAll(']', '')
                          .replaceAll('[', '');
                      var fileName = (path.split('.').last);
                      print('filePath ${result.paths}');
                      if (result.count <= 5) {
                        for (var item in result.paths) {
                          if ((await File(item!).length()) <= 10000000) {
                            switch (fileName) {
                              case 'pdf':
                                final fileSize = await getFileSize(item);
                                final fileName = path.lastSplit('/').toString();
                                debugPrint(
                                    'CCCC' + path.lastSplit('/').toString());
                                widget.documentAttachment(true);
                                final uploadApiResponse = await repository
                                    .ledgerApi
                                    .uploadAttachment(item);
                                widget.sendMessage!(0.0, uploadApiResponse,
                                    fileName, fileSize,'00:00', 7);
                                break;
                              case 'doc':
                                final fileSize = await getFileSize(item);
                                final fileName = path.lastSplit('/').toString();
                                debugPrint(
                                    'CCCC' + path.lastSplit('/').toString());
                                final uploadApiResponse = await repository
                                    .ledgerApi
                                    .uploadAttachment(item);
                                widget.sendMessage!(0.0, uploadApiResponse,
                                    fileName, fileSize,'00:00', 8);
                                break;
                              case 'docx':
                                final fileSize = await getFileSize(item);
                                final fileName = path.lastSplit('/').toString();
                                debugPrint(
                                    'CCCC' + path.lastSplit('/').toString());
                                final uploadApiResponse = await repository
                                    .ledgerApi
                                    .uploadAttachment(item);
                                widget.sendMessage!(0.0, uploadApiResponse,
                                    fileName, fileSize,'00:00', 8);
                                break;
                              // case 'xls':
                              //   debugPrint(fileName);
                              //   final uploadApiResponse =
                              //       await repository.ledgerApi.uploadAttachment(path);
                              //   // print(uploadApiResponse);
                              //   widget.sendMessage!(0.0, uploadApiResponse, 9);
                              //   break;
                              // case 'csv':
                              //   debugPrint(fileName);
                              //   final uploadApiResponse =
                              //       await repository.ledgerApi.uploadAttachment(path);
                              //   // print(uploadApiResponse);
                              //   widget.sendMessage!(0.0, uploadApiResponse, 9);
                              //   break;
                              default:
                                break;
                            }
                          } else {
                            'Document you tried to adding is larger than the 10 MB limit.'
                                .showSnackBar(context);
                          }
                        }
                      } else {
                        "Can't share more than 5 media items."
                            .showSnackBar(context);
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppAssets.documentIcon,
                          height: 40,
                        ),
                        Text(
                          'Document',
                          style:
                              TextStyle(color: Color(0xff666666), fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (!(await Permission.storage.isGranted)) {
                        final status = await Permission.storage.request();
                        if (status != PermissionStatus.granted) return;
                      }
                      final result = await (FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowMultiple: true,
                        allowedExtensions: ['png', 'jpg', 'jpeg'],
                      ));
                      var path = result!.paths
                          .toString()
                          .replaceAll(']', '')
                          .replaceAll('[', '');
                      var fileName = (path.split('.').last);
                      if (result.count <= 5) {
                        for (var item in result.paths) {
                          if ((await File(item!).length()) <= 10000000) {
                            switch (fileName) {
                              case 'png':
                                final fileSize = await getFileSize(item);
                                final fileName = path.lastSplit('/').toString();
                                debugPrint(
                                    'CCCC' + path.lastSplit('/').toString());
                                widget.galleryAttachment(true, File(item));
                                debugPrint(fileName);
                                final uploadApiResponse = await repository
                                    .ledgerApi
                                    .uploadAttachment(item);
                                debugPrint(uploadApiResponse);
                                widget.sendMessage!(0.0, uploadApiResponse,
                                    fileName, fileSize,'00:00', 6);
                                break;
                              case 'jpg':
                                final fileSize = await getFileSize(item);
                                final fileName = path.lastSplit('/').toString();
                                debugPrint(
                                    'CCCC' + path.lastSplit('/').toString());
                                widget.galleryAttachment(true, File(item));
                                debugPrint(fileName);
                                final uploadApiResponse = await repository
                                    .ledgerApi
                                    .uploadAttachment(item);
                                debugPrint(uploadApiResponse);
                                widget.sendMessage!(0.0, uploadApiResponse,
                                    fileName, fileSize,'00:00', 6);
                                break;
                              case 'jpeg':
                                final fileSize = await getFileSize(item);
                                final fileName = path.lastSplit('/').toString();
                                debugPrint(
                                    'CCCC' + path.lastSplit('/').toString());
                                widget.galleryAttachment(true, File(item));
                                debugPrint(fileName);
                                final uploadApiResponse = await repository
                                    .ledgerApi
                                    .uploadAttachment(item);
                                widget.sendMessage!(0.0, uploadApiResponse,
                                    fileName, fileSize,'00:00', 6);
                                break;
                              default:
                                break;
                            }
                          } else {
                            'Document you tried to adding is larger than the 10 MB limit.'
                                .showSnackBar(context);
                          }
                        }
                      } else {
                        "Can't share more than 5 media items."
                            .showSnackBar(context);
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppAssets.galleryIcon,
                          height: 40,
                        ),
                        Text(
                          'Gallery',
                          style:
                              TextStyle(color: Color(0xff666666), fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (!(await Permission.camera.isGranted)) {
                        final status = await Permission.camera.request();
                        if (status != PermissionStatus.granted) return;
                      }
                      cameraAttachment();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppAssets.cameraIcon01,
                          height: 40,
                        ),
                        Text(
                          'Camera',
                          style:
                              TextStyle(color: Color(0xff666666), fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          AppRoutes.contactListRoute,
                          arguments: ContactListRouteArgs(
                              widget.phoneNo,
                              widget.customerName,
                              widget.customerId,
                              widget.chatId,
                              widget.sendContact));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppAssets.contactIcon,
                          height: 40,
                        ),
                        Text(
                          'Contact',
                          style:
                              TextStyle(color: Color(0xff666666), fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
            ],
          ));
    }

    return ExpandableNotifier(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expandable(
            expanded: buildBottomSheetAttachment(),
            collapsed: Container(),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: Offset(0, -15), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (onRecord == false)
                      Platform.isIOS
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                if (showEmoji == false) {
                                  setState(() {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    showEmoji = true;
                                  });
                                } else {
                                  setState(() {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    showEmoji = false;
                                    // return MediaQuery.of(context).viewInsets.bottom ==0.0;
                                  });
                                }

                                // widget.onEmojiTap(widget.showEmojiKeyboard);
                              },
                              child: Image.asset(
                                AppAssets.smileyIcon,
                                height: 28,
                              )),
                    SizedBox(
                      width: 5,
                    ),
                    if (onRecord == false)
                      Expanded(
                        child: Container(
                          padding: Platform.isIOS
                              ? EdgeInsets.only(left: 5, right: 5)
                              : EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color.fromRGBO(239, 246, 253, 1),
                            border: Border.all(
                              width: 1,
                              color: Color(0xFFDDDDDD),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Scrollbar(
                                  child: TextField(
                                    maxLines: 5,
                                    minLines: 1,
                                    style: TextStyle(fontSize: 18),
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    cursorColor: AppTheme.electricBlue,
                                    controller: widget.textEditingController,
                                    onSubmitted: (_) {
                                      widget.onSubmit();
                                    },
                                    onChanged: (String value) async {
                                      setState(() {
                                        if (value.length > 0) {
                                          show = true;
                                        } else {
                                          show = false;
                                        }
                                      });
                                    },
                                    onTap: () {
                                      // if (widget.showEmojiKeyboard) {
                                      //   widget.onEmojiTap(
                                      //       widget.showEmojiKeyboard);
                                      // }
                                      setState(() {
                                        showEmoji = false;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      // suffixIcon: Icon(Icons.add),
                                      contentPadding: EdgeInsets.symmetric(
                                        // horizontal: 5,
                                        vertical: 5,
                                      ),
                                      hintText: 'Type here...',
                                      hintStyle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Builder(
                                builder: (context) {
                                  var controller = ExpandableController.of(
                                      context,
                                      required: true)!;
                                  return GestureDetector(
                                    child: Image.asset(
                                      AppAssets.attachIcon,
                                      height: 18,
                                      // ),
                                    ),
                                    onTap: () {
                                      controller.toggle();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (onRecord == true)
                      Expanded(
                        child: Scrollbar(
                          child: Container(
                            height: 38.0,
                            // color: Color.fromRGBO(239, 246, 253, 1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color.fromRGBO(239, 246, 253, 1),
                              border: Border.all(
                                width: 1,
                                color: Color(0xFFDDDDDD),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, bottom: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          AnimatedBuilder(
                                            animation: _animationController,
                                            builder: (context, child) {
                                              return Transform(
                                                transform: Matrix4.identity()
                                                  // ..translate(0.0, 9.9)
                                                  ..translate(0.0,
                                                      _micTranslateTop.value)
                                                  ..translate(
                                                      _micTranslateRight.value)
                                                  ..translate(
                                                      _micTranslateLeft.value)
                                                  ..translate(0.0,
                                                      _micTranslateDown.value)
                                                  ..translate(
                                                      0.0,
                                                      _micInsideTrashTranslateDown
                                                          .value),
                                                child: Transform.rotate(
                                                  angle:
                                                      _micRotationFirst.value,
                                                  child: Transform.rotate(
                                                    angle: _micRotationSecond
                                                        .value,
                                                    child: child,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 3),
                                                child: Image.asset(
                                                  AppAssets.recordingIcon,
                                                  height: 20.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: AnimatedBuilder(
                                        animation:
                                            _trashContainerWithCoverTranlateTop,
                                        builder: (context, child) {
                                          return Transform(
                                            transform: Matrix4.identity()
                                              ..translate(
                                                  0.0,
                                                  _trashContainerWithCoverTranlateTop
                                                      .value)
                                              ..translate(
                                                  0.0,
                                                  _trashContainerWithCoverTranlateDown
                                                      .value),
                                            child: child,
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            AnimatedBuilder(
                                              animation:
                                                  _trashCoverRotationFirst,
                                              builder: (context, child) {
                                                return Transform(
                                                    transform: Matrix4
                                                        .identity()
                                                      ..translate(
                                                          _trashCoverTranslateLeft
                                                              .value)
                                                      ..translate(
                                                          _trashCoverTranslateRight
                                                              .value),
                                                    child: Transform.rotate(
                                                        angle:
                                                            _trashCoverRotationSecond
                                                                .value,
                                                        child: Transform.rotate(
                                                          angle:
                                                              _trashCoverRotationFirst
                                                                  .value,
                                                          child: child,
                                                        )));
                                              },
                                              child: Image.asset(
                                                AppAssets.trashCoverIcon,
                                                width: 22,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 1.5),
                                              child: Image.asset(
                                                AppAssets.trashContainerIcon,
                                                width: 22,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 45, top: 7),
                                      child: Text(
                                        '0${_minuteDuration.toString()}:${_secondDuration.toString()}',
                                        style: TextStyle(
                                            color: AppTheme.coolGrey,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _animationController.forward();
                                    _timer =
                                        Timer(Duration(milliseconds: 3700), () {
                                      setState(() {
                                        onRecord = false;
                                        Vibration.vibrate(
                                            amplitude: 128, duration: 128);
                                        File file = new File(path.toString());
                                        file.delete();
                                        _animationController.reset();
                                      });
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.touch_app,
                                        color: AppTheme.coolGrey,
                                        size: 16,
                                      ),
                                      Text(
                                        'Tap to cancel',
                                        style:
                                            TextStyle(color: AppTheme.coolGrey),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (show == false)
                      SizedBox(
                        width: 10,
                      ),
                    if (show == false)
                      GestureDetector(
                        onLongPressStart: (value) async {
                          if (!(await Permission.microphone.isGranted)) {
                            final status =
                                await Permission.microphone.request();
                            if (status != PermissionStatus.granted) return;
                          } else {
                            _start();
                            setState(() {
                              onRecord = true;
                            });
                          }
                        },
                        onLongPressEnd: (value) {
                          _stop();
                        },
                        child: Image.asset(
                          AppAssets.micIcon,
                          height: 28,
                        ),
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    if (show == true || onRecord == true)
                      InkWell(
                        onTap: () {
                          if (onRecord == false) {
                            widget.onSubmit();
                            setState(() {
                              show = false;
                            });
                          } else {
                            setState(() {
                              onRecord = false;
                            });
                            _sendAudio();
                            widget.audioImm();
                            Vibration.vibrate(amplitude: 128, duration: 128);
                            _animationController.reset();
                          }
                        },
                        child: Image.asset(
                          AppAssets.sendIcon,
                          height: 28,
                        ),
                      ),
                    if (show == false && onRecord == false)
                      InkWell(
                        onTap: () async {
                          if (!(await Permission.camera.isGranted)) {
                            final status = await Permission.camera.request();
                            if (status != PermissionStatus.granted) return;
                          }
                          cameraAttachment();
                        },
                        child: Image.asset(
                          AppAssets.cameraIcon02,
                          height: 28,
                        ),
                      ),
                    if (show == false)
                      SizedBox(
                        width: 10,
                      ),
                    Material(
                      child: InkWell(
                        onTap: () {
                          displayModalBottomSheet(
                            context,
                            widget.customerName,
                            widget.phoneNo,
                            _customerModel,
                            widget.sendMessage,
                          );
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          child: Image.asset(
                            AppAssets.plusIcon,
                            height: 45,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (showEmoji && !_keyboardIsVisible())
            Container(
              height: MediaQuery.of(context).size.height * 0.32,
              child: EmojiPicker(
                onEmojiSelected: (Category category, Emoji emoji) {
                  final emojiImage = emoji.emoji;
                  debugPrint(emoji.name);
                  widget.textEditingController.text =
                      "${widget.textEditingController.text}$emojiImage";
                  if (widget.textEditingController.text.length > 0) {
                    setState(() {
                      show = true;
                    });
                  }
                },
                config: const Config(
                    columns: 7,
                    emojiSizeMax: 26.0,
                    initCategory: Category.RECENT,
                    bgColor: Color(0xFFF2F2F2),
                    indicatorColor: Colors.blue,
                    iconColor: Colors.grey,
                    iconColorSelected: Colors.blue,
                    progressIndicatorColor: Colors.blue,
                    showRecentsTab: true,
                    recentsLimit: 28,
                    noRecentsText: '',
                    noRecentsStyle:
                        TextStyle(fontSize: 20, color: Colors.black26),
                    categoryIcons:
                        CategoryIcons(symbolIcon: Icons.emoji_symbols),
                    buttonMode: ButtonMode.MATERIAL),
              ),
            ),
          // renderEmojiKeyboard(),
        ],
      ),
    );
  }

  void cameraAttachment() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.cameraAttachmentFn(true, _image);
      }
    });
    final fileSize = await getFileSize(_image!.path);
    final fileName = _image!.path.lastSplit('/').toString();
    debugPrint('sss' + fileSize.toString());
    debugPrint('CCCC' + _image!.path.lastSplit('/').toString());
    final uploadApiResponse =
        await repository.ledgerApi.uploadAttachment(_image!.path);
    widget.sendMessage!(0.0, uploadApiResponse, fileName, fileSize,'00:00', 6);
    _image = null;
  }

  // Widget renderEmojiKeyboard() {
  //   if (widget.showEmojiKeyboard) {
  //     FocusScope.of(context).requestFocus(FocusNode());
  //   }
  //   if (widget.showEmojiKeyboard && !_keyboardIsVisible()) {
  //     // return EmojiPicker(
  //     //   rows: 3,
  //     //   columns: 7,
  //     //   onEmojiSelected: (emoji, category) {
  //     //     final emojiImage = emoji.emoji;
  //     //     widget.textEditingController.text =
  //     //         "${widget.textEditingController.text}$emojiImage";
  //     //   },
  //     // );
  //     return EmojiKeyboard(
  //           column: 10,
  //           onEmojiSelected: onEmojiSelected,
  //         );
  //   }
  //   return Container(width: 0, height: 0);
  // }

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  // showBankAccountDialog() async => await showDialog(
  //     builder: (context) => Dialog(
  //           insetPadding:
  //               EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.75),
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 15.0, bottom: 5),
  //                 child: CustomText(
  //                   "No Bank Account Found.",
  //                   color: AppTheme.tomato,
  //                   bold: FontWeight.w500,
  //                   size: 18,
  //                 ),
  //               ),
  //               CustomText(
  //                 'Please Add Your Bank Account.',
  //                 size: 16,
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     Expanded(
  //                       child: Container(
  //                         margin: EdgeInsets.symmetric(vertical: 10),
  //                         padding: const EdgeInsets.symmetric(horizontal: 10),
  //                         child: RaisedButton(
  //                           padding: EdgeInsets.all(15),
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10)),
  //                           color: AppTheme.electricBlue,
  //                           child: CustomText(
  //                             'Add Account'.toUpperCase(),
  //                             color: Colors.white,
  //                             size: (18),
  //                             bold: FontWeight.w500,
  //                           ),
  //                           onPressed: () {
  //                             Navigator.pop(context, true);
  //                             Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) => AddBankAccount()));
  //                           },
  //                         ),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: Container(
  //                         margin: EdgeInsets.symmetric(vertical: 10),
  //                         padding: const EdgeInsets.symmetric(horizontal: 15),
  //                         child: RaisedButton(
  //                           padding: EdgeInsets.all(15),
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10)),
  //                           color: AppTheme.electricBlue,
  //                           child: CustomText(
  //                             'Not now'.toUpperCase(),
  //                             color: Colors.white,
  //                             size: (18),
  //                             bold: FontWeight.w500,
  //                           ),
  //                           onPressed: () {
  //                             Navigator.of(context).pop(true);
  //                           },
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //     barrierDismissible: false,
  //     context: context);

  displayModalBottomSheet(BuildContext context, String? name, String? phone,
      CustomerModel _customerModel, sendMessage) {
    final GlobalKey<State> key = GlobalKey<State>();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return isLoading == true
            ? Center(child: CircularProgressIndicator())
            : Container(
                height: MediaQuery.of(context).size.height * 0.12,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: Offset(0, -15), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 8),
                      padding: EdgeInsets.only(bottom: 22.0),
                      child: Image.asset(
                        'assets/icons/handle.png',
                        scale: 1.5,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: NewCustomButton(
                            onSubmit: () async {
                              Navigator.of(context).pop(true);
                              CustomLoadingDialog.showLoadingDialog(
                                  context, key);
                              var Cid = await repository.customerApi
                                  .getCustomerID(mobileNumber: phone.toString())
                                  .catchError((e) {
                                Navigator.of(context).pop();
                                'Please check internet connectivity and try again.'
                                    .showSnackBar(context);
                              }).timeout(Duration(seconds: 30),
                                      onTimeout: () async {
                                Navigator.of(context).pop();
                                return Future.value(null);
                              });
                              // debugPrint(widget.contacts[index].mobileNo.toString());
                              // debugPrint(widget.contacts[index].name);
                              bool? merchantSubscriptionPlan =
                                  Cid.customerInfo?.merchantSubscriptionPlan ??
                                      false;
                              debugPrint(Cid.customerInfo?.id.toString());
                              _customerModel
                                ..ulId = Cid.customerInfo?.id
                                ..name = getName(name, phone)
                                ..mobileNo = phone;

                              if (Cid.customerInfo?.id == null) {
                                Navigator.of(context).pop(true);

                                // userNotRegisteredDialog();
                                // showDialog(
                                //   context: context,
                                //   builder: (BuildContext context) {
                                //     return NonULDialog();
                                //   },
                                // );
                                MerchantBankNotAdded.showBankNotAddedDialog(
                                    context, 'userNotRegistered');
                              }
                              // else if (Repository()
                              //         .hiveQueries
                              //         .userData
                              //         .kycStatus ==
                              //     0) {
                              //   Navigator.of(context).pop(true);
                              //   MerchantBankNotAdded.showBankNotAddedDialog(
                              //       context, 'userKYCPending');
                              // }
                              //  else if (Repository()
                              //         .hiveQueries
                              //         .userData
                              //         .kycStatus ==
                              //     2) {
                              //   Navigator.of(context).pop(true);
                              //   await getKyc().then((value) =>
                              //       MerchantBankNotAdded.showBankNotAddedDialog(
                              //           context, 'userKYCVerificationPending'));
                              // }
                              else if (Cid.customerInfo?.bankAccountStatus ==
                                  false) {
                                Navigator.of(context).pop(true);

                                merchantBankNotAddedModalSheet(
                                    text: Constants.merchentKYCBANKPREMNotadd);
                              } else if (Cid.customerInfo?.kycStatus == false) {
                                Navigator.of(context).pop(true);
                                merchantBankNotAddedModalSheet(
                                    text: Constants.merchentKYCBANKPREMNotadd);
                              }
                              // else if (Repository()
                              //             .hiveQueries
                              //             .userData
                              //             .kycStatus ==
                              //         1 &&
                              //     Repository()
                              //             .hiveQueries
                              //             .userData
                              //             .premiumStatus ==
                              //         0) {
                              //   Navigator.of(context).pop(true);
                              //   debugPrint('Checket');
                              //   MerchantBankNotAdded.showBankNotAddedDialog(
                              //       context, 'upgradePremium');
                              // }
                              else if (merchantSubscriptionPlan == false) {
                                Navigator.of(context).pop(true);

                                merchantBankNotAddedModalSheet(
                                    text: Constants.merchentKYCBANKPREMNotadd);
                              } else {
                                // Navigator.of(context).pop(true);
                                // showBankAccountDialog();
                                var anaylticsEvents = AnalyticsEvents(context);
                                await anaylticsEvents.initCurrentUser();
                                await anaylticsEvents.chatPayEvent();
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => PayTransactionScreen(
                                //         model: _customerModel,
                                //         customerId: localCustomerId,
                                //         type: 'DIRECT',
                                //         suspense: false,
                                //         through: 'DIRECT'),
                                //   ),
                                // );
                                Map<String, dynamic> isTransaction =
                                    await repository.paymentThroughQRApi
                                        .getTransactionLimit(context)
                                        .catchError((e) {
                                  Navigator.of(context).pop();
                                  'Please check internet connectivity and try again.'
                                      .showSnackBar(context);
                                });
                                if (!(isTransaction)['isError']) {
                                  Navigator.of(context).pop(true);
                                  // showBankAccountDialog();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PayTransactionScreen(
                                              model: _customerModel,
                                              customerId: widget.customerId!,
                                              type: 'DIRECT',
                                              suspense: false,
                                              through: 'DIRECT'),
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).pop(true);
                                  '${(isTransaction)['message']}'
                                      .showSnackBar(context);
                                }
                              }
                              // Navigator.pushNamed(context, AppRoutes.payTransactionRoute);
                            },
                            text: 'Pay'.toUpperCase(),
                            textColor: Colors.white,
                            backgroundColor: AppTheme.electricBlue,
                            textSize: 15.0,
                            fontWeight: FontWeight.bold,
                            // width: 185,
                            height: 40,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: NewCustomButton(
                            onSubmit: () async {
                              Navigator.of(context).pop(true);
                              // CustomLoadingDialog.showLoadingDialog(
                              //     context, key);
                              // var Cid = await repository.customerApi
                              //     .getCustomerID(
                              //         mobileNumber: phone.toString());
                              // bool? merchantSubscriptionPlan =
                              //     Cid.customerInfo?.merchantSubscriptionPlan ??
                              //         false;
                              // await Provider.of<UserBankAccountProvider>(
                              //         context,
                              //         listen: false)
                              //     .getUserBankAccount();
                              // // debugPrint(widget.contacts[index].mobileNo.toString());
                              // // debugPrint(widget.contacts[index].name);
                              // debugPrint(Cid.customerInfo?.id.toString());
                              _customerModel
                                // ..ulId = Cid.customerInfo?.id
                                ..name = getName(name, phone)
                                ..chatId = widget.chatId
                                ..mobileNo = phone;

                              if (await allChecker(context)) {
                                // Navigator.of(context).pop(true);
                                _customerModel.chatId = widget.chatId;

                                var anaylticsEvents = AnalyticsEvents(context);
                                await anaylticsEvents.initCurrentUser();
                                await anaylticsEvents.chatPayRequestEvent();
                                print(widget.customerId);

                                Navigator.of(context).popAndPushNamed(
                                    AppRoutes.requestTransactionRoute,
                                    arguments: ReceiveTransactionArgs(
                                        _customerModel, widget.customerId!));
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         ReceiveTransactionScreen(
                                //       model: _customerModel,
                                //       customerId: localCustomerId,
                                //     ),
                                //   ),
                                // );
                                debugPrint(uid);
                              }
                            },
                            text: 'Request'.toUpperCase(),
                            textColor: Colors.white,
                            backgroundColor: AppTheme.electricBlue,
                            textSize: 15.0,
                            fontWeight: FontWeight.bold,
                            // width: 185,
                            height: 40,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                ));
      },
    );
  }
}
