import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';

class ChangePinVerification extends StatefulWidget {
  final String token;
  final bool fromSettings;
  ChangePinVerification(
      {Key? key, required this.token, required this.fromSettings})
      : super(key: key);
  @override
  _ChangePinVerificationState createState() => _ChangePinVerificationState();
}

class _ChangePinVerificationState extends State<ChangePinVerification> {
  TextEditingController _pinController = TextEditingController();
  final repository = Repository();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppTheme.greyBackground,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              primary: Theme.of(context).primaryColor,
            ),
            child: CustomText(
              'SUBMIT',
              size: 18,
              color: Colors.white,
            ),
            onPressed: _pinController.text.length == 6
                ? () async {
                    final status = await repository.changePinApi
                        .verifyChangePin(
                            widget.token, _pinController.text.substring(0, 4))
                        .catchError((e) {
                          _pinController.clear();
                      e.toString().showSnackBar(context);
                      return false;
                    });
                    if (status) {
                      repository.hiveQueries.insertUserPin('');
                      Navigator.of(context)
                        ..pop()
                        ..pop()
                        ..pushNamed(
                            widget.fromSettings
                                ? AppRoutes.setNewPinRoute
                                : AppRoutes.setPinRoute,
                            arguments: SetPinRouteArgs('', false, true, false));
                    } //else {
                    //   Navigator.pop(context);
                    //}
                  }
                : null,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back_ios)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ULLogoWidget(
                        height: 50,
                      ),
                    ),
                  ),
                ],
              ),

              10.0.heightBox,
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          AppAssets.msgIcon,
                          height: 33,
                        ),
                        15.0.widthBox,
                        CustomText(
                          'Code Sent to +' +
                              repository.hiveQueries.userData.mobileNo,
                          bold: FontWeight.w400,
                          color: AppTheme.brownishGrey,
                        ),
                      ],
                    ),
                    25.0.heightBox,
                    TextField(
                      controller: _pinController,
                      cursorColor: AppTheme.brownishGrey,
                      maxLength: 6,
                      buildCounter: counter(),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        ModifiedLengthLimitingTextInputFormatter(6),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        if (value.length == 5 || value.length == 6) {
                          setState(() {});
                        }
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          hintText: 'Enter 6 digit code',
                          counterText: '',
                          hintStyle: TextStyle(
                            color: Color(0xffb6b6b6),
                            fontSize: (16),
                          ),
                          errorStyle: TextStyle(
                              color: AppTheme.tomato,
                              fontWeight: FontWeight.w500)),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () {},
                          child: CustomText(
                            "RESEND CODE",
                            size: 16,
                            bold: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
