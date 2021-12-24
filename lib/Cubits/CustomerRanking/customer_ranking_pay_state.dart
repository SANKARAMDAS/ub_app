part of 'customer_ranking_pay_cubit.dart';

abstract class CustomerRankingPayState extends Equatable {
  const CustomerRankingPayState();

  @override
  List<Object> get props => [];
}

class CustomerRankingPayInitial extends CustomerRankingPayState {}

class FetchingCustomerRankingPayTransactions extends CustomerRankingPayState {}

class FetchedCustomerRankingPayTransactions extends CustomerRankingPayState {
  final List<CustomerRankingData> customerRankingPayDataList;
  final int payPageCount;

  FetchedCustomerRankingPayTransactions(this.customerRankingPayDataList,this.payPageCount);

  @override
  List<Object> get props => [customerRankingPayDataList];
}


class SearchedRankedCustomer extends CustomerRankingPayState {
  final List<CustomerRankingData> searchedCustomerList;

  final int selectedSort;

  SearchedRankedCustomer(this.searchedCustomerList, this.selectedSort);

  @override
  List<Object> get props => [searchedCustomerList, selectedSort];
}
