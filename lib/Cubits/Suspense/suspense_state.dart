part of 'suspense_cubit.dart';

abstract class SuspenseState extends Equatable {
  const SuspenseState();

  @override
  List<Object> get props => [];
}

class SuspenseInitial extends SuspenseState {}

class FetchingSuspenseTranasctions extends SuspenseState {}

class FetchedSuspenseTranasctions extends SuspenseState {
  final List<SuspenseData> suspenseDataList;

  FetchedSuspenseTranasctions(this.suspenseDataList);

  @override
  List<Object> get props => [suspenseDataList];
}

class SearchedSuspenseTransaction extends SuspenseState {
  final List<SuspenseData> searchedCustomerList;

  final int selectedSort;

  SearchedSuspenseTransaction(this.searchedCustomerList, this.selectedSort);

  @override
  List<Object> get props => [searchedCustomerList, selectedSort];
}
