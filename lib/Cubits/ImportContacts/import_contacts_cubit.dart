import 'package:bloc/bloc.dart';
// import 'package:contacts_service/contacts_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/import_contact_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:uuid/uuid.dart';

part 'import_contacts_state.dart';

class ImportContactsCubit extends Cubit<ImportContactsState> {
  ImportContactsCubit() : super(ImportContactsInitial());
  final Repository repository = Repository();
  List contacts = [];
  List<ImportContactModel> customers = [];
  final regExp = RegExp(r"[^0-9+]");

  Future<void> getContactsFromDevice() async {
    emit(LoadingImportContacts());
    if (contacts.isEmpty) {
      customers = await repository.queries.getContacts();
      if (await Permission.contacts.isGranted) if (customers.length == 0) {
        // contacts =
        //     (await ContactsService.getContacts(withThumbnails: true)).toList();

        await Contacts.streamContacts().forEach((contact) async {
          if (contact.phones.toList().isNotEmpty) {
            for (var phone in contact.phones.toList()) {
              if (phone.value != null) {
                final contactNo = phone.value!.replaceAll(regExp, '');
                // debugPrint(contactNo);
                final isValid = await PhoneNumberUtil.isValidPhoneNumber(
                    phoneNumber: contactNo,
                    isoCode: repository.hiveQueries.isoCode);
                // debugPrint(isValid.toString());
                // debugPrint(repository.hiveQueries.isoCode.toString());
                if (isValid ?? false) {
                  final phoneNumber =
                      (await PhoneNumberUtil.normalizePhoneNumber(
                              phoneNumber: contactNo,
                              isoCode: repository.hiveQueries.isoCode))
                          ?.replaceAll('+', '');
                  if (customers
                      .where((element) => element.mobileNo == phoneNumber)
                      .isEmpty) {
                    final importContactModel = ImportContactModel(
                      id: Uuid().v1(),
                      avatar: contact.avatar,
                      mobileNo: phoneNumber!,
                      name: contact.displayName ?? '',
                    );
                    customers.add(importContactModel);
                    emit(FetchedImportedContacts(customers));
                    repository.queries.insertContact(importContactModel);
                  }
                }
              }
            }
          }
        });
        customers.sort((a, b) => a.name.compareTo(b.name));
        emit(FetchedImportedContacts(customers));
      }
      syncContacts();
    }
    emit(FetchedImportedContacts(customers));
  }

  void searchImportedContacts(String searchQuery) {
    final searchedContacts = customers
        .where((element) =>
            element.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            element.mobileNo.contains(searchQuery.toLowerCase()))
        .toList();
    emit(SearchedImportedContacts(searchedContacts, searchQuery));
  }

  checkContactsPermission() async{
    PermissionStatus permissionStatus =  await requestPermission();

    if(permissionStatus.isGranted){
      emit(ContactPermissionStatus(true));
    }
    else if(permissionStatus.isPermanentlyDenied){
      await clearContacts();
      emit(ContactPermissionStatus(false));
    }


  }

  Future<PermissionStatus> requestPermission() async {
    PermissionStatus value = await Permission.contacts.request();
    return value;
  }

  Future<int> updateContacts(bool fromPhoneBook) async {
    int count = 0;
    if(fromPhoneBook){
      await Contacts.streamContacts(sortBy: ContactSortOrder.firstName()).forEach((contact) async {
        if (contact.phones.toList().isNotEmpty) {
          for (var phone in contact.phones.toList()) {
            if (phone.value != null) {
              final contactNo = phone.value!.replaceAll(regExp, '');
              // debugPrint(contactNo);
              final isValid = await PhoneNumberUtil.isValidPhoneNumber(
                  phoneNumber: contactNo,
                  isoCode: repository.hiveQueries.isoCode);
              // debugPrint(isValid.toString());
              // debugPrint(repository.hiveQueries.isoCode.toString());
              if (isValid ?? false) {
                final phoneNumber = (await PhoneNumberUtil.normalizePhoneNumber(
                    phoneNumber: contactNo,
                    isoCode: repository.hiveQueries.isoCode))
                    ?.replaceAll('+', '');
                if (customers
                    .where((element) => element.mobileNo == phoneNumber)
                    .isEmpty) {
                  final importContactModel = ImportContactModel(
                    id: Uuid().v1(),
                    avatar: contact.avatar,
                    mobileNo: phoneNumber!,
                    name: contact.displayName ?? '',
                  );
                  customers.add(importContactModel);
                  count++;
                  repository.queries.insertContact(importContactModel);
                }
              }
            }
          }
        }
      });
      if (count >= 0) {
        // customers.sort((a, b) => a.name.compareTo(b.name));
        emit(FetchedImportedContacts(customers));
        // syncContacts();
      }
    }
    else{
      customers = await repository.queries.getContacts();
      count = customers.length;
      if (count >= 0) {
        // customers.sort((a, b) => a.name.compareTo(b.name));
        emit(FetchedImportedContacts(customers));
        // syncContacts();
      }
    }

    return count;
  }

  clearContacts() async {
   await repository.queries.clearImportedContacts();
  }

  Future<void> syncContacts() async {
    final contactsToUpdate =
        customers.where((element) => element.customerId == null).toList();
    List<ImportContactModel> listOf25 = [];
    int listlength = contactsToUpdate.length;
    int i = 0;

    while (i < listlength) {
      int start = i;
      int end = i + 25 > listlength ? listlength : i + 25;

      for (int j = start; j < end; j++) {
        listOf25.add(contactsToUpdate[j]);
        // print('$j Adding element to list');
      }
      // print('Api call');

      final syncedContacts = await repository.customerApi
          .contactSync(listOf25.map((e) => e.mobileNo).toList());

      await Future.forEach<dynamic>(syncedContacts, (element) {
        if (element['customer_id'] != null && element['mobile_no'] != null)
          repository.queries
              .updateContact(element['customer_id']!, element['mobile_no']!);
      });

      listOf25.clear();
      i += 25;
    }

    customers = await repository.queries.getContacts();
    emit(FetchedImportedContacts(customers));
  }

  @override
  void onChange(Change<ImportContactsState> change) {
    debugPrint(change.toString());
    super.onChange(change);
  }
}
