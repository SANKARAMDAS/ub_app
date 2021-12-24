import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';

part 'ledger_state.dart';

class LedgerCubit extends Cubit<LedgerState> {
  LedgerCubit() : super(LedgerInitial());
  Repository repository = Repository();
  List<TransactionModel> ledgerTransactionList = [];
  List<TransactionModel> sortedTransactions = [];

  Future<void> getLedgerData(String customerId) async {
    emit(FetchingLedgerTransactions());
    ledgerTransactionList =
        await repository.queries.getLedgerTransactions(customerId);
    /*ledgerTransactionList.sort((a, b) =>
        (a.date!.isUtc ? a.date!.toLocal() : a.date!)
            .compareTo(b.date!.isUtc ? b.date!.toLocal() : b.date!));*/
    emit(FetchedLedgerTransactions(ledgerTransactionList));
  }

  void sortLedgerTransactions(DateTime? dateTime) {
    sortedTransactions = ledgerTransactionList;
    if (dateTime == null) {
      emit(FetchedLedgerTransactions(
        ledgerTransactionList.reversed.toList(),
      ));
    } else {
      sortedTransactions = ledgerTransactionList.where((e) {
        return e.createddate!.day == dateTime.day &&
            e.createddate!.month == dateTime.month &&
            e.createddate!.year == dateTime.year;
      }).toList();
      emit(FetchedLedgerTransactions(
        sortedTransactions,
      ));
    }
  }

  void searchLedger(String value) {
    if (sortedTransactions.isEmpty) sortedTransactions = ledgerTransactionList;
    final searchedLedgers = sortedTransactions.where((e) {
      return e.details.toLowerCase().contains(value.toLowerCase()) ||
          e.amount!.toString().contains(value.toLowerCase());
    });
    emit(FetchedLedgerTransactions(
      value.isEmpty
          ? sortedTransactions.reversed.toList()
          : searchedLedgers.toList(),
    ));
  }

  sortLedgerByDateRange(DateTime? start, DateTime? end) {
    sortedTransactions = ledgerTransactionList;
    if (start == null || end == null) {
      emit(FetchedLedgerTransactions(ledgerTransactionList.reversed.toList()));
    } else if (start == end) {
      sortedTransactions = ledgerTransactionList
          .where((element) =>
              element.date!.day == start.day &&
              element.date!.month == start.month &&
              element.date!.year == start.year)
          .toList();
      emit(FetchedLedgerTransactions(sortedTransactions));
    } else {
      sortedTransactions = ledgerTransactionList
          .where((element) =>
              (start.isBefore(DateTime(element.date!.year, element.date!.month,
                      element.date!.day)) ||
                  start ==
                      DateTime(element.date!.year, element.date!.month,
                          element.date!.day)) &&
              (end.isAfter(DateTime(element.date!.year, element.date!.month,
                      element.date!.day)) ||
                  end ==
                      DateTime(element.date!.year, element.date!.month,
                          element.date!.day)))
          .toList();
      emit(FetchedLedgerTransactions(sortedTransactions.reversed.toList()));
    }
  }

  Future<void> addLedger(TransactionModel transactionModel,
      void Function() sendMessage, context) async {
    debugPrint('Check Suspense Data: ' + transactionModel.toJson().toString());
    final response =
        await repository.queries.insertLedgerTransaction(transactionModel);
    if (response != null) {
      saveLedger(transactionModel);
      getLedgerData(transactionModel.customerId!);
      final amt = await repository.queries
          .getPaidMinusReceived(transactionModel.customerId!);
      await repository.queries.updateCustomerDetails(
          amt,
          amt.isNegative ? TransactionType.Pay : TransactionType.Receive,
          transactionModel.customerId);
      BlocProvider.of<ContactsCubit>(context).getContacts(
          Provider.of<BusinessProvider>(context, listen: false)
              .selectedBusiness
              .businessId);
      sendMessage();
    }
  }

  Future<void> saveLedger(TransactionModel transactionModel) async {
    if (await checkConnectivity) {
      for (var image in transactionModel.attachments) {
        if (image != null) {
          final uploadApiResponse =
              await repository.ledgerApi.uploadAttachment(image);
          if (uploadApiResponse.isNotEmpty) {
            transactionModel.filePaths.add(uploadApiResponse);
          }
        }
      }
      final apiResponse = await (repository.ledgerApi
          .saveTransaction(transactionModel)
          .catchError((e) {
        debugPrint(e);
        recordError(e, StackTrace.current);
        return false;
      }));
      if (apiResponse) {
        await repository.queries.updateLedgerIsChanged(transactionModel, 0);
      }
    }
  }

  Future<void> updateLedger(TransactionModel transactionModel,
      void Function() sendMessage, BuildContext context) async {
    final response =
        await repository.queries.updateLedgerTransaction(transactionModel);
    if (response != null) {
      updateLedgerEntries(transactionModel);
      getLedgerData(transactionModel.customerId!);
      final amt = await repository.queries
          .getPaidMinusReceived(transactionModel.customerId!);
      await repository.queries.updateCustomerDetails(
          amt,
          amt.isNegative ? TransactionType.Pay : TransactionType.Receive,
          transactionModel.customerId!);
      BlocProvider.of<ContactsCubit>(context).getContacts(
          Provider.of<BusinessProvider>(context, listen: false)
              .selectedBusiness
              .businessId);
      sendMessage();
    }
  }

  Future<void> updateLedgerEntries(TransactionModel transactionModel) async {
    if (await checkConnectivity) {
      for (var image in transactionModel.attachments) {
        if (image != null) {
          final uploadApiResponse =
              await repository.ledgerApi.uploadAttachment(image);
          if (uploadApiResponse.isNotEmpty) {
            transactionModel.filePaths.add(uploadApiResponse);
          }
        }
      }
      final apiResponse = await (repository.ledgerApi
          .saveTransaction(transactionModel)
          .catchError((e) {
        debugPrint(e.toString());
        recordError(e, StackTrace.current);
        return false;
      }));
      if (apiResponse) {
        await repository.queries.updateLedgerIsChanged(transactionModel, 0);
      }
    }
  }

  Future<double> getBalanceOnDate(DateTime dateTime) async {
    double balance = 0;
    for (var ledger in ledgerTransactionList) {
      // debugPrint('Start:' + DateTime.now().toString());
      if (ledger.date!.isBefore(dateTime) || ledger.date == dateTime) {
        if (ledger.transactionType == TransactionType.Pay)
          balance = balance - (ledger.amount ?? 0.0);
        else
          balance = balance + (ledger.amount ?? 0.0);
      }
      // debugPrint('End:' + DateTime.now().toString());
    }
    return balance;
  }

  @override
  void onChange(Change<LedgerState> change) {
    debugPrint(change.toString());
    super.onChange(change);
  }
}
