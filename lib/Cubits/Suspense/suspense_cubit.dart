import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:urbanledger/Models/SuspenseAccountModel.dart';
import 'package:urbanledger/Services/APIs/suspense_account_api.dart';
import 'package:urbanledger/Services/repository.dart';

part 'suspense_state.dart';

class SuspenseCubit extends Cubit<SuspenseState> {
  SuspenseCubit() : super(SuspenseInitial());

  List<SuspenseData> suspenseDataList = [];
  List<SuspenseData> filteredList = [];

  int _selectedSort = 1;

  Future<void> getSuspenseTransactions(bool fetchFull) async {
    emit(FetchingSuspenseTranasctions());
    if (fetchFull) {
      await getDataFromSuspenseAccount();
      suspenseDataList = await Repository().queries.getSuspenseAccount();
      debugPrint("CHecking" + suspenseDataList.length.toString());
    }
    emit(FetchedSuspenseTranasctions(suspenseDataList));
  }

  void searchTransactions(String value) {
    if (filteredList.isEmpty) filteredList = suspenseDataList;
    final searchedTransactions = filteredList
        .where((element) =>
            element.from.toLowerCase().contains(value.toLowerCase()) ||
            element.fromCustId!.mobileNo.contains(value.toLowerCase()) ||
            element.fromMobileNumber!.contains(value.toLowerCase()))
        .toList();
    emit(SearchedSuspenseTransaction(searchedTransactions, _selectedSort));
  }

  filterTransactions(int selectedSort, DateTime start, DateTime end) async {
    filteredList = suspenseDataList;

    _selectedSort = selectedSort;

    filteredList =
        await Repository().queries.getSuspenseAccountForFilter(start, end);
    applySort(selectedSort);
    emit(SearchedSuspenseTransaction(filteredList, selectedSort));
  }

  void applySort(int selectedSort) {
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
  }

  Future<void> getDataFromSuspenseAccount() async {
    await SuspenseAccountApi.suspenseAccountApi.getSuspenseAccount();
  }
}
