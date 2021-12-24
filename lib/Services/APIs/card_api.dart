import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:urbanledger/Models/add_card_model.dart';
import 'package:urbanledger/Models/verify_card_model.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/screens/mobile_analytics/analytics_events.dart';

class CardAPI {
  CardAPI._();

  static final CardAPI cardsProvider = CardAPI._();

  Future<List<CardDetailsModel>> getAllCards() async {
    List<CardDetailsModel> getCardModel;
    const url = "card/get";
    final response = await postRequest(
      endpoint: url,
      headers: apiAuthHeaderWithOnlyToken(),
    );
    debugPrint('Get All Cards: ' + response.body.toString());

    if (response.statusCode == 200) {
      debugPrint('Get All Cards: ' + response.body.toString());
      getCardModel = cardDetailsModelFromJson(response.body);
      print('test');
      return getCardModel;
    }
    return Future.error('Unexpected Error occured');
  }

  Future<bool> deleteCard(String? cardID) async {
    bool isDeleted = false;
    const url = "card/delete";
    final response = await postRequest(
      endpoint: url,
      headers: apiAuthHeaderWithOnlyToken(),
      body: {"id": "$cardID"},
    );
    if (response.statusCode == 200) {
      debugPrint('Delete Card : ' + response.body.toString());
      return isDeleted = true;
    } else
      Future.error('Unexpected Error occured');

    return isDeleted;
  }

  Future<VerifyCardModel?> verifyCard(String cardNumber) async {
    bool isValid = false;
    VerifyCardModel? verifyCardModel;

    const url = "payment/card/verify";
    print('Card number input :' + '${cardNumber.replaceAll(' ', '')}');
    final response = await postRequest(
      endpoint: url,
      headers: apiAuthHeaderWithOnlyToken(),
      body: {"card_number": "${cardNumber.replaceAll(' ', '')}"},
    );
    if (response.statusCode == 200) {
      debugPrint('Valid Card ? : ' + response.body.toString());
      debugPrint('check  :' + (jsonDecode(response.body)['valid']).toString());

      return verifyCardModel = verifyCardModelFromJson(response.body);
    } else {
      Future.error('Unexpected Error occured');
    }
    debugPrint('Valid: ' + isValid.toString());

    return verifyCardModel;
  }

  // Future<bool> saveCard(Map card, BuildContext context) async {
  //   bool getCardModel = false;
  //   const url = "card/save";
  //   final response = await postRequest(
  //       endpoint: url, headers: apiAuthHeaderWithOnlyToken(), body: card);
  //   debugPrint('Status Code: ' + response.statusCode.toString());
  //   if (response.statusCode == 200) {
  //     debugPrint('Save Cards: ' + response.body.toString());
  //     try {
  //       var anaylticsEvents = AnalyticsEvents(context);
  //       await anaylticsEvents.initCurrentUser();
  //       anaylticsEvents.sendSaveCardEvent();
  //     } catch (e) {
  //       debugPrint('Card Analytics: ' + e.toString());
  //     }

  //     return getCardModel = true;
  //   }
  //   return Future.error('Unexpected Error occured');
  // }

  Future<bool> saveCard(Map card, BuildContext context) async {
    bool getCardModel = false;
    try {
      const url = "card/save";
      final response = await postRequest(
          endpoint: url, headers: apiAuthHeaderWithOnlyToken(), body: card);
      debugPrint('Status Code: ' + response.statusCode.toString());
      debugPrint('Status Code: ' + response.body.toString());
      if (response.statusCode == 200) {
        debugPrint('Save Cards: ' + response.body.toString());
        try {
          var anaylticsEvents = AnalyticsEvents(context);
          await anaylticsEvents.initCurrentUser();
          anaylticsEvents.sendSaveCardEvent();
        } catch (e) {
          debugPrint('Card Analytics: ' + e.toString());
          return Future.error('$e');
        }
        return getCardModel = true;
      } else {
        debugPrint('Card Analytics: 1');
        return getCardModel = false;
      }
    } catch (e) {
      debugPrint('Card Analytics: 2');
      return Future.error('Unexpected Error occured');
    }
  }

  Future<bool> editCard({id, value}) async {
    bool status = false;
    const url = "card/update";
    Map t = {"id": "$id", "isdefault": value.toString()};
    debugPrint(t.toString());
    final response = await postRequest(
        endpoint: url, headers: apiAuthHeaderWithOnlyToken(), body: t);
    debugPrint('response : ' + response.body.toString());
    if (response.statusCode == 200) {
      debugPrint('Edit isDefault Card: ' + response.body.toString());
      status = jsonDecode(response.body)['status'];
      return status;
    }
    return Future.error('Unexpected Error occured');
  }
}
