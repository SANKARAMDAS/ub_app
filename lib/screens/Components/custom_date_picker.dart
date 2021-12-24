import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/Utility/app_theme.dart';
import 'package:urbanledger/screens/Components/custom_text_widget.dart';
import 'package:urbanledger/screens/Components/extensions.dart';

late DateTime _initialDate;
// DateTime _selectedDate;
late DateTime _firstDate;
late DateTime _lastDate;

late ValueNotifier<DateTime> _selectedDateNotifier;

Future<DateTime?> showCustomDatePicker(BuildContext context,
    {required DateTime firstDate,
    DateTime? lastDate,
    DateTime? initialDate}) async {
  _initialDate = initialDate ?? DateTime.now();
  ValueNotifier<DateTime> _changeMonthNotifier =
      ValueNotifier(initialDate ?? DateTime.now());
  _selectedDateNotifier = ValueNotifier(_initialDate);
  _firstDate = firstDate;
  _lastDate = lastDate ?? Jiffy(DateTime.now()).add(years: 5).dateTime;
  final response = await showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) => Dialog(
            clipBehavior: Clip.hardEdge,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  // padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ValueListenableBuilder<DateTime?>(
                      valueListenable: _selectedDateNotifier,
                      builder: (context, selectedDate, child) {
                        return ValueListenableBuilder<DateTime>(
                            valueListenable: _changeMonthNotifier,
                            builder: (context, updatedDate, child) {
                              return Column(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        alignment: Alignment.topCenter,
                                        width: double.infinity,
                                        child: Image.asset(
                                          AppAssets.backgroundImage,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              DateFormat('yyyy')
                                                  .format(selectedDate!),
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            CustomText(
                                              DateFormat('EEE, MMM dd')
                                                  .format(selectedDate),
                                              color: Colors.white,
                                              bold: FontWeight.bold,
                                              size: 26,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          CupertinoIcons.chevron_left,
                                          color: AppTheme.electricBlue,
                                        ),
                                        onPressed: () {
                                          _changeMonthNotifier.value = DateTime(
                                              _changeMonthNotifier.value.year,
                                              _changeMonthNotifier.value.month -
                                                  1,
                                              _changeMonthNotifier.value.day);
                                        },
                                      ),
                                      (screenWidth(context) * 0.1).widthBox,
                                      CustomText(
                                        DateFormat('MMMM yyyy')
                                            .format(updatedDate),
                                        bold: FontWeight.w600,
                                        size: 18,
                                        color: AppTheme.brownishGrey,
                                      ),
                                      (screenWidth(context) * 0.1).widthBox,
                                      IconButton(
                                        icon: Icon(
                                          CupertinoIcons.chevron_right,
                                          color: AppTheme.electricBlue,
                                        ),
                                        onPressed: () {
                                          _changeMonthNotifier.value = DateTime(
                                              _changeMonthNotifier.value.year,
                                              _changeMonthNotifier.value.month +
                                                  1,
                                              _changeMonthNotifier.value.day);
                                        },
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        children: generateDay(),
                                      ),
                                      (screenWidth(context) * 0.05).widthBox,
                                      Column(
                                        children: generateCol1(
                                            updatedDate, selectedDate),
                                      ),
                                      (screenWidth(context) * 0.05).widthBox,
                                      Column(
                                        children: generateCol2(updatedDate),
                                      ),
                                      (screenWidth(context) * 0.05).widthBox,
                                      Column(
                                        children: generateCol3(updatedDate),
                                      ),
                                      (screenWidth(context) * 0.05).widthBox,
                                      Column(
                                        children: generateCol4(updatedDate),
                                      ),
                                      (screenWidth(context) * 0.05).widthBox,
                                      Column(
                                        children: generateCol5(updatedDate),
                                      ),
                                      if (initialSkip(updatedDate) > 4)
                                        (screenWidth(context) * 0.05).widthBox,
                                      if (initialSkip(updatedDate) > 4)
                                        Column(
                                          children: generateCol6(updatedDate),
                                        )
                                    ],
                                  ),
                                  (20.0).heightBox,
                                  IntrinsicHeight(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: 12, bottom: 12),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      top: BorderSide(
                                                          color:
                                                              AppTheme.greyish),
                                                      right: BorderSide(
                                                          color: AppTheme
                                                              .greyish))),
                                              child: CustomText(
                                                'CANCEL',
                                                size: 20,
                                                bold: FontWeight.w500,
                                                color: AppTheme.brownishGrey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // VerticalDivider(),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop(
                                                  _selectedDateNotifier.value);
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      top: BorderSide(
                                                          color: AppTheme
                                                              .greyish))),
                                              child: CustomText(
                                                'OK',
                                                size: 20,
                                                bold: FontWeight.w500,
                                                color: AppTheme.brownishGrey,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            });
                      }),
                ),
              ],
            ),
          ));
  return response as DateTime?;
}

