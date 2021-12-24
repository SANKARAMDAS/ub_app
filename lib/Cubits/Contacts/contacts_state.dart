part of 'contacts_cubit.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {}

class SearchedContacts extends ContactsState {
  final List<CustomerModel> searchedCustomerList;
  final int selectedFilter;
  final int selectedSort;

  SearchedContacts(
      this.searchedCustomerList, this.selectedFilter, this.selectedSort);

  @override
  List<Object?> get props =>
      [searchedCustomerList, selectedFilter, selectedSort];
}

class FetchedContacts extends ContactsState {
  final List<CustomerModel> customerList;

  FetchedContacts(this.customerList);

  @override
  List<Object> get props => [customerList];
}
