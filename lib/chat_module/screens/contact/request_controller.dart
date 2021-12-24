import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_services.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import '../../data/models/chat.dart';
import '../../data/models/message.dart';
import '../../data/models/user.dart';
import '../../data/providers/chats_provider.dart';
import '../../data/repositories/chat_repository.dart';
import '../../utils/custom_shared_preferences.dart';
import '../../utils/dates.dart';
import '../../utils/state_control.dart';

class RequestController extends StateControl {
  BuildContext context;

  Repository repository = Repository();

  ChatRepository _chatRepository = ChatRepository();

  // ScrollController? scrollController;

  late ChatsProvider _chatsProvider;
  late ContactsCubit _contactsCubit;
  late BusinessProvider _businessProvider;

  // Chat? get selectedChat => _chatsProvider.selectedChat;

  // List<Chat> get chats => _chatsProvider.chats;

  TextEditingController textController = TextEditingController();

  // User? myUser;

  bool _error = false;

  bool get error => _error;

  bool _loading = true;

  bool get loading => _loading;

  bool _showEmojiKeyboard = false;

  bool get showEmojiKeyboard => _showEmojiKeyboard;

  set showEmojiKeyboard(bool showEmojiKeyboard) {
    _showEmojiKeyboard = showEmojiKeyboard;
    notifyListeners();
  }

  RequestController({
    required this.context,
  }) {
    this.init();
  }

  void init() {
    // scrollController = new ScrollController()..addListener(_scrollListener);
    initMyUser();
  }

  initMyUser() async {
    // myUser = await getMyUser();
    notifyListeners();
  }

  initProvider() {
    _chatsProvider = Provider.of<ChatsProvider>(context);
    _contactsCubit = BlocProvider.of<ContactsCubit>(context);
    _businessProvider = Provider.of<BusinessProvider>(context, listen: false);
  }

  // getMyUser() async {
  //   final userString = await CustomSharedPreferences.get("user");
  //   final userJson = jsonDecode(userString);
  //   return User.fromJson(userJson);
  // }

  static initChat(context, chatId) {
    final chat = Chat(
      user: null,
      id: chatId,
    );
    // final _provider = Provider.of<ChatsProvider>(context, listen: false);
    // _provider.setSelectedChat(chat);
  }

  // ignore: non_constant_identifier_names
  sendMessage(
      String? id,
      String? chatId,
      String? name,
      String? phone,
      double? amount,
      String? details,
      int? attachmentCount,
      String? requestId,
      int messageType) async {
    RegExp regExp = new RegExp(r"[^0-9]");
    phone = phone!.replaceAll(regExp, '');
    if (phone.length == 10) {
      phone = '91' + phone;
    }
    UtilDates.getTodayMidnight();
    final message = textController.text.trim();
    if (messageType == 0) {
      if (message.length == 0) return;
    }

    final user = await CustomSharedPreferences.getMyUser();
    final myId = user.id;
    final to = phone;
    if (chatId == null) {
      final Messages msg = Messages(
          amount: amount,
          details: details,
          messages: message,
          attachmentCount: attachmentCount,
          requestId: requestId,
          // avatar: avatar,
          messageType: messageType);
      var jsondata = jsonEncode(msg);
      textController.text = "";
      final response = await _chatRepository.sendMessage(
          to,
          name,
          jsondata,
          id ?? '',
          Provider.of<BusinessProvider>(context, listen: false)
              .selectedBusiness
              .businessId);
      debugPrint('response ${response.body}');
      final messageResponse =
          Map<String, dynamic>.from(jsonDecode(response.body));
      Message _message = Message.fromJson(messageResponse['message']);
      final newMessage = Message(
        chatId: _message.chatId,
        from: _message.from,
        to: _message.to,
        message: msg,
        sendAt: DateTime.now().millisecondsSinceEpoch,
        unreadByMe: false,
        paymentCancel: false,
      );
      await repository.queries.updateChatId(_message.chatId, mobileNo: phone);
      _contactsCubit.getContacts(_businessProvider.selectedBusiness.businessId);
      final toUser = User(
        id: _message.to,
        name: name,
        username: phone,
        chatId: _message.chatId,
      );
      final chat = Chat(id: _message.chatId, user: toUser);
      // final _provider = Provider.of<ChatsProvider>(context, listen: false);
      _chatsProvider.createUserIfNotExists(chat.user!);
      _chatsProvider.createChatIfNotExists(chat);
      _chatsProvider.addMessageToChat(newMessage);
      // _provider.setSelectedChat(chat);
    } else {
      debugPrint('not nulling');
      final Messages msg = Messages(
          amount: amount,
          details: details,
          requestId: requestId,
          attachmentCount: attachmentCount,
          messages: message,
          messageType: messageType);
      final newMessage = Message(
        chatId: chatId,
        from: myId,
        to: to,
        message: msg,
        sendAt: DateTime.now().millisecondsSinceEpoch,
        unreadByMe: false,
        paymentCancel: false,
      );
      debugPrint(newMessage.toString());
      // final _provider = Provider.of<ChatsProvider>(context, listen: false);
      _chatsProvider.addMessageToChat(newMessage);

      var jsondata = jsonEncode(msg);
      textController.text = "";
      await _chatRepository.sendMessage(
          to,
          name,
          jsondata,
          id ?? '',
          Provider.of<BusinessProvider>(context, listen: false)
              .selectedBusiness
              .businessId);
    }
  }

  declinePayment(Map<String, dynamic> data) async {
    final response = await _chatRepository.declinePaymentRequest(data);
    if (response) {
      final _provider = Provider.of<ChatsProvider>(context, listen: false);
      _provider.declineRequest(data['requestid']);
    }
  }

  void dispose() {
    super.dispose();
    // textController.dispose();
    // _chatsProvider.setSelectedChat(null);
    // scrollController!.removeListener(_scrollListener);
    // scrollController!.dispose();
  }
}
