import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Utility/app_routes.dart';
import 'package:urbanledger/screens/Add%20Card/card_ui.dart';
import 'package:urbanledger/screens/Components/custom_loading_dialog.dart';
import 'package:urbanledger/screens/Components/new_custom_button.dart';
import 'package:urbanledger/screens/TransactionScreens/add_cards_provider.dart';

import 'card_list.dart';

class SavedCards extends StatefulWidget {
  @override
  _SavedCardsState createState() => _SavedCardsState();
}

class _SavedCardsState extends State<SavedCards> {
  final GlobalKey<State> key = GlobalKey<State>();
  getDefaultCard() async {
    await Provider.of<AddCardsProvider>(context, listen: false).getCard();
    // Provider.of<AddCardsProvider>(context, listen: false)
    //     .card!
    //     .forEach((element) {
    //   if (element.isdefault == 1) {
    //     defaultCard = CardUi(
    //       title: element.title,
    //       backgroundColor: Colors.amber,
    //       bankName: '',
    //       cardHolderName: element.hashedName.toString(),
    //       cardNumber: element.hashedName.toString().replaceAll('xx', '42'),
    //       validCard: '',
    //       cardHeight: 300,
    //     );
    //   }
    // });
  }

  @override
  void initState() {
    super.initState();
    getDefaultCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.chevron_left,
                color: Color.fromRGBO(16, 88, 255, 1), size: 35)),
        title: Text('My Default Card',
            style: TextStyle(color: Color.fromRGBO(16, 88, 255, 1))),
      ),
      bottomSheet: Container(
        color: Colors.white,
        child: Padding(
          
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          child: NewCustomButton(
            text: 'MY SAVED CARDS',
            textColor: Colors.white,
            textSize: 18.0,
            onSubmit: () {
             /* Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => CardList()));*/
              Navigator.of(context).pushNamed(AppRoutes.cardListRoute);
              CustomLoadingDialog.showLoadingDialog(context, key);
            },
          ),
        ),
      ),
      body: Consumer<AddCardsProvider>(builder: (context, cards, _) {
        Widget defaultCard = CardUi(

          isDefualt: '1',
          id: '100',
          backgroundColor: Colors.grey,
          cardImage: '',
          title: 'XXXX',
          validCard: 'XX/XX',
          bankName: '',
          cardHeight: 340,
          cardHolderName: 'XXXX',
          cardNumber: 'XXXXXXXXXXXXXXXX',
        );
        // SizedBox(height: 20.0);

        cards.card!.forEach((element) {
          print('isDefaulkt card' + '${element.bankName}');
          if (element.isdefault.toString() == '1') {
            defaultCard = CardUi(
              cardImage: element.cardImage,
              title: element.title,
              backgroundColor: Colors.grey,
              id: element.id.toString(),
              bankName: element.bankName.toString(),
              cardHolderName: element.hashedName.toString(),
              cardNumber: element.endNumber.toString(),
              validCard: element.expdate.toString(),
            );
          }
          // else if {
          //   defaultCard = Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Text('Payment Method',
          //             style: TextStyle(
          //                 color: Colors.black54,
          //                 fontSize: 22,
          //                 fontWeight: FontWeight.w600)),
          //         SizedBox(height: 4),
          //         Text('Currently you haven\'t setup\na payment method',
          //             textAlign: TextAlign.center,
          //             style: TextStyle(color: Colors.black54, fontSize: 18)),
          //         SizedBox(height: 65),
          //         Image.asset(
          //           'assets/images/noCardFound.png',
          //         )
          //       ],
          //     ),
          //   );
          // }
        });
        // SizedBox(height: 20.0);
        return cards.card != null && cards.card!.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Payment Method',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 22,
                            fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text('Currently, you haven\'t set up\na default card',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, fontSize: 18)),
                    SizedBox(height: 65),
                    Image.asset(
                      'assets/images/noCardFound.png',
                    )
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: defaultCard,
              );
        // SizedBox(height: 10.0,);
      }),
    );
  }
}
