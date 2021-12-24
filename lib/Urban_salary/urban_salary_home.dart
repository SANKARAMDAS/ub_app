import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_services.dart';

class UrbanSalary extends StatefulWidget {
  const UrbanSalary({Key? key}) : super(key: key);

  @override
  _UrbanSalaryState createState() => _UrbanSalaryState();
}

class _UrbanSalaryState extends State<UrbanSalary> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);
        return true;
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage(AppAssets.topGradient),
              alignment: Alignment.topCenter),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Center(
              child: Text(
                'Urban Salary',
                style: TextStyle(
                    color: Colors.blue[900],
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30.0,
                  child: Image.asset(
                    'assets/icons/navbar/home_blue.png',
                    height: 30,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
          body: Container(
            color: Colors.white,
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to the",
                        style: TextStyle(
                            // color: Colors.blue[900],
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        "Urban Salary App",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.014,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Image.asset(
                                'assets/icons/referafriend/Your reward screen icon-05.png',
                                width: 30,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Total",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Text(
                              "Pending",
                              style: TextStyle(fontSize: 20),
                            ),
                            // Text(
                            //   "Per min",
                            //   style: TextStyle(fontSize: 12.0),
                            // )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.brownishGrey),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Image.asset(
                                  'assets/icons/addfile.png',
                                  width: 30,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Add ",
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Text(
                                "Staff",
                                style: TextStyle(fontSize: 20),
                              ),
                              // Text(
                              //   "Kcal",
                              //   style: TextStyle(fontSize: 12.0),
                              // )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Image.asset(
                                'assets/icons/about-us01.png',
                                width: 30,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Staff",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Text(
                              "List",
                              style: TextStyle(fontSize: 20),
                            ),
                            // Text(
                            //   "Hours",
                            //   style: TextStyle(fontSize: 12.0),
                            // )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Image.asset(
                                'assets/icons/Docs1-01.png',
                                width: 30,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Payment",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Text(
                              "logs",
                              style: TextStyle(fontSize: 20),
                            ),
                            // Text(
                            //   "Hours",
                            //   style: TextStyle(fontSize: 12.0),
                            // )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Image.asset(
                                'assets/icons/currency.png',
                                width: 30,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Bulk",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Text(
                              "payment",
                              style: TextStyle(fontSize: 20),
                            ),
                            // Text(
                            //   "Hours",
                            //   style: TextStyle(fontSize: 12.0),
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
