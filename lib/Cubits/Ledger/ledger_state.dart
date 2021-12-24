part of 'ledger_cubit.dart';

abstract class LedgerState extends Equatable {
  const LedgerState();

  @override
  List<Object> get props => [];
}

class LedgerInitial extends LedgerState {}

class FetchingLedgerTransactions extends LedgerState {}

class FetchedLedgerTransactions extends LedgerState {
  final List<TransactionModel> ledgerTransactionList;

  FetchedLedgerTransactions(
      this.ledgerTransactionList);

  @override
  List<Object> get props => [ledgerTransactionList];
}

/* class SortedLedgerTransactions extends LedgerState {
  final List<TransactionModel> ledgerTransactionList;

  SortedLedgerTransactions(this.ledgerTransactionList);

  @override
  List<Object> get props => [ledgerTransactionList];
} */

/* class SearchedLedgerTransactions extends LedgerState {
  final List<TransactionModel> ledgerTransactionList;

  SearchedLedgerTransactions(this.ledgerTransactionList);

  @override
  List<Object> get props => [ledgerTransactionList];
} */
