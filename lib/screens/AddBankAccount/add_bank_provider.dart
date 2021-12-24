import 'package:flutter/material.dart';
import 'package:urbanledger/Services/APIs/bank_api.dart';
import 'package:urbanledger/screens/AddBankAccount/bankModel.dart';

class AddBankProvider with ChangeNotifier {
  List<String> abcCheck = [];
  List<ListOfBankModel> _bank = [];

  List<ListOfBankModel> get bank => _bank;

  getListofBank() async {
    _bank = await BankAPI.bankProvider.getListOfBankFromAPI();
    notifyListeners();
  }

  addBankInList(ListOfBankModel addBank) {
    _bank.add(addBankInList(addBank));
    notifyListeners();
  }

  sortedBankName() {
    abcCheck.clear();
    _bank.forEach((element) {
      abcCheck.add(element.name!);
    });
    debugPrint('Check length of bank' + _bank.length.toString());
    debugPrint('Check length of bank name' + abcCheck.length.toString());
    notifyListeners();
    return abcCheck;
  }
}

// BankModel(
//   name: 'Abu Dhabi Islamic Bank(ADIB)',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '1',
// ),
// BankModel(
//   name: 'Abu Dhabi Commercial Bank(ADCB)',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '2',
// ),
// BankModel(
//   name: 'Ajman Bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '3',
// ),
// BankModel(
//   name: 'Al Ahli Bank of Kuwait K.S.C.',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '4',
// ),
// BankModel(
//   name: 'Al Ain Finance',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '5',
// ),
// BankModel(
//   name: 'Al Hail ORIX Finance PSC',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '6',
// ),
// BankModel(
//   name: 'Al Hilal Bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '7',
// ),
// BankModel(
//   name: 'Al Khaliji France S.A.',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '8',
// ),
// BankModel(
//   name: 'Al Masraf',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '9',
// ),
// BankModel(
//   name: 'Arab African International Bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '10',
// ),
// BankModel(
//   name: 'Arab Bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '11',
// ),
// BankModel(
//   name: 'Bank of Baroda',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '12',
// ),
// BankModel(
//   name: 'Bank of Sharjah',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '13',
// ),
// BankModel(
//   name: 'Banque Misr',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '14',
// ),
// BankModel(
//   name: 'Barclays bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '15',
// ),
// BankModel(
//   name: 'Blom Bank France',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '16',
// ),
// BankModel(
//   name: 'BNP Paribas',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '17',
// ),
// BankModel(
//   name: 'Citibank NA',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '18',
// ),
// BankModel(
//   name: 'Commercial Bank International PSC',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '19',
// ),
// BankModel(
//   name: 'Commercial Bank of Dubai(CBD)',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '20',
// ),
// BankModel(
//   name: 'Credit Agricole Corporate and Investment Bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '21',
// ),
// BankModel(
//   name: 'DEEM Finance',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '22',
// ),
// BankModel(
//   name: 'Deutsche Bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '23',
// ),
// BankModel(
//   name: 'Doha Bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '24',
// ),
// BankModel(
//   name: 'Dubai Bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '25',
// ),
// BankModel(
//   name: 'Dubai First',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '26',
// ),
// BankModel(
//   name: 'Dubai Islamic Bank((DIB)',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '27',
// ),
// BankModel(
//   name: 'El Nilein Bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '28',
// ),
// BankModel(
//   name: 'Emirates Investment Bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '29',
// ),
// BankModel(
//   name: 'Emirates Islamic Bank PJSC',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '30',
// ),
// BankModel(
//   name: 'EmiratesNBD Bank PJSC(ENBD)',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '31',
// ),
// BankModel(
//   name: 'Finance House',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '32',
// ),
// BankModel(
//   name: 'First Abu Dhabi Bank(FAB)',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '33',
// ),
// BankModel(
//   name: 'First Abu Dhabi Bank Erstwhile FGB',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '34',
// ),
// BankModel(
//   name: 'Habib Bank AG Zurich',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '35',
// ),
// BankModel(
//   name: 'Habib Bank Limited',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '36',
// ),
// BankModel(
//   name: 'HSBC Middle East',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '37',
// ),
// BankModel(
//   name: 'Industrial and Commercial Bank of China',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '38',
// ),
// BankModel(
//   name: 'Investbank PSC',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '39',
// ),
// BankModel(
//   name: 'Islamic Finance Company',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '40',
// ),
// BankModel(
//   name: 'Islamic Finance House',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '41',
// ),
// BankModel(
//   name: 'Janata Bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '42',
// ),
// BankModel(
//   name: 'Lloyds TSB',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '43',
// ),
// BankModel(
//   name: 'Mashreq Bank PSC',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '44',
// ),
// BankModel(
//   name: 'National Bank of Bahrain',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '45',
// ),
// BankModel(
//   name: 'National Bank of Fujairah',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '46',
// ),
// BankModel(
//   name: 'National Bank of Kuwait',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '47',
// ),
// BankModel(
//   name: 'National Bank of Oman',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '48',
// ),
// BankModel(
//   name: 'National Bank of Umm Al Qaiwain',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '49',
// ),
// BankModel(
//   name: 'Noor Islamic Bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '50',
// ),
// BankModel(
//   name: 'Rafidain Bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '51',
// ),
// BankModel(
//   name: 'RAK Bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '52',
// ),
// BankModel(
//   name: 'Sharjah Islamic Bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '53',
// ),
// BankModel(
//   name: 'Standard Chartered Bank',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '54',
// ),
// BankModel(
//   name: 'The Royal Bank of Scotland N.V.',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '55',
// ),
// BankModel(
//   name: 'United Arab Bank PJSC',
//   imageIcon: 'assets/icons/Bank.png',
//   isDefault: false,
//   id: '56',
// ),
