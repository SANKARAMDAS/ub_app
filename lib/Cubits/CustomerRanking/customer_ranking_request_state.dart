part of 'customer_ranking_request_cubit.dart';

abstract class CustomerRankingRequestState extends Equatable {
  const CustomerRankingRequestState();

  @override
  List<Object> get props => [];
}

class CustomerRankingRequestInitial extends CustomerRankingRequestState {}



class FetchingCustomerRankingRequestTransactions extends CustomerRankingRequestState {}

class FetchedCustomerRankingRequestTransactions extends CustomerRankingRequestState {
  final List<CustomerRankingData> customerRankingRequestDataList;
  final int requestPageCount;

  FetchedCustomerRankingRequestTransactions(this.customerRankingRequestDataList,this.requestPageCount);

  @override
  List<Object> get props => [customerRankingRequestDataList];
}

class SearchedRankedCustomer extends CustomerRankingRequestState {
  final List<CustomerRankingData> searchedCustomerList;

  final int selectedSort;

  SearchedRankedCustomer(this.searchedCustomerList, this.selectedSort);

  @override
  List<Object> get props => [searchedCustomerList, selectedSort];
}
