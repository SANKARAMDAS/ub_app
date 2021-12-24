import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/local_database/db_provider.dart';
import '../../data/providers/chats_provider.dart';
import '../../screens/home/home_view.dart';
import '../../screens/login/login_view.dart';
import '../../utils/custom_shared_preferences.dart';

class AfterLaunchScreen extends StatefulWidget {
  @override
  _AfterLaunchScreenState createState() => _AfterLaunchScreenState();
}

class _AfterLaunchScreenState extends State<AfterLaunchScreen> {
  void verifyUserLoggedInAndRedirect() async {
    String routeName = HomeScreen_new.routeName;
    String? token = await (CustomSharedPreferences.get('chat_token') as FutureOr<String?>);
    if (token == null) {
      routeName = LoginScreen.routeName;
    }
    Timer.run(() {
      // In case user is already logged in, go to home_screen
      // otherwise, go to login_screen
      Navigator.of(context).pushReplacementNamed(routeName);
    });
  }

  @override
  void initState() {
    super.initState();
    DBProvider.db.database;
    verifyUserLoggedInAndRedirect();
  }

  @override
  void didChangeDependencies() {
    Provider.of<ChatsProvider>(context).updateChats();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
