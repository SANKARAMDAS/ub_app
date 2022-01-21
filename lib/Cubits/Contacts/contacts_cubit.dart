import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_methods.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(ContactsInitial());
  List<CustomerModel> customerList = [];
  List<CustomerModel> filteredList = [];
  int _selectedFilter = 1;
  int _selectedSort = 1;
  Repository _repository = Repository();

  Future<void> getContacts(String businessId) async {
    if (businessId.isEmpty) {
      customerList = [];
    } else {
      customerList = await _repository.queries.getCustomers(businessId);
    }
    isCustomerAddedNotifier.value = !isCustomerAddedNotifier.value;
    customerList.sort((a, b) => a.updatedAt!.compareTo(b.updatedAt!));
    emit(FetchedContacts(customerList.reversed.toList()));
  }

  void deleteContact(String customerId) {
    customerList.removeWhere((element) => element.customerId == customerId);
    if (filteredList.isNotEmpty)
      filteredList.removeWhere((element) => element.customerId == customerId);
    if (customerList.isEmpty)
      isCustomerAddedNotifier.value = !isCustomerAddedNotifier.value;
    emit(FetchedContacts(customerList.reversed.toList()));
  }

  void searchContacts(String value) {
    if (filteredList.isEmpty) filteredList = customerList;
    final searchedCustomers = filteredList
        .where((element) =>
            element.name!.toLowerCase().contains(value.toLowerCase()) ||
            element.mobileNo!.contains(value.toLowerCase()))
        .toList();
    emit(SearchedContacts(searchedCustomers, _selectedFilter, _selectedSort));
  }

  void filterContacts(int selectedFilter, int selectedSort) {
   try{
     filteredList = customerList;
     _selectedFilter = selectedFilter;
     _selectedSort = selectedSort;

     if (selectedFilter == 2) {
       filteredList = filteredList.where((e) {
         return e.transactionType == TransactionType.Pay;
       }).toList();
     } else if (selectedFilter == 3) {
       filteredList = filteredList.where((e) {
         return e.transactionType == TransactionType.Receive;
       }).toList();
     } else if (selectedFilter == 4) {
       filteredList = filteredList.where((e) {
         return e.transactionAmount == 0;
       }).toList();
     }

     if (selectedSort == 1) {
       filteredList.sort((a, b) => a.updatedDate!.compareTo(b.updatedDate!));
       emit(SearchedContacts(
           filteredList.reversed.toList(), _selectedFilter, _selectedSort));
       return;
     } else if (selectedSort == 2) {
       filteredList.sort((a, b) => removeNegativeIfNegative(a.transactionAmount)
           .compareTo(removeNegativeIfNegative(b.transactionAmount)));
       emit(SearchedContacts(
           filteredList.reversed.toList(), _selectedFilter, _selectedSort));
       return;
     } else if (selectedSort == 3) {
       filteredList.sort(
               (a, b) => a.name!.toUpperCase().compareTo(b.name!.toUpperCase()));
       emit(SearchedContacts(filteredList, _selectedFilter, _selectedSort));
       return;
     } else if (selectedSort == 4) {
       filteredList.sort((a, b) => a.updatedDate!.compareTo(b.updatedDate!));
       emit(SearchedContacts(filteredList, _selectedFilter, _selectedSort));
       return;
     } else if (selectedSort == 5) {
       filteredList.sort((a, b) => removeNegativeIfNegative(a.transactionAmount)
           .compareTo(removeNegativeIfNegative(b.transactionAmount)));
       emit(SearchedContacts(filteredList, _selectedFilter, _selectedSort));
       return;
     }
   }
   catch(e){
     print(e);
   }
  }

  void sortCustomersByDateRange(DateTime? start, DateTime? end) {
    filteredList = customerList;
    if (start == null || end == null) {
      emit(SearchedContacts(filteredList, 1, 1));
    } else if (start == end) {
      filteredList = customerList
          .where((element) =>
              element.updatedDate!.day == start.day &&
              element.updatedDate!.month == start.month &&
              element.updatedDate!.year == start.year)
          .toList();
      emit(SearchedContacts(filteredList, 1, 1));
    } else {
      filteredList = customerList
          .where((element) =>
              (start.isBefore(DateTime(element.updatedDate!.year,
                      element.updatedDate!.month, element.updatedDate!.day)) ||
                  start ==
                      DateTime(
                          element.updatedDate!.year,
                          element.updatedDate!.month,
                          element.updatedDate!.day)) &&
              (end.isAfter(DateTime(element.updatedDate!.year,
                      element.updatedDate!.month, element.updatedDate!.day)) ||
                  end ==
                      DateTime(
                          element.updatedDate!.year,
                          element.updatedDate!.month,
                          element.updatedDate!.day)))
          .toList();
      emit(SearchedContacts(filteredList.reversed.toList(), 1, 1));
    }
  }

  void sortByDate(DateTime? dateTime) {
    if (dateTime == null) {
      emit(SearchedContacts(filteredList, 1, 1));
    } else {
      final sortedContacts = filteredList.where((e) {
        return e.updatedDate!.day == dateTime.day &&
            e.updatedDate!.month == dateTime.month &&
            e.updatedDate!.year == dateTime.year;
      }).toList();
      emit(SearchedContacts(sortedContacts, 1, 1));
    }
  }

  bool checkCustomerIsAdded(String phone) {
    return customerList.where((element) => element.mobileNo == phone).isEmpty
        ? false
        : true;
  }
}
