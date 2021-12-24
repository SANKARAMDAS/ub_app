import 'package:flutter/cupertino.dart';
import 'package:urbanledger/Services/APIs/kyc_api.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class KycProvider with ChangeNotifier {
  bool isPremium = false;

  updateKyc() async {
    await getKyc();
    calculatePremiumDate();
    notifyListeners();
  }

  getKyc() async {
    await KycAPI.kycApiProvider.kycCheker().then((value) {
      debugPrint('Check the value : ' + value.toString());

      if (value != null && value.toString().isNotEmpty) {
        isPremium = value['premium'] ?? false;

        return;
      }
    });
  }
}
