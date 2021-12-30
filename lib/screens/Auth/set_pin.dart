import 'package:flutter/material.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import '../Components/extensions.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';

class SetPinScreen extends StatefulWidget {
  final bool showConfirmPinState;
  final String tempPin;
  final bool isResetPinState;
  final bool isRegister;

  const SetPinScreen(
      {Key? key,
      required this.showConfirmPinState,
      required this.tempPin,
      required this.isResetPinState,
      required this.isRegister})
      : super(key: key);

  @override
  _SetPinScreenState createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final ValueNotifier<String> pinNotifier = ValueNotifier('');
  final ValueNotifier<String> setPinNotifier = ValueNotifier('');
  final ValueNotifier<String> confirmPinNotifier = ValueNotifier('');
  final Repository _repository = Repository();
  // final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool showError = false;

  @override
  void dispose() {
    setPinNotifier.dispose();
    confirmPinNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // _authenticate();
    super.initState();
  }

  /*  void _authenticate() async {
    try {
      final biometricList = await _localAuthentication.getAvailableBiometrics();
      if (biometricList.length != 0) {
        final canCheckBiometrics =
            await _localAuthentication.canCheckBiometrics;
        if (canCheckBiometrics) {
          final _isAuthenticated =
              await _localAuthentication.authenticateWithBiometrics(
                  localizedReason: 'Scan your fingerprint to authenticate',
                  useErrorDialogs: true,
                  stickyAuth: true);
          if (_isAuthenticated)
            Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paleGrey,
      body: Container(
        height: deviceHeight,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
            color: Color(0xfff2f1f6),
            image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/images/back2.png'),
                alignment: Alignment.topCenter)),
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                (MediaQuery.of(context).padding.top + 15).heightBox,
                Image.asset(
                  'assets/images/logo.png',
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.33,
                ),
                CustomText(
                  'Track. Remind. Pay.',
                  size: 18,
                  bold: FontWeight.w500,
                  color: Colors.white,
                ),
                (deviceHeight * 0.04).heightBox,
                if (!widget.showConfirmPinState)
                  ValueListenableBuilder<String>(
                      valueListenable: setPinNotifier,
                      builder: (context, value, _) {
                        return Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              // SizedBox(
                              //   height: 7,
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(AppAssets.lock1Icon),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Set PIN',
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // pinBox(value.length > 0),
                                  PinField(
                                      showError: showError,
                                      isFilled: value.length > 0,
                                      isSetField: true),
                                  PinField(
                                      showError: showError,
                                      isFilled: value.length > 1,
                                      isSetField: true),
                                  PinField(
                                      showError: showError,
                                      isFilled: value.length > 2,
                                      isSetField: true),
                                  PinField(
                                      showError: showError,
                                      isFilled: value.length > 3,
                                      isSetField: true),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ]);
                      }),
                if (!widget.showConfirmPinState)
                  SizedBox(
                    height: 10,
                  ),
                if (widget.showConfirmPinState)
                  ValueListenableBuilder<String>(
                      valueListenable: confirmPinNotifier,
                      builder: (context, value, _) {
                        return Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(AppAssets.lock1Icon),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Confirm PIN',
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // pinBox(value.length > 0),
                                  PinField(
                                      showError: showError,
                                      isFilled: value.length > 0,
                                      isSetField: false),
                                  PinField(
                                      showError: showError,
                                      isFilled: value.length > 1,
                                      isSetField: false),
                                  PinField(
                                      showError: showError,
                                      isFilled: value.length > 2,
                                      isSetField: false),
                                  PinField(
                                      showError: showError,
                                      isFilled: value.length > 3,
                                      isSetField: false),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ]);
                      }),
                (deviceHeight * 0.07).heightBox,
                showError && widget.showConfirmPinState
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          alignment: Alignment.center,
                          child: CustomText(
                            'Incorrect PIN. Enter again',
                            size: 16,
                            color: AppTheme.brownishGrey,
                            bold: FontWeight.w600,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: CustomText(
                            '',
                            size: 16,
                            color: AppTheme.brownishGrey,
                            bold: FontWeight.w600,
                          ),
                        ),
                      ),
                Image.asset(
                  widget.showConfirmPinState
                      ? AppAssets.confirmpinImage
                      : AppAssets.setpinImage,
                  height: deviceHeight * 0.3,
                ),
                Spacer(),
                // keyBoard()
              ],
            ),
            Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .7,
                ),
                height: MediaQuery.of(context).size.height * .3,
                color: AppTheme.paleGrey,
                alignment: Alignment.bottomCenter,
                child: keyBoard()),
          ],
        ),
      ),
    );
  }

  Widget keyBoard() {
    return SingleChildScrollView(
      child: Column(
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
      ),
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

  Future<void> inputTextToField(String str) async {
    if (!widget.showConfirmPinState) {
      if (setPinNotifier.value.length < 4) {
        setPinNotifier.value = setPinNotifier.value + str;
        if (setPinNotifier.value.length == 4) {
          Navigator.of(context).pushNamed(AppRoutes.setPinRoute,
              arguments: SetPinRouteArgs(setPinNotifier.value, true,
                  widget.isResetPinState, widget.isRegister));
        }
      }
    } else {
      if (confirmPinNotifier.value.length < 4) {
        confirmPinNotifier.value = confirmPinNotifier.value + str;
        if (confirmPinNotifier.value.length == 4) {
          if (widget.tempPin == confirmPinNotifier.value) {
            _repository.hiveQueries.insertUserPin(confirmPinNotifier.value);
            _repository.hiveQueries.setPinStatus(true);
            _repository.hiveQueries.setFingerPrintStatus(true);
            if (widget.showConfirmPinState && widget.isResetPinState) {
              'Pin Reset Successful'.showSnackBar(context);
              await Future.delayed(Duration(seconds: 1));
            }
            Navigator.of(context)
              ..pop()
              ..pop();
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            Navigator.of(context).pushNamed(widget.isRegister
                ? AppRoutes.welcomeuserRoute
                : AppRoutes.mainRoute);
            // Navigator.of(context).pushNamed(AppRoutes.introscreenRoute, arguments: IntroRouteArgs(widget.isRegister));
          } else {
            Future.delayed(Duration(milliseconds: 300), () {
              confirmPinNotifier.value = '';
              setState(() {
                showError = true;
              });
              // Navigator.of(context).pushReplacementNamed(AppRoutes.welcomescreenRoute);
            });
          }
        }
      }
    }
  }

  void deleteText() {
    if (showError)
      setState(() {
        showError = false;
      });
    if (confirmPinNotifier.value.length != 0) {
      confirmPinNotifier.value = confirmPinNotifier.value
          .substring(0, confirmPinNotifier.value.length - 1);
    } else if (setPinNotifier.value.length != 0) {
      setPinNotifier.value =
          setPinNotifier.value.substring(0, setPinNotifier.value.length - 1);
    }
  }
}

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

class PinField extends StatelessWidget {
  const PinField({
    Key? key,
    required this.showError,
    required this.isFilled,
    required this.isSetField,
  }) : super(key: key);

  final bool showError;

  ///
  final bool isFilled;
  final bool isSetField;

  ///

  @override
  Widget build(BuildContext context) => Padding(
        // padding: const EdgeInsets.only(left: 15.0, right: 15),
        padding: EdgeInsets.all(10),
        child: new Container(
          height: 60,
          width: 50,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border.all(width: 2.0, color: Colors.white),
              borderRadius: new BorderRadius.circular(7)),
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isFilled ? AppTheme.brownishGrey : Colors.white),
          ),
        ),
        // child: Column(
        //   children: [
        //     // CustomText(
        //     //   isFilled ? '*' : '',
        //     //   size: 30,
        //     //   color: AppTheme.brownishGrey,
        //     // ),
        //     10.0.heightBox,
        //     Container(
        //       height: 20,
        //       width: 20,
        //       decoration: BoxDecoration(
        //           color: isFilled ? AppTheme.brownishGrey : Colors.white,
        //           borderRadius: BorderRadius.circular(15)),
        //     ),
        //     10.0.heightBox,
        //     Container(
        //       color: showError && !isSetField
        //           ? AppTheme.tomato
        //           : AppTheme.brownishGrey,
        //       height: 3,
        //       width: 30,
        //     )
        //   ],
        // ),
      );
}
