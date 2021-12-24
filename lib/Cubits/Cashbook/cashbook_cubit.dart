import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:urbanledger/Models/cashbook_entry_model.dart';
import 'package:urbanledger/Services/repository.dart';

part 'cashbook_state.dart';

class CashbookCubit extends Cubit<CashbookState> {
  CashbookCubit() : super(CashbookInitial());
  Repository repository = Repository();
  List<CashbookEntryModel> cashbookEntryList = [];
  List<CashbookEntryModel> sortedTransactions = [];

  Future<void> getCashbookData(DateTime date, String businessId) async {
    emit(FetchingCashbookTransactions());
    cashbookEntryList =
        await repository.queries.getCashbookEntrys(date, businessId);
    emit(FetchedCashbookTransactions(cashbookEntryList.reversed.toList()));
  }

  void sortCashbookTransactions(DateTime? dateTime) {
    sortedTransactions = cashbookEntryList;
    if (dateTime == null) {
      emit(FetchedCashbookTransactions(cashbookEntryList.reversed.toList()));
    } else {
      sortedTransactions = cashbookEntryList.where((e) {
        return e.createdDate.day == dateTime.day &&
            e.createdDate.month == dateTime.month &&
            e.createdDate.year == dateTime.year;
      }).toList();
      emit(FetchedCashbookTransactions(sortedTransactions));
    }
  }
}
