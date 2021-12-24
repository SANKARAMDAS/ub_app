import 'dart:async';

import 'package:flutter/material.dart';
import 'package:urbanledger/Models/add_card_model.dart';
import 'package:urbanledger/Models/verify_card_model.dart';
import 'package:urbanledger/Services/APIs/card_api.dart';
import 'package:urbanledger/Services/repository.dart';

class AddCardsProvider with ChangeNotifier {
  List<CardDetailsModel>? _card = [];
  List<bool> _radioValues = [];
  VerifyCardModel? model;
  final Repository _repository = Repository();

  List<bool> get radioValues => _radioValues;

  CardDetailsModel? selectedCard;

  List<CardDetailsModel>? get card => _card;

  bool isValid = false;
  int indexOfDefaultCard = 0;

  Future getCard() async {
    _card = await _repository.cardsProvider.getAllCards();
    debugPrint((_card?.length ?? 0).toString());
    _card?.forEach((cards) {
      if (cards.isdefault == 1) {
        selectedCard = cards;
      }
    });

    /* int mySortComparison(CardDetailsModel? a, CardDetailsModel? b) {
      final propertyA = (int.parse(a!.isdefault.toString()));
      final propertyB = (int.parse(b!.isdefault.toString()));
      if (propertyA < propertyB) {
        return -1;
      } else if (propertyA > propertyB) {
        return 1;
      } else {
        return 0;
      }
    }


    _card?.sort(mySortComparison);*/
    /* if (_card!.isNotEmpty) {
      await getDefault();
    }*/
    debugPrint("hhh");
    notifyListeners();
    return _card;
  }

  /*Future getCardForPremium() async {
    _card = await _repository.cardsProvider.getAllCards();
    int mySortComparison(CardDetailsModel? a, CardDetailsModel? b) {
      final propertyA = (int.parse(a!.isdefault.toString()));
      final propertyB = (int.parse(b!.isdefault.toString()));
      if (propertyA < propertyB) {
        return -1;
      } else if (propertyA > propertyB) {
        return 1;
      } else {
        return 0;
      }
    }

    _card?.sort(mySortComparison);

    // await getDefault();
    notifyListeners();
    return _card;
  }*/

  getDefault() async {
    /*  _card!.forEach((element) {
      if (element.isdefault.toString() == '1') {
        indexOfDefaultCard = _card!.indexOf(element);
        debugPrint(
            'index at Card is Default' + _card!.indexOf(element).toString());
        selectedCard = element;
      } else {
        indexOfDefaultCard = 0;
        selectedCard = _card!.last;
        debugPrint('index at Card is Default' + indexOfDefaultCard.toString());
      }
    });*/
    /*selectedCard = _card!.last;

    label:
    for (int i = 0; i < _card!.length; i++) {
      var element = _card![i];
      if (element.isdefault.toString() == '1') {
        debugPrint(
            'index at Card is Default' + _card!.indexOf(element).toString());
        var temp = _card![i];
        _card!.removeAt(i);
        _card!.insert(0, temp);
        selectedCard = _card!.first;
        indexOfDefaultCard = card!.indexOf(selectedCard!);
        await editCard(id: selectedCard?.id, value: 1);
        break label;
      }
    }*/
    selectedCard = _card!.first;
    indexOfDefaultCard = card!.indexOf(selectedCard!);
    // await editCard(id: selectedCard?.id, value: 1);
    // indexOfDefaultCard = 0;

    notifyListeners();
  }

  Future saveCard(Map addCards, BuildContext context) async {
    await _repository.cardsProvider.saveCard(addCards, context);
    await getCard();
    notifyListeners();
  }

  Future editCard({id, value}) async {
    await _repository.cardsProvider.editCard(id: id, value: value);
    //await getCardForPremium();
    //notifyListeners();
  }

  Future paymentThroughCard(Map paymentDetails) async {
    var response;
    //CapturePaymentModel capturePayment;
    await Repository()
        .cardPaymentsProvider
        .paymentThroughCard(paymentDetails)
        .then((value) {
      debugPrint('Checks1112' + value.toString());
      response = value;
      //capturePayment = capturePaymentModelFromJson(value);
    });
    getCard();
    notifyListeners();
    return response;
  }

  Future paymentThroughCard2(Map paymentDetails) async {
    var response;
    //CapturePaymentModel capturePayment;
    await Repository()
        .cardPaymentsProvider
        .paymentThroughCard2(paymentDetails)
        .then((value) {
      debugPrint('Checks1112' + value.toString());
      response = value;
      //capturePayment = capturePaymentModelFromJson(value);
    });
    getCard();
    notifyListeners();
    return response;
  }

  Future<bool> deleleCard(String? cardID) async {
    final status = await CardAPI.cardsProvider.deleteCard(cardID);
    getCard();
    notifyListeners();
    return status;
  }

  Future<VerifyCardModel?> ValidCard(String cardID) async {
    model = await CardAPI.cardsProvider.verifyCard(cardID);
    isValid = model?.valid ?? false;
    await getCard();
    notifyListeners();
    return model;
  }
}
