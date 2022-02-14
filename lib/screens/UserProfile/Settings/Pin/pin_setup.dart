import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/error_codes.dart';
import 'package:local_auth/local_auth.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';

class PinSetupScreen extends StatefulWidget {
  @override
  _PinSetupScreenState createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  double viewInsetsBottom = 0.0;
  double height = deviceHeight - appBarHeight;
  bool isHightSubtracted = false;
  final Repository repository = Repository();
  late bool pinStatus;
  late bool fingerprintStatus;
  // bool isFingerPrintDisabledFromPhone = false;
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    pinStatus = repository.hiveQueries.pinStatus;
    fingerprintStatus = repository.hiveQueries.fingerPrintStatus;
  }

  Future<bool?> showWarningDialog() async => await showDialog(
      builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Dialog(
                insetPadding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 5, left: 20, right: 20),
                      child: CustomText(
                        'Please Enable Fingerprint from Settings to Continue.',
                        bold: FontWeight.w500,
                        color: AppTheme.brownishGrey,
                        size: 18,
                        centerAlign: true,
                      ),
                    ),
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    primary: AppTheme.electricBlue),
                                child: CustomText(
                                  'SETTINGS',
                                  color: Colors.white,
                                  size: (18),
                                  bold: FontWeight.w500,
                                ),
                                onPressed: () async {
                                  AppSettings.openSecuritySettings();
                                  // _authenticate();
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
              25.0.heightBox,
            ],
          ),
      barrierDismissible: false,
      context: context);

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
        title: Text('App Lock and Security'),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 22,
            ),
          ),
        ),
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back_ios,
        //     size: 22,
        //   ),
        //   onPressed: () async {
        //     Navigator.of(context).pop();
        //   },
        // ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.none,
              height: height * 0.1,
              width: double.infinity,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(AppAssets.backgroundImage),
                      alignment: Alignment.topCenter)),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (height * 0.1).heightBox,
                  Row(
                    children: [
                      Image.asset(
                        AppAssets.appIcon1,
                        width: 40,
                        height: 40,
                      ),
                      10.0.widthBox,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            'Urban Ledger PIN',
                            size: 20,
                            color: AppTheme.brownishGrey,
                          ),
                          const CustomText(
                            '4-Digit PIN protecting Urban Ledger',
                            color: AppTheme.brownishGrey,
                            size: 16,
                          ),
                        ],
                      ),
                      Spacer(),
                      CupertinoSwitch(
                        activeColor: AppTheme.electricBlue,
                        value: pinStatus,
                        onChanged: (value) {
                          if (!fingerprintStatus) {
                            'Either Fingerprint or PIN should be enabled'
                                .showSnackBar(context);
                            return;
                          }
                          if (pinStatus) {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.checkPinRoute,
                                    arguments: true)
                                .then((v) {
                              if (v != null) {
                                if (v as bool) {
                                  repository.hiveQueries.setPinStatus(value);
                                  pinStatus = value;
                                  setState(() {});
                                }
                              }
                            });
                          } else {
                            repository.hiveQueries.setPinStatus(value);
                            pinStatus = value;
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                  (height * 0.01).heightBox,
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: TextButton(
                      onPressed: pinStatus
                          ? () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.checkPinRoute);
                            }
                          : null,
                      child: const CustomText(
                        'Change your PIN',
                        size: 20,
                      ),
                    ),
                  ),
                  (height * 0.01).heightBox,
                  Divider(
                    thickness: 1,
                  ),
                  (height * 0.02).heightBox,
                  Row(
                    children: [
                      Image.asset(
                        AppAssets.appIcon1,
                        width: 40,
                        height: 40,
                      ),
                      10.0.widthBox,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            'Urban Ledger Fingerprint',
                            size: 20,
                            color: AppTheme.brownishGrey,
                          ),
                        ],
                      ),
                      Spacer(),
                      CupertinoSwitch(
                        activeColor: AppTheme.electricBlue,
                        value: fingerprintStatus,
                        onChanged: (value) async {
                          if (!pinStatus) {
                            'Either Fingerprint or PIN should be enabled'
                                .showSnackBar(context);
                            return;
                          }
                          if (fingerprintStatus) {
                            final status = await _authenticate();
                            if (status) {
                              repository.hiveQueries
                                  .setFingerPrintStatus(value);
                              fingerprintStatus = value;
                              var anaylticsEvents = AnalyticsEvents(context);
                              await anaylticsEvents.initCurrentUser();
                              await anaylticsEvents
                                  .fingerprintChangeEvent(fingerprintStatus);
                              setState(() {});
                            }
                          } else {
                            repository.hiveQueries.setFingerPrintStatus(value);
                            fingerprintStatus = value;
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _authenticate() async {
    try {
      final biometricList = await _localAuthentication.getAvailableBiometrics();
      if (biometricList.length != 0) {
        final canCheckBiometrics =
            await _localAuthentication.canCheckBiometrics;
        if (canCheckBiometrics) {
          final _isAuthenticated = await _localAuthentication.authenticate(
              localizedReason: 'Scan your fingerprint to authenticate',
              useErrorDialogs: true,
              biometricOnly: true,
              iOSAuthStrings: iosStrings,
              stickyAuth: true);
          if (_isAuthenticated) return true;
        }
      }
    } on PlatformException catch (e) {
      if (e.code == notAvailable) {
        // if (isFingerPrintDisabledFromPhone) {
        //   isFingerPrintDisabledFromPhone = false;
        // } else
        showWarningDialog();
      }
    }
    return false;
  }

  static const iosStrings = const IOSAuthMessages(
      cancelButton: 'cancel',
      goToSettingsButton: 'settings',
      goToSettingsDescription: 'Please set up your Touch ID.',
      lockOut: 'Please reenable your Touch ID');
}
