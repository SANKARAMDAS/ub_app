import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:urbanledger/Cubits/Contacts/contacts_cubit.dart';
import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/screens/Components/extensions.dart';
import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
import '../../data/models/chat.dart';
import '../../data/models/message.dart';
import '../../data/models/user.dart';
import '../../data/providers/chats_provider.dart';
import '../../data/repositories/chat_repository.dart';
import '../../utils/custom_shared_preferences.dart';
import '../../utils/dates.dart';
import '../../utils/state_control.dart';

class ContactController extends StateControl {
  BuildContext context;

  Repository repository = Repository();

  ChatRepository _chatRepository = ChatRepository();

  ScrollController? scrollController;

  late ChatsProvider _chatsProvider;

  Chat? get selectedChat => _chatsProvider.selectedChat;

  List<Chat> get chats => _chatsProvider.chats;

  TextEditingController textController = TextEditingController();

  User? myUser;

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

  ContactController({
    required this.context,
  }) {
    this.init();
  }

  void init() {
    scrollController = new ScrollController()..addListener(_scrollListener);
    initMyUser();
  }

  initMyUser() async {
    myUser = await getMyUser();
    notifyListeners();
  }

  initProvider() {
    _chatsProvider = Provider.of<ChatsProvider>(context);
    debugPrint(
        'selected chat id : ${_chatsProvider.selectedChat?.id.toString()}');
  }

  getMyUser() async {
    final userString = await CustomSharedPreferences.get("user");
    final userJson = jsonDecode(userString);
    return User.fromJson(userJson);
  }

  static initChat(context, chatId) {
    final chat = Chat(
      user: null,
      id: chatId,
    );
    final _provider = Provider.of<ChatsProvider>(context, listen: false);
    _provider.setSelectedChat(chat);
  }

  // ignore: non_constant_identifier_names
  sendMessage({
      String? id,
      String? chatId,
      String? name,
      required String phone,
      double? amount,
      String? details,
      String? fileName,
      String? fileSize,
      String? duration,
      String? dateTime,
      String? contactName,
      String? contactNo,
      Uint8List? avatar,
      String? requestId,
      required int messageType,
      String? transactionId}) async {
    debugPrint('customer id  ' + id.toString());
    debugPrint(chatId);
    debugPrint(name);
    debugPrint(phone);
    debugPrint(messageType.toString());
    RegExp regExp = new RegExp(r"[^0-9]");
    phone = phone.replaceAll(regExp, '');
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
          fileName: fileName,
          fileSize: fileSize,
          duration: duration,
          messages: message,
          dateTime: dateTime,
          contactName: contactName,
          contactNo: contactNo,
          transactionId: transactionId,
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
      // debugPrint('response ${response.body}');
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
      await repository.queries.updateChatId(_message.chatId, customerId: id);
      BlocProvider.of<ContactsCubit>(context).getContacts(
          Provider.of<BusinessProvider>(context, listen: false)
              .selectedBusiness
              .businessId);
      final toUser = User(
        id: _message.to,
        name: name,
        username: phone,
        chatId: _message.chatId,
      );
      final chat = Chat(id: _message.chatId, user: toUser);
      final _provider = Provider.of<ChatsProvider>(context, listen: false);
      _provider.addMessageToChat(newMessage);
      _provider.createUserIfNotExists(chat.user!);
      _provider.createChatIfNotExists(chat);
      _provider.setSelectedChat(chat);
    } else {
      debugPrint('not nulling');
      final Messages msg = Messages(
          amount: amount,
          details: details,
          fileName: fileName,
          fileSize: fileSize,
          duration: duration,
          messages: message,
          dateTime: dateTime,
          contactName: contactName,
          contactNo: contactNo,
          requestId: requestId,
          transactionId: transactionId,
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
      final _provider = Provider.of<ChatsProvider>(context, listen: false);
      _provider.addMessageToChat(newMessage);

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

  renameAudioFile(String fileName, String _id) {
    final _provider = Provider.of<ChatsProvider>(context, listen: false);
    _provider.updateAudioFilename(fileName, _id);
  }

  declinePayment(Map<String, dynamic> data) async {
    final transactionModel = TransactionModel()
      ..transactionId = data['requestid'];
    final _provider = Provider.of<ChatsProvider>(context, listen: false);
    _provider.declineRequest(data['requestid']);
    final Messages msg = Messages(
        requestId: data['requestid'], amount: data['amount'], messageType: 101);
    debugPrint('debugging.... ' + msg.toJson().toString());
    var jsondata = jsonEncode(msg);
    await _chatRepository.sendMessage(
        data['mobileNo'],
        data['name'],
        jsondata,
        data['uid'],
        Provider.of<BusinessProvider>(context, listen: false)
            .selectedBusiness
            .businessId);
    final response =
        await repository.queries.updateLedgerIsDeleted(transactionModel, 1);
    if (response != null) {
      deleteLedger(data['uid'], data['requestid']);
      BlocProvider.of<LedgerCubit>(context).getLedgerData(data['uid']);
    }
  }

  Future<void> deleteLedger(String customerId, String requestid) async {
    if (await checkConnectivity) {
      final transactionModel = TransactionModel()..transactionId = requestid;
      final previousBalance =
          (await repository.queries.getPaidMinusReceived(customerId));
      final apiResponse = await (repository.ledgerApi
          .deleteLedger(
        requestid,
        removeDecimalif0(previousBalance),
      )
          .catchError((e) {
        debugPrint(e);
        return false;
      }));
      if (apiResponse) {
        await repository.queries.deleteLedgerTransaction(transactionModel);
      }
    } else {
      'Please check your internet connection or try again later.'
          .showSnackBar(context);
    }
  }

  String getNumberOfUnreadChatsToString() {
    final unreadChats = chats.where((chat) {
      return chat.messages.where((message) => message.unreadByMe!).length > 0;
    }).length;
    if (unreadChats > 0) {
      return unreadChats.toString();
    }
    return '';
  }

  void _scrollListener() {
    if (scrollController!.position.extentAfter < 650) {
      _chatsProvider.loadMoreSelectedChatMessages();
    }
  }

  void dispose() {
    super.dispose();
    textController.dispose();
    _chatsProvider.setSelectedChat(null);
    scrollController!.removeListener(_scrollListener);
    scrollController!.dispose();
  }
}
