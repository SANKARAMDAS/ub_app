import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';

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
  "1010",
  "0852",
  "1998",
  "2580",
  "5683"];
  final Repository repository = Repository();


  Future<bool> checkPincodeStrenth(String pinCode) async {
   // String userMobile = repository.hiveQueries.userData.mobileNo.substring(2,6);
    String fullNo = await CustomSharedPreferences.get('ph_no_without_co');
    String userMobile = fullNo.substring(0,4);
    print(userMobile);
    commonPincodes.add(userMobile);

    return commonPincodes.contains(pinCode);
  }
}