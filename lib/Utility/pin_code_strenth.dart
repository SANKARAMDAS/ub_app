import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';
import 'package:collection/collection.dart';

class PincodeStrenth{
  /*List<String> commonPincodes =["1234",
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
  "5683"];*/

  List<String> commonPincodes =[
    "1004",
    "2000",
    "2001",
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


    return commonPincodes.contains(pinCode)
        || alldigitsEqual(pinCode)
        || repetativePattern(pinCode)
        || sequencePattern(pinCode)
        ||revSeqPattern(pinCode);
  }

   bool alldigitsEqual(String pinCode){
    var pinArr = pinCode.split('');
    bool result = pinArr.every((element) => element == pinArr[0]);
    return result;
  }

  bool repetativePattern(String pinCode){
    var pinArr = pinCode.split('');
    bool result = pinArr[0]==pinArr[2] && pinArr[1] == pinArr[3] || pinArr[0]==pinArr[1] && pinArr[2] == pinArr[3];
    return result;
  }

  bool sequencePattern(String pinCode){
    List<String> pinArr = pinCode.split('');
   var firstElement = pinArr.first;
   List<String> constructedList = [];
   for(int i = 0;i<pinArr.length;i++){
     constructedList.add('${int.parse(firstElement)+i}');
   }
    Function eq = const ListEquality().equals;
   bool result =eq(pinArr, constructedList);

    return result;
  }


  bool revSeqPattern(String pinCode){
    List<String> pinArr = pinCode.split('');
    var lastElement = pinArr.last;
    List<String> constructedList = [];
    for(int i = pinArr.length-1;i>=0;i--){
      constructedList.add('${int.parse(lastElement)+i}');
    }
    Function eq = const ListEquality().equals;
    bool result =eq(pinArr, constructedList);

    return result;
  }
}