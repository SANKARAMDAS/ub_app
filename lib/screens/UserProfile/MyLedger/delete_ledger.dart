/* import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Models/business_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';

class DeleteLedger extends StatefulWidget {
  final BusinessModel businessModel;

  const DeleteLedger({Key? key, required this.businessModel}) : super(key: key);

  @override
  _DeleteLedgerState createState() => _DeleteLedgerState();
}

class _DeleteLedgerState extends State<DeleteLedger> {
  final repository = Repository();

  final TextEditingController controller = TextEditingController();

  bool showError = false;

  @override
  void dispose() {
    controller.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton.icon(
              label: CustomText(
                'DELETE',
                size: (18),
                color: Colors.white,
                bold: FontWeight.w500,
              ),
              icon: Icon(
                CupertinoIcons.delete,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15),
                primary: AppTheme.tomato,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: controller.text.isNotEmpty
                  ? () async {
                      if (widget.businessModel.businessName ==
                          controller.text) {
                        final status = await showDeleteConfirmationDialog();
                        if (status) {
                          repository.queries
                              .updateBusinessIsDeleted(
                                  widget.businessModel.businessId, 1)
                              .then((value) async {
                            Provider.of<BusinessProvider>(context,
                                    listen: false)
                                .deleteBusiness(Provider.of<BusinessProvider>(
                                        context,
                                        listen: false)
                                    .businesses
                                    .indexWhere((element) =>
                                        element.businessId ==
                                        widget.businessModel.businessId));
                            if (await checkConnectivity) {
                              final apiResponse = await (repository.businessApi
                                  .deleteBusiness(
                                      widget.businessModel.businessId)
                                  .catchError((e) {
                                debugPrint(e);
                                recordError(e, StackTrace.current);
                                return false;
                              }));
                              if (apiResponse) {
                                await repository.queries
                                    .updateBusinessIsDeleted(
                                        widget.businessModel.businessId, 1);
                              }
                            }
                            Navigator.of(context).pop();
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            margin: const EdgeInsets.all(60),
                            backgroundColor: Colors.white,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText(
                                  'Entered Business Name Doesn\'t Match',
                                  size: 16,
                                  bold: FontWeight.w500,
                                  color: AppTheme.brownishGrey,
                                ),
                              ],
                            ),
                          ),
                        );
                        return;
                      }
                    }
                  : null,
            ),
          ),
          appBar: AppBar(
            title: Text('Delete Ledger'),
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
                  Center(
                    child: CustomText(
                      'You are going to delete ‘${widget.businessModel.businessName}’.\nBy doing so, you will lose all the entries in this ledger.\nAre you ABSOLUTELY sure?',
                      centerAlign: true,
                      color: AppTheme.tomato,
                      bold: FontWeight.w500,
                      size: 16,
                    ),
                  ),
                  40.0.heightBox,
                  TextField(
                    controller: controller,
                    onChanged: (value) {
                      if (value.length < 1 || value.length > 0) setState(() {});
                      if (showError) {
                        setState(() {
                          showError = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        // enabledBorder: OutlineInputBorder(
                        //     borderSide: BorderSide(
                        //         color: Theme.of(context).primaryColor),
                        //     borderRadius: BorderRadius.circular(15)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(15)),
                        hintText: 'Enter your Business name for delete Ledger',
                        hintStyle: TextStyle(
                            fontSize: 16,
                            color: AppTheme.greyish,
                            fontWeight: FontWeight.w500)),
                  ),
                  5.0.heightBox,
                  if (showError)
                    CustomText(
                      'Entered Business Name is Incorrect',
                      color: AppTheme.tomato,
                    )
                ]),
              ),
            ]),
          )),
    );
  }

  Future<bool> showDeleteConfirmationDialog() async => await showDialog(
      builder: (context) => Dialog(
            insetPadding:
                EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.78),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 5),
                  child: CustomText(
                    'Are you sure you want to\ndelete Ledger?',
                    color: AppTheme.tomato,
                    bold: FontWeight.w500,
                    size: 18,
                    centerAlign: true,
                  ),
                ),
                // CustomText(
                //   'Changes made will effect Current Balance',
                //   size: 16,
                // ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: RaisedButton(
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: AppTheme.electricBlue,
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
                )
              ],
            ),
          ),
      barrierDismissible: false,
      context: context);
}
 */
