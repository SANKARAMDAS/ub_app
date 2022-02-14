import 'package:flutter/material.dart';
import 'package:urbanledger/Models/analytics_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';
// import 'package:urbanledger/Cubits/Ledger/ledger_cubit.dart';
// import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Services/repository.dart';
import 'package:urbanledger/Utility/app_constants.dart';
// import 'package:urbanledger/screens/UserProfile/MyLedger/business_provider.dart';
// import 'package:uuid/uuid.dart';

import '../../data/local_database/db_provider.dart';
import '../../data/models/chat.dart';
import '../../data/models/message.dart';
import '../../data/models/user.dart';
import '../../data/repositories/chat_repository.dart';

class ChatsProvider with ChangeNotifier {
  ChatRepository _chatRepository = ChatRepository();

  List<Chat> _chats = [];

  List<Chat> get chats => _chats;

  Chat? _selectedChat;

  Chat? get selectedChat => _selectedChat;

  bool _noMoreSelectedChatMessages = false;

  bool get noMoreSelectedChatMessages => _noMoreSelectedChatMessages;

  bool _loadingMoreMessages = false;

  Repository repository = Repository();

  updateChats() async {
    _chats = await DBProvider.db.getChatsWithMessages();
    notifyListeners();
  }

  fetchChats() async {
    final _response = await _chatRepository.getMessages();
    if (_response is List<Chat>) {
      _chats = List.of(_response);
      notifyListeners();
    }
  }

  syncChats(String? chatId) async {
    final _response = await _chatRepository.getSyncMessages(chatId);
    if (_response is Chat) {
      createChatAndUserIfNotExists(_response);
      for (var i = 0; i < _response.messages.length; i++) {
        addMessageToChat(_response.messages[i]);
      }
      notifyListeners();
    }
  }

  setSelectedChat(Chat? selectedChat) async {
    _selectedChat = selectedChat;
    _noMoreSelectedChatMessages = false;
    _loadingMoreMessages = false;
    if (_selectedChat != null) {

      _selectedChat!.messages =
          await DBProvider.db.getChatMessages(selectedChat?.id);
      debugPrint(_selectedChat?.messages.length.toString());
      _readSelectedChatMessages();
      notifyListeners();
    }
  }

  loadMoreSelectedChatMessages() async {
    if (!noMoreSelectedChatMessages &&
        selectedChat!.messages.length > 0 &&
        !_loadingMoreMessages) {
      _loadingMoreMessages = true;
      int? lastMessageId =
          _selectedChat!.messages[_selectedChat!.messages.length - 1].localId;
      List<Message> newMessages = await DBProvider.db
          .getChatMessagesWithOffset(selectedChat!.id, lastMessageId);
      if (newMessages.length == 0) {
        _noMoreSelectedChatMessages = true;
        return;
      }
      // newMessages.forEach((message) {
      //   print("messageee ${message.toJson()}");
      // });
      _selectedChat!.messages = _selectedChat!.messages + newMessages;
      _loadingMoreMessages = false;
      notifyListeners();
    }
  }

  _readSelectedChatMessages() async {
    await DBProvider.db.readChatMessages(_selectedChat?.id);
    updateChats();
  }

  addMessageToSelectedChat(Message message) {
    debugPrint(message.toString());
    // DBProvider.db.addMessage(message);
    // updateChats();
  }

  createUserIfNotExists(User user) async {
    await DBProvider.db.createUserIfNotExists(user);
    updateChats();
  }

  createChatIfNotExists(Chat chat) async {
    await DBProvider.db.createChatIfNotExists(chat);
    updateChats();
  }

  createChatAndUserIfNotExists(Chat chat) async {
    await DBProvider.db.createUserIfNotExists(chat.user!);
    await DBProvider.db.createChatIfNotExists(chat);
    updateChats();
  }

  addMessageToChat(Message message) async {
    await DBProvider.db.addMessage(message);
    updateChats();
    setSelectedChat(selectedChat);
  }

