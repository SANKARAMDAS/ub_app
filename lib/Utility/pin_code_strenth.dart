import 'package:urbanledger/Services/repository.dart';

class PincodeStrenth{
  List<String> commonPincodes =["1234",
    "1111",
    "0000",
    "1212",
    "7777",
    "1004",
    "2000",
    "4444",
    "2222",
    "6969",
    "9999",
    "3333",
    "5555",
    "6666",
    "1122",
    "1313",
    "8888",
    "4321",
    "2001",
  "1010"];
  final Repository repository = Repository();


  bool checkPincodeStrenth(String pinCode){
    String userMobile = repository.hiveQueries.userData.mobileNo.substring(2,6);
    print(userMobile);
    commonPincodes.add(userMobile);

    return commonPincodes.contains(pinCode);
  }
}