import 'package:flutter/material.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';

class PinCheckScreen extends StatefulWidget {
  final bool? fromPinSetupScreen;

  const PinCheckScreen({Key? key, this.fromPinSetupScreen}) : super(key: key);
  @override
  _PinCheckScreenState createState() => _PinCheckScreenState();
}

class _PinCheckScreenState extends State<PinCheckScreen> {
  final ValueNotifier<String> pinNotifier = ValueNotifier('');
  final GlobalKey<State> key = GlobalKey<State>();
  double viewInsetsBottom = 0.0;
  double height = deviceHeight - appBarHeight;
  bool isHightSubtracted = false;
  final Repository repository = Repository();
  int incorrectPinCount = 0;
  late DateTime? pinTime;
  late DateTime? tempTime;
  int secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    pinTime = repository.hiveQueries.pinTimes.first;
    tempTime = repository.hiveQueries.pinTimes.last;
    if (pinTime != null) {
      final sec = DateTime.now().difference(pinTime!).inSeconds;
      // debugPrint(sec.toString());
      if (sec < 1800) {
        secondsRemaining = 1800 - sec;
        incorrectPinCount = 4;
      } else if (sec >= 1800) {
        incorrectPinCount = 0;
        pinTime = null;
        tempTime = null;
        repository.hiveQueries.insertIncorrectPinTime([null, null]);
      }
    }
  }

  @override
  void dispose() {
    pinNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    if (!isHightSubtracted) {
      height = height - MediaQuery.of(context).viewPadding.top;
      isHightSubtracted = true;
    }
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      appBar: AppBar(
          title: CustomText('PIN Setup'),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 22,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          )),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.none,
              height: height * 0.3,
              width: double.infinity,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(AppAssets.backgroundImage2),
                      alignment: Alignment.topCenter)),
            ),
            Column(
              children: <Widget>[
                (height * 0.07).heightBox,
                ValueListenableBuilder<String>(
                    valueListenable: pinNotifier,
                    builder: (context, value, _) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          height: height * 0.13,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(AppAssets.lockIcon),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'Enter Urban Ledger PIN'.toUpperCase(),
                                      style: TextStyle(
                                          color: AppTheme.brownishGrey,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    PinField(
                                      isFilled: value.length > 0,
                                    ),
                                    PinField(
                                      isFilled: value.length > 1,
                                    ),
                                    PinField(
                                      isFilled: value.length > 2,
                                    ),
                                    PinField(
                                      isFilled: value.length > 3,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                              ]),
                        ),
                      );
                    }),
                (height * 0.12).heightBox,
                incorrectPinCount > 0
                    ? Column(
                        children: [
                          CustomText(
                            incorrectPinCount > 3
                                ? 'Too many incorrect attempts.'
                                : 'Wrong PIN. ${4 - incorrectPinCount} attempts left',
                            size: 16,
                            bold: FontWeight.w400,
                            color: AppTheme.brownishGrey,
                          ),
                          if (incorrectPinCount > 3)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  'Please try again in ',
                                  size: 16,
                                  bold: FontWeight.w400,
                                  color: AppTheme.brownishGrey,
                                ),
                                CountDownTimer(
                                  secondsRemaining: secondsRemaining,
                                  countDownTimerStyle: TextStyle(),
                                  whenTimeExpires: () {
                                    incorrectPinCount = 0;
                                    pinTime = null;
                                    tempTime = null;
                                    repository.hiveQueries
                                        .insertIncorrectPinTime(
                                            [pinTime, tempTime]);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          10.0.heightBox,
                          TextButton(
                              onPressed: () async {
                                CustomLoadingDialog.showLoadingDialog(context);
                                final token = await repository.changePinApi
                                    .changePinRequest();
                                Navigator.of(context).popAndPushNamed(
                                    AppRoutes.changePinVerification,
                                    arguments: ChangePinVArgs(token, true));
                              },
                              child: CustomText(
                                'FORGOT PIN?',
                                size: 16,
                                bold: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ))
                        ],
                      )
                    : Image.asset(
                        AppAssets.pinClipartImage,
                        height: height * 0.3,
                      ),
                Spacer(),
                if (incorrectPinCount < 4)
                  Container(
                    child: keyBoard(),
                    height: height * 0.32,
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget keyBoard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            keyBoardButton('1'),
            keyBoardButton('2'),
            keyBoardButton('3')
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            keyBoardButton('4'),
            keyBoardButton('5'),
            keyBoardButton('6')
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            keyBoardButton('7'),
            keyBoardButton('8'),
            keyBoardButton('9')
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MaterialButton(
              onPressed: () {},
            ),
            keyBoardButton('0'),
            MaterialButton(
                shape: CircleBorder(),
                onPressed: () {
                  deleteText();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/icons/Delete_Back-01.png',
                      width: 25.0, height: 25.0),
                )),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
      ],
    );
  }

  Widget keyBoardButton(String number) => MaterialButton(
        shape: CircleBorder(),
        splashColor: AppTheme.buttonSplashGrey,
        onPressed: () {
          inputTextToField(number);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(number,
              style: TextStyle(
                  color: AppTheme.brownishGrey,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center),
        ),
      );

  Widget pinBox(bool value) => Padding(
        padding: EdgeInsets.all(22),
        child: new Container(
            height: 20,
            width: 20,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
                color: Colors.white,
                border: new Border.all(width: 2.0, color: Colors.white),
                borderRadius: new BorderRadius.circular(20)),
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: value ? AppTheme.brownishGrey : Colors.white),
            )),
      );

  void inputTextToField(String str) async {
    if (pinNotifier.value.length <= 4) {
      pinNotifier.value = pinNotifier.value + str;
    }
    if (pinNotifier.value.length == 4) {
      if (repository.hiveQueries.userPin == pinNotifier.value) {
        if (widget.fromPinSetupScreen != null) {
          if (widget.fromPinSetupScreen!) {
            Navigator.of(context).pop(true);
            return;
          }
        }
        Navigator.of(context)..pop();
        Navigator.of(context).pushNamed(AppRoutes.setNewPinRoute,
            arguments: SetPinRouteArgs('', false, false, false));
      } else {
        await Future.delayed(Duration(milliseconds: 200));
        setState(() {
          incorrectPinCount++;
          if (incorrectPinCount == 4) {
            pinTime = DateTime.now();
            tempTime = pinTime;
            tempTime = tempTime!.add(Duration(minutes: 30));
            secondsRemaining = tempTime!.difference(pinTime!).inSeconds;
            repository.hiveQueries.insertIncorrectPinTime([pinTime, tempTime]);
            setState(() {});
          }
        });
        pinNotifier.value = '';
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text('Please recheck your pin and try again.'),
        // ));
      }
    }
  }

  void deleteText() {
    if (pinNotifier.value.length != 0) {
      pinNotifier.value =
          pinNotifier.value.substring(0, pinNotifier.value.length - 1);
    }
  }
}

class PinField extends StatelessWidget {
  const PinField({
    Key? key,
    required this.isFilled,
  }) : super(key: key);

  final bool isFilled;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Column(
          children: [
            // CustomText(
            //   isFilled ? '*' : '',
            //   size: 30,
            //   color: AppTheme.brownishGrey,
            // ),
            10.0.heightBox,
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color: isFilled ? AppTheme.brownishGrey : Colors.white,
                  borderRadius: BorderRadius.circular(15)),
            ),
            10.0.heightBox,
            Container(
              color: AppTheme.brownishGrey,
              height: 3,
              width: 30,
            )
          ],
        ),
      );
}
