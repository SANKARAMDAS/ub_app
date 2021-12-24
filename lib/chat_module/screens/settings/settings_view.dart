import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../screens/settings/settings_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/settings_container.dart';
import '../../widgets/settings_item.dart';
import '../../widgets/user_info_item.dart';

class SettingsScreen extends StatefulWidget {
  static final String routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsController _settingsController;

  @override
  void initState() {
    _settingsController = SettingsController(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _settingsController.streamController.stream as Stream<Object>?,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Color(0xFFEEEEEE),
            appBar: CustomAppBar(
              automaticallyImplyLeading: true,
              title: Text('Settings', style: TextStyle(color: Colors.white)),
            ),
            body: SafeArea(
              child: Container(
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: <Widget>[
                    renderMyUserCard(),
                    SizedBox(
                      height: 30,
                    ),
                    SettingsContainer(
                      children: [
                        SettingsItem(
                          icon: Icons.delete_outline,
                          iconBackgroundColor: Colors.grey,
                          title: 'Delete conversations',
                          onTap: _settingsController.openModalDeleteChats,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget renderMyUserCard() {
    if (_settingsController.myUser != null) {
      return UserInfoItem(
        name: _settingsController.myUser!.name,
        subtitle: "@${_settingsController.myUser!.username}",
      );
    }
    return Container();
  }
}
