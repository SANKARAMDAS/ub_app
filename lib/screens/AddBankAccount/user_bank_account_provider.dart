import 'package:flutter/material.dart';
import 'package:urbanledger/Services/APIs/bank_api.dart';
import 'package:urbanledger/screens/AddBankAccount/userGetBankAccountModel.dart';

class UserBankAccountProvider with ChangeNotifier {
  List<UserBankModel> _account = [];

  List<UserBankModel> get account => _account;

  bool get isAccount => _account.isEmpty;

 Future addUserBankAccount(Map bank, BuildContext context)async {
   await  BankAPI.bankProvider.saveBank(Bank: bank,context:context);
    notifyListeners();
  }

  deleteUserBankAccount(String bankId) {
    BankAPI.bankProvider.deleteBank(bankId);
    getUserBankAccount();
    notifyListeners();
  }

  Future getUserBankAccount() async {
    _account.clear();
    _account = await BankAPI.bankProvider.getBank();
    notifyListeners();
  }
}