final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

List<Widget> generateDay() {
  List<Widget> daysList = [];
  for (var item in days) {
    daysList.add(Padding(
      padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
      child: Container(
        height: 25,
        width: 25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Color.fromRGBO(235, 235, 235, 1),
            borderRadius: BorderRadius.circular(2)),
        child: CustomText(
          item,
          size: 16,
          centerAlign: true,
          color: AppTheme.greyish,
        ),
      ),
    ));
  }
  return daysList;
}

int initialSkip(DateTime updatedDate) {
  final a = DateTime(updatedDate.year, updatedDate.month, 1);
  final b = DateFormat('EEEE').format(a);

  switch (b) {
    case 'Sunday':
      return 0;
    case 'Monday':
      return 1;
    case 'Tuesday':
      return 2;
    case 'Wednesday':
      return 3;
    case 'Thursday':
      return 4;
    case 'Friday':
      return 5;
    case 'Saturday':
      return 6;
    default:
      return 0;
  }
}

List<Widget> generateCol1(DateTime updatedDate, DateTime? selectedDate) {
  List<Widget> daysList = [];
  int j = 0;
  for (int i = 0; i <= 6; i++) {
    if (i < initialSkip(updatedDate)) {
      daysList.add(Padding(
        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
        child: Container(
          height: 25,
          width: 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
          child: CustomText(''),
        ),
      ));
    } else {
      j++;
      daysList.add(
        DateBox(
          date: j.toString(),
          updatedDate: updatedDate,
          selectedDate: _selectedDateNotifier.value,
        ),
      );
    }
  }

  return daysList;
}

List<Widget> generateCol2(DateTime updatedDate) {
  List<Widget> daysList = [];
  int j = 7 - initialSkip(updatedDate);
  for (int i = 7; i <= 13; i++) {
    if (i < initialSkip(updatedDate)) {
      daysList.add(Padding(
        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
        child: Container(
          height: 25,
          width: 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
          child: CustomText(''),
        ),
      ));
    } else {
      j++;
      daysList.add(
        DateBox(
          date: j.toString(),
          updatedDate: updatedDate,
          selectedDate: _selectedDateNotifier.value,
        ),
      );
    }
  }

  return daysList;
}

List<Widget> generateCol3(DateTime updatedDate) {
  List<Widget> daysList = [];
  int j = 14 - initialSkip(updatedDate);
  for (int i = 14; i <= 20; i++) {
    if (i < initialSkip(updatedDate)) {
      daysList.add(Padding(
        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
          ),
          height: 25,
          width: 25,
          child: CustomText(''),
        ),
      ));
    } else {
      j++;
      daysList.add(
        DateBox(
          date: j.toString(),
          updatedDate: updatedDate,
          selectedDate: _selectedDateNotifier.value,
        ),
      );
    }
  }

  return daysList;
}

List<Widget> generateCol4(DateTime updatedDate) {
  List<Widget> daysList = [];
  int j = 21 - initialSkip(updatedDate);
  for (int i = 21; i <= 27; i++) {
    if (i < initialSkip(updatedDate)) {
      daysList.add(Padding(
        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
          height: 25,
          width: 25,
          child: CustomText(''),
        ),
      ));
    } else {
      j++;
      daysList.add(
        DateBox(
          date: j.toString(),
          updatedDate: updatedDate,
          selectedDate: _selectedDateNotifier.value,
        ),
      );
    }
  }

  return daysList;
}

