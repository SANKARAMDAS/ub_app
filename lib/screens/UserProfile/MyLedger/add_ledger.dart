import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Models/business_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import 'package:uuid/uuid.dart';

class AddLedger extends StatefulWidget {
  @override
  _AddLedgerState createState() => _AddLedgerState();
}

class _AddLedgerState extends State<AddLedger> {
  final repository = Repository();

  final TextEditingController controller = TextEditingController();
  final GlobalKey<State> key = GlobalKey<State>();
  String? errorMsg;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.transparent,
          key: key,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 22,
                ),
              ),
            ),
            title: const Text('Add New Ledger'),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppTheme.electricBlue,
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: controller.text.trim().isEmpty || errorMsg != null
                  ? null
                  : () async {
                      if (validateBusinessName(controller.text) != null) {
                        return;
                      }
                      final businesses =
                          Provider.of<BusinessProvider>(context, listen: false)
                              .businesses;
                      if (businesses
                          .where((element) =>
                              element.businessName == controller.text)
                          .isNotEmpty) {
                        setState(() {
                          errorMsg = 'Please Enter a Different Business Name';
                        });
                        return;
                      }
                      CustomLoadingDialog.showLoadingDialog(context, key);
                      final businessModel = BusinessModel(
                          businessId: Uuid().v1(),
                          businessName: controller.text,
                          deleteAction: true,
                          isChanged: true,
                          isDeleted: false);

                      Provider.of<BusinessProvider>(context, listen: false)
                          .addBusiness(businessModel)
                          .then((value) async {
                        if (await checkConnectivity) {
                          final apiResponse = await (repository.businessApi
                              .saveBusiness(businessModel, context, false)
                              .catchError((e) {
                            Navigator.of(context).pop();
                            debugPrint(e);
                            Navigator.of(context).pop();
                            recordError(e, StackTrace.current);
                            return false;
                          }));
                          if (apiResponse) {
                            await repository.queries
                                .updateBusinessIsChanged(businessModel, 0);
                          }
                        }  else {
                                        Navigator.of(context).pop();
                          'Please check your internet connection or try again later.'
                              .showSnackBar(context);
                        }
                        /*    FocusScope.of(context).unfocus();
                        controller.clear();*/
                        Navigator.of(context)
                          ..pop()
                          ..pop();

                        'Ledger added Successfully '.showSnackBar(context);
                      });
                    },
              child: CustomText('Save'.toUpperCase(),
                  color: Colors.white, size: 18, bold: FontWeight.w500),
            ),
          ),
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
                child: Column(children: [
                  (deviceHeight * 0.1).heightBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: controller,
                        label: 'Ledger Name',
                        onChanged: (value) {
                          errorMsg = validateBusinessName(value);
                          setState(() {});
                        },
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            AppAssets.businessNameIcon,
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                      5.0.heightBox,
                      if (errorMsg != null)
                        CustomText(
                          '$errorMsg',
                          color: AppTheme.tomato,
                        )
                    ],
                  )
                ]),
              ),
            ]),
          )),
    );
  }

  String? validateBusinessName(String value) {
    if (value.trim().length < 3 || value.length > 50) {
      return 'Ledger Name must be between 3 to 50 characters';
    }
    return null;
  }
}

class CustomTextField extends StatelessWidget {
  final String? label;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final bool? enabled;
  final void Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    this.label,
    this.prefixIcon,
    this.controller,
    this.enabled,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      onChanged: onChanged,
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppTheme.electricBlue,
          ),
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.electricBlue),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.electricBlue),
              borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.electricBlue),
              borderRadius: BorderRadius.circular(10)),
          ),
    );
  }
}
