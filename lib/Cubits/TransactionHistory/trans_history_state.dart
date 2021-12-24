
part of 'trans_history_cubit.dart';
abstract class TransHistoryState extends Equatable {
  const TransHistoryState();

  @override
  List<Object> get props => [];
}

class TransactionHistoryInitial extends TransHistoryState {}

class FetchingTranasctionHistory extends TransHistoryState {}

class FetchedTranasctionHistory extends TransHistoryState {
  final List<Datum> transactionHistoryDataList;

  FetchedTranasctionHistory(this.transactionHistoryDataList);

  @override
  List<Object> get props => [transactionHistoryDataList];
}

class SearchedTransactionHistory extends TransHistoryState {
  final List<Datum> searchedCustomerList;

  final int selectedSort;

  SearchedTransactionHistory(this.searchedCustomerList, this.selectedSort);

  @override
  List<Object> get props => [searchedCustomerList, selectedSort];
}