List<Widget> generateCol5(DateTime updatedDate) {
  List<Widget> daysList = [];
  int lastday = DateTime(updatedDate.year, updatedDate.month + 1, 0).day;
  int j = 28 - initialSkip(updatedDate);
  int k = j;
  for (int i = k; i < lastday; i++) {
    if (i < k + 7) {
      j++;
      daysList.add(DateBox(
        date: j.toString(),
        updatedDate: updatedDate,
        selectedDate: _selectedDateNotifier.value,
      ));
    }
  }
  int l = daysList.length;
  for (var i = 1; i <= 7 - l; i++) {
    daysList.add(
      Padding(
        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            /*  border: updatedDate.day == j &&
                    updatedDate.month == _initialDate.month &&
                    updatedDate.year == _initialDate.year
                ? Border.all(color: Colors.blueAccent)
                : null, */
          ),
          height: 25,
          width: 25,
          child: CustomText(''),
        ),
      ),
    );
  }
  return daysList;
}

List<Widget> generateCol6(DateTime updatedDate) {
  List<Widget> daysList = [];
  int j = 35 - initialSkip(updatedDate);
  int lastday = DateTime(updatedDate.year, updatedDate.month + 1, 0).day;
  int k = j;

  for (int i = k; i < lastday; i++) {
    j++;
    daysList.add(DateBox(
      date: j.toString(),
      updatedDate: updatedDate,
      selectedDate: _selectedDateNotifier.value,
    ));
  }
  int l = daysList.length;
  for (var i = 1; i <= 7 - l; i++) {
    daysList.add(
      Padding(
        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            /*  border: updatedDate.day == j &&
                    updatedDate.month == _initialDate.month &&
                    updatedDate.year == _initialDate.year
                ? Border.all(color: Colors.blueAccent)
                : null, */
          ),
          height: 25,
          width: 25,
          child: CustomText(''),
        ),
      ),
    );
  }
  return daysList;
}

class DateBox extends StatelessWidget {
  final String date;
  final DateTime updatedDate;
  final DateTime selectedDate;

  const DateBox(
      {Key? key,
      required this.date,
      required this.updatedDate,
      required this.selectedDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _lastDate
                  .difference(DateTime(updatedDate.year, updatedDate.month,
                      int.tryParse(date) ?? 0))
                  .isNegative ||
              DateTime(updatedDate.year, updatedDate.month,
                      int.tryParse(date) ?? 0)
                  .difference(DateTime(
                      _firstDate.year, _firstDate.month, _firstDate.day))
                  .isNegative
          ? null
          : () {
              _selectedDateNotifier.value = DateTime(
                  updatedDate.year, updatedDate.month, int.tryParse(date) ?? 0);
            },
      child: Padding(
        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
        child: Container(
          height: 25,
          width: 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selectedDate.day.toString() == date &&
                    selectedDate.month == updatedDate.month &&
                    selectedDate.year == updatedDate.year
                ? AppTheme.electricBlue
                : null,
            borderRadius: BorderRadius.circular(25),
            border: DateTime.now().day.toString() == date &&
                    updatedDate.month == DateTime.now().month &&
                    updatedDate.year == DateTime.now().year
                ? Border.all(color: Colors.blueAccent)
                : null,
          ),
          child: CustomText(
            date.toString(),
            size: 16,
            color: _lastDate
                        .difference(DateTime(updatedDate.year,
                            updatedDate.month, int.tryParse(date) ?? 0))
                        .isNegative ||
                    DateTime(updatedDate.year, updatedDate.month,
                            int.tryParse(date) ?? 0)
                        .difference(DateTime(
                            _firstDate.year, _firstDate.month, _firstDate.day))
                        .isNegative
                ? AppTheme.greyish
                : (selectedDate.day.toString() == date &&
                        selectedDate.month == updatedDate.month &&
                        selectedDate.year == updatedDate.year
                    ? Colors.white
                    : AppTheme.brownishGrey),
          ),
        ),
      ),
    );
  }
}
