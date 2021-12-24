import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:urbanledger/Models/customer_ranking_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';


class CustomerRankingApi {
  CustomerRankingApi._();

  static final CustomerRankingApi customerRankingApi = CustomerRankingApi._();





  Future<CustomerRankingModel?>  getCustomerRanking(RequestType type,BuildContext context) async {
    CustomerRankingModel? model;
    String businessId =Provider.of<BusinessProvider>(context,
        listen: false)
        .selectedBusiness
        .businessId;
    const url = "payment/getPaymentContacts";
    final response = await postRequest(
      endpoint: url,
      headers: apiAuthHeader(),
        body: jsonEncode({
          "type":type == RequestType.PAY?'pay':'recieve',
          "ledger_id": businessId
        })
    );
    if (response.statusCode == 200) {
      try{
        print(jsonDecode(response.body));

          model = CustomerRankingModelFromJson(response.body);
          print(model.data!.length);
          await Repository().queries.clearCustomerRankingType(type == RequestType.PAY?'pay':'recieve');
          model.data!.forEach((element) async {
            debugPrint('Check11' + element.id.toString());
            element.type = type == RequestType.PAY?'pay':'recieve';
            await Repository().queries.insertCustomerRanking(element);
          });


      }
      catch(e){
        print(e);
      }
    }
    return model;
  }


}
enum RequestType{PAY,RECIEVE}
