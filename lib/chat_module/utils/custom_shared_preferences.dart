// import 'dart:convert';

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/user.dart';

class CustomSharedPreferences {
  static Future<dynamic> get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  static Future<bool> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<void> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<void> setDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static Future<void> setStringList(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  static Future<void> setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<bool> contains(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isContain = prefs.containsKey(key);
    return isContain;
  }

  static Future<User> getMyUser() async {
    final userString = await CustomSharedPreferences.get("user");
    // final User userString = new User(
    //     name: 'Kabir Khan',
    //     username: 'kabir.khan@gmail.com',
    //     id: '60427905fe472f7213e81f2c');
    // userString.id = "60427905fe472f7213e81f2c";
    // userString.name = "Kabir Khan";
    // userString.username = "kabir.khan@gmail.com";
    final userJson = jsonDecode(userString.toString());
    return User.fromJson(userJson);
    // return userString;
  }
}
