import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:urbanledger/Models/customer_ranking_model.dart';
import 'package:urbanledger/Services/APIs/customer_ranking_api.dart';
import 'package:urbanledger/Services/APIs/suspense_account_api.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/chat_module/screens/contact/request_controller.dart';

part 'customer_ranking_pay_state.dart';

class CustomerRankingPayCubit extends Cubit<CustomerRankingPayState> {
  CustomerRankingPayCubit() : super(CustomerRankingPayInitial());

  List<CustomerRankingData> customerRankingPayDataList = [];
  List<CustomerRankingData> filteredList = [];
  int totalPayPageCount = 0;


  int _selectedSort = 1;
  CustomerRankingModel customerRankingPayModel= new CustomerRankingModel();


  Future<void> getCustomerRankingPayTransactions(RequestType type,int pageNo,BuildContext context) async {

    emit(FetchingCustomerRankingPayTransactions());
    await getPayDataFromCustomerRanking(type,context);
    getCustomerRankingPayTransactionsOffline(type,pageNo);
  }

  Future<void> getCustomerRankingPayTransactionsOffline(RequestType type,int pageNo) async {
   // emit(FetchingCustomerRankingPayTransactions());
    customerRankingPayModel = await Repository().queries.getCustomerRanking(7,type,pageNo);
    totalPayPageCount = customerRankingPayModel.totalPages!;
    customerRankingPayDataList = customerRankingPayModel.data!;
    emit(FetchedCustomerRankingPayTransactions(customerRankingPayDataList,totalPayPageCount));

  }

/*  void searchTransactions(String value) {
    if (filteredList.isEmpty) filteredList = customerRankingDataList;
    final searchedTransactions = filteredList
        .where((element) =>
    element.firstName!.toLowerCase().contains(value.toLowerCase()) ||
        element.mobileNo!.contains(value.toLowerCase()) ||
        element.lastName!.contains(value.toLowerCase()))
        .toList();
    emit(SearchedRankedCustomer(searchedTransactions, _selectedSort));
  }*/

/*  filterTransactions(int selectedSort, DateTime start, DateTime end) async {
    filteredList = customerRankingDataList;

    _selectedSort = selectedSort;

    filteredList =
    await Repository().queries.getCustomerRankingForFilter(start, end);
    applySort(selectedSort);
    emit(SearchedRankedCustomer(filteredList, selectedSort));
  }*/



  void applySort(int selectedSort) {
    switch (selectedSort) {
      case 1:
        filteredList.sort(
                (a, b) => a.firstName!.toLowerCase().compareTo(b.firstName!.toLowerCase()));
        // setState(() {});
        break;
      case 2:
        filteredList.sort((a, b) => a.lastName!.compareTo(b.lastName!));
        filteredList = filteredList.reversed.toList();
        // setState(() {});
        break;
      case 3:
        filteredList.sort((a, b) => a.updatedAt!.compareTo(b.updatedAt!));
        break;
      default:
    }
  }

  Future<void> getPayDataFromCustomerRanking( type,BuildContext context) async {
   // emit(FetchingCustomerRankingTransactions());
    await CustomerRankingApi.customerRankingApi.getCustomerRanking(type,context);
   // emit(FetchedCustomerRankingTransactions(customerRankingDataList,totalPageCount));
  }
}
