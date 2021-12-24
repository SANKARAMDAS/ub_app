part of 'cashbook_cubit.dart';

abstract class CashbookState extends Equatable {
  const CashbookState();

  @override
  List<Object> get props => [];
}

class CashbookInitial extends CashbookState {}

class FetchingCashbookTransactions extends CashbookState {}

class FetchedCashbookTransactions extends CashbookState {
  final List<CashbookEntryModel> cashbookEntryList;

  FetchedCashbookTransactions(this.cashbookEntryList);

  @override
  List<Object> get props => [cashbookEntryList];
}
