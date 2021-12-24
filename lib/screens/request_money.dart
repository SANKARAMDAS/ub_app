import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_assets.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_routes.dart';

import 'Components/extensions.dart';

class RequestMoney extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 22,
              ),
            ),
          ),
        ),
        title: Text('Request Money'),
        actions: [Icon(Icons.add_box_outlined)],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        AppAssets.backgroundImage.background,
        0.35.backdrop,
        Column(children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + appBarHeight,
          ),
          20.0.heightBox,
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.white.withOpacity(0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        // color: Colors.white.withOpacity(0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Customers',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Contacts',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 16)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          30.0.heightBox,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                        child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Search Customers',
                          hintStyle: TextStyle(color: Colors.grey),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none),
                    )),
                  ],
                ),
              ),
            ),
          ),
          10.0.heightBox,
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Card(
                    elevation: 0,
                    child: ListTile(
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Colors.green,
                          )),
                      title: Text('Name'),
                      subtitle: Text('+91 9378484383'),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.requestMoneyOptionsRoute);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ])
      ]),
    );
  }
}
