import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/Components/custom_widgets.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
// import 'package:urbanledger/chat_module/screens/contact/contact_controller.dart';
import 'package:uuid/uuid.dart';

class CalculatorScreen extends StatefulWidget {
  final bool toTheCustomer;
  final int? paymentType;
  final CustomerModel? customerModel;
  final TransactionModel? transactionModel;
  final Function(double? amount, String details, int? paymentType)? sendMessage;

  const CalculatorScreen(
      {Key? key,
      required this.toTheCustomer,
      required this.paymentType,
      required this.customerModel,
      required this.transactionModel,
      required this.sendMessage})
      : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<CalculatorScreen> {
  final Repository repository = Repository();
  double viewInsetsBottom = 0.0;
  bool hideCalculator = false;
  double height = deviceHeight - appBarHeight;
  bool isHightSubtracted = false;
  DateTime? _selectedDate = DateTime.now();
  List<PlatformFile> _pickedFiles = [];
  TransactionModel? _transactionModel = TransactionModel();
  TextEditingController _detailsController = TextEditingController();
  List<PdfPageImage?> _pageImages = [];
  bool isLoading = false;
  bool isCalcSheetOpen = false;
  FocusNode newFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    initializeCalculationNotifiers();
    // _contactController = ContactController(
    //   context: context,
    // );
    if (widget.transactionModel != null) {
      _transactionModel = widget.transactionModel;
      calculationStringNotifier.value =
          removeDecimalif0(_transactionModel!.amount);
      equalPressed();
      _detailsController.text = _transactionModel!.details;
      _selectedDate = _transactionModel!.date;
      _pickedFiles = widget.transactionModel!.attachments.map((e) {
        return PlatformFile(path: e != null ? e : null);
      }).toList();
      generateThumbnails(_pickedFiles);
    }
  }

