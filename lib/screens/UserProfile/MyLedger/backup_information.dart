import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/main_screen.dart';

class BackupInformationScreen extends StatefulWidget {
  @override
  _BackupInformationScreenState createState() =>
      _BackupInformationScreenState();
}

class _BackupInformationScreenState extends State<BackupInformationScreen> {
  final repository = Repository();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.greyBackground,
      bottomNavigationBar: SafeArea(
        child: Padding(
            padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
            child: ElevatedButton(
                child: isLoading
                    ? CircularProgressIndicator(backgroundColor: Colors.white)
                    : CustomText(
                        'Sync now'.toUpperCase(),
                        color: Colors.white,
                        size: (18),
                        bold: FontWeight.w500,
                      ),
                style: ElevatedButton.styleFrom(
                  padding: isLoading ? EdgeInsets.zero : EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (await checkConnectivity) {
                          await syncData(context);
                          setState(() {
                            isLoading = false;
                          });
                          'Data Successfully BackedUp'.showSnackBar(context);
                        } else {
                          setState(() {
                            isLoading = false;
                          });

                          'Please Check Your Internet Connectivity and Try Again'
                              .showSnackBar(context);
                        }
                      })),
      ),
      appBar: AppBar(
        title: Text('Backup Information'),
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
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(children: [
          Container(
            clipBehavior: Clip.none,
            height: deviceHeight * 0.06,
            width: double.infinity,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(AppAssets.backgroundImage),
                    alignment: Alignment.topCenter)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                (deviceHeight * 0.1).heightBox,
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          "Your data is automatically backed-up when your phone is connected to the internet. In case you formatted this phone or mistakenly deleted the app, just download the app again and login using your UrbanLedger-registered number. Your data will be automatically restored.",
                          color: AppTheme.brownishGrey,
                          size: 18,
                          height: 1.5,
                          bold: FontWeight.w500,
                        ),
                        30.0.heightBox,
                        Row(
                          children: [
                            CustomText(
                              'LAST BACKUP AT',
                              color: AppTheme.electricBlue,
                              size: 16,
                              bold: FontWeight.w600,
                            ),
                            10.0.widthBox,
                            Image.asset(
                              AppAssets.greyBackupIcon,
                              height: 30,
                            )
                          ],
                        ),
                        CustomText(
                          DateFormat('hh:mm aa | dd MMMM yyyy').format(
                              repository.hiveQueries.lastBackupTimeStamp),
                          color: AppTheme.brownishGrey,
                          size: 14,
                          height: 1,
                          bold: FontWeight.w500,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
