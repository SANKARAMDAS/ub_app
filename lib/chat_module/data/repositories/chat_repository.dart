import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:urbanledger/Utility/apiCalls.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';
// import 'package:urbanledger/chat_module/data/local_database/db_provider.dart';

import '../../data/models/chat.dart';
import '../../data/models/custom_error.dart';
import '../../data/models/message.dart';
import '../../utils/custom_http_client.dart';
import '../../utils/my_urls.dart';

class ChatRepository {
  CustomHttpClient http = CustomHttpClient();

  Future<dynamic> getMessages() async {
    try {
      var response =
          await http.post(Uri.parse('${MyUrls.serverUrl}/message_list'));
      final List<dynamic> chatsResponse = jsonDecode(response.body)['messages'];
      final List<Chat> chats = chatsResponse.map((json) {
        Map<String, dynamic>? userJson = json['from'];
        final chat = Chat.fromJson({
          "_id": json['chatId'],
          "user": userJson,
        });
        Message message = Message.fromJson(json);
        chat.messages.add(message);
        return chat;
      }).toList();
      chats.forEach((chat) {});
      return chats;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<Chat?> getSyncMessages(String? chatId) async {
    try {
      var response = await http.get(Uri.parse(
          '${MyUrls.serverUrl}/getChatData?limit=100&chatId=$chatId&pageNo=0'));

      List _list = jsonDecode(response.body)['messages'];
      Chat? chat;
      for (var i = 0; i < _list.length; i++) {
        final data = _list[i];
        Map<String, dynamic> json = data;
        Map<String, dynamic> userJson = json['from'];
        chat ??= Chat.fromJson({
          "_id": json['chatId'],
          "user": userJson,
        });
        Message message = Message.fromJson(json);
        if (json['from']['_id'] != json['to']['_id']) {
          chat.messages.add(message);
        }
      }
      return chat;
    } catch (err) {
      // throw CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
      return null;
    }
  }

  Future<dynamic> sendMessage(String to, String? name, String message,
      String customerId, String businessId) async {
    try {
      var response = await http.post(
        Uri.parse('${MyUrls.serverUrl}/message'),
        body: jsonEncode({
          "to": to,
          "name": name,
          "message": message,
          "customerId": customerId,
          "businessId": businessId,
        }),
      );
      final messageResponse =
      Map<String, dynamic>.from(
          jsonDecode(response.body));
      Message _message = Message.fromJson(
          messageResponse['message']);
      print(_message);
      return response;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<dynamic> declinePaymentRequest(Map<String, dynamic> requestId) async {
    try {
      var response = await http.post(
        Uri.parse('${baseUrl}payment/decline'),
        body: jsonEncode(requestId),
      );
      var map = jsonDecode(response.body);
      debugPrint('qwert');
      debugPrint('qwerty' + (map)['status'].toString());
      return (map)['status'];
    } catch (e) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<Map<String, dynamic>?> getTransactionDetails(
      String? transactionId) async {
    try {
      var url = 'transactions/$transactionId';
      var response = await postRequest(
      endpoint: url,
      headers: apiAuthHeaderWithOnlyToken(),
    );
      if(response.statusCode == 200){
      var map = jsonDecode(response.body);
      Map<String, dynamic> data = {
        "urbanledgerId": "${(map)['urbanledgerId']}",
        "transactionId": "${(map)['transactionId']}",
        "to": "${(map)['to']}",
        "toEmail": "${(map)['toEmail']}",
        "from": "${(map)['from']}",
        "fromEmail": "${(map)['fromEmail']}",
        "completed": "${(map)['completed']}",
        "paymentMethod": "${(map)['paymentMethod']}",
        "amount": (map)['amount'],
        "cardImage": "${(map)['cardImage']}",
        "endingWith": "${(map)['endingWith']}",
      };
      debugPrint(data.toString());
      return data;
      }
    } catch (e) {
      CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
    return null;
  }

  Future<dynamic> getChatByUsersIds(String userId) async {
    try {
      var response =
          await http.get(Uri.parse('${MyUrls.serverUrl}/chats/user/$userId'));
      final dynamic chatResponse = jsonDecode(response.body)['chat'];

      final Chat chat = Chat.fromJson(chatResponse);
      return chat;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<dynamic> readChat(String chatId) async {
    try {
      var response =
          await http.post(Uri.parse('${MyUrls.serverUrl}/$chatId/read'));
      final dynamic chatResponse = jsonDecode(response.body)['chat'];

      final Chat chat = Chat.fromJson(chatResponse);
      return chat;
    } catch (err) {
      return CustomError.fromJson({'error': true, 'errorMessage': 'Error'});
    }
  }

  Future<void> deleteMessage(String? messageId) async {
    try {
      await http.put(Uri.parse('${MyUrls.serverUrl}/message/$messageId'));
    } catch (err) {
      debugPrint("Error $err");
    }
  }
}
