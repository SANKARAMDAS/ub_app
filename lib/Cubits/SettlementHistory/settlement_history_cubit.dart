import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:urbanledger/Models/SuspenseAccountModel.dart';
import 'package:urbanledger/Models/settlement_history_model.dart';
import 'package:urbanledger/Services/APIs/settlement_history_api.dart';
import 'package:urbanledger/Services/APIs/suspense_account_api.dart';
import 'package:urbanledger/Services/repository.dart';

part 'settlement_history_state.dart';

class SettlementHistoryCubit extends Cubit<SettlementHistoryState> {
  SettlementHistoryCubit() : super(SettlementHistoryInitial());

  List<SettlementHistoryData> settlementHistoryDataList = [];
  List<SettlementHistoryData> filteredList = [];
  double totalSettlementAmount= 0;

  int _selectedSort = 1;

  Future<void> getSettlementHistoryData(bool fetchFull) async {
    emit(FetchingSettlementHistory());
    if (fetchFull) {
      await getDataFromSettlementHistory();
      settlementHistoryDataList = await Repository().queries.getSettlementHistory();
      debugPrint("CHecking" + settlementHistoryDataList.length.toString());
      settlementHistoryDataList.forEach((element) {
        totalSettlementAmount +=element.totalSettlementAmount!;
      });
    }
    emit(FetchedSettlementHistory(settlementHistoryDataList));
  }



 /* void searchTransactions(String value) {
    if (filteredList.isEmpty) filteredList = settlementHistoryDataList;
    final searchedTransactions = filteredList
        .where((element) =>
            element.from.toLowerCase().contains(value.toLowerCase()) ||
            element.fromCustId!.mobileNo.contains(value.toLowerCase()) ||
            element.fromMobileNumber!.contains(value.toLowerCase()))
        .toList();
    emit(SearchedSettlementHistory(searchedTransactions, _selectedSort));
  }*/

  filterTransactions(int selectedSort, DateTime start, DateTime end) async {
    filteredList = settlementHistoryDataList;

    _selectedSort = selectedSort;

    filteredList =
        await Repository().queries.getSettlementHistoryForFilter(start, end);


    applySort(selectedSort);
    totalSettlementAmount = 0.0;
    filteredList.forEach((element) {
      totalSettlementAmount +=element.totalSettlementAmount!;
    });
    print(totalSettlementAmount);
    emit(SearchedSettlementHistory(filteredList, selectedSort));
  }

  void applySort(int selectedSort) {
    switch (selectedSort) {
      case 0:
        filteredList.sort(
            (a, b) => b.createdAt.toString().compareTo(a.createdAt.toString()));
        // setState(() {});
        break;
      case 1:
        filteredList.sort((a, b) => b.totalSettlementAmount!.compareTo(a.totalSettlementAmount!));
       // filteredList = filteredList.reversed.toList();
        // setState(() {});
        break;
      case 2:
        filteredList.sort((a, b) => a.totalSettlementAmount!.compareTo(b.totalSettlementAmount!));
        break;
      default:
    }
    print(filteredList.length);
  }

  Future<void> getDataFromSettlementHistory() async {
    await SettlementHistoryApi.settlementHistoryApi.getSettlementHistory();
  }

  // void filterTransactions(int selectedSort, DateTime startDate, DateTime lastDate) {}
}