  addMessageToChatFromSocket(
      Message message, BuildContext context, Chat chat) async {
    debugPrint("req :2"+message.messageType.toString());
      debugPrint("req :2"+message.requestId.toString());
    if (message.messageType == 101) {
      declineRequest(message.requestId!);
    } else if (message.messageType == 1 && message.requestId != '') {
      if (message.messageType == 1 && message.paymentStatus == 1) {
        debugPrint('payd2 :');
        Datum data = Datum(
          suspense: message.suspense == 0 ? true : false,
          amount: message.amount!.round(),
          currency: '$currencyAED',
          urbanledgerId: message.urbanledgerId.toString(),
          transactionId: message.transactionId.toString(),
          through: message.through.toString(),
          type: message.type.toString(),
          createdAt: DateTime.parse(message.dateTime.toString()),
          updatedAt: DateTime.parse(message.dateTime.toString()),
        );
        await repository.queries.insertAnalytics(data);
        // await DBProvider.db.addMessage(message);
        updateChats();
        setSelectedChat(selectedChat);
      }
      payRequest(message.requestId);
      await DBProvider.db.addMessage(message);
      
      ///ledger
      /* if (chat.user?.username != null) {
        final localCustId =
            await repository.queries.getCustomerId(chat.user!.username!);
        final previousBalance =
            (await repository.queries.getPaidMinusReceived(localCustId));
        await BlocProvider.of<LedgerCubit>(context).addLedger(
            TransactionModel()
              ..transactionId = message.requestId
              ..amount = message.amount
              ..details = message.details ?? ''
              ..transactionType = TransactionType.Receive
              ..customerId = localCustId
              ..date = DateTime.fromMillisecondsSinceEpoch(message.sendAt ?? 0)
              ..attachments = []
              ..balanceAmount = previousBalance + (message.amount ?? 0)
              ..isChanged = true
              ..isDeleted = false
              ..transactionId = message.transactionId
              ..isPayment = true
              ..business = Provider.of<BusinessProvider>(context, listen: false)
                  .selectedBusiness
                  .businessId //todoadd column
              ..createddate =
                  DateTime.fromMillisecondsSinceEpoch(message.sendAt ?? 0),
            () {},
            context);
      } */
      updateChats();
      setSelectedChat(selectedChat);
    } else {
      debugPrint('payd1 :');
      if (message.messageType == 1 && message.paymentStatus == 1) {
        debugPrint('payd2 :');
        Datum data = Datum(
          suspense: message.suspense == 0 ? true : false,
          amount: message.amount!.round(),
          currency: '$currencyAED',
          urbanledgerId: message.urbanledgerId.toString(),
          transactionId: message.transactionId.toString(),
          through: message.through.toString(),
          type: message.type.toString(),
          createdAt: DateTime.parse(message.dateTime.toString()),
          updatedAt: DateTime.parse(message.dateTime.toString()),
        );
        await repository.queries.insertAnalytics(data);
        await DBProvider.db.addMessage(message);
        updateChats();
        setSelectedChat(selectedChat);
      } else {
        await DBProvider.db.addMessage(message);
        updateChats();
        setSelectedChat(selectedChat);
      }
    }
  }

  declineRequest(String request) async {
    debugPrint('asdfg');
    await DBProvider.db.decline(request);
    updateChats();
    setSelectedChat(selectedChat);
    notifyListeners();
  }

  updateAudioFilename(String fileName, String _id) async {
    debugPrint('asdfg');
    await DBProvider.db.updateAudioFileName(fileName, _id);
    updateChats();
    setSelectedChat(selectedChat);
    notifyListeners();
  }

  payRequest(String? request) async {
    await DBProvider.db.pay(request);
    updateChats();
    setSelectedChat(selectedChat);
    notifyListeners();
  }

  Future<void> clearDatabase() async {
    await DBProvider.db.clearDatabase();
    updateChats();
  }
}
