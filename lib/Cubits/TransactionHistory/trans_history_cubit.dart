import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:urbanledger/Models/analytics_model.dart';

import 'package:urbanledger/Services/repository.dart';

part 'trans_history_state.dart';

class TransHistoryCubit extends Cubit<TransHistoryState> {
  TransHistoryCubit() : super(TransactionHistoryInitial());

  List<Datum> transactionHistoryDataList = [];
  List<Datum> filteredList = [];

 int _selectedSort = 1;

  Future<void> getTransactionsHistory(bool fetchFull) async {
    emit(FetchingTranasctionHistory());
    if (fetchFull) {
     // await getDataFromSuspenseAccount();
      transactionHistoryDataList = await Repository().queries.getTransactionHistory();
    }
    emit(FetchedTranasctionHistory(transactionHistoryDataList));
  }

  void searchTransactions(String value) {
    if (filteredList.isEmpty) filteredList = transactionHistoryDataList;
    final searchedTransactions = filteredList
        .where((element) =>
    element.from!.toLowerCase().contains(value.toLowerCase()) ||
        element.fromMobileNumber!.contains(value.toLowerCase()))
        .toList();
    emit(SearchedTransactionHistory(searchedTransactions, _selectedSort));
  }

/*  filterTransactions(*//*int selectedSort,*//* DateTime start, DateTime end) async {
    filteredList = transactionHistoryDataList;

  //  _selectedSort = selectedSort;

    filteredList =
    await Repository().queries.getSuspenseAccountForFilter(start, end);
    applySort(selectedSort);
    emit(SearchedSuspenseTransaction(filteredList, selectedSort));
  }*/


  /*void applySort(int selectedSort) {
    switch (selectedSort) {
      case 1:
        filteredList.sort(
                (a, b) => a.from.toLowerCase().compareTo(b.from.toLowerCase()));
        // setState(() {});
        break;
      case 2:
        filteredList.sort((a, b) => a.amount.compareTo(b.amount));
        filteredList = filteredList.reversed.toList();
        // setState(() {});
        break;
      case 3:
        filteredList.sort((a, b) => a.amount.compareTo(b.amount));
        break;
      default:
    }
  }*/

 /* Future<void> getDataFromSuspenseAccount() async {
    await SuspenseAccountApi.suspenseAccountApi.getSuspenseAccount();
  }*/
}
