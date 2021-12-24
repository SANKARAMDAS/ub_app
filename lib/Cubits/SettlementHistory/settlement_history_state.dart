part of 'settlement_history_cubit.dart';

abstract class SettlementHistoryState extends Equatable {
  const SettlementHistoryState();

  @override
  List<Object> get props => [];
}

class SettlementHistoryInitial extends SettlementHistoryState {}

class FetchingSettlementHistory extends SettlementHistoryState {}

class FetchedSettlementHistory extends SettlementHistoryState {
  final List<SettlementHistoryData> settlementHistoryDataList;

  FetchedSettlementHistory(this.settlementHistoryDataList);

  @override
  List<Object> get props => [settlementHistoryDataList];
}

class SearchedSettlementHistory extends SettlementHistoryState {
  final List<SettlementHistoryData> searchedSettlementHistoryList;

  final int selectedSort;

  SearchedSettlementHistory(this.searchedSettlementHistoryList, this.selectedSort);

  @override
  List<Object> get props => [searchedSettlementHistoryList, selectedSort];
}
