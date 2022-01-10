import 'package:flutter/material.dart';
import 'package:urbanledger/Models/login_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/pin_code_strenth.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';

class SetNewPinScreen extends StatefulWidget {
  final bool showConfirmPinState;
  final String tempPin;
  final bool isResetPinState;

  const SetNewPinScreen(
      {Key? key,
      required this.showConfirmPinState,
      required this.tempPin,
      required this.isResetPinState})
      : super(key: key);

  @override
  _SetNewPinScreenState createState() => _SetNewPinScreenState();
}

class _SetNewPinScreenState extends State<SetNewPinScreen> {
  final ValueNotifier<String> setPinNotifier = ValueNotifier('');
  final ValueNotifier<String> confirmPinNotifier = ValueNotifier('');
  double viewInsetsBottom = 0.0;
  double height = deviceHeight - appBarHeight;
  bool isHightSubtracted = false;
  bool showError = false;
  final Repository repository = Repository();

  @override
  void dispose() {
    setPinNotifier.dispose();
    confirmPinNotifier.dispose();
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
                if (!widget.showConfirmPinState)
                  ValueListenableBuilder<String>(
                      valueListenable: setPinNotifier,
                      builder: (context, value, _) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
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
                                    Image.asset(AppAssets.lockIcon, color: Colors.white,),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'Enter New Urban Ledger PIN'
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
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
                              ]),
                        );
                      }),
                if (!widget.showConfirmPinState)
                  SizedBox(
                    height: 12,
                  ),
                if (widget.showConfirmPinState)
                  ValueListenableBuilder<String>(
                      valueListenable: confirmPinNotifier,
                      builder: (context, value, _) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                         
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
                                      Image.asset(AppAssets.lockIcon,color: Colors.white,),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'CONFIRM NEW URBAN LEDGER PIN',
                                        style: TextStyle(
                                            color: Colors.white,
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
                                ]),
                          
                        );
                      }),
                // (height * 0.11).heightBox,
                showError && widget.showConfirmPinState
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          alignment: Alignment.center,
                          child: const CustomText(
                            'Incorrect PIN. Enter again',
                            size: 16,
                            color: AppTheme.brownishGrey,
                            bold: FontWeight.w600,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: const CustomText(
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
                  height: height * 0.3,
                ),
                Spacer(),
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

  Future<void> inputTextToField(String str) async {
    if (!widget.showConfirmPinState) {
      if (setPinNotifier.value.length < 4) {
        setPinNotifier.value = setPinNotifier.value + str;
        if (setPinNotifier.value.length == 4) {
          if(await PincodeStrenth().checkPincodeStrenth(setPinNotifier.value)){
            setState(() {
              showError = true;
            });
             showWeakPinDialog(context);

          }
          else{
            Navigator.of(context).pushNamed(AppRoutes.setNewPinRoute,
                arguments: SetPinRouteArgs(
                    setPinNotifier.value, true, widget.isResetPinState, false));
          }

        }
      }
    } else {
      if (confirmPinNotifier.value.length < 4) {
        confirmPinNotifier.value = confirmPinNotifier.value + str;
        if (confirmPinNotifier.value.length == 4) {
          if (widget.tempPin == confirmPinNotifier.value) {
            repository.hiveQueries.insertUserPin(confirmPinNotifier.value);
            // repository.hiveQueries.setPinStatus(false);
            /* if (widget.showConfirmPinState && widget.isResetPinState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: CustomText('Pin Reset Successful'),
                duration: Duration(
                  seconds: 1,
                ),
              ));
              await Future.delayed(Duration(seconds: 1));
            } */
            LoginModel loginModel = LoginModel(
                mobileNo: repository.hiveQueries.userData.mobileNo,
                pin: confirmPinNotifier.value,
                status: true,
              );
              repository.queries.checkLoginUser(loginModel);
            var anaylticsEvents = AnalyticsEvents(context);
            await anaylticsEvents.initCurrentUser();
            await anaylticsEvents.changePinEvent();
            Navigator.of(context)..pop()..pop();
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            Navigator.of(context).pushNamed(widget.isResetPinState
                ? AppRoutes.welcomeuserRoute
                : AppRoutes.mainRoute);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                margin: const EdgeInsets.all(60),
                backgroundColor: Colors.white,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      'Your PIN has been changed',
                      size: 16,
                      bold: FontWeight.w500,
                      color: AppTheme.brownishGrey,
                    ),
                    // Image.asset(AppAssets.thumbsIcon)
                  ],
                )));
          } else {
            confirmPinNotifier.value = '';
            setState(() {
              showError = true;
            });
          }
        }
      }
    }
  }

  showWeakPinDialog(BuildContext ctx){
    return  showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: ctx,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(ctx).size.height*0.3 ,
            child: SizedBox.expand(child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),child: Scaffold(body: Container(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.only(top:16),
                    alignment: Alignment.center,
                    child:  Text('Weak PIN',style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.w500))),
                SizedBox(height: 8,),
                Image.asset(
                  AppAssets.weak_pin,
                  height: 50,
                  width: 50,
                ),
                SizedBox(height: 8,),

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal:40),
                    child: CustomText('This PIN Can Be Easily Guessed. Please try again with a different PIN'
                      ,
                      size: 18,
                      centerAlign: true,
                      color: AppTheme.brownishGrey,
                      bold: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 8,),

              ],)),
              bottomNavigationBar: Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () async {

                          Navigator.of(ctx).pop();
                      Navigator.of(ctx).pushNamed(AppRoutes.setNewPinRoute,
                              arguments: SetPinRouteArgs(
                                  setPinNotifier.value, true, widget.isResetPinState, false));

                        },
                        child: CustomText(
                          'YES',
                          size: (18),
                          bold: FontWeight.w500,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                          primary: AppTheme.electricBlue,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        )),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          setPinNotifier.value = '';
                          Navigator.of(ctx).pop();
                        },
                        child: CustomText(
                          'NO',
                          size: (18),
                          bold: FontWeight.w500,
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 0
                        )),
                  ),
                )
              ],)

              ,))),
            margin: EdgeInsets.only(bottom: 12, left: 16, right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(new Radius.circular(12.0)),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
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

class PinField extends StatelessWidget {
  const PinField({
    Key? key,
    required this.showError,
    required this.isFilled,
    required this.isSetField,
  }) : super(key: key);

  final bool showError;
  final bool isFilled;
  final bool isSetField;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(10),
        child: new Container(
          height: 75,
          width: 50,
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border.all(width: 2.0, color: Colors.white),
              borderRadius: new BorderRadius.circular(7)
              ),
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isFilled ? AppTheme.brownishGrey : Colors.white),
            )),
      );
}
