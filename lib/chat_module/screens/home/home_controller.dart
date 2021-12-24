import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/routeArgs.dart';
// import 'package:urbanledger/Models/routeArgs.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_routes.dart';

import '../../data/models/chat.dart';
import '../../data/models/message.dart';
import '../../data/models/user.dart';
import '../../data/providers/chats_provider.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/repositories/user_repository.dart';
// import '../../screens/add_chat/add_chat_view.dart';
import '../../utils/custom_shared_preferences.dart';
import '../../utils/socket_controller.dart';
import '../../utils/state_control.dart';

class HomeController extends StateControl with WidgetsBindingObserver {
  ChatRepository _chatRepository = ChatRepository();

  UserRepository _userRepository = UserRepository();

  Repository repository = Repository();

  late ChatsProvider _chatsProvider;

  IO.Socket socket = SocketController.socket;

  late FirebaseMessaging _firebaseMessaging;

  final BuildContext context;

  bool _error = false;

  bool get error => _error;

  List<Chat> get chats => _chatsProvider.chats;

  bool _loading = true;

  bool get loading => _loading;

  List<User> _users = [];

  List<User> get users => _users;

  AppLifecycleState? _notification;

  final duration = const Duration(milliseconds: 100);

  bool isSocketConnected = false;

  CustomerModel customerModel = CustomerModel();

  HomeController({
    required this.context,
  }) {
    this.init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _notification = state;
    if (state == AppLifecycleState.inactive) {
      disconnectSocket();
    }
    if (state == AppLifecycleState.resumed) {
      // socket.connect();
      connectSocket();
    }
  }

  connectSocket() {
    disconnectSocket();
    socket.connect();
    socket.onConnect((data) => print('h'));
    _loading = true;
    notifyListeners();
    socket.onError((data) {
      debugPrint('socket error');
      debugPrint(data.toString());
    });
    socket.onConnectError((data) {
      debugPrint('socket connect error');
      debugPrint(data.toString());
    });
    socket.onConnectTimeout((data) {
      debugPrint('socket connect timeout');
      debugPrint(data.toString());
    });
    socket.onDisconnect((data) => print(data));
    Timer.periodic(duration, (timer) {
      // debugPrint("socket connected ${socket.connected}");
      if (socket.connected) {
        if (timer != null) timer.cancel();
        initSocket();
      }
    });
  }

  disconnectSocket() {
    socket.disconnect();
    isSocketConnected = false;
    inactiveSocketFunctions();
  }

  inactiveSocketFunctions() {
    socket.off("user-in");
    socket.off("message");
  }

  void init() {
    _firebaseMessaging = FirebaseMessaging.instance;
    requestPushNotificationPermission();
    configureFirebaseMessaging();
    connectSocket();
    WidgetsBinding.instance!.addObserver(this);
  }

  void initSocket() {
    if (!isSocketConnected) {
      isSocketConnected = true;
      // debugPrint('socket is connected');
      emitUserIn();
      onMessage();
      onUserIn();
      Provider.of<ChatsProvider>(context, listen: false).updateChats();
      // Provider.of<ChatsProvider>(context, listen: false).fetchChats();
    }
  }

  void emitUserIn() async {
    User user = await CustomSharedPreferences.getMyUser();
    Map<String, dynamic> json = user.toJson();
    socket.emit("user-in", json);
  }

  void onUserIn() async {
    socket.on("user-in", (_) {
      _loading = false;
      notifyListeners();
    });
  }

  void onMessage() async {
    socket.on("message", (dynamic data) async {
      debugPrint("test123 $data");
      Map<String, dynamic> json = data['message'];
      Map<String, dynamic> userJson = json['from'];
      Chat chat = Chat.fromJson({
        "_id": json['chatId'],
        "user": userJson,
      });
      debugPrint("test123 ${json.toString()}");
      Message message = Message.fromJson(json);
      Provider.of<ChatsProvider>(context, listen: false)
          .createChatAndUserIfNotExists(chat);
      if (json['from']['_id'] != json['to']['_id']) {
        Provider.of<ChatsProvider>(context, listen: false)
            .addMessageToChatFromSocket(message, context, chat);
      }
      // if(json['message']['messageType'] == 101 || json['message']['messageType'] == '101'){
      //   final _provider = Provider.of<ChatsProvider>(context, listen: false);
      //   _provider.declineRequest(json['message']['request_id']);
      // }
      await _chatRepository.deleteMessage(message.id);
    });
  }

  void emitUserLeft() async {
    socket.emit("user-left");
  }

  void requestPushNotificationPermission() {
    if (Platform.isIOS) {
      _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
      );
    }
  }

  void configureFirebaseMessaging() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // customerModel..customerId = event.data['customer_id'];
      // debugPrint('dddaattta' + message.data.toString());
      // debugPrint(event.from);
      debugPrint('message data ' + message.data.toString());
      customerModel
        ..customerId = message.data['customer_id']
        ..mobileNo = message.data['mobileNo']
        ..name = message.data['name']
        ..chatId = message.data['chatId']
        ..businessId = message.data['business_id'];
      debugPrint('dddaattta' + customerModel.toJson().toString());
      // Navigator.popAndPushNamed(context, AppRoutes.transactionListRoute,
      //     arguments: TransactionListArgs(true, customerModel));
    });

    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    // );
    _firebaseMessaging.getToken().then((token) {
      if (token != null) {
        _userRepository.saveUserFcmToken(token);
      }
    });
  }

  void initProvider() {
    _chatsProvider = Provider.of<ChatsProvider>(context);
  }

  void openAddChatScreen() async {
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) => AddChatScreen(),
    // ));
  }

  void openSettings() async {
    Navigator.of(context).pushNamed('/settings');
  }

  @override
  void dispose() {
    super.dispose();
    emitUserLeft();
    disconnectSocket();
    WidgetsBinding.instance!.removeObserver(this);
    disconnectSocket();
  }
}
