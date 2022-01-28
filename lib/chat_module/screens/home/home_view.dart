import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/app_services.dart';

import '../../../chat_module/screens/settings/settings_view.dart';
import '../../../chat_module/widgets/chat_card.dart';
import '../../screens/home/home_controller.dart';
import '../../widgets/custom_app_bar.dart';

class HomeScreen_new extends StatefulWidget {
  static final String routeName = "/home";

  @override
  _HomeScreen_newState createState() => _HomeScreen_newState();
}

class _HomeScreen_newState extends State<HomeScreen_new> {
  late HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _homeController = HomeController(context: context);
  }

  @override
  void dispose() {
    _homeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _homeController.initProvider();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: _homeController.streamController.stream as Stream<Object>?,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: CustomAppBar(
            title: Text(_homeController.loading ? 'Connecting...' : 'Chats'),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).pushNamed(SettingsScreen.routeName);
                },
              ),
            ],
          ),
          body: SafeArea(
            child: usersList(context),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _homeController.openAddChatScreen,
            backgroundColor: AppTheme.electricBlue,
            child: Icon(
              Icons.message,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget usersList(BuildContext context) {
    // if (_homeController.loading) {
    //   return SliverFillRemaining(
    //     child: Center(
    //       child: CupertinoActivityIndicator(),
    //     ),
    //   );
    // }
    // if (_homeController.error) {
    //   return SliverFillRemaining(
    //     child: Center(
    //       child: Text('Ocorreu um erro ao buscar suas conversas.'),
    //     ),
    //   );
    // }
    if (_homeController.chats.length == 0) {
      return Center(
        child: Text('You have no conversations.'),
      );
    }
    bool theresChatsWithMessages = _homeController.chats.where((chat) {
          return chat.messages.length > 0;
        }).length >
        0;
    if (!theresChatsWithMessages) {
      return Center(
        child: Text('You don\'t have conversations.'),
      );
    }
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: _homeController.chats.map((chat) {
            if (chat.messages.length == 0) {
              return Container(height: 0, width: 0);
            }
            return Column(
              children: <Widget>[
                ChatCard(
                  chat: chat,
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