  Future<void> generateThumbnails(List<PlatformFile> files) async {
    for (var file in files) {
      if (file.path!.split('.').last == 'pdf') {
        final doc = await PdfDocument.openFile(file.path!);
        final page = await doc.getPage(1);
        final pageImage = await page.render(
            height: 37, width: 20, fullHeight: 100, fullWidth: 100
            // width: (screenWidth(context) * 0.90).toInt(),
            );
        await pageImage.createImageIfNotAvailable();
        _pageImages.add(pageImage);
      } else {
        _pageImages.add(null);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    disposeCalculationNotifiers();
    _detailsController.dispose();
    _pageImages.forEach((e) => e?.dispose());
    // _contactController.dispose();
    newFocus.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // _contactController.initProvider();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    if (!isHightSubtracted) {
      height = height - MediaQuery.of(context).viewPadding.top;
      isHightSubtracted = true;
    }
    hideCalculator = viewInsetsBottom != 0.0;
    return WillPopScope(
      onWillPop: () async {
        if (isLoading) return false;
        if (isCalcSheetOpen) {
          isCalcSheetOpen = false;
          Navigator.pop(context);
          return false;
        }
        if (widget.transactionModel != null) {
          final bool? response = await showExitWithoutSavingDialog();
          return response!;
        }
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();

          if (isCalcSheetOpen) {
            isCalcSheetOpen = false;
            Navigator.pop(context);
          }
        },
        child: Scaffold(
            backgroundColor: AppTheme.paleGrey,
            appBar: AppBar(
              backgroundColor: AppTheme.electricBlue,
              titleSpacing: 0.0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 22,
                ),
                onPressed: () async {
                  if (isLoading) return;
                  if (isCalcSheetOpen) {
                    isCalcSheetOpen = false;
                    Navigator.pop(context);
                    return;
                  }
                  if (widget.transactionModel != null) {
                    final bool? response = await showExitWithoutSavingDialog();
                    if (response ?? false) Navigator.of(context).pop();
                    return;
                  }
                  Navigator.of(context).pop();
                },
              ),
              title: ValueListenableBuilder<double?>(
                  valueListenable: calculatedAmountNotifier,
                  builder: (context, calculatedAmount, child) {
                    return Text('You ' +
                        (widget.toTheCustomer ? 'gave ' : 'got ') +
                        '$currencyAED ' +
                        removeDecimalif0(calculatedAmount) +
                        (widget.toTheCustomer ? ' to ' : ' from ') +
                        ' ${widget.customerModel!.name}');
                  }),
            ),
            body: Container(
              height: height,
              width: double.maxFinite,
              child: Stack(
                children: [
                  Container(
                    clipBehavior: Clip.none,
                    height: height * 0.245,
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(AppAssets.backgroundImage),
                            alignment: Alignment.topCenter)),
                  ),
                  Container(
                    child: ValueListenableBuilder<double>(
                        valueListenable: calculatedAmountNotifier,
                        builder: (context, calculatedAmount, child) {
                          return ValueListenableBuilder<String>(
                              valueListenable: calculationStringNotifier,
                              builder: (context, calculationString, child) {
                                return Column(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    (height * 0.030).heightBox,
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Enter the Amount',
                                            style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              FocusScope.of(context).unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(newFocus);
                                              isCalcSheetOpen = true;
                                              await calculatorSheet(context);
                                            },
                                            child: Container(
                                              height: height * 0.12,
                                              width: screenWidth(context),
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 10),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        // width:
                                                        //     screenWidth(context) *
                                                        //         0.475,
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          '$currencyAED',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                      VerticalDivider(
                                                        color: Colors.white,
                                                        thickness: 2,
                                                        indent: 1,
                                                      ),
                                                      Flexible(
                                                        child: Container(
                                                            // alignment: Alignment
                                                            //     .centerLeft,
                                                            height:
                                                                height * 0.12,
                                                            // width:
                                                            //     screenWidth(context) *
                                                            //         0.480,
                                                            // color: Colors.black,
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                              child: CustomText(
                                                                (calculatedAmount)
                                                                    .getFormattedCurrency,
                                                                bold: FontWeight
                                                                    .w700,
                                                                size: 40,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                          ),
                                        ]),
                                    (height * 0.03).heightBox,
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        width: double.infinity,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10,
                                                left: 20,
                                                right: 20),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (calculationString
                                                    .isNotEmpty)
                                                  CustomText(
                                                    calculationString +
                                                        (calculationString
                                                                .contains(' ')
                                                            ? ' = ${removeDecimalif0(calculatedAmount)}'
                                                            : ''),
                                                    bold: FontWeight.w700,
                                                    color: AppTheme.greyish,
                                                    size: 18,
                                                  ),
                                                ValueListenableBuilder<double>(
                                                    valueListenable:
                                                        memoryAmountNotifier,
                                                    builder: (context,
                                                        memoryAmount, child) {
                                                      return calculationString
                                                                  .isEmpty &&
                                                              memoryAmount == 0
                                                          ? CustomText(
                                                              '',
                                                              size: 18,
                                                            )
                                                          : memoryAmount == 0
                                                              ? Container()
                                                              : Flexible(
                                                                  child:
                                                                      CustomText(
                                                                    'M = $memoryAmount',
                                                                    bold: FontWeight
                                                                        .w700,
                                                                    color: AppTheme
                                                                        .greyish,
                                                                    size: 18,
                                                                  ),
                                                                );
                                                    }),
                                              ],
                                            )),
                                      ),
                                    ),
                                    (height * 0.02).heightBox,
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Theme(
                                          data: ThemeData(
                                              primaryColor: Colors.white),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: TextField(
                                              controller: _detailsController,
                                              style: TextStyle(
                                                  color: AppTheme.brownishGrey),
                                              onEditingComplete: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              onTap: () {
                                                if (isCalcSheetOpen) {
                                                  isCalcSheetOpen = false;
                                                  Navigator.pop(context);
                                                }
                                              },
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              maxLength: 120,
                                              decoration: InputDecoration(
                                                  hintText:
                                                      'Enter Details (Item No, Bill, Quantity)',
                                                  hintStyle: TextStyle(
                                                      color: AppTheme.greyish,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  filled: true,
                                                  fillColor: Colors.white),
                                            ),
                                          ),
                                        )),
                                    (height * 0.017).heightBox, //0.02
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton.icon(
                                            icon: Icon(Icons.today_rounded),
                                            label: CustomText(
                                                DateFormat('EEE, dd MMM yyyy')
                                                    .format(_selectedDate!)),
                                            onPressed: () async {
                                              final selectedDate =
                                                  (await showCustomDatePicker(
                                                          context,
                                                          firstDate:
                                                              DateTime(2000),
                                                          initialDate:
                                                              _selectedDate ??
                                                                  DateTime
                                                                      .now(),
                                                          lastDate:
                                                              DateTime.now()) ??
                                                      _selectedDate);
                                              if (selectedDate != null) {
                                                _selectedDate = selectedDate;
                                                setState(() {});
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    ClipRRect(child: (height * 0.02).heightBox),
                                    if (_pickedFiles.length < 1)
                                      if (!hideCalculator)
                                        Flexible(
                                          child: ClipRRect(
                                            child: GestureDetector(
                                              onTap: () async {
                                                pickAttachment();
                                              },
                                              child: Stack(
                                                // clipBehavior: Clip.none,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20),
                                                    child: DottedBorder(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      radius:
                                                          Radius.circular(10),
                                                      dashPattern: [5, 5, 5, 5],
                                                      borderType:
                                                          BorderType.RRect,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 20),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Expanded(
                                                                    child: Image
                                                                        .asset(
                                                                      AppAssets
                                                                          .addFileIcon,
                                                                      height:
                                                                          30,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        'Attach Bills',
                                                                        style: TextStyle().copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    if (_pickedFiles.length > 0)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          runSpacing: 10,
                                          children: [
                                            ...getImageDocWidgets(
                                                _pickedFiles.where((e) {
                                              return e.path != null;
                                            }).toList()),
                                            if (_pickedFiles.length < 5)
                                              GestureDetector(
                                                onTap: () {
                                                  pickAttachment();
                                                },
                                                child: DottedBorder(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  radius: Radius.circular(10),
                                                  dashPattern: [5, 5, 5, 5],
                                                  borderType: BorderType.RRect,
                                                  child: Container(
                                                    color: Colors.white,
                                                    height: 40,
                                                    width: 60,
                                                    child: Icon(
                                                        Icons.add_a_photo,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                    SizedBox(height: 5),
                                    // (height * 0.001).heightBox,
                                    Flexible(
                                      child: ClipRRect(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 80),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'You can upload JPEG, PNG or PDF with max size 5MB',
                                              style: TextStyle(
                                                  color: AppTheme.greyish,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Flexible(
                                      child: ClipRRect(
                                        child: saveButton(calculationString,
                                            calculatedAmount, context),
                                      ),
                                    )
                                  ],
                                );
                              });
                        }),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget saveButton(
      String calculationString, double calculatedAmount, BuildContext context) {
    return ValueListenableBuilder<double>(
        valueListenable: memoryAmountNotifier,
        builder: (context, memoryAmount, child) {
          return Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Container(
              width: double.infinity,
              child: !showMemoryButton || memoryAmount == 0
                  ? ElevatedButton(
                      child: isLoading
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.white)
                          : FittedBox(
                              child: CustomText(
                                'SAVE',
                                color: Colors.white,
                                size: (18),
                                bold: FontWeight.w500,
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            isLoading ? EdgeInsets.zero : EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        primary: calculationString.isEmpty
                            ? AppTheme.disabledBlue
                            : AppTheme.electricBlue,
                      ),
                      onPressed: calculatedAmount < 0.1
                          ? null
                          : isLoading
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();
                                  if (calculatedAmount.isNegative ||
                                      calculatedAmount < 0.1 ||
                                      removeDecimalif0(calculatedAmount)
                                              .length >
                                          20) {
                                    'Please enter a valid amount'
                                        .showSnackBar(context);
                                    return;
                                  }
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final previousBalance = (await repository
                                      .queries
                                      .getPaidMinusReceived(
                                          widget.customerModel!.customerId!));
                                  // widget.sendMessage!(
                                  //     calculatedAmount,
                                  //     _detailsController.text,
                                  //     widget.paymentType);

                                  if (widget.transactionModel != null) {
                                    await BlocProvider.of<LedgerCubit>(context)
                                        .updateLedger(
                                            _transactionModel!
                                              ..balanceAmount = (widget
                                                      .toTheCustomer
                                                  ? (previousBalance +
                                                          widget
                                                              .transactionModel!
                                                              .amount!) -
                                                      calculatedAmount
                                                  : previousBalance -
                                                      widget.transactionModel!
                                                          .amount! +
                                                      calculatedAmount)
                                              ..details =
                                                  _detailsController.text
                                              ..customerId = widget
                                                  .transactionModel!.customerId
                                              ..date = _selectedDate != null
                                                  ? DateTime(
                                                      _selectedDate!.year,
                                                      _selectedDate!.month,
                                                      _selectedDate!.day,
                                                      DateTime.now().hour,
                                                      DateTime.now().minute,
                                                      DateTime.now().second)
                                                  : DateTime.now()
                                              ..attachments = _pickedFiles
                                                  .map((e) => e.path)
                                                  .toList()
                                              ..isChanged = true
                                              ..isDeleted = false
                                              ..amount = calculatedAmount
                                              ..business = Provider.of<
                                                          BusinessProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedBusiness
                                                  .businessId //todoadd column
                                              ..createddate = DateTime.now(),
                                            () => widget.sendMessage!(
                                                calculatedAmount,
                                                _detailsController.text,
                                                widget.paymentType),
                                            context);

                                    setState(() {
                                      isLoading = false;
                                    });
                                    'Entry edited successfully'
                                        .showSnackBar(context);
                                    Navigator.of(context)
                                      ..pop()
                                      ..pop();
                                  } else {
                                    await BlocProvider.of<LedgerCubit>(context)
                                        .addLedger(
                                            _transactionModel!
                                              ..transactionId = Uuid().v1()
                                              ..amount = calculatedAmount
                                              ..details =
                                                  _detailsController.text
                                              ..transactionType =
                                                  widget.toTheCustomer
                                                      ? TransactionType.Pay
                                                      : TransactionType.Receive
                                              ..customerId = widget
                                                  .customerModel!.customerId
                                              ..date = _selectedDate != null
                                                  ? DateTime(
                                                      _selectedDate!.year,
                                                      _selectedDate!.month,
                                                      _selectedDate!.day,
                                                      DateTime.now().hour,
                                                      DateTime.now().minute,
                                                      DateTime.now().second)
                                                  : DateTime.now()
                                              ..attachments = _pickedFiles
                                                  .map((e) => e.path)
                                                  .toList()
                                              ..balanceAmount =
                                                  (widget.toTheCustomer
                                                      ? previousBalance -
                                                          calculatedAmount
                                                      : previousBalance +
                                                          calculatedAmount)
                                              ..isChanged = true
                                              ..isDeleted = false
                                              ..business = Provider.of<
                                                          BusinessProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedBusiness
                                                  .businessId //todoadd column
                                              ..createddate = DateTime.now(),
                                            () => widget.sendMessage!(
                                                calculatedAmount,
                                                _detailsController.text,
                                                widget.paymentType),
                                            context);
                                    setState(() {
                                      isLoading = false;
                                    });

                                    Navigator.of(context).pushNamed(
                                        AppRoutes.transactionSavedRoute);
                                  }
                                },
                    )
                  : ElevatedButton(
                      child: CustomText(
                        'MRC = $memoryAmount',
                        color: Colors.white,
                        size: (18),
                        bold: FontWeight.w500,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (calculationStringNotifier.value.endsWith(' ') ||
                            calculationStringNotifier.value.isEmpty) {
                          calculationStringNotifier.value +=
                              memoryAmount.toString().split('.').last == '0'
                                  ? memoryAmount.toString().split('.').first
                                  : memoryAmount.toStringAsFixed(3);
                          // memoryAmountNotifier.value =
                          //     0;
                          equalPressed();
                          setState(() {
                            showMemoryButton = false;
                          });
                        }
                      },
                    ),
            ),
          );
        });
  }

  calculatorSheet(BuildContext c) {
    return showBottomSheet<void>(
      backgroundColor: AppTheme.paleGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: c,
      builder: (BuildContext context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {},
          child: Container(
            // height: 130,
            constraints: BoxConstraints(maxHeight: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: CustomCalculator(
                    onPercentPressed: () {
                      if (!calculationStringNotifier.value.endsWith(' '))
                        calculationStringNotifier.value =
                            calculationStringNotifier.value + ' % ';
                    },
                    onACPressed: () {
                      memoryAmountNotifier.value = 0;
                      showMemoryButton = false;
                    },
                    onMinusPressed: () {
                      if (!calculationStringNotifier.value.endsWith(' '))
                        calculationStringNotifier.value =
                            calculationStringNotifier.value + ' - ';
                    },
                    onMMinusPressed: () {
                      if (calculatedAmountNotifier.value != 0) {
                        memoryAmountNotifier.value -=
                            calculatedAmountNotifier.value;
                        showMemoryButton = true;
                        calculationStringNotifier.value = '';
                        calculatedAmountNotifier.value = 0;
                      }
                    },
                    onDecimalPressed: () {
                      if (!calculationStringNotifier.value
                          .lastSplit(' ')
                          .contains('.'))
                        calculationStringNotifier.value =
                            calculationStringNotifier.value + '.';
                    },
                    onCPressed: () {
                      calculationStringNotifier.value = '';
                      calculatedAmountNotifier.value = 0.0;
                    },
                    onbackSpacePressed: () {
                      if (calculationStringNotifier.value.isNotEmpty) {
                        if (calculationStringNotifier.value.endsWith(' ')) {
                          calculationStringNotifier.value =
                              calculationStringNotifier.value.trim();
                          calculationStringNotifier.value =
                              calculationStringNotifier.value.replaceRange(
                                  calculationStringNotifier.value.length - 1,
                                  calculationStringNotifier.value.length,
                                  '');

                          calculationStringNotifier.value =
                              calculationStringNotifier.value.trim();
                        } else {
                          calculationStringNotifier.value =
                              calculationStringNotifier.value.replaceRange(
                                  calculationStringNotifier.value.length - 1,
                                  calculationStringNotifier.value.length,
                                  '');
                        }
                        equalPressed();
                      }
                    },
                    onAddPressed: () {
                      if (!calculationStringNotifier.value.endsWith(' ')) {
                        calculationStringNotifier.value =
                            calculationStringNotifier.value + ' + ';
                      }
                    },
                    on9Pressed: () {
                      calculationStringNotifier.value =
                          calculationStringNotifier.value + '9';
                      equalPressed();
                    },
                    on8Pressed: () {
                      calculationStringNotifier.value =
                          calculationStringNotifier.value + '8';
                      equalPressed();
                    },
                    on7Pressed: () {
                      calculationStringNotifier.value =
                          calculationStringNotifier.value + '7';
                      equalPressed();
                    },
                    on6Pressed: () {
                      calculationStringNotifier.value =
                          calculationStringNotifier.value + '6';
                      equalPressed();
                    },
                    on5Pressed: () {
                      calculationStringNotifier.value =
                          calculationStringNotifier.value + '5';
                      equalPressed();
                    },
                    on4Pressed: () {
                      calculationStringNotifier.value =
                          calculationStringNotifier.value + '4';
                      equalPressed();
                    },
                    on3Pressed: () {
                      calculationStringNotifier.value =
                          calculationStringNotifier.value + '3';
                      equalPressed();
                    },
                    on2Pressed: () {
                      calculationStringNotifier.value =
                          calculationStringNotifier.value + '2';
                      equalPressed();
                    },
                    on1Pressed: () {
                      calculationStringNotifier.value =
                          calculationStringNotifier.value + '1';
                      equalPressed();
                    },
                    onDividePressed: () {
                      if (!calculationStringNotifier.value.endsWith(' '))
                        calculationStringNotifier.value =
                            calculationStringNotifier.value + ' ÷ ';
                    },
                    on0Pressed: () {
                      calculationStringNotifier.value =
                          calculationStringNotifier.value + '0';
                      equalPressed();
                    },
                    onEqualPressed: () {
                      equalPressed();
                    },
                    onMPlusPressed: () {
                      if (calculatedAmountNotifier.value != 0) {
                        memoryAmountNotifier.value +=
                            calculatedAmountNotifier.value;
                        showMemoryButton = true;
                        calculationStringNotifier.value = '';
                        calculatedAmountNotifier.value = 0;
                      }
                    },
                    onMultiplyPressed: () {
                      if (!calculationStringNotifier.value.endsWith(' '))
                        calculationStringNotifier.value =
                            calculationStringNotifier.value + ' x ';
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  showDeleteImageDialog(int index) async => await showDialog(
      builder: (context) => Dialog(
            insetPadding:
                EdgeInsets.only(left: 20, right: 20, top: deviceHeight * 0.78),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 5),
                  child: CustomText(
                    'Delete this image?',
                    color: AppTheme.tomato,
                    bold: FontWeight.w500,
                    size: 18,
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              primary: AppTheme.electricBlue,
                            ),
                            child: CustomText(
                              'DELETE',
                              color: Colors.white,
                              size: (18),
                              bold: FontWeight.w500,
                            ),
                            onPressed: () {
                              _pickedFiles.removeAt(index);
                              _pageImages.removeAt(index);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      margin: const EdgeInsets.all(40),
                                      backgroundColor: Colors.white,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomText(
                                            'Image has been deleted!',
                                            size: 16,
                                            bold: FontWeight.w500,
                                            color: AppTheme.brownishGrey,
                                          ),
                                          Icon(
                                            CupertinoIcons.delete,
                                            color: AppTheme.tomato,
                                          ),
                                        ],
                                      )));
                              setState(() {});
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

  Future<bool?> showExitWithoutSavingDialog() async => await showDialog(
      builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 5),
                  child: CustomText(
                    'Exit without saving?',
                    color: AppTheme.tomato,
                    bold: FontWeight.w500,
                    size: 18,
                  ),
                ),
                CustomText(
                  'Changes will not be saved ',
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                )
              ],
            ),
          ),
      barrierDismissible: false,
      context: context);

  pickAttachment() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 130,
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
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          if (!(await Permission.storage.isGranted)) {
                            final status = await Permission.storage.request();
                            if (status != PermissionStatus.granted) return;
                          }
                          pickFileAndGenerateThumbnail(context, 0);
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Image.asset(
                                AppAssets.documentIcon,
                                height: 40,
                              ),
                              5.0.heightBox,
                              Text(
                                'Document',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.brownishGrey,
                                ),
                              )
                            ]),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (!(await Permission.storage.isGranted)) {
                            final status = await Permission.storage.request();
                            if (status != PermissionStatus.granted) return;
                          }
                          pickFileAndGenerateThumbnail(context, 1);
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.asset(
                                AppAssets.galleryIcon,
                                height: 40,
                              ),
                              5.0.heightBox,
                              Text(
                                'Gallery',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.brownishGrey,
                                ),
                              )
                            ]),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (!(await Permission.camera.isGranted)) {
                            final status = await Permission.camera.request();
                            if (status != PermissionStatus.granted) return;
                          }
                          pickFileAndGenerateThumbnail(context, 2);
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Image.asset(
                                AppAssets.cameraIcon01,
                                height: 40,
                              ),
                              5.0.heightBox,
                              Text(
                                'Camera',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.brownishGrey,
                                ),
                              )
                            ]),
                      ),
                    ]),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> pickFileAndGenerateThumbnail(
      BuildContext context, int type) async {
    final _pickedFile = type == 0
        ? await pickFile()
        : type == 1
            ? await pickImage(ImageSource.gallery)
            : await pickImage(ImageSource.camera);
    if (_pickedFile == null) return;
    if (_pickedFiles.length < 5) {
      if ((await File(_pickedFile.path!).length()) < 5242880) {
        _pickedFiles.add(_pickedFile);
        if (_pickedFile.extension == 'pdf') {
          final doc = await PdfDocument.openFile(_pickedFile.path!);
          final page = await doc.getPage(1);
          final pageImage = await page.render(
              height: 40, width: 60, fullHeight: 100, fullWidth: 487
              // width: (screenWidth(context) * 0.90).toInt(),
              );
          await pageImage.createImageIfNotAvailable();
          _pageImages.add(pageImage);
        } else {
          _pageImages.add(null);
        }
        setState(() {});
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
        'File size exceeds the maximum limit of 5MB'.showSnackBar(context);
      }
    } else {
      'File size exceeds the maximum limit of 5MB'.showSnackBar(context);
    }
  }

  List<Widget> getImageDocWidgets(List<PlatformFile> files) {
    List<Widget> widgets = [];
    for (int i = 0; i < files.length; i++) {
      widgets.add(imageDocWidget(files[i].path!, _pageImages[i], i));
    }
    return widgets;
  }

  Widget imageDocWidget(String path, PdfPageImage? pageImage, int index) =>
      Padding(
        padding: EdgeInsets.only(right: 20),
        child: GestureDetector(
          onTap: () async {
            await showDeleteImageDialog(index);
          },
          child: DottedBorder(
            color: AppTheme.electricBlue,
            radius: Radius.circular(10),
            dashPattern: [5, 5, 5, 5],
            borderType: BorderType.RRect,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                path.split('.').last == 'pdf'
                    ? pageImage?.imageIfAvailable == null
                        ? Container()
                        : RawImage(
                            image: pageImage!.imageIfAvailable,
                            fit: BoxFit.contain,
                            // scale: 1,
                          )
                    : Image.file(
                        File(path),
                        height: 40,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                Positioned(
                  right: -15,
                  top: -12,
                  child: Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: AppTheme.tomato,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future<PlatformFile?> pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      allowedExtensions: allowedExtensions,
      type: FileType.custom,
    );
    return pickedFile == null ? null : pickedFile.files.first;
  }

  Future<PlatformFile?> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    return pickedFile == null ? null : PlatformFile(path: pickedFile.path);
  }

  static List<String> get allowedExtensions => const [
        'pdf',
        'doc',
        'docx',
        // 'jpg',
        // 'jpeg',
        // 'png',
      ];
}
