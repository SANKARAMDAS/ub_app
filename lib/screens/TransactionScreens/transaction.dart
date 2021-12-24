import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_routes.dart';

class TransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        title: Container(
            child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  'Click here to view setting',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            )
          ],
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.phone),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.more_vert),
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    size: 22,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Only you and User can see these entries',
                    style: TextStyle(color: Colors.blue[700]),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 120,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Add first transaction of User'),
                      SizedBox(
                        height: 10,
                      ),
                      Icon(
                        Icons.arrow_downward,
                        color: Colors.blue[700],
                      )
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 37, vertical: 15),
                          color: Colors.red[700],
                          child: Text(
                            'YOU GAVE ₹',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.calculatorRoute);
                          }),
                      FlatButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: 37, vertical: 15),
                        color: Colors.green[700],
                        child: Text(
                          'YOU PAY ₹',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AppRoutes.calculatorRoute);
                        },
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
