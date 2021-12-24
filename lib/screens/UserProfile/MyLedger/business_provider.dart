import 'package:flutter/cupertino.dart';
import 'package:urbanledger/Models/business_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';

class BusinessProvider extends ChangeNotifier {
  List<BusinessModel> businesses = [];
  final repository = Repository();
  late BusinessModel selectedBusiness;
  late BusinessModel selectedBusinessForUnrecognized;

  ///Function used to get all Business
  Future<int> getBusinesses() async {
    businesses = await repository.queries.getBusinesses();
    // selectedBusiness =
    //     businesses.firstWhere((element) => element.deleteAction == false);
    notifyListeners();
    return businesses.length;
  }

  ///Function used to add business
  Future<void> addBusiness(BusinessModel businessModel) async {
    if (businesses
        .where((element) => element.businessId == businessModel.businessId)
        .isEmpty) {
      await repository.queries.insertBusiness(businessModel).catchError((e) {
        debugPrint(e);
        recordError(e, StackTrace.current);
      });
      businesses.add(businessModel);
      notifyListeners();
    }
  }

  ///Function used to update selectedBusiness
  BusinessModel updateSelectedBusiness({int? index}) {
    if (index == null) {
      selectedBusiness = repository.hiveQueries.selectedBusiness ??
          businesses.where((element) => element.deleteAction == false).first;
      selectedBusinessForUnrecognized= selectedBusiness;
      repository.hiveQueries.insertSelectedBusiness(selectedBusiness);
    } else {
      selectedBusiness = businesses.elementAt(index);
      selectedBusinessForUnrecognized= selectedBusiness;
      repository.hiveQueries.insertSelectedBusiness(selectedBusiness);
    }
    notifyListeners();
    return selectedBusiness;
  }


  BusinessModel getSelectedBusinessForUnrecognized({int? index}) {
    if (index == null) {
      selectedBusinessForUnrecognized = repository.hiveQueries.selectedBusiness ??
          businesses.where((element) => element.deleteAction == false).first;
     // repository.hiveQueries.insertSelectedBusiness(selectedBusiness);
    } else {
      selectedBusinessForUnrecognized = businesses.elementAt(index);
     // repository.hiveQueries.insertSelectedBusiness(selectedBusiness);
    }
    notifyListeners();
    return selectedBusinessForUnrecognized;
  }

  ///Function used to delete the business
  void deleteBusiness(int index) {
    if (selectedBusiness.businessId == businesses[index].businessId) {
      updateSelectedBusiness();
    }
    businesses.removeAt(index);
    notifyListeners();
  }

  ///Function used to rename the business
  void renameBusiness(int index, BusinessModel updatedModel) {
    businesses[index] = updatedModel;
    if (selectedBusiness.businessId == businesses[index].businessId) {
      repository.hiveQueries.insertSelectedBusiness(updatedModel);
      updateSelectedBusiness();
    }
    notifyListeners();
  }
}
