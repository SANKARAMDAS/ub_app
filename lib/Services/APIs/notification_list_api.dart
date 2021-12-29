


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:urbanledger/Models/notification_list_model.dart';
import 'package:urbanledger/Utility/app_constants.dart';
import 'package:urbanledger/Utility/app_methods.dart';

class NotificationListApi {
  NotificationListApi._();

  static final NotificationListApi notificationListApi = NotificationListApi._();

  Future<List<NotificationData>> getNotificationList() async {
    NotificationListModel? model;
    List<NotificationData> data=[];
    const url = "notification";
    print('$baseUrl$url');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$url'),
        headers: apiAuthHeaderWithOnlyToken(),
      );

      debugPrint('Check SUS' + jsonDecode(response.body).toString());

      model = notificationListModelFromJson(response.body);
      if(model != null){
        data = model.data!;
      }
  //insert to DB

      return data;
    } catch (e) {
      //return Future.error('$e');
      print(e);
      return data;
    }
  }

  /*Future<bool> clearNotifications() async {
    const url = "notification";
    print('$baseUrl$url');
    Map<String,dynamic> responseData={};
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$url'),
        headers: apiAuthHeaderWithOnlyToken(),
      );

      debugPrint('Check SUS' + jsonDecode(response.body).toString());

      responseData = jsonDecode(response.body);
      //insert to DB

      return true;
    } catch (e) {
      //return Future.error('$e');
      print(e);
      return false;
    }
  }*/

  Future<bool> markAllAsRead(List<String> ids) async {
    const url = "notification";
    print('$baseUrl$url');
    Map<String,dynamic> responseData={};
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl$url'),
        headers: apiAuthHeaderWithOnlyToken(),
          body: jsonEncode({"id":ids})
      );

      debugPrint('Check SUS' + jsonDecode(response.body).toString());

      responseData = jsonDecode(response.body);
      //insert to DB

      return true;
    } catch (e) {
      //return Future.error('$e');
      print(e);
      return false;
    }
  }



  Future<bool> deleteNotifications(List<String> ids) async {
   // List<NotificationData> data=[];
    const url = "notification";
    print('$baseUrl$url');
    Map<String,dynamic> responseData={};
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$url'),
        headers: apiAuthHeaderWithOnlyToken(),
        body: jsonEncode({"id":ids})
      );

      debugPrint('Check SUS' + jsonDecode(response.body).toString());
      responseData = jsonDecode(response.body);


      //insert to DB

      return true;
    } catch (e) {
      //return Future.error('$e');
      print(e);
      return false;
    }
  }


}