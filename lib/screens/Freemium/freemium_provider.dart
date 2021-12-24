import 'package:flutter/cupertino.dart';
import 'package:urbanledger/Models/get_premium_moodel.dart';
import 'package:urbanledger/Services/APIs/premium_api.dart';
import 'package:urbanledger/Services/repository.dart';

import '../../main.dart';

class FreemiumProvider with ChangeNotifier {
  String? planID;
  String? cardID;
  String? amountID;
  int? index = 0;
  String? cardNumber;

  List<Map>? stat = [];
  int linkCount = 0;
  int qrCount = 0;
  double? amountViaLink = 0.0;
  double? amountViaQr = 0.0;
  GetPremiumModel? gpp;
  DateTime endDate = DateTime.now();
  DateTime remainingDays = DateTime.now();
  List<Map> TransactionHistory = [];
  List<Map> TransactionCount = [];
  DateTime? LastDateOfCurrentPlan;
  AddPlanID({PlanID}) {
    planID = PlanID;
    debugPrint('PLAN ID on Selector :');
    debugPrint(planID.toString());

    notifyListeners();
  }

  AddAmountID({AmountID}) {
    amountID = AmountID;
    debugPrint('Amount ID on Selector :');
    debugPrint(AmountID.toString());

    notifyListeners();
  }

  AddCardID({CardID}) {
    cardID = CardID.toString();
    print('Card on Selector ' + cardID.toString());
    notifyListeners();
  }

  AddCardNumber({CardNumber}) {
    cardNumber = CardNumber.toString();
    print('Card Number ' + cardNumber.toString());
    notifyListeners();
  }

  AddIndex({Index}) {
    index = Index;
    notifyListeners();
  }

  clearSubcription() {
    cardID = '';
    planID = '';
    index = 1;
  }

  getPremiumPlans() async {
    gpp = await PremiumAPI.getpremiumplanApi.getPremiumPlan();
    await getCalculatedDate();
    await getTransactionCount();
    // await getTransactionHistory();

    notifyListeners();
    return gpp;
  }

  int getDaysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  getCalculatedDate() async {
    int activePlans = 0;

    int? AllRemainigDays = 0;
    int getDaysBetween(DateTime from, DateTime to) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      return (to.difference(from).inHours / 24).round();
    }

    gpp?.data?.forEach((element) {
      if (element.plan?.activeStatus == true) {
        activePlans = gpp!.data!
            .where((element) => element.plan!.activeStatus == true)
            .toList()
            .length;
        debugPrint('No of Active Plans: ' + activePlans.toString());
        debugPrint('ARM DAYS before: ' + AllRemainigDays.toString());
        AllRemainigDays = AllRemainigDays! +
            getDaysBetween(
                element.createdAt!,
                element.createdAt!.add(Duration(
                    days: (element.plan!.days!.toInt() -
                        getDaysBetween(element.createdAt!, DateTime.now())))));
        debugPrint('ARM DAYS after: ' + AllRemainigDays.toString());
      }
      debugPrint('All Remaining Days: ' + AllRemainigDays.toString());

      debugPrint('ActivePlan Length : ' + activePlans.toString());

      LastDateOfCurrentPlan = gpp?.data?.last.createdAt
          ?.add(Duration(days: gpp!.data!.last.plan!.days!.toInt()));
      debugPrint('LastDateOfCurrentPlan: ' + LastDateOfCurrentPlan.toString());
    });

    if (gpp != null && gpp?.data!.isNotEmpty != null && activePlans > 1) {
      debugPrint('ActivePlan is : ' + activePlans.toString());
      //endDate = DateTime.now().add(Duration(days: AllRemainigDays!));
      debugPrint('Check CC' + (gpp!.data!.last.plan!.days!.toInt()).toString());
      // remainingDays = DateTime.now().subtract(
      //   Duration(
      //     days: LastDateOfCurrentPlan!.day,
      //     minutes: LastDateOfCurrentPlan!.minute,
      //     seconds: LastDateOfCurrentPlan!.second,
      //     microseconds: LastDateOfCurrentPlan!.microsecond,
      //     hours: LastDateOfCurrentPlan!.hour,
      //     milliseconds: LastDateOfCurrentPlan!.millisecond,
      //   ),
      // );

      // remainingDays = LastDateOfCurrentPlan!.subtract(
      //   Duration(
      //     days: DateTime.now().day,
      //     milliseconds: DateTime.now().millisecond,
      //     hours: DateTime.now().hour,
      //     microseconds: DateTime.now().microsecond,
      //     seconds: DateTime.now().second,
      //     minutes: DateTime.now().minute,
      //   ),
      // );
      // endDate =
      //     LastDateOfCurrentPlan!.add(Duration(days: AllRemainigDays!.toInt()));
      // endDate = LastDateOfCurrentPlan!;
      endDate = DateTime.now().add(Duration(days: AllRemainigDays!.toInt()));
      debugPrint('1st Remaing Day: ' + remainingDays.toString());
      return endDate;
    } else {
      debugPrint('ActivePlan is 1 : ' + activePlans.toString());

      debugPrint('All Remaining Days: ' + AllRemainigDays.toString());
      // endDate =
      //     LastDateOfCurrentPlan!.add(Duration(days: AllRemainigDays!.toInt()));
      endDate = LastDateOfCurrentPlan ?? DateTime.now();
      debugPrint('End Date2: ' + endDate.toString());
    }

    notifyListeners();
  }

  getStats() async {
    stat = [];
    linkCount = 0;
    qrCount = 0;
    amountViaLink = 0.0;
    amountViaQr = 0.0;
    // notifyListeners();
    Repository().queries.getPREMIUMSTATS().then((value) {
      stat = value;

      stat!.forEach((element) {
        if (element['type'] == 'LINK') {
          linkCount += 1;
          amountViaLink = (amountViaLink! + element['amount']);
        } else {
          if (element['type'] == 'QRCODE') {
            qrCount += 1;
            amountViaQr = (amountViaQr! + element['amount']);
          }
        }
        notifyListeners();
      });
    });
    notifyListeners();
    return await Repository().queries.getPREMIUMSTATS();
  }

  getRemainingDaysForUnsunscribe() async {
    return await getDaysBetween(DateTime.now(), endDate);
  }

  getTransactionCount() async {
    TransactionCount = await repository.queries.getTransactionCount();
    notifyListeners();

    debugPrint('Transaction Count: ' + TransactionCount.last.toString());
  }
}
