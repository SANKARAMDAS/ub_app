import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';

class CustomHttpClient extends http.BaseClient {
  http.Client _httpClient = new http.Client();

  final Map<String, String> defaultHeaders = {
    "Content-Type": "application/json"
  };

  @override
//   Future<http.StreamedResponse> send(http.BaseRequest request) async {
  //  final String token = await CustomSharedPreferences.get('chat_token');
//     final String token =
//         "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MDRhMDFkNGQzMGU1MDE3NGFlZjY5YTAiLCJpYXQiOjE2MTU5NzI4NjF9.w5gFlA_aaQ9L9hG61i9ZrlzXqbguTH7K9nKD7wnczZg";
//     if (token != null) {
//       defaultHeaders['Authorization'] = "Bearer $token";
//     }
//     request.headers.addAll(defaultHeaders);
//     return _httpClient.send(request);
//   }
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final String? token = await (CustomSharedPreferences.get('chat_token'));
    debugPrint(token);
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MDQ3MTNhNTIzM2JkZjE5YmZjMmE2OGYiLCJpYXQiOjE2MTU5NzMyMDB9.Bv-uKYsQ9ij7sXnFC-shWaG20r-O6ZGmCNKSo2fz6Co";
    if (token != null) {
      defaultHeaders['Authorization'] = "Bearer $token";
    }
    request.headers.addAll(defaultHeaders);
    return _httpClient.send(request);
  }
}
