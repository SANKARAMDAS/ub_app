part of 'import_contacts_cubit.dart';

abstract class ImportContactsState extends Equatable {
  const ImportContactsState();

  @override
  List<Object> get props => [];
}

class ImportContactsInitial extends ImportContactsState {}

class ContactPermissionStatus extends ImportContactsState {
  final bool status;
  ContactPermissionStatus(this.status);
}

class FetchedImportedContacts extends ImportContactsState {
  final List<ImportContactModel> fetchedContacts;

  FetchedImportedContacts(this.fetchedContacts);

  @override
  List<Object> get props => [fetchedContacts];
}

class SearchedImportedContacts extends ImportContactsState {
  final List<ImportContactModel> searchedContacts;
  final String searchQuery;

  SearchedImportedContacts(this.searchedContacts, this.searchQuery);

  @override
  List<Object> get props => [searchedContacts, searchQuery];
}

class LoadingImportContacts extends ImportContactsState {}
